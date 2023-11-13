`default_nettype none

module tt_um_stdp2 (
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
assign uio_oe = 8'b11111111; // 1 = enable
assign uio_out[6:0] = 6'd0; // set unused bits to 0

// in
wire [7:0] in_pre, in_post; // 8-bit input wires

// outs
wire [4:0]spike_pre; // 5 bit spike vector (1 for each presynaptic neuron)
wire      spike_post; // 1-bit output spike
reg [7:0] state_pre1, state_pre2, state_pre3, state_pre4, state_pre5, state_post; // 8-bit output state
reg [7:0] time_diff_out, weight_out;
reg       w_flag_out;
wire [7:0] threshold_pre1, threshold_pre2, threshold_pre3, threshold_pre4, threshold_pre5, threshold_post;

// assignments
assign in_pre = ui_in; // current driven by test.py
assign in_post = ui_in; // can use different current here
assign threshold_pre1 = 260;
assign threshold_pre2 = 220;
assign threshold_pre3 = 180;
assign threshold_pre4 = 140;
assign threshold_pre5 = 100;
assign threshold_post = 200;
// assign in2 = spike_out1 ? weight_out : 0; // in2 = spike_1 * weight (TO-DO)

// stdp logic (including counter, stdp rule, and weight flag)
stdp2 stdp(.clk(clk), .rst_n(rst_n), .pre_spike(spike_out1), .post_spike(spike_out2), .time_diff(time_diff_out), .update_w_flag(w_flag_out), .weight(weight_out));

// instantiate 5 LIF for each presynaptic neuron
lif lif_pre1(.current(in_pre), .clk(clk), .rst_n(rst_n), .spike(spike_pre[4]), .state(state_pre1), .threshold_val(threshold_pre1));
lif lif_pre2(.current(in_pre), .clk(clk), .rst_n(rst_n), .spike(spike_pre[3]), .state(state_pre2), .threshold_val(threshold_pre2));
lif lif_pre3(.current(in_pre), .clk(clk), .rst_n(rst_n), .spike(spike_pre[2]), .state(state_pre3), .threshold_val(threshold_pre3));
lif lif_pre4(.current(in_pre), .clk(clk), .rst_n(rst_n), .spike(spike_pre[1]), .state(state_pre4), .threshold_val(threshold_pre4));
lif lif_pre5(.current(in_pre), .clk(clk), .rst_n(rst_n), .spike(spike_pre[0]), .state(state_pre5), .threshold_val(threshold_pre5));

// instantiate 1 LIF for postsynaptic neuron
lif lif_post(.current(in_post), .clk(clk), .rst_n(rst_n), .spike(spike_post), .state(state_post), .threshold_val(threshold_post));

// assign outputs wires to output to lif2
assign  uio_out[7] = spike_out2;
assign  uo_out = state_out2;

endmodule