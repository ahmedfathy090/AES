module Round #(parameter Nk=4,parameter Nr=10) (state, key, InvRoundOut);

// Main module parameters
input [127:0] state;
input [32*Nk -1: 0] key;
output [127:0] InvRoundOut;

// Temp wires
wire [127:0] Inv_SB_OUT, Inv_SR_OUT, Inv_MC_OUT, Inv_ARK_OUT;

// Inverse Round steps
Invshift_rows ISR(state, Inv_SR_OUT);
InvSubBytes ISB (Inv_SR_OUT, Inv_SB_OUT);
AddRoundKey ARK(Inv_SB_OUT, ARK_OUT);
InvMixColumns IMC(ARK_OUT, Inv_MC_OUT);

assign InvRoundOut = Inv_MC_OUT;

endmodule
