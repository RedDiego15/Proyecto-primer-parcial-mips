.data
coca_cola: .asciiz "1. coca cola $1.00\n"
fanta: .asciiz "2. Fanta $1.50\n"
sprite: .asciiz "3. sprite $0.75\n"
inca: .asciiz "4. Inca coola 10$\n"
agua: .asciiz "5. Agua 10$\n"
gatorade_naranja: .asciiz "6. Gatorade naranja 10$\n"
gatorade_lima: .asciiz "7. Gatorade lima 10$\n"
esporade_mandarina: .asciiz "8. Esporade mandarina 10$\n"
esporade_manzana: .asciiz "9. Esporade manzana 10$\n"
lipton_tea: .asciiz "10. liption tea 10$\n"
brisk_lemon_tea: .asciiz "11. brisk lemon tea 10$\n"

array: .word coca_cola, fanta, sprite
array_stock: .word 0,5,10  #El total máximo de nuestro stock es 15 
array_precios2: .float 1.00, 1.50, 0.75
input: .asciiz "Ingrese un numero del 1- 3 según el producto deseado\n"
billetes: .word 1,5,10,20
monedas: .word 5,1,10,25,50
temp: .space 4
welcome: .asciiz "Bienvenidos a la máquina expendedora de productos \n"
input_tipo_dinero: .asciiz "1. Ingreso Billetes\n2. Ingreso Monedas\n3. Terminar de pedir\nIngrese opcion\n "
input_billete: .asciiz "Ingrese valor del billete\n"
input_moneda: .asciiz "Ingrese valor de la moneda\n"
input_ingreso: .asciiz "Desea Ingresar mas Dinero?\n 1.Si\n 2.Ingrese cualquier otro digito\n "
numero_producto: .asciiz "Elija el número del producto\n"
msg_stock: .asciiz "Este producto tiene un stock menor a 15%\n"
msg_suma: .asciiz "la suma es \n"
.text

maquina:
	li $v0, 4 
	la $a0, welcome #imprimir mensaje para pedir el valor de la moneda
	syscall
	jal menudinero
	bne $t1,1,mostrarProductos
	li $v0, 4 #imprimir mensaje elija numero de producto
	la $a0, numero_producto
	syscall
	#jal manejoStock
	li $v0, 1
	move $a0, $s0 #imrpimir suma
	syscall
	
menudinero: 
	addi $sp,$sp,-4
	sw $ra,0($sp)
	li $v0, 4 #imprimir mensaje para pedir 1.biletes, 2.monedas o 3.terminar de pedir 
	la $a0, input_tipo_dinero
	syscall
	li $v0, 5 #Leer entero
	syscall
	move $a0, $v0 #a0 almacena las opciones de 1.billete 2.moneda o 3.salir 
	jal evaluarOpciones
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
	

evaluarOpciones: 
	addi $sp,$sp,-8
	sw $ra,0($sp)
	sw $a0,4($sp)
	#beq $t8,1,contarBilletes 
	beq $a0,2,sumarMonedas 		
	beq $a0,3,exit  #si ingresa 3 termina 	
	lw $ra,0($sp)
	lw $a0,4($sp)
	addi $sp,$sp,8
	jr $ra
	
ingresoMonedas:
	li $v0, 4 
	la $a0, input_moneda #imprimir mensaje para pedir el valor de la moneda
	syscall
	li $v0, 5 #Leer entero
	syscall
	move $s0, $v0 #s0 almacena el VALOR DE LA MONEDA
	li $v0, 4 #imprimir mensaje para pedir si desea ingresar más dinero 1, si 
	la $a0, input_ingreso 
	syscall
	li $v1, 5 #Leer entero
	syscall
	beq $v1,1,ingresoMonedas
	
sumarMonedas:
	addi $sp,$sp,-8
	sw $ra,0($sp)
	sw $a1,4($sp)
	li $v0, 4 
	la $a0, input_moneda #imprimir mensaje para pedir el valor de la moneda
	syscall
	li $v0, 5 #Leer entero
	syscall
	add $v1,$a1,$v0 #v1=a1(argumento1)+valoringresado(v0) SUMA TOTAL
	move $a1,$v1  #a1=v1
	li $v0, 4 #imprimir mensaje para pedir si desea ingresar más dinero
	la $a0, input_ingreso
	syscall
	li $v0, 5 #Leer entero
	syscall	
	beq $v0,1,loopIngresoMonedas #mientras sea igual a 1.Si (loopIngresoMonedas)
	#bne $v0,1, menudinero
	lw $ra,0($sp)
	lw $a1,4($sp)
	addi $sp,$sp,8
	jr $ra	
	
#funcion que muestra los productos
mostrarProductos:
	addi $sp,$sp,4
	sw $ra,0($sp)

	move $s1,$a0 	#en s1 almaceno el valor i 
	la $t0, array #arreglo de productos
	la $t6, array_stock #arreglo de stock
	li $t1,3	#longitud del array de productos
	slt $t2,$a0,$t1	  #t2=1 si i<length del array
	beq $t2,$zero,exit
	
	sll $t3,$a0,2	#i*4 para producto
	sll $t7,$a0,2 	#i*4 para stock
	add $t3,$t3,$t0
	add $t7,$t7,$t6
	addi $s1,$s1,1	#i+=1
	
	lw $t4,0($t3) #producto array[i]
	lw $t5,0($t7) #stock del producto  array_stock[i]
	
	#imprimo el producto
	li $v0, 4 #print string
	move $a0,$t4	#para que imprima el producto
	syscall	
	
	#calculo de porcentaje
	li $t8,100
	mult $t5,$t8
	mflo $t5 
	#ahora divido para el total de stock que hay 
	li $s2,15	#15 es el total de stock maximo de los productos 
	div $t5,$s2
	mflo $t5	#almaceno el valor del cociente
	
	li $t8,15	#porcentaje minimo 15%
	slt $t9,$t5,$t8 # t9 = 1 si el porcentaje de stock del producto es menor que 15%
	move $a0,$t9
	jal validaStock
	move $a0,$s1	
	lw $ra,0($sp)
	addi $sp,$sp,-4
	j mostrarProductos
	
	
exit:
	lw $ra,0($sp)
	addi $sp,$sp,-4
	jr $ra
	
	
validaStock:
	bne $a0,$zero,imprimirMsgStock
	jr $ra

imprimirMsgStock:
	li $v0, 4
	la $a0,msg_stock
	syscall
	jr $ra
	
	


manejoStock:
	sll $t0, $a0, 2
	#add $t1, $
	li $t5,0 #stock=0 
		 	
loopIngresoMonedas:
	jal sumarMonedas
	move $s0, $v1 #suma total
	li $v0,5	
	



buscarMonedas: 
	addi $sp,$sp,-4
	sw $ra,0($sp)
	la $t0, monedas #arreglo de billetes A=[5,1,10,25,50]
	li $t1,0 #i=0
	li $t2,5 #constante length = 5
	slt $t4, $t1, $t3 # i<4 , 1 True, 0 False
	#beq $t4,$zero,Maquina #if(1/0==0) Maquinasll $t5, $t1,2 
	add $t5,$t0,$t5 # La base del arreglo es monedas
	lw $t6, 0($t5) #monedas[i] 
	bne $t6,$s0,buscarMonedas #monedas[i] != $s0 es el valor igresado por consola 
	addi $t1,$t1,1 # i+1
	j buscarMonedas 
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
	
	

	

	

	
	





