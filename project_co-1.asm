.data 
op: .space 4 
msg2: .asciiz"0- Exit \n1- Enter paraghraph ending with EOF \n2- list one char \n3- list two char \n4- list three char \n5- list all char \n"
final: .asciiz"exit the program \n"
freq: .space 1000	# Array of integers, 4 byte for each
n  :  .word  1000000   # Limit buffer size
str:  .space 1000000  # Array of characters, 1 byte for each
printProgramTerminated: .asciiz "\nProgram terminated.\n"
##edit for listall

freq_size: .word 1000
print_statistics_for: .asciiz "Statistics for:\n"
print_is: .asciiz " is "
#end edit for listall
##edit for list2
promptFirstChar: .asciiz "\nEnter first character: "
promptSecondChar: .asciiz "\nEnter second character: "
promptThirdChar:  .asciiz "\nEnter third character: "
printOccurrenceIs: .asciiz " occurrence is:  "
print1: .asciiz "statistics of the characters  "
print2: .asciiz " , "
print3: .asciiz " and "
print5: .asciiz "is "
printNewLine: .byte '\n'
charBuffer: .byte ' '
char1: .byte ' '
char2: .byte ' ' 
char3: .byte ' '
##end edit for list2
EOF:  .word 48
msg1: .asciiz"Please Enter Your Character \n"
char: .space 4
notvalid_msg:.asciiz"Please Enter a valid Option"
.text 
    main:
      li $v0 , 4         # system call code for print string "msg2"
      la $a0,msg2        # address of string to print "msg2"
      syscall            # print the string  "msg2" 
      
    while:
      addi $s0, $zero, 0      # intialize $s0 equel Zero 
      li $v0, 5               # system call code for getting intger number from user 
      syscall                 # take input from user 
      add $s0, $s0, $v0       # store the input in $s0 
      
      blt $s0,0,notvalid 
      bgt $s0,5,notvalid
      
      addi $t0,$zero ,0    # $t0  equal  0
      beq  $s0,$t0,exit   # if user write 0 in input  go to function exit
      
      addi $t0 , $zero ,1    # $t0 equal 1 
      beq  $s0 , $t0 , read #if user write input 1 go to function read 
      
      addi $t0 , $zero ,2 #$t0 equal 2
      beq  $s0 , $t0 , list1 #if user write input 1 go to function list1 
      
      addi $t0 , $zero ,3    #$t0 equal 3 
      beq  $s0 , $t0 , list2 #if user write input 1 go to function list2 
      
      addi $t0 , $zero,4 #$t0 equal 1 
      beq  $s0 , $t0 , list3 #if user write input 1 go to function list3 
       
      addi $t0 , $zero,5 #$t0 equal 1 
      beq  $s0 , $t0 , listall #if user write input 1 go to function list1 
      
      j while
    
    read:
   #getting user input
    
         reading:
	    li $v0, 8
	    la $a0, str
	    la $a1, n
	    syscall
	    
	    lb  $t1,str($zero)    #$t1 holds value    of str[0]        
	    lw  $t2,EOF           #t2 hold   value of EOF = 0      
	    beq $t1,$t2, exit_read       #if(str[0] == '0') end while loop
	    
	    
  
	  li $t0,0                #$t0 is i
	   
         stat:  lb   $t1, str($t0)       #$t1 holds value   of str[$t1]
          beq  $t1, $zero ,reading  #if(str[i]=='\0') end of for loop
          sll  $t1,$t1,2           #str[i]*4
          lw   $t2,freq($t1)       #$t2 holds the frequency of element at index $t1
          addi $t2,$t2,1           #$t2 freq[i] +1  
          sw   $t2,freq($t1)       #freq[i]=$t2
          addi $t0,$t0,1           #++i
          j  stat
        
   
    list1:
    
    li $v0 , 4         # system call code for print string "msg1"
    la $a0,msg1        # address of string to print "msg1"
    syscall            # print the string  "msg1" 
    
    #read character from user 
    li $v0,12          # system call code for take input character from user 
    syscall            # take input character 
    addi $t1,$v0, 0    # $t1 equal character from user 
    
    # print new line
    li $v0, 4
    la $a0, printNewLine
    syscall
    
    #print this character 
    li   $v0 , 11  
    addi $a0 , $t1, 0 
    syscall
    
    
    sll  $t1,$t1,2      # convert character byte to word 
    lw   $t2,freq($t1)  # get Freq of this character 
    
    # print "occurrence is"
    li $v0, 4
    la $a0, printOccurrenceIs
     syscall
    
   #print frequency of char 
    li   $v0,1
    addi $a0,$t2,0
    syscall
  
  # print new line
    li $v0, 4
    la $a0, printNewLine
    syscall
    
    j main  #jump to main function 
   
    list2:
        #first char
           # prompt first char
           li $v0, 4
           la $a0, promptFirstChar
           syscall
           # read first char
           li $v0, 12
           syscall
           # save first char to $t3
           addi $t3, $v0, 0
        #second char
           # prompt second char
           li $v0, 4
           la $a0, promptSecondChar
           syscall
           # read second char
           li $v0, 12
           syscall
           #save second char to $t4
           addi $t4, $v0, 0
        # print frequency of first char
           # print new line
           li $v0, 4
           la $a0, printNewLine
           syscall
           # print char again - set to buffer then from buffer to a0
           li $v0, 11
           addi $a0, $t3, 0
           syscall
           # print "occurrence is"
           li $v0, 4
           la $a0, printOccurrenceIs
           syscall
           # get occurrence value
           
           sll $t3, $t3, 2
           lw $t5, freq($t3)
           # print it
           li $v0, 1
           addi $a0, $t5, 0
           syscall
        # print frequency of second char
           # print new line
           li $v0, 4
           la $a0, printNewLine
           syscall
           # print second char
           li $v0, 11
           addi $a0, $t4, 0
           syscall
           # print "occurrence is"
           li $v0, 4
           la $a0, printOccurrenceIs
           syscall
           # get occurrence value
           sll $t4, $t4, 2
           lw $t5, freq($t4)
           # print it
           li $v0, 1
           addi $a0, $t5, 0
           syscall
        # print new line again
        li $v0, 4
        la $a0, printNewLine
        syscall
        j main
    list3:
    
    li $v0, 4
    la $a0, promptFirstChar
    syscall #enter first character :-
 
    li $v0, 12
    syscall #read char1 
    sb $v0, char1
    
    li $v0, 4
    la $a0, printNewLine
    syscall #new line
    
    li $v0, 4
    la $a0, promptSecondChar 
    syscall #enter second character :-
    
    li $v0, 12
    syscall #read char2
    sb $v0, char2
    
    
    li $v0, 4
    la $a0, printNewLine
    syscall #newline
    
    li $v0, 4
    la $a0, promptThirdChar
    syscall #enter third character
    
    li $v0, 12
    syscall #read char3
    sb $v0, char3
    
    li $v0, 4
    la $a0, printNewLine
    syscall #newline
    
    li $v0, 4
    la $a0, print1
    syscall #statistics of characters 
    
   li $v0, 11
   lb $a0, char1
   syscall #print first character
    
    li $v0, 4
    la $a0, print2
    syscall # ,
    
    li $v0, 11
    lb $a0, char2
    syscall #print second character
    
    li $v0, 4
    la $a0, print3
    syscall #and
    
    li $v0, 11
    lb $a0, char3
    syscall #print third character
    
    li $v0, 4
    la $a0, printNewLine
    syscall #newline
    
    li $v0, 4
    la $a0, print5
    syscall #is
    
    sll $t6, $t6, 2
    lw $t7, freq($t6)
    li $v0, 1
    addi $a0, $t7, 0
    syscall
    
    li $v0, 4
    la $a0, print2
    syscall # ,
    
    sll $t8, $t8, 2
    lw $t9, freq($t8)
    li $v0, 1
    addi $a0, $t9, 0
    syscall
    
    li $v0, 4
    la $a0, print2
    syscall # ,
    
    sll $t0, $t0, 2
    lw $t4, freq($t0)
    li $v0, 1
    addi $a0, $t4, 0
    syscall
    j main
   
     listall:
     # For loop to print statistics for all characters
     #print statistics for
     li $v0, 4
     la $a0, print_statistics_for
     syscall
     # Initialize the counter
     addi $t0, $zero, -4
     lw $s7, freq_size
     addi $t2, $zero, 0
     loop_list_all:
     	# Add 4 for $t0, to loop through freq array that holds integers (word: 4 byte)
    	addi $t0, $t0, 4
    	# Load element from freq array at index $t0
    	lw $t1, freq($t0)
    	# Exit the loop when we reached the size of the freq array
    	beq $t0, $s7, exit_list_all
    	# Loop again if $t1 equals zero (There is no letter)
    	beqz $t1, loop_list_all
    	# load the content of frequency($t0) to $t2, and shift it right by 2 (Divide it by 4)
    	srl $t2, $t0, 2
    	# Print the character
    	li $v0, 11
    	addi $a0, $t2, 0
    	syscall
    	
    	# Print "is"
    	li $v0, 4
    	la $a0, print_is
    	syscall
    	
    	# Print frequency
    	li $v0, 1
    	addi $a0, $t1, 0
    	syscall
    	
    	# print new line
    	li $v0, 11
    	lb $a0, printNewLine
    	syscall
    	j loop_list_all
    
     # Exit the loop
     exit_list_all:
    	 #j exit
    	 j main
    	 
     
    exit:
          li $v0, 4
          la $a0, printProgramTerminated
          syscall
          li $v0, 10
          syscall
    notvalid:
          li $v0, 4
          la $a0, notvalid_msg
          syscall
           # print new line
           li $v0, 4
           la $a0, printNewLine
           syscall
   exit_read:
         j main
     
