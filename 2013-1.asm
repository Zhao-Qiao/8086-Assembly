assume cs: codeseg, ds: dataseg, es: dataseg
dataseg segment 
    nA dw ?
    nB dw ?
    nC dw ?
    nD dw ?

dataseg ends

codeseg segment
main proc far
start:
;compute (A*B+C)/D + 15
sub ax, ax
push ax
mov ax, dataseg
mov ds, ax
mov es, ax
mov ax, nA
imul nB; (DX, AX) = A*B
add ax, nC
adc dx, 0
idiv nD


main endp
codeseg ends
end start