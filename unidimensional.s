.data
	test :.asciz "%d\n"
	drive :.space 1024
	nume_comanda :.space 4
	#cer comanda
	cerere_comanda :.asciz "Comanda(1-add, 2-del 3-defragmentare)\n" 
	citire :.asciz "%ld" 
	fisier :.asciz "ID fisier:\n" 	
	id_fisier :.space 4
	cerere_dimensiune :.asciz "Care este dimensiunea?\n"
	dimensiune_fisier :.space 4
	start_spatiu :.long 0
	stop_spatiu :.long 0
	afisare_bloc :.asciz "Intervaul: (%d,%d)\n"
	
.text
.global main

inserare_zerouri:
	cmp $1024, %ecx
	jge primire_comanda
	movb $0, (%edi, %ecx, 1)
	inc %ecx
	jmp inserare_zerouri


primire_comanda:
	push $cerere_comanda
	call printf
	add $4, %esp
	push $nume_comanda
	push $citire
	call scanf
	add $8, %esp
	jmp verificare_comanda

verificare_comanda:
	mov nume_comanda, %eax
	cmp $3, %eax
	je et_exit
	jmp citire_id_fisier	


citire_id_fisier:
	push %eax
	push $fisier 
	call printf
	add $4, %esp	
	push $id_fisier
	push $citire
	call scanf
	add $8, %esp
	pop %eax
	cmp $1, %eax
	je citire_dimensiune_fisier
	cmp $2, %eax
	je stergere

#adaugam fisier
citire_dimensiune_fisier:
	push $cerere_dimensiune
	call printf
	add $4, %esp
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
	xor %ebx, %ebx
	jmp cautare_spatiu

et_adaugare_fisier:
	cmp dimensiune_fisier, %ebx
	je am_gasit_spatiu#schimba numele, inseamna ca am gasit loc
	jl cautare_spatiu #inseamna ca inca cautam spatiu
	cmp $1024, %ecx
	je et_exit #schimba numele, inseamna ca nu am gasit loc in tot driveul
	
cautare_spatiu:
	mov (%edi, %ecx, 1), %eax
	cmp $0, %eax
	je am_gasit_zero
	jg nu_am_gasit_zero

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
	movb id_fisier, %al
	dec %ecx
	movl %ecx, stop_spatiu
	mov start_spatiu, %ecx
continuare: 
	cmp stop_spatiu, %ecx
	jg afisare_inserare
	movb %al, (%edi, %ecx)
	inc %ecx
	jmp continuare

#afisam intervalul unde am inserat 
afisare_inserare:
	xor %ecx, %ecx
	push stop_spatiu
	push start_spatiu
	push $afisare_bloc
	call printf
	add $12, %esp
	jmp primire_comanda

#stergem element, idul este in eax
stergere:
	xor %ecx, %ecx
	mov id_fisier, %eax
continuare_stergere:
	cmpb (%edi, %ecx), %al
	je setare_interval
	inc %ecx
	jmp continuare_stergere

#setez inceputul intervalului
setare_interval:
	movl %ecx, start_spatiu
	

#caut finalul
cautare_final_interval:
	cmpb (%edi, %ecx), %al
	jne am_gasit_final
	movb $0, (%edi, %ecx)
	inc %ecx

am_gasit_final:
	movl %ecx, stop_spatiu
	jmp afisare_inserare


main:
	lea drive, %edi
	xor %ecx, %ecx
	jmp inserare_zerouri

et_exit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
		
