module shift_rows(input [0:127] A, output [0:127] B);


assign B[0:7]   = A[0:7];//0 

assign B[8:15] = A[40:47];//1

assign B[16:23] = A[80:87];//2

assign B[24:31] = A[120:127];//3

assign B[32:39] = A[32:39];//4

assign B[40:47] = A[72:79];//5

assign B[48:55] = A[112:119];//6

assign B[56:63] = A[24:31];//7

assign B[64:71] = A[64:71];//8

assign B[72:79] = A[104:111];//9

assign B[80:87] = A[16:23];//10

assign B[88:95] = A[56:63];//11

assign B[96:103] = A[96:103];//12

assign B[104:111] = A[8:15];//13

assign B[112:119] = A[48:55];//14

assign B[120:127] = A[88:95];//15

endmodule
