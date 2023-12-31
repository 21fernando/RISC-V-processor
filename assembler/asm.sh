#!/bin/bash

#!/bin/bash


# Check if an argument is provided
if [ $# -eq 0 ]; then
  echo "No file specified."
  exit 1
fi

# Store the first command line argument in a variable
program=$1

platform=$(uname)

root=""
assembly_file=""
memory_file=""
if [[ "$platform" == "Darwin" ]]; then
  # Running on macOS
  root="/Users/tharindu2003/Documents/FPGA/processor"
  assembly_file="${root}/Test/Assembly/${program}.s"
  memory_file="${root}/Test/Memory/${program}.mem"
else
  # Default case
  root="C:\\Users\\taf27\\Documents\\FPGA\\RISC-V-processor\\"
  assembly_file="${root}\\Test\\Assembly\\${program}.s"
  memory_file="${root}\\Test\\Memory\\${program}.mem"
fi
echo $root
echo $assembly_file
echo $memory_file

if [ ! -f "$assembly_file" ]; then
  echo "File not found: $assembly_file"
  exit 1
fi
echo "Assembly file: ${assembly_file}"
#Assemble using bronzebeard
bronzebeard "${assembly_file}" --hex-offset 0

#Format using python script
python3 bronzebeard_formatter.py bb.out.hex 

#Clean up directory
rm "${root}/assembler/bb.out.hex"
rm "${root}/assembler/bb.out"

#Move files to location
cp "${root}/assembler/bb.mem" "${memory_file}"
rm "${root}/assembler/bb.mem"
echo "Memory file: ${memory_file}"
exit 0
