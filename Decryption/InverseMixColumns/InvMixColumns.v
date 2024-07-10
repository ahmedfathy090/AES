module InvMixColumns(input [0:127] stateIn, output [0:127] stateOut);

    function [7:0] Multiply_2(input[7:0] stateByte);
	    begin
	        if(stateByte[7] == 0) 
		        Multiply_2 = stateByte << 1;
		      else begin
		        Multiply_2 = stateByte << 1;
		       	Multiply_2 = Multiply_2 ^ 8'h1b;
		      end
		 end
	endfunction
	
	
	//9 = 8 + 1 -> 1000 ^ 0001 = 1001
	function [7:0] Multiply_9(input[7:0] stateByte);
	    Multiply_9 = Multiply_2(Multiply_2(Multiply_2(stateByte))) ^ stateByte;
	endfunction
	
	//11 = 9 + 2 -> 1001 ^ 0010 = 1011
	function [7:0] Multiply_11(input[7:0] stateByte);
	    Multiply_11 = Multiply_9(stateByte) ^ Multiply_2(stateByte);
	endfunction
	
	//13 = 9 + 4 -> 1001 ^ 0100 = 1101
	function [7:0] Multiply_13(input[7:0] stateByte);
	    Multiply_13 = Multiply_9(stateByte) ^ Multiply_2(Multiply_2(stateByte));
	endfunction
	

    //14 = 8 + 4 + 2  -> 1000 ^ 0100 ^ 0010 = 1110
    function [7:0] Multiply_14(input[7:0] stateByte);
	    Multiply_14 = Multiply_2(Multiply_2(Multiply_2(stateByte))) ^ Multiply_2(Multiply_2(stateByte)) ^ Multiply_2(stateByte);
	endfunction
 
 
    genvar i;
	generate
	    for(i = 0; i < 4; i = i + 1) begin : InvMixColumnsLoop
            assign stateOut[i * 32 : i * 32 + 7] = Multiply_14(stateIn[i * 32 : i * 32 + 7]) ^ Multiply_11(stateIn[i*32 + 8 : i*32 + 15]) ^ Multiply_13(stateIn[i*32 + 16 : i*32 + 23]) ^ Multiply_9(stateIn[i*32 + 24 : i*32 + 31]);    
		    assign stateOut[i*32 + 8 : i*32 + 15] = Multiply_9(stateIn[i * 32 : i * 32 + 7]) ^ Multiply_14(stateIn[i*32 + 8 : i*32 + 15]) ^ Multiply_11(stateIn[i*32 + 16 : i*32 + 23]) ^ Multiply_13(stateIn[i*32 + 24 : i*32 + 31]);
		    assign stateOut[i*32 + 16 : i*32 + 23] = Multiply_13(stateIn[i * 32 : i * 32 + 7]) ^ Multiply_9(stateIn[i*32 + 8 : i*32 + 15]) ^ Multiply_14(stateIn[i*32 + 16 : i*32 + 23]) ^ Multiply_11(stateIn[i*32 + 24 : i*32 + 31]); 
		    assign stateOut[i*32 + 24 : i*32 + 31] = Multiply_11(stateIn[i * 32 : i * 32 + 7]) ^ Multiply_13(stateIn[i*32 + 8 : i*32 + 15]) ^ Multiply_9(stateIn[i*32 + 16 : i*32 + 23]) ^ Multiply_14(stateIn[i*32 + 24 : i*32 + 31]);  	 
	    end
	endgenerate
	
endmodule


