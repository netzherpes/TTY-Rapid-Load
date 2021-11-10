; Target assembler: cc65 v2.18.0 [--target none -C TTY RAPID LAOD.bin_cc65.cfg]
;***************************************************************
;* TTY RAPID LOAD                                              *
;* *****************************                               *
;* Markus P. Goenner, Buel 3205 Mauss, Switzerland             *
;*                                                             *
;* The program is fully relocatable. After you start           *
;* the program with the G Key, it answers with a               *
;* cr-lf. Enter the adress you wish to load the data.          *
;* LEading Zeros need not to be entered. A CR from you         *
;* the TTY proceed with a CR-LF and you are ready for          *
;* entering data in HEX Code.Just one byte after the           *
;* other. At the end of a line type CR. Type an ESC            *
;* and the program will answer with a dollar sign and          *
;* then you are back in the KIM monitor.                       *
;***************************************************************
         .setcpu "6502"
CR       =       $0d
ESC      =       $1b
DOLLAR   =       $24
INL      =       $f8
INH      =       $f9
POINTL   =       $fa
POINTH   =       $fb
CLEAR    =       $1c64
CRLF     =       $1e2f
GETCH    =       $1e5a
OUTCH    =       $1ea0
INCPT    =       $1f63
PACK     =       $1fac

         .org    $0000
         cld
         lda     #$00
         sta     INL
         sta     INH
         jsr     CRLF
ADDR:    jsr     GETCH
         cmp     #CR
         beq     DATA
         jsr     PACK
         beq     ADDR
DATA:    lda     INL
         sta     POINTL
         lda     INH
         sta     POINTH
LINE:    jsr     CRLF
INPUT:   jsr     GETCH
         cmp     #CR
         beq     LINE
         cmp     #ESC
         bne     STORE
         lda     #DOLLAR
         jsr     OUTCH
         jsr     CRLF
         jmp     CLEAR
STORE:   jsr     PACK
         bne     INPUT
         jsr     GETCH
         jsr     PACK
         ldy     #$00
         lda     INL
         sta     (POINTL),y
         jsr     INCPT
         clc
         bcc     INPUT
