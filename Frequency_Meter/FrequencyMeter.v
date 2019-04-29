/**
 *	主模块
 */
module FrequencyMeter(input sig1, input sig2, input clk, input reset, output out, output test_p);

    wire reset_sig,wrsig,isHigh,frequency_input,clk_s;
    wire[1:0] mode;
    wire[31:0] result_Hf, result_Lf,first_data,second_data,third_data;
    wire[31:0] delta_T, pos_time;
    wire [7:0] dataout;


    how_many_inputs ShuchuGeshu(reset_sig,sig1,sig2,mode);
    one_second Fuweixinhao(clk, reset, reset_sig);
    clkdiv uart_clk(clk, reset, clk_s);


    wire_controller Jiexianqi(sig1,sig2,mode,frequency_input,duty_input);


    
    getPeriod  Dipin(result_Lf,frequency_input,clk);
    direct_Measure Gaopin(result_Hf, clk, frequency_input, reset);
    
    Positive_Time p_time(duty_input,clk,pos_time);
    DeltaT delta(clk,sig1,sig2,delta_T);
    //testuart_test send_test(clk_s, reset,result_Hf,dataout, wrsig);
    //uarttx stable(.clk(clk_s), .rst_n(reset), .datain(dataout), .wrsig(wrsig), .tx(out));
    
    
    
    send_controller Judge(result_Hf,result_Lf,delta_T,pos_time,mode,first_data,second_data,third_data, isHigh);

    testuart Data_Gen(clk_s, reset, mode,first_data,second_data,third_data, dataout, wrsig, isHigh);
    uarttx stable(.clk(clk_s), .rst_n(reset), .datain(dataout), .wrsig(wrsig), .tx(out));
    
    assign test_p = frequency_input;

endmodule

/**************************************************************************************
//参考代码&&测试代码
/    占空比测试
/    wire[31:0] result321,result322;
/    wire[7:0] result81,result82;
/    wire clk_s,wrsig;
/    clkdiv myclk(clk, reset, clk_s);
/    Duty test(sig1, clk, result321, result322);
/    testuart data_gen(clk_s, reset, result321, result81, wrsig);
/    uarttx tx(.clk(clk_s), .rst_n(reset), .datain(result81), .wrsig(wrsig), .tx(o1));
/    testuart data_gen(clk_s, reset, result322, result82, wrsig);
/    uarttx tx(.clk(clk_s), .rst_n(reset), .datain(result82), .wrsig(wrsig), .tx(o2));
/
/
/
/
/
/    wire clk_s,wrsig1,wrsig2,gate;
/    wire[31:0] result1_s,result2_s;
/    wire[7:0] out1,out2;
/    
/    one_second ones(clk, reset, gate);
/    clkdiv uart_clock(clk, reset, clk_s);
/    only_Frequency Measure(gate,result1_s,result2_s,reset,clk,sig);
/    testuart out1_gen(clk_s, reset, result1_s, out1, wrsig1);
/    testuart out2_gen(clk_s, reset, result2_s, out2, wrsig2);
/    uarttx tx1(.clk(clk_s), .rst_n(reset), .datain(out1), .wrsig(wrsig1), .tx(o1));
/    uarttx tx2(.clk(clk_s), .rst_n(reset), .datain(out2), .wrsig(wrsig2), .tx(o2));
/
/
/
/
/wire[31:0] result32;
/    wire[7:0] result8;
/    wire clk_s,wrsig;
/    clkdiv myclk(clk, reset, clk_s);
/    DeltaT test(clk,sig1,sig2,result32);
/    testuart data_gen(clk_s, reset, result32, result8, wrsig);
/    uarttx tx(.clk(clk_s), .rst_n(reset), .datain(result8), .wrsig(wrsig), .tx(o1));
/    wire[31:0] result32;
/    wire[7:0] result8;
/    wire clk_s,wrsig;
/    clkdiv myclk(clk, reset, clk_s);
/    Positive_Time test(sig,clk,result32);
/    testuart data_gen(clk_s, reset, result32, result8, wrsig);
/    uarttx tx(.clk(clk_s), .rst_n(reset), .datain(result8), .wrsig(wrsig), .tx(o1));   
*/
