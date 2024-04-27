module Round #(parameter Nk=4,parameter Nr=10)(input [127:0] state, input [32*Nk -1: 0] key, output [127:0] roundOut);
wire [127:0] SB_IN;
wire [127:0] SB_OUT, SR_OUT, MC_OUT, ARK_OUT;
assign SB_IN = state;

SubBytes S_B (SB_IN, SB_OUT);
//shift_rows SR(SB_OUT, SR_OUT);
//MixColumns MC(SR_OUT,MC_OUT);
//AddRoundKey ARK(MC_OUT, ARK_OUT);

assign roundOut = SB_OUT;

endmodule
