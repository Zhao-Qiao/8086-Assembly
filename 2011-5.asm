assume cs: codeseg, ds: dataseg, es: dataseg

dataseg segment
    count db 0
    seconds db 0
    mods db 0; decides display 0 or 1
dataseg ends

codeseg segment

INT_1CH proc near
    push ax
    push bx
    push cx
    push dx
    mov ax, dataseg
    mov ds, ax
    sti
    inc count
    cmp count, 12h
    jne exit
inc_sec:
    inc seconds
    mov al, 0
    mov count, al
    cmp seconds, 0ah
    jne print
change: ; seconds == 10
    cmp mods, 0
    jne set0
set1:
    mov al, 01h
    mov mods, al
    jmp print
set0:
    mov al, 00h
    mov mods, al
print:
    cmp mods, 00h
    jne case1
case0:
    mov dl, '0'
    mov ah, 02h 
    int 21h
    jmp exit
case1:
    mov dl, '1'
    mov ah, 02h
    int 21h
exit:
    cli
    pop dx
    pop cx
    pop bx
    pop ax
    iret
INT_1CH endp

main proc far
start:
; save old interrupt vector
    sub ax, ax
    push ax
    mov ax, dataseg
    mov ds, ax
    mov es, ax
    mov al, 1ch
    mov ah, 35h
    int 21h
    push es
    push bx
; set new interrupt vector 
    lea dx, INT_1CH
    mov ax, seg INT_1CH
    push ds; save dataseg
    mov ds, ax
    mov ah, 25h
    mov al, 1ch
    int 21h
    pop ds; restore ds
;delay
    mov cx, 10000
lp1:
    push cx
    mov cx, 10000
lp2:loop lp2
    pop cx
    loop lp1
;restore interrupt vector
    pop dx
    pop ds
    mov ah, 25h
    mov al, 1ch
    int 21h
    mov ah, 4ch 
    int 21h
main endp
codeseg ends
end start