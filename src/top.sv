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
/*
fpd_Gowin_rPLL mhz243_pll(
        .clkout(ser_clk), //output clkout
        .lock(), //output lock
        .reset(~sys_rst_n), //input reset
        .clkin(sys_clk) //input clkin
    );

fpd_Gowin_CLKDIV mhz243_div_35(
        .clkout(par_clk), //output clkout
        .hclkin(ser_clk), //input hclkin
        .resetn(sys_rst_n) //input resetn
    );

wire [2:0] vid_hve;

wire signed[12:0] pic_x, pic_y;

tgen vid_tgen (
  .i_pixel_clk(par_clk),
  .o_hve(vid_hve),   // { display_enable, vsync, hsync}
  .o_x(pic_x), //o signed 12:0
  .o_y(pic_y)  //o signed 12:0
);

wire [5:0] r, g, b;
assign r = pic_x;
assign b = pic_y;
assign g = pic_x - pic_y;

OVIDEO ovideo_d0 (  //b+sync
        .Q(vid_d0),
        .D0(vid_hve[2]),        //de(very important!)
        .D1(1'b0),              //vsync(doesnt matter)
        .D2(1'b0),              //hsync(doesnt matter)
        .D3(b[5]),              //b5
        .D4(b[4]),              //b4
        .D5(b[3]),              //b3
        .D6(b[2]),              //b2
        .PCLK(par_clk),
        .FCLK(ser_clk),
        .RESET(!sys_rst_n)
    );
OVIDEO ovideo_d1 ( //green?
        .Q(vid_d1),
        .D0(b[1]),              //b1
        .D1(b[0]),              //b0
        .D2(g[5]),              //g5
        .D3(g[4]),              //g4
        .D4(g[3]),              //3
        .D5(g[2]),              //g2
        .D6(g[1]),              //g1
        .PCLK(par_clk),
        .FCLK(ser_clk),
        .RESET(!sys_rst_n)
    );
OVIDEO ovideo_d2 ( //red?
        .Q(vid_d2),
        .D0(g[1]),               //g0
        .D1(r[5]),               //r5
        .D2(r[4]),               //r4
        .D3(r[3]),               //r3
        .D4(r[2]),               //r2
        .D5(r[1]),               //r1
        .D6(r[0]),               //r0
        .PCLK(par_clk),
        .FCLK(ser_clk),
        .RESET(!sys_rst_n)
    );

OVIDEO ovideo_clk (
        .Q(vid_clk),
        .D0(1'b1),
        .D1(1'b1),
        .D2(1'b0),
        .D3(1'b0),
        .D4(1'b0),
        .D5(1'b1),
        .D6(1'b1),
        .PCLK(par_clk),
        .FCLK(ser_clk),
        .RESET(!sys_rst_n)
    );

ELVDS_OBUF u_clk (.I(vid_clk), .O(lvds_clk_p), .OB(lvds_clk_n));
ELVDS_OBUF u_d0 (.I(vid_d0), .O(lvds_d0_p), .OB(lvds_d0_n));
ELVDS_OBUF u_d1 (.I(vid_d1), .O(lvds_d1_p), .OB(lvds_d1_n));
ELVDS_OBUF u_d2 (.I(vid_d2), .O(lvds_d2_p), .OB(lvds_d2_n));
*/
endmodule