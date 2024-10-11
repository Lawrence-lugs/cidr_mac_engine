`timescale 1ns/1ps

module tb_mac_engine;

parameter int unsigned CLK_PERIOD = 20;
localparam nTestVectors = 50;
localparam activationBits = 8;
localparam matBits = 8;
localparam matH = 3;
localparam matW = 3;
localparam outBits = activationBits + matBits + $clog2(matH);

logic clk, nrst;
logic [matH-1:0][activationBits-1:0] x_i;
logic [matH-1:0][matW-1:0][matBits-1:0] w_i;
logic [matW-1:0][outBits-1:0] y_o;

mvm_engine #(
    .activationBits(activationBits),
    .matBits(matBits),
    .matH(matH),
    .matW(matW)
) mac_inst (
    .clk(clk),
    .nrst(nrst),
    .x_i(x_i),
    .w_i(w_i),
    .y_o(y_o)
);


always
    #(CLK_PERIOD/2) clk = ~clk;

int outs_ref;
logic [outBits-1:0] out_ref;
int acts_file;
int weights_file;

int err_cnt;

initial begin
    $vcdpluson; // Please comment out if using Vivado

    $display("===============");

    outs_ref = $fopen("../tb/mvm/outs.csv","r");
    acts_file = $fopen("../tb/mvm/acts.csv","r");
    weights_file = $fopen("../tb/mvm/weights.csv","r");

    err_cnt = 0;
    clk = 0;
    nrst = 0;
    #(CLK_PERIOD * 5)
    nrst = 1;

    for(int l=0;l<nTestVectors;l++) begin

        for(int i=0;i<matH;i++) begin
            $fscanf(acts_file,"%d ", x_i[i]);
            for(int j=0;j<matW;j++) begin
                $fscanf(weights_file,"%d ", w_i[i][j]);
            end
        end

        #(CLK_PERIOD);

        for(int k=0;k<matW;k++) begin
            $fscanf(outs_ref,"%d ", out_ref);
            if(out_ref != y_o[k]) begin
                $display("%d. Error at output (line %d, col %d),%d vs expected %d",err_cnt+1,l,k,y_o[k],out_ref);
                err_cnt++;
            end
        end
    end

    #(CLK_PERIOD * 20)

    if(err_cnt)
        $display("%d errors were detected.",err_cnt);
    else
        $display("Simulation success. No errors were detected.");

    $display("===============");
    $finish();

end

endmodule