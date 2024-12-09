`timescale 1ns/1ps
`define CYCLE_TIME 10.0
`define SETTING_TIME 200
module PATTERN;

reg clk;
reg [1:0] Floor, FS, Call;
wire [1:0] Motor, Drop;

real    CYCLE = `CYCLE_TIME;
always #(CYCLE/2.0) clk = ~clk;
initial clk = 0;
/*iverilog */

/*iverilog*/ 
Drone_delivery U0(
    // Inputs
    .clk(clk),
    .Floor(Floor),
    .FS(FS),
    .Call(Call),
    // Outputs
    .Motor(Motor),
    .Drop(Drop)
);

/// PATTERN ///
initial begin
    //====Pat1====//
    Floor = 2'b00;
    FS    = 2'b00;
    Call  = 2'b00;
    #10;
    Floor = 2'b01;
    #10;
    Floor = 2'b00;
    #10;
    FS    = 2'b01;
    #10;
    FS    = 2'b00;
    Call  = 2'b01;
    #10;
    Floor = 2'b00;
    FS    = 2'b00;
    Call  = 2'b00;
    #20;
    //============//

    //====pat2====//
    Floor = 2'b10;
    FS    = 2'b00;
    Call  = 2'b00;
    #10;
    Floor = 2'b00;
    #10;
    FS    = 2'b10;
    #10;
    FS    = 2'b00;
    Call  = 2'b10;
    #10;
    Floor = 2'b00;
    FS    = 2'b00;
    Call  = 2'b00;
    #20;
    //============//

    //====pat3====//
    Floor = 2'b11;
    FS    = 2'b00;
    Call  = 2'b00;
    #10;
    Floor = 2'b00;
    #10;
    FS    = 2'b01;
    #10;
    FS    = 2'b00;
    Call  = 2'b01;
    #10;
    FS    = 2'b10;
    Call  = 2'b00;
    #10;
    FS    = 2'b00;
    Call  = 2'b10;
    #10;
    Floor = 2'b00;
    FS    = 2'b00;
    Call  = 2'b00;
    #20;
    $finish;
end
//////////////

initial
begin            
    $dumpfile("wave.vcd");   
    $dumpvars(0, PATTERN);
end

endmodule