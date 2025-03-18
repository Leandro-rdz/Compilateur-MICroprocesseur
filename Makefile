GRM = syn.y
LEX = lex.l
BIN = out

CC = gcc
CFLAGS = compilateur/* -I compilateur -Wall -g -Wno-unused-function -Wno-implicit-function-declaration
YFLAGS = -d -v #-Wcounterexamples
LEX_C = flex
SYN_C = yacc
TEST_FILE = test_chiant.c

OBJ = 

all: $(BIN)

%.o: %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

lex_compile:
	$(LEX_C) -o $(LEX).c $(LEX)
	$(CC) $(LEX).c -o $(BIN)

syn_compile:
	$(LEX_C) $(LEX)
	$(SYN_C) $(YFLAGS) $(GRM)
	$(CC) $(CFLAGS) y.tab.c lex.yy.c -o $(BIN)

run:
	make syn_compile
	./$(BIN)
test:
	make syn_compile
	./$(BIN) < $(TEST_FILE)

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) $(CPPFLAGS) $^ -o $@

clean:
	rm -f $(OBJ) $(LEX).c $(BIN) y.tab.c lex.yy.c y.tab.h
