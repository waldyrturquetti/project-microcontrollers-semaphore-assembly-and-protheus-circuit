list p=16f877a
#include <p16f877a.inc>

;---PAGINA��O DE MEM�RIAS---
#DEFINE		BANK0	BCF		STATUS,RP0		
#DEFINE		BANK1	BSF		STATUS,RP0		
	
__CONFIG _CP_OFF & _WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_OFF & _LVP_OFF & _CPD_OFF
ERRORLEVEL  -302
	
	CBLOCK	0x20
			W_TEMP					; variable used for context saving
			STATUS_TEMP				; variable used for context saving
			PCLATH_TEMP				; variable used for context saving	
			TEMP1					; For delay routine
			TEMP2					; For delay routine
			TEMP3					; For delay routine
			TEMP4					; For delay routine
	ENDC

	;---INICIO DA APLICA��O---
	ORG     0x000				
  	GOTO    MAIN				
	
	;---INTERRUP��O---
	ORG     0x004
	;SALVAMENTO DE CONTEXTO				
	MOVWF   W_TEMP				
	SWAPF	STATUS,W			
	CLRF 	STATUS
	MOVWF	STATUS_TEMP			
	MOVF	PCLATH,W			
	MOVWF	PCLATH_TEMP			
	CLRF	PCLATH
	;**************************

	;CODIGO_ISR

	;**************************
	;RECUPERA CONTEXTO
EXIT_ISR:
	MOVF	PCLATH_TEMP,W		
	MOVWF	PCLATH				
	SWAPF   STATUS_TEMP,W		
	MOVWF	STATUS				
	SWAPF   W_TEMP,F
	SWAPF   W_TEMP,W			
	RETFIE	

MAIN:
	BANK0
	CLRF	PORTA	;LIMPA O PORTA
	CLRF	PORTB	;LIMPA O PORTB
	CLRF	PORTC	;LIMPA O PORTC
	CLRF	PORTD	;LIMPA O PORTD
	CLRF	PORTE	;LIMPA O PORTE

	BANK1
	MOVLW	B'00000000'		;Todas os PinosB ser�o OUT;	
	MOVWF	TRISA	
	MOVLW	B'00000000'		;Todas os PinosB ser�o OUT;	
	MOVWF	TRISB
	MOVLW	B'00000000'		;Todas os PinosC ser�o OUT;	
	MOVWF	TRISC
	MOVLW	B'00000000'		;Todas os PinosD ser�o OUT;	
	MOVWF	TRISD
	MOVLW	B'00000111'		;Todas os PinosE ser�o IN;	
	MOVWF	TRISE

	BANK0

LOOPING:						

	;*************************
	MOVLW	B'00001100' 	;1� Momento
	MOVWF	PORTA
	MOVLW	B'01100100'
	MOVWF	PORTB							;************************************************************
	MOVLW   B'00110001'						;Pinos:
	MOVWF   PORTC							;		76543210					
	MOVLW   B'10011001'						;	  B'00001010'
	MOVWF   PORTD							;Ou seja, as sa�das dos pinos 1 e 3 ser�o 1 e o resto 0 
	CALL	DELAY5S							;************************************************************
	CALL	DELAY5S
	CALL	DELAY5S
	CALL	DELAY5S
	;*************************

	;*************************
	MOVLW	B'00001010'		;2� Momento
	MOVWF	PORTA
	MOVLW	B'01100010'
	MOVWF	PORTB
	MOVLW	B'00110001'
	MOVWF	PORTC
	MOVLW   B'10011001'
	MOVWF   PORTD
	CALL	DELAY100M
	CALL	DELAY100M
	CALL	DELAY100M
	;*************************
	
	CALL TUDOVERMELHO 		;3� Momento

	;*************************
	MOVLW	B'00001001'		;4� Momento
	MOVWF	PORTA
	MOVLW	B'01100001'
	MOVWF	PORTB
	MOVLW   B'00110100'
	MOVWF   PORTC
	MOVLW   B'10011100'
	MOVWF   PORTD
	CALL	DELAY5S
	CALL	DELAY5S
	CALL	DELAY5S
	CALL	DELAY5S
	;*************************

	;*************************
	MOVLW	B'00001001'		;5� Momento
	MOVWF	PORTA
	MOVLW	B'01100001'
	MOVWF	PORTB
	MOVLW	B'00110010'
	MOVWF	PORTC
	MOVLW   B'10011010'
	MOVWF   PORTD
	CALL	DELAY100M
	CALL	DELAY100M
	CALL	DELAY100M
	;*************************

	CALL TUDOVERMELHO		;6� Momento
	CALL ATIVAPEDESTRE  	;7� Momento
	CALL TUDOVERMELHO		;8� Momento

	GOTO LOOPING	

;---FUN��ES---
;*************************************************************************
TUDOVERMELHO:				;Fun��o que deixa todos os Sem�foros com apenas o VERMELHO ATIVO
	MOVLW	B'00001001'		
	MOVWF	PORTA
	MOVLW	B'01100001'
	MOVWF	PORTB
	MOVLW	B'00110001'
	MOVWF	PORTC
	MOVLW   B'10011001'
	MOVWF   PORTD
	CALL	DELAY100M		;Totalizando 3OOmS
	CALL	DELAY100M
	CALL	DELAY100M
	RETURN
;*************************************************************************
;*************************************************************************
ATIVAPEDESTRE:
	MOVLW	D'5'	
	MOVWF	TEMP4
	
	MOVLW	B'00000001'		
	MOVWF	PORTA
	MOVLW	B'10011001'
	MOVWF	PORTB
	MOVLW	B'11001001'
	MOVWF	PORTC
	MOVLW   B'01100001'
	MOVWF   PORTD
	CALL	DELAY5S
	CALL	DELAY5S

LOOPPEDESTRE:
	MOVLW	B'00001001'		
	MOVWF	PORTA
	MOVLW	B'01100001'
	MOVWF	PORTB
	MOVLW	B'00110001'
	MOVWF	PORTC
	MOVLW   B'10011001'
	MOVWF   PORTD
	CALL	DELAY100M	
	MOVLW	B'00000001'		
	MOVWF	PORTA
	MOVLW	B'00000001'
	MOVWF	PORTB
	MOVLW	B'00000001'
	MOVWF	PORTC
	MOVLW   B'00000001'
	MOVWF   PORTD
	CALL 	DELAY100M
	
	DECFSZ	TEMP4, 1
	GOTO LOOPPEDESTRE
	RETURN
;*************************************************************************


;---DELAYS---
;*************************************************************************
DELAY5S:				;Fun��o de Delay de 5s
	MOVLW	0X07	;07
	MOVWF	TEMP1
	MOVLW	0X2F	;47
	MOVWF	TEMP2
	MOVLW	0X03	;03
	MOVWF	TEMP3
DELAY5SLOOP
	DECFSZ	TEMP1, 1	
	GOTO	$+2
	DECFSZ	TEMP2, 1
	GOTO	$+2
	DECFSZ	TEMP3, 1
	GOTO	DELAY5SLOOP
	GOTO	$+1
	GOTO	$+1
	GOTO	$+1
	RETURN
;*************************************************************************
;*************************************************************************
DELAY100M:				;Delay 100 mili routine
	MOVLW	0x1E	;30
	MOVWF	TEMP1
	MOVLW	0x4F	;79
	MOVWF	TEMP2
DELAYLOOP
	DECFSZ	TEMP1, 1
	GOTO	$+2
	DECFSZ	TEMP2, 1
	GOTO	DELAYLOOP
	GOTO	$+1
	NOP
	RETURN
;**************************************************************************


END 