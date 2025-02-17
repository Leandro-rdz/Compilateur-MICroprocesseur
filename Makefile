GRM=syn.y
LEX=lex.l
BIN=out

CC=gcc
CFLAGS=-Wall -g
LEX_C=flex
SYN_C=yacc


OBJ=

all: $(BIN)

%.o: %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

lex_compile:
	$(LEX_C) -o $(LEX).c $(LEX)
	$(CC) $(LEX).c -o $(BIN)

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) $(CPPFLAGS) $^ -o $@

clean:
	rm $(OBJ) $(LEX_OUT) 

