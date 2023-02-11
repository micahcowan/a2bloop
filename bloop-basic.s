.include "basic-utils.inc"
.include "a2-monitor.inc"

.export ASoftProg
.export ASoftEnd

.feature string_escapes

.macro delayFor N
line "FOR PS=1 TO ",.sprintf("%d",N),":NEXT"
.endmacro

ASoftProg:
;      1234567890123456789012345678901234567890
line "POKE ",.sprintf("%d",Mon_CSWL),",0"
line "POKE ",.sprintf("%d",Mon_CSWL+1),",64"
line "POKE ",.sprintf("%d",Mon_KSWL),",4"
line "POKE ",.sprintf("%d",Mon_KSWL+1),",64"
;
line "BS$=CHR$(8):B$=CHR$(2)"
BasLoopBack = LINE_NUMBER
.if 1
line "PRINT \"IT WAS A LONG, \";"
delayFor 300
line "PRINT \"LONG\";"
delayFor 100
line "FOR I=1 TO 5"
line "PRINT BS$;BS$;B$;\"O\";B$;\"NG\";"
delayFor 75
line "NEXT"
delayFor 300
lineP
lineP "DAY OF GRUELING WORK AT THE OFFICE."
lineP "MEL IS AT THE TABLE, EATING."

.else
lineP
lineP "WELCOME, YOUNG ONE, TO THE BEGINNING"
lineP "OF YOUR GREAT AND NOBLE QUEST. IT IS"
lineP "WITH GREAT PLEASURE THAT I WELCOME"
lineP "YOU TO THE LAND OF BIPPER-BOP."
lineP
lineP "MAY THE GREAT FIZZAZZ GUIDE YOUR WAY!"
lineP
.endif
line "INPUT ",'"',">",'"',";A$"
line "GOTO ",.sprintf("%d",BasLoopBack)
scrcode "RUN", $0D
ASoftEnd:

