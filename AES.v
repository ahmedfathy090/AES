module AES #(parameter Nk = 4, parameter Nr = Nk + 6) (clk, enable, reset, successFlag, modeSelector, Units_seg, Tens_seg, Hunds_seg);

// Main module parameters
input clk, reset, enable;
output reg successFlag = 1'b0;
input [1:0] modeSelector;
output [0:6] Units_seg, Tens_seg, Hunds_seg;  //7 segment outputs
reg [5:0] ciphersEnables = 6'b000001; //Enables for cipher and inverse cipher
wire [0:127] plainText = 128'h00112233445566778899aabbccddeeff; 


reg [0:127] displayedOut;  //output of each round that should be displayed on 7 segment 
reg [0:127] expectedOutput = 128'd0;
wire [3:0] units, tens, hunds;  //7 segment outputs
reg[3:0] Units_reg, Hunds_reg, Tens_reg;  // store 7 segment outputs in reg


//initially display the plain text
initial begin 
    displayedOut = plainText;  
end


// == key-128 == mode 00
wire [0:127] encryptedText128, outPlainText128; // Cipher128 and Inverse Cipher128's outputs
wire [0:127] key128 = 128'h000102030405060708090a0b0c0d0e0f;
wire [0:1407] keysContainer128; // Store the 128 bit keys for the encryption & decryption
KeysGenerator #(4, 10) KG128 (key128, keysContainer128);  //Fill the keys container with all keys needed
Cipher #(4) C128 (clk, reset, ciphersEnables[0], plainText, keysContainer128, encryptedText128);
InvCipher #(4) IC128 (clk, reset, ciphersEnables[1], encryptedText128 , keysContainer128, outPlainText128);
wire [0:127] expectedEncrypt128 = 128'h69c4e0d86a7b0430d8cdb78070b4c55a; // Cipher's expected final round's output

// == key-192 == mode 01
wire [0:127] encryptedText192, outPlainText192; // Cipher192 and Inverse Cipher192's outputs
wire [0:191] key192 = 192'h000102030405060708090a0b0c0d0e0f1011121314151617;
wire [0:2495] keysContainer192; // Store the keys for the encryption & decryption
KeysGenerator #(6, 12) KG192 (key192, keysContainer192);  //Fill the keys container with all keys needed
Cipher #(6) C192 (clk, reset, ciphersEnables[2], plainText, keysContainer192, encryptedText192);
InvCipher #(6) IC192 (clk, reset, ciphersEnables[3], encryptedText192 , keysContainer192, outPlainText192);
wire [0:127] expectedEncrypt192 = 128'hdda97ca4864cdfe06eaf70a0ec0d7191; // Cipher's expected final round's output

// == key-256 == mode 10
wire [0:127] encryptedText256, outPlainText256; // Cipher256 and Inverse Cipher256's outputs
wire [0:255] key256 = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
wire [0:3974] keysContainer256; // Store the keys for the encryption & decryption
KeysGenerator #(8, 14) KG256 (key256, keysContainer256);  //Fill the keys container with all keys needed
Cipher #(8) C256 (clk, reset, ciphersEnables[4], plainText, keysContainer256, encryptedText256);
InvCipher #(8) IC256 (clk, reset, ciphersEnables[5], encryptedText256, keysContainer256, outPlainText256);
wire [0:255] expectedEncrypt256 = 256'h8ea2b7ca516745bfeafc49904b496089; // Cipher's expected final round's output

reg [6:0] roundNumber = 7'd0;

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
        if(modeSelector == 2'b00) begin
            if(roundNumber == 11) begin  // Check final Encryption output 
                expectedOutput = expectedEncrypt128; 
                ciphersEnables= 6'b000010; //enable inverse cipher128
            end
            else if(roundNumber == 22) begin  // Check decryption output
                expectedOutput = plainText;  
                ciphersEnables= 6'b000100; // enable cipher192
        end
        
        end
         if (modeSelector == 2'b01) begin //192 mode
            if(roundNumber == 13) begin
                expectedOutput = expectedEncrypt192;
                ciphersEnables= 6'b001000; // enable inverse cipher192
            end
            else if(roundNumber == 26) begin
                expectedOutput = plainText;
                ciphersEnables= 6'b010000; // enable cipher256
	 	    end   
        end
        
        else if (modeSelector == 2'b10) begin
            if(roundNumber == 15) begin
                expectedOutput = expectedEncrypt256;
                ciphersEnables= 6'b100000; // enable inverse cipher256
		end
          else if(roundNumber == 30) begin
                expectedOutput = plainText;
                ciphersEnables= 6'b000001; // enable cipher128
		end
        end
   end
        // first 11 rounds display the encrypted text and after that display the out plain text of the decipher
		  if(roundNumber <= 11 && modeSelector == 2'b00)
            displayedOut = encryptedText128;
		  else if( roundNumber <=22 && modeSelector == 2'b00) 
           displayedOut = outPlainText128; 
        else if(roundNumber <= 13 && modeSelector == 2'b01)
            displayedOut = encryptedText192;
        else if(roundNumber <= 26 && modeSelector == 2'b01)
            displayedOut = outPlainText192;
        else if(roundNumber <= 15 && modeSelector == 2'b10 )
            displayedOut = encryptedText256;
        else if(roundNumber <= 30 && modeSelector == 2'b10)
            displayedOut = outPlainText256;
        else
            displayedOut = 128'd0;
     
    // Check if the final out is the expected output
    successFlag <= (displayedOut == expectedOutput) ? 1'b1 : 1'b0; // flag is turned on
end


//Display it on seven segment
BCDtoSSD B2S_1 (Units_reg, enable, Units_seg);
BCDtoSSD B2S_2 (Tens_reg, enable, Tens_seg);
BCDtoSSD B2S_3 (Hunds_reg, enable, Hunds_seg);


always @(posedge clk) begin 
    if (reset) begin  // Reset and start again from initial round
        roundNumber <= 7'd0; 
    end 
    else begin
        roundNumber <= roundNumber + 1; // Increment roundNumber each clk

        //checks when each mode ends and resets the round number
        if(modeSelector == 2'b00 && roundNumber == 22)
             roundNumber <= 7'd0;
        else if (modeSelector == 2'b01 && roundNumber == 26)
            roundNumber <= 7'd0;
        else if (modeSelector == 2'b10 && roundNumber == 30)
            roundNumber <= 7'd0;
     end
 end 

/*
    $display("round out 128 :%h ",encryptedText128);
    $display("inround out 128 :%h ",outPlainText128);
    $display("round out 192 :%h ",encryptedText192);
    $display("inround out 192 :%h ",outPlainText192);
    $display("round out 256 :%h ",encryptedText256);
    $display("inround out 256 :%h ",outPlainText256);
    $display("roundNumber :%d ",roundNumber);
    $display("successFlag :%b ",successFlag);
    $display("displayedOut :%h ",displayedOut);
    $display("Units_re :%d ",Units_reg);
    $display("Tens_re :%d ",Tens_reg);
    $display("Hunds_re :%d ",Hunds_reg);
    */

endmodule