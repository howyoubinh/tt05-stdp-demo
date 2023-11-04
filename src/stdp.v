`default_nettype none

module stdp (
    input wire       clk, // clock signal
    input wire       rst_n, // reset signal
    input wire       pre_spike, // pre-synaptic spike
    input wire       post_spike, // post-synaptic spike
    output reg [7:0]time_diff, // 8-bit output time difference
    output reg      update_w_flag, // 1 bit update flag
    output wire [7:0]weight
);

// local variables
reg [15:0] pre_spike_time;
reg [15:0] post_spike_time;
reg [15:0] weight_local;

// increment pre_spike_time and post_spike_time
always @(posedge clk) begin
    if (!rst_n) begin // initialize variables
        pre_spike_time <= 16'b0;
        post_spike_time <= 16'b0;
    end else begin
        pre_spike_time <= pre_spike ? 16'b0 : pre_spike_time + 1; // if spike is true, reset timer else increment timer
        post_spike_time <= post_spike ? 16'b0 : post_spike_time + 1; // change this back to 1 to pass gds
    end
end

// calculate time diff whenever time changes (only LTP)
always @(posedge clk) begin
    if (!rst_n) begin
        time_diff <= 8'b0;
        update_w_flag <= 1'b0;
    end else begin
    time_diff <= post_spike_time - pre_spike_time; // assume pre comes before post (LTP)
    update_w_flag <= (time_diff > 0) ? 1'b1 : 1'b0; // if time_diff > 0, update_w_flag is true else false
    end
end

// LUT for weight update
always @(posedge clk) begin
    if (!rst_n) begin
        weight_local <= 8'b1;
    end else begin
        case (update_w_flag)
            1'b1: weight_local <= (weight_local << 1); // weight * 2
            1'b0: weight_local <= (weight_local >> 1); // weight / 2
        endcase
    end
end

//spike1 and weight should be same bit width

assign weight = weight_local;

endmodule