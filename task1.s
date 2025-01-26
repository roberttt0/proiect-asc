.data
    v: .space 4194304
    temp: .long -1
    nou: .space 4194304
    temp2: .long -1
    n: .long 0
    x: .long 0
    eax_verificare: .long 0
    eax_copy: .long 0
    ebx_copy: .long 0
    ecx_copy: .long 0
    edx_copy: .long 0
    eax_contor: .long 0
    ebx_contor: .long 0
    ecx_contor: .long 0
    edx_contor: .long 0
    nr_fisiere: .long 0
    descriptor: .long 0
    dimensiune: .long 0
    nrp: .long 0
    end: .long 0
    cntx: .long 0
    cnty: .long 0
    endx: .long 0
    endy: .long 0
    nr: .long 0
    startx: .long 0
    starty: .long 0
    numar: .long 0
    linie: .long 0
    ok: .long 0
    formatScanf: .asciz "%d"
    formatPrintf1: .asciz "%d: ((%d, %d), (%d, %d))\n"
    formatPrintf2: .asciz "((%d, %d), (%d, %d))\n"
    
    pathname: .space 256
    pathname_m: .space 256
    pathname_input: .space 256
    slash: .asciz "/"
    fd_director: .space 4
    formatScanf2: .asciz "%s"
    formatPrintf3: .asciz "%d\n"
    fds: .long 0
    fd: .long 0
    ok2: .long 0
.text
.global main
main:
    mov $v, %edi
    xor %ecx, %ecx
initializare:
    cmp $1048576, %ecx
    je initializare_exit
    
    movl $0, (%edi, %ecx, 4)

    inc %ecx
    jmp initializare
initializare_exit:
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
    mov %ecx, ecx_contor

    mov x, %eax
    mov %eax, eax_verificare

    cmp $1, %eax
    je adaugare

    cmp $2, %eax
    je et_get

    cmp $3, %eax
    je delete

    cmp $4, %eax
    je defrag

    cmp $5, %eax
    je concrete

    jmp for_exit

adaugare:
    mov %ecx, ecx_copy
    mov %ecx, ecx_contor
    push $nr_fisiere
    push $formatScanf
    call scanf
    add $8, %esp
    mov ecx_copy, %ecx

    xor %ebx, %ebx

adaugare_loop:
    cmp nr_fisiere, %ebx
    je for_exit

    mov %ecx, ecx_copy
    push $descriptor
    push $formatScanf
    call scanf
    add $8, %esp
    mov ecx_copy, %ecx

    mov %ecx, ecx_copy
    push $dimensiune
    push $formatScanf
    call scanf
    add $8, %esp
    mov ecx_copy, %ecx

    mov dimensiune, %eax
    mov %ebx, ebx_copy
    mov $8, %ebx
    xor %edx, %edx
    div %ebx
    cmp $0, %edx
    jnz adaugare_inc
    jmp adaugare_loop_1

adaugare_inc:
    inc %eax

adaugare_loop_1:
    mov ebx_copy, %ebx
    mov %eax, dimensiune

    movl $0, cntx
    movl $0, cnty
    movl $0, ok
    mov %ebx, ebx_contor
    mov %ecx, ecx_contor

    xor %ecx, %ecx

adaugare_loop_1k:
    cmp $1024, %ecx
    je adaugare_loop_2

    movl $0, nr
    xor %edx, %edx

adaugare_loop_1p:
    cmp $1024, %edx
    je adaugare_loop_1k_revenire

    mov %ecx, %eax
    mov %edx, edx_copy
    mov $1024, %ebx
    mul %ebx
    mov edx_copy, %edx
    add %edx, %eax

    mov (%edi, %eax, 4), %ebx

    cmp $0, %ebx
    je adaugare_loop_1p_inc
    movl $0, nr
    jmp adaugare_loop_1p_a

adaugare_loop_1p_inc:
    mov nr, %ebx
    inc %ebx
    mov %ebx, nr

adaugare_loop_1p_a:
    mov dimensiune, %ebx
    cmp nr, %ebx
    je adaugare_loop_1p_a_schimb
    jmp adaugare_loop_1p_revenire

adaugare_loop_1p_a_schimb:
    mov %ecx, cntx
    mov %edx, %eax
    sub dimensiune, %eax
    inc %eax
    mov %eax, cnty
    mov $1024, %ecx
    mov $1024, %edx
    movl $1, ok
    jmp adaugare_loop_2

adaugare_loop_1p_revenire:
    inc %edx
    jmp adaugare_loop_1p

adaugare_loop_1k_revenire:
    inc %ecx
    jmp adaugare_loop_1k

adaugare_loop_2:
    cmpl $1, ok
    jne adaugare_loop_else

    mov cnty, %ecx
    mov cnty, %eax
    add dimensiune, %eax
    sub $1, %eax
    mov %eax, end

adaugare_loop_2_cmp:
    cmp %eax, %ecx
    jg adaugare_loop_exit

    mov %eax, eax_copy
    mov cntx, %eax
    mov $1024, %ebx
    mul %ebx
    add %ecx, %eax
    mov %ecx, ecx_copy
    mov descriptor, %ecx
    mov %ecx, (%edi, %eax, 4)
    mov ecx_copy, %ecx
    inc %ecx
    mov eax_copy, %eax
    jmp adaugare_loop_2_cmp

adaugare_loop_exit:
    mov cntx, %eax
    mov %eax, endx
    push end
    push endx
    push cnty
    push cntx
    push descriptor
    push $formatPrintf1
    call printf
    add $24, %esp

    mov ecx_contor, %ecx
    mov ebx_contor, %ebx

    inc %ebx

    mov eax_verificare, %eax
    cmp $5, %eax
    je concrete_inc

    jmp adaugare_loop

adaugare_loop_else:
    movl $0, cntx
    movl $0, cnty
    movl $0, endx
    movl $0, end

    push end
    push endx
    push cnty
    push cntx
    push descriptor
    push $formatPrintf1
    call printf
    add $24, %esp

    mov ecx_contor, %ecx
    mov ebx_contor, %ebx

    mov eax_verificare, %eax
    cmp $5, %eax
    je concrete_inc

    inc %ebx
    jmp adaugare_loop

et_get:
    mov %ecx, ecx_contor
    movl $0, startx
    movl $0, starty
    movl $0, endx
    movl $0, endy

    mov %ecx, ecx_copy
    push $descriptor
    push $formatScanf
    call scanf
    add $8, %esp
    mov ecx_copy, %ecx

    xor %ebx, %ebx

et_get_for_k:
    cmp $1024, %ebx
    je et_get_cout

    xor %edx, %edx

et_get_for_p:
    cmp $1024, %edx
    je et_get_for_k_continuare

    mov %ebx, %eax
    mov %edx, edx_copy
    mov %ebx, ebx_copy
    mov $1024, %ebx
    mul %ebx
    mov edx_copy, %edx
    add %edx, %eax
    mov ebx_copy, %ebx

    mov (%edi, %eax, 4), %ecx

    cmp descriptor, %ecx
    je et_get_for_p_if
    jmp et_get_for_p_continuare

et_get_for_p_if:
    mov %ebx, startx
    mov %edx, starty

et_get_for_while:
    mov %ebx, %eax
    mov %edx, edx_copy
    mov %ebx, ebx_copy
    mov $1024, %ebx
    mul %ebx
    mov edx_copy, %edx
    add %edx, %eax
    mov ebx_copy, %ebx
    mov (%edi, %eax, 4), %ecx

    cmp descriptor, %ecx
    jne et_get_for_p_if_continuare
    inc %edx

    jmp et_get_for_while

et_get_for_p_if_continuare:
    dec %edx
    mov %edx, endy
    mov $1023, %ebx
    mov $1023, %edx

et_get_for_p_continuare:
    inc %edx
    jmp et_get_for_p

et_get_for_k_continuare:
    inc %ebx
    jmp et_get_for_k

et_get_cout:
    mov ecx_contor, %ecx
    mov %ecx, ecx_copy
    mov startx, %ecx
    mov %ecx, endx
    push endy
    push endx
    push starty
    push startx
    push $formatPrintf2
    call printf
    add $20, %esp
    mov ecx_copy, %ecx

    jmp for_exit

delete:
    mov %ecx, ecx_contor

    push $descriptor
    push $formatScanf
    call scanf
    add $8, %esp

    xor %ebx, %ebx

delete_k:
    cmp $1024, %ebx
    je afisare

    xor %edx, %edx

delete_p:
    cmp $1024, %edx
    je delete_kinc

    mov %edx, edx_copy
    mov %ebx, ebx_copy

    mov %ebx, %eax
    mov $1024, %ebx
    mul %ebx
    mov edx_copy, %edx
    add %edx, %eax

    mov (%edi, %eax, 4), %ecx

    mov ebx_copy, %ebx

    cmp descriptor, %ecx
    je delete_del
    jmp delete_pinc

delete_del:
    movl $0, (%edi, %eax, 4)

delete_pinc:
    inc %edx
    jmp delete_p

delete_kinc:
    inc %ebx
    jmp delete_k

afisare:
    xor %ebx, %ebx

afisare_k:
    cmp $1024, %ebx
    je for_exit
    
    xor %edx, %edx

afisare_p:
    cmp $1024, %edx
    je afisare_kcont

    mov %edx, edx_copy
    mov %ebx, ebx_copy

    mov %ebx, %eax
    mov $1024, %ebx
    mul %ebx
    mov edx_copy, %edx
    add %edx, %eax
    mov (%edi, %eax, 4), %ecx

    mov ebx_copy, %ebx

    cmp $0, %ecx
    je afisare_pcont

    mov %ecx, numar
    mov %ebx, startx
    mov %ebx, endx
    mov %edx, starty

afisare_while:
    mov %edx, edx_copy
    mov %ebx, ebx_copy

    mov %ebx, %eax
    mov $1024, %ebx
    mul %ebx
    mov edx_copy, %edx
    add %edx, %eax

    mov (%edi, %eax, 4), %ecx

    mov ebx_copy, %ebx

    cmp numar, %ecx
    jne afisare_afisare

    inc %edx
    jmp afisare_while

afisare_afisare:
    dec %edx
    mov %edx, endy

    mov %edx, edx_copy
    mov %ebx, ebx_copy

    push endy
    push endx
    push starty
    push startx
    push numar
    push $formatPrintf1
    call printf
    add $24, %esp

    mov edx_copy, %edx
    mov ebx_copy, %ebx

afisare_pcont:
    inc %edx
    jmp afisare_p
    
afisare_kcont:
    inc %ebx
    jmp afisare_k

defrag:
    mov $nou, %esi
    xor %ebx, %ebx

defrag_loop:
    cmp $1048576, %ebx
    je defragg

    movl $0, (%esi, %ebx, 4)
    inc %ebx
    jmp defrag_loop

defragg:
    mov %ecx, ecx_contor
    movl $0, descriptor
    movl $0, dimensiune
    movl $0, linie

    xor %ebx, %ebx

defrag_k:
    cmp $1024, %ebx
    je defrag4

    xor %edx, %edx

defrag_p:
    cmp $1024, %edx
    je defrag_kcont

    mov %edx, edx_copy
    mov %ebx, ebx_copy

    mov %ebx, %eax
    mov $1024, %ebx
    mul %ebx
    mov edx_copy, %edx
    add %edx, %eax

    mov (%edi, %eax, 4), %ecx

    mov ebx_copy, %ebx

    cmp $0, %ecx
    je defrag_pcont

    mov %ecx, descriptor
    movl $0, dimensiune

defrag_while:
    mov %edx, edx_copy
    mov %ebx, ebx_copy

    mov %ebx, %eax
    mov $1024, %ebx
    mul %ebx
    mov edx_copy, %edx
    add %edx, %eax

    mov (%edi, %eax, 4), %ecx

    mov ebx_copy, %ebx

    cmp descriptor, %ecx
    jne defrag2

    mov dimensiune, %ecx
    inc %ecx
    mov %ecx, dimensiune
    inc %edx

    jmp defrag_while

defrag2:
    dec %edx
    movl $0, cntx
    movl $0, cnty

    mov %ebx, ebx_contor
    mov %edx, edx_contor

    mov linie, %ebx
    
defrag2_y:
    cmp $1024, %ebx
    je defrag3

    movl $0, nr
    xor %edx, %edx

defrag2_u:
    cmp $1024, %edx
    je defrag2_ycont

    mov %edx, edx_copy
    mov %ebx, ebx_copy

    mov %ebx, %eax
    mov $1024, %ebx
    mul %ebx
    mov edx_copy, %edx
    add %edx, %eax

    mov (%esi, %eax, 4), %ecx

    mov ebx_copy, %ebx

    cmp $0, %ecx
    jne defrag2_u0

    mov nr, %ecx
    inc %ecx
    mov %ecx, nr
    jmp defrag2_continuare

defrag2_u0:
    movl $0, nr

defrag2_continuare:
    mov dimensiune, %eax
    cmp nr, %eax
    jne defrag2_ucont

    mov %ebx, cntx
    mov %edx, %ecx
    sub dimensiune, %ecx
    inc %ecx
    mov %ecx, cnty
    
    mov $1023, %ebx
    mov $1023, %edx

defrag2_ucont:
    inc %edx
    jmp defrag2_u

defrag2_ycont:
    inc %ebx
    jmp defrag2_y

defrag3:
    mov cnty, %edx
    mov cnty, %ebx
    add dimensiune, %ebx
    dec %ebx

defrag3_while:
    cmp %ebx, %edx
    jg defrag3_final

    mov %edx, edx_copy
    mov %ebx, ebx_copy

    mov cntx, %eax
    mov $1024, %ebx
    mul %ebx
    mov edx_copy, %edx
    add %edx, %eax

    mov descriptor, %ecx
    mov %ecx, (%esi, %eax, 4)

    mov ebx_copy, %ebx
    inc %edx
    jmp defrag3_while

defrag3_final:
    mov cntx, %ecx
    mov %ecx, linie

    mov ebx_contor, %ebx
    mov edx_contor, %edx

defrag_pcont:
    inc %edx
    jmp defrag_p

defrag_kcont:
    inc %ebx
    jmp defrag_k

defrag4:
    xor %ebx, %ebx

defrag4_atribuire:
    cmp $1048576, %ebx
    je afisare

    mov (%esi, %ebx, 4), %eax
    mov %eax, (%edi, %ebx, 4)
    
    inc %ebx
    jmp defrag4_atribuire

concrete:
    mov %ecx, ecx_contor
    push $pathname_input
    push $formatScanf2
    call scanf
    add $8, %esp

    push $pathname_input
    call opendir
    add $4, %esp

    cmp $0, %eax
    je for_exit

    mov %eax, fd_director

    push $pathname_input
    push $pathname_m
    call strcpy
    add $8, %esp

    push $slash
    push $pathname_m
    call strcat
    add $8, %esp
concrete_loop:
    movl $0, ok2
    push fd_director
    call readdir
    add $4, %esp

    cmp $0, %eax
    je for_exit

    add $11, %eax

    push %eax
    push $pathname_m
    push $pathname
    call strcpy
    add $8, %esp
    pop %eax

    movb (%eax), %bl
    cmpb $'.', %bl
    je concrete_inc

    push %eax
    push $pathname
    call strcat
    add $8, %esp


    mov $5, %eax
    mov $pathname, %ebx
    mov $0, %ecx
    int $0x80
    mov %eax, fd

    mov $19, %eax
    mov fd, %ebx
    mov $0, %ecx
    mov $2, %edx
    int $0x80

    mov $1000, %ebx
    xor %edx, %edx
    div %ebx
    mov %eax, dimensiune

    mov fd, %eax
    and $0xFF, %eax
    add $1, %eax
    mov %eax, fds

concrete_afisare:
    push fds
    push $formatPrintf3
    call printf
    add $8, %esp

    push dimensiune
    push $formatPrintf3
    call printf
    add $8, %esp

    mov fds, %eax
    mov %eax, descriptor

    mov dimensiune, %eax
    mov $8, %ebx
    xor %edx, %edx
    div %ebx
    cmp $0, %edx
    jnz concrete_afisare_inc
    jmp concrete_continuare

concrete_afisare_inc:
    inc %eax

concrete_continuare:
    mov %eax, dimensiune
    cmpl $2, dimensiune
    jl concrete_ok

    xor %ecx, %ecx
concrete_parcurgere:
    cmp $1048576, %ecx
    je concrete_verificare
    
    mov (%edi, %ecx, 4), %eax
    cmp descriptor, %eax
    je concrete_ok

    inc %ecx
    jmp concrete_parcurgere
concrete_ok:
    movl $1, ok2

concrete_verificare:
    cmpl $1, ok2
    je concrete_afisare_zero

    movl $0, cntx
    movl $0, cnty
    movl $0, ok
    xor %ecx, %ecx
    jmp adaugare_loop_1k

concrete_afisare_zero:
    movl $0, cntx
    movl $0, cnty
    movl $0, endx
    movl $0, end

    push end
    push endx
    push cnty
    push cntx
    push descriptor
    push $formatPrintf1
    call printf
    add $24, %esp

concrete_inc:
    jmp concrete_loop

for_exit:
    mov ecx_contor, %ecx
    inc %ecx

    jmp for

et_exit:
    pushl $0
    call fflush
    popl %eax
    
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
