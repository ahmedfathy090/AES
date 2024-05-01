module InvRound #(parameter Nk=4,parameter Nr=10) (state, key, InvRoundOut);

// Main module parameters
input [127:0] state;
input [32*Nk-1: 0] key;
output [127:0] InvRoundOut;

// Temp wires
wire [127:0] Inv_SB_OUT, Inv_SR_OUT, Inv_MC_OUT, ARK_OUT;

// Inverse Round steps
Invshift_rows IS_R(state, Inv_SR_OUT);
InvSubBytes IS_B (Inv_SR_OUT, Inv_SB_OUT);
AddRoundKey AR_K(Inv_SB_OUT, ARK_OUT);
InvMixColumns IM_C(ARK_OUT, Inv_MC_OUT);

assign InvRoundOut = Inv_MC_OUT;


endmodule
