.data
    v: .space 4096
    temp: .long -1
    nou: .space 4096
    temp2: .long -1
    n: .long 0
    x: .long 0
    nr_fisiere: .long 0
    descriptor: .long 0
    dimensiune: .long 0
    ecx_copy: .long 0
    eax_copy: .long 0
    ebx_copy: .long 0
    edx_copy: .long 0
    i: .long 0
    aux: .long 0
    nr: .long 0
    start: .long 0
    end: .long 0
    cnt: .long 0
    nrp: .long 0
    ok: .long 0
    ecx_contor: .long 0
    numar: .long 0
    stop: .long 0
    c_stop: .long 0
    element: .long 0
    formatPrintf1: .asciz "%d: (%d, %d)\n"
    formatPrintf2: .asciz "(%d, %d)\n"
    formatScanf: .asciz "%d"
.text
.global main
main:
    mov $v, %edi
    xor %ecx, %ecx
initializare:
    cmp $1024, %ecx
    je main1
    movl $0, (%edi, %ecx, 4)
    inc %ecx
    jmp initializare
main1:
    push $n
    push $formatScanf
    call scanf
    add $8, %esp

    xor %ecx, %ecx

for:
    cmp n, %ecx
    je et_exit

    mov %ecx, ecx_copy
    push $x
    push $formatScanf
    call scanf
    add $8, %esp
    mov ecx_copy, %ecx

    mov x, %eax
    cmp $1, %eax
    je adaugare

    cmp $2, %eax
    je et_get

    cmp $3, %eax
    je et_delete

    cmp $4, %eax
    je et_defrag

    jmp for_continuare

adaugare:
    mov %ecx, ecx_contor

    push $nr_fisiere
    push $formatScanf
    call scanf
    add $8, %esp

    xor %ebx, %ebx
adaugare_for:
    cmp nr_fisiere, %ebx
    je for_continuare

    push $descriptor
    push $formatScanf
    call scanf
    add $8, %esp

    push $dimensiune
    push $formatScanf
    call scanf
    add $8, %esp

    mov dimensiune, %eax
    mov $8, %ecx
    xor %edx, %edx
    div %ecx

    cmp $0, %edx
    je adaugare_for1

    inc %eax
adaugare_for1:
    mov %eax, dimensiune

    movl $0, nr
    movl $0, cnt
    movl $0, ok

    xor %edx, %edx
adaugare_fork:
    cmp $1024, %edx
    je adaugare2

    movl (%edi, %edx, 4), %eax

    cmp $0, %eax
    je adaugare_fork_inc

    movl $0, nr
    jmp adaugare_fork1
adaugare_fork_inc:
    mov nr, %eax
    inc %eax
    mov %eax, nr
adaugare_fork1:
    mov nr, %eax
    cmp dimensiune, %eax
    jne adaugare_fork_cont

    sub dimensiune, %edx
    inc %edx
    mov %edx, cnt
    mov $1023, %edx
    movl $1, ok
adaugare_fork_cont:
    inc %edx
    jmp adaugare_fork
adaugare2:
    cmpl $0, ok
    je adaugare_else

    mov cnt, %ecx
    mov cnt, %edx
    add dimensiune, %edx
    dec %edx
    mov %edx, end
adaugare_while:
    cmp %edx, %ecx
    jg adaugare_if

    mov descriptor, %eax
    mov %eax, (%edi, %ecx, 4)
    inc %ecx
    jmp adaugare_while
adaugare_if:
    push end
    push cnt
    push descriptor
    push $formatPrintf1
    call printf
    add $16, %esp
    jmp adaugare_nrfisiere
adaugare_else:
    movl $0, cnt
    movl $0, end
    push end
    push cnt
    push descriptor
    push $formatPrintf1
    call printf
    add $16, %esp
adaugare_nrfisiere:
    mov ecx_contor, %ecx
    inc %ebx
    jmp adaugare_for

et_get:     # GET
    movl $0, start
    movl $0, end

    mov %ecx, ecx_copy
    push $descriptor
    push $formatScanf
    call scanf
    add $8, %esp
    mov ecx_copy, %ecx

    xor %ebx, %ebx

et_get_for:
    cmp $1024, %ebx
    je et_get_for_exit

    mov (%edi, %ebx, 4), %eax
    cmp descriptor, %eax
    je et_get_for_1
    jmp et_get_for_1_continuare

et_get_for_1:
    mov %ebx, start

et_get_for_1_loop:
    mov (%edi, %ebx, 4), %eax
    cmp descriptor, %eax
    je et_get_for_1_loop_add
    jmp et_get_for_1_loop_continuare

et_get_for_1_loop_add:
    inc %ebx
    jmp et_get_for_1_loop

et_get_for_1_loop_continuare:
    dec %ebx
    mov %ebx, end
    mov $1023, %ebx

et_get_for_1_continuare:
    inc %ebx
    jmp et_get_for

et_get_for_exit:
    # AFISARE
    mov %ecx, ecx_copy
    push end
    push start
    push $formatPrintf2
    call printf
    add $12, %esp
    mov ecx_copy, %ecx

    jmp for_continuare

et_delete:
    mov %ecx, ecx_copy
    push $descriptor
    push $formatScanf
    call scanf
    add $8, %esp
    mov ecx_copy, %ecx

    xor %ebx, %ebx

et_delete_sterg_loop:
    cmp $1024, %ebx
    je et_delete_1

    mov (%edi, %ebx, 4), %eax
    cmp descriptor, %eax
    je et_delete_sterg_1
    jmp et_delete_sterg_continuare

et_delete_sterg_1:
    mov $0, %eax
    mov %eax, (%edi, %ebx, 4)

et_delete_sterg_continuare:
    inc %ebx
    jmp et_delete_sterg_loop

et_delete_1:
    xor %ebx, %ebx

et_delete_1_loop:
    cmp $1024, %ebx
    je et_delete_exit

    mov (%edi, %ebx, 4), %eax
    cmp $0, %eax
    jne et_delete_1_if
    jmp et_delete_1_continuare

et_delete_1_if:
    mov (%edi, %ebx, 4), %eax
    mov %eax, numar
    mov %ebx, start
    mov %eax, nrp

et_delete_1_if_loop:
    mov (%edi, %ebx, 4), %eax
    cmp nrp, %eax
    je et_delete_1_if_loop_inc
    jmp et_delete_2

et_delete_1_if_loop_inc:
    inc %ebx
    jmp et_delete_1_if_loop

et_delete_2:
    dec %ebx
    mov %ebx, end

    mov %ecx, ecx_copy
    push end
    push start
    push numar
    push $formatPrintf1
    call printf
    add $16, %esp
    mov ecx_copy, %ecx

et_delete_1_continuare:
    inc %ebx
    jmp et_delete_1_loop

et_delete_exit:
    jmp for_continuare

et_defrag:
    mov %ecx, ecx_contor

    xor %ecx, %ecx
    mov $nou, %esi

defrag_nou:
    cmp $1024, %ecx
    je defrag

    movl $0, (%esi, %ecx, 4)
    inc %ecx
    jmp defrag_nou

defrag:
    movl $0, descriptor
    movl $0, dimensiune

    xor %ecx, %ecx

defrag_forj:
    cmp $1024, %ecx
    je defrag_schimbare

    mov (%edi, %ecx, 4), %eax

    cmp $0, %eax
    je defrag_forj_continuare

    mov %eax, descriptor
    movl $0, dimensiune

defrag_while:
    mov (%edi, %ecx, 4), %eax

    cmp descriptor, %eax
    jne defrag_forj2

    mov dimensiune, %edx
    inc %edx
    mov %edx, dimensiune
    inc %ecx
    jmp defrag_while

defrag_forj2:
    dec %ecx
    movl $0, start
    movl $0, end
    movl $0, nr

    xor %edx, %edx

defrag_fork:
    cmp $1024, %edx
    je defrag_atribuire

    mov (%esi, %edx, 4), %eax

    cmp $0, %eax
    je defrag_fork_inc

    movl $0, nr
    jmp defrag_fork2
defrag_fork_inc:
    mov nr, %eax
    inc %eax
    mov %eax, nr

defrag_fork2:
    mov nr, %ebx

    cmp dimensiune, %ebx
    jne defrag_fork_continuare

    mov %edx, end
    sub dimensiune, %edx
    inc %edx
    mov %edx, start
    mov $1023, %edx

defrag_fork_continuare:
    inc %edx
    jmp defrag_fork

defrag_atribuire:
    mov start, %ebx

defrag_atribuire_while:
    cmp end, %ebx
    jg defrag_forj_continuare

    mov descriptor, %eax
    mov %eax, (%esi, %ebx, 4)
    inc %ebx
    jmp defrag_atribuire_while

defrag_forj_continuare:
    inc %ecx
    jmp defrag_forj

defrag_schimbare:
    xor %ecx, %ecx
    
defrag_schimbare_loop:
    cmp $1024, %ecx
    je defrag_afisare

    mov (%esi, %ecx, 4), %eax
    mov %eax, (%edi, %ecx, 4)

    inc %ecx
    jmp defrag_schimbare_loop

defrag_afisare:
    mov ecx_contor, %ecx
    jmp et_delete_1

for_continuare:
    inc %ecx
    jmp for

et_exit:
    pushl $0
    call fflush
    popl %eax
    
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
