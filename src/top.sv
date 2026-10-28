module top
(
    input sys_clk,
    input sys_rst_n,
    output lvds_clk_p,
    output lvds_clk_n,
    output lvds_data_p[2:0],
    output lvds_data_n[2:0]
);

wire signed [12:0] curr_x, curr_y;

fpdlink_transmitter panel
(
    .clk27(sys_clk),
    .rstn(sys_rst_n),
    .pixel_x(curr_x),
    .pixel_y(curr_y),
    .pixel_r(curr_x),
    .pixel_g(curr_y),
    .pixel_b(curr_x - curr_y),
    .lvds_c_p(lvds_clk_p),
    .lvds_c_n(lvds_clk_n),
    .lvds_d_p(lvds_data_p),
    .lvds_d_n(lvds_data_n)
);

endmodule
