`default_nettype none
`timescale 1ns / 1ps

module tb ();

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
        #1;
    end

    reg clock;
    reg reset;
    reg srcValid;
    reg [31:0] srcData;
    reg [15:0] srcAddr;
    wire srcReady;
    wire [31:0] dstData;
    wire [15:0] dstAddr;
    wire dstValid;
    reg dstReady;

    tt_um_hoorifyyyy_D2DAdapter dut (
        .clock(clock),
        .reset(reset),
        .srcData(srcData),
        .srcAddr(srcAddr),
        .srcValid(srcValid),
        .srcReady(srcReady),
        .dstData(dstData),
        .dstAddr(dstAddr),
        .dstValid(dstValid),
        .dstReady(dstReady)
    );

  
    initial begin
        clock = 0;
        forever #5 clock = ~clock; 
    end

 
    initial begin
      
        reset = 1;
        srcValid = 0;
        srcData = 0;
        srcAddr = 0;
        dstReady = 0;

      
        #15 reset = 0;
        #10 reset = 1;

     
        srcData = 32'hA5A5A5A5;
        srcAddr = 16'h0001;
        srcValid = 1;

        wait(srcReady);
        
        
        #10 dstReady = 1;

        wait(dstValid);

        assert(dstData == srcData) else $error("Data mismatch! Expected: %h, Got: %h", srcData, dstData);
        assert(dstAddr == srcAddr) else $error("Address mismatch! Expected: %h, Got: %h", srcAddr, dstAddr);
        
        $display("Test passed: Data transferred correctly.");
        $finish;
    end

endmodule

