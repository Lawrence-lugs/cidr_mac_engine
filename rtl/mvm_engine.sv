module mvm_engine
#(
    parameter activationBits = 8,
    parameter matBits = 8,
    parameter matH = 3,
    parameter matW = 3,
    localparam outBits = activationBits + matBits + $clog2(matH)
)
( 
    input clk,
    input nrst,

    input [matH-1:0][activationBits-1:0] x_i,
    input [matH-1:0][matW-1:0][matBits-1:0] w_i,
    
    output logic [matW-1:0][outBits-1:0] y_o

    // No saturation logic implemented for now
);

logic [matW-1:0][outBits-1:0] y_o_d;

always_comb
begin : partmult
    for(int j=0;j<matW;j=j+1) begin
        y_o_d[j] = 0;
        for(int i=0;i<matH;i=i+1) begin
            y_o_d[j] += x_i[i] * w_i[i][j];
        end
    end
end

always_ff @( posedge clk or negedge nrst ) begin
    if (!nrst) begin
        y_o <= 0;
    end else begin
        y_o <= y_o_d;
    end
end

endmodule