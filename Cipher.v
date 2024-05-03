module Cipher #(parameter Nk=4,parameter Nr = Nk + 6) ( clk, reset, plainText, keys, encryptedText); 

// Main module parameters
input clk, reset;
input [0:127] plainText;
input [0:(Nk*32) * (Nr + 1) - 1] keys; // whole keys
output reg [0:127] encryptedText;

// temp parameters
wire [0:127] SB_IN, SB_OUT, SR_OUT;
reg [0:127] state [0:Nr]; // array of (128bit wire) of size Nr
wire [0:127] RoundIn, RoundOut,RoundOut1;
reg [0:127] RoundInReg;
reg [3:0] round = 4'b0000; // Counter for the current round


localparam INITIAL_ROUND = 2'b00, ROUNDS = 2'b01, FINAL_ROUND = 2'b10;

reg[1:0] currentstate = INITIAL_ROUND; // Initial state


AddRoundKey ARK (plainText, keys[0:127], RoundIn);
Round #(Nk,Nr) encryptionRound (RoundInReg, keys[128*round+:128], RoundOut);
SubBytes SB (state[Nr - 1], SB_OUT);
shift_rows SR(SB_OUT, SR_OUT);
AddRoundKey ARK1 (SR_OUT, keys[(Nr-1)*128+:128], RoundOut1);


always @(posedge clk or posedge reset) begin
    if (reset) begin
        round <= 4'b0000;
        currentstate <= INITIAL_ROUND;
    end else begin 
        case (currentstate)
            INITIAL_ROUND: begin
                state[0] <= RoundIn;
                encryptedText <= RoundIn;
                RoundInReg <= RoundIn;
                currentstate <= ROUNDS;
            end
            ROUNDS: begin
                if (round < Nr - 1) begin
                    round <= round + 4'b0001; 
                    state[round] <= RoundOut;
                    RoundInReg <= state[round];
                    encryptedText <= RoundOut;
                end else begin
                    currentstate <= FINAL_ROUND;
                end
            end
            FINAL_ROUND: begin
                if(round + 1 == Nr) begin
                encryptedText <= RoundOut1; 
                round <= round + 4'b0001;
                end
            end
        endcase
    end
end
endmodule