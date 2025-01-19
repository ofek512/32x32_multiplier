// 32X32 Multiplier test template
module mult32x32_fast_test;

    logic clk;            // Clock
    logic reset;          // Reset
    logic start;          // Start signal
    logic [31:0] a;       // Input a
    logic [31:0] b;       // Input b
    logic busy;           // Multiplier busy indication
    logic [63:0] product; // Miltiplication product

mult32x32_fast test(
	.clk(clk),
	.reset(reset),
	.start(start),
	.a(a),
	.b(b),
	.busy(busy),
	.product(product)
	);

initial begin
	clk=1;
	start=0;
	reset=1;
	busy=0;
	
	repeat(4) begin
		@(posedge clk);
	end
	
	a=32'd212533061;
	b=32'd342824687; 
	reset=0;
	
	@(posedge clk);
	start=1;
	
	@(posedge clk);
	start=0;
	
	repeat(9) begin
		@(posedge clk);
	end

	a= a & 32'hFFFF0000;
	b= b & 32'hFFFF0000;
	
	@(posedge clk);
	start=1;
	
	@(posedge clk);
	start=0;
	
	repeat(9) begin
		@(posedge clk);
	end

end 

always begin 
	#5;
	clk=~clk;
end

endmodule
