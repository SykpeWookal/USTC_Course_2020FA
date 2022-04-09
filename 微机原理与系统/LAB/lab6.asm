ASSUME  CS:CODE, DS:DATA

.387

DATA       SEGMENT

TES    DB 0D9H,0FEH
ERRORSTRING  DB 'Error: x<0! $',0
XINPUT   DB  20  DUP(0)       ;ASCIIZ串
A1INPUT DB  20  DUP(0)
A2INPUT DB  20  DUP(0)
A3INPUT DB  20  DUP(0)
TXTLEN           DB   1  ;输入长度
XVALUE        DD  ?
A1VALUE      DD  ?
A2VALUE      DD  ?
A3VALUE      DD  ?
PET1             DB  5  DUP(0)
BUF1              DD  ?
BUF2	      DD  ?
PET2            DB 5 DUP(0)
RES              DD  ?
PET3            DB 5 DUP(0)
INTDD         DD  ?
DECIDD       DD  ?

TEMP        DW  ?
TOL             DD  10000.0           ;取小数的位数，此时取4位
FLAGNEG   DB   0   ;标记读取到的是否为负
FNEG  DD  -1.0
F0       DD   0.0
F1       DD   1.0
F2       DD   2.0
F3       DD   3.0
F4       DD   4.0
F5       DD   5.0
F6       DD   6.0
F7       DD   7.0
F8       DD   8.0
F9       DD   9.0
FA     DD   10.0
FLAGINT   DB  1        ;当前为整数标记，用于区分读取的是整数或是小数部分

XSTRING   DB  'Please Input x:$'
A1STRING DB  'Please Input a1:$'
A2STRING DB  'Please Input a2:$'
A3STRING DB  'Please Input a3:$'
FLAGPRINTDECI   DB  0
HFLAG  DB  0                              ;=1时表示千位存在且百位为0
DFLAG     DB  0                           ;=1时表示千位或百位存在且十位为0

DATA       ENDS   



CODE   SEGMENT   'CODE'

START: MOV   AX,DATA      ;初始化DS
            MOV   DS,AX

	LEA     DX,XSTRING   ;输出屏幕提示串
	MOV  AH,9
	INT     21H
          ;接下来扫入x
	LEA    SI, XINPUT
	CALL  INPUTN
	LEA    SI, XINPUT
	.IF BYTE PTR [SI]==2DH    ;x<0直接报错
		JMP ERRORBB
	.ENDIF
          ;将其存入XVALUE，上面已经确保x>0
	CALL  INPUTFUNCTION
	FST    XVALUE
         ;输入A1
	LEA     DX,A1STRING   ;输出屏幕提示串
	MOV  AH,9
	INT     21H
	LEA    SI, A1INPUT
	CALL  INPUTN
	LEA    SI, A1INPUT
	CALL  INPUTFUNCTION
	FST    A1VALUE
         ;输入A2
	LEA     DX,A2STRING   ;输出屏幕提示串
	MOV  AH,9
	INT     21H
	LEA    SI, A2INPUT
	CALL  INPUTN
	LEA    SI, A2INPUT
	CALL  INPUTFUNCTION
	FST    A2VALUE
         ;输入A3
	LEA     DX,A3STRING   ;输出屏幕提示串
	MOV  AH,9
	INT     21H
	LEA    SI, A3INPUT
	CALL  INPUTN
	LEA    SI, A3INPUT
	CALL  INPUTFUNCTION
	FST    A3VALUE


  ;逻辑处理，计算函数值
           ;先处理log2，ST1中应该存放A2的值
	FLD    A2VALUE
	FLD    XVALUE
	FYL2X
	FSTP  BUF1
           ;再计算A1\sqrt x
	FLD   XVALUE
	FSQRT
	FMUL  A1VALUE
	FADD  BUF1
	FSTP    BUF1
           ;最后计算A3sinx
	FLD  XVALUE
	FSIN
	FMUL A3VALUE
	FADD BUF1
        ;计算完毕，结果存储在RES中
	FSTP   RES 

 ;打印结果
		FINIT
	
	FSTCW  TEMP
	MOV     AX,TEMP
	OR        AX,0C00H    ;设置舍入误差为直接截断
	MOV     TEMP, AX
	FLDCW  TEMP
	
	FLD   RES    ;装载待输出单精度浮点数
	FTST
	FSTSW   TEMP	
	MOV     AX, TEMP
	AND      AX, 4500H
	.IF AX==0100H
		MOV  DL, 2DH
		MOV  AH,02H
		INT     21H
		FABS
	.ENDIF		

	FRNDINT			;舍入为整数
	FST   INTDD
	FIST    BUF1

	FLD    RES		;重新压栈，求小数部分
	FABS			;此时直接取绝对值
	FSUB  INTDD
	FMUL TOL

	FRNDINT			;舍入为整数
	FST   DECIDD
	FIST    BUF2
	
	LEA   DI,BUF1
	MOV  AH, [DI+1]
	MOV  AL, [DI]
	CALL PRINTN

	MOV  DL, 2EH
	MOV  AH,02H
	INT     21H
	
	MOV FLAGPRINTDECI, 1
	LEA   DI,BUF2
	MOV  AH, [DI+1]
	MOV  AL, [DI]
	CALL PRINTN
	
         MOV AX, 4C00H
         INT 21H

ERRORBB:
	LEA     DX,ERRORSTRING
	MOV  AH,9
	INT     21H
	MOV  AX, 4C00H
	INT     21H


 INPUTFUNCTION   PROC   NEAR  ;输入数据子函数
	XOR   CX,CX
	MOV  CL,TXTLEN 	    ;清空CX并存入循环次数
	FINIT
	FLD  F0                         ;栈顶初始化为0
	MOV  FLAGINT, 1
	MOV  FLAGNEG, 0
	.IF BYTE PTR [SI]==2DH
		MOV  FLAGNEG, 1
		INC    SI
		DEC   CX
	.ENDIF
  SCANFXINT:
	.IF BYTE PTR [SI] == 2EH      ;小数点
		MOV  FLAGINT, 0
		INC     SI
		DEC    CX
		JMP   SCANFXDECI
	.ENDIF
	.IF BYTE PTR FLAGINT == 1    ;整数部分
			FMUL  FA
			;FST RES
		.IF BYTE PTR [SI]==31H	
			FADD  F1
			;FST RES
		.ELSEIF BYTE PTR [SI]==32H
			FADD  F2
			;FST RES
		.ELSEIF BYTE PTR [SI]==33H
			FADD  F3
			;FST RES
		.ELSEIF BYTE PTR [SI]==34H
			FADD  F4
			FST RES
                JMP NOLABELX
        LABELFORXLOOP:
	JMP SCANFXINT
        NOLABELX:
		.ELSEIF BYTE PTR [SI]==35H
			FADD  F5
		.ELSEIF BYTE PTR [SI]==36H
			FADD  F6
			;FST RES
		.ELSEIF BYTE PTR [SI]==37H
			FADD  F7
		.ELSEIF BYTE PTR [SI]==38H
			FADD  F8
		.ELSEIF BYTE PTR [SI]==39H
			FADD  F9
			;FST RES
		.ENDIF
	.ENDIF
	INC     SI
  LOOP LABELFORXLOOP

  SCANFXDECI:
		FST RES
	.IF FLAGINT == 1
		JMP NEXTX
	.ENDIF
	FLD  F1                          ;把1.0压入栈
	MOV  AX,CX                  ;把剩余长度取出存入AX
	.WHILE AX>0
		FMUL FA
		DEC    AX
	.ENDW
		FST RES
	FLD  F0
         DECIINT:
			FMUL  FA
			FST RES
		.IF BYTE PTR [SI]==31H	
			FADD  F1
			FST RES
		.ELSEIF BYTE PTR [SI]==32H
			FADD  F2
			FST RES
		.ELSEIF BYTE PTR [SI]==33H
			FADD  F3
			FST RES
		.ELSEIF BYTE PTR [SI]==34H
			FADD  F4
                JMP NOLABELXDECI
        LABELFORDECIINT:
	JMP DECIINT
        NOLABELXDECI:
		.ELSEIF BYTE PTR [SI]==35H
			FADD  F5
		.ELSEIF BYTE PTR [SI]==36H
			FADD  F6
			FST RES
		.ELSEIF BYTE PTR [SI]==37H
			FADD  F7
		.ELSEIF BYTE PTR [SI]==38H
			FADD  F8
		.ELSEIF BYTE PTR [SI]==39H
			FADD  F9
			FST RES
		.ENDIF
	INC     SI
        LOOP LABELFORDECIINT
        
	FSTP   BUF1
	FSTP   BUF2
	FLD    BUF1
	FDIV  BUF2
	FSTP  BUF1
	FADD BUF1
        NEXTX:
	.IF FLAGNEG==1
		FMUL FNEG
	.ENDIF
	FST    RES

	RET
   INPUTFUNCTION   ENDP

PRINTN   PROC  NEAR   ;打印函数，AX存储待打印数
 PRINTPOS:
    XOR    DX,DX  ;将DX清零，做32位/16位除法
    MOV  BX,1000
    DIV     BX      ;AX/1000，商存在AX中，余数存在DX中
    MOV   BX,DX  ;把下一步的操作数暂存入BX
    .IF FLAGPRINTDECI==1
       MOV  HFLAG,1
       MOV  DFLAG,1        ;百位和十位标志=1
       ADD   AL,30H
       MOV  DL,AL
       MOV  AH,02H
       INT     21H
       JMP    NOTHOUSAND
    .ENDIF
    CMP   AX,0     ;千位不存在
    JZ       NOTHOUSAND
       MOV  HFLAG,1
       MOV  DFLAG,1        ;百位和十位标志=1
       ADD   AL,30H
       MOV  DL,AL
       MOV  AH,02H
       INT     21H

 NOTHOUSAND:     ;求百位

     XOR    DX,DX  ;将DX清零，做32位/16位除法
     MOV   AX,BX
     MOV   BX,100
     DIV     BX      ;AX/100，商存在AX中，余数存在DX中
     MOV   BX,DX  ;把下一步的操作数暂存入BX

     CMP   AX,0
     JZ       IFPRINT0FORHUN
       MOV   DFLAG,1
       ADD   AL,30H
       MOV  DL,AL
       MOV  AH,02H
       INT     21H
       MOV  AH,1
       JMP   NOHUNDRED
   IFPRINT0FORHUN:
     CMP  BYTE PTR HFLAG,1
     JNZ   NOHUNDRED   ;千位百位都为0，直接打印十位.
        MOV  DL,30H
        MOV  AH,02H
        INT     21H
     JMP   NOHUNDRED

 NOHUNDRED:
     XOR    DX,DX  ;将DX清零，做32位/16位除法
     MOV   AX,BX
     MOV   BX,10
     DIV     BX      ;AX/10，商存在AX中，余数存在DX中
     MOV   BX,DX  ;把下一步的操作数暂存入BX
     CMP   AX,0
     JZ       IFPRINT0FORDEC
       ADD   AL,30H
       MOV  DL,AL
       MOV  AH,02H
       INT     21H
       JMP   NODECADE
  IFPRINT0FORDEC:
     CMP   DFLAG,1  
     JNZ     NODECADE
     MOV  DL,30H
     MOV  AH,02H
     INT     21H       ;打印百位0

 NODECADE:
     ADD   BL,30H
     MOV  DL,BL
     MOV  AH,02H
     INT     21H

  MOV  HFLAG,0
  MOV  DFLAG,0

	RET
PRINTN  ENDP

INPUTN   PROC  NEAR
	MOV  TXTLEN,0
;从键盘接收字符，写入[SI]中
    LOP1: MOV AH,1             ;INT 21H的1号功能
          INT    21H              ;从键盘接收一个字符
          CMP  AL,0DH         ;判断是否为结束的回车符
          JZ      ENDLOP1     ;是，结束
          MOV [SI],AL          ;不是，保存
          INC    SI
          INC    TXTLEN
          JMP   LOP1              ;保存成功，返回继续接收字符
    ENDLOP1:
	RET
INPUTN  ENDP


CODE  ENDS

END   START