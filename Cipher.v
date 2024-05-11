module Cipher #(parameter Nk=4) (clks, reset, enable, plainText, keys, encryptedText); 

// Main module parameters
input clks, reset,enable;
input [0:127] plainText;
parameter Nr = Nk + 6;
input [0:(Nk*32) * (Nr + 1) - 1] keys; // whole keys
output [0:127] encryptedText;
reg [0:127] tempEncryptedText;

// temp parameters
wire [0:127] SB_IN, SB_OUT, SR_OUT;
wire [0:127] RoundIn, RoundOut,RoundOut1;
reg [0:127] final_round;
reg [0:127] RoundInReg;
reg [3:0] round = 4'b0000; // Counter for the current round


localparam INITIAL_ROUND = 2'b00, ROUNDS = 2'b01, FINAL_ROUND = 2'b10;

reg[1:0] currentstate = INITIAL_ROUND; // Initial state

AddRoundKey ARK (plainText, keys[0:127], RoundIn);
Round #(Nk) encryptionRound (clks ,RoundInReg, keys[128*(round)+:128], RoundOut);
SubBytes SB (final_round, SB_OUT);
shift_rows SR(SB_OUT, SR_OUT);
AddRoundKey ARK1 (SR_OUT, keys[(Nr)*128+:128], RoundOut1);



always @(posedge clks) begin
    $display("Round cipher:%d ",round);
     $display("Cpher ::  :: :: :: :: :: :: :: :: :: encryptedText :%h ",RoundIn);
    $display("Cpher ::  :: :: :: :: :: :: :: :: :: decryptedText :%h ",RoundOut);
    if (reset) begin
        round <= 4'b0000;
        currentstate <= INITIAL_ROUND;
    end 
    else begin
        case (currentstate)
            
        INITIAL_ROUND: begin
        RoundInReg <= RoundIn;
        tempEncryptedText <= RoundIn;
        round <= round + 4'b0001;
        currentstate <= ROUNDS;
        end
        
        ROUNDS: begin
        if (round < Nr ) begin 
            RoundInReg <= RoundOut;
            tempEncryptedText <= RoundOut;
            round <= round + 4'b0001; // Encrement round number
        if(round == Nr-1 ) begin
            final_round <= RoundOut;
            currentstate <= FINAL_ROUND;
            end
        end
        end
       
        FINAL_ROUND: begin
            if(round == Nr) begin
            tempEncryptedText <= RoundOut1; 
            round <= 4'b0000;
            currentstate <= INITIAL_ROUND;
            end
        end
        endcase
        end
    
end


assign encryptedText = tempEncryptedText;



endmodule


module Cipher_tb;
    reg clks, reset;
    reg [0:127] plainText;
    reg [0:(4*32) * (11) - 1] keys; // whole keys
    wire [0:127] encryptedText;

    // Instantiate the Cipher module
    Cipher #(4) cipher(clks, reset, plainText, keys, encryptedText);

    // Initialize the inputs
    initial begin
        clks = 0;
        reset = 0;
        plainText = 128'h00112233445566778899aabbccddeeff;
        keys = 1408'h000102030405060708090a0b0c0d0e0fd6aa74fdd2af72fadaa678f1d6ab76feb692cf0b643dbdf1be9bc5006830b3feb6ff744ed2c2c9bf6c590cbf0469bf4147f7f7bc95353e03f96c32bcfd058dfd3caaa3e8a99f9deb50f3af57adf622aa5e390f7df7a69296a7553dc10aa31f6b14f9701ae35fe28c440adf4d4ea9c02647438735a41c65b9e016baf4aebf7ad2549932d1f08557681093ed9cbe2c974e13111d7fe3944a17f307a78b4d2b30c5;
        #1500; 
    end

    // Toggle the clock
    always #100 clks = ~clks;

endmodule