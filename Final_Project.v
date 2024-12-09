`include "GATES.v"

module Drone_delivery(
    input clk,
    input [1:0] Floor, 
    input [1:0] FS,
    input [1:0] Call,

    output [1:0] Motor,
    output [1:0] Drop
);
//============================================//
//              wire declaration              //
//============================================//
//you can only use wire in this project
    wire f5, f5b;
    wire f6, f6b;
    wire st_tf5b, st_tf5bb;
    wire st_tf6b, st_tf6bb;
    wire o5, o5b, o6, o6b;
    wire to_drop5, to_drop5b, to_drop6, to_drop6b;
    wire to_finish5, to_finish5b, to_finish5b1, to_finish5b2b;
    wire tf5, tf5b;
    wire f_and_six, f_and_sixb;
    wire to_finish6, to_finish6b, to_finish6b1, to_finish6b2b;
    wire five_m, five_mb;
    wire six_m1, six_m1b, six_m2, six_m2b;
    wire out1, out1b, out2, out2b, out3, out3b, out4, out4b, out5, out5b, out6, out6b, out7, out7b, out8, out8b;
    wire five_six_finish, five_six_finishb, five_six_finish1, five_six_finishb1;
    wire nu1, nu2, nu3; // useless
    wire q1, q1b, q2, q2b;
    wire a1, a1b, b1, b1b, c1;
    wire a2, a2b, b2, b2b, c2;
    wire on5, on5b, on6, on6b;

//============================================//
//                   design                   //
//============================================//
/*
Notice that logic gates can only handle single bit operation, which means that statement likes:

NAND m0(Floor, FS, A); 

is forbidden, while

NAND m0(Floor[1], FS[0], A); 

is avalible
*/  
    store st1(clk, Floor[1], Floor[1], Floor[0], f6, f6b);
    store st2(clk, Floor[0], Floor[0], Floor[1], f5, f5b);
    store_tofinish stf0(clk, to_finish5b, Floor[0], Floor[1], st_tf5b, st_tf5bb);
    store_tofinish stf1(clk, to_finish6b, Floor[0], Floor[1], st_tf6b, st_tf6bb);

    NAND five_and_6(f6, f5, f_and_six);
    INV i5(f_and_six, f_and_sixb);

    NAND five_move(f_and_sixb, to_finish5, five_m);
    INV i6(five_m, five_mb);

    NAND six_move1(f_and_sixb, to_finish6, six_m1);
    INV i10(six_m1, six_m1b);
    NAND six_move2(six_m1b, to_finish5b, six_m2);
    INV i11(six_m2, six_m2b);

    NAND five_six_finish_gate(to_finish6b, to_finish5b, five_six_finish1);
    INV i7(five_six_finish1, five_six_finishb1);

    NAND special_case(f_and_sixb, st_tf5b, k1);
    INV inv5(k1, k1b);

    NAND spc(k1b, to_finish6b, k2);
    INV inv6(k2, k2b);

    NOR spec(five_six_finishb1, k2b, five_six_finish);
    INV inv7(five_six_finish, five_six_finishb);


// ============== operation on five floor ============== \\
    DFF d0(clk, FS[0], Drop[0], atdb);

    NAND on_5(f5, f6b, on5);
    INV i17(on5, on5b);
    
    NOR no1(f_and_sixb, on5b, b1);
    INV in1(b1, b1b);

    NAND no0(b1b, Call[0], a1);
    INV in0(a1, a1b);
    NOR no2(a1b, on6b, c1);
    INV in2(c1, to_finish5b);
    INV inv1(to_finish5b, to_finish5);
// ======================================================= \\

// ============== operation on six floor ============== \\
    DFF d_6_0(clk, FS[1], Drop[1], nu3);

    NAND on_6(f6, f5b, on6);
    INV i18(on6, on6b);
    NOR no4(f_and_sixb, on6b, b2);
    INV in4(b2, b2b);

    NAND no5(b2b, Call[1], a2);
    INV in5(a2, a2b);
    NOR no3(a2b, on5b, c2);
    INV in3(c2, to_finish6b);
    INV inv0(to_finish6b, to_finish6);
// ======================================================= \\

    NAND only_5(out2, f6b, o5);
    INV i14(o5, o5b);

    NAND only_6(f5b, out1, o6);
    INV i15(o6, o6b);

// Floor 6
    DFF d3(clk, Floor[1], out1, out1b);
    NOR nor4(o6b, six_m2b, out5);
    INV i12(out5, out5b);
    NOR nor5(out5b, five_six_finishb, out7);
    INV i13(out7, out7b);
    
    DFF d1(clk, out7b, Motor[0], nu2);

// Floor 5
    DFF d4(clk, Floor[0], out2, out2b);
    NOR nor2(o5b, five_mb, out3);
    INV i8(out3, out3b);
    NAND nand100(out3b,out2 , out4);
    INV i20(out4, out4b);
    NOR nor3(out4b, five_six_finishb, out8);
    INV i9(out8, out8b);
    
    DFF d2(clk, out8b, Motor[1], nu1);


endmodule

//============================================//
//            submodule (if needed)           //
//============================================//

module store(clk, fst, f0, f1, q, qbar);

    input fst, f0, f1, clk;
    output q, qbar;
    wire change, change_bar;
    wire s0, s0b, s1, s1b, s2, s2b, s3b, s3;

    //assign s0 = 0, s1 = 0, s2 = 0, s3 = 0;

    NOR no0(f0, f1, change);
    INV in0(change, change_bar);

    NAND na0(fst, change_bar, s0);
    INV in1(s0, s0b);

    assign s1 = change_bar;
    INV in2(s1, s1b);
    NAND na1(s1b, q, s2);
    INV in4(s2, s2b);

    NOR no1(s0b, s2b, s3);
    INV in3(s3, s3b);

    DFF df0(clk, s3b, q, qbar);

endmodule

module store_tofinish(clk, fst, f0, f1, q, qbar);

    input fst, f0, f1, clk;
    output q, qbar;
    wire change, change_bar;
    wire s0, s0b, s1, s1b, s2, s2b, s3, s3b, s4, s4b;
    wire fstb;

    //assign s0 = 0, s1 = 0, s2 = 0, s3 = 0;

    NOR no0(f0, f1, change);
    INV in0(change, change_bar);

    INV in2(fst, fstb);

    NOR no1(fst, change_bar, s1);

    NAND na1(s1, q, s2);
    INV in3(s2, s2b);

    NAND na2(fst, change, s4);
    INV in5(s4, s4b);

    NOR no2(s4b, s2b, s3);
    INV in4(s3, s3b);

    DFF df0(clk, s3b, q, qbar);

endmodule