module BCDtoSSD (input wire [3:0]  state, input enable, output [6:0] seg);

// If enabled, turn the SS on 
    assign seg = 
    (enable)     ?  7'b1111111 : // if not enabled, turn off
    (state == 0) ?  7'b1000000 :
    (state == 1) ?  7'b1111001 :
    (state == 2) ?  7'b0100100 :
    (state == 3) ?  7'b0110000 :
    (state == 4) ?  7'b0011001 :
    (state == 5) ?  7'b0010010 :
    (state == 6) ?  7'b0000010 :
    (state == 7) ?  7'b1111000 :
    (state == 8) ?  7'b0000000 :
    (state == 9) ?  7'b0010000 :
    (state == 4'ha) ? 7'b0001000 :
    (state == 4'hb) ? 7'b0000011 :
    (state == 4'hc) ? 7'b1000110 :
    (state == 4'hd) ? 7'b0100001 :
    (state == 4'he) ? 7'b0000110 :
    (state == 4'hf) ? 7'b0001110 :
    7'b1111111; // default : turn off
endmodule