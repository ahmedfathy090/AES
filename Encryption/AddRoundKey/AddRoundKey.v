module AddRoundKey (stateIn, wordKey, stateOut);
// Main module parameters
input [0:127] stateIn;
input [0:127] wordKey;
output [0:127] stateOut;

assign stateOut = stateIn ^ wordKey;

endmodule
