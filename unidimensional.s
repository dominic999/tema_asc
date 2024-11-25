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
	jge xor_ecx#schimba cu primire_comanda
	movw $0, (%edi, %ecx, 1)
	inc %ecx
	jmp inserare_zerouri

xor_ecx:
	mov $0, %ecx

afisare_test:
	cmp $10, %ecx
	je et_exit
	push %ecx
	push (%edi, %ecx)
	push $test
	call printf
	add $8, %esp
	pop %ecx
	jmp afisare_test

primire_comanda:
	push $cerere_comanda
	call printf
	add $4, %esp
	push $nume_comanda
	push $citire
	call scanf
	add $8, %esp
	push nume_comanda
	jmp verificare_comanda

verificare_comanda:
	mov 0(%esp), %eax
	cmp $1, %eax
	je citire_id_fisier
	jmp et_exit


citire_id_fisier:
	push $fisier 
	call printf
	add $4, %esp	
	push $id_fisier
	push $citire
	call scanf
	add $8, %esp

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
	mov id_fisier, %eax
	dec %ecx
	movl %ecx, stop_spatiu
	mov start_spatiu, %ecx
continuare: 
	cmp stop_spatiu, %ecx
	jg afisare_inserare
	movw $10, (%edi, %ecx)
	inc %ecx
	jmp continuare

afisare_inserare:
	push stop_spatiu
	push start_spatiu
	push $afisare_bloc
	call printf
	add $12, %esp
	push 0(%edi)
	push 1(%edi)
	push $afisare_bloc
	call printf
	add $12, %esp
	jmp primire_comanda

main:
	lea drive, %edi
	xor %ecx, %ecx
	jmp inserare_zerouri

et_exit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
		
