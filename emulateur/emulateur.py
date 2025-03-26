import re

def execute_instruction(instruction, *args):
    if instruction == "ADD":
        print(f"Addition: {args[0]} + {args[1]} + {args[2]}")
    elif instruction == "MUL":
        print(f"Multiplication: {args[0]} * {args[1]} * {args[2]}")
    elif instruction == "SOU":
        print(f"Soustraction: {args[0]} - {args[1]} - {args[2]}")
    elif instruction == "DIV":
        print(f"Division: {args[0]} / {args[1]} / {args[2]}")
    elif instruction == "COP":
        print(f"Copy: {args[0]} to {args[1]}")
    elif instruction == "AFC":
        print(f"Assign: {args[0]} = {args[1]}")
    elif instruction == "LOAD":
        print(f"Load: {args[0]} to {args[1]}")
    elif instruction == "STORE":
        print(f"Store: {args[0]} to {args[1]}")
    elif instruction == "EQU":
        result = 1 if args[1] == args[2] else 0
        print(f"Equal: {args[0]} = {result}")
    elif instruction == "INF":
        result = 1 if args[1] < args[2] else 0
        print(f"Less Than: {args[0]} = {result}")
    elif instruction == "INFE":
        result = 1 if args[1] <= args[2] else 0
        print(f"Less Than or Equal: {args[0]} = {result}")
    elif instruction == "SUP":
        result = 1 if args[1] > args[2] else 0
        print(f"Greater Than: {args[0]} = {result}")
    elif instruction == "SUPE":
        result = 1 if args[1] >= args[2] else 0
        print(f"Greater Than or Equal: {args[0]} = {result}")
    elif instruction == "JMP":
        print(f"Jump to address: {args[0]}")
    elif instruction == "JMPF":
        print(f"Jump if not zero to address: {args[0]} if {args[1]} != 0")
    elif instruction == "PRI":
        print(f"Print what's in 0x{args[0]}")


with open('../compilateur/out/output.asm', encoding="utf-8") as f:
    for line in f:
        line = line.strip()
        print(" ### " + line)
        
        match = line.split(" ")
        if match:
            instruction = match[1]
            arg1 = int(match[2], 16) if len(match) > 2 and match[2] is not None else None
            arg2 = int(match[3], 16) if len(match) > 3 and match[3] is not None else None
            arg3 = int(match[4], 16) if len(match) > 4 and match[4] is not None else None

            if arg3 is not None:
                execute_instruction(instruction, arg1, arg2, arg3)
            else:
                execute_instruction(instruction, arg1, arg2)
