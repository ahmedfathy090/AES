module InvCipher #(parameter Nk=4,parameter Nr = Nk + 6) (clks, reset, encryptedText, keys, decryptedText); 
// Main module parameters
input clks, reset;
input [0:127] encryptedText;
input [0:(Nk*32) * (Nr + 1) - 1] keys; // whole keys
output reg [0:127] decryptedText;

// temp parameters
wire [0:127] Inv_SB_IN, Inv_SB_OUT, Inv_SR_OUT;
reg [0:127] state [0:Nr]; // array of (128bit wire) of size Nr
wire [0:127] RoundIn, RoundOut,RoundOut1;
reg [0:127] RoundInReg;
reg [3:0] round = 4'b0000; // Counter for the current round


localparam INITIAL_ROUND = 2'b00, ROUNDS = 2'b01, FINAL_ROUND = 2'b10;

reg[1:0] currentstate = INITIAL_ROUND; // Initial state
AddRoundKey ARK (encryptedText, keys[0:127], RoundIn);
InvRound #(Nk,Nr) decryptionRound (RoundInReg, keys[128*round+:128], RoundOut);
InvSubBytes SB (state[Nr - 1], Inv_SB_OUT);
Invshift_rows SR(Inv_SB_OUT, Inv_SR_OUT);
AddRoundKey ARK1 (Inv_SR_OUT, keys[(Nr)*128+:128], RoundOut1);


always @(posedge clks or posedge reset) begin
    if (reset) begin
        round <= 4'b0000;
        currentstate <= INITIAL_ROUND;
    end else begin 
        case (currentstate)
            INITIAL_ROUND: begin
                state[0] <= RoundIn;
                decryptedText <= RoundIn;
                RoundInReg <= RoundIn;
                currentstate <= ROUNDS;
                round <= round + 4'b0001; 
            end
            ROUNDS: begin
                if (round < Nr - 1) begin
                    state[round] <= RoundOut;
                    RoundInReg <= state[round];
                    decryptedText <= RoundOut;
                    round <= round + 4'b0001; 
                end else begin
                    currentstate <= FINAL_ROUND;
                end
            end
            FINAL_ROUND: begin
                if(round + 1 == Nr) begin
                decryptedText <= RoundOut1; 
                round <= round + 4'b0001;
                end
            end
        endcase
    end
end

endmodule

