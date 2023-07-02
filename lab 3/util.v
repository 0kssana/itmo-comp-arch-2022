// модуль, который реализует расширенение
// 16-битной знаковой константы до 32-битной
module sign_extend(in, out);
  input [15:0] in;
  output [31:0] out;

  assign out = {{16{in[15]}}, in};
endmodule

// модуль, который реализует побитовый сдвиг числа
// влево на 2 бита
module shl_2(in, out);
  input [31:0] in;
  output [31:0] out;

  assign out = {in[29:0], 2'b00};
endmodule

// 32 битный сумматор
module adder(a, b, out);
  input [31:0] a, b;
  output [31:0] out;

  assign out = a + b;
endmodule

// 32-битный мультиплексор
module mux2_32(d0, d1, a, out);
  input [31:0] d0, d1;
  input a;
  output [31:0] out;
  assign out = a ? d1 : d0;
endmodule

// 5 - битный мультиплексор
module mux2_5(d0, d1, a, out);
  input [4:0] d0, d1;
  input a;
  output [4:0] out;
  assign out = a ? d1 : d0;
endmodule


module Unit(Opencode, funct, RegWrite, regdst, alusrc, branch, memwrite, memtoreg, ALUControl);
  input [5:0] Opencode, funct;
  output reg RegWrite, regdst, alusrc, branch, memwrite, memtoreg;
  output reg [1:0] ALUOp;
  output reg [2:0] ALUControl;

always @*
begin
  if (Opencode == 6'b000000) begin
    RegWrite = 1;
    regdst = 1;
    alusrc = 0;
    branch = 0;
    memwrite = 0;
    memtoreg = 0;
    ALUOp = 2'b10;
  end else if (Opencode == 6'b100011) begin
    RegWrite = 1;
    regdst = 0;
    alusrc = 1;
    branch = 0;
    memwrite = 0;
    memtoreg = 1;
    ALUOp = 2'b00;
  end else if (Opencode == 6'b101011) begin
    RegWrite = 0;
    alusrc = 1;
    branch = 0;
    memwrite = 1;
    ALUOp = 2'b00;
  end else if (Opencode == 6'b000100) begin //bqe
    RegWrite = 0;
    alusrc = 0;
    branch = 1;
    memwrite = 0;
    ALUOp = 2'b01; 
  end else if (Opencode == 6'b001000) begin
    RegWrite = 1;
    regdst = 0;
    alusrc = 1;
    branch = 0;
    memwrite = 0;
    memtoreg = 0;
    ALUOp = 2'b00; 
  end else if (Opencode == 6'b001100) begin
    RegWrite = 1;
    regdst = 0;
    alusrc = 1;
    branch = 0;
    memwrite = 0;
    memtoreg = 0;
    ALUOp = 2'b11; 
  end else if (Opencode == 6'b000101) begin  //bne
    RegWrite = 0;
    alusrc = 0;
    branch = 1;
    memwrite = 0;
    ALUOp = 2'b01;
  end 
end
 
always @*
begin
  if (ALUOp == 2'b00) begin
      ALUControl = 3'b010;
  end else if (ALUOp == 2'b01) begin
      ALUControl = 3'b110;
  end else if (ALUOp == 2'b10) begin
    if (funct == 6'b100100) begin
      ALUControl = 3'b000;
    end else if (funct == 6'b100101) begin
      ALUControl = 3'b001;
    end else if (funct == 6'b100000) begin
      ALUControl = 3'b010;
    end else if (funct == 6'b100010) begin
      ALUControl = 3'b110;
    end else if (funct == 6'b101010) begin
      ALUControl = 3'b111;
    end
  end
end
endmodule

module ALU(a, b, in, out, zero);
  input [31:0] a, b;
  input wire [2:0] in;
  output reg [31:0] out;
  output reg zero;

  always @*
  //begin
  if (in == 0) begin
      out = (a & b);
  end else if (in == 3'b001) begin
      out = (a | b);
  end else if (in == 3'b010) begin
      out = a + b;
  end else if (in == 3'b110) begin
      out = a - b;
  end else if (in == 3'b111) begin
      if ((a < b) && (a[31] >= b[31])) begin
          out = 0;
          out[0] = 1;
      end else if ((a > b) && (a[31] > b[31])) begin
          out = 0;
          out[0] = 1;
      end else begin
          out = 0;
      end
      end   
        always @*
  if (out == 0) begin
    zero = 1;
  end else begin
    zero = 0;
  end


endmodule


module sign25(in, out);
  input [25:0] in;
  output [31:0] out;
  assign out = {{6{in[25]}}, in};
endmodule