`timescale 1ns/1ps 

module tb_hdmi_tx_1080p_60fps();

/***************************
*	Simulation parameters
***************************/
reg FPGA_CLK1_50;
	
wire HDMI_I2C_SCL;
wire HDMI_I2C_SDA;
	
wire HDMI_TX_INT;
  
wire HDMI_TX_CLK;
wire [23:0] HDMI_TX_DATA;
wire HDMI_TX_DE;
wire HDMI_TX_HS;
wire HDMI_TX_VS;
/***************************
*	Simulation parameters
***************************/

wire system_reset;
wire hdmi_output_reset;
reg [2:0] system_reset_delay;

assign system_reset = (system_reset_delay == 3'b111) ? 1'b1 : 1'b0;

always @ (posedge FPGA_CLK1_50)
begin
	if (system_reset_delay != 3'b111)
		system_reset_delay <= system_reset_delay + 1'b1;
end

pll u_pll(
	.refclk(FPGA_CLK1_50),
	.rst(!system_reset),
	.outclk_0(HDMI_TX_CLK),
	.locked(hdmi_output_reset)
);
/*
I2C_HDMI_Config u_I2C_HDMI_Config(
	.iCLK(FPGA_CLK1_50),
	.iRST_N(system_reset),
	.I2C_SCLK(HDMI_I2C_SCL),
	.I2C_SDAT(HDMI_I2C_SDA),
	.HDMI_TX_INT(HDMI_TX_INT)
);
*/
video_generator u_video_generator(
	.clk(HDMI_TX_CLK),
	.reset_n(hdmi_output_reset),
	.vga_hs(HDMI_TX_HS),
	.vga_vs(HDMI_TX_VS),
	.vga_de(HDMI_TX_DE),
	.vga_r(HDMI_TX_DATA[23:16]),
	.vga_g(HDMI_TX_DATA[15:8]),
	.vga_b(HDMI_TX_DATA[7:0])
);

initial begin 
	FPGA_CLK1_50 = 0;
	system_reset_delay = 0;
	forever #10 FPGA_CLK1_50 = ~FPGA_CLK1_50;
	
	#100 $finish;
end

endmodule
