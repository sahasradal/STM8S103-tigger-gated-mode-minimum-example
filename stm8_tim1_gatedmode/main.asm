stm8/
	; works correctly. counts on PC6 low and stops counting on PC6 high, gated mode
	; timer1 base conts to 1 second and over flows to toggle LED on PD4. Initially
	; LED stays on. On grounding PC6 gated mode is triggered and PD4 staats toggle and stops on PC6 high
	#include "mapping.inc"
	#include "stm8s103f.inc"
	
	
	
	
	segment byte at 100 'ram1'
buffer1  ds.b
buffer2  ds.b
buffer3  ds.b
nibble1  ds.b	
pad1     ds.b	
state    ds.b	






	segment 'rom'
main.l
	; initialize SP
	ldw X,#stack_end
	ldw SP,X

	#ifdef RAM0	
	; clear RAM0
ram0_start.b EQU $ram0_segment_start
ram0_end.b EQU $ram0_segment_end
	ldw X,#ram0_start
clear_ram0.l
	clr (X)
	incw X
	cpw X,#ram0_end	
	jrule clear_ram0
	#endif

	#ifdef RAM1
	; clear RAM1
ram1_start.w EQU $ram1_segment_start
ram1_end.w EQU $ram1_segment_end	
	ldw X,#ram1_start
clear_ram1.l
	clr (X)
	incw X
	cpw X,#ram1_end	
	jrule clear_ram1
	#endif

	; clear stack
stack_start.w EQU $stack_segment_start
stack_end.w EQU $stack_segment_end
	ldw X,#stack_start
clear_stack.l
	clr (X)
	incw X
	cpw X,#stack_end	
	jrule clear_stack

infinite_loop.l
	
	mov CLK_CKDIVR,#$0  ; set max internal clock 16mhz
	bset TIM1_CCER1,#1  ; polarity low, detect low edge on TIM1 CHanel1 ,TI1
	ld a,#$00
	ld TIM1_PSCRH,a
	ld a,#$ff
	ld TIM1_PSCRL,a
	mov TIM1_SMCR,#$55	; TS = 101: TI1 as input ,SMS = 101: trigger reset mode
	bset TIM1_IER,#0	; enable update interrupt in interrupt register
	bset TIM1_CR1,#0	; enable timer1
	bset PD_DDR,#4		; PD4 output
	bset PD_CR1,#4		; fast mode
	bset PC_CR1,#6		; enable input and pull up, uncomment if falling edge needed
	RIM					; enable interrupts globally
	
here:
	jp here
	
	
	
	
	
	
	interrupt TIM1_ISR
TIM1_ISR
   bres TIM1_SR1,#6 ; clear interrupt flag
   bres TIM1_SR1,#0 ; clear interrupt flag
   bcpl PD_ODR,#4    ; each update interrupt at 4.09ms after counting 65535
   iret
	
	
	
	
	

	interrupt NonHandledInterrupt
NonHandledInterrupt.l
	iret

	segment 'vectit'
	dc.l {$82000000+main}									; reset
	dc.l {$82000000+NonHandledInterrupt}	; trap
	dc.l {$82000000+NonHandledInterrupt}	; irq0
	dc.l {$82000000+NonHandledInterrupt}	; irq1
	dc.l {$82000000+NonHandledInterrupt}	; irq2
	dc.l {$82000000+NonHandledInterrupt}	; irq3
	dc.l {$82000000+NonHandledInterrupt}	; irq4
	dc.l {$82000000+NonHandledInterrupt}	; irq5
	dc.l {$82000000+NonHandledInterrupt}	; irq6
	dc.l {$82000000+NonHandledInterrupt}	; irq7
	dc.l {$82000000+NonHandledInterrupt}	; irq8
	dc.l {$82000000+NonHandledInterrupt}	; irq9
	dc.l {$82000000+NonHandledInterrupt}	; irq10
	dc.l {$82000000+TIM1_ISR}   ; irq11{$82000000+NonHandledInterrupt}	; irq11
	dc.l {$82000000+NonHandledInterrupt}	; irq12
	dc.l {$82000000+NonHandledInterrupt}	; irq13
	dc.l {$82000000+NonHandledInterrupt}	; irq14
	dc.l {$82000000+NonHandledInterrupt}	; irq15
	dc.l {$82000000+NonHandledInterrupt}	; irq16
	dc.l {$82000000+NonHandledInterrupt}	; irq17
	dc.l {$82000000+NonHandledInterrupt}	; irq18
	dc.l {$82000000+NonHandledInterrupt}	; irq19
	dc.l {$82000000+NonHandledInterrupt}	; irq20
	dc.l {$82000000+NonHandledInterrupt}	; irq21
	dc.l {$82000000+NonHandledInterrupt}	; irq22
	dc.l {$82000000+NonHandledInterrupt}	; irq23
	dc.l {$82000000+NonHandledInterrupt}	; irq24
	dc.l {$82000000+NonHandledInterrupt}	; irq25
	dc.l {$82000000+NonHandledInterrupt}	; irq26
	dc.l {$82000000+NonHandledInterrupt}	; irq27
	dc.l {$82000000+NonHandledInterrupt}	; irq28
	dc.l {$82000000+NonHandledInterrupt}	; irq29

	end
