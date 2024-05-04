module InvCipher #(parameter Nk=4,parameter Nr = Nk + 6) (clks, reset, encryptedText, keys, decryptedText); 

// Main module parameters
input clks, reset;
input [0:127] encryptedText;
input [0:(Nk*32) * (Nr + 1) - 1] keys; // whole keys
output reg [0:127] decryptedText;

// temp parameters
wire [0:127] Inv_SB_IN, Inv_SB_OUT, Inv_SR_OUT;
wire [0:127] RoundIn, RoundOut,RoundOut1;
reg [0:127] final_round;
reg [0:127] RoundInReg;
reg [3:0] round = 4'b0000; // Counter for the current round


localparam INITIAL_ROUND = 2'b00, ROUNDS = 2'b01, FINAL_ROUND = 2'b10;

reg[1:0] currentstate = INITIAL_ROUND; // Initial state

AddRoundKey ARK (encryptedText, keys[0:127], RoundIn);
InvRound #(Nk,Nr) decryptionRound (clks, RoundInReg, keys[128*(round)+:128], RoundOut);
InvSubBytes SB (final_round, Inv_SB_OUT);
Invshift_rows SR(Inv_SB_OUT, Inv_SR_OUT);
AddRoundKey ARK1 (Inv_SR_OUT, keys[(Nr)*128+:128], RoundOut1);



always @(posedge clks) begin
    $display("Round :%d ",round);
    if (reset) begin
        round <= 4'b0000;
        currentstate <= INITIAL_ROUND;
    end 
        case (currentstate)
            INITIAL_ROUND: begin
                RoundInReg <= RoundIn;
                decryptedText <= RoundIn;
                round <= round + 4'b0001;
                currentstate <= ROUNDS;
            end
            ROUNDS: begin
                if (round < Nr ) begin 
                    RoundInReg <= RoundOut;
                    decryptedText <= RoundOut;
                    round <= round + 4'b0001;
                    if(round == Nr-1 ) begin
                        final_round <= RoundOut;
                        currentstate <= FINAL_ROUND;
                        end
                end
            end
            FINAL_ROUND: begin
             if(round==Nr) begin
                decryptedText <= RoundOut1; 
                round <= round + 4'b0001;
             end
            end
        endcase
    
end



endmodule

