module fifo(
    input wire clk,
    input wire rstn,
    input wire wr_en, //write enable (habilita escrita)
    input wire rd_en, //read enable (habilita leitura)
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output full,
    output empty
);

reg [1:0] w_ptr;  // vai de 0 a 3 (total de 4 posições)
reg [1:0] r_ptr;  // vai de 0 a 3
reg [7:0] fifo_mem [0:3]; // 4 posições de 8 bits

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        w_ptr <= 2'b00;
        r_ptr <= 2'b00;
        data_out <= 8'bxxxxxxxx; // Inicia como don't care

    end else begin
        // Lógica de escrita
        if (wr_en && !full) begin
            fifo_mem[w_ptr] <= data_in; //Armazena o valor de data_in na posição do FIFO indicada pelo ponteiro de escrita (w_ptr)
            w_ptr <= (w_ptr == 3) ? 0 : w_ptr + 1; //Ternário escrita
        end

        // Lógica de leitura
        if (rd_en && !empty) begin
            data_out <= fifo_mem[r_ptr]; //lê o valor da memória FIFO (fifo_mem) na posição indicada pelo ponteiro de leitura (r_ptr) e envia esse valor para a saída (data_out)
            r_ptr <= (r_ptr == 3) ? 0 : r_ptr + 1; //Ternário leitura
        end

        // Manter data_out estável se não houver leitura
        if (!rd_en || empty) begin
            data_out <= data_out; // Mantém o último valor
        end
    end
end

// Lógicas de full e empty 
assign empty = (w_ptr == r_ptr);
//Se o próximo valor do ponteiro de escrita (w_ptr) + 1 é igual ao ponteiro de leitura (r_ptr) = full
//Se o ponteiro de escrita (w_ptr) está na última posição (3), e o ponteiro de leitura (r_ptr) está na primeira posição (0) = full
assign full = ((w_ptr + 1 == r_ptr) || (w_ptr == 3 && r_ptr == 0));

endmodule
