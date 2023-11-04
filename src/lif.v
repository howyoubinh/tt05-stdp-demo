`default_nettype none

module lif (
    input wire [7:0] current,
    input wire       clk,
    input wire       rst_n,
    output wire      spike,
    output reg [7:0] state,
    input wire [7:0] threshold_val
);
    //local variables
    reg [7:0] threshold;
    wire [7:0] next_state;

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            // threshold <= 230;
            threshold <= threshold_val;
        end else begin
            state <= next_state;
            // threshold <= threshold_val;
        end
    end

// next_state logic and spiking logic
// if state >= threshold, spike = 1 else spike = 0
assign spike = (state >= threshold); // spike if state > threshold

// if spike == 1, next_state = 0 else spike = current + decay (beta)
assign next_state = (spike ? 0 : current) + (spike ? 0 : (state >> 1)+(state >> 2)+(state >> 3));

endmodule