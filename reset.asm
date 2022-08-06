.ifndef __RESET_ASM__
__RESET_ASM__ = 1

.include "ppu.inc"
.include "variables.inc"
.include "apu.inc"

.proc Reset
; Data initialization
  sei
	cld
  ldx #$FF
  txs
	inx
	stx PPU_CONTROL_REG
	stx PPU_MASK_REG
	stx DPCM_CONTROL_REG2
	bit PPU_STATUS_REG
@vblankwait1:
	bit PPU_STATUS_REG
	bpl @vblankwait1

	ldx #%10000000
.endproc
.endif