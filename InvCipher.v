module InvCipher #(parameter Nk=4)(clks, reset, enable, encryptedText, keys, decryptedText); 

// Main module parameters
input clks, reset,enable;
input [0:127] encryptedText;
parameter Nr = Nk + 6;
input [0:(Nk*32) * (Nr + 1) - 1] keys; // whole keys
output  [0:127] decryptedText;
 reg [0:127] tempDecryptedText;

// temp parameters
wire [0:127] Inv_SB_IN, Inv_SB_OUT, Inv_SR_OUT;
wire [0:127] RoundIn, RoundOut,RoundOut1;
reg [0:127] final_round;
reg [0:127] RoundInReg;
reg [3:0] round = 4'b0000; // Counter for the current round



localparam INITIAL_ROUND = 2'b00, ROUNDS = 2'b01, FINAL_ROUND = 2'b10;

reg[1:0] currentstate = INITIAL_ROUND; // Initial state

AddRoundKey ARK (encryptedText, keys[1407-:128], RoundIn);
InvRound #(Nk) decryptionRound (clks, RoundInReg, keys[(128*(Nr-round+1)-1)-:128], RoundOut); 
InvSubBytes SB (final_round, Inv_SB_OUT);
Invshift_rows SR(Inv_SB_OUT, Inv_SR_OUT);
AddRoundKey ARK1 (Inv_SR_OUT, keys[0:127], RoundOut1);

always @(posedge clks) begin
    
    $display("Round :%d ",round);
    $display("InvCpher ::  :: :: :: :: :: :: :: :: :: encryptedText :%h ",RoundIn);
    $display("InvCpher ::  :: :: :: :: :: :: :: :: :: decryptedText :%h ",RoundOut);
    if (reset) begin
        round <= 4'b0000;
        currentstate <= INITIAL_ROUND;
    end  else begin
        case (currentstate)
            INITIAL_ROUND: begin
                 RoundInReg <= RoundIn;
                round <= round + 4'b0001;
                tempDecryptedText<=RoundIn;
                currentstate <= ROUNDS;
            end
            ROUNDS: begin
                if (round < Nr ) begin 
                    RoundInReg <= RoundOut;
                    tempDecryptedText<=RoundOut;
                    round <= round + 4'b0001;
                    if(round == Nr-1 ) begin
                        final_round = RoundOut;
                        currentstate <= FINAL_ROUND;
                    end
                end
            end
            FINAL_ROUND: begin
             if(round==Nr) begin
                round <= 4'b0000;
                tempDecryptedText<=RoundOut1;
                currentstate <= INITIAL_ROUND;

             end
            end
        endcase
    end
end
assign decryptedText = tempDecryptedText;


endmodule

