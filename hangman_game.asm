.MODEL SMALL
.STACK 100H
.DATA
    ; Game configuration
    MAX_TRIES       EQU 6                ; Maximum incorrect guesses allowed
    WORD_COUNT      EQU 10               ; Number of words in the word bank
    MAX_WORD_LEN    EQU 10               ; Maximum length of a word
    
    
    ;Welcome Page Data
    welcome_page_line_1  db 10,13, '                           **********************************$'
    welcome_page_line_2  db 10,13, '                           **            Welcome           **$'
    welcome_page_line_3  db 10,13, '                           **                              **$'
    welcome_page_line_4  db 10,13, '                           **              To              **$'
    welcome_page_line_5  db 10,13, '                           **                              **$'
    welcome_page_line_6  db 10,13, '                           **         HANGMAN GAME!        **$'
    welcome_page_line_7  db 10,13, '                           **                              **$'    
    welcome_page_line_9  db 10,13, '                           **********************************$'
    welcome_page_line_10 db 10,13, '                           __________________________________$'
    welcome_page_line_11 db 10,13, '$'

    ; Word bank with 10 words
    WORDS           DB 'COMPUTER ', 0     ; 8 chars + padding
                    DB 'HANGMAN  ', 0     ; 7 chars + padding
                    DB 'ASSEMBLY ', 0     ; 8 chars + padding
                    DB 'PROGRAM  ', 0     ; 7 chars + padding
                    DB 'KEYBOARD ', 0     ; 8 chars + padding
                    DB 'MONITOR  ', 0     ; 7 chars + padding
                    DB 'PROCESS  ', 0     ; 7 chars + padding
                    DB 'MEMORY   ', 0     ; 6 chars + padding
                    DB 'SYSTEM   ', 0     ; 6 chars + padding
                    DB 'CIRCUIT  ', 0     ; 7 chars + padding
    
    ; Game state variables
    CURRENT_WORD    DB MAX_WORD_LEN DUP(0)  ; Current word to guess
    WORD_LEN        DB 0                    ; Length of current word
    WORD_DISPLAY    DB MAX_WORD_LEN DUP('_'), '$' ; Display with _ for unrevealed letters
    GUESSED_LETTERS DB 26 DUP(0)            ; Tracks guessed letters (0=not guessed, 1=guessed)
    INCORRECT_TRIES DB 0                    ; Number of incorrect guesses
    CORRECT_GUESSES DB 0                    ; Number of correct guesses
    SCORE           DW 0                    ; Current score
    HIGH_SCORE      DW 0                    ; Highest score
    GAME_ACTIVE     DB 1                    ; 1 if game is active, 0 if over
    SEED            DW 0                    ; Random seed for word selection
    
    ; Display messages
    MSG_TITLE           DB '===== HANGMAN GAME =====', 0DH, 0AH, '$'
    MSG_WORD_PROMPT     DB 'Word: $'
    MSG_GUESSED         DB 'Guessed: $'
    MSG_TRIES           DB 'Tries left: $'
    MSG_ENTER_GUESS     DB 'Enter a letter: $'
    MSG_ALREADY_GUESSED DB 'You have already guessed this letter!', 0DH, 0AH, '$'
    MSG_CORRECT         DB 'Correct guess!', 0DH, 0AH, '$'
    MSG_INCORRECT       DB 'Incorrect guess!', 0DH, 0AH, '$'
    MSG_WIN             DB 'Congratulations! You won!', 0DH, 0AH, '$'
    MSG_LOSE            DB 'Game over! The word was: $'
    MSG_SCORE           DB 'Score: $'
    MSG_HIGH_SCORE      DB 'High Score: $'
    MSG_PLAY_AGAIN      DB 'Would you like to play again? (Y/N): $'
    MSG_THANKS          DB 'Thanks for playing!', 0DH, 0AH, '$'
    
    ; Hangman ASCII art stages
    HANGMAN0        DB '  +---+', 0DH, 0AH
                    DB '  |   |', 0DH, 0AH
                    DB '      |', 0DH, 0AH
                    DB '      |', 0DH, 0AH
                    DB '      |', 0DH, 0AH
                    DB '      |', 0DH, 0AH
                    DB '=========', 0DH, 0AH, '$'
                    
    HANGMAN1        DB '  +---+', 0DH, 0AH
                    DB '  |   |', 0DH, 0AH
                    DB '  O   |', 0DH, 0AH
                    DB '      |', 0DH, 0AH
                    DB '      |', 0DH, 0AH
                    DB '      |', 0DH, 0AH
                    DB '=========', 0DH, 0AH, '$'
                    
    HANGMAN2        DB '  +---+', 0DH, 0AH
                    DB '  |   |', 0DH, 0AH
                    DB '  O   |', 0DH, 0AH
                    DB '  |   |', 0DH, 0AH
                    DB '      |', 0DH, 0AH
                    DB '      |', 0DH, 0AH
                    DB '=========', 0DH, 0AH, '$'
                    
    HANGMAN3        DB '  +---+', 0DH, 0AH
                    DB '  |   |', 0DH, 0AH
                    DB '  O   |', 0DH, 0AH
                    DB ' /|   |', 0DH, 0AH
                    DB '      |', 0DH, 0AH
                    DB '      |', 0DH, 0AH
                    DB '=========', 0DH, 0AH, '$'
                    
    HANGMAN4        DB '  +---+', 0DH, 0AH
                    DB '  |   |', 0DH, 0AH
                    DB '  O   |', 0DH, 0AH
                    DB ' /|\  |', 0DH, 0AH
                    DB '      |', 0DH, 0AH
                    DB '      |', 0DH, 0AH
                    DB '=========', 0DH, 0AH, '$'
                    
    HANGMAN5        DB '  +---+', 0DH, 0AH
                    DB '  |   |', 0DH, 0AH
                    DB '  O   |', 0DH, 0AH
                    DB ' /|\  |', 0DH, 0AH
                    DB ' /    |', 0DH, 0AH
                    DB '      |', 0DH, 0AH
                    DB '=========', 0DH, 0AH, '$'
                    
    HANGMAN6        DB '  +---+', 0DH, 0AH
                    DB '  |   |', 0DH, 0AH
                    DB '  O   |', 0DH, 0AH
                    DB ' /|\  |', 0DH, 0AH
                    DB ' / \  |', 0DH, 0AH
                    DB '      |', 0DH, 0AH
                    DB '=========', 0DH, 0AH, '$'

.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    
    ; Seed random number generator with system time
    MOV AH, 2CH         ; Get system time
    INT 21H
    MOV SEED, DX        ; DX has centiseconds and seconds
    
START_GAME:
    ; Clear screen and reset game state
    CALL CLEAR_SCREEN 
    ;Printing Welcome Page
    mov ah, 09
    mov dx, offset welcome_page_line_1
    int 21h
    mov ah, 09
    mov dx, offset welcome_page_line_2
    int 21h
    mov ah, 09
    mov dx, offset welcome_page_line_3
    int 21h
    mov ah, 09
    mov dx, offset welcome_page_line_4
    int 21h
    mov ah, 09
    mov dx, offset welcome_page_line_5
    int 21h
    mov ah, 09
    mov dx, offset welcome_page_line_6
    int 21h
    mov ah, 09
    mov dx, offset welcome_page_line_7
    int 21h
    mov ah, 09
    mov dx, offset welcome_page_line_9
    int 21h
    mov ah, 09
    mov dx, offset welcome_page_line_10
    int 21h
    mov ah, 09
    mov dx, offset welcome_page_line_11
    int 21h
    CALL INIT_GAME
    
GAME_LOOP:
    ; Check if game is still active
    CMP GAME_ACTIVE, 0
    JE GAME_OVER
    
    ; Display game state
    CALL DISPLAY_GAME_STATE
    
    ; Get user input
    CALL GET_USER_INPUT
    
    ; Process the guess
    CALL PROCESS_GUESS
    
    ; Check win/lose condition
    CALL CHECK_GAME_STATUS
    
    ; Continue loop
    JMP GAME_LOOP
    
GAME_OVER:
    ; Display final game state
    CALL DISPLAY_GAME_STATE
    
    ; Ask to play again
    LEA DX, MSG_PLAY_AGAIN
    CALL PRINT_STRING
    
    ; play again or not? (Y/N)
    MOV AH, 1
    INT 21H
    
    
    CMP AL, 'Y'
    JE START_GAME
    CMP AL, 'y'
    JE START_GAME
    
    ; Exit game
    LEA DX, MSG_THANKS
    CALL PRINT_STRING
    
    ; Exit to DOS
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; Clear the screen
CLEAR_SCREEN PROC
    MOV AH, 0          ; Set video mode
    MOV AL, 3          ; Text mode 80x25
    INT 10H
    RET
CLEAR_SCREEN ENDP

; Initialize game state
INIT_GAME PROC
    ; Reset game state variables
    MOV INCORRECT_TRIES, 0    ; Reset incorrect tries counter
    MOV CORRECT_GUESSES, 0    ; Reset correct guesses counter
    MOV GAME_ACTIVE, 1        ; Set game as active
    MOV SCORE, 0              ; Reset score for new game
    
    ; Reset guessed letters array
    MOV CX, 26
    LEA SI, GUESSED_LETTERS
INIT_GUESSED_LOOP:
    MOV BYTE PTR [SI], 0
    INC SI
    LOOP INIT_GUESSED_LOOP
    
    ; Select a random word
    CALL SELECT_RANDOM_WORD
    
    ; Initialize word display with underscores
    MOV BX, 0
    MOV BL, WORD_LEN
    LEA SI, WORD_DISPLAY
INIT_DISPLAY_LOOP:
    MOV BYTE PTR [SI], '_'
    INC SI
    DEC BL
    JNZ INIT_DISPLAY_LOOP
    
    ; Terminate with '$'
    MOV BYTE PTR [SI], '$'
    
    ; Clear the screen again to ensure a fresh start
    CALL CLEAR_SCREEN
    
    RET
INIT_GAME ENDP

; Select a random word from the word bank
SELECT_RANDOM_WORD PROC
    ; Generate random number between 0 and WORD_COUNT-1
    MOV AX, SEED
    MOV CX, 8405h      ; Multiplier
    MUL CX             ; DX:AX = AX * CX
    ADD AX, 1          ; Increment
    MOV SEED, AX       ; Save new seed
    
    MOV DX, 0         ; Clear DX
    MOV CX, WORD_COUNT
    DIV CX             ; DX = remainder (0 to WORD_COUNT-1)
    
    ; Calculate offset to selected word
    MOV AX, DX
    MOV BX, MAX_WORD_LEN
    MUL BX             ; AX = word index * MAX_WORD_LEN
    
    ; Copy selected word to CURRENT_WORD
    LEA SI, WORDS
    ADD SI, AX         ; SI points to selected word
    LEA DI, CURRENT_WORD
    MOV CX, MAX_WORD_LEN
    
COPY_WORD_LOOP:
    MOV AL, [SI]
    MOV [DI], AL
    INC SI
    INC DI
    LOOP COPY_WORD_LOOP
    
    ; Calculate word length (stop at space or null)
    LEA SI, CURRENT_WORD
    MOV CX, 0
COUNT_WORD_LENGTH:
    MOV AL, [SI]
    CMP AL, 0          ; Check for null terminator
    JE WORD_LENGTH_DONE
    CMP AL, ' '        ; Check for space (padding)
    JE WORD_LENGTH_DONE
    INC CX
    INC SI
    JMP COUNT_WORD_LENGTH
    
WORD_LENGTH_DONE:
    MOV WORD_LEN, CL
    RET
SELECT_RANDOM_WORD ENDP

; Display current game state
DISPLAY_GAME_STATE PROC
    ; Clear screen before displaying new game state
    CALL CLEAR_SCREEN
    
    ; Display game title
    LEA DX, MSG_TITLE
    CALL PRINT_STRING
    
    ; Display hangman art based on incorrect tries
    MOV BL, INCORRECT_TRIES
    CMP BL, 0
    JE SHOW_HANGMAN0
    CMP BL, 1
    JE SHOW_HANGMAN1
    CMP BL, 2
    JE SHOW_HANGMAN2
    CMP BL, 3
    JE SHOW_HANGMAN3
    CMP BL, 4
    JE SHOW_HANGMAN4
    CMP BL, 5
    JE SHOW_HANGMAN5
    CMP BL, 6
    JE SHOW_HANGMAN6
    JMP HANGMAN_DONE
    
SHOW_HANGMAN0:
    LEA DX, HANGMAN0
    JMP SHOW_HANGMAN
SHOW_HANGMAN1:
    LEA DX, HANGMAN1
    JMP SHOW_HANGMAN
SHOW_HANGMAN2:
    LEA DX, HANGMAN2
    JMP SHOW_HANGMAN
SHOW_HANGMAN3:
    LEA DX, HANGMAN3
    JMP SHOW_HANGMAN
SHOW_HANGMAN4:
    LEA DX, HANGMAN4
    JMP SHOW_HANGMAN
SHOW_HANGMAN5:
    LEA DX, HANGMAN5
    JMP SHOW_HANGMAN
SHOW_HANGMAN6:
    LEA DX, HANGMAN6
    
SHOW_HANGMAN:
    CALL PRINT_STRING
    
HANGMAN_DONE:
    ; Display current score
    LEA DX, MSG_SCORE
    CALL PRINT_STRING
    MOV AX, SCORE
    CALL PRINT_NUMBER
    
    ; Display high score
    CALL PRINT_NEWLINE
    LEA DX, MSG_HIGH_SCORE
    CALL PRINT_STRING
    MOV AX, HIGH_SCORE
    CALL PRINT_NUMBER
    CALL PRINT_NEWLINE
    
    ; Display word progress
    LEA DX, MSG_WORD_PROMPT
    CALL PRINT_STRING
    LEA DX, WORD_DISPLAY
    CALL PRINT_STRING
    CALL PRINT_NEWLINE
    
    ; Display guessed letters
    LEA DX, MSG_GUESSED
    CALL PRINT_STRING
    
    ; Display all guessed letters
    MOV CX, 26         ; 26 letters in alphabet
    MOV BX, 0          ; Start with 'A'
DISPLAY_GUESSED_LOOP:
    LEA SI, GUESSED_LETTERS
    ADD SI, BX
    CMP BYTE PTR [SI], 1
    JNE SKIP_GUESSED
    
    ; Print the letter
    MOV DL, BL
    ADD DL, 'A'
    MOV AH, 2
    INT 21H
    MOV DL, ' '
    INT 21H
    
SKIP_GUESSED:
    INC BX
    LOOP DISPLAY_GUESSED_LOOP
    
    CALL PRINT_NEWLINE
    
    ; Display tries left
    LEA DX, MSG_TRIES
    CALL PRINT_STRING
    MOV DL, MAX_TRIES
    SUB DL, INCORRECT_TRIES
    ADD DL, '0'        ; Convert to ASCII
    MOV AH, 2
    INT 21H
    CALL PRINT_NEWLINE
    
    ; Check if game is over
    CMP GAME_ACTIVE, 0
    JE DISPLAY_GAME_OVER
    
    ; Game is still active, prompt for next guess
    LEA DX, MSG_ENTER_GUESS
    CALL PRINT_STRING
    JMP DISPLAY_DONE
    
DISPLAY_GAME_OVER:
    ; Check if player won
    MOV AL, WORD_LEN
    CMP CORRECT_GUESSES, AL
    JNE DISPLAY_LOSE
    
    ; Player won
    LEA DX, MSG_WIN
    CALL PRINT_STRING
    JMP DISPLAY_DONE
    
DISPLAY_LOSE:
    ; Player lost - show the actual word
    LEA DX, MSG_LOSE
    CALL PRINT_STRING
    
    ; Display the actual word (not the guessed version)
    MOV SI, 0
    MOV CL, WORD_LEN
SHOW_WORD_LOOP:
    CMP CL, 0
    JE SHOW_WORD_DONE
    MOV DL, CURRENT_WORD[SI]
    MOV AH, 2           ; Function to output a character
    INT 21H
    INC SI
    DEC CL
    JMP SHOW_WORD_LOOP
SHOW_WORD_DONE:
    CALL PRINT_NEWLINE
    
DISPLAY_DONE:
    RET
DISPLAY_GAME_STATE ENDP

; Get user input (a letter guess)
GET_USER_INPUT PROC
    ; Read a character
    MOV AH, 1
    INT 21H
    
    ; Convert to uppercase if it's a letter
    CMP AL, 'a'
    JB CHECK_UPPERCASE
    CMP AL, 'z'
    JA CHECK_UPPERCASE
    SUB AL, 32         ; Convert to uppercase
    
CHECK_UPPERCASE:
    ; Check if it's a valid uppercase letter
    CMP AL, 'A'
    JB GET_USER_INPUT  ; If below 'A', get input again
    CMP AL, 'Z'
    JA GET_USER_INPUT  ; If above 'Z', get input again
    
    ; Store the letter index (0-25) in BL
    SUB AL, 'A'
    MOV BL, AL
    
    ; Check if already guessed
    LEA SI, GUESSED_LETTERS
    MOV BH, 0
    ADD SI, BX
    CMP BYTE PTR [SI], 1
    JNE VALID_GUESS
    
    ; Already guessed this letter
    CALL PRINT_NEWLINE
    LEA DX, MSG_ALREADY_GUESSED
    CALL PRINT_STRING
    JMP GET_USER_INPUT
    
VALID_GUESS:
    ; Mark as guessed
    MOV BYTE PTR [SI], 1
    
    CALL PRINT_NEWLINE
    RET
GET_USER_INPUT ENDP

; Sleep/delay procedure
SLEEP_PROC PROC
    PUSH AX
    PUSH CX
    PUSH DX
    
    MOV CX, 0FH     ; High part of delay count (adjust for longer/shorter delay)
    MOV DX, 4240H   ; Low part of delay count - approx 1 second delay
    MOV AH, 86H     ; BIOS Delay function
    INT 15H         ; Call BIOS
    
    POP DX
    POP CX
    POP AX
    RET
SLEEP_PROC ENDP

; Process the guessed letter
PROCESS_GUESS PROC
    ; BL contains the index of the guessed letter (0-25)
    
    ; Check if the letter exists in the word
    LEA SI, CURRENT_WORD
    MOV CX, 0
    MOV CL, WORD_LEN
    MOV DH, 0          ; Flag for correct guess
    
CHECK_LETTER_LOOP:
    MOV AL, [SI]
    CMP AL, ' '        ; Skip spaces
    JE NEXT_LETTER
    SUB AL, 'A'        ; Convert to index (0-25)
    CMP AL, BL
    JNE NEXT_LETTER
    
    ; Found a match, update display
    MOV DH, 1          ; Set correct guess flag
    LEA DI, WORD_DISPLAY
    SUB SI, OFFSET CURRENT_WORD
    ADD DI, SI         ; DI points to corresponding position in display
    ADD SI, OFFSET CURRENT_WORD
    
    ; Update display with the letter
    MOV AL, BL
    ADD AL, 'A'
    MOV [DI], AL
    
    ; Increase correct guesses
    INC CORRECT_GUESSES
    
NEXT_LETTER:
    INC SI
    LOOP CHECK_LETTER_LOOP
    
    ; Check if any matches were found
    CMP DH, 1
    JE CORRECT_GUESS
    
    ; No matches found, increment incorrect tries
    INC INCORRECT_TRIES
    LEA DX, MSG_INCORRECT
    CALL PRINT_STRING
    
    ; Add delay after incorrect guess message
    CALL SLEEP_PROC
    
    JMP GUESS_PROCESSED
    
CORRECT_GUESS:
    ; Display correct guess message
    LEA DX, MSG_CORRECT
    CALL PRINT_STRING
    
    ; Add delay after correct guess message
    CALL SLEEP_PROC
    
    ; Update score (10 points per correct guess)
    ADD SCORE, 10
    
GUESS_PROCESSED:
    RET
PROCESS_GUESS ENDP

; Check if the game is won or lost
CHECK_GAME_STATUS PROC
    ; Check if player won (all letters guessed)
    MOV AL, WORD_LEN
    CMP CORRECT_GUESSES, AL
    JE GAME_WON
    
    ; Check if player lost (max tries reached)
    MOV AL, MAX_TRIES
    CMP INCORRECT_TRIES, AL
    JE GAME_LOST
    
    ; Game continues
    RET
    
GAME_WON:
    ; Player won
    MOV GAME_ACTIVE, 0
    
    ; Add bonus points for remaining tries
    MOV AL, MAX_TRIES
    SUB AL, INCORRECT_TRIES
    MOV AH, 0
    MOV BX, 20         ; 20 points per remaining try
    MUL BX
    ADD SCORE, AX
    
    ; Update high score if needed
    MOV AX, SCORE
    CMP AX, HIGH_SCORE
    JLE GAME_WON_DONE
    MOV HIGH_SCORE, AX
    
GAME_WON_DONE:
    RET
    
GAME_LOST:
    ; Player lost
    MOV GAME_ACTIVE, 0
    RET
CHECK_GAME_STATUS ENDP

; Utility: Print a string from DX
PRINT_STRING PROC
    PUSH AX            ; Save AX
    MOV AH, 9
    INT 21H
    POP AX             ; Restore AX
    RET
PRINT_STRING ENDP

; Utility: Print a newline
PRINT_NEWLINE PROC
    PUSH AX            ; Save AX
    PUSH DX            ; Save DX
    MOV DL, 0DH
    MOV AH, 2
    INT 21H
    MOV DL, 0AH
    INT 21H
    POP DX             ; Restore DX
    POP AX             ; Restore AX
    RET
PRINT_NEWLINE ENDP

; Utility: Print number in AX
PRINT_NUMBER PROC
    PUSH AX            ; Save registers
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV CX, 0          ; Digit counter
    MOV BX, 10         ; Divisor
    
    ; Handle zero case
    CMP AX, 0
    JNE CONVERT_LOOP
    MOV DL, '0'
    MOV AH, 2
    INT 21H
    JMP PRINT_NUMBER_DONE
    
CONVERT_LOOP:
    ; Exit if AX is 0
    CMP AX, 0
    JE PRINT_DIGITS
    
    ; Divide AX by 10
    MOV DX, 0
    DIV BX
    
    ; Push remainder (DX) to stack
    PUSH DX
    INC CX
    JMP CONVERT_LOOP
    
PRINT_DIGITS:
    ; Pop and print each digit
    CMP CX, 0
    JE PRINT_NUMBER_DONE
    POP DX
    ADD DL, '0'        ; Convert to ASCII
    MOV AH, 2
    INT 21H
    DEC CX
    JMP PRINT_DIGITS
    
PRINT_NUMBER_DONE:
    POP DX             ; Restore registers
    POP CX
    POP BX
    POP AX
    RET
PRINT_NUMBER ENDP

END MAIN
