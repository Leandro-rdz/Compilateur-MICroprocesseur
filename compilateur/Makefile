GRM = syn.y
LEX = lex.l
BIN = out/compiler
OUT_DIR = out

CC = gcc
CFLAGS = src/* -I src -Wall -g -Wno-unused-function -Wno-implicit-function-declaration
YFLAGS = -d -v
LEX_C = flex
SYN_C = yacc
TEST_FILE = test_files/test_io.c

all: $(OUT_DIR) $(BIN)

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

%.o: %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

lex_compile: $(OUT_DIR)
	$(LEX_C) $(LEX)  # Génère lex.yy.c
	mv lex.yy.c $(OUT_DIR)/lex.yy.c  # Déplace dans `out/`

syn_compile: lex_compile
	cd $(OUT_DIR) && $(SYN_C) $(YFLAGS) ../$(GRM)  # Génère y.tab.c et y.tab.h dans `out/`
	cd ..
	$(CC) $(CFLAGS) $(OUT_DIR)/y.tab.c $(OUT_DIR)/lex.yy.c -o $(BIN)

run:
	make syn_compile
	./$(BIN)

test:
	make clean
	clear
	make syn_compile
	./$(BIN) < $(TEST_FILE)
	cat $(OUT_DIR)/output.asm
	#cat $(OUT_DIR)/output.opcode
	python3 $(CURDIR)/cross-compil/cross-compilateur.py
	cat $(OUT_DIR)/output_vivado.vhdl

clean:
	rm -rf $(OUT_DIR)  # Supprime tout le dossier `out/`
