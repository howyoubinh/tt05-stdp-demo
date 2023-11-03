`default_nettype none

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
// spike if state >= threshold
assign spike = (state >= threshold); // spike if state > threshold

// next_state = (0 or current) + (0 or decay)
assign next_state = (spike ? 0 : current) + (spike ? 0 : (state >> 1)+(state >> 2)+(state >> 3));

endmodule