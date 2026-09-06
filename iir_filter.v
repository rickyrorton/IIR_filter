module iir_filter #(
    parameter DATA_WIDTH    = 16,
    parameter OUT_WIDTH     = 24,
    parameter signed B0     = 16'd125,
    parameter signed B1     = 16'd125,
    parameter signed A1     = 16'd32518
)(
    input  wire                          aclk,
    input  wire                          aresetn,
    input  wire signed [DATA_WIDTH-1:0]  s_axis_tdata,
    input  wire                          s_axis_tvalid,
    output reg  signed [OUT_WIDTH-1:0]   m_axis_tdata,
    output reg                           m_axis_tvalid
);

    reg signed [DATA_WIDTH-1:0] x_n1 = 0;
    reg signed [OUT_WIDTH-1:0]  y_n1 = 0;

    wire signed [40:0] full_sum;
    wire signed [40:0] full_sum_round;

    assign full_sum = (B0 * s_axis_tdata)
                    + (B1 * x_n1)
                    + (A1 * y_n1);

    // Add rounding constant (2^14)
    assign full_sum_round = full_sum + 41'sd16384;

    always @(posedge aclk) begin
        if (!aresetn) begin
            x_n1          <= 0;
            y_n1          <= 0;
            m_axis_tdata  <= 0;
            m_axis_tvalid <= 0;
        end else begin
            if (s_axis_tvalid) begin
                m_axis_tdata  <= full_sum_round[38:15];
                y_n1          <= full_sum_round[38:15];
                x_n1          <= s_axis_tdata;
                m_axis_tvalid <= 1;
            end else begin
                m_axis_tvalid <= 0;
            end
        end
    end

endmodule