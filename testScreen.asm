.ifndef __TEST_SCREEN_ASM__
__TEST_SCREEN_ASM__ = 1

.include "characters.inc"
.include "ppu.inc"
.include "variables.inc"

.proc renderTestScreen
	lda renderFlag
	bmi render_start
	rts
render_start:

	bit PPU_STATUS_REG
@vblankwait1:
	bit PPU_STATUS_REG
	bpl @vblankwait1

; スクリーンオフ
	lda	#%00001000
	sta	PPU_CONTROL_REG
	lda	#%00000110
	sta	PPU_MASK_REG

; Set default palette
	lda	#BG_PALETTE_TABLE_ADDRESS_HI
	sta	VRAM_ADDRESS_REG
	lda	#BG_PALETTE_TABLE_ADDRESS_LO
	sta	VRAM_ADDRESS_REG
	ldx	#$00
	ldy	#$10
copypal:
	lda	palette_set_1, x
	sta	VRAM_ACCESS_REG
	inx
	dey
	bne	copypal

; transfer to name table 1
	lda	#NAME_TABLE_1_ADDRESS_HI
	sta	VRAM_ADDRESS_REG
	lda	#NAME_TABLE_1_ADDRESS_LO
	sta	VRAM_ADDRESS_REG

; 画面描画
	lda #$04
	sta renderCounter
	ldx	#$00
render:
	ldy	#$F0
copymap:
	stx	VRAM_ACCESS_REG
	inx
	dey
	bne	copymap
	dec renderCounter
	bne render

; パレット選択
	ldy #ATTRIBUTE_TABLE_SIZE
	ldx #$00
attribute:
	stx VRAM_ACCESS_REG
	dey
	bne attribute
	
; 画面描画
	lda #$04
	sta renderCounter
	ldx	#$00
render2:
	ldy	#$F0
copymap2:
	stx	VRAM_ACCESS_REG
	inx
	dey
	bne	copymap2
	dec renderCounter
	bne render2

; パレット選択
	ldy #ATTRIBUTE_TABLE_SIZE
	ldx #$00
attribute2:
	stx VRAM_ACCESS_REG
	dey
	bne attribute2

; スクロール設定
	lda	scrollX
	sta	SCROLL_REG
	lda	scrollY
	sta	SCROLL_REG

	bit PPU_STATUS_REG
@vblankwait2:
	bit PPU_STATUS_REG
	bpl @vblankwait2

; スクリーンオン
	lda	#%00001000
	sta	PPU_CONTROL_REG
	lda	#%00011110
	sta	PPU_MASK_REG

	and #%01111111
	sta renderFlag
  rts

palette_set_1:
	.byte	$0f, $00, $02, $30
	.byte	$0f, $06, $16, $30
	.byte	$0f, $08, $18, $30
	.byte	$0f, $0a, $1a, $30
.endproc
.endif