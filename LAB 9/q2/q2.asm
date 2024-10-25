LCD_data equ P2
LCD_rs equ p0.0
LCD_rw equ p0.1
LCD_en equ p0.2

lcd_init:
mov A, #38H
acall lcd_command

mov A,#0CH
acall lcd_command

mov A,#01H
acall lcd_command

mov A,#06H
acall lcd_command
ret


lcd_command:
mov LCD_data,A
clr LCD_rs
clr LCD_rw
setb LCD_en
acall delay
clr LCD_en
acall delay
ret

lcd_senddata:


mov LCD_data,a
setb LCD_rs
clr LCD_rw
setb LCD_en
acall delay
clr LCD_en
acall delay
acall delay
ret

delay: mov r0, #10
loop2: mov r1,#255
loop1:djnz r1,loop1
djnz r0,loop2
ret

org 500h

ljmp main

org 520h
main:

mov P2,#00h
acall delay
acall delay
acall lcd_init
acall delay
acall delay
acall delay

mov p1, #00h
mov tmod, #01h

ReadNibble:
loop: ; Routine to read a nibble and confirm from user
clr p1.4
clr p1.5
clr p1.6
clr p1.7

;configure the port P1.0-P1.3 as input (to configure a port as input, set it) and turn on all 4 leds (to indicate program is ready to accept input)
setb p1.0;
setb p1.1;
setb p1.2;
setb p1.3;

cpl p1.4
cpl p1.5
cpl p1.6
cpl p1.7
;wait for 5 sec during which user can give input through switches
acall delay11
acall delay11
acall delay11
acall delay11
acall delay11
;turn off all LEDS
clr p1.4
clr p1.5
clr p1.6
clr p1.7
;save the read value in a register
mov a,p1

rl a
rl a
rl a
rl a
mov r1,a
;wait for one sec
acall delay11
;show the read value on LEDs
mov p1,r1
;wait for 5 sec (during this time delay, user can put all switches to OFF position to signal that the read value is correct and routine can proceed to next step)
acall delay11
acall delay11
acall delay11
acall delay11
acall delay11


;clear leds
clr p1.4
clr p1.5
clr p1.6
clr p1.7

setb p1.0;
setb p1.1;
setb p1.2;
setb p1.3; 

cpl p1.4
cpl p1.5
cpl p1.6
cpl p1.7

acall delay11
acall delay11
acall delay11
acall delay11
acall delay11

clr p1.4
clr p1.5
clr p1.6
clr p1.7

;read the input from switches
mov a,p1
rl a
rl a
rl a
rl a
mov r2,a
acall delay11
mov p1,r2
acall delay11
acall delay11
acall delay11
acall delay11
acall delay11

clr p1.4
clr p1.5
clr p1.6
clr p1.7
;if read value < or > 00h go to loop
;;;;;;;;;;;;;;;;;;;;;;
mov a,r2
rr a
rr a
rr a
rr a
add a,r1
add a,#02h
mov r5,a
;;extracting lower
ANL a,#0FH 
;;adding 30h
add a,#30h
mov r3,a
;;exracting higher
mov a,r5
ANL a,#0F0H 
;;adding 30h
rr a
rr a
rr a
rr a
add a,#30h
mov r4,a

mov r6,#0h
jc op

mov a,r6
add a,#30h
mov r6,a
;;;;;;;;;;;;;;;;;;;
mov a,#082h
acall lcd_command
acall delay
mov a,r4
acall lcd_senddata
acall delay

mov a,#083h
acall lcd_command
acall delay
mov a,r3
acall lcd_senddata
acall delay


mov a,#081h
acall lcd_command
acall delay
mov a,r6
acall lcd_senddata
acall delay
;otherwise return and store previously read nibble in location 60H (lower 4 bits).
here: sjmp here




delay11: mov r0, #16H
mov tl0, #00h
mov th0, #00h
setb tr0

timerloop: jnb tf0, timerloop
clr tf0
djnz r0, timerloop
clr tr0
ret

op:mov r6,#01h
ret