.data
	startZero :.long 0
	stopZero :.long 0
	startId :.long 0
	stopId :.long 0
	counterZero :.long 0
	counterId :.long 0
	startX :.long 0
	startY : .long 0
	stopX :.long 0
	stopY :.long 0
	dimensiuneFisier :.space 4
	idFisier :.space 4
	comandaAdd :.long 1
	comandaDel :.long 3
	comandaGet :.long 2
	comandaDef :.long 4
	dimensiuneLinie :.long 1024
	linieActuala :.long 0
	coloanaActuala :.long 0
	numarComenzi :.space 4
	numeComanda :.space 4
	comenziExecutate :.long 0
	dimensiuneDriver :.long 1048576
	numarAdduri :.space 4
	adduriExecutate :.long 0
	startSpatiu :.long 0
	stopSpatiu :.long 0
	counter :.long 0
	driver :.space 1048576
	afisareGet :.asciz "((%ld, %ld), (%ld, %ld))\n"
	afisareEroare :.asciz "((%ld, %ld), (%ld, %ld))\n"
	afisareInterval :.asciz "%ld: ((%ld, %ld), (%ld, %ld))\n"
	formatCitire :.asciz "%ld" 
.text
.global main



swap:
     mov idFisier, %eax
     mov startZero, %ecx
     movb %al, (%edi, %ecx)
     mov $0, %eax
     mov startId, %ecx
     movb %al, (%edi, %ecx)
     ret



afisare:
	mov $0, %ecx
continuare_afisare:
	cmp dimensiuneDriver, %ecx
	je finalizare_afisare
	mov $0, %eax
	cmpb (%edi, %ecx), %al
	jne am_gasit_id
	inc %ecx
	jmp continuare_afisare
am_gasit_id:
	#aici setam inceputul intervalului si idul
	mov %ecx, startSpatiu
	movb (%edi, %ecx), %al
	mov %eax, idFisier
	#acum vreau sa vad unde se termina intervalul
	inc %ecx
	jmp cautare_final
cautare_final:
	cmpb (%edi, %ecx), %al
	jne am_gasit_final_interval
	inc %ecx
	jmp cautare_final
am_gasit_final_interval:
	dec %ecx
	mov %ecx, stopSpatiu
	mov startSpatiu, %eax
	mov $0, %edx
	divl dimensiuneLinie
	mov %eax, startX
	mov %edx, startY
	mov stopSpatiu, %eax
	mov $0, %edx
	divl dimensiuneLinie	
	mov %eax, stopX
	mov %edx, stopY
	push %ecx
	push stopY
	push stopX
	push startY
	push startX
	push idFisier
	push $afisareInterval
	call printf
	add $24, %esp
	pop %ecx
	inc  %ecx
	jmp continuare_afisare
finalizare_afisare:
	ret




afisare_eroare:
	mov $0, %eax
	push %eax
	push %eax
	push %eax
	push %eax
	push $afisareEroare
	call printf
	add $20, %esp
	ret


afisare_bloc:
	mov startSpatiu, %eax
	mov $0, %edx
	divl dimensiuneLinie
	movl %eax, startX
	movl %edx, startY
	movl stopSpatiu, %eax
	movl $0, %edx
	divl dimensiuneLinie
	mov %eax, stopX
	mov %edx, stopY
	push stopY
	push stopX
	push startY
	push startX
	push idFisier
	push $afisareInterval
	call printf
	add $24, %esp
	ret


#primul argument este startul, iar al doilea este stopul
afisare_get:
	mov startSpatiu, %eax
	mov $0, %edx
	divl dimensiuneLinie
	mov %eax, startX
	mov %edx, startY
	mov stopSpatiu, %eax
	mov $0, %edx
	divl dimensiuneLinie
	mov %eax, stopX
	mov %edx, stopY
	push stopY
	push stopX
	push startY
	push startX
	push $afisareGet
	call printf
	add $20, %esp
	ret
	

main:
	lea driver, %edi
	push $numarComenzi
	push $formatCitire
	call scanf
	add $8, %esp
	jmp inserare_zerouri

et_exit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80

inserare_zerouri:
	cmp dimensiuneDriver, %ecx
	je verificare_numar_comenzi
	movb $0, (%edi, %ecx)
	inc %ecx
	jmp inserare_zerouri


verificare_numar_comenzi:
	movl $0, numarAdduri
	mov comenziExecutate, %ecx
	cmp numarComenzi, %ecx
	je et_exit
	inc %ecx
	mov %ecx, comenziExecutate
	jmp primire_comanda

primire_comanda:
	push $numeComanda
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
	cmp comandaDef, %eax
	je et_def


et_add:
#verific cate adduri am de facut
	push $numarAdduri
	push $formatCitire
	call scanf 
	add $8, %esp
	movl $0, adduriExecutate
	jmp check_add

#aici verific daca mai am addiri de facut
check_add:
	mov adduriExecutate, %ecx
	cmp $0, %ecx
	jg afis_add
cont_check:
	cmp numarAdduri, %ecx
	je verificare_numar_comenzi
	inc %ecx
	mov %ecx, adduriExecutate
	jmp citire_id_add

afis_add:
	push %ecx
	call afisare_bloc
	pop %ecx
	jmp cont_check
	


citire_id_add:
	push $idFisier
	push $formatCitire
	call scanf
	add $8, %esp
	jmp citire_dimensiune

citire_dimensiune:
	mov $0, %ecx
	push $dimensiuneFisier
	push $formatCitire
	call scanf
	add $8, %esp
	jmp formatare_dimensiune


formatare_dimensiune:
	mov dimensiuneFisier, %eax
	mov $8, %ebx
	mov $0, %edx
	div %ebx
	cmp $0, %edx
	jg rest
	mov %eax, dimensiuneFisier
	mov $1, %eax
	mov $0, %ecx
	jmp cautare_zero

rest:
	add $1,  %eax
	mov %eax, dimensiuneFisier
	mov $0, %ecx
	mov $1, %eax
	jmp cautare_zero
	 

cautare_zero:
	#aici verificam daca se schimba linia si daca s a terminat fisierul
	cmp dimensiuneDriver, %ecx
	je error #aici sarim la eticheta care afiseaza (0,0), inseamna ca nu am agasit spatiu
	mov %ecx, %eax
	mov $0, %edx
	divl dimensiuneLinie
	cmp linieActuala, %eax
	jne schimbare_linie
	mov $0, %eax
	cmpb (%edi, %ecx), %al
	je gasit_zero
	mov $0, %eax
	inc %ecx
	movl $0, counter
	jmp cautare_zero

schimbare_linie:
	mov %eax, linieActuala
	movl $0, counter
	jmp cautare_zero

gasit_zero:
	mov counter, %eax
	cmp $0, %eax
	je inceput_interval
	inc %eax
	mov %eax ,counter
	jmp comparare_dimensiune
inceput_interval:
	#aici setam inceputul intervalului in care cautam spatiu pentru a insera fisierul si linia pe care suntem
	inc %eax
	mov %eax, counter
	mov %ecx, startSpatiu
	mov %ecx, %eax
	mov $0, %edx
	divl dimensiuneLinie
	mov %eax, linieActuala
	jmp comparare_dimensiune

comparare_dimensiune:
	mov counter, %eax
	cmp dimensiuneFisier, %eax
	je am_gasit_spatiu
	inc %ecx
	jmp cautare_zero

am_gasit_spatiu:
	#aici vrem sa punem id-ul in spatiul gasit
	mov %ecx, stopSpatiu
	mov startSpatiu, %ecx
	mov idFisier, %eax
cont_am_gasit_spatiu:
	cmp stopSpatiu, %ecx
	jg check_add
	mov idFisier, %eax
	movb %al, (%edi, %ecx)
	inc %ecx
	jmp cont_am_gasit_spatiu
	
error:
	push %ecx
	call afisare_eroare
	pop %ecx
	mov numeComanda, %eax
	cmp comandaGet, %eax
	je verificare_numar_comenzi
	jmp check_add


et_del:
et_get:
	#vom citi id-ul si vom cauta incetutul intervalului
	push $idFisier
	push $formatCitire
	call scanf
	add $8, %esp
	mov $0, %ecx
	jmp cautare_inceput_interval_get_si_del
	
cautare_inceput_interval_get_si_del:
	cmp dimensiuneDriver, %ecx
	je error 
	mov idFisier, %eax
	cmpb (%edi, %ecx), %al
	je am_gasit_id_get_si_del
	inc %ecx
	jmp cautare_inceput_interval_get_si_del
	
am_gasit_id_get_si_del:
	mov %ecx, startSpatiu
	mov numeComanda, %eax
 	cmp comandaDel, %eax
	je stergere
	jmp gasire

#aici executam efectiv stergerea
stergere:	
	mov idFisier, %eax
	cmpb (%edi, %ecx), %al
	jne finalizare_del
	mov $0, %eax
	movb %al, (%edi, %ecx)	
	inc %ecx
	jmp stergere

finalizare_del:
	call afisare
	jmp verificare_numar_comenzi

#aici executam gasirea fisierului
gasire:
	mov idFisier, %eax
	cmpb (%edi, %ecx), %al
	jne finalizare_gasire
	inc %ecx
	jmp gasire
finalizare_gasire:
	dec %ecx
	mov %ecx, stopSpatiu
 	call afisare_get
	jmp verificare_numar_comenzi
	

et_def:
	#prima oara cautam un zero, apoi cand gasit numaram cati de 0 sunt pana gasim urmatorul id
	mov $0, %ecx
	movl $0, linieActuala
	movl $0, %eax
	movl $0, counterZero
	movl $0, counterId
continuare_defrag:
	mov %ecx, %eax
	mov $0, %edx
	divl dimensiuneLinie
	mov %eax, linieActuala
	mov $0, %eax
	cmp dimensiuneDriver, %ecx
	je final_defrag
	cmpb (%edi, %ecx), %al
	je zero_defrag
	inc %ecx
	jmp continuare_defrag
zero_defrag:
	mov %ecx, startZero
	addl $1, counterZero
	jmp cautare_id_defrag
cautare_id_defrag:
	#aici vrem sa cautam un id, iar cat timp nu gasim sa incrementm counterZero
	cmp dimensiuneDriver, %ecx
	je final_defrag
	cmpb (%edi, %ecx), %al
	jne id_defrag
	inc %ecx
	addl $1, counterZero
	jmp cautare_id_defrag
id_defrag:
	movb (%edi, %ecx), %al
	mov %eax, idFisier
	mov %ecx, startId
	#aici vom avea doua variante: daca suntem pe aceeasi linie pe care am gasit zeroul, schibmam direct, daca nu  verificam daca are loc
	#in plus, daca nu are loc vreau sa sar peste toata portiunea aceea de zero si sa trec la urmatoarea
	mov %ecx, %eax
	mov $0, %edx
	divl dimensiuneLinie
	cmp linieActuala, %eax
	je aceeasi_linie
	jmp linie_diferita
aceeasi_linie:
	push %ecx
	call swap
	pop %ecx
	mov startZero, %ecx
	inc %ecx
	movl $0, counterZero
	jmp continuare_defrag
linie_diferita:
	#asta inseamna ca am gasit fisierul pe o alta linie si vreau sa ma asigur ca are spatiu pe linia precedenta
	#daca nu are continui cautarea de zerouri de la locul unde se termina idul si schimb limia actuala	
	#trebuie la final sa resetez counterul si pentru zero si pentru id
	mov %ecx, %eax
	mov $0, %edx
	divl dimensiuneLinie
	mov %eax, linieActuala
	mov idFisier, %eax
	cmpb (%edi, %ecx), %al
	jne final_fisier_defrag
	inc %ecx
	addl $1, counterId
	jmp linie_diferita
final_fisier_defrag:
	dec %ecx
	mov %ecx, stopId
	mov counterId, %eax
	cmp counterZero, %eax
	jg nu_este_loc
	mov startZero, %ecx
	mov $0, %eax
	jmp este_loc
nu_este_loc:
	#aici resetam counterele si continuam cautarea dupa finalul id-ului
	inc %ecx
	movl $0, counterZero
	movl $0, counterId	
	jmp continuare_defrag
este_loc:	
	cmp counterId, %eax
	je final_de_swap_intre_linii
	mov idFisier, %ebx
	mov startZero, %edx
	movb %bl, (%edi, %edx)
	mov $0, %ebx
	mov startId, %edx
	movb %bl, (%edi, %edx)
	addl $1, startZero
	addl $1, startId
	inc %eax
	jmp este_loc
final_de_swap_intre_linii:
	mov startId, %ecx
	sub counterId, %ecx
	movl $0, counterZero
	movl $0, counterId
	jmp continuare_defrag
final_defrag:
	call afisare
	jmp verificare_numar_comenzi
	
