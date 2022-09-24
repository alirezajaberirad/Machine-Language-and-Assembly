# Machine-Language-and-Assembly
 This repository includes all the projects and assignment of Machine Language and Assembly course - Spring 2021

## Binary Coded Decimal(BCD) to Binary Converter
The title of this assignment is obvious, a BCD to binary number converter was implemented in Assembly language.

## Number Properties and Operations
This section is a collection of codes written in Assembly for checking or generating mathematical properties or doing some math operations in Assembly.
### Least Common Multiple(lcm)
This code calculates the LCM of the numbers that are in rax and rbx registers and stores the result in rdx register.
### Greatest Common Divisor(gcd)
This code calculates the GCD of the numbers that are in rax and rbx registers and stores the result in rdx register.
### Complete Number Checker(complete)
This piece of code checks whether the number that is in rax register is a complete number or not. If the stored number is complete then it will print all of its divisors.
### Prime Number Checker(prime)
This code determines if the number stored in rax register is prime or not.
### Adding Digits of a Number(digitAdd)
In this code the summation of the number stored in rax register will be calculated and then stored in rdx register.
### Adding Digits of a Number++ (digitAddEo)
In this code the summation of even and odd digits of a number will be calculated seperately and respectively, the results will be stored in rbx and rdx registers.
### Reverse Bits (reverseBit)
This code will reverse the orders of the bits of the number in rdx:rax then will store the result in r8:r9.
### Counting 1 Bits (countOne)
In this piece of code, the number of bits that are 1 in rax register will be counted and stored in bl register.
### Counting 1 Bits++ (countOneM)
This code counts the number of bits that are 1 in the memory from the address that is stored in rsi register to the address that is stored in rdi register. Ultimately, the result will be stored in rax register.