;write a program that can track the runtime of the program by taking over INT 1CH, 
assume cs: codeseg, ds: dataseg, es: dataseg
dataseg segment
    prompt db 'current runtime: ', '$'
    count db 0
    runtime db 0
    endline db 13, 10, '$'
dataseg ends

codeseg segment
display_dec proc near
; print runtime in decimal 
    push ax
    push bx
    push cx
    push dx
    mov bx, 10
    mov cx, 0
    mov al, runtime
    mov ah, 0
push_:
    div bl
    push ax
    inc cx
    mov ah, 0
    cmp ax, 0
    ja push_

disp:
    pop dx
    push cx
    mov cl, 8
    sar dx, cl
    pop cx
    add dl, 30h
    mov ah, 02h
    int 21h
    loop disp

    pop dx
    pop cx
    pop bx
    pop ax
    ret 
display_dec endp

alert proc near ; new int 1ch
    push ds
    push ax
    push bx
    push cx
    push dx
    mov ax, dataseg
    mov ds, ax
    ; int 1ch is called 18 times per second
    sti
    inc count 
    mov ax, 0
    mov al, count
    mov bl, 18
    div bl
    ;ah: 余数 al: 商
    cmp ah, 0
    ; mov runtime, al
    jne exit
    display:
    inc runtime
    lea dx, prompt
    mov ah, 09h
    int 21h
    call display_dec
    lea dx, endline
    mov ah, 09h
    int 21h
    exit:
    cli
    pop dx
    pop cx
    pop bx
    pop ax
    pop ds
    iret  
alert endp
main proc far 
start:
; save old interrupt vector
    sub ax, ax
    mov ax, dataseg
    mov ds, ax
    mov es, ax
    mov ah, 35h
    mov al, 1ch
    int 21h
    push es
    push bx
    push ds
    ; set new interrupt vector
    lea dx, alert; 002F
    mov ax, seg alert; 076E: codeseg
    mov ds, ax
    ;(ds:dx) => new interrupt vector
    mov ah, 25h
    mov al, 1ch
    int 21h; call dos to set new vector
    pop ds; restore ds
    sti
    mov cx, 10000
loop1:
    push cx
    mov cx, 10000
loop2: loop loop2
    pop cx  
    loop loop1
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
