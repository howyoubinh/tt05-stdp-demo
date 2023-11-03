`default_nettype none

module tt_um_stdp (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

// use bidirectionals as outputs
assign uio_oe = 8'b11111111;
assign uio_out[6:0] = 6'd0;


// stdp logic (including counter, stdp rule, and weight flag)
// stdp stdp1(.clk(clk), .rst_n(rst_n), .pre_spike(uio_out[7]), post_spike(uio_out[6]), .time_diff(), .update_w_flag(), .weight(uio_out[5]));

// instantiate lif for presynaptic neuron
lif lif1(.current(ui_in), .clk(clk), .rst_n(rst_n), .spike(uio_out[7]), .state(uo_out));

// instantiate lif for postsynaptic neuron
// lif lif2(.current(ui_in), .clk(clk), .rst_n(rst_n), .spike(uio_out[6]), .state(uo_out));


endmodule