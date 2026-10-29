module top
(
    input sys_clk,
    input sys_rst_n,
    output lvds_clk_p,
    output lvds_clk_n,
    output lvds_d0_p,
    output lvds_d0_n,
    output lvds_d1_p,
    output lvds_d1_n,
    output lvds_d2_p,
    output lvds_d2_n
);

wire signed [12:0] curr_x, curr_y;

fpdlink_transmitter panel
(
    .clk27(sys_clk),
    .rstn(sys_rst_n),
    .pixel_x(curr_x), //output wire signed [12:0], positive when active pixels
    .pixel_y(curr_y), //output wire signed [12:0], positive when active pixels
    .pixel_r(curr_x), //6-bit color input, RGB666
    .pixel_g(curr_y), 
    .pixel_b(curr_x - curr_y), //r=curr_x, g=curr_y, b=curr_x-curr_y creates an interesting test pattern
    .lvds_clk_p(lvds_clk_p),
    .lvds_clk_n(lvds_clk_n),
    .lvds_d0_p(lvds_d0_p),
    .lvds_d0_n(lvds_d0_n),
    .lvds_d1_p(lvds_d1_p),
    .lvds_d1_n(lvds_d1_n),
    .lvds_d2_p(lvds_d2_p),
    .lvds_d2_n(lvds_d2_n)
);

endmodule
