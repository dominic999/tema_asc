.data
	start :.long 0
	stop :.long 0
	driver :.space 1024
	numComenzi :.space 4
	comenziFinalizate :.long 0
	formatText :.asciz "%ld"
	comanda :.space 4
	numarAdduri :.space 4
	adduriFinalizate :.long 0
	
.text
.global main

loop_comenzi:
	mov comenziFinalizate, %ecx
	cmp numComenzi, %ecx
	je et_exit
	inc %ecx
	mov %ecx, comenziFinalizate
	jmp citire_comanda

citire_comanda:
	push $comanda
	push $formatText
	call scanf
	add $8, %esp
	mov comanda, %eax
	cmp $4, %eax
	je et_defragmentare
	cmp $1, %eax
	je et_add
	jg citire_id


et_add:
	#verific cate add-uri am de facut
	push $numarAdduri
	push $formatText
	call scanf
	add $8, %esp
	mov $0, %ecx
	jmp loop_adduri
	
#verificam daca mai avem adduri de facut
loop_adduri:
	mov adduriFinalizate, %ecx	
	cmp numarAdduri, %ecx
	je loop_comenzi
	inc %ecx
	mov %ecx, adduriFinalizate
	mov $0, %ecx
	jmp citire_id
	

#cautam spatiu liber
free_space:
	mov $0, %eax
	cmp (%edi, %ecx), %eax	
	je verificare_spatiu_liber


verificare_spatiu_liber:	
	jmp et_exit

	


main:
	lea driver, %edi
	push $numComenzi
	push $formatText
	call scanf
	add $8, %esp 
	xor %ecx, %ecx
	jmp inserare_zerouri


et_exit: 
	mov $1, %eax
	mov $0, %ebx
	int $0x80

inserare_zerouri:
	cmp $1024, %ecx
	je loop_comenzi
	mov $0, %eax
	movb %al, (%edi, %ecx)
	inc %ecx
	jmp inserare_zerouri	
