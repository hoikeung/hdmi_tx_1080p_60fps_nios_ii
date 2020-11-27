	component nios_ii is
		port (
			clk_clk                        : in  std_logic := 'X'; -- clk
			led_external_connection_export : out std_logic;        -- export
			reset_reset_n                  : in  std_logic := 'X'; -- reset_n
			i2c_0_i2c_serial_sda_in        : in  std_logic := 'X'; -- sda_in
			i2c_0_i2c_serial_scl_in        : in  std_logic := 'X'; -- scl_in
			i2c_0_i2c_serial_sda_oe        : out std_logic;        -- sda_oe
			i2c_0_i2c_serial_scl_oe        : out std_logic         -- scl_oe
		);
	end component nios_ii;

	u0 : component nios_ii
		port map (
			clk_clk                        => CONNECTED_TO_clk_clk,                        --                     clk.clk
			led_external_connection_export => CONNECTED_TO_led_external_connection_export, -- led_external_connection.export
			reset_reset_n                  => CONNECTED_TO_reset_reset_n,                  --                   reset.reset_n
			i2c_0_i2c_serial_sda_in        => CONNECTED_TO_i2c_0_i2c_serial_sda_in,        --        i2c_0_i2c_serial.sda_in
			i2c_0_i2c_serial_scl_in        => CONNECTED_TO_i2c_0_i2c_serial_scl_in,        --                        .scl_in
			i2c_0_i2c_serial_sda_oe        => CONNECTED_TO_i2c_0_i2c_serial_sda_oe,        --                        .sda_oe
			i2c_0_i2c_serial_scl_oe        => CONNECTED_TO_i2c_0_i2c_serial_scl_oe         --                        .scl_oe
		);

