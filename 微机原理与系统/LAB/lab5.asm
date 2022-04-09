ASSUME  CS:CODE, DS:DATA

DATA       SEGMENT
BUFFER      DB   ?    		     ;一个字节的写缓冲区      
READBUF   DB 100 DUP (0)	     ;保存从键盘读取到的数据
TXTLEN      DW 0                          ;保存从键盘读取入的BYTE数
CUL            DB 100 DUP (0)         ;保存后缀表达式
SYMSTACK        DB 30   DUP (0)         ;符号栈
LAST          DB  0		    ;用于产生空格分隔数字，记录上次读到的是否为数字
FLAGNEG  DB  0       ;记录当前数字是否为负
RES            DB  100 DUP (0)       ;用于计算最后的结果
LASTCUL    DW  ?
HFLAG  DB  0                              ;=1时表示千位存在且百位为0
DFLAG     DB  0                           ;=1时表示千位或百位存在且十位为0
DATA       ENDS   
 

CODE   SEGMENT   'CODE'

START: MOV   AX,DATA      ;初始化DS
            MOV   DS,AX
 
;初始化SI，利用源地址指针寄存器将键盘内容存入READBUF
          LEA  SI, READBUF
 
;从键盘接收字符，写入READBUF中
LOP1: MOV AH,1             ;INT 21H的1号功能
          INT    21H              ;从键盘接收一个字符
          CMP  AL,0DH         ;判断是否为结束的回车符
          JZ      ENDLOP1     ;是，结束
          MOV [SI],AL          ;不是，保存到缓冲区READBUF中
          INC    SI
          INC    TXTLEN
          JMP   LOP1              ;保存成功，返回继续接收字符

ENDLOP1:
	LEA  SI, READBUF
	LEA  DI, CUL
	LEA  BX, SYMSTACK
	MOV  CX,TXTLEN     ;设置循环次数，对每一个输入值作转换


;将READBUF中内容转换为后缀表达式，以ASCII方式存储在CUL内
CONVERT:               ;ASCII值：( 28    ) 29   + 2B   - 2D
	CMP BYTE PTR [SI], 30H    ;简单表达式中大于30H的只有数字
	JS      SYM          ;处理符号
	  ;数字需要做的操作
	  CMP   LAST, 30H	;产生空格
	  JNS   NOSPACE
	        MOV BYTE PTR [DI], 20H
	        INC     DI
	        CMP  FLAGNEG, 0
	        JZ      NOSPACE ;跳转即为正数
	                MOV  AL, [SI]         ;处理负数字，+20H
		ADD   AL,20H
	  	MOV  [DI], AL
	   	INC     SI
	   	INC     DI
	   	MOV   LAST, AL
		MOV   FLAGNEG, 0
	   	DEC   CX
	   	CMP  CX,0    ;处理数字，直接放入
	   	JNZ   CONVERT
	   	JZ      LABELFORPOPREST
            NOSPACE:
	   MOV  AL, [SI]         ;处理数字，直接放入
	   MOV  [DI], AL
	   INC     SI
	   INC     DI
	   MOV   LAST, AL
	   DEC   CX
	   CMP  CX,0    ;处理数字，直接放入
	   JNZ   CONVERT
	   JZ      LABELFORPOPREST
  SYM:
	CMP BYTE PTR [SI], 2DH
	JS      NSUB
	    CMP  LAST, 0
	    JNZ   LSUB  ;跳转表示-号解释为减，不跳转解释为负
	           MOV  FLAGNEG, 1   ;标记为负
	           INC     SI
	           DEC   CX
	           CMP  CX,0   
	           JNZ   CONVERT
	           JZ      LABELFORPOPREST
	 ;减号或负号-需要做的操作. 由于加减运算优先级相同，需要比较栈顶元素
            LSUB:
	 CMP BYTE PTR [BX-1], 2BH      ;栈顶为+或-，出栈并将-压入栈
	 JS     PUSHSUB                         ;变号说明不是+-号
	       MOV AL, [BX-1]
                       MOV BYTE PTR [DI], AL
	       INC     DI
	       DEC    BX
	       JMP    LSUB

          PUSHSUB:
	   MOV  BYTE PTR [BX], 2DH
	   INC     BX
	   INC     SI
	   MOV   LAST, 0
	   DEC   CX
	   CMP  CX,0   
	   JNZ   CONVERT
	   JZ      POPREST
				LABELFORJUMP:
					JMP  CONVERT
				LABELFORPOPREST:
					JMP  POPREST
    NSUB:
	CMP  BYTE PTR [SI],  2BH    ;加号+
	JS      LBRACKET   ;以下先处理左括号后处理右括号
	 ;加号+需要的操作，由于加减运算优先级相同，需要比较栈顶元素
          LADD:
	 CMP BYTE PTR [BX-1], 2BH      ;栈顶为+或-，出栈并将-压入栈
	 JS     PUSHADD                         ;变号说明不是+-号
	       MOV AL, [BX-1]
                       MOV BYTE PTR [DI], AL
	       INC     DI
	       DEC    BX
	       JMP    LADD
 

          PUSHADD:
	   MOV  BYTE PTR [BX], 2BH
	   INC     BX
	   INC     SI
	   MOV   LAST, 0
	   DEC   CX
	   CMP  CX,0   
	   JNZ   LABELFORJUMP
	   JZ      POPREST

    LBRACKET:
	CMP BYTE PTR [SI], 29H
	JNS    RBRACKET   ;跳转以后处理右括号
	 ;处理左括号，直接入栈,左括号优先级最高
	   MOV BYTE PTR [BX], 28H
	   INC     BX
	   INC     SI
	   MOV   LAST, 0
	   DEC   CX
	   CMP  CX,0   
	   JNZ   LABELFORJUMP
	   JZ      POPREST

    RBRACKET:
	DEC  BX
	MOV AL, [BX]
	CMP  AL, 28H
	JZ      POPSTOP
	   MOV  [DI], AL
	   INC     DI
	   JMP    RBRACKET

        POPSTOP:      ;遇到左括号，停止出栈
	MOV  BYTE PTR [BX], 0
	INC     SI
	MOV   LAST, 0
	   DEC   CX
	   CMP  CX,0   
	   JNZ   LABELFORJUMP
	   JZ      POPREST

;将剩余部分全部出栈
  POPREST:
	LEA  DX,SYMSTACK
	CMP BX,DX
	JZ     POPEND
  POPREST1:
	DEC  BX
	CMP BX,DX
	JZ     POPEND
	   MOV AL, [BX]
	   MOV  [DI], AL
	   INC     DI
	   JMP    POPREST1

  POPEND:
	CMP BYTE PTR [BX],0
	JZ      FIRSTEND
	MOV AL, [BX]
	MOV  [DI], AL
	INC     DI


FIRSTEND:
	MOV  LASTCUL, DI



;接下来将其回显至屏幕
          MOV  CX,50
          LEA     SI,CUL
NEXT:     
          MOV DL,[SI]
          MOV AH,2
          INT    21H
          INC    SI
LOOP NEXT 
          MOV  DL, 0DH    ;回车     
          MOV  AH, 2           
          INT  21H            
          MOV  DL, 0AH    ;换行  
          INT  21H


	LEA SI,RES   ;SI记录结果栈RES
	LEA DI,CUL  ;DI记录后缀表达式串
	XOR AX,AX

;计算结果
CALCULATE:
	CMP DI,LASTCUL
	JZ     LABELFORPRINT  ;DI已到最后，直接出结果

	CMP BYTE PTR [DI],0	
	JNZ  NO0
	    INC    DI
	   JMP   CALCULATE
	
   NO0:
	CMP BYTE PTR [DI],30H  ;和数字比较，如果不是数字将之前的数压栈
	JS      NONUM
	   MOV  CL, [DI]
	   CMP   CL,50H
	   JS       POS
	        MOV   CH,0
	        SUB    CL, 50H   ;变为数值
	        MOV BYTE PTR FLAGNEG, 1
	        MOV  DX,10
	        MUL   DX
	        ADD   AX,CX
	        INC    DI
	        JMP   CALCULATE
           POS:
	   SUB    CL, 30H   ;变为数值
	   MOV  DX,10
	   MUL   DX
	   ADD   AL,CL
	   INC    DI
	   JMP   CALCULATE
				LABELFORPRINT:
					JMP PRINTOUT
        NONUM:
	CMP BYTE PTR [DI-1], 30H
	JS         NONEWNUM
	  CMP  BYTE PTR FLAGNEG ,1
	  JNZ    CPOS
	      NEG  AX
	      MOV BYTE PTR FLAGNEG ,0
	CPOS:
	  MOV  [SI], AL
	  MOV  [SI+1], AH
	  INC     SI
	  INC     SI
           NONEWNUM:
	  XOR    AX, AX
	CMP BYTE PTR [DI], 20H
	JNZ    ADDORSUB
	    INC  DI
	    JMP CALCULATE
           ADDORSUB:
	   MOV  AH, [SI-3]
	   MOV  AL, [SI-4]
	   MOV  BH, [SI-1]
	   MOV  BL, [SI-2]
	   DEC SI
	   DEC SI
	CMP BYTE PTR [DI], 2BH
	JNZ    SUBOP
	   ADD  AX, BX
	   MOV [SI-1], AH
	   MOV [SI-2], AL
	   INC   DI
	   JMP CALCULATE
           SUBOP:
	   SUB  AX, BX
	   MOV [SI-1], AH
	   MOV [SI-2], AL
	   INC   DI
	   JMP CALCULATE

;打印最终结果
PRINTOUT:
	MOV  AH, [SI-1]
	MOV  AL, [SI-2]
	PUSH  AX
	CMP   AX,0
	JNS     PRINTPOS  ;打印正数
	    ;跳转不成功，打印负数    
     	    MOV  DL,2DH     ;负号
     	    MOV  AH,02H     ;2号功能，打印出DL中数据对应的ASCII字符
    	    INT     21H          ;打印负号
    	    POP    AX
     	    NEG   AX             ;再将其转换为正数，打印正数

         PRINTPOS:
	XOR    DX,DX  ;将DX清零，做32位/16位除法
    	MOV  BX,1000
   	 DIV     BX      ;AX/1000，商存在AX中，余数存在DX中
   	 MOV   BX,DX  ;把下一步的操作数暂存入BX
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


         MOV AX, 4C00H
         INT 21H

CODE  ENDS

END   START