ASSUME  CS:CODE, DS:DATA

DATA       SEGMENT
FILENAME  DB   'input3.txt',0       ;ASCIIZ串
HANDLE     DW  ?                        ;保存句柄单元
READBUF   DB 100 DUP (0)        ;用于存储读取文件得到的ASCII串
NUM          DW 100 DUP (0)       ;用于存储转换后的数值
TXTLEN      DW ?                         ;记录读取到的ASCII字符总数
FLAG          DB  ?                         ;记录是否为负数，读取ASCII文件时使用
NUMCOUNTER   DB  0                ;记录读取到的数字个数
HFLAG  DB  0                              ;=1时表示千位存在且百位为0
DFLAG     DB  0                           ;=1时表示千位或百位存在且十位为0
DATA       ENDS
 

CODE   SEGMENT   'CODE'

START: MOV   AX,DATA      ;初始化DS
            MOV   DS,AX
 
;读取文件
READ:
  ;打开文件
          MOV   AH, 3DH
          LEA   DX,FILENAME
          MOV   AL, 0
          INT      21H
          MOV   HANDLE,AX     ;打开文件
  ;读文件
          MOV   BX, HANDLE
          MOV   CX, 1000
          LEA      DX, READBUF
          MOV   AH, 3FH
          INT      21H
          MOV   TXTLEN, AX     ;记录实际读取的字节数
;接下来将其回显至屏幕
          MOV  CX,TXTLEN
          LEA     SI,READBUF
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
;关闭文件
          MOV   AH, 3EH        ;INT 21H的功能3EH，关闭文件
          MOV   BX, HANDLE     ;BX＝文件句柄
          INT   21H                       ;关闭文件


;将READBUF中的ASCII码转换成数字
         MOV  CX,TXTLEN
         INC     CX
         LEA     SI,READBUF
         LEA     DI,NUM
         MOV  BX, 0     ;存放当前数值，读到空格回车等将BX赋给[DI]
         MOV  AL,0      ;默认为正数
         MOV  FLAG,AL

CONVERT:
LOOP1:   
    MOV DL,[SI]     ;把读到的ASCII字符码转移到DL中
    CMP DL,20H     ;比较空格
    JZ  NEXTNUM
    CMP DL,13       ;比较回车
    JZ  NEXTNUM
    CMP DL,0       ;最后一个数字
    JZ  NEXTNUM

    ;转换开始
    CMP  DL,2DH  ;负号，-
    JNZ   POSNUM
    MOV  AL,1
    MOV  FLAG,AL
    INC    SI
    JMP   CONTINUE
 
  POSNUM:
    PUSH DX
    MOV AX,10   ;10进制乘数，16位乘法
    MUL  BX        ;16位乘法
    POP  DX         ;16位乘法会改变DX，用push，pop保留它
    MOV BX,AX   ;只要低16位即可
    SUB DL,30H  ;从ASCII变回数值 
    XOR  AX,AX
    MOV AL,DL
    ADD  BX,AX
    INC   SI
    JMP  CONTINUE

NEXTNUM:
    ADD  BYTE PTR NUMCOUNTER,1
    CMP  BYTE PTR FLAG,1
    JNZ   POS
                               ;OR    BX,1000000000000000B ;求负数原码
    NEG  BX              ;求补码
    MOV AL,0
    MOV FLAG,AL     ;将符号标志位置0
  POS:
    MOV [DI],BX       ;将内容存到num中
    MOV BX,0 
    INC    SI
    INC    DI
    INC    DI
CONTINUE:
LOOP CONVERT

;排序
    
    LEA    SI, NUM  ;指向NUM的第一个字节
    MOV  CL,NUMCOUNTER
    DEC   DI            ;指向NUM最高地址，即最后一个数字的高位字节    
    DEC   DI            ;指向最后一个数字的低位字节
    MOV DX,DI

SORT: 
    CMP  DI,SI
    JZ      NEXTLOOP

    DEC   DI
    DEC   DI    ;指向上一个数字的低字节，上一条比较指令保证这个数字存在
    MOV AH,[DI+3]
    MOV AL, [DI+2]
    MOV BH,[DI+1]
    MOV BL, [DI]

    CMP  AX,BX
    JS     JOF0
    JNS  JOF1
 JOF0:
      JNO CHANGE
      JMP NOCHANGE
 JOF1:
      JO    CHANGE
      JMP NOCHANGE
 CHANGE:
      MOV [DI+3],BH
      MOV [DI+2],BL
      MOV [DI+1],AH
      MOV [DI],    AL
 NOCHANGE:
    JMP SORT
 NEXTLOOP:
    MOV DI,DX
LOOP SORT 


;将排序完的数字打印在屏幕上
    MOV  CL,NUMCOUNTER
PRINT:
    MOV  AH,[SI+1]
    MOV  AL, [SI]     ;AX中存储当前要输出的数
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
 
 LABELFORLOOP:
     JMP  PRINT
 
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

  ADD   SI,2
  MOV  HFLAG,0
  MOV  DFLAG,0
    MOV  DL, 20H    ;空格    
    MOV  AH, 2           
    INT  21H        
LOOP LABELFORLOOP


         MOV AX, 4C00H
         INT 21H

CODE  ENDS

END   START