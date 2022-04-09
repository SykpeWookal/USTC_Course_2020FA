ASSUME  DS:DATA, CS:CODE 

DATA  SEGMENT       
 INPUTN  DB ?
 INPUTNN  DB ?
 NUM  DB  200 DUP(0)
DATA ENDS
 

CODE  SEGMENT  
START:
  MOV  AX, DATA 
  MOV  DS, AX 

  MOV   AH,1           ;INT 21H的1号功能
  INT   21H               ;从键盘接收一个字符

  SUB  AL,30H          ;将接收到的ASCII字符转为数字
  MOV  INPUTN,AL  ;将N存入数据段中
  INC AL
  MOV INPUTNN,AL    ;存放N+1

  MOV  DL, 0DH    ;回车     
  MOV  AH, 2           
  INT  21H            
  MOV  DL, 0AH    ;换行  
  INT  21H           
  
  LEA  SI, NUM      ;使用SI寄存器寻址NUM
  MOV  CL, 1
 
  XOR   AX,AX       ;将AX清零
  MOV  AL,INPUTN  
  MUL   AL            ;此时AX=N^2
  INC     AX           ;此时AX=N^2+1

LOOP1:               ;生成数组,利用CX自增依次给[SI++]赋值
  MOV  [SI], CX  
  INC  SI  
  INC  CX 
  CMP  CX, AX     ;While(CX<N^2+1)
JNZ  LOOP1
 
  MOV  CX, 1       ;重新给CX赋值，此后CX存储当前行数  
  MOV  SI, 0        ;SI=0，指向NUM第一个元素
 
LOOP2: 
  MOV  BX, 0       ;BX存放了当前列数，每当换行时BX=0
 
LOOP3:
  MOV  AL, NUM[SI + BX] ;索引数组元素
  MOV  AH, 0 
  MOV  DL, 10   
  DIV  DL 
  MOV  DL, AL 
  ADD   DL, 30H    ;转化成ascii码
  MOV  DH, AH 
  MOV  AH, 2      ;设置INT输出DL中字符
  CMP   DL, 30H    
  JZ   ZERO       ;十位为0则不输出
  INT  21H        ;输出十位

ZERO:  
  MOV  DL, DH 
  ADD  DL, 30H  
  INT  21H        ;输出个位
  MOV  DL, 20H 
  INT  21H
 
 
  INC  BX           
  CMP  BX, CX        
  JNZ  LOOP3        
 
  MOV  DL, 0DH    ;回车     
  MOV  AH, 2           
  INT  21H            
  MOV  DL, 0AH    ;换行  
  INT  21H           
 
  XOR  AX,AX
  MOV AL,INPUTN
  ADD  SI, AX           ;SI=SI+N
  INC  CX                 ;计算行数，同时也是下一次循环每行的列数     
  MOV AL,INPUTNN
  CMP  CX, AX         ;N+1
  JNZ  LOOP2
 
               
  MOV  AX, 4C00H    ;设置INT结束      
  INT  21H  
                 
   CODE  ENDS
END  START
 