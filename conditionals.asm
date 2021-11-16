.data

var1: .word 10
var2: .word 16


.text

lw $t1, var1
lw $t0, var2

slt $t3, $t0, $t1

li $t5,0
li $t4,0
li $t6,1

or  $t7,$t5,0

bne $t3, 1, Else
sll $t5, $t1, 2
sub $t5, $t5, $t0
j End
 
Else:
srl $t5, $t0, 2
add $t5, $t5, $t1

End:
