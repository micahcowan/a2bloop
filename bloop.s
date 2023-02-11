;#define CFGFILE apple2-asm.cfg

;#resource "basic-utils.inc"
;#resource "a2-monitor.inc"
;#link "load-and-run-basic.s"
;#link "bloop-basic.s"

.include "a2-monitor.inc"

.import LoadAndRunBasic

waitDefault = $80
waitSpeedy = $30
waitComma = $FF
waitPeriod = $FF
waitPeriodFactor = 3

.org $803
Start:
	jmp LoadAndRunBasic
        
.res $4000 - *

BloopOut:
	cld
	jmp _Out
BloopIn:
	cld
	jmp _In
_Out:
	pha
        tya
        pha
        txa
        pha
        ;
        ; Get A-reg back from stack
        tsx
        inx
        inx
        inx
        lda $100,x
        pha
          cmp #$82 ; Ctrl-B "suppress next"
          bne @ckSuppressed
          sta flagSuppressNext
          jmp @sFinish
@ckSuppressed:
	  bit flagSuppressNext
          bpl @noSuppress
        pla
        pha
          jsr Mon_COUT1
        pla
        pha
          jsr DoWait
          jmp @finish
@noSuppress:
          lda Mon_CH
          cmp SavedCH
          bne @normOut
          lda Mon_CV
          cmp SavedCV
          bne @normOut
@echoOut:
	pla
        pha
	  jsr Mon_COUT1
          cmp #$8D
          beq @skipLow
	  jsr LowBeep
@skipLow:
	  jmp @finish
@normOut:
	pla
        pha
	  jsr Mon_COUT1
          jsr DoBeep
        pla
        pha
          jsr DoWait
        ;
@finish:
	  lda #$00
          sta flagSuppressNext
@sFinish:
	  lda #$00
          sta SavedChar
	  lda #$FF
          sta SavedCH
          sta SavedCV
        pla
        pla
        tax
        pla
        tay
        pla
        ;
        rts
_In:
	jsr Mon_KEYIN
        sta SavedChar
        pha
          lda Mon_CV
          sta SavedCV
          lda Mon_CH
          sta SavedCH
        pla
        rts
flagSuppressNext:
	.byte $00
SavedChar:
	.byte $00
SavedCV:
	.byte $FF
SavedCH:
	.byte $FF

DoBeep:
	cmp #$A1
        bcc @noBeep
        jsr Beep1
@noBeep:
        rts

DoWait:
	ldx #1
	cmp #$AC ; ','
        bne @ckPd
        lda #waitComma
        bne @doIt
@ckPd:	cmp #$AE ; '.'
	beq @sentence
        cmp #$A1 ; '!'
        beq @sentence
        cmp #$BF ; '?'
        beq @sentence
        cmp #$BA ; ':'
        beq @sentence
        cmp #$BB ; ';'
	bne @default
@sentence:
	lda #waitPeriod
        ldx #waitPeriodFactor
        bne @doIt
@default:
        lda #waitDefault
@doIt:
	; ** if open-apple is pressed, speed
        ;    up the text
	bit $C061
        bpl :+
        lda #waitSpeedy
        ldx #1
:
        jsr Mon_WAIT
        dex
        bne @doIt
@end:
	;sta LastChar
        rts
LastChar:
	.byte $00

Beep1:
        ;
	ldy     #$0b
:
	lda     #$0f
	jsr     Mon_WAIT
	lda     SS_SPKR
	dey
	bne     :-
        rts
LowBeep:
        ;
	ldy     #$0b
:
	lda     #$10
	jsr     Mon_WAIT
	lda     SS_SPKR
	dey
	bne     :-
        rts