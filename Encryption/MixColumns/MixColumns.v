module MixColumns(input [0:127] stateIn, output [0:127] stateOut);

/*
    function that performs multiplication by 2 operation, it checks if the leftmost byte equals 0 only shift left, 
	else state byte is shifted and xored with 1b.
*/
     
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
	
	// 11 = 01 ^ 10
	function [7:0] Multiply_3(input[7:0] stateByte);
	    begin
	        Multiply_3 = Multiply_2(stateByte) ^ stateByte;
	    end
	endfunction
	
	/* 
	temporary loop variable to be used during 
	generation and won't be available during simulation
	*/
	genvar i;
	generate
	    for(i = 0; i < 4; i = i + 1) begin
            assign stateOut[i * 32 : i * 32 + 7] = Multiply_2(stateIn[i * 32 : i * 32 + 7]) ^ Multiply_3(stateIn[i*32 + 8 : i*32 + 15]) ^ stateIn[i*32 + 16 : i*32 + 23] ^ stateIn[i*32 + 24 : i*32 + 31];    
		    assign stateOut[i*32 + 8 : i*32 + 15] = stateIn[i * 32 : i * 32 + 7] ^ Multiply_2(stateIn[i*32 + 8 : i*32 + 15]) ^ Multiply_3(stateIn[i*32 + 16 : i*32 + 23]) ^ stateIn[i*32 + 24 : i*32 + 31]; 
			assign stateOut[i*32 + 16 : i*32 + 23] = stateIn[i * 32 : i * 32 + 7] ^ stateIn[i*32 + 8 : i*32 + 15] ^ Multiply_2(stateIn[i*32 + 16 : i*32 + 23]) ^ Multiply_3(stateIn[i*32 + 24 : i*32 + 31]); 
			assign stateOut[i*32 + 24 : i*32 + 31] = Multiply_3(stateIn[i * 32 : i * 32 + 7]) ^ stateIn[i*32 + 8 : i*32 + 15] ^ stateIn[i * 32 + 23 : i * 32 + 16] ^ Multiply_2(stateIn[i*32 + 24 : i*32 + 31]);  	 
	    end
	endgenerate
endmodule
