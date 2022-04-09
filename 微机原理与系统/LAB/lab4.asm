ASSUME  CS:CODE, DS:DATA

DATA       SEGMENT
BUF   DB 3 DUP (0)
N       DB ?    ;存储输入的N
VALUE   DB 1000 DUP (0)   ;用于存储阶乘结果
DATA       ENDS   


CODE   SEGMENT   'CODE'

START: MOV   AX,DATA      ;初始化DS
            MOV   DS,AX
 

;从键盘接收字符
          LEA      SI,BUF
          LEA      DI,BUF
LOP1: MOV   AH,1           ;INT 21H的1号功能
          INT   21H               ;从键盘接收一个字符
          CMP  AL,0DH         ;判断是否为结束的回车符
          JZ      NEXT             ;是，结束
          MOV  [SI],AL         ;不是，保存到缓冲区BUF中
          INC    SI
          JMP    LOP1

;将其转换为数值
NEXT:
          MOV  BL,[DI+1]
          MOV  BH,[DI]
          CMP   BL,0
          JZ       LESSTHAN10
           ;两位数
           XOR  AX,AX
           MOV AL,BH
           SUB   AL,30H
           MOV  DL,10
           MUL   DL
           SUB   BL,30H
           ADD  AL,BL
           MOV  N,AL
          JMP     MAIN          

  LESSTHAN10:    ;没有十位的情况
          XOR  AX,AX
          MOV AL,BH
          SUB   AL,30H
          MOV N,AL
          

;以上处理完输入部分，接下来计算阶乘
MAIN:
         LEA      SI,VALUE
         LEA      DI,VALUE
         INC      DI           ;DI指向最高位的上一位，SI指向最低位
         MOV  BYTE PTR [SI],1
         XOR    CX,CX
         MOV   CL,N
    CALLN:
         CALL   FACTORIAL
    LOOP CALLN
         
    PRINT:   ;将结果以十进制形式打印     
         DEC   DI        
         MOV DL,[DI]
         ADD  DL,30H
         MOV AH,02H
         INT    21H
         CMP  DI,SI
         JNZ   PRINT
         

         MOV AX, 4C00H
         INT 21H


 FACTORIAL   PROC    NEAR    ;阶乘计算子函数
        MOV  BX,SI   ;BX作为循环变量
        MOV  AL,[BX]
        MUL   CL
        MOV  [BX],AL
  MULBIT:
        INC     BX
        CMP   BX,DI
        JZ       CARRY
           MOV  AL,[BX]
           MUL   CL
           MOV  [BX],AL          ;将其存回内存
           JMP    MULBIT

   CARRY:     ;统一处理进位
        MOV    BX,SI
     CARRYLOP:
        CMP  BYTE PTR  [BX],10
        JC      NOCHANGE
           XOR    AX,AX
           MOV  AL,[BX]
           MOV  DL,10
           DIV     DL
           MOV  [BX],AH
           ADD   [BX+1],AL
           CMP   BYTE PTR [DI],0
           JZ       NOCHANGE
              INC DI     
    NOCHANGE:
        INC   BX
        CMP  BX,DI
        JNZ   CARRYLOP

        RET
 FACTORIAL  ENDP

CODE  ENDS

END   START