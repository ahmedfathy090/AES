module shift_rows(input [0:127] stateIn, output [0:127] stateOut);

    assign stateOut[0:7]   = stateIn[0:7];//0 

    assign stateOut[8:15] = stateIn[40:47];//1

    assign stateOut[16:23] = stateIn[80:87];//2

    assign stateOut[24:31] = stateIn[120:127];//3

    assign stateOut[32:39] = stateIn[32:39];//4

    assign stateOut[40:47] = stateIn[72:79];//5

    assign stateOut[48:55] = stateIn[112:119];//6

    assign stateOut[56:63] = stateIn[24:31];//7

    assign stateOut[64:71] = stateIn[64:71];//8

    assign stateOut[72:79] = stateIn[104:111];//9

    assign stateOut[80:87] = stateIn[16:23];//10

    assign stateOut[88:95] = stateIn[56:63];//11

    assign stateOut[96:103] = stateIn[96:103];//12

    assign stateOut[104:111] = stateIn[8:15];//13

    assign stateOut[112:119] = stateIn[48:55];//14

    assign stateOut[120:127] = stateIn[88:95];//15

endmodule
