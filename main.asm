.setcpu		"6502"
.autoimport	on

.include "variables.inc"
.include "joypad.inc"

; iNESヘッダ
.segment "HEADER"
	.byte	"NES", $1A	      ; "NES" Header
	.byte	$02			          ; PRG-BANKS
	.byte	$01			          ; CHR-BANKS
	.byte	%00000001         ; V-Mirroring
	.byte	$00 | %0000
	.byte	$00 | %0000
  .byte $00
  .byte %00000000
  .byte %00000000
  .byte $00, $00, $00, $00

.segment "STARTUP"
; SPU initialization
.include "reset.asm"

	jmp render_start

mainLoop:
  inc counter

  lda #%00000001
  sta JOYPAD1_REG
  sta pad1_status
  sta pad2_status
  lsr
  sta JOYPAD1_REG
loadPadStatus:
  lda JOYPAD1_REG
  lsr
  rol pad1_status

  lda JOYPAD2_REG
  lsr
  rol pad2_status
  bcc loadPadStatus


  ldx #$00
if_right_is_pressed:
  lda #%00000001
  bit pad1_status
  beq if_left_is_pressed
  lda #$10
  adc scrollX
  sta scrollX
  ldx #%10000000
  jmp if_up_is_pressed
if_left_is_pressed:
  lda #%00000010
  bit pad1_status
  beq if_up_is_pressed
  lda #$EF
  adc scrollX
  sta scrollX
  ldx #%10000000
  jmp if_up_is_pressed
if_up_is_pressed:
  lda #%00000100
  bit pad1_status
  beq if_down_is_pressed
  lda #$10
  adc scrollY
  sta scrollY
  ldx #%10000000
  jmp render_start
if_down_is_pressed:
  lda #%00001000
  bit pad1_status
  beq render_start
  lda #$EF
  adc scrollY
  sta scrollY
  ldx #%10000000

render_start:
	stx renderFlag
  jsr renderTestScreen
  jmp mainLoop

.include "testScreen.asm"

.segment "VECINFO"
	.word	$0000
	.word	Reset
	.word	$0000

; Load pattern tables
.segment "CHARS"
	.incbin	"character01.chr"
