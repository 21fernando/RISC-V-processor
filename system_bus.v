module system_bus(

    input [31:0] cpu_addr,      //From cpu to peripheral
    input [2:0] cpu_read_type,
    output reg [31:0] cpu_read_data,     //From peripheral to cpu
    input cpu_device_id, 
    input [31:0] cpu_write_data,     //From cpu to peripheral
    input cpu_write_en,
    output cpu_interrupt,
    output [4:0] cpu_interrupt_id,

    output [31:0] memory_addr,  //From cpu to memory
    output [2:0] memory_read_type,
    input [31:0] memory_read_data,   //From memory to cpu
    output reg [31:0] memory_write_data, //From cpu to memory
    output reg memory_write_en,

    output [31:0] io_addr,      //From cpu to io
    input [31:0] io_read_data,       //From io to cpu
    output reg [31:0] io_write_data,     //From cpu to io
<<<<<<< HEAD
    output reg io_write_en,
    output io_device_id
=======
    output reg io_write_en
    input io_interrupt,
    input [4:0] io_interrupt_id
>>>>>>> bc82f29 (working on interrupt flow)
);
    //Interrupt Signals:
    assign cpu_interrupt = io_interrupt;
    assign cpu_interrupt_id = io_interrupt_id;

    //CPU read
    assign memory_addr = cpu_addr;
    assign io_addr = cpu_addr;
    assign memory_read_type = cpu_read_type;
    
    always @(*) begin
        case (cpu_device_id)
            1'b0 : cpu_read_data <= memory_read_data;
            1'b1 : cpu_read_data <= io_read_data;
        endcase
    end

    //CPU write
    always @(*) begin
        memory_write_data <= cpu_write_data;
        io_write_data <= cpu_write_data;
        case(cpu_device_id)
            1'b0: begin
                memory_write_en <= cpu_write_en;
                io_write_en <= 1'b0;    
            end
            1'b1: begin
                io_write_en <= cpu_write_en;
                memory_write_en <= 1'b0;
            end
        endcase
    end
    
    assign io_device_id = cpu_device_id;

endmodule