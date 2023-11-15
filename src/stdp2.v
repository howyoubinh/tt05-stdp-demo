`default_nettype none

module stdp2 (
    input wire       clk, // clock signal
    input wire       rst_n, // reset signal
    // input wire [4:0] pre_spike, // pre-synaptic spike
    input wire [3:0] pre_spike, // 4 bit pre-synaptic spike
    input wire       post_spike, // post-synaptic spike
    output reg [7:0] time_diff, // 8-bit output time difference
    output reg       update_w_flag, // 1 bit update flag
    output wire [15:0]weight // 16 bit weight
);

// Number of presynaptic neurons
localparam NUM_PRE_NEURONS = 4;

// internal signals to store spike times
reg [7:0] pre_spike_times [0:NUM_PRE_NEURONS-1]; // 4 presynaptic neuron times
reg [7:0] post_spike_time; // 1 postsynaptic neuron time

// internal signal for time differences
reg [7:0] time_diffs [0:NUM_PRE_NEURONS-1]; // post - pre

// internal signals for weights
reg [3:0] weights [0:NUM_PRE_NEURONS-1]; // 4 bit weights

// internal signal for weight update flag
reg update_w_flag_internal;

initial begin
    // dump array word
    for (int i = 0; i < NUM_PRE_NEURONS; i = i + 1) begin
        $dumpvars(0, pre_spike_times[i]);
    end
end


// increment pre_spike_time and post_spike_time
always @(posedge clk) begin
    if (!rst_n) begin // initialize signals
        for (int i = 0; i < NUM_PRE_NEURONS; i = i + 1) begin
            pre_spike_times[i] <= 8'b0;
            time_diffs[i] <= 8'b0;
            weights[i] <= 4'b0;
        end
        post_spike_time <= 8'b0;
        update_w_flag_internal <= 1'b0;
    end else begin

        // update spikes for presynaptic neurons
        for (int i = 0; i < NUM_PRE_NEURONS; i = i + 1) begin
            if (pre_spike[i]) begin
                pre_spike_times[i] <= 8'b0;
            end else begin
                pre_spike_times[i] = pre_spike_times[i] + 1; // increment presynaptic timer
            end
        end

        // update spike time for postsynaptic neuron
        if (post_spike) begin
            post_spike_time <= 8'b0;
        end else begin
            post_spike_time = post_spike_time + 1; // increment postsynaptic timer
        end

        // calculate time diff and update weights
        for (int i = 0; i < NUM_PRE_NEURONS; i = i + 1) begin
            time_diffs[i] <= post_spike_time - pre_spike_times[i];
            weights[i] <= calculate_weight(time_diffs[i]); // calculate_weight function takes time diff as input
        end

        // check if weights need to be updated
        // update_w_flag_internal <= (|time_diffs); // check if any bits in time_diffs is set to 1
    end
end

// assign internal signals to output ports

assign time_diff = time_diffs[0];
// assign weight[15:12] = weights[0];
// assign weight[11:8] = weights[1];
// assign weight[7:4] = weights[2];
// assign weight[3:0] = weights[3];
assign weight = weights[0];
assign update_w_flag = update_w_flag_internal;

function [7:0] calculate_weight;
    input [7:0] time_diff;
    begin
        // positive time_diff = LTP 
        
        // negative time_diff = LTD

        // placeholder for calculate_weight
        calculate_weight = time_diff; // weight directly proportional to time difference
    end
endfunction

endmodule