;this program waits 10 seconds on start and display 'Are you ready', then wait for user input
;if user inputs 'y', then print '3 2 1 go' one word per second
;if user inputs 'n', then restart program
;state: initial waiting, waiting for input, print,
assume cs: codeseg, ds: dataseg, es: dataseg

dataseg segment 
    prompt1 db 'Are You Ready? ', 13, 10, '$'
    go db 'go', 13, 10, '$'
    endline db 13, 10, '$'
    count db 0
    seconds db 0
    is_ready db 0; is ready for print
    process db 0; 
dataseg ends

codeseg segment

INT_1CH proc near
    push ax
    push bx
    push cx
    push dx
    mov ax, 0
    mov bx, 0
    mov cx, 0
    mov dx, 0
    mov ax, dataseg
    mov ds, ax
    sti

control:
    inc count
    mov al, count; if increase counted seconds
    cmp al, 12h
    jne exit
inc_second:
    mov al, 0
    mov count, al; reset count
    inc seconds
    mov al, seconds
    cmp al, 0ah ; 10 seconds
    je set_wait
    ; since we print output one word per second, we can set the entrence of the printing process inside second increment process
    mov al, is_ready
    cmp al, 01h
    je print
    mov al, seconds
    jmp exit
set_wait: ; set wait until user inputs
    lea dx, prompt1
    mov ah, 09h
    int 21h
    mov al, 20h
    out 20h, al
    mov ah, 01h
    int 21h
    cmp al, 'y'
    ;set is_ready, start output next time
    jne set_restart
set_ready:
    mov al, 01h
    mov is_ready, al
    lea dx, endline
    mov ah, 09h
    int 21h
    jmp exit
set_restart:
    cmp al, 'n'
    lea dx, endline
    mov ah, 09h
    int 21h
    ;restart
    je reset
    jmp exit
print:
    mov al, process
    inc process
    cmp al, 0 
    je print1 
    cmp al, 1 
    je print2
    cmp al, 2 
    je print3 
    cmp al, 3
    je printgo
print1:
    mov dl, '1'
    mov ah, 02h
    int 21h
    mov dl, ' '
    mov ah, 02h
    int 21h
    jmp exit
    
print2:
    mov dl, '2'
    mov ah, 02h
    int 21h
    mov dl, ' '
    mov ah, 02h
    int 21h
    jmp exit
print3:
    mov dl, '3'
    mov ah, 02h
    int 21h
    mov dl, ' '
    mov ah, 02h
    int 21h
    jmp exit
printgo:
    lea dx, go
    mov ah, 09h
    int 21h
reset:
    mov al, 0h
    mov is_ready, al
    mov count, al
    mov seconds, al
    mov process, al
exit:
    
    cli
    pop dx
    pop cx
    pop bx
    pop cx
    iret
INT_1CH endp

main proc far
start:
    sub ax, ax
    push ax
    mov ax, dataseg
    mov ds, ax
    mov es, ax
    ; save old 1ch interrupt vector
    mov al, 1ch
    mov ah, 35h
    int 21h ; (es:bx)
    push es
    push bx
    push ds; save ds
    ; set new ich interrupt vector
    lea dx, INT_1CH
    mov ax, seg INT_1CH
    mov ds, ax
    mov ah, 25h
    mov al, 1ch
    int 21h
    pop ds; restore ds
    sti
    mov cx, 10000
    mov ah, 01h
    int 21h
loop1:; delay
    push cx
    mov cx, 10000
loop2: loop loop2
    ; restore old interrupt vector
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
