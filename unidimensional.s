.data                                                                                            
     adduri_executate :.long 1
     nr_add :.space 4
     ultimul_id :.byte 0
     afisam_byte :.asciz "%d\n"
     test :.asciz "%d\n"
     drive :.space 1000
     nume_comanda :.space 4
     #cer comanda
     numar_comenzi :.space 4
     comenzi_executate :.long 0
     citire :.asciz "%ld" 
     id_fisier :.space 4
     cerere_dimensiune :.asciz "Care este dimensiunea?\n"
     dimensiune_fisier :.space 4
     start_spatiu :.long 0
     stop_spatiu :.long 0
     afisare_bloc :.asciz "%d: (%d,%d)\n"
     primul_zero :.long 0
     primul_id :.long 0
	 afisare_get: .asciz "(%d,%d)\n"
     
 .text
 .global main
 
 inserare_zerouri:
     cmp $1000, %ecx
     jge primire_comanda
     movb $0, (%edi, %ecx, 1)
     inc %ecx
     jmp inserare_zerouri
 
afisare_00:
	xor %eax, %eax
	push %eax
	push %eax
	push $afisare_get
	call printf
	add $8, %esp
	mov nume_comanda, %eax
	cmp $1,  %eax
	je verificare_add
	jmp primire_comanda

afisare_add:
	push stop_spatiu
	push start_spatiu
	push id_fisier
	push $afisare_bloc
	call printf
	add $16, %esp
	jmp verificare_add

 
 primire_comanda:
     movl comenzi_executate, %ecx
     cmpl numar_comenzi, %ecx
     je et_exit
     inc %ecx
     movl %ecx, comenzi_executate
     push $nume_comanda
     push $citire
     call scanf
     add $8, %esp
     jmp verificare_comanda
 
 verificare_comanda:
     mov nume_comanda, %eax
     cmp $5, %eax
     je et_exit
     cmp $4, %eax 
     je et_defragmentare
     cmp $1, %eax
     je add_initial
     jmp citire_id_fisier    
 
 
 citire_id_fisier:
	 mov nume_comanda, %eax
	 push %eax
     push $id_fisier
     push $citire
     call scanf
     add $8, %esp
	 pop %eax
     cmp $1, %eax
     je citire_dimensiune_fisier
     cmp $2, %eax
     je cautare_inceput_interval
     cmp $3, %eax
     je cautare_inceput_interval
 
 
 #aici am citit cate adduri se vor face
 add_initial:
     push $nr_add
     push $citire
     call scanf 
     add $8 ,%esp
     jmp citire_id_fisier
 
 verificare_add:
     mov adduri_executate, %ecx
     cmp nr_add, %ecx
     je resetare_adduri
     inc %ecx
     mov %ecx, adduri_executate
     jmp citire_id_fisier
     
resetare_adduri:
	movl $1, adduri_executate
	jmp primire_comanda
 
 #citim care este id-ul fisierului
 citire_dimensiune_fisier:
 #aici am citit cate adduri se vor face si este in nr_add
     push $dimensiune_fisier
     push $citire
     call scanf
     add $8, %esp
 
 #calculam de cate blocuri este nevoie   
 calculare_blocuri:
     xor %edx, %edx
     mov dimensiune_fisier, %eax
     mov $8, %ebx
     div %ebx
     cmp $0, %edx
   jg rest_mare    
   je rest_zero
 
 rest_mare:
     add $1, %eax
     mov %eax, dimensiune_fisier
   xor %ecx, %ecx                                                                               
     xor %ebx, %ebx
     jmp cautare_spatiu
 
 rest_zero:
     mov %eax, dimensiune_fisier
     xor %ecx, %ecx
     mov $0, %ebx
     jmp cautare_spatiu
 
 et_adaugare_fisier:
     cmp $1000, %ecx
     je afisare_00
     cmp dimensiune_fisier, %ebx
     je am_gasit_spatiu
     jl cautare_spatiu #inseamna ca inca cautam spatiu
 
 cautare_spatiu:
     movb (%edi, %ecx, 1), %al
     cmp $0, %al
     je am_gasit_zero
     jne nu_am_gasit_zero
 
 am_gasit_zero:
     cmp $0, %ebx
     je seteaza_start
 revenire:
     inc %ebx
     inc %ecx
     jmp et_adaugare_fisier
 
 seteaza_start:
     movl %ecx, start_spatiu
     jmp revenire

 nu_am_gasit_zero:
     mov $0, %ebx
     inc %ecx
     jmp cautare_spatiu
 
 am_gasit_spatiu:
     mov id_fisier, %eax
     dec %ecx
     movl %ecx, stop_spatiu
     mov start_spatiu, %ecx
 continuare: 
     cmp stop_spatiu, %ecx
     jg afisare_add
     movb %al, (%edi, %ecx)
     inc %ecx
     jmp continuare
 
 #afisam intervalul unde am inserat 
 afisare_inserare:
     xor %ecx, %ecx
     push stop_spatiu
     push start_spatiu
     push $afisare_get
     call printf
     add $12, %esp
     movl nume_comanda, %eax
     cmpl $1, %eax
     je verificare_add
     jmp primire_comanda
     
reset_ecx:
	mov $0, %ecx
	jmp afisare_memorie

#afisam fiecare fisier
afisare_memorie:
	cmp $1000, %ecx
	je primire_comanda
	mov $0, %eax 
	cmpb (%edi, %ecx), %al 
	jne setare_inceput_afisare
	inc %ecx
	jmp afisare_memorie

verificare_eax:
	mov nume_comanda, %eax
	cmp $1, %eax
	je verificare_add
	jmp primire_comanda

setare_inceput_afisare:
	mov %ecx, start_spatiu
	mov $0, %eax
	movb (%edi, %ecx), %al
	mov %eax, id_fisier

afisare_efectiva:
	mov id_fisier, %eax
	cmpb (%edi, %ecx), %al
	jne afisare
	inc %ecx
	jmp afisare_efectiva

afisare:
	dec %ecx
	mov %ecx, stop_spatiu
	push stop_spatiu
	push start_spatiu
	push id_fisier
	push $afisare_bloc
	call printf
	add $16, %esp
	mov stop_spatiu, %ecx
	inc %ecx
	jmp afisare_memorie
	
	
#aici incepe stergerea si getul
 #cautam iceputul intervlului
 cautare_inceput_interval:
     xor %ecx, %ecx
     mov id_fisier, %eax
 continuare_cautare_inceput:
   	 cmp $1000, %ecx
	 je verific_get
     cmpb (%edi, %ecx), %al
     je setare_interval
     inc %ecx
     jmp continuare_cautare_inceput

verific_get:
	mov nume_comanda, %eax
	cmp $2, %eax
	je afisare_00
	jmp afisare_memorie
 
 #setez inceputul intervalului
 setare_interval:
     movl %ecx, start_spatiu
     mov nume_comanda, %edx
     cmp $3, %edx
     je cautare_final_interval_de_sters
     jl cautare_final_interval_de_returnat

 #caut finalul
 cautare_final_interval_de_sters:
     cmpb (%edi, %ecx), %al
     jne am_gasit_final
     movb $0, (%edi, %ecx)
     inc %ecx
     jmp cautare_final_interval_de_sters
 
 cautare_final_interval_de_returnat:
     cmpb (%edi, %ecx), %al
     jne am_gasit_final
     inc %ecx
     jmp cautare_final_interval_de_returnat
 
 am_gasit_final:
     dec %ecx
     movl %ecx, stop_spatiu
	 mov nume_comanda, %eax
	 cmpl  $2, %eax
	 je afisare_inserare
	 jmp reset_ecx
 
 et_defragmentare:
     mov primul_zero, %ecx
     mov $0, %eax
 continuare_defragmentare:
     cmp $1000, %ecx
     je resetare_primul_zero
     cmpb (%edi, %ecx), %al
     je am_gasit_primul_zero
     inc %ecx
     jmp continuare_defragmentare 

resetare_primul_zero:
	movl $0, primul_zero
	jmp reset_ecx
 
 am_gasit_primul_zero:
     mov %ecx, primul_zero
     inc %ecx    
 
 cautam_primul_id:
     cmp $1000, %ecx
     je resetare_primul_zero
     cmpb (%edi, %ecx), %al
     jne am_gasit_primul_id
     inc %ecx
     jmp cautam_primul_id
 
am_gasit_primul_id:          
	mov %ecx, primul_id
et_switch:
     movb (%edi, %ecx), %al
     mov primul_zero, %ecx
     movb %al, (%edi, %ecx)
     mov $0, %eax
     mov primul_id, %ecx
     movb %al, (%edi, %ecx)
     jmp et_defragmentare
 
 et_afisare_lista:
     mov $0, %ecx
     mov $0, %eax
     mov $0, %edx
 cont_lista:
     cmpb (%edi, %ecx), %al
     je primire_comanda
     movb (%edi, %ecx), %dl
     push %ecx
     push %eax
     push %edx
     push $afisam_byte
     call printf
     add $8, %esp
     pop %eax
     pop %ecx
     inc %ecx
     jmp cont_lista
 
 
 main:
     push $numar_comenzi
     push $citire
     call scanf
     add $8, %esp
     lea drive, %edi
     xor %ecx, %ecx
     jmp inserare_zerouri                                                                         
 
 et_exit:
     mov $1, %eax
     mov $0, %ebx
     int $0x80


