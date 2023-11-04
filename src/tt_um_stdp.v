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

// in
wire [7:0] in1, in2; // 8-bit input wires

// outs
wire spike_out1, spike_out2; // 1-bit output spike
reg [7:0] state_out1, state_out2; // 8-bit output state
reg [7:0] time_diff_out, weight_out;
reg w_flag_out;
wire [7:0] threshold1, threshold2;

// assignments
assign in1 = ui_in; // current driven by test.py
assign in2 = ui_in;
assign threshold1 = 230;
assign threshold2 = 150;
// assign in2 = spike_out1 ? weight_out : 0; // in2 = spike_1 * weight (TO-DO)

// stdp logic (including counter, stdp rule, and weight flag)
stdp stdp1(.clk(clk), .rst_n(rst_n), .pre_spike(spike_out1), .post_spike(spike_out2), .time_diff(time_diff_out), .update_w_flag(w_flag_out), .weight(weight_out));

// instantiate lif for presynaptic neuron
lif lif1(.current(in1), .clk(clk), .rst_n(rst_n), .spike(spike_out1), .state(state_out1), .threshold_val(threshold1));

// instantiate lif for postsynaptic neuron
lif lif2(.current(in2), .clk(clk), .rst_n(rst_n), .spike(spike_out2), .state(state_out2), .threshold_val(threshold2));

// assign outputs wires to output to lif2
assign  uio_out[7] = spike_out2;
assign  uo_out = state_out2;

endmodule