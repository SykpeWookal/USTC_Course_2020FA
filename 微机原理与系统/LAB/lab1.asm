ASSUME  CS:CODE, DS:DATA

DATA       SEGMENT
FILENAME  DB   'input1.txt',0       ;ASCIIZ串
BUFFER      DB   ?    		     ;一个字节的写缓冲区      
HANDLE     DW  ?                        ;保存句柄单元
READBUF   DB 2000 DUP (0)		
TXTLEN      DW ?     
DATA       ENDS   
 

CODE   SEGMENT   'CODE'

START: MOV   AX,DATA      ;初始化DS
            MOV   DS,AX
 
;创建文件
         MOV AH,3CH          ;INT 21H的3CH功能，创建文件
         MOV CX,0  	              ;设置文件属性，CX=0为普通文件
         LEA   DX,FILENAME    ;DX=ASCIIZ串的首地址
         INT   21H                      ;创建文件
         MOV   HANDLE,AX    ;创建成功，保存文件句柄  
 
;从键盘接收字符，写入文件中
LOP1: MOV   AH,1           ;INT 21H的1号功能
          INT   21H               ;从键盘接收一个字符
          CMP  AL,0DH         ;判断是否为结束的回车符
          JZ  READ                ;是，结束
          MOV  BUFFER,AL   ;不是，保存到写文件缓冲区BUFFER中
;将缓冲区中内容写到文件中
          MOV   AH, 40H      ;INT 21H的40H功能，写文件
          MOV   BX, HANDLE  ;BX=文件句柄
          MOV   CX, 1           ;CX=要写入的字节数
          LEA   DX, BUFFER   ;DX=写缓冲区首地址
          INT   21H                ;把缓冲区内容写入文件
          JMP  LOP1              ;写成功，返回继续接收字符
 

;读取文件并将其转换
READ:
  ;先将刚才的文件关闭
          MOV   AH, 3EH        ;INT 21H的功能3EH，关闭文件
          MOV   BX, HANDLE     ;BX＝文件句柄
          INT   21H                       ;关闭文件 
  ;重新打开文件
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
          MOV   TXTLEN, AX ;记录实际读取的字节数，用于最后写回
;接下来将其回显至屏幕
          PUSH  AX
          MOV  CX,AX
          LEA     SI,READBUF
NEXT:
          CMP BYTE PTR [SI], 96
          JS    NOTCHANGE
          CMP BYTE PTR [SI], 123
          JNS    NOTCHANGE
          AND  BYTE PTR [SI],11011111B
    NOTCHANGE:      
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



;打开文件
          MOV   AH, 3DH          
          LEA   DX,FILENAME
          MOV   AL, 1
          INT      21H
          MOV   HANDLE,AX     
;将其写回txt文件中
          MOV    AH, 40H      ;INT 21H的40H功能，写文件
          MOV   BX, HANDLE  ;BX=文件句柄
          MOV   CX, TXTLEN           ;CX=要写入的字节数
          LEA     DX, READBUF   ;DX=写缓冲区首地址
          INT   21H                ;把缓冲区内容写入文件


 ;关闭文件
 EXIT: MOV   AH, 3EH        ;INT 21H的功能3EH，关闭文件
          MOV   BX, HANDLE     ;BX＝文件句柄
          INT   21H                       ;关闭文件 
            

         MOV AX, 4C00H
         INT 21H

CODE  ENDS

END   START