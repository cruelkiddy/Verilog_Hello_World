/**
 *  @brief:调度信息的流向 ， 根据频率调整输出三个数据是什么
 *  @para：sig1,sig2 
 *  @para : first_data,second_data,third_data : 输出的三个数据，根据频率调整三个数据和输入的关系
 */
 module send_controller(Period_by_gate,direct_Period,delta_T,pos_time,mode,first_data,second_data,third_data,high_Frequency);
    input[31:0] Period_by_gate,direct_Period,delta_T,pos_time;
    input[1:0] mode;
    output reg[31:0] first_data;
    output reg[31:0] second_data;
    output reg[31:0] third_data;
    output high_Frequency;
    always
        case (mode)
            2'b11 : begin   if(Period_by_gate < 32'd10000) third_data <= direct_Period; else third_data <= Period_by_gate;  first_data <= delta_T;second_data <= pos_time;end 
            2'b10 : begin   if(Period_by_gate < 32'd10000) first_data <= direct_Period; else first_data <= Period_by_gate;  second_data <= 0;third_data <= 0;end
            2'b01 : begin   if(Period_by_gate < 32'd10000) first_data <= direct_Period; else first_data <= Period_by_gate;   second_data <= 0;third_data <= 0;end
            2'b00 : begin  first_data <= 0;second_data <= 0;third_data <= 0;   end
            default : begin  first_data <= 0;second_data <= 0;third_data <= 0;   end
        endcase
    assign high_Frequency = (Period_by_gate > 32'd10000);
 endmodule 


/**
 *  @brief:调用 edge_Detector 将sig1,sig2的结果合并为一个2bit mode
 *  @para: mode 
 *         2'b10 : sig1 有 sig2 无 
 *         2'b01 : sig1 无 sig2 有
 *         2'b00 : sig1 无 sig2 无
 *         2'b11 : sig1 有 sig2 有
 */
module how_many_inputs(reset_sig,sig1,sig2,mode);
    input reset_sig,sig1,sig2;
    //output reg[1:0] mode = 0;         Might be this works!!!!!?????
    output reg[1:0] mode;
    wire has_one, has_two;

    edge_Detector sig1_detect(sig1, reset_sig, has_one);
    edge_Detector sig2_detect(sig2, reset_sig, has_two);

    //always @(negedge reset_sig)
        //mode <= {has_one,has_two};
    // Just try another way to decribe ------------------------
    //assign mode = @(negedge reset_sig) {has_one,has_two};
    always @(negedge reset_sig)
        mode <= {has_one,has_two};

endmodule

/**
 *  @breif : 接线器：根据mode，将有信号输入的那路信号接到输出上面
 *  ------------------！!bug！!---------------
 *  ------------------输出不稳，不稳定表现在输出常为1 高频(k以上)不稳定时间短，otherwise 不稳定时间长
 */
module wire_controller(sig1,sig2,mode,frequency_input,duty_input);
    input sig1,sig2;
    input[1:0] mode;
    output frequency_input,duty_input;
    assign frequency_input = (mode[1] & sig1) | (mode[0] & sig2);
    assign duty_input = mode[1] & mode[0] & sig1;

endmodule 


/**
 *  @brief:检测 sig的上升沿 reset使其输出为 0 
 *  配合固定频率的reset脉冲，可以卡住门限判断一段时间是否有上升沿
 */
module edge_Detector(sig, reset, out);
    input sig, reset; //< low_Valid
    output reg out;
    always @(posedge sig or negedge reset) begin
        if(~reset)  out <= 0;
        else if(sig) out <= 1'b1;
        else out <= 0;  //< Just try  else necessory???     It works!!!!????
    end 
endmodule




