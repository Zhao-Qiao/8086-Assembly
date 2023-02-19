# 汇编指令们
敲一敲8086的指令系统
## 数据传输指令
1. mov 
    usage: mov dst, src
    action: (dst) <= (src)
    format:
    ```
    mov mem/reg1, mem/reg2(至少一个寄存器)
    mov reg, data(instant number)
    mov ac, mem
    mov mem, ac
    mov segreg, mem/reg
    mov mem/reg, segreg
    mov mem/reg, data
    ```
2. push
    usage: push src
    action:
        (sp) <= (sp) - 2
        ((sp+1), (sp)) <= (src)
    format: (16bit/1W only)
        push reg
        push mem
        push data (instant number)
        push segreg
3. pop
    usage: pop dst
    action:
        (dst) <= ((sp+1), (sp)) 
        (sp) <= sp + 2
    format: (16bit/1W only)
        pop reg
        pop mem
        pop segreg

4. xchg (exchange， W/Byte)
    usage: xchg opr1, opr2
    action: (opr1) <=> (opr2)
    format: opr1, opr2 至少一个在寄存器，

5. 累加器传输指令：
    IN (input)
    OUT (output)
    XLAT (translate)
    usage
6. 地址传输指令 LEA:
    usage: lea reg, src
    action: (reg) <= src 把源操作数的有效地址送入寄存器， 目的操作数不可以为段寄存器，

7. 类型转换指令：
    CBW (Convert Byte to Word)
    usage: CBW
    action: 把AL（8bit）的内容符号拓展到AH，形成AX中的字（16bit），即若AL的最高有效位为0，则(AH)=0；若AL的最高有效位为1，则(AH)=0FFFFH
    CWD (Convert Word to Double Word)
    usage: CWD
    action: 把AX的内容符号拓展到DX，形成DX:AX的双字，与cbw类似


## 算数指令
8086的标志位们：CF（进位，carry flag）, ZF（结果为0，zero flag）, SF（符号，sign flag）, OF（溢出，Overflow flag）
1. 加法
    1. add
    usage: add dst, src
    action: (dst) <= (dst) + (src)

    2. adc
    usage: adc  dst, src
    action: (dst) <= (dst) + (src) + CF

    3. inc
    usage: inc opr
    action: (opr) <= (opr) + 1

2. 减法
    1. sub
    usage: sub dst, src
    action: (dst) <= (dst) - (src)

    2. sbb (subtract with borrow)
    usage: sub dst, src
    action: (dst) <= (dst) - (src) - CF

    3. dec
    usage: dec opr
    action (opr) <= (opr) - 1

    4. neg
    usage: neg opr
    action (opr) <= -(opr)

    5. cmp
    usage cmp opr1. opr2
    action: (opr1) - (opr2),设标志位

3. 乘法 (byte, word, doubleword)
    1. mul
    2. imul
    format: mul src
    action:
        byte: (ax) <= (al)*(src) # al:目的操作数8bit; src:源操作数8bit; ax: 结果16bit
        word: (dx, ax) <= (ax)*(src) # ax：16bit; src:源操作数16bit ; (dx,ax) 结果32bit， dx存高16位，ax存低16位:
        double word: (edx, eax) <= (eax)*(src)
4. 除法 (byte, word, doubleword)
    1. div
    2. idiv
    format: div src
    action:
    byte: (al) <= (ax) / (src) 的商
          (ah) <= (ax) / (src) 的余数
    word: (ax) <= (dx, ax) / (src) 的商
          (adx) <= (dx, ax) / (src) 的余数

## 逻辑指令
1. AND, OR, XOR: OP dst, src
2. NOT: NOT opr
## 串处理指令
1. movs (move string)
2. cmps (compare string)
3. scas (scan string)
配合使用的前缀：
1. REP
format: rep string primitive(movs, lods, stos, ins, outs)

2. REPE/REPZ (repeat while equal/zero)
format: repe string primitive(cmps, scas)
action:
    if count reg(cx) == 0 or ZF=0（某次比较的两个操作数不等），break
    (Count Reg) <= (Count Reg) + 1
    继续执行其后的串指令
    重复1-3
CMPS: 
    format: cmps dst, src
    action: ((SI)-(DI)) # SI: source-index register 源变址寄存器; DI: destination-index register 目的变址寄存器
3. REPNE/REPNZ (repeat while not equal/zero)
    和REPE/REPZ差不多

## 转移控制指令
转移控制指令分为无条件和有条件的
1. JMP 无条件转移
2. 条件转移
    根据某一次运算的结果产生转移
    jz/je
    jnz/jne
    js
    jns
    jo
    jb/jnae/jc

    比较两个无符号数
    jb/jnae/jc
    jnb/jae/jnc
    jbe/jna
    jnbe/ja

    比较两个有符号数
    jl/jnge
    jnl/jge
    jle/jng
