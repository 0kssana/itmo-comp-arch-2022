`include "util.v"
//`include "memory.v"
//`include "d_flop.v"
//`include "register_file.v"


module mips_cpu(clk, pc, pc_new, instruction_memory_a, instruction_memory_rd, data_memory_a, data_memory_rd, data_memory_we, data_memory_wd,
                register_a1, register_a2, register_a3, register_we3, register_wd3, register_rd1, register_rd2);
  // сигнал синхронизации
  input clk;
  // текущее значение регистра PC
  inout [31:0] pc;
  // новое значение регистра PC (адрес следующей команды)
  output [31:0] pc_new;
  // we для памяти данных
  output data_memory_we;
  // адреса памяти и данные для записи памяти данных
  output [31:0] instruction_memory_a, data_memory_a, data_memory_wd;
  // данные, полученные в результате чтения из памяти
  inout [31:0] instruction_memory_rd, data_memory_rd;
  // we3 для регистрового файла
  output register_we3;
  // номера регистров
  output [4:0] register_a1, register_a2, register_a3;
  // данные для записи в регистровый файл
  output [31:0] register_wd3;
  // данные, полученные в результате чтения из регистрового файла
  inout [31:0] register_rd1, register_rd2;

  // TODO: implementation
  wire [2:0] ALUControl;
  wire [31:0] SrcB;
  wire [31:0] Signimm;
  wire [31:0] Shl;
  wire [31:0] PCBranch;
  wire [31:0] PCPLus4;
  wire MemToReg;
  wire RegDst;
  
  wire RegWrite;
  wire Zero;
  wire ALUSrc;
  wire MemWrite;
  wire Branch;

  Unit cu(instruction_memory_rd[31:26], instruction_memory_rd[5:0], RegWrite, RegDst, ALUSrc, Branch, MemWrite, MemToReg, ALUControl);  

  assign instruction_memory_a = pc;

  adder addd(pc, 4, PCPLus4); 
  assign register_a1 = instruction_memory_rd[25:21];
  assign register_a2 = instruction_memory_rd[20:16];    
  mux2_5 x5(instruction_memory_rd[20:16], instruction_memory_rd[15:11], RegDst, register_a3);
  sign_extend Si(instruction_memory_rd[15:0], Signimm);
  ALU alu(register_rd1, SrcB, ALUControl, data_memory_a, Zero);

reg PCSrc;
//assign PCSrc = Zero & Branch; 
//reg p;
  always @*
  begin
    if (instruction_memory_rd[31:26] == 6'b000100) begin
      PCSrc = Zero & Branch;;
    end else if (instruction_memory_rd[31:26] == 6'b000101) begin
      PCSrc = ! Zero;
    end else begin
      PCSrc = ! Zero & Branch;
    end 
  end
  //beq	000100
//assign PCSrc = p;

  wire [31:0] pcc, pcnew1, pcnew2, cpc;
  reg [31:0] pc__new;
  sign25 s25(pc[25:0], pcc);
  shl_2 S21(pcc, cpc);
  shl_2 S22(cpc, pcnew1);
  mux2_32 m1(PCPLus4, PCBranch, PCSrc, pcnew2);
  always @*
  begin
  if (instruction_memory_rd[31:26] == 6'b000010) begin
    pc__new = pcnew1;
  end else begin
    pc__new = pcnew2;
  end
  end
  assign pc_new = pc__new;
  assign register_we3 = RegWrite;
  mux2_32 m2(data_memory_a, data_memory_rd, MemToReg, register_wd3);
  assign data_memory_wd = register_rd2;
  assign data_memory_we = MemWrite;
  mux2_32 m3(register_rd2, Signimm, ALUSrc, SrcB);  
  shl_2 ssss(Signimm, Shl);
  adder ad(Shl, PCPLus4, PCBranch);
 
endmodule