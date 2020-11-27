module hdmi_tx_1080p_60fps(
	input FPGA_CLK1_50,
	
	inout HDMI_I2C_SCL,
   inout HDMI_I2C_SDA,
	
   input HDMI_TX_INT,
   
	output HDMI_TX_CLK,
   output [23:0] HDMI_TX_DATA,
   output HDMI_TX_DE,
	output HDMI_TX_HS,
	output HDMI_TX_VS,
	
	output LED,
	output reg CLK_1K_DEBUG,
	
	inout I2C_SCL_TEST,
   inout I2C_SDA_TEST
);

wire system_reset;
wire hdmi_output_reset;
reg [2:0] system_reset_delay;

assign system_reset = (system_reset_delay == 3'b111) ? 1'b1 : 1'b0;

reg [31:0] clk_1k_debug_count;

wire i2c_scl_oe, i2c_sda_oe, i2c_scl_in, i2c_sda_in;


//assign i2c_scl_in = I2C_SCL_TEST;
//assign I2C_SCL_TEST = i2c_scl_oe ? 1'b0 : 1'bz;
//assign i2c_sda_in = I2C_SDA_TEST;
//assign I2C_SDA_TEST = i2c_sda_oe ? 1'b0 : 1'bz;


assign i2c_scl_in = HDMI_I2C_SCL;
assign HDMI_I2C_SCL = i2c_scl_oe ? 1'b0 : 1'bz;
assign i2c_sda_in = HDMI_I2C_SDA;
assign HDMI_I2C_SDA = i2c_sda_oe ? 1'b0 : 1'bz;

//assign I2C_SCL_TEST = HDMI_I2C_SCL;
//assign I2C_SDA_TEST = HDMI_I2C_SDA;


pll u_pll(
	.refclk(FPGA_CLK1_50),
	.rst(!system_reset),
	.outclk_0(HDMI_TX_CLK),
	.locked(hdmi_output_reset)
);

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

nios_ii u0 (
	.clk_clk                        (FPGA_CLK1_50),                        //                     clk.clk
	.led_external_connection_export (LED), // led_external_connection.export
	.reset_reset_n                  (system_reset),                  //                   reset.reset_n
	.i2c_0_i2c_serial_sda_in        (i2c_sda_in),        //        i2c_0_i2c_serial.sda_in
	.i2c_0_i2c_serial_scl_in        (i2c_scl_in),        //                        .scl_in
	.i2c_0_i2c_serial_sda_oe        (i2c_sda_oe),        //                        .sda_oe
	.i2c_0_i2c_serial_scl_oe        (i2c_scl_oe)         //                        .scl_oe
);

always @ (posedge FPGA_CLK1_50)
begin
	if (system_reset_delay != 3'b111)
		system_reset_delay <= system_reset_delay + 1'b1;
end

always@(posedge FPGA_CLK1_50)
begin
	if( clk_1k_debug_count	< (50000000/1000) )
	begin
		clk_1k_debug_count	<=	clk_1k_debug_count + 1;
	end
	else
	begin
		clk_1k_debug_count	<=	0;
		CLK_1K_DEBUG	<=	~CLK_1K_DEBUG;
	end
end

endmodule
