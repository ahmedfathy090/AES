module AES #(parameter Nk = 4, parameter Nr = Nk + 6) (clk, enable, reset, successFlag, Units_seg, Tens_seg, Hunds_seg);

input clk, reset, enable;
output reg successFlag = 1'b0;
output [0:6] Units_seg, Tens_seg, Hunds_seg;  //7 segment outputs

// Store the keys for the encryption & decryption
wire [0:1407] keysContainer ;//= 1408'h000102030405060708090a0b0c0d0e0fd6aa74fdd2af72fadaa678f1d6ab76feb692cf0b643dbdf1be9bc5006830b3feb6ff744ed2c2c9bf6c590cbf0469bf4147f7f7bc95353e03f96c32bcfd058dfd3caaa3e8a99f9deb50f3af57adf622aa5e390f7df7a69296a7553dc10aa31f6b14f9701ae35fe28c440adf4d4ea9c02647438735a41c65b9e016baf4aebf7ad2549932d1f08557681093ed9cbe2c974e13111d7fe3944a17f307a78b4d2b30c5;


wire [0:127] plainText = 128'h00112233445566778899aabbccddeeff;
wire [0:127] key = 128'h000102030405060708090a0b0c0d0e0f;

wire [0:127] encryptedText, outPlainText;
wire [0:127] expectedEncrypt= 128'h69c4e0d86a7b0430d8cdb78070b4c55a;


reg [0:127] displayedOut;  //output of each round that should be displayed on 7 segment 
wire [3:0] units, tens, hunds;  //7 segment outputs
reg[3:0] Units_reg, Hunds_reg, Tens_reg;  // store 7 segment outputs in reg

reg [1:0] ciphersEnables = 2'b10; //Enables for cipher and inverse cipher


initial begin 
    displayedOut = plainText;  //initially display the plain text
end

KeysGenerator KG (key, keysContainer);  //Fill the keys container with all keys needed
Cipher #(4, 10) C (clk, reset, ciphersEnables[1], plainText, keysContainer, encryptedText);
InvCipher #(4, 10) IC (clk, reset, ciphersEnables[0],encryptedText , keysContainer, outPlainText);

reg [4:0] count = 5'd0;

//convert least significant byte of the state to BCD
BCD_E bcd_encoder(displayedOut[127-:8], units, tens, hunds);

always@(*)begin
    Units_reg = units;
    Tens_reg = tens;
    Hunds_reg = hunds;
    
   if(reset) begin
		displayedOut = plainText;
   end else begin
		if(count == 11) begin  //After Enryption rounds 
        successFlag = (encryptedText == expectedEncrypt) ? 1'b1:1'b0; // flag is turned on 
        ciphersEnables= 2'b01; //enable inverse cipher
        end
		else if(count == 22) begin  //After Decryption Rounds
        successFlag = (outPlainText == plainText) ? 1'b1:1'b0;  //flag is turned on 
        ciphersEnables= 2'b10; //enable cipher
        end
		else begin
        successFlag=1'b0; 
		end
        
        // first 11 rounds display the encrypted text and after that display the out plain text of the decipher
		if(count <= 11) begin
            displayedOut = encryptedText;
        end
		else if( count > 11 && count <=22 ) begin 
           displayedOut = outPlainText;
        
        end 
    end
end


//Display it on seven segment
BCDtoSSD B2S_1 (Units_reg, enable, Units_seg);
BCDtoSSD B2S_2 (Tens_reg, enable, Tens_seg);
BCDtoSSD B2S_3 (Hunds_reg, enable, Hunds_seg);


always @(posedge clk) begin 
    if (reset) begin  //count reset
        count <= 5'd0; 
    end 
    else begin
            count <= count + 1; //increment count each clk
            if(count==22)begin   // restarting the AES
             count <= 5'd0;
        end
    end 

    $display("round out :%h ",encryptedText);
    $display("inround out :%h ",outPlainText);
    $display("count :%d ",count);
    $display("successFlag :%b ",successFlag);
    $display("displayedOut :%h ",displayedOut);
    $display("Units_re :%d ",Units_reg);
    $display("Tens_re :%d ",Tens_reg);
    $display("Hunds_re :%d ",Hunds_reg);

end 
endmodule