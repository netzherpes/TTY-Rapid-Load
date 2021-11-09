
;********************************************************
;* TTY RAPID LOAD                                       *
;* ******************************************************
;* Markus P. Goenner, Buel 3205 Mauss, Switzerland      *
;*                                                      *
;* The program is fully relocatable. After you start    *
;* the program with the G Key, it answers with a        *
;* cr-lf. Enter the adress you wish to load the data.   *
;* LEading Zeros need not to be entered. A CR from you  *
;* the TTY proceed with a CR-LF and you are ready for   *
;* entering data in HEX Code.Just one byte after the    *
;* other. At the end of a line type CR. Type an ESC     *
;* and the program will answer with a dollar sign and   *
;* then you are back in the KIM monitor.                *
;********************************************************
         .setcpu "6502"
         .org    $0000
         cld
         lda     #$00
         sta     $f8
         sta     $f9
         jsr     $1e2f
ADDR:    jsr     $1e5a
         cmp     #$0d
         beq     DATA
         jsr     $1fac
         beq     ADDR
DATA:    lda     $f8
         sta     $fa
         lda     $f9
         sta     $fb
LINE:    jsr     $1e2f
INPUT:   jsr     $1e5a
         cmp     #$0d
         beq     LINE
         cmp     #$1b
         bne     STORE
         lda     #$24
         jsr     $1ea0
         jsr     $1e2f
         jmp     $1c64

STORE:   jsr     $1fac
         bne     INPUT
         jsr     $1e5a
         jsr     $1fac
         ldy     #$00
         lda     $f8
         sta     ($fa),y
         jsr     $1f63
         clc
         bcc     INPUT

