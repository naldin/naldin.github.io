; Filename: RCFSPIC.ASM

; Target Processor: Microchip PIC 16C84 
; Clock Frequency : 4 MHz
; Input           : Four R/C-receiver PWM-signals or serial pulse train
;                   tapped at Graupner/JR R/C transmitter and one
;                   toggle switch to select the adjust mode
; Output          : Control Signals for 4 Xicor X9C104
;                   digitally controlled Potentiometer
; Purpose         : R/C-receiver / Joystick Adapter 
;                   for IBM-PC compatible computers
;                   to control R/C Fligth simulators by original
;                   R/C-Transmitter
;
; Assembler       : Mircochip MPASM 1.21
;
; Version:        : 1.1
; Last Update     : 06.Jan.1996
; 
; Author          : Cord Johannmeyer    C_Jhm@t-online.de
;
; Changes         : 06.Jan.96 added Graupner/JR transmitter support
;                             (via trainer cord) 
; Copyright (C) 1994,1995
; Permission is granted to any individual or institution to use, 
; copy, or redistribute this software so long as it is not sold
; for profit, provided this copyright notice is retained.


; for use of four R/C-receiver PWM-signals comment out next line 
#define SERIAL          ;Graupner/JR transmitter interface

;
	list    p=16C84

	include "mpreg.h"
	
	org     0x10
;----------------------------------------------------------------------------        
; Register for DIVMUL

ACCaLO  equ     0x0c
ACCaHI  equ     0x0d
ACCbLO  equ     0x0e
ACCbHI  equ     0x0f
ACCcLO  equ     0x10
ACCcHI  equ     0x11
ACCdLO  equ     0x12
ACCdHI  equ     0x13
temp    equ     0x14
sign    equ     0x15
	
	include "divmul.asm"
;-----------------------------------------------------------------------------

#define F       1

#define RP0     0x05
#define RP1     0x06

#define TRISB   0x86 & 0x7f

; ===========  EEPROM ==================
#define EEDATA  0x08
#define EEADR   0x09
#define EECON1  0x88 & 0x7f
#define EECON2  0x89 & 0x7f
#define RD      0x00
#define WR      0x01
#define WREN    0x02
#define WRERR   0x03
#define EEIF    0x04

; ======================================

ERG     equ     0x16

MAX_0   equ     0x17
MAX_1   equ     0x18
MAX_2   equ     0x19
MAX_3   equ     0x1a

MIN_0   equ     0x1b
MIN_1   equ     0x1c
MIN_2   equ     0x1d
MIN_3   equ     0x1e

FAC_LO_0 equ    0x17
FAC_LO_1 equ    0x18
FAC_LO_2 equ    0x19
FAC_LO_3 equ    0x1a

FAC_HI_0 equ    0x1f
FAC_HI_1 equ    0x20
FAC_HI_2 equ    0x21
FAC_HI_3 equ    0x22

OLD_VAL_0 equ   0x23
OLD_VAL_1 equ   0x24
OLD_VAL_2 equ   0x25
OLD_VAL_3 equ   0x26

NEW_VAL equ     0x27
TEMP    equ     0x28
TEMP1   equ     0x29
CHAN1   equ     0x2A
CHAN2   equ     0x2B
CHAN3   equ     0x2C
CHAN4   equ     0x2D

;----------- Macros ----------------------------------------------------------

;=========== Abtast ===============
Abtast  macro   bit
	local   wtl,wth,loop
	
	clrf    ERG        

; syncronize, wait for low
wtl     btfsc   Port_A,bit
	goto    wtl

; wait for high 
wth     btfss   Port_A,bit
	goto    wth

; measure pulsewidth
; at 4MHz 1000us => ERG = 100
loop    incf    ERG,Same
	nop
	nop
	nop
	nop
	nop
	nop
	btfsc   Port_A,bit
	goto    loop
	endm

;======== write_eeprom ============
write_eeprom macro ADR, DAT
	movlw   ADR
	movwf   EEADR
	movf    DAT,W
	movwf   EEDATA
	call    write_ee
	endm
	
;======== read_eeprom =============
read_eeprom macro ADR, DAT
	movlw   ADR
	movwf   EEADR
	call    read_ee
	movf    EEDATA,W
	movwf   DAT
	endm

;======== min_max =================
min_max macro MIN, MAX
	local   tst_max, weiter
	movf    MIN,W           ; if (ERG < MIN)
	subwf   ERG,W
	btfsc   STATUS,0        ;   goto tst_max
	goto    tst_max         ; else
	movf    ERG,W           ;   MIN = ERG
	movwf   MIN
tst_max
	movf    ERG,W           ; if (MAX < ERG)
	subwf   MAX,W
	btfsc   STATUS,0        ;   goto next_just
	goto    weiter          ; else
	movf    ERG,W           ;   MAX = ERG
	movwf   MAX
weiter        
	endm

;======== Auswert =================
Auswert macro MIN, FAC_LO, FAC_HI
	movf    MIN,W           ; TMP = (ERG - MIN)
	subwf   ERG,W
	btfss   STATUS,0        ; IF(TMP < 0) TMP = 0
	clrw
	movwf   ACCaLO          ; NEW_VAL = TMP * FAC
	clrf    ACCaHI
	movf    FAC_LO,W
	movwf   ACCbLO
	movf    FAC_HI,W
	movwf   ACCbHI
	call    D_mpyS
	movlw   0x64            ; if(NEW_VAL > 100) NEW_VAL = 100
	subwf   ACCcHI,W
	movf    ACCcHI,W
	btfsc   STATUS,0
	movlw   0x64
	movwf   NEW_VAL
	endm

;======== Stellpoti ===============
Stellpoti macro OLD_VAL, INC
	local   negativ, positiv, rdy, ready
	
	subwf   OLD_VAL,W       ; TEMP = OLD_VAL - NEW_VAL
	movwf   TEMP
	btfsc   STATUS,2        ; if (TEMP == 0) Continue
	goto    ready
	btfsc   STATUS,0        ; if (TEMP < 0) goto negativ
				; Carry == 0 => Erg. negativ!!!!
	goto    positiv

negativ 
	bsf     Port_B,4        ; UP
	nop
	bcf     Port_B,INC      ; toggle CLK
	bsf     Port_B,INC
	incfsz  TEMP,F
	goto    negativ
	goto    rdy             ; else

positiv 
	bcf     Port_B,4        ; DOWN
	nop
	bcf     Port_B,INC      ; toggle CLK
	bsf     Port_B,INC
	decfsz  TEMP,F
	goto    positiv

rdy 
	movf    NEW_VAL,W
	movwf   OLD_VAL
ready
	endm

;----------- Subroutines -----------------------------------------

write_ee
	bsf     STATUS,RP0      ; Page 1 selektieren
	bcf     EECON1,EEIF
	bsf     EECON1,WREN
	movlw   0x55
	movwf   EECON2
	movlw   0xAA
	movwf   EECON2
	bsf     EECON1,WR
wait_ee btfss   EECON1,EEIF
	goto    wait_ee
	bcf     EECON1,WREN
	bcf     STATUS,RP0      ; auf Page 0 zurÅck
	return

read_ee
	bsf     STATUS,RP0      ; Page 1 selektieren
	bsf     EECON1,RD
	bcf     STATUS,RP0      ; auf Page 0 zurÅck
	return

;=========== calc_fac =======================================================;
; calculate scale
; in:
;       Differenz von MIN, MAX in W
; out:
;       FAC_HI,FAC_LO
; temp variable:
;       ACxxx

calc_fac
	movwf   ACCaLO          ; loads ACCa = DIF

; skalieren, FAC berechnen
	movlw   0x00            ; FAC = 0x6400 / DIF
	movwf   ACCaHI
;
	movlw   0x64            ; loads ACCb = 6400
	movwf   ACCbHI
	movlw   0x00            
	movwf   ACCbLO
;
	call    D_divS          ; remainder in ACCc. 

	return


IFDEF SERIAL

;=========== wait_gap =====================================================;
; wait for pulse gap, return when gap is detected
; in:
;       sample Port_A,0
; out:
;       -
; temp variable:
;       TEMP, TEMP1

wait_gap
	movlw   0x80            ; min gap length
	movwf   TEMP1
wgnext  movlw   0x06            ; sample rate 25us
	movwf   TEMP
wgloop  decfsz  TEMP,F
	goto    wgloop
	nop
;wg      btfss   Port_A,0       ;active low       
wg      btfsc   Port_A,0        ;active high
	goto    wait_gap
	decfsz  TEMP1,F
	goto    wgnext
	return

;=========== wait_hl =====================================================;
; wait for HIGH/LOW transition, then return
; in:
;       sample Port_A,0
; out:
;       W contains wait time in 0.01 ms
; temp variable:
;       TEMP, TEMP1

#define CNT  TEMP
#define LAST TEMP1

wait_hl
;        clrf    LAST           ; active low
	bsf     LAST,0          ; active high
	clrf    CNT

whloop  rrf     Port_A,W        ; shift bit 0 to carry
;        bc      whnext         ; active low
;        btfss   LAST,0
	bnc      whnext         ; active high
	btfsc   LAST,0
	goto    whnext1
	movf    CNT,W
	return
whnext  nop
	nop
whnext1 rlf     LAST,F
	incf    CNT,F
	goto    whloop

#undefine CNT
#undefine LAST

ENDIF

;----------- Main Program -----------------------------------------

main

	bsf     Port_B,0        ; CLK = 1
	bsf     Port_B,1        ; CLK = 1
	bsf     Port_B,2        ; CLK = 1
	bsf     Port_B,3        ; CLK = 1

	movlw   0x80
	bsf     STATUS,RP0      ; select page 1
	movwf   TRISB           ; define Bit 0..6 as output
	bcf     STATUS,RP0      ; back to page 0
	
;??????????????????????????????????        
;        call    wait_gap
;        call    wait_hl
;        call    wait_hl
;        movwf   CHAN1
;        call    wait_hl
;        movwf   CHAN2
;        call    wait_hl
;        movwf   CHAN3
;        call    wait_hl
;        movwf   CHAN4
;hldone
;??????????????????????????????????        

; adjust ?
	btfsc   Port_B,7
	goto    work

just  
	clrw
	movwf   MAX_0
	movwf   MAX_1
	movwf   MAX_2
	movwf   MAX_3

	movlw   0xFF
	movwf   MIN_0
	movwf   MIN_1
	movwf   MIN_2
	movwf   MIN_3

do_just
	
IFDEF SERIAL
	
	call    wait_gap
	call    wait_hl
	call    wait_hl
	movwf   CHAN1
	call    wait_hl
	movwf   CHAN2
	call    wait_hl
	movwf   CHAN3
	call    wait_hl
	movwf   CHAN4

	movf    CHAN1,W
	movwf   ERG
	min_max MIN_0, MAX_0
	
	movf    CHAN2,W
	movwf   ERG
	min_max MIN_1, MAX_1

	movf    CHAN3,W
	movwf   ERG
	min_max MIN_2, MAX_2

	movf    CHAN4,W
	movwf   ERG
	min_max MIN_3, MAX_3
	
ELSE

	Abtast  0               ; Result in ERG
	min_max MIN_0, MAX_0
	
	Abtast  1
	min_max MIN_1, MAX_1

	Abtast  2
	min_max MIN_2, MAX_2

	Abtast  3
	min_max MIN_3, MAX_3

ENDIF

	btfss   Port_B,7        ; Weiter messen ?
	goto    do_just

; Messen beendet        

	movf    MIN_0,W         ; DIF = MAX - MIN
	subwf   MAX_0,W
	call    calc_fac
; store MIN und FAC_LO, FAC_HI to EEPROM
	write_eeprom 0x00, MIN_0
	write_eeprom 0x01, ACCbHI       ;FAC_HI
	write_eeprom 0x02, ACCbLO       ;FAC_LO

	movf    MIN_1,W         ; DIF = MAX - MIN
	subwf   MAX_1,W
	call    calc_fac
; store MIN und FAC_LO, FAC_HI to EEPROM
	write_eeprom 0x03, MIN_1
	write_eeprom 0x04, ACCbHI       ;FAC_HI
	write_eeprom 0x05, ACCbLO       ;FAC_LO

	movf    MIN_2,W         ; DIF = MAX - MIN
	subwf   MAX_2,W
	call    calc_fac
; store MIN und FAC_LO, FAC_HI to EEPROM
	write_eeprom 0x06, MIN_2
	write_eeprom 0x07, ACCbHI       ;FAC_HI
	write_eeprom 0x08, ACCbLO       ;FAC_LO

	movf    MIN_3,W         ; DIF = MAX - MIN
	subwf   MAX_3,W
	call    calc_fac
; store MIN und FAC_LO, FAC_HI to EEPROM
	write_eeprom 0x09, MIN_3
	write_eeprom 0x0A, ACCbHI       ;FAC_HI
	write_eeprom 0x0B, ACCbLO       ;FAC_LO

	

work
	clrf    OLD_VAL_0       ; OLD_VAL = 0
	clrf    OLD_VAL_1       ; OLD_VAL = 0
	clrf    OLD_VAL_2       ; OLD_VAL = 0
	clrf    OLD_VAL_3       ; OLD_VAL = 0

; zero Poti

	movlw   0x64            ; 100 CountDown
	movwf   temp
	bcf     Port_B,4        ; DOWN
w1        
	bcf     Port_B,0        ; toggle CLK
	bsf     Port_B,0
	bcf     Port_B,1        ; toggle CLK
	bsf     Port_B,1
	bcf     Port_B,2        ; toggle CLK
	bsf     Port_B,2
	bcf     Port_B,3        ; toggle CLK
	bsf     Port_B,3

	decfsz  temp,F
	goto    w1

; read values from EEPROM
rec_ee
	read_eeprom 0x00, MIN_0
	read_eeprom 0x01, FAC_HI_0
	read_eeprom 0x02, FAC_LO_0

	read_eeprom 0x03, MIN_1
	read_eeprom 0x04, FAC_HI_1
	read_eeprom 0x05, FAC_LO_1

	read_eeprom 0x06, MIN_2
	read_eeprom 0x07, FAC_HI_2
	read_eeprom 0x08, FAC_LO_2

	read_eeprom 0x09, MIN_3
	read_eeprom 0x0a, FAC_HI_3
	read_eeprom 0x0b, FAC_LO_3

work_loop

IFDEF SERIAL
	
	call    wait_gap
	call    wait_hl
	call    wait_hl
	movwf   CHAN1
	call    wait_hl
	movwf   CHAN2
	call    wait_hl
	movwf   CHAN3
	call    wait_hl
	movwf   CHAN4

	movf    CHAN1,W
	movwf   ERG
	Auswert MIN_0, FAC_LO_0, FAC_HI_0
	Stellpoti OLD_VAL_0, 0
	
	movf    CHAN2,W
	movwf   ERG
	Auswert MIN_1, FAC_LO_1, FAC_HI_1
	Stellpoti OLD_VAL_1, 1

	movf    CHAN3,W
	movwf   ERG
	Auswert MIN_2, FAC_LO_2, FAC_HI_2
	Stellpoti OLD_VAL_2, 2

	movf    CHAN4,W
	movwf   ERG
	Auswert MIN_3, FAC_LO_3, FAC_HI_3
	Stellpoti OLD_VAL_3, 3

ELSE
	Abtast  0               ; ERG = ABTAST(0)
				; NEW_VAL = Auswert(ERG,MIN,FAC)
	Auswert MIN_0, FAC_LO_0, FAC_HI_0
	Stellpoti OLD_VAL_0, 0

	Abtast 1
	Auswert MIN_1, FAC_LO_1, FAC_HI_1
	Stellpoti OLD_VAL_1, 1

	Abtast 2
	Auswert MIN_2, FAC_LO_2, FAC_HI_2
	Stellpoti OLD_VAL_2, 2

	Abtast 3
	Auswert MIN_3, FAC_LO_3, FAC_HI_3
	Stellpoti OLD_VAL_3, 3
ENDIF

; only for Test Port_B,bit 5 toggle
	bsf     Port_B,5
	nop
	nop
	nop
	nop
	bcf     Port_B,5

; adjust ?
	btfsc   Port_B,7
	goto    work_loop
	goto    just


	org     0x000
	goto    main

	end


