.dato
	dimensiuneFisiser
	idFisier :.space 4
	comandaAdd :.long 1
	comandaDel :.long 3
	comandaGet :.long 2
	comandaDef :.long 4
	dimenisuneLinie :.long 1000
	linieActuala :.long 0
	coloanaActuala :.long 0
	formatCitire :.asciz "ld" 
	driver :.space 1000000
	numarComenzi :.space 4
	comenziExecutate :.long 0
	dimensiuneFisier :.long 1000000
	numarAdduri :.space 4
	adduriExecutate :.long 0
	startSpatiu :.long 0
	stopSpatiu :.long 0
	counter :.long 0

.text
.global main


main:
	lea driver, %edi
	push $numarComenzi
	push $formatCitire
	call scanf
	add $8, %esp
	mov $0, %ecx
	jmp inserare_zerouri

et_exit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80

inserare_zerouri:
	cmp dimensiuneFisier, %ecx
	je et_exit 
	movb $0, (%edi, %ecx)
	inc %ecx
	jmp inserare_zerouri


verificare_numar_comenzi:
	mov comenziExecutate, %ecx
	cmp numarComenzi, %ecx
	je et_exit
	inc %ecx
	mov %ecx, comenziExecutate
	jmp verificare_comanda

primire_comanda:
	push $numeComanda
	push $formatCitire
	call scanf
	add $8, %esp
	jmp verific_defrag

#aici verific daca este defragmentare sau altceva
verific_defrag:
	mov numeComanda, %eax
	cmp comandaDef, %eax
	je et_def
	jmp citire_id

#aici ajung daca este alta comanda in afara de defragmentare
citire_id: 
	push $idFisier
	push $formatCitire
	call scanf
	add $8, %esp
	jmp verific_comanda

#aici verific daca este add, del sau get 
verific_comanda:
	mov numeComanda, %eax
	cmp comandaAdd, %eax
	je et_add
	cmp comandaDel, %eax
	je et_del
	cmp comandaGet, %eax
	je et_get



et_add:
#verific cate adduri am de facut
	push $numarAdduri
	push %formatCitire
	call scanf 
	add $8, %esp

check_add:
	mov adduriExecutate, %ecx
	cmp numarAdduri, %ecx
	je primire_comanda
	inc %ecx
	mov %ecx, adduriExecutate
	mov $0, %ecx
	jmp citire_dimensiune

citire_dimensiune:
	push $dimensiunFisier
	push $formatCitire
	call scnaf
	add $8, %esp
	jmp formatare_dimensiune


formatare_dimensiune:
	mov dimensuneFisier, %eax
	mov $8. %ebx
	mov $0, %edx
	div %ebx
	cmp $0, %edx
	jl rest

rest:
	inc %eax
	mov %eax. dimensiuneFisier
	jmp cautare_zero
	 

cautare_zero:
	mov $0, %eax
	cmpb (%edi, %ecx), eax
	je gasit_zero
	inc %ecx
	jmp cautare_zero

gasit_zero:
	mov counter, %eax
	cmp $0, %eax
	inc %eax
	mov %eax ,counter
	je inceput_interval
	jmp comparare_dimensiune
inceput_interval:
	mov %ecx, startSpatiu
	jmp comparare_dimensiune

comparare_dimensiune:
	mov counter, %eax
	cmp dimensiuneFisier, %eax
	

