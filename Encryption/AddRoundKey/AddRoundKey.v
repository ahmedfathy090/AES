module AddRoundKey (stateIn, wordKey, stateOut);
// Main module parameters
input [127:0] stateIn;
input [127:0] wordKey;
output [127:0] stateOut;

assign stateOut = stateIn ^ wordKey;
endmodule
