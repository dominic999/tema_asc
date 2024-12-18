#TODO verifica care este treaba cu fsstat, vezi cat trebuie sa adaugi la adresa bufferului ca sa gasesti dimensiunea
.data
	dimensiuneFisier :.long 0
	buffer :.space 200
	descriptor :.long 0
	file :.quad 0
	entry :.quad 0
	director :.quad 0
	path :.asciz "/home/tirdeadominic/Documents/fisiere_test/"
	filePath :.space 256
	statBuffer :.space 1024
	text :.asciz "%ld\n"
	format :.asciz "%s\n"
	dot :.asciz "."
	dotDot :.asciz ".."
	afisareMemorie :.asciz "fisierul %s are dimensiunea %ld\n"
.text
.global main
main:
	lea path, %edi
	push %edi
	call opendir
	mov %eax, director
	add $4, %esp
	push $path
	push $filePath
	call strcpy
	add $8, %esp
citire:
	push director
	call readdir
	cmp $0, %eax
	je et_exit
	mov %eax, %edx
	add $11, %edx
	#aici voi verifica daca este fisierul dot sau dot dot
	push $dot
	push %edx
	call strcmp
	add $8, %esp
	cmp $0, %eax
	je citire
	push $dotDot
	push %edx
	call strcmp
	add $8, %esp
	cmp $0, %eax
	je citire
	#aici vom concatena fisierul
	push %edx
	push $filePath
	call strcat
	add $8, %esp
	push $filePath
	push $format
	call printf
	add $8, %esp
	#aici vom face open
	mov $5, %eax
	mov $filePath, %ebx
	mov $0, %ecx
	int $0x80
	#aici vom face fstat
	mov %eax, descriptor
	push descriptor
	push $text
	call printf
	add $8, %esp
	mov $108, %eax
	mov descriptor, %ebx
 	lea statBuffer, %ecx
	int $0x80
	#aici o sa afisez memoria ca si test sa vad adca merge cum vreau eu
	lea statBuffer, %edx
	movl 20(%edx), %eax
	movl %eax, dimensiuneFisier
	push %eax
	push $filePath
	push $afisareMemorie
	call printf
	add $12, %esp
	#aici refacem filePath ca sa adaugam urmatoarele fisiere
	push $path
	push $filePath
	call strcpy
	add $8, %esp
	jmp citire

et_exit:
	mov director, %edi
 	push %edi
	call closedir
	add $4, %esp
	mov $1, %eax
	mov $0, %ebx
	int $0x80
