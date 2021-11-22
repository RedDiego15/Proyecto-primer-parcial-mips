.data

precios: .float 1.40,1.00,1.20
acum: .float 0.0
fpconst2: .float 1.6
input: .asciiz "Ingrese valor \n"
.text
li $t1,0 #i=0

li $v0, 2
mov.s $f12, $f1 #imrpimir suma
syscall

forPrecios: 
	la $s0, precios #arreglo de precios
	li $t3,3 #constante length = 3
	
	slt $t4, $t1, $t3 # i<3 , 1 True, 0 False
	beq $t4,$zero,exit #if(0==0) False
	# $s0 = offset result
	# $s1 = matrix_size: 4
	# $s2 = float_size: 4
	# $s7 = base address of A
	#caculate offset
	sll $s1,$t1,2
	add $t2,$s0,$s1 
	lwc1 $f1 0($t2)
	
	#sll $t5, $t1,2	
	#add $t1,$s0,$t5 # La base del arreglo es precios
	#lwc1 $f0, 0($t5) #precios[i]
	#l.s $f1, fpconst
	#add.s $f2, $f0, $f1
	addi $t1,$t1,1 # i+1
	#li $v0, 2 #codigo imprimir float
	#mov.s $f12, $f1 #imrpimir suma float
	#syscall 
	j forPrecios


maquina:
	l.s $f1, acum
	li $v0, 4
	la $a0, input
	syscall	
	
	li $v0, 6	#pide que se ingrese un numero entero
	syscall
	#mtc1 $v0, $f0 	#mover v0 a f0
       	#cvt.s.w $f0, $f0 #convertir a float
       	
       	li $v0, 2 #imprimir float
       	mov.s $f12, $f0    	
       	syscall
       	mov.s $f13, $f0    
       	add.s $f1, $f0, $f1 #sumar 2 floats
       	
       	li $v0, 2 #imprimir suma float
       	mov.s $f12, $f1        	
       	syscall
	j maquina

funcion: 
	addi $sp,$sp,-4
	sw $ra,0($sp)
	move $t2, $a0
	li $v0, 1
	move $a0, $t2
	syscall
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra

li $v0, 2
mov.s $f12, $f1 #imrpimir suma
syscall
l.s $f2, fpconst2
li $v0, 2
mov.s $f12, $f2 #imrpimir suma
syscall
add.s $f3, $f1, $f2
li $v0, 2
mov.s $f12, $f3 #imrpimir suma
syscall




exit:
	lw $ra,0($sp)
	addi $sp,$sp,-4
	jr $ra



