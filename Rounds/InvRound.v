module InvRound (clk ,state, key, InvRoundOut);

// Main module parameters
input clk;
input [0:127] state;
input [0 : 32*Nk -1] key;
output [0:127] InvRoundOut;

// Temp wires
wire [0:127] Inv_SB_OUT, Inv_SR_OUT, Inv_MC_OUT, Inv_ARK_OUT;

// Inverse Round steps
Invshift_rows IS_R(state, Inv_SR_OUT);
InvSubBytes IS_B (Inv_SR_OUT, Inv_SB_OUT);
AddRoundKey AR_K(Inv_SB_OUT, key, Inv_ARK_OUT);
InvMixColumns IM_C(Inv_ARK_OUT, Inv_MC_OUT);

assign InvRoundOut = Inv_MC_OUT;


always @(posedge clk) begin
    $display("InvRound: state = %h, key = %h", state, key);
    $display("InvRound: SR_OUT = %h", Inv_SR_OUT);
    $display("InvRound: SB_OUT = %h", Inv_SB_OUT);
    $display("InvRound: ARK_OUT = %h", Inv_ARK_OUT);
    $display("InvRound: MC_OUT = %h", Inv_MC_OUT); 
end

endmodule
