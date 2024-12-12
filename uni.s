.data
	pozZero :.long 0
	pozId :.long 0
	raspuns :.long 0
	counter :.long 0
	startSpatiu :.long 0
	stopSpatiu :.long 0
	comandaAdd :.long 1
	comandaGet :.long 2
	comandaDel :.long 3
	comandaDefrag :.long 4
	comenziExecutate :.long 0
	adduriExecutate :.long 0
	dimensiuneDriver :.long 1024
	numeComanda :.space 4
	idFisier :.space 4
	dimensiuneFisier :.space 4
	numarComenzi :.space 4
	numarAdduri :.space 4
	numeCOmanda :.space 4
	driver :.space 1024
	formatCitire :.asciz "%ld"
	textGetSiEroare :.asciz "(%ld, %ld)\n"
	formatAfisare :.asciz "%ld: (%ld, %ld)\n"
.text
.global main


swap:
	mov idFisier, %eax
	mov pozZero, %ecx
	movb %al, (%edi, %ecx)
	mov $0, %eax
	mov pozId, %ecx
	movb %al, (%edi, %ecx)
	ret

citire_id:
	push $idFisier
	push $formatCitire
	call scanf
	add $8, %esp
	ret


afisare_get:
	push stopSpatiu
	push startSpatiu
	push $textGetSiEroare
	call printf
	add $12, %esp
	push $0
	call fflush
	add $4, %esp
	ret


afisare_eroare:
	mov $0, %eax
	push %eax
	push %eax
	push $textGetSiEroare
	call printf
	add $12, %esp
	push $0
	call fflush
	add $4, %esp
	ret

#argumentul o sa fie 0 ca sa inceapa cautarea de la 0 si daca la final raspuns este 0 inseamna ca nu am gasit fisier
cautare_fisier:
	mov 4(%esp), %ecx
	movl $0, raspuns 
	mov idFisier, %eax
continuam_cautarea:
	cmp dimensiuneDriver, %ecx
	je nu_am_gasit_fisier
	cmpb (%edi, %ecx), %al
	je am_gasit_fisier
	inc %ecx
	jmp continuam_cautarea
am_gasit_fisier:
	mov %ecx, startSpatiu
	movl $1, raspuns
	ret
nu_am_gasit_fisier:
	ret



afisare_memorie:
	mov $0, %ecx
continuare_afisare_memorie:
	cmp dimensiuneDriver, %ecx
	je finalizare_afisare_memorie
	mov $0, %ebx
	cmpb (%edi, %ecx), %bl
	jne fisier_gasit
	inc %ecx
	jmp continuare_afisare_memorie
fisier_gasit:
	mov $0, %eax
	movb (%edi, %ecx), %al
	mov %eax, idFisier
	mov %ecx, startSpatiu
	inc %ecx 
	jmp cautare_final_fisier_de_afisat
cautare_final_fisier_de_afisat:
	cmp (%edi, %ecx), %al
	jne final_fisier_de_afisat
	inc %ecx
	jmp cautare_final_fisier_de_afisat
final_fisier_de_afisat:
	sub $1, %ecx
	mov %ecx, stopSpatiu	
	push %ecx
	call afisare_bloc
	pop %ecx
	inc %ecx
	jmp continuare_afisare_memorie
finalizare_afisare_memorie:
	ret


afisare_bloc:
	push stopSpatiu
	push startSpatiu
	push idFisier
	push $formatAfisare
	call printf
	add $16, %esp	
	push $0
	call fflush
	add $4, %esp
	ret



et_exit:
	mov $1, %eax	
	mov $0, %ebx
	int $0x80


main:
	#citim cate comenzi avem de facut
	push $numarComenzi
	push $formatCitire
	call scanf
	add $8, %esp	
	mov $0, %ecx
	lea driver, %edi
	jmp initializare_driver


initializare_driver:
	cmp dimensiuneDriver, %ecx
	je verificare_numar_comenzi
	mov $0, %eax
	movb %al, (%edi, %ecx)
	inc %ecx
	jmp initializare_driver
	

verificare_numar_comenzi:
	mov comenziExecutate, %ecx
	cmp numarComenzi, %ecx
 	je et_exit
	inc %ecx
	mov %ecx, comenziExecutate
	jmp citire_comanda

citire_comanda:	
	push $numeComanda
	push $formatCitire
	call scanf
	add $8, %esp
	mov numeComanda, %eax
	cmp comandaAdd, %eax
	je et_add
	cmp comandaGet, %eax
	je et_get
	cmp comandaDel, %eax
	je et_del
	cmp comandaDefrag, %eax
	je et_defrag

et_add:
	#prima oara vrem sa vedem cate adduri avem de facut
	push $numarAdduri
	push $formatCitire
	call scanf
	add $8, %esp 
	jmp check_add

resetare_adduri:
	#aici resetam adduriExecutate pentru urmatoarea data cand primim comanda add
	movl $0, adduriExecutate
	jmp verificare_numar_comenzi

check_add:
	#aici verificam daca mai avem adduri de facut si daca nu mergem as verificam daca mai avem alte comenzi de facut
	movl $0, counter
	mov adduriExecutate, %ecx
	cmp numarAdduri, %ecx
	je resetare_adduri
	inc %ecx
	mov %ecx, adduriExecutate
	call citire_id
	#urmatoarele 3 linii sunt doar pentru a testa codul
	mov idFisier, %eax
	cmp $227, %eax
	je test1
revenire:
	jmp citire_dimensiune
test1:
	jmp revenire
citire_dimensiune:
	push $dimensiuneFisier
	push $formatCitire
	call scanf
	add $8, %esp
	jmp formatare_dimensiune

formatare_dimensiune:
	mov dimensiuneFisier, %eax
	mov $0, %edx
	mov $8, %ebx
	div %ebx
	cmp $0, %edx
	jg rest
	mov %eax, dimensiuneFisier
	mov $0, %ecx
	jmp cautare_spatiu
	
rest:
	add $1, %eax
	mov %eax, dimensiuneFisier
	mov $0, %ecx
	jmp cautare_spatiu 
	

cautare_spatiu:
	#aici verificam daca am ajuns la finalul driverului
	cmp dimensiuneDriver, %ecx
	je eroare_add
	mov $0, %eax
	cmpb (%edi, %ecx), %al
	je am_gasit_zero
	#aici da ca nu am intrat in am gasit zero inseamna ca am gasit un fisier asa ca resetam counterul
	inc %ecx
	movl $0, counter
	jmp cautare_spatiu

eroare_add:
	call afisare_eroare
	jmp check_add
	
am_gasit_zero:
	#prima oara verificam daca este primul zero gasit sau nu
	mov counter, %eax
	cmp $0, %eax
	je primul_zero
	inc %eax
	mov %eax, counter
	jmp verificare_spatiu
primul_zero:
	mov %ecx, startSpatiu
	inc %eax
	mov %eax, counter
	jmp verificare_spatiu

verificare_spatiu:
	mov counter, %eax
	cmp dimensiuneFisier, %eax
	je am_gasit_spatiu
	inc %ecx
	jmp cautare_spatiu


am_gasit_spatiu:
	mov %ecx, stopSpatiu
	mov startSpatiu, %ecx
	mov idFisier, %eax
	jmp continuare_spatiu
continuare_spatiu:
	cmp stopSpatiu, %ecx
	jg afisare_add
	movb %al, (%edi, %ecx)
	inc %ecx
	jmp continuare_spatiu
	
afisare_add:	
	push stopSpatiu
	push startSpatiu
	push idFisier
	push $formatAfisare
	call printf
	add $16, %esp	
	push $0
	call fflush	
	add $4, %esp
	jmp check_add



et_get:
	call citire_id
	mov $0, %ecx
	push %ecx
	call cautare_fisier
	add $4, %esp
	mov startSpatiu, %ecx
	inc %ecx
	mov idFisier, %eax
	cmpl $0, raspuns
	je eroare_get
	jmp cautare_final

eroare_get:
	call afisare_eroare
	jmp verificare_numar_comenzi

cautare_final:
	cmpb (%edi, %ecx), %al
	jne am_gasit_final
	inc %ecx
	jmp cautare_final

am_gasit_final:
	dec %ecx
	mov %ecx, stopSpatiu
	call afisare_get
	jmp verificare_numar_comenzi
	

et_del:
	call citire_id
	mov $0, %ecx
	push %ecx
	call cautare_fisier
	add $4, %esp
	mov startSpatiu, %ecx
	mov idFisier, %eax
	cmpl $0, raspuns
	je final_delete
	jmp cautare_final_del


cautare_final_del:
	cmpb (%edi, %ecx), %al
	jne final_delete
	mov $0, %ebx
	movb %bl, (%edi, %ecx)
	inc %ecx
	jmp cautare_final_del

final_delete:
	call afisare_memorie
	jmp verificare_numar_comenzi


et_defrag:
	#prima oara cautam un zero, iar apoi cautam ceva diferit de zero, cand am gasit le schimbam
	mov $0, %ecx
cautare_de_zero:
	cmp dimensiuneDriver, %ecx
	je final_defrag
	mov $0, %eax
	cmpb (%edi, %ecx), %al
	je setare_poz_zero
	inc %ecx
	jmp cautare_de_zero
setare_poz_zero:
	mov %ecx, pozZero
	inc %ecx
	jmp cautare_de_id
cautare_de_id:
	cmp dimensiuneDriver, %ecx
	je final_defrag
	cmpb (%edi, %ecx), %al
	jne schimbare
	inc %ecx
	jmp cautare_de_id
schimbare:
	mov %ecx, pozId
	mov $0, %eax
	movb (%edi, %ecx), %al
	mov %eax, idFisier
	call swap
	mov pozZero, %ecx
	inc %ecx
	jmp cautare_de_zero
final_defrag:
	call afisare_memorie
	jmp verificare_numar_comenzi
