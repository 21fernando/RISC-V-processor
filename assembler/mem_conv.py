import sys

def main():
    if len(sys.argv) == 2:
        with open(sys.argv[1], 'r') as infile:
            out_file_name = sys.argv[1].split(".")[0] + ".mem"
            with open(out_file_name, 'w') as outfile:
                num_lines = 0
                for line in infile:
                    binary_string = bin(int(line, 16))[2:].zfill(32)
                    outfile.write(binary_string[0:8] + '\n')
                    outfile.write(binary_string[8:16] + '\n')
                    outfile.write(binary_string[16:24] + '\n')
                    outfile.write(binary_string[24:32] + '\n')
                    num_lines += 4
                while (num_lines < 16384):
                    outfile.write("00000000\n")
                    num_lines +=1
                print("Success")
    else:
        print("Incorrect number of arguments")

if __name__ == "__main__":
    main();