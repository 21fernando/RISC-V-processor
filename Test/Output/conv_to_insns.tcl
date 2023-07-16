# Get the value of the custom signal representing the 32-bit field
set signals {D_insn E_insn M_insn W_insn q_imem}
foreach signal signals {
	set instruction [value $signal_name]

	# Extract opcode, funct3, and funct7 fields from the instruction
	set opcode [expr ($instruction & 0x7F)]
	set funct3 [expr (($instruction >> 12) & 0x7)]
	set funct7 [expr (($instruction >> 25) & 0x7F)]

	# Decode the instruction based on opcode, funct3, and funct7
	switch $opcode {
    	0 {
	        switch $funct3 {
    	        0 {
	                switch $funct7 {
                    	0 { set mnemonic "add" }
                	    32 { set mnemonic "sub" }
            	    }
        	    }
    	        1 { set mnemonic "sll" }
	            2 { set mnemonic "slt" }
        	    3 { set mnemonic "sltu" }
    	        4 { set mnemonic "xor" }
	            5 {
                	switch $funct7 {
            	        0 { set mnemonic "srl" }
        	            32 { set mnemonic "sra" }
    	            }
	            }
            	6 { set mnemonic "or" }
        	    7 { set mnemonic "and" }
    	    }
	    }
    	3 {
	        switch $funct3 {
            	0 { set mnemonic "lb" }
        	    1 { set mnemonic "lh" }
    	        2 { set mnemonic "lw" }
	            4 { set mnemonic "lbu" }
            	5 { set mnemonic "lhu" }
        	}
    	}
	    35 {
        	switch $funct3 {
    	        0 { set mnemonic "sb" }
	            1 { set mnemonic "sh" }
            	2 { set mnemonic "sw" }
        	}
    	}
	    51 {
    	    switch $funct3 {
	            0 { set mnemonic "addiw" }
            	1 { set mnemonic "slliw" }
        	    5 {
    	            switch $funct7 {
	                    0 { set mnemonic "srliw" }
                    	32 { set mnemonic "sraiw" }
                	}
            	}
        	}
    	}
	    99 { set mnemonic "ecall" }
    	103 { set mnemonic "ebreak" }
	    111 { set mnemonic "jal" }
    	1035 { set mnemonic "jalr" }
	    99 {
    	    switch $funct3 {
	            0 { set mnemonic "beq" }
            	1 { set mnemonic "bne" }
        	    4 { set mnemonic "blt" }
    	        5 { set mnemonic "bge" }
	            6 { set mnemonic "bltu" }
            	7 { set mnemonic "bgeu" }
        	}
    	}
	    default { set mnemonic "unknown" }
	}	

	# Display the translated instruction mnemonic
	annotate $signal "$mnemonic"

}