if [ $# -eq 0 ]; then
  echo "No program specified."
  exit 1
fi

# Store the first command line argument in a variable
program=$1

cd assembler
./asm.sh "${program}"
# Check the exit status of the called script
if [ $? -ne 0 ]; then
  echo "Error: Assembling failed."
  exit 1
fi
cd -



iverilog -o proc -c processor_files.txt -s Wrapper_tb -P Wrapper_tb.FILE=\"${program}\"
vvp proc