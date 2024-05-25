TODO:
1. Implement CSR file for interrupt enable, interrupt cause, and stack pointer. 
    - Bubble in memory write instrcutions to a reserved portion of memory
2. In assembly, should jump to generic interrupt code first
    - save the stack frame
    - save the CSR values into the actual registers
3. Using the interrupt cause, jump to the appropriate handler
4. Jump back to a restore subroutine that restores stackframe, and PC back (AUIPC?)
5. Turn on interrupt enable


Tasks:
- Adapt testbench
- Fix ports for top level in both 
- Find a way to write in IVT
- Write a memory format 

IO SPEC:
Input:
- Interrupt:
    - Saves PC
    - Saves interrupt cause
    - Stalls to flush instructions
    - Jumps to the interrupt handler
    - Restores PC
    - Interrupt Vector Table located at 0x00000000
- Polling:


Output:
