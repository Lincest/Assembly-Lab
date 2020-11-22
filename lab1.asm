;description
DATA SEGMENT
	buffer    DB 'Author: 18010500076 ShiXuezhou', 0ah, 0dh, '$'
	buffer2   DB 'AaBbCDEF','$'
	showch    DB 'The character is: ', '$'
	showasc   DB 'The ascii is: ', '$'
	showinput DB 'Your input is: ', '$'
	endl      DB 0ah, 0dh, '$'
DATA ENDS

;description
CODE SEGMENT
	             assume cs:code, ds:data
	START:       
	             mov    ax, data
	             mov    ds, ax
	             mov    ah, 09h             	; 调用int21h的09号功能, 显示字符串, ds:dx=串地址
	             mov    dx, offset buffer
	             int    21h
	             mov    si, offset buffer2
	showascii:   
	             cmp    byte ptr [si], '$'
	             je     showinputasc        	; 遇到结束符跳转

	; The character is
	             mov    ah, 09h
	             mov    dx, offset showch
	             int    21h
	             mov    al, ds:[si]
	             mov    dl, al
	             mov    ah, 02h
	             int    21h
	; endl
	             mov    ah, 09h
	             mov    dx, offset endl
	             int    21h
	; The ascii is
	             mov    ah, 09h
	             mov    dx, offset showasc
	             int    21h

	             mov    al, ds:[si]
	             mov    dl, al
	             and    al, 0f0h            	; 处理高四位
	             mov    cl, 4
	             shr    al, cl
	             cmp    al, 0ah             	; 比较是否是大于0AH的数
	             jb     showhigh
	             add    al, 07h
	showhigh:                               	; 转换成数字
	             add    al, 30h
	             mov    dl, al
	             mov    ah, 02h
	             int    21h                 	; 显示高四位的ascii
	             mov    al, ds:[si]
	             and    al, 0fh             	; 处理低四位
	             cmp    al, 0ah
	             jb     showlow
	             add    al, 07h
	showlow:     
	             add    al, 30h
	             mov    dl, al
	             mov    ah, 02h
	             int    21h
	; endl
	             mov    ah, 09h
	             mov    dx, offset endl
	             int    21h

	             add    si, 1
	             jmp    showascii
	showinputasc:
	;endl
	             mov    ah, 09h
	             mov    dx, offset endl
	             int    21h
	; Your input is
	             mov    ah, 09h
	             mov    dx, offset showinput
	             int    21h
	; 读取键盘输入并回显
	             mov    ah, 01h
	             int    21h
	; 输入q或Q退出
	             cmp    al, 'q'
	             je     proend
	             cmp    al, 'Q'
	             je     proend
	             mov    bl, al              	; 保存一下al
	; The ascii is
	             mov    ah, 09h
	             mov    dx, offset endl
	             int    21h
	             mov    ah, 09h
	             mov    dx, offset showasc
	             int    21h

	             mov    al, bl
	             and    al, 0f0h
	             mov    cl, 4
	             shr    al, cl
	             cmp    al, 0ah
	             jb     showhigh1
	             add    al, 07h
	showhigh1:   
	             add    al, 30h
	             mov    dl, al
	             mov    ah, 02h
	             int    21h
	             mov    al, bl
	             and    al, 0fh
	             cmp    al, 0ah
	             jb     showlow1
	             add    al, 07h
	showlow1:    
	             add    al, 30h
	             mov    dl, al
	             mov    ah, 02h
	             int    21h
	             jmp    showinputasc
	proend:      
	             mov    ah, 4ch
	             int    21h
CODE ENDS
    END START