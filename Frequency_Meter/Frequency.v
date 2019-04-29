/**
 *	等精度测频
 *  not finished
 */
module only_Frequency(gate,out1,out2,reset,clk,sig);
	output[31:0] out1;
	output[31:0] out2;
	input reset,clk,sig,gate;
	wire D_C;
	count32 CNT1(out1,~reset,clk,D_C),CNT2(out2,~reset,clk,D_C);
	D_EF d_latch(D_C,gate,sig);
	
endmodule


/**
 *  @brief : 数一秒钟数有几个信号的上升沿，result为频率
 *  !!!warning:主门时间信号为2Hz方波
 */
 module direct_Measure(result, clk, sig, reset);
    input clk,sig,reset;
    output reg[31:0] result;
    reg[31:0] tmp;
    wire oneHz;
    two_second gate(clk, reset, oneHz);//oneHz


    /*
    always @(posedge clk)
        if(oneHz)
            tmp <= @(posedge sig) tmp + 1'b1;
        else
            tmp <= 0;
    
    always @(negedge oneHz)
        result <= tmp;
    */
    always @(posedge sig)
        if(oneHz)
            tmp <= tmp + 1'b1;
        else
            tmp <= 0;
    
    always @(negedge oneHz)
        result <= tmp;

 endmodule 
