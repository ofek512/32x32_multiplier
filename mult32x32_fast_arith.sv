// 32X32 Multiplier arithmetic unit template
module mult32x32_fast_arith (
    input logic clk,             // Clock
    input logic reset,           // Reset
    input logic [31:0] a,        // Input a
    input logic [31:0] b,        // Input b
    input logic [1:0] a_sel,     // Select one byte from A
    input logic b_sel,           // Select one 2-byte word from B
    input logic [2:0] shift_sel, // Select output from shifters
    input logic upd_prod,        // Update the product register
    input logic clr_prod,        // Clear the product register
    output logic a_msb_is_0,     // Indicates MSB of operand A is 0
    output logic b_msw_is_0,     // Indicates MSW of operand B is 0
    output logic [63:0] product  // Miltiplication product
);
// Put your code here
// ------------------
logic [7:0] A_out, [15:0] B_out, [63:0] mul_out, [63:0] shift_out;

//a_msb_is_0 and b_msw_is_0 checker//
always_comb begin
    if(a[31:23] == 8'b0) begin
        a_msb_is_0 = 1'b1;
    end
    else begin
        a_msb_is_0 = 1'b0;
    end
    if(b[31:16] == 16'b0) begin
        b_msw_is_0 = 1'b1;
    end
    else begin
        b_msw_is_0 = 1'b0;
    end

end
//A selector//
always_comb begin
    case(a_sel)
        2'b00: A_out = a[7:0];
        2'b01: A_out = a[15:8];
        2'b10: A_out = a[23:16];
        2'b11: A_out = a[31:24];
    endcase
end
//B selector//
always_comb begin
    if(b_sel == 1'b0) begin
        B_out = b[15:0];
    end
    else begin
        B_out = b[31:16];
    end
end

//16X8 multiplier//
always_comb begin
    mul_out = A_out * B_out;
end

//shift mux and calculator//
always_comb begin
    case(shift_sel)
        3'b000: shift_out = mul_out;
        3'b001: shift_out = mul_out << 8;
        3'b010: shift_out = mul_out << 16;
        3'b011: shift_out = mul_out << 24;
        3'b100: shift_out = mul_out << 32;
        3'b101: shift_out = mul_out << 40;
    endcase
end

//64-bit adder//
always_ff @(posedge clk, posedge reset) begin
    if(reset == 1'b1) begin
        product <= 64'b0;
    end
    else if(upd_prod == 1'b1) begin
        product <= product + shift_out;
    end
    else if(clr_prod == 1'b1) begin
        product <= 64'b0;
    end
end


// End of your code

endmodule
