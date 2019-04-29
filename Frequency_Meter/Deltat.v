/*	
 * @brief : 测两路同频信号相位差|绝对值|
 * @param : result 32bit sig1=1,sig2=0期间数到的标准时钟个数 
 * @param : sig1 1bit 待测信号1
 * @param : sig2 1bit 待测信号2
 * @param : clk 1bit 标准时钟
 */
module DeltaT(clk,sig1,sig2,result);
	input sig1,sig2,clk;
	output [31:0]result;
	wire new_sig = sig1 & ~sig2;
	Positive_Time delta(new_sig, clk, result);
	/*4-18 go to be a poor worker    4-20 continue*/
endmodule

/*	
 * @brief : 测高电平持续时间
 * @param : p_time 32bit 信号高电平期间数到的标准时钟个数 
 * @param : sig 1bit 待测信号
 * @param : clk 1bit 标准时钟
 */
module Positive_Time(sig,clk,p_time);
	input sig,clk;
	output reg[31:0]p_time;
	reg [31:0] tmp;
		
	always @(posedge clk) begin
		if(sig)
			tmp <= tmp + 1'b1;
		else
			tmp <= 0;
	end

	always @(negedge sig)
		p_time <= tmp;
	
endmodule




/*	
 * @brief : 测周法测频,输入信号2分频成为计数使能信号
 * @param : period 32bit 一个信号周期内数到的标准时钟个数 
 * @param : sig 1bit 待测信号
 * @param : clk 1bit 标准时钟
 */
module getPeriod(period,sig,clk);
	input sig,clk;
	output reg [31:0] period = 0;
	reg [31:0] tmp = 0;
	reg count_en = 0;
	
	always @(posedge sig) 
		count_en <= ~count_en;
		
	always @(negedge count_en)
		period <= tmp;

	always @(posedge clk) begin
		if(count_en)
			tmp <= tmp + 1'b1;
		else
			tmp <= 0;
	end

endmodule
