import sys

def main():
    if (len(sys.argv)) != 2:
        print("Incorrect Arguments")
        return
    file_path = sys.argv[1]
    mem_size = 16384
    insns = []
    with open(file_path, 'r') as file:
        for line in file:
            line = line.strip()
            record_length = int(line[1:3], 16)
            address = int(line[3:7], 16)
            record_type = int(line[7:9], 16)
            if (record_type == 1): break
            for i in range(record_length//4):
                insn = line[8*i+9:8*i+17]
                insn_formatted = insn[6] + insn[7] + insn[4] + insn[5] + insn[2] + insn[3] + insn[0] + insn[1]
                insns.append(insn_formatted)
    outfile = file_path.split('.')[0] + ".mem"
    with open(outfile, 'w') as file:
        for insn in insns:
            binary_insn = bin(int(insn, 16))[2:].zfill(32)
            file.write(binary_insn + '\n')
        for i in range(mem_size - len(insns)):
            file.write("00000000000000000000000000000000\n")
    print("Success!")            

if __name__ == "__main__":
    main()
