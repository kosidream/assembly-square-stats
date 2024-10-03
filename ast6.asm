
;  Description: This assembly program processes square side lengths given in ASCII/undecimal format,
;  converts them into integers, calculates their areas, and performs statistical analysis on the results.
;  The program then displays the sum, average, minimum, and maximum of the square areas in ASCII/undecimal format.
;

; =====================================================================
;  STEP #2
;  Macro to convert ASCII/undecimal value into an integer.
;  Reads <string>, convert to integer and place in <integer>
;  Assumes valid data, no error checking is performed.

;  Arguments:
;    %1 -> <string>, register -> string address
;    %2 -> <integer>, register -> result

;  Macro usgae
;    aUndec2int  <string-address>, <integer-variable>

;  Example usage:
;    aUndec2int    rbx, tmpInteger

;  For example, to get address into a local register:
;        mov    rsi, %1

;  To return a value, it might be:
;        mov    dword [%2], eax

;  Note, the register used for the macro call (rbx in this example)
;  must not be altered BEFORE the address is copied into
;  another register (if desired).

%macro    aUndec2int    2


;    YOUR CODE GOES HERE

    mov rsi, %1
        mov rax, 0
        mov rcx, 0

    convertLoopMacro:
        mov bl, [rsi]
        cmp bl, NULL
        je doneConversionMacro

        cmp bl, ' '
        je skipSpaceMacro

        cmp bl, 'X'
        je handleXMacro

        sub bl, '0'
        movzx rbx, bl
        jmp processDigitMacro

    handleXMacro:
        mov rbx, 10
        jmp processDigitMacro

    processDigitMacro:
        mov rax, rcx
        mov rdi, 11
        mul rdi
        mov rcx, rax
        add rcx, rbx

        inc rsi
        jmp convertLoopMacro

    skipSpaceMacro:
        inc rsi
        jmp convertLoopMacro

    doneConversionMacro:
        mov [%2], ecx


%endmacro

; =====================================================================
;  Macro to convert integer to undecimal value in ASCII format.
;  Reads <integer>, converts to ASCII/undecimal integer value into
;  a <string>, including inserting the terminating NULL.

;  Note, the macro is calling using RSI, so the macro itself should
;     NOT use the RSI register until is saved elsewhere.

;  Note, STR_LENGTH is available gloabbly and can be used as needed.

;  Arguments:
;    %1 -> <integer-variable>, value
;    %2 -> <string-address>, string address

;  Macro usage
;    int2aUndec    <integer-variable>, <string-address>

;  Example usage:
;    int2aUndec    dword [sqAreas+rsi*4], tempString

;  Within the macro, to get the passed value into a local register:
;        mov    eax, %1

%macro    int2aUndec    2


;    YOUR CODE GOES HERE
      mov eax, %1
        mov rdi, %2
        mov rcx, STR_LENGTH-1
        mov ebx, 11

    %%convertToUndecimalLoop:
        cmp eax, 0
        je %%doneConversion            ; If zero, we're done converting

        mov edx, 0
        div ebx
        cmp edx, 10
        jne %%notTen
        mov edx, 'X'
        jmp %%storeDigit

    %%notTen:
        add edx, '0'                  ; Convert remainder to ASCII

    %%storeDigit:
        sub rcx, 1                    ; Move to the next position in the string
        mov [rdi+rcx], dl

        cmp eax, 0                    ; Check if there are more digits
        jne %%convertToUndecimalLoop   ; Loop again for next digit

    %%doneConversion:
    %%fillLeadingSpaces:
        cmp rcx, 0
        je %%addNullTerminator
        mov byte [rdi+rcx-1], ' '      ; Fill leading spaces
        sub rcx, 1
        jmp %%fillLeadingSpaces

    %%addNullTerminator:
        mov byte [rdi+STR_LENGTH-1], 0

%endmacro

; =====================================================================
;  Simple macro to display a string to the console.
;  Count characters (excluding NULL).
;  Display string starting at address <stringAddr>

;  Macro usage:
;    printString  <stringAddr>

;  Arguments:
;    %1 -> <stringAddr>, string address

%macro    printString    1
    push    rax            ; save altered registers (cautionary)
    push    rdi
    push    rsi
    push    rdx
    push    rcx

    lea    rdi, [%1]        ; get address
    mov    rdx, 0            ; character count
%%countLoop:
    cmp    byte [rdi], NULL
    je    %%countLoopDone
    inc    rdi
    inc    rdx
    jmp    %%countLoop
%%countLoopDone:

    mov    rax, SYS_write        ; system call for write (SYS_write)
    mov    rdi, STDOUT        ; standard output
    lea    rsi, [%1]        ; address of the string
    syscall                ; call the kernel

    pop    rcx            ; restore registers to original values
    pop    rdx
    pop    rsi
    pop    rdi
    pop    rax
%endmacro

; =====================================================================
;  Initialized variables.

section    .data

; -----
;  Define standard constants.

TRUE        equ    1
FALSE        equ    0

EXIT_SUCCESS    equ    0            ; successful operation
NOSUCCESS    equ    1            ; unsuccessful operation

STDIN        equ    0            ; standard input
STDOUT        equ    1            ; standard output
STDERR        equ    2            ; standard error

SYS_read    equ    0            ; system call code for read
SYS_write    equ    1            ; system call code for write
SYS_open    equ    2            ; system call code for file open
SYS_close    equ    3            ; system call code for file close
SYS_fork    equ    57            ; system call code for fork
SYS_exit    equ    60            ; system call code for terminate
SYS_creat    equ    85            ; system call code for file open/create
SYS_time    equ    201            ; system call code for get time

LF        equ    10
SPACE        equ    " "
NULL        equ    0
ESC        equ    27

NUMS_PER_LINE    equ    5


; -----
;  Assignment #6 Provided Data

STR_LENGTH    equ    10            ; chars in string (inc NULL)

sideLens    db    "       2X", NULL, "       3X", NULL
        db    "      345", NULL, "      362", NULL
        db    "      372", NULL, "      38X", NULL
        db    "      400", NULL, "      411", NULL
        db    "      427", NULL, "      431", NULL
        db    "       45", NULL, "       X1", NULL
        db    "       23", NULL, "      137", NULL
        db    "      194", NULL, "      151", NULL
        db    "      10X", NULL, "      217", NULL
        db    "      234", NULL, "      24X", NULL
        db    "       59", NULL, "       7X", NULL
        db    "      267", NULL, "      281", NULL
        db    "      462", NULL, "       97", NULL
        db    "      512", NULL, "      52X", NULL
        db    "      532", NULL, "      548", NULL
        db    "      6X5", NULL, "      697", NULL
        db    "      632", NULL, "      648", NULL
        db    "      652", NULL, "      678", NULL
        db    "      711", NULL, "      719", NULL
        db    "      737", NULL, "      7X8", NULL
        db    "      192", NULL, "      322", NULL
        db    "      312", NULL, "      327", NULL
        db    "      245", NULL, "      290", NULL
        db    "      77X", NULL, "      827", NULL
        db    "      X50", NULL, "      X88", NULL

aUndecLength    db    "       46", NULL
length        dd    0

sqSum        dd    0
sqAve        dd    0
sqMin        dd    0
sqMax        dd    0

; -----
;  Misc. variables for main.

hdr        db    "-----------------------------------------------------"
        db    LF, ESC, "[1m", "CS 218 - Assignment #6", ESC, "[0m", LF
        db    "Square Calculations", LF, LF
        db    "Square Areas:", LF, NULL
sqshdr        db    LF, "Squares Sum:  ", NULL
sqahdr        db    LF, "Squares Ave:  ", NULL
sqminhdr    db    LF, "Squares Min:  ", NULL
sqmaxhdr    db    LF, "Squares Max:  ", NULL

newLine        db    LF, NULL
spaces        db    "   ", NULL


; =====================================================================
;  Uninitialized variables

section    .bss

tmpInteger    resd    1                ; temporary value

sqAreas        resd    55
sideLenInts    resd    55

lenString    resb    STR_LENGTH            ; bytes
tempString    resb    STR_LENGTH

sqSumString    resb    STR_LENGTH
sqAveString    resb    STR_LENGTH
sqMinString    resb    STR_LENGTH
sqMaxString    resb    STR_LENGTH


; **************************************************************

section    .text
global    _start
_start:

; -----
;  Display assignment initial headers.

    printString    hdr

; -----
;  STEP #1
;    Convert integer length, in ASCII/undecimal format to integer.
;    Do not use macro here...
;    Read string aUndecLength string, convert to integer, and store in length
;    Must complete this step before continuing.


;    YOUR CODE GOES HERE - done

      mov rsi, aUndecLength
    mov rax, 0
    mov rcx, 0

convertLoopUnsignedSkipSpaces:
    mov bl, [rsi]
    cmp bl, NULL
    je doneConversionUnsignedSkipSpaces

    cmp bl, ' '
    je skipSpace

    cmp bl, 'X'
    je handleXUnsignedSkipSpaces

    sub bl, '0'
    movzx rbx, bl
    jmp processDigitUnsignedSkipSpaces

handleXUnsignedSkipSpaces:
    mov rbx, 10
    jmp processDigitUnsignedSkipSpaces

processDigitUnsignedSkipSpaces:
    mov rax, rcx
    mov rdi, 11
    mul rdi
    mov rcx, rax
    add rcx, rbx

    inc rsi
    jmp convertLoopUnsignedSkipSpaces

skipSpace:
    inc rsi
    jmp convertLoopUnsignedSkipSpaces

doneConversionUnsignedSkipSpaces:
    mov [length], ecx

              
            ;    YOUR CODE GOES HERE- end




; -----
;  STEP #2
;  Convert side lengths from ASCII/undecimal format to integer.
;    Must complete this step before continuing.

    mov    ecx, dword [length]
    mov    rdi, 0                    ; index for array
    mov    rbx, sideLens                ; addr of string to cvt
cvtLoop:
    push    rbx                    ; safety push's
    push    rcx
    push    rdi

    aUndec2int    rbx, tmpInteger

    pop    rdi
    pop    rcx
    pop    rbx

    mov    eax, dword [tmpInteger]
    mov    dword [sideLenInts+rdi*4], eax        ; save for reference

    mul    eax                    ; ^2
    mov    dword [sqAreas+rdi*4], eax
    add    rbx, STR_LENGTH

    inc    rdi
    dec    ecx
    cmp    ecx, 0
    jne    cvtLoop

; -----
;  Display each the square areas array (five per line).

    mov    ecx, dword [length]
    mov    rsi, 0
    mov    r12, 0
printLoop:
    push    rcx                    ; safety push's
    push    rsi
    push    r12

    int2aUndec    dword [sqAreas+rsi*4], tempString

    printString    tempString
    printString    spaces

    pop    r12
    pop    rsi
    pop    rcx

    inc    r12
    cmp    r12, 5
    jne    skipNewline
    mov    r12, 0
    printString    newLine
skipNewline:
    inc    rsi

    dec    ecx
    cmp    ecx, 0
    jne    printLoop
    printString    newLine

; -----
;  STEP #3
;    Find square areas array stats (sum, min, max, and average).
;    Reads data from sqAreas[] array (set above).
;    Must complete this step before continuing.

        mov ecx, [length]
        mov edi, 0
        mov eax, 0
        mov ebx, [sqAreas]
        mov edx, ebx

    computeStatsLoop:
        mov esi, [sqAreas+edi*4]
        add eax, esi

        cmp esi, ebx
        jb updateMin
        jmp skipUpdateMin

    updateMin:
        mov ebx, esi

    skipUpdateMin:
        cmp esi, edx
        ja updateMax
        jmp skipUpdateMax

    updateMax:
        mov edx, esi

    skipUpdateMax:
        add edi, 1
        loop computeStatsLoop

        mov [sqSum], eax
        mov [sqMin], ebx
        mov [sqMax], edx

        mov ecx, [length]
        mov edx, 0
        div ecx
        mov [sqAve], eax


; -----
;  STEP #4
;    Convert sum to ASCII/Undecimal for printing.
;    Do not use macro here...
;    Must complete this step before continuing.

    printString    sqahdr                ; display header

;    Read square areas sum inetger (set above), convert to
;        ASCII/Undecimal and store in sqSumString.
;    The ASCII version of the number should be STR_LENGTH
;        (globally available constant) characters (including the NULL),
;        right justified with the appropriate number of leading blanks.


;    YOUR CODE GOES HERE
    mov eax, [sqSum]
    mov rdi, sqSumString
    mov rcx, STR_LENGTH-1
    mov ebx, 11

convertToUndecimalLoop:
    cmp eax, 0
    je doneConversion             ; Exit if no more digits

    mov edx, 0
    div ebx                      ; Divide by 11
    cmp edx, 10
    jne notTen
    mov edx, 'X'                 ; Handle 'X' for remainder 10
    jmp storeDigit

notTen:
    add edx, '0'                 ; Convert remainder to ASCII

storeDigit:
    sub rcx, 1
    mov [rdi+rcx], dl            ; Store character

    cmp eax, 0
    jne convertToUndecimalLoop

doneConversion:
fillLeadingSpaces:
    cmp rcx, 0
    je addNullTerminator
    mov byte [rdi+rcx-1], ' '     ; Fill with spaces
    sub rcx, 1
    jmp fillLeadingSpaces

addNullTerminator:
    mov byte [rdi+STR_LENGTH-1], 0 ; Add null terminator




;    print the sqSumString (set above).
    printString    sqSumString

; -----
;  STEP #5
;    Convert average, min, and max integers to ASCII/undecimal for printing.
;    Must complete this step before continuing.  :-)

    printString    sqshdr
    int2aUndec    dword [sqAve], sqAveString
    printString    sqAveString

    printString    sqminhdr
    int2aUndec    dword [sqMin], sqMinString
    printString    sqMinString

    printString    sqmaxhdr
    int2aUndec    dword [sqMax], sqMaxString
    printString    sqMaxString

    printString    newLine
    printString    newLine


; *****************************************************************
;  Done, terminate program.

last:
    mov    rax, SYS_exit
    mov    rdi, EXIT_SUCCESS
    syscall
