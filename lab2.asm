;从键盘输入十进制数，输出该十进制数的十进制，二进制
;用循环左移指令做的输出函数
DATA SEGMENT                                      		; 数据段
	INFO1 DB 0DH,0AH,'please input a number:$'
	INFO2 DB 0DH,0AH,'the binary number of your input is:$'
    INFO3 DB 0DH,0AH,'please input a string:$'
    INFO4 DB 0DH,0AH,'count the number in your string is:$'
DATA ENDS

DTOB SEGMENT                  		; 代码段
	        ASSUME CS:DTOB,DS:DATA
; 关于子程序的proc far和proc near
; NEAR属性(段内近调用): 调用程序和子程序在同一代码段中,只能被相同代码段的其他程序调用;
; FAR属性(段间远调用): 调用程序和子程序不在同一代码段中,可以被相同或不同代码段的程序调用.
MAIN PROC FAR
	        MOV    AX,DATA
	        MOV    DS,AX
	REPET:  
	        CALL   DECIBIN        	; 十进制->二进制，输入函数
	        CALL   BINIBIN        	; 二进制->二进制并输出
	        CALL   CRLF
            CALL   CNTNUM
	        CALL   STOP
	        JMP    REPET
MAIN ENDP

DECIBIN PROC NEAR             		; 十进制->二进制函数
	        LEA    DX,INFO1       	; 取偏移地址
	        MOV    AH,09H
	        INT    21H
	        MOV    BX,0
	NEWCHAR:
            MOV    AH,01H         	; 读一个字符
	        INT    21H
	        SUB    AL,30H
	; 小于0或者大于9则退出
	        CMP    AL, 0
	        JL     EXIT
	        CMP    AL,9
	        JG     EXIT
	        CBW                   	; 字节->字
	; 乘10 + 新数
	        XCHG   AX,BX          	; 交换存储器内容
	        MOV    CX,10D
	        MUL    CX
	        XCHG   AX,BX
	        ADD    BX,AX
	        JMP    NEWCHAR
	EXIT:   
	        RET
       
DECIBIN ENDP

BINIBIN PROC NEAR             		;输出二进制
	        LEA    DX,INFO2
	        MOV    AH,09H
	        INT    21H
	        MOV    CX,16            ; 循环16次
	ROTATE:        
            ROL    BX,1            ; 循环左移一位 (最高位->最低位)
	        MOV    AL,BL            
	        AND    AL,01H
	        ADD    AL,30H           ; 转换为ascii输出
	        MOV    DL,AL
	        MOV    AH,02H
	        INT    21H
	        LOOP   ROTATE           ; 循环16次
    COUT:
	        MOV    DL,42H           ; 输出B字符
	        MOV    AH,02H
	        INT    21H
	        RET
BINIBIN ENDP

CNTNUM PROC NEAR
            LEA    DX,INFO3
	        MOV    AH,09H
	        INT    21H
            MOV    CL,0
    INPUT:
            MOV    AH,01H         	; 读一个字符
	        INT    21H
    ;空格则退出
            CMP    AL,20H
            JE     OUTPUT
	        SUB    AL,30H
	; 小于0或者大于9则取下一位
	        CMP    AL, 0
	        JL     INPUT
	        CMP    AL,9
	        JG     INPUT
            ADD    CL,1
	        JMP    INPUT
    OUTPUT:
            CALL   CRLF
            LEA    DX,INFO4
	        MOV    AH,09H
	        INT    21H

            MOV    AH,02H
            ADD    CL,30H
            MOV    DL,CL
            INT    21H
CNTNUM ENDP

CRLF PROC NEAR                		;输出换行符
	        MOV    DL,0DH
	        MOV    AH,2
	        INT    21H
	        MOV    DL,0AH
	        MOV    AH,2
	        INT    21H
	        RET
CRLF ENDP
STOP PROC NEAR                		;结束MAIN过程
	        MOV    AX,4C00H
	        INT    21H
	        RET
STOP ENDP
DTOB    ENDS
  END MAIN   