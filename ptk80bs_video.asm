; Video Sync Gen. for TK-80BS clone
; 
; Device  : ATmega88
; Clock   : 20MHz
; FUSES   : LOW=0xE6 HIGH=0xDF EXTENDED=0xF9
; Date    : Oct. 11 2020
;

.include "m88def.inc"

; Register
.def temp = R16
.def lcnt = R17
.def xcnt = R18
.def ycnt = R19

.ORG 0x0000						;
	RJMP	RESET				;

RESET:

	LDI		temp,low(RAMEND)	; Set RAM End Address to Stack Pointer 
	OUT		SPL,temp			;
	LDI		temp,high(RAMEND)	;
	OUT		SPH,temp			;

	LDI		temp,0xFF			; Set OUTput PORT B
	OUT		DDRB,temp			;

	LDI		temp,0xFF			; Set OUTput PORT C
	OUT		DDRC,temp			;

	LDI		temp,0xFF			; Set OUTput PORT D
	OUT		DDRD,temp			;

	LDI		lcnt,0				;
	LDI		xcnt,0				;
	LDI		ycnt,0				;

	SBI		portB,0				;
	CBI		portB,4				;
	OUT		portC,ycnt			;
	OUT		portD,xcnt			;

; Main Loop
MAIN_LOOP:

	RCALL	EQ_PULSE			; 4clk + 1266clk
	RCALL	EQ_PULSE			; 4clk + 1266clk
	RCALL	EQ_PULSE			; 4clk + 1266clk
	RCALL	V_SYNC				; 4clk + 1266clk
	RCALL	V_SYNC				; 4clk + 1266clk
	RCALL	V_SYNC				; 4clk + 1266clk
	RCALL	EQ_PULSE			; 4clk + 1266clk
	RCALL	EQ_PULSE			; 4clk + 1266clk
	RCALL	EQ_PULSE			; 4clk + 1266clk

LOOP1:
	RCALL	BLACK_LINE			; 4clk + 1262clk 
	INC		lcnt				; 1clk
	CPI		lcnt,67				; 1clk
	BRNE	LOOP1				; 2clk/1clk
	NOP							; 1clk	

LOOP2:
	RCALL	VALID_LINE			; 4clk + 1260clk
	INC		ycnt				; 1clk
	OUT		portC,ycnt			; 1clk
	INC		lcnt				; 1clk
	CPI		lcnt,131			; 1clk
	BRNE	LOOP2				; 2clk/1clk

	SBI		portB,4				; 2clk

LOOP3:
	RCALL	VALID_LINE			; 4clk + 1260clk
	INC		ycnt				; 1clk
	OUT		portC,ycnt			; 1clk
	INC		lcnt				; 1clk
	CPI		lcnt,195			; 1clk
	BRNE	LOOP3				; 2clk/1clk

	CBI		portB,4				; 2clk

LOOP4:
	RCALL	BLACK_LINE			; 4clk + 1262clk 
	INC		lcnt				; 1clk
	CPI		lcnt,253			; 1clk
	BRNE	LOOP4				; 2clk/1clk

	LDI		lcnt,0				; 1clk
	LDI		ycnt,0				; 1clk

	RJMP	MAIN_LOOP			; 2clk


; EQ Pulse
EQ_PULSE:

	CBI		portB,1				; 2clk					   2clk

	LDI		temp,11				; 1clk
EQ_LOOP1:
	DEC		temp				; 1clk
	CPI		temp,0				; 1clk
	BRNE	EQ_LOOP1			; 2clk/1clk	44clk		  46clk			

	NOP							; 1clk
	NOP							; 1clk					  48clk

	SBI		portB,1				; 2clk					  50clk

	LDI		temp,146			; 1clk
EQ_LOOP2:
	DEC		temp				; 1clk
	CPI		temp,0				; 1clk
	BRNE	EQ_LOOP2			; 2clk/1clk 584clk		 634clk

	CBI		portB,1				; 2clk					 636clk

	LDI		temp,11				; 1clk
EQ_LOOP3:
	DEC		temp				; 1clk
	CPI		temp,0				; 1clk
	BRNE	EQ_LOOP3			; 2clk/1clk 44clk		 680clk

	NOP							; 1clk
	NOP							; 1clk					 682clk

	SBI		portB,1				; 2clk					 684clk

	LDI		temp,144			; 1clk					 
EQ_LOOP4:
	DEC		temp				; 1clk
	CPI		temp,0				; 1clk
	BRNE	EQ_LOOP4			; 2clk/1clk 576clk		1260clk

	NOP							; 1clk					1261clk														

	RET							; 5clk					1266clk 


; V SYNC
V_SYNC:
	CBI		portB,1				; 2clk					   2clk

	LDI		temp,134			; 1clk
VS_LOOP1:
	DEC		temp				; 1clk
	CPI		temp,0				; 1clk
	BRNE	VS_LOOP1			; 2clk/1clk 536clk		 538clk

	SBI		portB,1				; 2clk					 540clk

	LDI		temp,23				; 1clk
VS_LOOP2:
	DEC		temp				; 1clk
	CPI		temp,0				; 1clk
	BRNE	VS_LOOP2			; 2clk/1clk 92clk		 632clk

	NOP							; 1clk					 635clk

	CBI		portB,1				; 2clk					 637clk

	LDI		temp,134			; 1clk
VS_LOOP3:
	DEC		temp				; 1clk
	CPI		temp,0				; 1clk
	BRNE	VS_LOOP3			; 2clk/1clk 536clk		 1171clk

	SBI		portB,1				; 2clk					 1173clk

	LDI		temp,22				; 1clk
VS_LOOP4:
	DEC		temp				; 1clk
	CPI		temp,0				; 1clk
	BRNE	VS_LOOP4			; 2clk/1clk 88clk		 1261clk

	RET							; 5clk					 1266clk

; BLACK LINE
BLACK_LINE:
	CBI		portB,1				; 2clk					   2clk

	LDI		temp,23				; 1clk
BK_LOOP1:
	DEC		temp				; 1clk
	CPI		temp,0				; 1clk
	BRNE	BK_LOOP1			; 2clk/1clk 92clk		  94clk

	NOP							; 1clk
	NOP							; 1clk					  96clk

	SBI		portB,1				; 2clk					  98clk

	LDI		temp,24				; 1clk
BK_LOOP2:	
	DEC		temp				; 1clk
	CPI		temp,0				; 1clk
	BRNE	BK_LOOP2			; 2clk/1clk 96clk 		 194clk

	LDI		temp,255			; 1clk
BK_LOOP3:	
	DEC		temp				; 1clk
	CPI		temp,0				; 1clk
	BRNE	BK_LOOP3			; 2clk/1clk 1020clk 	1214clk

	LDI		temp,10				; 1clk
BK_LOOP4:	
	DEC		temp				; 1clk
	CPI		temp,0				; 1clk
	BRNE	BK_LOOP4			; 2clk/1clk 40clk 		1254clk

	NOP							; 1clk						
	NOP							; 1clk						
	NOP							; 1clk					1257clk

	RET							; 5clk					1262clk						


; VALID LINE
VALID_LINE:
	CBI		portB,1				; 2clk					   2clk

	LDI		temp,23				; 1clk
VA_LOOP1:
	DEC		temp				; 1clk
	CPI		temp,0				; 1clk
	BRNE	VA_LOOP1			; 2clk/1clk 92clk		  94clk

	NOP							; 1clk
	NOP							; 1clk					  96clk

	SBI		portB,1				; 2clk					  98clk

	LDI		temp,61				; 1clk
VA_LOOP2:	
	DEC		temp				; 1clk
	CPI		temp,0				; 1clk
	BRNE	VA_LOOP2			; 2clk/1clk 244clk 		 342clk

	CBI		portB,0				; 2clk					 344clk

 	; Xcount 3clk*256 = 768clk 
	OUT		portD,xcnt			; 1clk
	INC		xcnt				; 1clk
	NOP							; 1clk
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			; 1clk
	INC		xcnt				; 1clk
	NOP							; 1clk
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			; 1clk
	INC		xcnt				; 1clk
	NOP							; 1clk
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			; 1clk
	INC		xcnt				; 1clk
	NOP							; 1clk
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			; 1clk
	INC		xcnt				; 1clk
	NOP							; 1clk
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			; 1clk
	INC		xcnt				; 1clk
	NOP							; 1clk
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			; 1clk
	INC		xcnt				; 1clk
	NOP							; 1clk
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			; 1clk
	INC		xcnt				; 1clk
	NOP							; 1clk
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			; 1clk
	INC		xcnt				; 1clk
	NOP							; 1clk
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			; 1clk
	INC		xcnt				; 1clk
	NOP							; 1clk
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			; 1clk
	INC		xcnt				; 1clk
	NOP							; 1clk
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			; 1clk
	INC		xcnt				; 1clk
	NOP							; 1clk
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			; 1clk
	INC		xcnt				; 1clk
	NOP							; 1clk
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			; 1clk
	INC		xcnt				; 1clk
	NOP							; 1clk
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			; 1clk
	INC		xcnt				; 1clk
	NOP							; 1clk
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			; 1clk
	INC		xcnt				; 1clk
	NOP							; 1clk
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							
	OUT		portD,xcnt			
	INC		xcnt				
	NOP							; 768clk				1112clk

	SBI		portB,0				; 2clk					1114clk

	LDI		xcnt,0				; 1clk					1115clk	
	OUT		portD,xcnt			; 1clk					1116clk

	LDI		temp,34				; 1clk
VA_LOOP3:	
	DEC		temp				; 1clk
	CPI		temp,0				; 1clk
	BRNE	VA_LOOP3			; 2clk/1clk 136clk 		1252clk

	NOP							; 1clk
	NOP							; 1clk
	NOP							; 1clk					1255clk

	RET							; 5clk					1260clk						
