;*******************************************************************
;                       Double Precision Division
;
;               ( Optimized for Code Size : Looped Code )
;
;*******************************************************************;
;   Division : ACCb(16 bits) / ACCa(16 bits) -> ACCb(16 bits) with
;                                               Remainder in ACCc (16 bits)
;      (a) Load the Denominator in location ACCaHI & ACCaLO ( 16 bits )
;      (b) Load the Numerator in location ACCbHI & ACCbLO ( 16 bits )
;      (c) CALL D_div
;      (d) The 16 bit result is in location ACCbHI & ACCbLO
;      (e) The 16 bit Remainder is in locations ACCcHI & ACCcLO
;
;   Performance :
;               Program Memory  :       037
;               Clock Cycles    :       310
;
;        NOTE :
;               The performance specs are for Unsigned arithmetic ( i.e,
;               with "SIGNED equ  FALSE ").
;
;*******************************************************************;
;
;

;*******************************************************************
SIGNED  equ     FALSE           ; Set This To 'TRUE' if the routines
;                               ; for Multiplication & Division needs
;                               ; to be assembled as Signed Integer
;                               ; Routines. If 'FALSE' the above two
;                               ; routines ( D_mpy & D_div ) use
;                               ; unsigned arithmetic.
;*******************************************************************
;       Double Precision Divide ( 16/16 -> 16 )
;
;         ( ACCb/ACCa -> ACCb with remainder in ACCc ) : 16 bit output
; with Quotiont in ACCb (ACCbHI,ACCbLO) and Remainder in ACCc (ACCcHI,ACCcLO).
;
;   NOTE  :  Before calling this routine, the user should make sure that
;            the Numerator(ACCb) is greater than Denominator(ACCa). If
;            the case is not true, the user should scale either Numerator
;            or Denominator or both such that Numerator is greater than
;            the Denominator.
;
;
D_divS
;
     IF   SIGNED
     CALL    S_SIGN
     ENDIF
;
	call    setup
	clrf    ACCcHI
	clrf    ACCcLO
dloop   bcf     STATUS,CARRY
	rlf     ACCdLO,1
	rlf     ACCdHI,1
	rlf     ACCcLO,1
	rlf     ACCcHI,1
	movf    ACCaHI,w
	subwf   ACCcHI,w          ;check if a>c
	btfss   STATUS,Z_bit
	goto    nochk
	movf    ACCaLO,w
	subwf   ACCcLO,w        ;if msb equal then check lsb
nochk   btfss   STATUS,CARRY    ;carry set if c>a
	goto    nogo
	movf    ACCaLO,w        ;c-a into c
	subwf   ACCcLO,1
	btfss   STATUS,CARRY
	decf    ACCcHI,1
	movf    ACCaHI,w
	subwf   ACCcHI,1
	bsf     STATUS,CARRY    ;shift a 1 into b (result)
nogo    rlf     ACCbLO,1
	rlf     ACCbHI,1
	decfsz  temp,1          ;loop untill all bits checked
	goto    dloop
;
    IF    SIGNED
	btfss   sign,MSB        ; check sign if negative
	retlw   0
	goto    neg_B          ; negate ACCa ( -ACCa -> ACCa )
    ELSE
	retlw   0
    ENDIF
;
;*******************************************************************
;
setup   movlw   .16             ; for 16 shifts
	movwf   temp
	movf    ACCbHI,w          ;move ACCb to ACCd
	movwf   ACCdHI
	movf    ACCbLO,w
	movwf   ACCdLO
	clrf    ACCbHI
	clrf    ACCbLO
	retlw   0
;
;*******************************************************************
;
neg_A   comf    ACCaLO,1          ; negate ACCa ( -ACCa -> ACCa )
	incf    ACCaLO,1
	btfsc   STATUS,Z_bit
	decf    ACCaHI,1
	comf    ACCaHI,1
	retlw   0
;
;*******************************************************************
;  Assemble this section only if Signed Arithmetic Needed
;
     IF    SIGNED
;
S_SIGN  movf    ACCaHI,W
	xorwf   ACCbHI,W
	movwf   sign
	btfss   ACCbHI,MSB        ; if MSB set go & negate ACCb
	goto    chek_A
;
	comf    ACCbLO          ; negate ACCb
	incf    ACCbLO
	btfsc   STATUS,Z_bit
	decf    ACCbHI
	comf    ACCbHI
;
chek_A  btfss   ACCaHI,MSB        ; if MSB set go & negate ACCa
	retlw   0
	goto    neg_A
;
     ENDIF
;

;*******************************************************************
;                    Double Precision Multiplication
;
;               ( Optimized for Code Size : Looped Code )
;
;*******************************************************************;
;   Multiplication : ACCb(16 bits) * ACCa(16 bits) -> ACCb,ACCc ( 32 bits )
;      (a) Load the 1st operand in location ACCaLO & ACCaHI ( 16 bits )
;      (b) Load the 2nd operand in location ACCbLO & ACCbHI ( 16 bits )
;      (c) CALL D_mpy
;      (d) The 32 bit result is in location ( ACCbHI,ACCbLO,ACCcHI,ACCcLO )
;
;   Performance :
;               Program Memory  :       033
;               Clock Cycles    :       333
;
;       Note : The above timing is the worst case timing, when the
;               register ACCb = FFFF. The speed may be improved if
;               the register ACCb contains a number ( out of the two
;               numbers ) with less number of 1s.
;               The performance specs are for Unsigned arithmetic ( i.e,
;               with "SIGNED equ  FALSE ").
;
;               The performance specs are for Unsigned arithmetic ( i.e,
;               with "SIGNED equ  FALSE ").
;
;*******************************************************************;

;*******************************************************************
;         Double Precision Subtraction ( ACCb - ACCa -> ACCb )
;
D_add   movf    ACCaLO,w        ; Addition ( ACCb + ACCa -> ACCb )
	addwf   ACCbLO,1        ;add lsb
	btfsc   STATUS,CARRY    ;add in carry
	incf    ACCbHI,1
	movf    ACCaHI,w
	addwf   ACCbHI,1        ;add msb
	retlw   0
;*******************************************************************
;               Double Precision Multiply ( 16x16 -> 32 )
;         ( ACCb*ACCa -> ACCb,ACCc ) : 32 bit output with high word
;  in ACCb ( ACCbHI,ACCbLO ) and low word in ACCc ( ACCcHI,ACCcLO ).
;
D_mpyS                           ;results in ACCb(16 msb's) and ACCc(16 lsb's)
;
     IF   SIGNED
     CALL    S_SIGN
     ENDIF
;
	call    setup
mloop   rrf     ACCdHI,1        ;rotate d right
	rrf     ACCdLO,1
	btfsc   STATUS,CARRY    ;need to add?
	call    D_add
	rrf     ACCbHI,1
	rrf     ACCbLO,1
	rrf     ACCcHI,1
	rrf     ACCcLO,1
	decfsz  temp,1          ;loop until all bits checked
	goto    mloop
;
    IF    SIGNED
	btfss   sign,MSB
	retlw   0
	comf    ACCcLO          ; negate ACCa ( -ACCa -> ACCa )
	incf    ACCcLO
	btfsc   STATUS,Z_bit
	decf    ACCcHI
	comf    ACCcHI
	btfsc   STATUS,Z_bit
neg_B   comf    ACCbLO          ; negate ACCb
	incf    ACCbLO
	btfsc   STATUS,Z_bit
	decf    ACCbHI
	comf    ACCbHI
	retlw   0
    ELSE
	retlw   0
    ENDIF
;
;*******************************************************************
;  Assemble this section only if Signed Arithmetic Needed
;
     IF    SIGNED
;
S_SIGN  movf    ACCaHI,W
	xorwf   ACCbHI,W
	movwf   sign
	btfss   ACCbHI,MSB        ; if MSB set go & negate ACCb
	goto    chek_A
;
	comf    ACCbLO          ; negate ACCb
	incf    ACCbLO
	btfsc   STATUS,Z_bit
	decf    ACCbHI
	comf    ACCbHI
;
chek_A  btfss   ACCaHI,MSB        ; if MSB set go & negate ACCa
	retlw   0
	goto    neg_A
;
     ENDIF
;
;*******************************************************************


