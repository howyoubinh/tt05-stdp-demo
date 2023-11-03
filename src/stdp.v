`default_nettype none

module stdp (
    input wire       clk, // clock signal
    input wire       rst_n, // reset signal
    input wire       pre_spike, // pre-synaptic spike
    input wire       post_spike, // post-synaptic spike
    output wire [7:0]time_diff, // 8-bit output time difference
    output wire      update_w_flag, // 1 bit update flag
    output wire      weight
);

// local variables
reg [7:0] pre_spike_time;
reg [7:0] post_spike_time;
reg [7:0] weight_local;

// increment pre_spike_time and post_spike_time
always @(posedge clk) begin
    if (reset) begin // initialize variables
        pre_spike_time <= 8'b0;
        post_spike_time <= 8'b0;
        weight_local <= 8'b1;
    end else begin
        pre_spike_time <= pre_spike ? 8'b0 : pre_spike_time + 1; // if spike is true, reset timer else increment timer
        post_spike_time <= post_spike ? 8'b0 : post_spike_time + 1;
    end
end

// calculate time diff whenever time changes (only LTP)
always @(*) begin
    time_diff = post_spike_time - pre_spike_time // assume pre comes before post (LTP)
    update_w_flag = (time_diff > 0) ? 1'b1 : 1'b0; // if time_diff > 0, update_w_flag is true else false
end

// LUT for weight update
assign weight = weight_local;
always @(posedge clk) begin
    case (update_w_flag)
        1'b1: weight_local <= (weight_local << 1) // weight * 2
        1'b0: weight_local <= (weight_local >> 1) // weight / 2
    endcase
end

endmodule