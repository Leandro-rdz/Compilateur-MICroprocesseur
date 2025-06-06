import os

debug = 0

# Table des opcodes
OPCODES = {
    "NOP": 0x00,
    "ADD": 0x10,
    "SOU": 0x11,
    "MUL": 0x12,
    "DIV": 0x13,
    "AND": 0x14,
    "OR":  0x15,
    "XOR": 0x16,
    "NOT": 0x17,
    "INF": 0x18,
    "INFE":0x19,
    "SUP": 0x1A,
    "SUPE":0x1B,
    "EQU": 0x1C,
    "COP": 0x20,
    "AFC": 0x21,
    "JMP": 0x22,
    "JMPF":0x23,
    "PRI": 0x24,
    "LOAD":0x25,
    "STORE":0x26,
    "READ":0x29
}

def encode_instruction(op, args):
    opcode = OPCODES.get(op.upper(), 0x00)
    if op == "NOP":
        return "00000000"

    args = [int(a,16) if isinstance(a, str) and a.startswith("0x") else int(a) for a in args]
    if (debug):
        print(op,args)


    if op in {"ADD", "SOU", "MUL", "DIV", "AND", "OR", "XOR", "INF", "INFE", "SUP", "SUPE", "EQU"}:
        rD, rA, rB = args
        return f"{opcode:02X}{rD:02X}{rA:02X}{rB:02X}"
    elif op in {"NOT", "COP"}:
        rD = args
        return f"{opcode:02X}{rD:02X}0000"
    elif op == "AFC":
        rD, val = args
        return f"{opcode:02X}{rD:02X}{val:02X}00"
    elif op == "JMP":
        addr = args[0]
        return f"{opcode:02X}{addr:02X}0000"
    elif op == "JMPF":
        addr, r = args
        return f"{opcode:02X}{addr:02X}{r:02X}00"
    elif op == "LOAD":
        rD, addr = args
        return f"{opcode:02X}{rD:02X}{addr:02X}00"
    elif op == "STORE":
        addr, rA = args
        return f"{opcode:02X}{addr:02X}{rA:02X}00"
    elif op == "PRI":    
        val, rA = args
        return f"{opcode:02X}{val:02X}{rA:02X}00"
    elif op == "READ":
        rA, val = args
        return f"{opcode:02X}{rA:02X}{val:02X}00"
    else:
        return "00000000"

def parse_line(line):
    parts = line.strip().split()
    if len(parts) < 2:
        return None
    addr = int(parts[0], 16)
    op = parts[1]
    args = parts[2:]
    return addr, op, args

def convert_file(input_lines):
    final_lines = []
    temp_reg = 0  # Registres temporaires

    # Pass 1: construire la table addr -> index
    addr_to_index = {}
    index = 1  # commence à 1, car NOP à l'index 0
    for line in input_lines:
        if not line.strip() or line.strip().startswith("#"):
            continue
        parsed = parse_line(line)
        if parsed is None:
            continue
        addr, op, args = parsed
        if (debug):
            print(f"Addr: {addr:X}, Op: {op}, Index: {index}")
        addr_to_index[addr] = index

        if op in {"ADD", "SOU", "MUL", "DIV", "AND", "OR", "XOR", "INF", "INFE", "SUP", "SUPE", "EQU"}:
            index += 4  
        elif op in {"NOT","READ"}:
            index += 3  
        elif op in {"COP","AFC","JMPF", "PRI"}:
            index += 2  
        elif op == "JMP":
            index += 1  
        else:
            index += 1  # par défaut

    # Repasser pour générer le vrai code
    final_lines.append("0 => x\"00000000\",")
    index = 1

    for line in input_lines:
        if not line.strip() or line.strip().startswith("#"):
            continue
        parsed = parse_line(line)
        if parsed is None:
            continue
        addr, op, args = parsed

        insert_lines = []

        if op in {"ADD", "SOU", "MUL", "DIV", "AND", "OR", "XOR", "INF", "INFE", "SUP", "SUPE", "EQU"}:
            dst, arg1, arg2 = args
            rA = temp_reg
            rB = temp_reg + 1
            rD = temp_reg + 2
            insert_lines.append(encode_instruction("LOAD", [rA, arg1]))
            insert_lines.append(encode_instruction("LOAD", [rB, arg2]))
            insert_lines.append(encode_instruction(op, [rD, rA, rB]))
            insert_lines.append(encode_instruction("STORE", [dst, rD]))
        elif op == "COP":
            dst, arg = args
            rA = temp_reg
            insert_lines.append(encode_instruction("LOAD", [rA, arg]))
            insert_lines.append(encode_instruction("STORE", [dst, rA]))
        elif op == "NOT":
            dst, arg = args
            rA = temp_reg
            insert_lines.append(encode_instruction("LOAD", [rA, arg]))
            insert_lines.append(encode_instruction(op, [rA]))
            insert_lines.append(encode_instruction("STORE", [dst, rA]))
        elif op == "AFC":
            dst, val = args
            rA = temp_reg
            insert_lines.append(encode_instruction("AFC", [rA, val]))
            insert_lines.append(encode_instruction("STORE", [dst, rA]))
        elif op == "JMP":
            target = int(args[0], 16) if isinstance(args[0], str) else int(args[0])
            jump_addr = addr_to_index.get(target, 0)
            insert_lines.append(encode_instruction(op, [jump_addr]))
        elif op == "JMPF":
            target_addr = int(args[0], 16) if isinstance(args[0], str) and args[0].startswith("0x") else int(args[0])
            if(debug):
                print(f"JMPF vers addr {target_addr} -> index {addr_to_index[target_addr]}")
            cond_addr = int(args[1], 16) if isinstance(args[1], str) and args[1].startswith("0x") else int(args[1])
            jump_index = addr_to_index.get(target_addr, 0)

            temp_r = temp_reg  # registre temporaire
            insert_lines.append(encode_instruction("LOAD", [temp_r, cond_addr]))
            insert_lines.append(encode_instruction(op, [jump_index,temp_r]))
        elif op == "PRI":
            val, dst = args
            rA = temp_reg
            insert_lines.append(encode_instruction("LOAD", [rA, dst]))
            insert_lines.append(encode_instruction(op, [val, rA]))
        elif op == "READ":
            dst, val = args
            rA = temp_reg
            insert_lines.append(encode_instruction("LOAD", [rA, dst]))
            insert_lines.append(encode_instruction(op, [rA, val]))
            insert_lines.append(encode_instruction("STORE", [dst, rA]))
        else:
            insert_lines.append(encode_instruction(op, args))

        for hex_instr in insert_lines:
            final_lines.append(f"{index} => x\"{hex_instr}\",")
            index += 1

    final_lines.append("others => (others => '0')")
    return final_lines

# === Main ===

if __name__ == "__main__":
    input_path = os.path.join("..","compilateur", "out", "output.asm")
    output_path = os.path.join("..","compilateur", "out","output_vivado.vhdl")

    if not os.path.exists(input_path):
        print(f"Fichier introuvable : {input_path}")
        exit(1)

    with open(input_path, "r") as f:
        input_lines = f.readlines()

    output_lines = convert_file(input_lines)

    with open(output_path, "w") as f:
        for line in output_lines:
            f.write(line + "\n")

    print(f"Fichier généré pour Vivado : {output_path}")
