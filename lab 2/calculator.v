// Code your design here
module not_gate(in, out);
  input wire in;
  output wire out;

  supply1 vdd;
  supply0 gnd;

  pmos pmos1(out, vdd, in);
  nmos nmos1(out, gnd, in);
endmodule

module nand_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  supply0 gnd;
  supply1 pwr;

  wire nmos1_out;

  pmos pmos1(out, pwr, in1);
  pmos pmos2(out, pwr, in2);
  nmos nmos1(nmos1_out, gnd, in1);
  nmos nmos2(out, nmos1_out, in2);
endmodule

module nor_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  supply0 gnd;
  supply1 pwr;

  wire pmos1_out;

  pmos pmos1(pmos1_out, pwr, in1);
  pmos pmos2(out, pmos1_out, in2);
  nmos nmos1(out, gnd, in1);
  nmos nmos2(out, gnd, in2);
endmodule

module and_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  wire nand_out;

  nand_gate nand_gate1(in1, in2, nand_out);
  not_gate not_gate1(nand_out, out);
endmodule

module or_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  wire nor_out;

  nor_gate nor_gate1(in1, in2, nor_out);
  not_gate not_gate1(nor_out, out);
endmodule

module xor_gate(in1, in2, out);
  input wire in1;
  input wire in2;
  output wire out;

  wire not_in1;
  wire not_in2;
  wire and_out1;
  wire and_out2;
  wire or_out1;

  not_gate not_gate1(in1, not_in1);
  not_gate not_gate2(in2, not_in2);
  and_gate and_gate1(in1, not_in2, and_out1);
  and_gate and_gate2(not_in1, in2, and_out2);
  or_gate or_gate1(and_out1, and_out2, out);
endmodule

module alu0(a, b, out);
  input wire [3:0] a, b;
  output wire [3:0] out;
  
  and_gate a0(a[0], b[0], out[0]);
  and_gate a1(a[1], b[1], out[1]);
  and_gate a2(a[2], b[2], out[2]);
  and_gate a3(a[3], b[3], out[3]);
endmodule

module alu1(a, b, out);
  input wire [3:0] a, b;
  output wire [3:0] out;
  
  or_gate o0(a[0], b[0], out[0]);
  or_gate o1(a[1], b[1], out[1]);
  or_gate o2(a[2], b[2], out[2]);
  or_gate o3(a[3], b[3], out[3]);  
endmodule

module summer(a, b, cin, cout, s);
  input wire a, b, cin;
  output wire cout, s;
  
  wire xr, ab, ac, bc, abc;
  
  xor_gate x0(a, b, xr);
  xor_gate x1(xr, cin, s);
  
  and_gate ab0(a, b, ab);
  and_gate ac0(a, cin, ac);
  and_gate bc0(b, cin, bc);
  or_gate o0(ab, ac, abc);
  or_gate o1(abc, bc, cout);
endmodule

module alu2(a, b, out);
  input wire [3:0] a, b;
  output wire [3:0] out;
  
  wire cout0, cout1, cout2, cout3;
  
  summer s0(a[0], b[0], 1'b0, cout0, out[0]);
  summer s1(a[1], b[1], cout0, cout1, out[1]);
  summer s2(a[2], b[2], cout1, cout2, out[2]);
  summer s3(a[3], b[3], cout2, cout3, out[3]);
endmodule

module alu3(a, b, out);
  input wire [3:0] a, b;
  output wire [3:0] out;
  
  wire nb0, nb1, nb2, nb3;
  
  not_gate b0(b[0], nb0);
  not_gate b1(b[1], nb1);
  not_gate b2(b[2], nb2);
  not_gate b3(b[3], nb3);
  and_gate a0(a[0], nb0, out[0]);
  and_gate a1(a[1], nb1, out[1]);
  and_gate a2(a[2], nb2, out[2]);
  and_gate a3(a[3], nb3, out[3]);
endmodule

module alu4(a, b, out);
  input wire [3:0] a, b;
  output wire [3:0] out;
  
  wire nb0, nb1, nb2, nb3;
  
  not_gate b0(b[0], nb0);
  not_gate b1(b[1], nb1);
  not_gate b2(b[2], nb2);
  not_gate b3(b[3], nb3);
  or_gate o0(a[0], nb0, out[0]);
  or_gate o1(a[1], nb1, out[1]);
  or_gate o2(a[2], nb2, out[2]);
  or_gate o3(a[3], nb3, out[3]);
endmodule

module r(a, b, cin, cout, s);
  input wire a, b, cin;
  output wire cout, s;
  
  wire xr, ab, ac, bc, abc;
  
  xor_gate x0(a, b, xr);
  xor_gate x1(xr, cin, s);  
  and_gate a0(a, b, ab);
  and_gate a1(a, cin, ac);
  and_gate a3(b, cin, bc);
  or_gate o0(ab, ac, abc);
  or_gate o1(abc, bc, cout);
endmodule

module alu5(a, b, out);
  input wire [3:0] a, b;
  output wire [3:0] out;
  
  wire cout0, cout1, cout2, cout3;
  wire nb0, nb1, nb2, nb3;
  
  not_gate b0(b[0], nb0);
  not_gate b1(b[1], nb1);
  not_gate b2(b[2], nb2);
  not_gate b3(b[3], nb3);  
  r res0(a[0], nb0, 1'b1, cout0, out[0]);
  r res1(a[1], nb1, cout0, cout1, out[1]);
  r res2(a[2], nb2, cout1, cout2, out[2]);
  r res3(a[3], nb3, cout2, cout3, out[3]); 
endmodule

module alu6(a, b, out);
  input wire [3:0] a, b;
  output wire [3:0] out;
  
  wire [3:0] na, nb;
  wire a30, a31, a20, a21, a10, a11, a00;  
  wire nor3, nor2, nor1;  
  wire and1, and2, and3;  
  wire t1, t2, o01, o012;
  
  not_gate n0(a[0], na[0]);
  not_gate n1(a[1], na[1]);
  not_gate n2(a[2], na[2]);
  not_gate n3(a[3], na[3]);
  not_gate n4(b[0], nb[0]);
  not_gate n5(b[1], nb[1]);
  not_gate n6(b[2], nb[2]);
  not_gate n7(b[3], nb[3]);  
  and_gate aa0(a[3], nb[3], a30);
  and_gate aa1(na[3], b[3], a31);
  nor_gate nn3(a30, a31, nor3);
  and_gate aa7(na[2], b[2], a20);
  and_gate aa2(a[2], nb[2], a21);
  nor_gate nn2(a20, a21, nor2);
  and_gate aa3(na[1], b[1], a10);
  and_gate aa4(a[1], nb[1], a11);
  nor_gate nn1(a10, a11, nor1);
  and_gate aa5(na[0], b[0], a00);    
  and_gate a1(nor3, a20, and1);
  and_gate an1(nor3, nor2, t1);
  and_gate an2(t1, a10, and2);
  and_gate an3(t1, nor1, t2); 
  and_gate an4(t2, a00, and3);
  or_gate o0(a30, and1, o01);
  or_gate o1(o01, and2, o012);
  or_gate o2(o012, and3, out[0]);
  or_gate o4(1'b0, 1'b0, out[3]);
  or_gate o5(1'b0, 1'b0, out[2]);
  or_gate o6(1'b0, 1'b0, out[1]);
endmodule

module twoalu(f, alu, out);
  input wire [2:0] f, alu;
  output wire out;  
  wire t0, t1, t2, t;
  
  xor_gate r0(f[0], alu[0], t0);
  xor_gate r1(f[1], alu[1], t1);
  xor_gate r2(f[2], alu[2], t2);
  or_gate o0(t0, t1, t);
  nor_gate no0(t, t2, out);
endmodule


module all(in, a, out);
  input wire [3:0] in;
  input wire a;
  output [3:0] out;
  
  and_gate a0(in[0], a, out[0]);
  and_gate a1(in[1], a, out[1]);
  and_gate a2(in[2], a, out[2]);
  and_gate a3(in[3], a, out[3]);
endmodule

module alu(a, b, control, res);
  input [3:0] a, b; // Операнды
  input [2:0] control; // Управляющие сигналы для выбора операции

  output [3:0] res; // Результат
  // TODO: implementation
  
  wire a0, a1, a2, a3, a4, a5, a6;  
  wire [3:0] o0, o1, o2, o3, o4, o5, o6;  
  wire [3:0] alu0, alu1, alu2, alu3, alu4, alu5, alu6;  
  wire [3:0] res1, res2, res3, res4, res5;
  
  twoalu f0(control, 3'b000, a0);
  twoalu f1(control, 3'b001, a1);
  twoalu f2(control, 3'b010, a2);
  twoalu f4(control, 3'b100, a3);
  twoalu f5(control, 3'b101, a4);
  twoalu f6(control, 3'b110, a5);
  twoalu f7(control, 3'b111, a6);  
  alu0 l0(a, b, o0);
  alu1 l1(a, b, o1);
  alu2 l2(a, b, o2);
  alu3 l3(a, b, o3);
  alu4 l4(a, b, o4);
  alu5 l5(a, b, o5);
  alu6 l6(a, b, o6);  
  all al0(o0, a0, alu0);
  all al1(o1, a1, alu1);
  all al2(o2, a2, alu2);
  all al3(o3, a3, alu3);
  all al4(o4, a4, alu4);
  all al5(o5, a5, alu5);
  all al6(o6, a6, alu6);
  
  wire al001, al0012, al00123, al001234, al0012345;
  wire al101, al1012, al10123, al101234, al1012345;
  wire al201, al2012, al20123, al201234, al2012345;
  wire al301, al3012, al30123, al301234, al3012345;
  
  //res0
  or_gate oo0(alu0[0], alu1[0], al001);
  or_gate oo1(al001, alu2[0], al0012);
  or_gate oo2(al0012, alu3[0], al00123);
  or_gate oo3(al00123, alu4[0], al001234);
  or_gate oo4(al001234, alu5[0], al0012345);
  or_gate oo5(al0012345, alu6[0], res[0]);
  //res1
  or_gate oo6(alu0[1], alu1[1], al101);
  or_gate oo7(al101, alu2[1], al1012);
  or_gate oo8(al1012, alu3[1], al10123);
  or_gate oo9(al10123, alu4[1], al101234);
  or_gate oo10(al101234, alu5[1], al1012345);
  or_gate oo11(al1012345, alu6[1], res[1]);
  //res2
  or_gate oo12(alu0[2], alu1[2], al201);
  or_gate oo13(al201, alu2[2], al2012);
  or_gate oo14(al2012, alu3[2], al20123);
  or_gate oo15(al20123, alu4[2], al201234);
  or_gate oo16(al201234, alu5[2], al2012345);
  or_gate oo17(al2012345, alu6[2], res[2]);
  //res3
  or_gate oo18(alu0[3], alu1[3], al301);
  or_gate oo19(al301, alu2[3], al3012);
  or_gate oo20(al3012, alu3[3], al30123);
  or_gate oo21(al30123, alu4[3], al301234);
  or_gate oo22(al301234, alu5[3], al3012345);
  or_gate oo23(al3012345, alu6[3], res[3]);    
endmodule 

module d_latch(clk, d, we, q);
  input clk; // Сигнал синхронизации
  input d; // Бит для записи в ячейку
  input we; // Необходимо ли перезаписать содержимое ячейки

  output reg q; // Сама ячейка
  // Изначально в ячейке хранится 0
  initial begin
    q <= 0;
  end
  // Значение изменяется на переданное на спаде сигнала синхронизации
  always @ (negedge clk) begin
    if (we) begin
      q <= d;
    end
  end
endmodule

module part(clk, we, in, out);
  input clk, we;
  input wire [3:0] in;
  output wire [3:0] out;
  d_latch d_latch0(clk, in[0], we, out[0]);
  d_latch d_latch1(clk, in[1], we, out[1]);
  d_latch d_latch2(clk, in[2], we, out[2]);
  d_latch d_latch3(clk, in[3], we, out[3]); 
endmodule

module dec(rd, we);
  input wire [1:0] rd;
  output wire [3:0] we;
  
  wire [1:0] n;
  
  not_gate nt0(rd[0], n[0]);
  not_gate nt1(rd[1], n[1]);
  and_gate a0(rd[0], rd[1], we[3]);
  and_gate a1(rd[1], n[0], we[2]);
  and_gate a2(n[1], rd[0], we[1]);
  and_gate a3(n[0], n[1], we[0]);
endmodule

module mult(a0, a1, a2, a3, ab, out);
  input wire [3:0] a0, a1, a2, a3;
  input wire [1:0] ab;
  output wire [3:0] out;
  
  wire [1:0] no;
  wire ad0, ad1, ad2, ad3;
  wire [3:0] r0, r1, r2, r3; 
  
  not_gate n0(ab[0], no[0]);
  not_gate n1(ab[1], no[1]);
  and_gate an0(no[0], no[1], ad0);
  and_gate aa1(ad0, a0[0], r0[0]);
  and_gate aa2(ad0, a0[1], r0[1]);
  and_gate aa3(ad0, a0[2], r0[2]);
  and_gate a4(ad0, a0[3], r0[3]);
  and_gate an1(ab[0], no[1], ad1);
  and_gate a5(ad1, a1[0], r1[0]);
  and_gate a6(ad1, a1[1], r1[1]);
  and_gate a7(ad1, a1[2], r1[2]);
  and_gate a8(ad1, a1[3], r1[3]);
  and_gate an2(ab[1], no[0], ad2);
  and_gate a9(ad2, a2[0], r2[0]);
  and_gate a10(ad2, a2[1], r2[1]);
  and_gate a11(ad2, a2[2], r2[2]);
  and_gate a12(ad2, a2[3], r2[3]);
  and_gate an3(ab[1], ab[0], ad3);
  and_gate a13(ad3, a3[0], r3[0]);
  and_gate a14(ad3, a3[1], r3[1]);
  and_gate a15(ad3, a3[2], r3[2]);
  and_gate a16(ad3, a3[3], r3[3]);
  
  wire r001, r0012, r101, r1012, r201, r2012;

  or_gate o0(r0[0], r1[0], r001);
  or_gate o1(r001, r2[0], r0012);
  or_gate o2(r0012, r3[0], out[0]);
  or_gate o3(r0[1], r1[1], r101);
  or_gate o4(r101, r2[1], r1012);
  or_gate o5(r1012, r3[1], out[1]);
  or_gate o6(r0[2], r1[2], r201);
  or_gate o7(r201, r2[2], r2012);
  or_gate o8(r2012, r3[2], out[2]);
  or_gate o9(r0[3], r1[3], r301);
  or_gate o10(r301, r2[3], r3012);
  or_gate o11(r3012, r3[3], out[3]);
endmodule

module register_file(clk, rd_addr, we_addr, we_data, rd_data);
  input clk; // Сигнал синхронизации
  input [1:0] rd_addr, we_addr; // Номера регистров для чтения и записи
  input [3:0] we_data; // Данные для записи в регистровый файл

  output [3:0] rd_data; // Данные, полученные в результате чтения из регистрового файла
  // TODO: implementation
  
  wire [3:0] r1, r2, r3, r0, we; 
  
  dec d(we_addr, we);
  part p1(clk, we[0],  we_data, r0);
  part p2(clk, we[1],  we_data, r1);
  part p3(clk, we[2],  we_data, r2);
  part p4(clk, we[3],  we_data, r3);
  mult m(r0, r1, r2, r3, rd_addr, rd_data);
endmodule

module calculator(clk, rd_addr, immediate, we_addr, control, rd_data);
  input clk; // Сигнал синхронизации
  input [1:0] rd_addr; // Номер регистра, из которого берется значение первого операнда
  input [3:0] immediate; // Целочисленная константа, выступающая вторым операндом
  input [1:0] we_addr; // Номер регистра, куда производится запись результата операции
  input [2:0] control; // Управляющие сигналы для выбора операции

  output [3:0] rd_data; // Данные из регистра c номером 'rd_addr', подающиеся на выход
  // TODO: implementation
  wire [3:0] al;
  alu alu(rd_data, immediate, control, al);
  register_file regis(clk, rd_addr, we_addr, al, rd_data);
endmodule
