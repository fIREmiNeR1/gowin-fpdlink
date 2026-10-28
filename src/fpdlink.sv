/*
Tool Version: V1.9.11.03 (64-bit)
Part Number: GW1NR-LV9QN88PC6/I5
Tested on Samsung LTN156AT35 panel
*/

module fpdlink_transmitter
(
    input clk27,
    input rstn,

    output signed [12:0] pixel_x,
    output signed [12:0] pixel_y,
    input [5:0] pixel_r,
    input [5:0] pixel_g,
    input [5:0] pixel_b,

    output lvds_c_p,
    output lvds_c_n,
    output lvds_d_p[2:0],
    output lvds_d_n[2:0]
);

fpd_Gowin_rPLL mhz243_pll(
        .clkout(ser_clk),
        .lock(),
        .reset(rstn),
        .clkin(clk27)
    );

fpd_Gowin_CLKDIV mhz243_div_35(
        .clkout(par_clk),
        .hclkin(ser_clk),
        .resetn(rstn)
    );

wire [2:0] vid_hve;

wire signed[12:0] pic_x, pic_y;

fpd_tgen vid_tgen (
  .i_pixel_clk(par_clk),
  .o_hve(vid_hve),   // { display_enable, vsync, hsync}
  .o_x(pixel_x),
  .o_y(pixel_y)
);

OVIDEO ovideo_d0 (
        .Q(vid_d0),
        .D0(vid_hve[2]),        //de(very important!)
        .D1(1'b0),              //vsync(doesnt matter for my panel, may_differ)
        .D2(1'b0),              //hsync(doesnt matter for my panel, may differ)
        .D3(pixel_b[5]),              //b5
        .D4(pixel_b[4]),              //b4
        .D5(pixel_b[3]),              //b3
        .D6(pixel_b[2]),              //b2
        .PCLK(par_clk),
        .FCLK(ser_clk),
        .RESET(rstn)
    );
OVIDEO ovideo_d1 (
        .Q(vid_d1),
        .D0(pixel_b[1]),              //b1
        .D1(pixel_b[0]),              //b0
        .D2(pixel_g[5]),              //g5
        .D3(pixel_g[4]),              //g4
        .D4(pixel_g[3]),              //3
        .D5(pixel_g[2]),              //g2
        .D6(pixel_g[1]),              //g1
        .PCLK(par_clk),
        .FCLK(ser_clk),
        .RESET(rstn)
    );
OVIDEO ovideo_d2 (
        .Q(vid_d2),
        .D0(pixel_g[1]),               //g0
        .D1(pixel_r[5]),               //r5
        .D2(pixel_r[4]),               //r4
        .D3(pixel_r[3]),               //r3
        .D4(pixel_r[2]),               //r2
        .D5(pixel_r[1]),               //r1
        .D6(pixel_r[0]),               //r0
        .PCLK(par_clk),
        .FCLK(ser_clk),
        .RESET(rstn)
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
        .RESET(rstn)
    );

ELVDS_OBUF u_clk (.I(vid_clk), .O(lvds_c_p), .OB(lvds_c_n));
ELVDS_OBUF u_d0 (.I(vid_d0), .O(lvds_d_p[0]), .OB(lvds_d_n[0]));
ELVDS_OBUF u_d1 (.I(vid_d1), .O(lvds_d_p[1]), .OB(lvds_d_n[1]));
ELVDS_OBUF u_d2 (.I(vid_d2), .O(lvds_d_p[2]), .OB(lvds_d_n[2]));

endmodule

module fpd_Gowin_rPLL (clkout, lock, reset, clkin);

output clkout;
output lock;
input reset;
input clkin;

wire clkoutp_o;
wire clkoutd_o;
wire clkoutd3_o;
wire gw_gnd;

assign gw_gnd = 1'b0;

rPLL rpll_inst (
    .CLKOUT(clkout),
    .LOCK(lock),
    .CLKOUTP(clkoutp_o),
    .CLKOUTD(clkoutd_o),
    .CLKOUTD3(clkoutd3_o),
    .RESET(reset),
    .RESET_P(gw_gnd),
    .CLKIN(clkin),
    .CLKFB(gw_gnd),
    .FBDSEL({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .IDSEL({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .ODSEL({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .PSDA({gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .DUTYDA({gw_gnd,gw_gnd,gw_gnd,gw_gnd}),
    .FDLY({gw_gnd,gw_gnd,gw_gnd,gw_gnd})
);

defparam rpll_inst.FCLKIN = "27";
defparam rpll_inst.DYN_IDIV_SEL = "false";
defparam rpll_inst.IDIV_SEL = 0;
defparam rpll_inst.DYN_FBDIV_SEL = "false";
defparam rpll_inst.FBDIV_SEL = 8;
defparam rpll_inst.DYN_ODIV_SEL = "false";
defparam rpll_inst.ODIV_SEL = 2;
defparam rpll_inst.PSDA_SEL = "0000";
defparam rpll_inst.DYN_DA_EN = "true";
defparam rpll_inst.DUTYDA_SEL = "1000";
defparam rpll_inst.CLKOUT_FT_DIR = 1'b1;
defparam rpll_inst.CLKOUTP_FT_DIR = 1'b1;
defparam rpll_inst.CLKOUT_DLY_STEP = 0;
defparam rpll_inst.CLKOUTP_DLY_STEP = 0;
defparam rpll_inst.CLKFB_SEL = "internal";
defparam rpll_inst.CLKOUT_BYPASS = "false";
defparam rpll_inst.CLKOUTP_BYPASS = "false";
defparam rpll_inst.CLKOUTD_BYPASS = "false";
defparam rpll_inst.DYN_SDIV_SEL = 2;
defparam rpll_inst.CLKOUTD_SRC = "CLKOUT";
defparam rpll_inst.CLKOUTD3_SRC = "CLKOUT";
defparam rpll_inst.DEVICE = "GW1NR-9C";

endmodule //Gowin_rPLL

module fpd_Gowin_CLKDIV (clkout, hclkin, resetn);

output clkout;
input hclkin;
input resetn;

wire gw_gnd;

assign gw_gnd = 1'b0;

CLKDIV clkdiv_inst (
    .CLKOUT(clkout),
    .HCLKIN(hclkin),
    .RESETN(resetn),
    .CALIB(gw_gnd)
);

defparam clkdiv_inst.DIV_MODE = "3.5";
defparam clkdiv_inst.GSREN = "false";

endmodule //Gowin_CLKDIV

module fpd_tgen #(
  H_RESOLUTION    = 1366,          //243mhz serial clock, clkdiv 3.5 gives 7x serializer rate(serializer is DDR)
  V_RESOLUTION    = 768,           //My panel refused to work with standard timings, because pixel clock exceeded its max.
  H_FRONT_PORCH   = 32,
  H_SYNC          = 32,
  H_BACK_PORCH    = 50,
  V_FRONT_PORCH   = 3,
  V_SYNC          = 5,
  V_BACK_PORCH    = 4,
  H_SYNC_POLARITY = 0,
  V_SYNC_POLARITY = 1
)
(
  input  i_pixel_clk,
  output reg [2:0] o_hve,   // { display_enable, vsync, hsync}
  output /*reg*/ signed [12:0] o_x,                 //uncomment reg to get delayed!!!
  output /*reg*/ signed [12:0] o_y 
);

    assign o_x = x;                                          //comment to get delayed!!!
    assign o_y = y;                                          //comment to get delayed!!!

  localparam signed H_START       = -H_BACK_PORCH - H_SYNC - H_FRONT_PORCH;
  localparam signed HSYNC_START   = -H_BACK_PORCH - H_SYNC;
  localparam signed HSYNC_END     = -H_BACK_PORCH;
  localparam signed HACTIVE_START = 0;
  localparam signed HACTIVE_END   = H_RESOLUTION - 1;
  localparam signed V_START       = -V_BACK_PORCH - V_SYNC - V_FRONT_PORCH;
  localparam signed VSYNC_START   = -V_BACK_PORCH - V_SYNC;
  localparam signed VSYNC_END     = -V_BACK_PORCH;
  localparam signed VACTIVE_START = 0;
  localparam signed VACTIVE_END   = V_RESOLUTION - 1;

  reg signed [12:0] x, y;
  always @(posedge i_pixel_clk) begin
    x <= (x == HACTIVE_END) ? 13'(H_START) : x + 1'b1;
    if   (x == HACTIVE_END) y <= (y == VACTIVE_END) ? 13'(V_START) : y + 1'b1;
    //o_x <= x; //uncomment to get delayed!!!
    //o_y <= y; //uncomment to get delayed!!!
    o_hve <= { x >= 0 && y >= 0,
               1'(V_SYNC_POLARITY) ^ (y >= VSYNC_START && y < VSYNC_END),
               1'(H_SYNC_POLARITY) ^ (x >= HSYNC_START && x < HSYNC_END) };
  end
endmodule