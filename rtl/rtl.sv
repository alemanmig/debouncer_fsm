// ============================================================================
// db_fsm.v  -  Debouncer basado en FSM (esquema 1: salida retardada)
// Referencia: P. Chu, "FPGA Prototyping by Verilog Examples", sec. 5.3.3,
//             Fig. 5.9 / Listing 5.6.
//
// Cambios respecto al libro (propuestos por el grupo de verificacion):
//   - N es `parameter` (no localparam) para poder simular con N pequeno.
//   - m_tick se expone como puerto de depuracion.
//   - Estados con nombres de la especificacion (wait1_1 ... wait0_3).
//
// Con clk = 50 MHz y N = 19:  T = 2^19 * 20 ns ~= 10.49 ms
// Latencia de db tras un cambio estable de sw: [2T+1, 3T] ciclos.
// ============================================================================
module db_fsm
  #(
    parameter N = 19                 // bits del timer; periodo de tick = 2^N
  )
  (
    input  wire clk,
    input  wire reset,               // asincrono, activo en alto
    input  wire sw,                  // entrada cruda del switch (con rebotes)
    output reg  db,                  // salida filtrada
    output wire m_tick               // depuracion: tick de 10 ms
  );

  // --------------------------------------------------------------------------
  // Codificacion de estados (8 estados -> 3 bits, sin estados ilegales)
  // --------------------------------------------------------------------------
  localparam [2:0]
    ZERO    = 3'b000,
    WAIT1_1 = 3'b001,
    WAIT1_2 = 3'b010,
    WAIT1_3 = 3'b011,
    ONE     = 3'b100,
    WAIT0_1 = 3'b101,
    WAIT0_2 = 3'b110,
    WAIT0_3 = 3'b111;

  reg [N-1:0] q_reg;
  wire [N-1:0] q_next;
  reg [2:0]   state_reg, state_next;

  // --------------------------------------------------------------------------
  // Timer libre: cuenta 0 .. 2^N-1 y da la vuelta; m_tick cuando q_reg == 0
  // --------------------------------------------------------------------------
  always @(posedge clk, posedge reset)
    if (reset)
      q_reg <= {N{1'b0}};
    else
      q_reg <= q_next;

  assign q_next = q_reg + 1'b1;
  assign m_tick = (q_reg == {N{1'b0}});

  // --------------------------------------------------------------------------
  // Registro de estado
  // --------------------------------------------------------------------------
  always @(posedge clk, posedge reset)
    if (reset)
      state_reg <= ZERO;
    else
      state_reg <= state_next;

  // --------------------------------------------------------------------------
  // Logica de siguiente estado y salida (Moore)
  //   - En los estados de espera, el regreso por sw tiene prioridad sobre m_tick
  // --------------------------------------------------------------------------
  always @* begin
    state_next = state_reg;          // por defecto: permanece
    db         = 1'b0;
    case (state_reg)
      ZERO: begin
        db = 1'b0;
        if (sw)
          state_next = WAIT1_1;
      end
      WAIT1_1: begin
        db = 1'b0;
        if (~sw)
          state_next = ZERO;
        else if (m_tick)
          state_next = WAIT1_2;
      end
      WAIT1_2: begin
        db = 1'b0;
        if (~sw)
          state_next = ZERO;
        else if (m_tick)
          state_next = WAIT1_3;
      end
      WAIT1_3: begin
        db = 1'b0;
        if (~sw)
          state_next = ZERO;
        else if (m_tick)
          state_next = ONE;
      end
      ONE: begin
        db = 1'b1;
        if (~sw)
          state_next = WAIT0_1;
      end
      WAIT0_1: begin
        db = 1'b1;
        if (sw)
          state_next = ONE;
        else if (m_tick)
          state_next = WAIT0_2;
      end
      WAIT0_2: begin
        db = 1'b1;
        if (sw)
          state_next = ONE;
        else if (m_tick)
          state_next = WAIT0_3;
      end
      WAIT0_3: begin
        db = 1'b1;
        if (sw)
          state_next = ONE;
        else if (m_tick)
          state_next = ZERO;
      end
      default: begin
        db         = 1'b0;
        state_next = ZERO;
      end
    endcase
  end

endmodule