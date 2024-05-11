module AES #(parameter Nk = 4, parameter Nr = Nk + 6) (clk, enable, reset, successFlag, Units_seg, Tens_seg, Hunds_seg);

// Main module parameters
input clk, reset, enable;
output reg successFlag = 1'b0;
output [0:6] Units_seg, Tens_seg, Hunds_seg;  //7 segment outputs

reg [1:0] ciphersEnables = 2'b10; //Enables for cipher and inverse cipher

wire [0:127] plainText = 128'h00112233445566778899aabbccddeeff; 
wire [0:127] key = 128'h000102030405060708090a0b0c0d0e0f;
wire [0:1407] keysContainer ; // Store the keys for the encryption & decryption

wire [0:127] encryptedText, outPlainText; // Cipher and Inverse Cipher's outputs
wire [0:127] expectedEncrypt= 128'h69c4e0d86a7b0430d8cdb78070b4c55a; // Cipher's expected final round's output


reg [0:127] displayedOut;  //output of each round that should be displayed on 7 segment 
wire [3:0] units, tens, hunds;  //7 segment outputs
reg[3:0] Units_reg, Hunds_reg, Tens_reg;  // store 7 segment outputs in reg


//initially display the plain text
initial begin 
    displayedOut = plainText;  
end

KeysGenerator KG (key, keysContainer);  //Fill the keys container with all keys needed
Cipher #(4, 10) C (clk, reset, ciphersEnables[1], plainText, keysContainer, encryptedText);
InvCipher #(4, 10) IC (clk, reset, ciphersEnables[0],encryptedText , keysContainer, outPlainText);

reg [4:0] roundNumber = 5'd0;

//convert least significant byte of the state to BCD
BCD_E bcd_encoder(displayedOut[127-:8], units, tens, hunds);

always@(*)begin
    Units_reg = units;
    Tens_reg = tens;
    Hunds_reg = hunds;
    
   if(reset) begin
		displayedOut = plainText; // show initial output
   end 
   else begin
		if(roundNumber == 11) begin  // Check final Encryption output 
            successFlag = (encryptedText == expectedEncrypt) ? 1'b1:1'b0; // flag is turned on 
            ciphersEnables= 2'b01; //enable inverse cipher
        end
		else if(roundNumber == 22) begin  // Check decryption output
            successFlag = (outPlainText == plainText) ? 1'b1:1'b0;  //flag is turned on 
            ciphersEnables= 2'b10; //enable cipher
        end
		else begin
            successFlag=1'b0; 
		end
        
        // first 11 rounds display the encrypted text and after that display the out plain text of the decipher
		if(roundNumber <= 11) begin
            displayedOut = encryptedText;
        end
		else if( roundNumber > 11 && roundNumber <=22 ) begin 
           displayedOut = outPlainText;
        
        end 
    end
end


//Display it on seven segment
BCDtoSSD B2S_1 (Units_reg, enable, Units_seg);
BCDtoSSD B2S_2 (Tens_reg, enable, Tens_seg);
BCDtoSSD B2S_3 (Hunds_reg, enable, Hunds_seg);


always @(posedge clk) begin 
    if (reset) begin  // Reset and start again from initial round
        roundNumber <= 5'd0; 
    end 
    else begin
        roundNumber <= roundNumber + 1; // Increment roundNumber each clk
        if(roundNumber==22) begin   // restarting the AES
            roundNumber <= 5'd0;
        end
    end 

    $display("round out :%h ",encryptedText);
    $display("inround out :%h ",outPlainText);
    $display("roundNumber :%d ",roundNumber);
    $display("successFlag :%b ",successFlag);
    $display("displayedOut :%h ",displayedOut);
    $display("Units_re :%d ",Units_reg);
    $display("Tens_re :%d ",Tens_reg);
    $display("Hunds_re :%d ",Hunds_reg);

end 
endmodule