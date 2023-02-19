;write an program that compares three 16bit digits in the given array
assume cs: codeseg, ds: dataseg, es: dataseg
dataseg segment
    array dw 0000h, 0000h, 0002h
dataseg ends

codeseg segment

main proc far
start:
sub ax, ax
push ax
push ds
push es
mov ax, dataseg
mov ds, ax
mov es, ax
;use 3 different registers to stores 3 given number, and make comparison
;case 0: a = b = c
;case 1: a != b != c
;case 2: else
mov si, 0
mov ax, array[si]
mov bx, array[si+2]
mov dx, array[si+4]
mov cx, 0; stores number of equal pairs
cmp_1:cmp ax, bx
jne cmp_2
inc cx
cmp_2:cmp bx, dx
jne cmp_3
inc cx
cmp_3:cmp ax, dx
jne exit
inc cx
exit:
cmp cx, 0
je case_0
cmp cx, 3
je case_1
jmp case_2
case_0:
mov dl, '0'
mov ah, 02h
int 21h
jmp return
case_1:
mov dl, '1'
mov ah, 02h
int 21h
jmp return
case_2:
mov dl, '2'
mov ah, 02h
int 21h
return:
mov ax, 4c00h
int 21h

main endp
codeseg ends
end start