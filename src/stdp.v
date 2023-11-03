`default_nettype none

module stdp(
    input wire       clk,
    input wire       rst_n,
    input wire       pre_spike,
    input wire       post_spike,
    output wire      weight,
    output reg [7:0] state,
    output reg       spike_flag,
    output wire [7:0]counter
);

// STDP parameters
// parameter max_weight = 127; // Max Synaptic weight
// parameter min_weight = 0; // Min Synaptic weight
// parameter alpha_pos = 2; // STDP positive learning rate
// parameter alpha_neg = 1; // STDP negative learning rate

// standard values of STDP
// tau_pos = 16.8ms
// tau_neg = 33.7ms
// A_pos = 0.78
// A_neg = -0.27

// Internal signals
reg [7:0] weight_internal;


always@(posedge clk) begin
    // if(!rst_n) 
end


endmodule


// lif

module lif (
    input wire [7:0] current,
    input wire       clk,
    input wire       rst_n,
    output wire      spike,
    output reg [7:0] state
);
    reg [7:0] threshold;
    wire [7:0] next_state;

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 230;
        end else begin
            state <= next_state;
        end
    end

// next_state logic and spiking logic
assign spike = (state >= threshold);
assign next_state = (spike ? 0 : current) + spike( ? 0 : (state >> 1)+(state >> 2)+(state >> 3));

endmodule