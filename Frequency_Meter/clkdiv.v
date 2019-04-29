`timescale 1ns / 1ps
/**
 *  @brief : 数据发生器 和 发送器 的时钟
 *
 */
module clkdiv(clk50, rst_n, clkout);
  input clk50;	           //系统时钟
  input rst_n;              //收入复位信号
  output clkout;            //采样时钟输出
  reg clkout;
  reg [15:0] cnt;
/////分频进程, 50Mhz的时钟326分频/////////
  always @(posedge clk50 or negedge rst_n)   
  begin
    if (!rst_n) begin
      clkout <=1'b0;
	    cnt<=0;
    end	  
    else if(cnt == 16'd162) begin
      clkout <= 1'b1;
      cnt <= cnt + 16'd1;
    end
    else if(cnt == 16'd325) begin
      clkout <= 1'b0;
      cnt <= 16'd0;
    end
    else begin
      cnt <= cnt + 16'd1;
    end
  end
  endmodule


/**
 * @ brief: 产生主门时间	
 * 50M时钟100M分频产生2Hz方波，使用其1s的高电平做门
 *	
 */
module two_second(clk50, rst_n, clkout);
input clk50;              //系统时钟
input rst_n;              //复位信号low_valid
output clkout;            //采样时钟输出
reg clkout;
reg [26:0] cnt;
/////分频进程, 50Mhz的时钟100M分频/////////
always @(posedge clk50 or negedge rst_n)begin
  if (!rst_n) begin
     clkout <=1'b0;
	  cnt<=0;
  end
  
  else if(cnt == 27'd50000000) begin
    clkout <= 1'b1;
    cnt <= cnt + 27'd1;
  end
  
  else if(cnt == 27'd100000000) begin
    clkout <= 1'b0;
    cnt <= 27'd0;
  end
  
  else
    cnt <= cnt + 27'd1;
	 
end
endmodule

/**
 *	50M时钟50M分频产生1Hz reset信号（low valid） 低电平时间极短 10个 50M clk
 *
 */
module one_second(clk50, rst_n, clkout);
input clk50;              //系统时钟
input rst_n;              //复位信号low_valid
output clkout;            //采样时钟输出
reg clkout;
reg [26:0] cnt;

always @(posedge clk50 or negedge rst_n)begin
  if (!rst_n) begin
     clkout <=1'b0;
	   cnt<=0;
  end
  
  else if(cnt == 27'd50000000) begin
    clkout <= 1'b0;
    cnt <= cnt + 27'd1;
  end
  
  else if(cnt == 27'd50000010) begin
    clkout <= 1'b1;
    cnt <= 27'd0;
  end
  
  else
    cnt <= cnt + 27'd1;
	 
end
endmodule
