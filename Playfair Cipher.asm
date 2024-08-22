INCLUDE Irvine32.inc
BUFMAX = 128     	; maximum buffer size
keySize = 25
.data
msg1  BYTE  "Please input the plaintext: ",0
msg2  BYTE  "Modified plaintext: ",0
msg3  BYTE  "The ciphertext is: ",0
mystring   BYTE   BUFMAX+1 DUP(?) ;�x�s��J��r
myupper   BYTE   BUFMAX+1 DUP(?)  ;�x�s�ܤj�g����r(��¤�r)
myTwo   BYTE   BUFMAX+1 DUP(?)  
strSize  DWORD  ?          ;��J��r������

div2 DWORD 00000002h
div5 DWORD 00000005h
Playfairkey BYTE "MONARCHYBDEFGIKLPQSTUVWXZ",0
myPf   BYTE   BUFMAX+1 DUP(0) 
tmp DWORD ?         ;�ΨӦsecx
w1pos DWORD ?       ;���r����m
row1 DWORD ?        ;�s�Ӧr�b�ĴX��ĴX�C
col1 DWORD ?
w2pos DWORD ?
row2 DWORD ?
col2 DWORD ?
GO DWORD 0          ;�ΨӧP�_�O�_����Ӹ�����m 1.���U�� 2.�����X��m
;-----------------------------------------------------
.code

main PROC
    ;�N�Ѽ�PUSH��steak
    mov eax, OFFSET Playfairkey   ;key[ebp+16]
    push eax
	mov eax, OFFSET myTwo  ;inputstring[ebp+12]
    push eax
    mov eax, OFFSET myPf  ;output[ebp+8]
    push eax

    call Playfair

    call Crlf
    mov	edx,OFFSET msg3	
	call WriteString
    mov	edx,OFFSET myPf	
	call WriteString
	exit
main ENDP
;-----------------------------------------------------
;Playfairkey      high   +16
;myTwo
;myPf
;return address
;��ebp��           low    +0
;-----------------------------------------------------
CmpRow PROC         ;�P�_Row�O�_�ۦP
    mov GO,0        ;�Y�ۦP �Ӧr��m���k���A�Ycol+1=5�A�hwpos-4(���ܸӦ�̫e�Y)�A�_�hwpos+1
    mov eax,row1    ;�Y���ۦP�~�򩹤U��Col
    cmp eax,row2
    je  Right1      ;row1==row2
    jmp CmpC        ;row1!=row2
Right1:
    inc col1
    mov eax,col1
    cmp eax,5
    je w1Sub4
    inc w1pos
    jmp Right2
w1Sub4:
    sub w1pos,4
    jmp Right2
Right2:
    inc col2
    mov eax,col2
    cmp eax,5
    je w2Sub4
    inc w2pos
    jmp quit
w2Sub4:
    sub w2pos,4
    jmp quit
CmpC:
    mov GO,1
quit:
    ret
CmpRow ENDP
;-------------------------------------------------
CmpCol PROC        ;�P�_Col�O�_�ۦP
    mov GO,0       ;�Y�ۦP �Ӧr��m���U���A�Yrow+1=5�A�hwpos-20(���ܸӦC�̫e�Y)�A�_�hwpos+5
    mov eax,col1   ;�Y���ۦP�N��﨤��m
    cmp eax,col2
    je  Down1      ;col1==col2
    jmp other      ;col1!=col2
Down1:
    inc row1
    mov eax,row1
    cmp eax,5
    je w1Sub20
    add w1pos,5
    jmp Down2
w1Sub20:
    sub w1pos,20
    jmp Down2
Down2:
    inc row2
    mov eax,row2
    cmp eax,5
    je w2Sub20
    add w2pos,5
    jmp quit
w2Sub20:
    sub w2pos,20
other:
    mov GO,1
quit:
    ret
CmpCol ENDP
;-------------------------------------------------
Other PROC
    mov eax,col1      ;���col�֤j(�j��������(-)�A�p�����k��(+))
    cmp eax,col2
    ja Col12
    jb Col21
Col12:                ;col1 > col2
    mov eax,col1
    sub eax,col2   
    sub w1pos,eax     
    add w2pos,eax
    jmp quit
Col21:                ;col2 > col1
    mov eax,col2
    sub eax,col1
    sub w2pos,eax
    add w1pos,eax
quit:
    ret
Other ENDP
;-------------------------------------------------
Find1 PROC
    ;--------------------------�Ĥ@�Ӧr
    mov ecx,25         ;key����
    cld
    repne scasb        ;�Y���@�˴N���U��        
    dec edi            ;edi����쪺��m
    mov w1pos,edi      ;
    mov edx,00000000h
    mov eax,24
    sub eax,ecx        ;�Ӧr�bkey�����ĴX��
    div div5
    mov row1,eax       ;�o���Ӧr��������C
    mov col1,edx
    ret
Find1 ENDP
;-------------------------------------------------
Find2 PROC
    ;--------------------------�ĤG�Ӧr
    mov ecx,25      ;key����
    cld
    repne scasb     ;�Y���@�˴N���U��        
    dec edi         ;edi����쪺��m
    mov w2pos,edi
    mov edx,00000000h
    mov eax,24
    sub eax,ecx
    div div5
    mov row2,eax
    mov col2,edx
    add esi,1
    ret
Find2 ENDP
;-------------------------------------------------
InputPF PROC
    mov ecx,tmp
    mov edi,w1pos
    mov al,[edi]    ;���쪺�ȩ��myPf
    mov [ebx], al   ;���쪺�ȩ��myPf
    inc ebx

    mov edi,w2pos
    mov al,[edi]    ;���쪺�ȩ��myPf
    mov [ebx], al   ;���쪺�ȩ��myPf
    inc ebx
    mov w1pos,0
    mov w2pos,0
    add esi,1
    ret
InputPF ENDP

Playfair PROC
    mov	edx,OFFSET msg1	;��Xenter your string
	call WriteString
    call InputTheString ;��J��r
	call lowertoCap     ;�p�g�ܤj�g���Ƶ{��(�ç�Ҧ�J�令I)
    call Crlf

    call Twotwo
    mov	edx,OFFSET msg2	;
	call WriteString
    mov	edx,OFFSET myTwo
	call WriteString
    call Crlf
    ;---------
    push ebp 
    mov ebp,esp
    pushad
    ;---------
    ;mov edi,[ebp+16]  ;key
    mov esi,[ebp+12]  ;mytwo
    mov ebx,[ebp+8]
    mov ecx,50
L1:
    mov tmp,ecx
    mov al,[esi]
    cmp al,' '   ;�Y���Ů�N��J�Ů�imyPf
    je spa
    cmp al,0     ;�O�_�J�쵲���Ÿ�
    je quit
    ;--------------------------�Ĥ@�Ӧr
    mov edi,[ebp+16] ;key
    call Find1
   ;--------------------------�ĤG�Ӧr
    mov al,[esi+1]
    mov edi,[ebp+16] ;key
    call Find2
   ;--------------------------��� 
   ;�Prow ���k (�Ycol+1=5 wpos�N-4�A�_�hwpos+1)
CompareRow:
    call CmpRow
    mov eax,GO
    cmp GO,1
    je CompareCol
    jmp Input
   ;�Pcol ���U (�Yrow+1=5 wpos�N-20,�_�hwpos+5)
CompareCol:
    call CmpCol
    mov eax,GO
    cmp GO,1
    je Different
    jmp Input 
Different:
    call Other
    jmp Input
Input:
    call InputPF
    jmp Next
 spa:
    mov al,' '
    mov [ebx], al
    inc ebx
    inc esi
 Next:
    loop L1
quit:
    ;---------
    popad
    pop ebp
    ret 12     ;add esp, 12
Playfair ENDP
;-----------------------------------------------------
Twotwo PROC
    pushad
    mov esi,OFFSET myupper    ;�B�z���j�g���r��
    mov edi,OFFSET myTwo
    mov eax,strSize
    mov edx,00000000h
    div div2
    inc eax
    
    mov ecx,eax
L1: mov al,[esi]     ;�YŪ��'5'�N�����j��(�N����)
    cmp al,'5'
    je bye           ;���X�j��
    mov al,[esi+1]   ;�YŪ��Ӧ�m���U�@�Ӭ�'5'�b���ݥ[X(�N��r�����_�ơA���ɺ������t��)
    cmp al,'5'
    je rearX

    mov al,[esi+1]   ;����Ӧr�P�U�@�Ӧr���L�@��
    cmp al,[esi]
    je addX          ;�Y�@�˴N����addX 
    mov al,[esi]     ;�S���@��
    mov [edi],al     ;�N�N��r��J��myTwo
    mov al,[esi+1]
    mov [edi+1],al
    add esi,2        ;�U�@������2�r  ABCDEF
    jmp quit         ;               ^ ^(+2)  
addX:
    mov al,[esi]     ;�@��
    mov [edi],al     ;�N�Ĥ@�Ӧr��J��myTwo
    mov al,'X'       ;�U�@�Ӧr��J'X'
    mov [edi+1],al
    add esi,1        ;�U�����ᱵ��Ū AABCDE
    jmp quit         ;               ^^(+1)    
rearX:
    mov al,[esi]     ;�Y�Ӧr�U�@�Ӭ�'5'(�N��S�����t��)
    mov [edi],al
    mov al,'X'
    mov [edi+1],al
    jmp bye
quit:
    mov al,' '
    mov [edi+2],al
    add edi,3
    loop L1
bye:mov BYTE PTR [edi+2], 0
    popad
    ret
Twotwo ENDP
;-----------------------------------------------------
lowertoCap PROC
    pushad          
    mov esi, OFFSET mystring  ; ��J����r             
    mov edi, OFFSET myupper                  
    mov ecx, strSize          ; ����

L1: mov al, [esi]                 
    cmp al, 0                 ; �ˬd�O�_��F����
    je do                     ; �p�G�O�A�����`��
    cmp al,'j'                ; �NJ��j�令'i'
    je upJ
    cmp al,'J'
    je upJ
    jmp Tran1
upJ:
    mov bl,'i'
    mov [esi],bl
    mov al,[esi]
Tran1:
    cmp al, 'a'               ; �ˬd�O�_���p�g�r��
    jb A1                     ; �p�G�p�� 'a'�A���L�ഫ
    cmp al, 'z'
    ja A1
    sub al, 32                ; �Ya<=[esi]<=z �N�p�g�r���ഫ���j�g�r��

A1: cmp al,'A'
    jb quit
    cmp al,'Z'
    ja quit
    mov [edi], al 
    inc edi
quit:
    inc esi                                              
    loop L1 
     
do: mov al,'5'
    mov [edi], al
    mov BYTE PTR [edi+1], 0     ;�T�O��X�H NULL ����
    popad                         
    ret
lowertoCap ENDP

;-----------------------------------------------------
InputTheString PROC
	pushad
	mov	ecx,BUFMAX		    ; �i�H��h������r 
	mov	edx,OFFSET mystring ; �N��J��r�s��mystring
	call ReadString         ; ��J
	mov	strSize,eax        	; �x�s��r����
	popad
	ret
InputTheString ENDP
;-----------------------------------------------------
END main