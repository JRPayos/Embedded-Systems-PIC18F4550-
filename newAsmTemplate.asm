    #include P18F4550.inc
	; BLINKING LEDS RB0-7 
	config  FOSC = HS		
	config  CPUDIV = OSC1_PLL2
	config  PLLDIV = 1 
	config  PWRT = OFF
	config  BOR = OFF
	config  WDT = OFF
	config  MCLRE = ON
	config  LVP = OFF
	config  ICPRT = OFF
	config  XINST = OFF
	config  DEBUG = OFF
	config  FCMEN = OFF
	config  IESO = OFF
	config  LPT1OSC = OFF
	config  CCP2MX = ON
	config  PBADEN = OFF
	config  USBDIV = 2
	config  VREGEN = OFF

    org 0x0000
    BRA INIT
    org 0x0008
    RETFIE FAST
    org 0x0018
    RETFIE

    R1 equ 0x000
    R2 equ 0x001
    R3 equ 0x002
    SWA equ 0x003
    PAUSE_VAR equ 0x004

INIT:
    ; SW @ PORTA: RA0 & RA1
    MOVLW 0x0F				; value to configure A/D for digital I/O
    MOVWF ADCON1, ACCESS	; Analog-Digital connection
    MOVLW 0x07				; this value disables comparators and configure for digital I/O
    MOVWF CMCON, ACCESS		;Comparator Module connection
    MOVLW 0x03 ;0000 0011, RA0 and RA1
    MOVWF TRISA, ACCESS

    ; LED @ PORTB: 0-7

    CLRF TRISB, ACCESS
    
    CLRF PAUSE_VAR, ACCESS

MAIN:

    MOVF PORTA, W, ACCESS
    MOVWF SWA, ACCESS
  
    BRA ROUTE_SEQ1

ROUTE_SEQ1:
    
    RCALL PAUSE_LOOP
    RCALL DELAY
    RCALL DELAY
    
    MOVLW 0x0F
    MOVWF LATB, ACCESS
    
    RCALL PAUSE_LOOP
    RCALL DELAY
    RCALL DELAY
    
    MOVLW 0xF0
    MOVWF LATB, ACCESS
     
    MOVF PORTA, W, ACCESS   ;Updates the values 
    MOVWF SWA, ACCESS	    ;of SWA switches
    BTFSS SWA, 0x0, ACCESS   ; checker if RA0,SW1 is pressed/SET
    BRA ROUTE_SEQ1  ;loops this sequence indefinetly
    BRA ROUTE_SEQ2
	
ROUTE_SEQ2:
    
    RCALL PAUSE_LOOP
    RCALL DELAY
    RCALL DELAY
    
    MOVLW 0xCC
    MOVWF LATB, ACCESS
    
    RCALL PAUSE_LOOP
    RCALL DELAY
    RCALL DELAY
    
    MOVLW 0x33
    MOVWF LATB, ACCESS
       
    MOVF PORTA, W, ACCESS   ;Updates the values 
    MOVWF SWA, ACCESS	 
    BTFSS SWA, 0x0, ACCESS
    
    BRA ROUTE_SEQ2
    BRA ROUTE_SEQ1
    
PAUSE_LOOP:
    MOVF PORTA, W, ACCESS
    MOVWF SWA, ACCESS
    BTFSC SWA, 0x1, ACCESS
    BRA PAUSE
    RETURN
    
PAUSE:
    BTFSC PAUSE_VAR, 0x0, ACCESS
    CLRF PAUSE_VAR, ACCESS
    RCALL PLAY
    BSF PAUSE_VAR, 0x0, ACCESS
    
PLAY:
    MOVF PORTA, W, ACCESS
    MOVWF SWA, ACCESS
    BTFSC SWA, 0x1, ACCESS
    BRA PLAY
    RETURN


DELAY:
    CLRF R1, ACCESS
    CLRF R2, ACCESS
    MOVLW 0xFE
    MOVWF R3, ACCESS

DELAY_LOOP:
    INCFSZ R1, F, ACCESS
    BRA DELAY_LOOP
    INCFSZ R2, F, ACCESS
    BRA DELAY_LOOP
    INCFSZ R3, F, ACCESS
    BRA DELAY_LOOP
    RETURN

    end


