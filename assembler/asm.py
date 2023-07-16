import sys
from riscv_assembler.convert import AssemblyConverter as AC
mem_depth = 4096
def main():
    if len(sys.argv) == 2:
        last_period_index = sys.argv[1].rfind(".")
        if(last_period_index == -1):
            print("Error in file specification")
            return 
        output_file = sys.argv[1][:last_period_index] + ".mem"
        convert = AC(output_mode = 'a')
        result = convert(sys.argv[1])
        if(len(result)>4096):
            print("Error, input file is too long")
        else:
            with open(output_file, 'w') as fhand:
                line_num = 0
                insn_num = 0
                while line_num < 16384:
                    if(insn_num<len(result)):
                        fhand.write(result[insn_num][0:8] + '\n')
                        fhand.write(result[insn_num][8:16] + '\n')
                        fhand.write(result[insn_num][16:24] + '\n')
                        fhand.write(result[insn_num][24:32] + '\n')
                        insn_num+=1
                        line_num+=4
                    else:
                        fhand.write("00000000\n")
                        line_num += 1
        print("Success!")
    else:
        print("Error: must specify file")

if __name__ == "__main__":
    main()