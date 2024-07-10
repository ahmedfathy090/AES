module BCDtoSSD (input wire [3:0]  state, input enable, output [6:0] seg);

// If enabled, turn the SS on 
    assign seg = 
    (enable)     ?  7'b1111111 : // if not enabled, turn off
    (state == 0) ?  7'b0000001 :
    (state == 1) ?  7'b1001111 :
    (state == 2) ?  7'b0010010 :
    (state == 3) ?  7'b0000110:
    (state == 4) ?  7'b1001100 :
    (state == 5) ?  7'b0100100 :
    (state == 6) ?  7'b0100000 :
    (state == 7) ?  7'b0001111 :
    (state == 8) ?  7'b0000000 :
    (state == 9) ?  7'b0000100 :
    7'b1111111; // default : turn off
    
endmodule