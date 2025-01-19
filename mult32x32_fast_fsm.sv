// 32X32 Multiplier FSM
module mult32x32_fast_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    input logic a_msb_is_0,       // Indicates MSB of operand A is 0
    input logic b_msw_is_0,       // Indicates MSW of operand B is 0
    output logic busy,            // Multiplier busy indication
    output logic [1:0] a_sel,     // Select one byte from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [2:0] shift_sel, // Select output from shifters
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);

// Put your code here
// ------------------
typedef enum {idle, Start, A00B0, A01B0, A10B0, A11B0, A00B1, A01B1, A10B1} fsm_type;
fsm_type state, next_state;

always_ff @(posedge clk, posedge reset) begin
    if(reset == 1'b1) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    next_state = idle;
    busy = 1'b0;
    clr_prod = 0;
    upd_prod = 0;
    a_sel = 2'b00;
    b_sel = 1'b0;
    shift_sel = 3'b000;
    case(state)
    idle: begin
        if(start == 1'b1) begin
            next_state = Start;
            busy = 0;
            clr_prod = 1'b1;
            upd_prod = 1'b0;
        end
    end
    Start: begin
        if(a_msb_is_0 == 1'b1 && b_msw_is_0 == 1'b0) begin
            next_state = A00B1;
        end
        else if (a_msb_is_0 == 1'b1 && b_msw_is_0 == 1'b1) begin
            next_state = A11B1;
        end
        else begin
            shift_sel = 3'b011;
            b_sel = 1'b0;
            a_sel = 2'b11;
            clr_prod = 1'b0;
            upd_prod = 1'b1;
            next_state = A11B0;
        end
    end
    A11B0: begin
        if(a_msb_is_0 == 1'b0 && b_msw_is_0 == 1'b1) begin
            next_state = A00B0;
        end
        else begin
            shift_sel = 3'b010;
            b_sel = 1'b1;
            a_sel = 2'b00;
            upd_prod = 1'b1;
            clr_prod = 1'b0;
            next_state = A00B1;
        end
    end
    A00B1: begin
        upd_prod = 1'b1;
        clr_prod = 1'b0;
        a_sel = 2'b01;
        b_sel = 1'b1;
        shift_sel = 3'b011;
        next_state = A01B1;
    end
    A01B1: begin
        upd_prod = 1'b1;
        clr_prod = 1'b0;
        a_sel = 2'b10;
        b_sel = 1'b1;
        shift_sel = 3'b100;
        next_state = A10B1;
    end
    A10B1: begin
        upd_prod = 1'b1;
        clr_prod = 1'b0;
        a_sel = 2'b11;
        b_sel = 1'b1;
        shift_sel = 3'b101;
        next_state = A11B1;
    end
    A11B1: begin
        upd_prod = 1'b1;
        clr_prod = 1'b0;
        a_sel = 2'b00;
        b_sel = 1'b0;
        shift_sel = 3'b000;
        next_state = A00B0;
    end
    A00B0: begin
        upd_prod = 1'b1;
        clr_prod = 1'b0;
        a_sel = 2'b01;
        b_sel = 1'b0;
        shift_sel = 3'b001;
        next_state = A01B0;
    end
    A01B0: begin
        upd_prod = 1'b1;
        clr_prod = 1'b0;
        a_sel = 2'b10;
        b_sel = 1'b0;
        shift_sel = 3'b010;
        next_state = idle;
    end
    endcase

end

// End of your code

endmodule
