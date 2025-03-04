GRM = syn.y
LEX = lex.l
BIN = out

CC = gcc
CFLAGS = -Wall -g -Wno-unused-function -Wno-implicit-function-declaration
LEX_C = flex
SYN_C = yacc

OBJ =

all: $(BIN)

%.o: %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

lex_compile:
	$(LEX_C) -o $(LEX).c $(LEX)
	$(CC) $(LEX).c -o $(BIN)

syn_compile:
	$(LEX_C) $(LEX)
	$(SYN_C) -d -v $(GRM)
	$(CC) $(CFLAGS) y.tab.c lex.yy.c -o $(BIN)

run:
	make syn_compile
	./$(BIN)

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) $(CPPFLAGS) $^ -o $@

clean:
	rm -f $(OBJ) $(LEX).c $(BIN) y.tab.c lex.yy.c y.tab.h
