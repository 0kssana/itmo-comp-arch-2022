// Реализация логического вентиля NOT с помощью структурных примитивов
module not_gate(in, out);
  // Входные порты помечаются как input, выходные как output
  input wire in;
  output wire out;
  // Ключевое слово wire для обозначения типа данных можно опустить,
  // тогда оно подставится неявно, например:
  /*
    input in;
    output out;
  */

  supply1 vdd; // Напряжение питания
  supply0 gnd; // Напряжение земли

  // p-канальный транзистор, сток = out, исток = vdd, затвор = in
  pmos pmos1(out, vdd, in); // (сток, исток, база)
  // n-канальный транзистор, сток = out, исток = gnd, затвор = in
  nmos nmos1(out, gnd, in);
endmodule

// Реализация NAND с помощью структурных примитивов
module nand_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  supply0 gnd;
  supply1 pwr;

  // С помощью типа wire можно определять промежуточные провода для соединения элементов.
  // В данном случае nmos1_out соединяет сток транзистора nmos1 и исток транзистора nmos2.
  wire nmos1_out;

  // 2 p-канальных и 2 n-канальных транзистора
  pmos pmos1(out, pwr, in1);
  pmos pmos2(out, pwr, in2);
  nmos nmos1(nmos1_out, gnd, in1);
  nmos nmos2(out, nmos1_out, in2);
endmodule

// Реализация NOR с помощью структурных примитивов
module nor_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  supply0 gnd;
  supply1 pwr;

  // Промежуточный провод, чтобы содединить сток pmos1 и исток pmos2
  wire pmos1_out;

  pmos pmos1(pmos1_out, pwr, in1);
  pmos pmos2(out, pmos1_out, in2);
  nmos nmos1(out, gnd, in1);
  nmos nmos2(out, gnd, in2);
endmodule

// Реализация AND с помощью NAND и NOT
module and_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  // Промежуточный провод, чтобы передать выход вентиля NAND на вход вентилю NOT
  wire nand_out;

  // Схема для формулы AND(in1, in2) = NOT(NAND(in1, in2))
  nand_gate nand_gate1(in1, in2, nand_out);
  not_gate not_gate1(nand_out, out);
endmodule

// Реализация OR с помощью NOR и NOT
module or_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  wire nor_out;

  // Схема для формулы OR(in1, in2) = NOT(NOR(in1, in2))
  nor_gate nor_gate1(in1, in2, nor_out);
  not_gate not_gate1(nor_out, out);
endmodule

// Реализация XOR с помощью NOT, AND, OR
module xor_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  wire not_in1;
  wire not_in2;

  wire and_out1;
  wire and_out2;

  wire or_out1;

  // Формула: XOR(in1, in2) = OR(AND(in1, NOT(in2)), AND(NOT(in1), in2))

  not_gate not_gate1(in1, not_in1);
  not_gate not_gate2(in2, not_in2);

  and_gate and_gate1(in1, not_in2, and_out1);
  and_gate and_gate2(not_in1, in2, and_out2);

  or_gate or_gate1(and_out1, and_out2, out);
endmodule

module ternary_min(a, b, out); 
  input wire [1:0] a; 
  input wire [1:0] b; 
  output wire [1:0] out; 
   
  wire not_a0; 
  wire not_a1; 
  wire not_b0; 
  wire not_b1; 
   
  wire and_1; 
  wire and_2; 
  wire and_3; 
  wire and_4; 
  wire and_34; 
  wire and_5; 
  wire and_6; 
  wire and_56; 
  wire and_7; 
  wire and_8; 
  wire and_78; 
   
  wire or_1; 
   
  not_gate not_gate1(a[1], not_a1); 
  not_gate not_gate2(a[0], not_a0); 
  not_gate not_gate3(b[1], not_b1); 
  not_gate not_gate4(b[0], not_b0); 
  
   
  and_gate and_gate1(a[1], not_a0, and_1); 
  and_gate and_gate2(b[1], not_b0, and_2); 
  and_gate and_gate12(and_1, and_2, out[1]); 
   
  and_gate and_gate3(not_a1, a[0], and_3); 
  and_gate and_gate4(not_b1, b[0], and_4); 
  and_gate and_gate34(and_3, and_4, and_34); 
   
  and_gate and_gate5(a[1], not_a0, and_5); 
  and_gate and_gate6(not_b1, b[0], and_6); 
  and_gate and_gate56(and_5, and_6, and_56); 
   
  and_gate and_gate7(not_a1, a[0], and_7); 
  and_gate and_gate8(b[1], not_b0, and_8); 
  and_gate and_gate78(and_7, and_8, and_78); 
   
  or_gate or_gate1(and_34, and_56, or_1); 
  or_gate or_gate2(or_1, and_78, out[0]); 
endmodule

module ternary_max(a, b, out);
  input wire [1:0] a; 
  input wire [1:0] b;
  output wire [1:0] out;
  
  wire no_a0;
  wire no_b0;
  wire no_a1;
  wire no_b1;
  wire and_ano0no1;
  wire and_b1no0;
  wire out1; 
  wire and_ano01;
  wire out2;
  wire and_a0no1;
  wire and_bno0no1;  
  wire and_b0nob1;
  wire a1;
  wire b1;  
  wire out3;
  wire and_bno01;
  wire out4;
  wire out5;
  wire out12;
  wire out123;
  wire out1234;
  wire out21;
  wire out22;
  wire out23;
  wire out212;
  wire out2123;
  wire outt;
  
  not_gate not_a0(a[0], no_a0);
  not_gate not_b0(b[0], no_b0);
  not_gate not_a1(a[1], no_a1);
  not_gate not_b1(b[1], no_b1);
  
  and_gate and_a(no_a0, no_a1, and_ano0no1);
  and_gate and_b(b[1], no_b0, and_b1no0);
  and_gate and_ab(and_ano0no1, and_b1no0, out1);
  
  and_gate and_aa(no_a1, a[0], a1);
  and_gate adds(b[1], no_b0, b1);
  and_gate and_aab(a1, b1, out2);
  
  and_gate and_noaa(a[1], no_a0, and_a0no1);
  and_gate a_bb(no_b0, no_b1, and_bno0no1);
  and_gate and_abb(and_a0no1, and_bno0no1, out3);
  
  and_gate and_bbb(no_b1, b[0], and_bno01);
  and_gate and_aabb(and_a0no1, and_bno01, out4); 
  and_gate and_abab(and_a0no1, and_b1no0, out5); 
  or_gate or1(out1, out2, out12);
  or_gate or2(out12, out3, out123);
  or_gate or3(out123, out4, out1234);
  or_gate or4(out1234, out5, outt);
  
  and_gate asd(and_ano0no1, and_bno01, out21);
  and_gate asnd(a1, and_bno0no1, out22);
  and_gate le(a1, and_bno01, out23);
  or_gate kt(out21, out22, out212);
  or_gate the_best(out212, out23, out2123);
  
  
  assign out[0] = out2123;
  assign out[1] = outt;
  
endmodule


module ternary_consensus(a, b, out); 
  input wire [1:0] a; 
  input wire [1:0] b; 
  output wire [1:0] out; 
   
  wire not_a0; 
  wire not_a1; 
  wire not_b0; 
  wire not_b1; 
   
  wire and_1; 
  wire and_2; 
   
  wire or_1; 
  wire or_2; 
  wire or_12; 
   
  wire or_3; 
  wire or_4; 
  wire or_34; 
   
  not_gate not_gate1(a[1], not_a0); 
  not_gate not_gate2(a[0], not_a1); 
  not_gate not_gate3(b[1], not_b0); 
  not_gate not_gate4(b[0], not_b1); 
  
   
  and_gate and_gate1(a[1], not_a1, and_1); 
  and_gate and_gate2(b[1], not_b1, and_2); 
  and_gate and_gate12(and_1, and_2, out[1]); 
   
  or_gate or_gate1(a[1], a[0], or_1); 
  or_gate or_gate2(b[1], b[0], or_2); 
  or_gate or_gate12(or_1, or_2, or_12); 
   
  or_gate or_gate3(not_a0, a[0], or_3); 
  or_gate or_gate4(not_b0, b[0], or_4); 
  or_gate or_gate34(or_3, or_4, or_34); 
   
  and_gate and_gate5(or_12, or_34, out[0]);  
   
endmodule

module ternary_any(a, b, out);
  input wire [1:0] a; 
  input wire [1:0] b; 
  output wire [1:0] out; 
  
  wire not_a0;
  wire not_a1;
  wire not_b1;
  wire not_b0;
  wire and_nota0a1;
  wire and_b0notb1;
  wire out11;
  wire and_nota0nota1;
  wire and_a0nota1;
  wire and_notb0b1;
  wire out12;
  wire out13;
  wire out112;
  wire out123;
  wire and_nota0not1;
  wire out21;
  wire out22;
  wire and_notb0notb1;
  wire out23;
  wire a1;
  wire b1;
  wire out212;
  wire out321;
  
  
  not_gate noa0(a[0], not_a0);
  not_gate noa1(a[1], not_a1);
  not_gate nob0(b[0], not_b0);
  not_gate nob1(b[1], not_b1); 
  
  and_gate and1(not_a0, a[1], and_nota0a1);
  and_gate and2(b[0], not_b1, and_b0notb1);
  and_gate and12(and_b0notb1, and_nota0a1, out11);
  
  and_gate and3(a[0], not_a1, and_a0nota1);
  and_gate and4(not_b0, b[1], and_notb0b1);
  and_gate and34(and_a0nota1, and_notb0b1, out12);
  
  and_gate and1234(and_notb0b1, and_nota0a1, out13);
  
  or_gate or1(out11, out12, out112);
  or_gate or2(out112, out13, out123);
  
  and_gate and11(not_a0, not_a1, and_nota0not1);
  and_gate and123(and_nota0not1, and_notb0b1, out21);
  
  and_gate andd(not_a1, a[0], a1);
  and_gate aand(not_b1, b[0], b1);
  and_gate and122(a1, b1, out22);
  
  and_gate and33(not_b0, not_b1, and_notb0notb1);
  and_gate and13(and_notb0notb1, and_nota0a1, out23);
  
  or_gate or11(out21, out22, out212);
  or_gate or22(out212, out23, out321);
  
  assign out[0] = out321;
  assign out[1] = out123;
  
  
endmodule