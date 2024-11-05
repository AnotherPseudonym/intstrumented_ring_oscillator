`default_nettype none

parameter N_STAGES = 25;

module iro (
    input rst_n,
    input enable, hold,
    input bclk, bdat, // Positive edge clocked in
    input [3:0] n_stages,
    output [15:0] phases
);

    reg [N_STAGES-1:0] seed; // The initial state for the ring oscillator. Feed with SPI like protocol.

    // Show the seed state on the output pins.
    //assign { P1B10, P1B9, P1B8, P1B7, P1B4, P1B3, P1B2, P1B1, P1A10, P1A9, P1A8, P1A7, P1A4, P1A3, P1A2, P1A1 } = seed;

    // Show inputs and some connect phases.
    //assign { P1B10, P1B9, P1B8, P1B7, P1B4, P1B3, P1B2, P1B1 }  = {NSTAGES0, NSTAGES1, NSTAGES2, NSTAGES3, enable, hold, bdat, bclk };
    //assign { P1A10, P1A9, P1A8, P1A7, P1A4, P1A3, P1A2, P1A1}  = connect;

    assign phases = connect[15:0];

    always @(posedge bclk, negedge rst_n) begin
        if (!rst_n) begin
            seed <= {32'b0};
        end else begin
            seed[0] <= { bdat };
            seed[N_STAGES-1:1] <= seed[N_STAGES-2:0];
        end
    end

    // A simple ring oscillator needs an odd number of stages > 2, but in case 3 is too fast, 5 is the minimum.
    wire [N_STAGES-1:0] connect;
    ro_stage ro0  (.enable (enable), .in0 (connect[24]), .in1 (connect[24]), .in_select ( 1'b0),        .seed (seed[11]), .out (connect[ 0]));
    ro_stage ro1  (.enable (enable), .in0 (connect[ 0]), .in1 (    1'b0   ), .in_select (  hold ),      .seed (seed[12]), .out (connect[ 1]));
    ro_stage ro2  (.enable (enable), .in0 (connect[ 1]), .in1 (connect[ 1]), .in_select ( 1'b0 ),       .seed (seed[13]), .out (connect[ 2]));
    ro_stage ro3  (.enable (enable), .in0 (connect[ 2]), .in1 (connect[ 2]), .in_select ( 1'b0 ),       .seed (seed[14]), .out (connect[ 3]));
    ro_stage ro4  (.enable (enable), .in0 (connect[ 3]), .in1 (connect[ 3]), .in_select ( 1'b0 ),       .seed (seed[15]), .out (connect[ 4]));
    ro_stage ro5  (.enable (enable), .in0 (connect[ 4]), .in1 (connect[ 4]), .in_select ( 1'b0 ),       .seed (seed[16]), .out (connect[ 5]));
    ro_stage ro6  (.enable (enable), .in0 (connect[ 5]), .in1 (connect[ 5]), .in_select ( 1'b0 ),       .seed (seed[17]), .out (connect[ 6]));
    ro_stage ro7  (.enable (enable), .in0 (connect[ 6]), .in1 (connect[ 6]), .in_select ( 1'b0 ),       .seed (seed[18]), .out (connect[ 7]));
    ro_stage ro8  (.enable (enable), .in0 (connect[ 7]), .in1 (connect[ 7]), .in_select ( 1'b0),        .seed (seed[19]), .out (connect[ 8]));
    ro_stage ro9  (.enable (enable), .in0 (connect[ 8]), .in1 (connect[ 8]), .in_select ( 1'b0 ),       .seed (seed[20]), .out (connect[ 9]));
    ro_stage ro10 (.enable (enable), .in0 (connect[ 9]), .in1 (connect[ 9]), .in_select ( 1'b0 ),       .seed (seed[21]), .out (connect[10]));
    ro_stage ro11 (.enable (enable), .in0 (connect[10]), .in1 (connect[10]), .in_select ( 1'b0 ),       .seed (seed[22]), .out (connect[11]));
    ro_stage ro12 (.enable (enable), .in0 (connect[11]), .in1 (connect[11]), .in_select ( 1'b0 ),       .seed (seed[23]), .out (connect[12]));
    ro_stage ro13 (.enable (enable), .in0 (connect[12]), .in1 (connect[12]), .in_select ( 1'b0 ),       .seed (seed[24]), .out (connect[13]));
    ro_stage ro14 (.enable (enable), .in0 (connect[13]), .in1 (connect[13]), .in_select (n_stages >10), .seed (seed[ 0]), .out (connect[14]));
    ro_stage ro15 (.enable (enable), .in0 (connect[12]), .in1 (connect[14]), .in_select (n_stages > 9), .seed (seed[ 1]), .out (connect[15]));
    ro_stage ro16 (.enable (enable), .in0 (connect[11]), .in1 (connect[15]), .in_select (n_stages > 8), .seed (seed[ 2]), .out (connect[16]));    
    ro_stage ro17 (.enable (enable), .in0 (connect[10]), .in1 (connect[16]), .in_select (n_stages > 7), .seed (seed[ 3]), .out (connect[17]));
    ro_stage ro18 (.enable (enable), .in0 (connect[ 9]), .in1 (connect[17]), .in_select (n_stages > 6), .seed (seed[ 4]), .out (connect[18]));
    ro_stage ro19 (.enable (enable), .in0 (connect[ 8]), .in1 (connect[18]), .in_select (n_stages > 5), .seed (seed[ 5]), .out (connect[19]));
    ro_stage ro20 (.enable (enable), .in0 (connect[ 7]), .in1 (connect[19]), .in_select (n_stages > 4), .seed (seed[ 6]), .out (connect[20]));
    ro_stage ro21 (.enable (enable), .in0 (connect[ 6]), .in1 (connect[20]), .in_select (n_stages > 3), .seed (seed[ 7]), .out (connect[21]));
    ro_stage ro22 (.enable (enable), .in0 (connect[ 5]), .in1 (connect[21]), .in_select (n_stages > 2), .seed (seed[ 8]), .out (connect[22]));
    ro_stage ro23 (.enable (enable), .in0 (connect[ 4]), .in1 (connect[22]), .in_select (n_stages > 1), .seed (seed[ 9]), .out (connect[23]));
    ro_stage ro24 (.enable (enable), .in0 (connect[ 3]), .in1 (connect[23]), .in_select (n_stages > 0), .seed (seed[10]), .out (connect[24]));
endmodule

(* keep_hierarchy = "yes" *) module ro_stage(input enable, input in0, input in1, input in_select, input seed, output out);
    // All combinatorial logic.
    if (1) begin
        assign out = (enable == 0)?(seed):((!in_select)?(!in0):(!in1)); // This runs faster on the fpga
    end else begin
        always @(enable, in0, in1, in_select, seed) begin
            if (enable == 0) begin
                out = seed;
            end else begin
                if (!in_select) 
                    out = !in0;
                else
                    out = !in1;
            end
        end // always 
    end // if generate

endmodule
