module mac_engine
( 
    input clk,
    input nrst,

    input logic [7:0][3:0] act_i,
    input logic [7:0][7:0] w_i,
    output logic [7:0][3:0] res_o
);

logic [7:0][6:0] accumulator;

always_comb
begin : partmult
    for(int j=0;j<8;j=j+1) begin
        accumulator[j] = 0;
        for(int i=0;i<8;i=i+1) begin
            accumulator[j] += act_i[i] * w_i[i][j];
        end
    end
end

always_ff @ (posedge clk)
begin
    if (!nrst)
        for(int k=0;k<8;k=k+1)
            res_o[k] <= 0;
    else
        for(int k=0;k<8;k=k+1)
            res_o[k] <= accumulator[k][6:3];
end

endmodule