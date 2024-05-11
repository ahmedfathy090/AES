module key_expansion #(parameter Nk=4, parameter Nr = Nk + 6) (input [0: (32 * Nk) - 1] wIn, output [0:(32 * Nk) - 1] wOut , input [0:3] roundNum); 

function [0:7] SBox (input [0:7] In);
begin
case (In)
8'h00: SBox = 8'h63;
8'h01: SBox = 8'h7c;
8'h02: SBox = 8'h77;
8'h03: SBox = 8'h7b;
8'h04: SBox = 8'hf2;
8'h05: SBox = 8'h6b;
8'h06: SBox = 8'h6f;
8'h07: SBox = 8'hc5;
8'h08: SBox = 8'h30;
8'h09: SBox = 8'h01;
8'h0a: SBox = 8'h67;
8'h0b: SBox = 8'h2b;
8'h0c: SBox = 8'hfe;
8'h0d: SBox = 8'hd7;
8'h0e: SBox = 8'hab;
8'h0f: SBox = 8'h76;
8'h10: SBox = 8'hca;
8'h11: SBox = 8'h82;
8'h12: SBox = 8'hc9;
8'h13: SBox = 8'h7d;
8'h14: SBox = 8'hfa;
8'h15: SBox = 8'h59;
8'h16: SBox = 8'h47;
8'h17: SBox = 8'hf0;
8'h18: SBox = 8'had;
8'h19: SBox = 8'hd4;
8'h1a: SBox = 8'ha2;
8'h1b: SBox = 8'haf;
8'h1c: SBox = 8'h9c;
8'h1d: SBox = 8'ha4;
8'h1e: SBox = 8'h72;
8'h1f: SBox = 8'hc0;
8'h20: SBox = 8'hb7;
8'h21: SBox = 8'hfd;
8'h22: SBox = 8'h93;
8'h23: SBox = 8'h26;
8'h24: SBox = 8'h36;
8'h25: SBox = 8'h3f;
8'h26: SBox = 8'hf7;
8'h27: SBox = 8'hcc;
8'h28: SBox = 8'h34;
8'h29: SBox = 8'ha5;
8'h2a: SBox = 8'he5;
8'h2b: SBox = 8'hf1;
8'h2c: SBox = 8'h71;
8'h2d: SBox = 8'hd8;
8'h2e: SBox = 8'h31;
8'h2f: SBox = 8'h15;
8'h30: SBox = 8'h04;
8'h31: SBox = 8'hc7;
8'h32: SBox = 8'h23;
8'h33: SBox = 8'hc3;
8'h34: SBox = 8'h18;
8'h35: SBox = 8'h96;
8'h36: SBox = 8'h05;
8'h37: SBox = 8'h9a;
8'h38: SBox = 8'h07;
8'h39: SBox = 8'h12;
8'h3a: SBox = 8'h80;
8'h3b: SBox = 8'he2;
8'h3c: SBox = 8'heb;
8'h3d: SBox = 8'h27;
8'h3e: SBox = 8'hb2;
8'h3f: SBox = 8'h75;
8'h40: SBox = 8'h09;
8'h41: SBox = 8'h83;
8'h42: SBox = 8'h2c;
8'h43: SBox = 8'h1a;
8'h44: SBox = 8'h1b;
8'h45: SBox = 8'h6e;
8'h46: SBox = 8'h5a;
8'h47: SBox = 8'ha0;
8'h48: SBox = 8'h52;
8'h49: SBox = 8'h3b;
8'h4a: SBox = 8'hd6;
8'h4b: SBox = 8'hb3;
8'h4c: SBox = 8'h29;
8'h4d: SBox = 8'he3;
8'h4e: SBox = 8'h2f;
8'h4f: SBox = 8'h84;
8'h50: SBox = 8'h53;
8'h51: SBox = 8'hd1;
8'h52: SBox = 8'h00;
8'h53: SBox = 8'hed;
8'h54: SBox = 8'h20;
8'h55: SBox = 8'hfc;
8'h56: SBox = 8'hb1;
8'h57: SBox = 8'h5b;
8'h58: SBox = 8'h6a;
8'h59: SBox = 8'hcb;
8'h5a: SBox = 8'hbe;
8'h5b: SBox = 8'h39;
8'h5c: SBox = 8'h4a;
8'h5d: SBox = 8'h4c;
8'h5e: SBox = 8'h58;
8'h5f: SBox = 8'hcf;
8'h60: SBox = 8'hd0;
8'h61: SBox = 8'hef;
8'h62: SBox = 8'haa;
8'h63: SBox = 8'hfb;
8'h64: SBox = 8'h43;
8'h65: SBox = 8'h4d;
8'h66: SBox = 8'h33;
8'h67: SBox = 8'h85;
8'h68: SBox = 8'h45;
8'h69: SBox = 8'hf9;
8'h6a: SBox = 8'h02;
8'h6b: SBox = 8'h7f;
8'h6c: SBox = 8'h50;
8'h6d: SBox = 8'h3c;
8'h6e: SBox = 8'h9f;
8'h6f: SBox = 8'ha8;
8'h70: SBox = 8'h51;
8'h71: SBox = 8'ha3;
8'h72: SBox = 8'h40;
8'h73: SBox = 8'h8f;
8'h74: SBox = 8'h92;
8'h75: SBox = 8'h9d;
8'h76: SBox = 8'h38;
8'h77: SBox = 8'hf5;
8'h78: SBox = 8'hbc;
8'h79: SBox = 8'hb6;
8'h7a: SBox = 8'hda;
8'h7b: SBox = 8'h21;
8'h7c: SBox = 8'h10;
8'h7d: SBox = 8'hff;
8'h7e: SBox = 8'hf3;
8'h7f: SBox = 8'hd2;
8'h80: SBox = 8'hcd;
8'h81: SBox = 8'h0c;
8'h82: SBox = 8'h13;
8'h83: SBox = 8'hec;
8'h84: SBox = 8'h5f;
8'h85: SBox = 8'h97;
8'h86: SBox = 8'h44;
8'h87: SBox = 8'h17;
8'h88: SBox = 8'hc4;
8'h89: SBox = 8'ha7;
8'h8a: SBox = 8'h7e;
8'h8b: SBox = 8'h3d;
8'h8c: SBox = 8'h64;
8'h8d: SBox = 8'h5d;
8'h8e: SBox = 8'h19;
8'h8f: SBox = 8'h73;
8'h90: SBox = 8'h60;
8'h91: SBox = 8'h81;
8'h92: SBox = 8'h4f;
8'h93: SBox = 8'hdc;
8'h94: SBox = 8'h22;
8'h95: SBox = 8'h2a;
8'h96: SBox = 8'h90;
8'h97: SBox = 8'h88;
8'h98: SBox = 8'h46;
8'h99: SBox = 8'hee;
8'h9a: SBox = 8'hb8;
8'h9b: SBox = 8'h14;
8'h9c: SBox = 8'hde;
8'h9d: SBox = 8'h5e;
8'h9e: SBox = 8'h0b;
8'h9f: SBox = 8'hdb;
8'ha0: SBox = 8'he0;
8'ha1: SBox = 8'h32;
8'ha2: SBox = 8'h3a;
8'ha3: SBox = 8'h0a;
8'ha4: SBox = 8'h49;
8'ha5: SBox = 8'h06;
8'ha6: SBox = 8'h24;
8'ha7: SBox = 8'h5c;
8'ha8: SBox = 8'hc2;
8'ha9: SBox = 8'hd3;
8'haa: SBox = 8'hac;
8'hab: SBox = 8'h62;
8'hac: SBox = 8'h91;
8'had: SBox = 8'h95;
8'hae: SBox = 8'he4;
8'haf: SBox = 8'h79;
8'hb0: SBox = 8'he7;
8'hb1: SBox = 8'hc8;
8'hb2: SBox = 8'h37;
8'hb3: SBox = 8'h6d;
8'hb4: SBox = 8'h8d;
8'hb5: SBox = 8'hd5;
8'hb6: SBox = 8'h4e;
8'hb7: SBox = 8'ha9;
8'hb8: SBox = 8'h6c;
8'hb9: SBox = 8'h56;
8'hba: SBox = 8'hf4;
8'hbb: SBox = 8'hea;
8'hbc: SBox = 8'h65;
8'hbd: SBox = 8'h7a;
8'hbe: SBox = 8'hae;
8'hbf: SBox = 8'h08;
8'hc0: SBox = 8'hba;
8'hc1: SBox = 8'h78;
8'hc2: SBox = 8'h25;
8'hc3: SBox = 8'h2e;
8'hc4: SBox = 8'h1c;
8'hc5: SBox = 8'ha6;
8'hc6: SBox = 8'hb4;
8'hc7: SBox = 8'hc6;
8'hc8: SBox = 8'he8;
8'hc9: SBox = 8'hdd;
8'hca: SBox = 8'h74;
8'hcb: SBox = 8'h1f;
8'hcc: SBox = 8'h4b;
8'hcd: SBox = 8'hbd;
8'hce: SBox = 8'h8b;
8'hcf: SBox = 8'h8a;
8'hd0: SBox = 8'h70;
8'hd1: SBox = 8'h3e;
8'hd2: SBox = 8'hb5;
8'hd3: SBox = 8'h66;
8'hd4: SBox = 8'h48;
8'hd5: SBox = 8'h03;
8'hd6: SBox = 8'hf6;
8'hd7: SBox = 8'h0e;
8'hd8: SBox = 8'h61;
8'hd9: SBox = 8'h35;
8'hda: SBox = 8'h57;
8'hdb: SBox = 8'hb9;
8'hdc: SBox = 8'h86;
8'hdd: SBox = 8'hc1;
8'hde: SBox = 8'h1d;
8'hdf: SBox = 8'h9e;
8'he0: SBox = 8'he1;
8'he1: SBox = 8'hf8;
8'he2: SBox = 8'h98;
8'he3: SBox = 8'h11;
8'he4: SBox = 8'h69;
8'he5: SBox = 8'hd9;
8'he6: SBox = 8'h8e;
8'he7: SBox = 8'h94;
8'he8: SBox = 8'h9b;
8'he9: SBox = 8'h1e;
8'hea: SBox = 8'h87;
8'heb: SBox = 8'he9;
8'hec: SBox = 8'hce;
8'hed: SBox = 8'h55;
8'hee: SBox = 8'h28;
8'hef: SBox = 8'hdf;
8'hf0: SBox = 8'h8c;
8'hf1: SBox = 8'ha1;
8'hf2: SBox = 8'h89;
8'hf3: SBox = 8'h0d;
8'hf4: SBox = 8'hbf;
8'hf5: SBox = 8'he6;
8'hf6: SBox = 8'h42;
8'hf7: SBox = 8'h68;
8'hf8: SBox = 8'h41;
8'hf9: SBox = 8'h99;
8'hfa: SBox = 8'h2d;
8'hfb: SBox = 8'h0f;
8'hfc: SBox = 8'hb0;
8'hfd: SBox = 8'h54;
8'hfe: SBox = 8'hbb;
8'hff: SBox = 8'h16;
default:SBox  = 8'h00;

endcase
end
endfunction




// function rotWord that takes a word and perform cyclic permutation
function [0:31] rotWord(input [0:31] in);
begin
    rotWord = {in[8:31], in[0:7]};
end   
endfunction

function [0:31] subWord(input [0:31] in);
begin
    subWord[0:7] = SBox(in[0:7]);
    subWord[8:15] = SBox(in[8:15]);
    subWord[16:23] = SBox(in[16:23]);
    subWord[24:31] = SBox(in[24:31]);
end
endfunction


  function [0:31] roundConst ( input [0:3] roundNum);
begin
    case(roundNum)
    1: roundConst = 32'h01000000;
    2: roundConst = 32'h02000000;
    3: roundConst = 32'h04000000;
    4: roundConst = 32'h08000000;
    5: roundConst = 32'h10000000;
    6: roundConst = 32'h20000000;
    7: roundConst = 32'h40000000;
    8: roundConst = 32'h80000000;
    9: roundConst = 32'h1b000000;
    10: roundConst = 32'h36000000;
    default: roundConst = 32'h00000000;
    endcase
end
endfunction


reg [0:31] temp_wOut;
assign wOut [0:31] = temp_wOut;

initial begin
    if(Nk == 4)
        temp_wOut[0:31] = subWord(rotWord(wIn[96:127])) ^ roundConst(roundNum) ^ wIn[0:31]; 
    else if (Nk == 6)
        temp_wOut[0:31] = subWord(rotWord(wIn[160:191])) ^ roundConst(roundNum) ^ wIn[0:31];
    else if (Nk == 8)
        temp_wOut[0:31] = subWord(rotWord(wIn[160:255])) ^ roundConst(roundNum) ^ wIn[0:31];
end

genvar i;
generate 
for(i = 1; i < Nk; i = i + 1) begin : KE
    if(Nk == 8 && i == 4) 
       assign wOut[i*32 +: 32] = subWord(wOut[(i-1)*32 +: 32]) ^ wIn[i*32 +: 32];
    else
       assign wOut[i*32 +: 32] = wOut[(i-1)*32 +: 32] ^ wIn[i*32 +: 32];
end
endgenerate

endmodule 
