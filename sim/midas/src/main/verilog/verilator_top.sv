// Since non-top-level modules cannot be specified with verilator's
// --top-module this provides an alternate top-level module that simply wraps
// FPGATop and exposes otherwise identical I/O

module verilator_top (
  input reg                         ctrl_ar_valid,
  output reg                        ctrl_ar_ready,
  input reg [`CTRL_ADDR_BITS-1:0]   ctrl_ar_bits_addr,
  input reg [`CTRL_ID_BITS-1:0]     ctrl_ar_bits_id,
  input reg [2:0]                   ctrl_ar_bits_size,
  input reg [7:0]                   ctrl_ar_bits_len,

  input reg                         ctrl_aw_valid,
  output reg                        ctrl_aw_ready,
  input reg [`CTRL_ADDR_BITS-1:0]   ctrl_aw_bits_addr,
  input reg [`CTRL_ID_BITS-1:0]     ctrl_aw_bits_id,
  input reg [2:0]                   ctrl_aw_bits_size,
  input reg [7:0]                   ctrl_aw_bits_len,

  input reg                         ctrl_w_valid,
  output reg                        ctrl_w_ready,
  input reg [`CTRL_STRB_BITS-1:0]   ctrl_w_bits_strb,
  input reg [`CTRL_DATA_BITS-1:0]   ctrl_w_bits_data,
  input reg                         ctrl_w_bits_last,

  output reg                        ctrl_r_valid,
  input reg                         ctrl_r_ready,
  output reg  [1:0]                 ctrl_r_bits_resp,
  output reg  [`CTRL_ID_BITS-1:0]   ctrl_r_bits_id,
  output reg  [`CTRL_DATA_BITS-1:0] ctrl_r_bits_data,
  output reg                        ctrl_r_bits_last,

  output reg                        ctrl_b_valid,
  input reg                         ctrl_b_ready,
  output reg  [1:0]                 ctrl_b_bits_resp,
  output reg  [`CTRL_ID_BITS-1:0]   ctrl_b_bits_id,

`ifdef DMA_PRESENT
  input reg                         dma_ar_valid,
  output reg                        dma_ar_ready,
  input reg [`DMA_ADDR_BITS-1:0]    dma_ar_bits_addr,
  input reg [`DMA_ID_BITS-1:0]      dma_ar_bits_id,
  input reg [2:0]                   dma_ar_bits_size,
  input reg [7:0]                   dma_ar_bits_len,

  input reg                         dma_aw_valid,
  output reg                        dma_aw_ready,
  input reg [`DMA_ADDR_BITS-1:0]    dma_aw_bits_addr,
  input reg [`DMA_ID_BITS-1:0]      dma_aw_bits_id,
  input reg [2:0]                   dma_aw_bits_size,
  input reg [7:0]                   dma_aw_bits_len,

  input reg                         dma_w_valid,
  output reg                        dma_w_ready,
  input reg [`DMA_STRB_BITS-1:0]    dma_w_bits_strb,
  input reg [`DMA_DATA_BITS-1:0]    dma_w_bits_data,
  input reg                         dma_w_bits_last,

  output reg                        dma_r_valid,
  input reg                         dma_r_ready,
  output reg  [1:0]                 dma_r_bits_resp,
  output reg  [`DMA_ID_BITS-1:0]    dma_r_bits_id,
  output reg  [`DMA_DATA_BITS-1:0]  dma_r_bits_data,
  output reg                        dma_r_bits_last,

  output reg                        dma_b_valid,
  input reg                         dma_b_ready,
  output reg  [1:0]                 dma_b_bits_resp,
  output reg  [`DMA_ID_BITS-1:0]    dma_b_bits_id,
`endif // DMA_PRESENT

`ifdef FPGA_MANAGED_AXI4_PRESENT
  output reg                        fmaxi4_ar_valid,
  input reg                         fmaxi4_ar_ready,
  output reg  [`FPGA_MANAGED_AXI4_ADDR_BITS-1:0]  fmaxi4_ar_bits_addr,
  output reg  [`FPGA_MANAGED_AXI4_ID_BITS-1:0]    fmaxi4_ar_bits_id,
  output reg  [2:0]                 fmaxi4_ar_bits_size,
  output reg  [7:0]                 fmaxi4_ar_bits_len,

  output reg                        fmaxi4_aw_valid,
  input reg                         fmaxi4_aw_ready,
  output reg  [`FPGA_MANAGED_AXI4_ADDR_BITS-1:0]  fmaxi4_aw_bits_addr,
  output reg  [`FPGA_MANAGED_AXI4_ID_BITS-1:0]    fmaxi4_aw_bits_id,
  output reg  [2:0]                 fmaxi4_aw_bits_size,
  output reg  [7:0]                 fmaxi4_aw_bits_len,

  output reg                        fmaxi4_w_valid,
  input reg                         fmaxi4_w_ready,
  output reg  [(`FPGA_MANAGED_AXI4_DATA_BITS/8)-1:0]  fmaxi4_w_bits_strb,
  output reg  [`FPGA_MANAGED_AXI4_DATA_BITS-1:0]  fmaxi4_w_bits_data,
  output reg                        fmaxi4_w_bits_last,

  input reg                         fmaxi4_r_valid,
  output reg                        fmaxi4_r_ready,
  input reg [1:0]                   fmaxi4_r_bits_resp,
  input reg [`FPGA_MANAGED_AXI4_ID_BITS-1:0]      fmaxi4_r_bits_id,
  input reg [`FPGA_MANAGED_AXI4_DATA_BITS-1:0]    fmaxi4_r_bits_data,
  input reg                         fmaxi4_r_bits_last,

  input reg                         fmaxi4_b_valid,
  output reg                        fmaxi4_b_ready,
  input reg [1:0]                   fmaxi4_b_bits_resp,
  input reg [`FPGA_MANAGED_AXI4_ID_BITS-1:0]      fmaxi4_b_bits_id,
`endif

  output reg                        mem_0_ar_valid,
  input reg                         mem_0_ar_ready,
  output reg  [`MEM_ADDR_BITS-1:0]  mem_0_ar_bits_addr,
  output reg  [`MEM_ID_BITS-1:0]    mem_0_ar_bits_id,
  output reg  [2:0]                 mem_0_ar_bits_size,
  output reg  [7:0]                 mem_0_ar_bits_len,

  output reg                        mem_0_aw_valid,
  input reg                         mem_0_aw_ready,
  output reg  [`MEM_ADDR_BITS-1:0]  mem_0_aw_bits_addr,
  output reg  [`MEM_ID_BITS-1:0]    mem_0_aw_bits_id,
  output reg  [2:0]                 mem_0_aw_bits_size,
  output reg  [7:0]                 mem_0_aw_bits_len,

  output reg                        mem_0_w_valid,
  input reg                         mem_0_w_ready,
  output reg  [`MEM_STRB_BITS-1:0]  mem_0_w_bits_strb,
  output reg  [`MEM_DATA_BITS-1:0]  mem_0_w_bits_data,
  output reg                        mem_0_w_bits_last,

  input reg                         mem_0_r_valid,
  output reg                        mem_0_r_ready,
  input reg [1:0]                   mem_0_r_bits_resp,
  input reg [`MEM_ID_BITS-1:0]      mem_0_r_bits_id,
  input reg [`MEM_DATA_BITS-1:0]    mem_0_r_bits_data,
  input reg                         mem_0_r_bits_last,

  input reg                         mem_0_b_valid,
  output reg                        mem_0_b_ready,
  input reg [1:0]                   mem_0_b_bits_resp,
  input reg [`MEM_ID_BITS-1:0]      mem_0_b_bits_id,

  output reg                        mem_1_ar_valid,
  input reg                         mem_1_ar_ready,
  output reg  [`MEM_ADDR_BITS-1:0]  mem_1_ar_bits_addr,
  output reg  [`MEM_ID_BITS-1:0]    mem_1_ar_bits_id,
  output reg  [2:0]                 mem_1_ar_bits_size,
  output reg  [7:0]                 mem_1_ar_bits_len,
`ifdef MEM_HAS_CHANNEL1
  output reg                        mem_1_aw_valid,
  input reg                         mem_1_aw_ready,
  output reg  [`MEM_ADDR_BITS-1:0]  mem_1_aw_bits_addr,
  output reg  [`MEM_ID_BITS-1:0]    mem_1_aw_bits_id,
  output reg  [2:0]                 mem_1_aw_bits_size,
  output reg  [7:0]                 mem_1_aw_bits_len,

  output reg                        mem_1_w_valid,
  input reg                         mem_1_w_ready,
  output reg  [`MEM_STRB_BITS-1:0]  mem_1_w_bits_strb,
  output reg  [`MEM_DATA_BITS-1:0]  mem_1_w_bits_data,
  output reg                        mem_1_w_bits_last,

  input reg                         mem_1_r_valid,
  output reg                        mem_1_r_ready,
  input reg [1:0]                   mem_1_r_bits_resp,
  input reg [`MEM_ID_BITS-1:0]      mem_1_r_bits_id,
  input reg [`MEM_DATA_BITS-1:0]    mem_1_r_bits_data,
  input reg                         mem_1_r_bits_last,

  input reg                         mem_1_b_valid,
  output reg                        mem_1_b_ready,
  input reg [1:0]                   mem_1_b_bits_resp,
  input reg [`MEM_ID_BITS-1:0]      mem_1_b_bits_id,
`endif
`ifdef MEM_HAS_CHANNEL2
  output reg                        mem_2_ar_valid,
  input reg                         mem_2_ar_ready,
  output reg  [`MEM_ADDR_BITS-1:0]  mem_2_ar_bits_addr,
  output reg  [`MEM_ID_BITS-1:0]    mem_2_ar_bits_id,
  output reg  [2:0]                 mem_2_ar_bits_size,
  output reg  [7:0]                 mem_2_ar_bits_len,

  output reg                        mem_2_aw_valid,
  input reg                         mem_2_aw_ready,
  output reg  [`MEM_ADDR_BITS-1:0]  mem_2_aw_bits_addr,
  output reg  [`MEM_ID_BITS-1:0]    mem_2_aw_bits_id,
  output reg  [2:0]                 mem_2_aw_bits_size,
  output reg  [7:0]                 mem_2_aw_bits_len,

  output reg                        mem_2_w_valid,
  input reg                         mem_2_w_ready,
  output reg  [`MEM_STRB_BITS-1:0]  mem_2_w_bits_strb,
  output reg  [`MEM_DATA_BITS-1:0]  mem_2_w_bits_data,
  output reg                        mem_2_w_bits_last,

  input reg                         mem_2_r_valid,
  output reg                        mem_2_r_ready,
  input reg [1:0]                   mem_2_r_bits_resp,
  input reg [`MEM_ID_BITS-1:0]      mem_2_r_bits_id,
  input reg [`MEM_DATA_BITS-1:0]    mem_2_r_bits_data,
  input reg                         mem_2_r_bits_last,

  input reg                         mem_2_b_valid,
  output reg                        mem_2_b_ready,
  input reg [1:0]                   mem_2_b_bits_resp,
  input reg [`MEM_ID_BITS-1:0]      mem_2_b_bits_id,

`endif
`ifdef MEM_HAS_CHANNEL3
  output reg                        mem_3_ar_valid,
  input reg                         mem_3_ar_ready,
  output reg  [`MEM_ADDR_BITS-1:0]  mem_3_ar_bits_addr,
  output reg  [`MEM_ID_BITS-1:0]    mem_3_ar_bits_id,
  output reg  [2:0]                 mem_3_ar_bits_size,
  output reg  [7:0]                 mem_3_ar_bits_len,

  output reg                        mem_3_aw_valid,
  input reg                         mem_3_aw_ready,
  output reg  [`MEM_ADDR_BITS-1:0]  mem_3_aw_bits_addr,
  output reg  [`MEM_ID_BITS-1:0]    mem_3_aw_bits_id,
  output reg  [2:0]                 mem_3_aw_bits_size,
  output reg  [7:0]                 mem_3_aw_bits_len,

  output reg                        mem_3_w_valid,
  input reg                         mem_3_w_ready,
  output reg  [`MEM_STRB_BITS-1:0]  mem_3_w_bits_strb,
  output reg  [`MEM_DATA_BITS-1:0]  mem_3_w_bits_data,
  output reg                        mem_3_w_bits_last,

  input reg                         mem_3_r_valid,
  output reg                        mem_3_r_ready,
  input reg [1:0]                   mem_3_r_bits_resp,
  input reg [`MEM_ID_BITS-1:0]      mem_3_r_bits_id,
  input reg [`MEM_DATA_BITS-1:0]    mem_3_r_bits_data,
  input reg                         mem_3_r_bits_last,

  input reg                         mem_3_b_valid,
  output reg                        mem_3_b_ready,
  input reg [1:0]                   mem_3_b_bits_resp,
  input reg [`MEM_ID_BITS-1:0]      mem_3_b_bits_id,
`endif
  input reg                          clock,
  input reg                          reset
  );


   /* verilator lint_off PINMISSING */
   FPGATop FPGATop(
     .ctrl_ar_valid(ctrl_ar_valid),
     .ctrl_ar_ready(ctrl_ar_ready),
     .ctrl_ar_bits_addr(ctrl_ar_bits_addr),
     .ctrl_ar_bits_id(ctrl_ar_bits_id),
     .ctrl_ar_bits_size(ctrl_ar_bits_size),
     .ctrl_ar_bits_len(ctrl_ar_bits_len),

     .ctrl_aw_valid(ctrl_aw_valid),
     .ctrl_aw_ready(ctrl_aw_ready),
     .ctrl_aw_bits_addr(ctrl_aw_bits_addr),
     .ctrl_aw_bits_id(ctrl_aw_bits_id),
     .ctrl_aw_bits_size(ctrl_aw_bits_size),
     .ctrl_aw_bits_len(ctrl_aw_bits_len),

     .ctrl_w_valid(ctrl_w_valid),
     .ctrl_w_ready(ctrl_w_ready),
     .ctrl_w_bits_strb(ctrl_w_bits_strb),
     .ctrl_w_bits_data(ctrl_w_bits_data),
     .ctrl_w_bits_last(ctrl_w_bits_last),

     .ctrl_r_valid(ctrl_r_valid),
     .ctrl_r_ready(ctrl_r_ready),
     .ctrl_r_bits_resp(ctrl_r_bits_resp),
     .ctrl_r_bits_id(ctrl_r_bits_id),
     .ctrl_r_bits_data(ctrl_r_bits_data),
     .ctrl_r_bits_last(ctrl_r_bits_last),

    .ctrl_b_valid(ctrl_b_valid),
    .ctrl_b_ready(ctrl_b_ready),
    .ctrl_b_bits_resp(ctrl_b_bits_resp),
    .ctrl_b_bits_id(ctrl_b_bits_id),

`ifdef DMA_PRESENT
    .dma_ar_valid(dma_ar_valid),
    .dma_ar_ready(dma_ar_ready),
    .dma_ar_bits_addr(dma_ar_bits_addr),
    .dma_ar_bits_id(dma_ar_bits_id),
    .dma_ar_bits_size(dma_ar_bits_size),
    .dma_ar_bits_len(dma_ar_bits_len),

    .dma_aw_valid(dma_aw_valid),
    .dma_aw_ready(dma_aw_ready),
    .dma_aw_bits_addr(dma_aw_bits_addr),
    .dma_aw_bits_id(dma_aw_bits_id),
    .dma_aw_bits_size(dma_aw_bits_size),
    .dma_aw_bits_len(dma_aw_bits_len),

    .dma_w_valid(dma_w_valid),
    .dma_w_ready(dma_w_ready),
    .dma_w_bits_strb(dma_w_bits_strb),
    .dma_w_bits_data(dma_w_bits_data),
    .dma_w_bits_last(dma_w_bits_last),

    .dma_r_valid(dma_r_valid),
    .dma_r_ready(dma_r_ready),
    .dma_r_bits_resp(dma_r_bits_resp),
    .dma_r_bits_id(dma_r_bits_id),
    .dma_r_bits_data(dma_r_bits_data),
    .dma_r_bits_last(dma_r_bits_last),

    .dma_b_valid(dma_b_valid),
    .dma_b_ready(dma_b_ready),
    .dma_b_bits_resp(dma_b_bits_resp),
    .dma_b_bits_id(dma_b_bits_id),
`endif

`ifdef FPGA_MANAGED_AXI4_PRESENT
    .fmaxi4_ar_valid(fmaxi4_ar_valid),
    .fmaxi4_ar_ready(fmaxi4_ar_ready),
    .fmaxi4_ar_bits_addr(fmaxi4_ar_bits_addr),
    .fmaxi4_ar_bits_id(fmaxi4_ar_bits_id),
    .fmaxi4_ar_bits_size(fmaxi4_ar_bits_size),
    .fmaxi4_ar_bits_len(fmaxi4_ar_bits_len),

    .fmaxi4_aw_valid(fmaxi4_aw_valid),
    .fmaxi4_aw_ready(fmaxi4_aw_ready),
    .fmaxi4_aw_bits_addr(fmaxi4_aw_bits_addr),
    .fmaxi4_aw_bits_id(fmaxi4_aw_bits_id),
    .fmaxi4_aw_bits_size(fmaxi4_aw_bits_size),
    .fmaxi4_aw_bits_len(fmaxi4_aw_bits_len),

    .fmaxi4_w_valid(fmaxi4_w_valid),
    .fmaxi4_w_ready(fmaxi4_w_ready),
    .fmaxi4_w_bits_strb(fmaxi4_w_bits_strb),
    .fmaxi4_w_bits_data(fmaxi4_w_bits_data),
    .fmaxi4_w_bits_last(fmaxi4_w_bits_last),

    .fmaxi4_r_valid(fmaxi4_r_valid),
    .fmaxi4_r_ready(fmaxi4_r_ready),
    .fmaxi4_r_bits_resp(fmaxi4_r_bits_resp),
    .fmaxi4_r_bits_id(fmaxi4_r_bits_id),
    .fmaxi4_r_bits_data(fmaxi4_r_bits_data),
    .fmaxi4_r_bits_last(fmaxi4_r_bits_last),

    .fmaxi4_b_valid(fmaxi4_b_valid),
    .fmaxi4_b_ready(fmaxi4_b_ready),
    .fmaxi4_b_bits_resp(fmaxi4_b_bits_resp),
    .fmaxi4_b_bits_id(fmaxi4_b_bits_id),
`endif

    .mem_0_ar_valid(mem_0_ar_valid),
    .mem_0_ar_ready(mem_0_ar_ready),
    .mem_0_ar_bits_addr(mem_0_ar_bits_addr),
    .mem_0_ar_bits_id(mem_0_ar_bits_id),
    .mem_0_ar_bits_size(mem_0_ar_bits_size),
    .mem_0_ar_bits_len(mem_0_ar_bits_len),

    .mem_0_aw_valid(mem_0_aw_valid),
    .mem_0_aw_ready(mem_0_aw_ready),
    .mem_0_aw_bits_addr(mem_0_aw_bits_addr),
    .mem_0_aw_bits_id(mem_0_aw_bits_id),
    .mem_0_aw_bits_size(mem_0_aw_bits_size),
    .mem_0_aw_bits_len(mem_0_aw_bits_len),

    .mem_0_w_valid(mem_0_w_valid),
    .mem_0_w_ready(mem_0_w_ready),
    .mem_0_w_bits_strb(mem_0_w_bits_strb),
    .mem_0_w_bits_data(mem_0_w_bits_data),
    .mem_0_w_bits_last(mem_0_w_bits_last),

    .mem_0_r_valid(mem_0_r_valid),
    .mem_0_r_ready(mem_0_r_ready),
    .mem_0_r_bits_resp(mem_0_r_bits_resp),
    .mem_0_r_bits_id(mem_0_r_bits_id),
    .mem_0_r_bits_data(mem_0_r_bits_data),
    .mem_0_r_bits_last(mem_0_r_bits_last),

    .mem_0_b_valid(mem_0_b_valid),
    .mem_0_b_ready(mem_0_b_ready),
    .mem_0_b_bits_resp(mem_0_b_bits_resp),
    .mem_0_b_bits_id(mem_0_b_bits_id),
`ifdef MEM_HAS_CHANNEL1
    .mem_1_ar_valid(mem_1_ar_valid),
    .mem_1_ar_ready(mem_1_ar_ready),
    .mem_1_ar_bits_addr(mem_1_ar_bits_addr),
    .mem_1_ar_bits_id(mem_1_ar_bits_id),
    .mem_1_ar_bits_size(mem_1_ar_bits_size),
    .mem_1_ar_bits_len(mem_1_ar_bits_len),

    .mem_1_aw_valid(mem_1_aw_valid),
    .mem_1_aw_ready(mem_1_aw_ready),
    .mem_1_aw_bits_addr(mem_1_aw_bits_addr),
    .mem_1_aw_bits_id(mem_1_aw_bits_id),
    .mem_1_aw_bits_size(mem_1_aw_bits_size),
    .mem_1_aw_bits_len(mem_1_aw_bits_len),

    .mem_1_w_valid(mem_1_w_valid),
    .mem_1_w_ready(mem_1_w_ready),
    .mem_1_w_bits_strb(mem_1_w_bits_strb),
    .mem_1_w_bits_data(mem_1_w_bits_data),
    .mem_1_w_bits_last(mem_1_w_bits_last),

    .mem_1_r_valid(mem_1_r_valid),
    .mem_1_r_ready(mem_1_r_ready),
    .mem_1_r_bits_resp(mem_1_r_bits_resp),
    .mem_1_r_bits_id(mem_1_r_bits_id),
    .mem_1_r_bits_data(mem_1_r_bits_data),
    .mem_1_r_bits_last(mem_1_r_bits_last),

    .mem_1_b_valid(mem_1_b_valid),
    .mem_1_b_ready(mem_1_b_ready),
    .mem_1_b_bits_resp(mem_1_b_bits_resp),
    .mem_1_b_bits_id(mem_1_b_bits_id),
`endif
`ifdef MEM_HAS_CHANNEL2
    .mem_2_ar_valid(mem_2_ar_valid),
    .mem_2_ar_ready(mem_2_ar_ready),
    .mem_2_ar_bits_addr(mem_2_ar_bits_addr),
    .mem_2_ar_bits_id(mem_2_ar_bits_id),
    .mem_2_ar_bits_size(mem_2_ar_bits_size),
    .mem_2_ar_bits_len(mem_2_ar_bits_len),

    .mem_2_aw_valid(mem_2_aw_valid),
    .mem_2_aw_ready(mem_2_aw_ready),
    .mem_2_aw_bits_addr(mem_2_aw_bits_addr),
    .mem_2_aw_bits_id(mem_2_aw_bits_id),
    .mem_2_aw_bits_size(mem_2_aw_bits_size),
    .mem_2_aw_bits_len(mem_2_aw_bits_len),

    .mem_2_w_valid(mem_2_w_valid),
    .mem_2_w_ready(mem_2_w_ready),
    .mem_2_w_bits_strb(mem_2_w_bits_strb),
    .mem_2_w_bits_data(mem_2_w_bits_data),
    .mem_2_w_bits_last(mem_2_w_bits_last),

    .mem_2_r_valid(mem_2_r_valid),
    .mem_2_r_ready(mem_2_r_ready),
    .mem_2_r_bits_resp(mem_2_r_bits_resp),
    .mem_2_r_bits_id(mem_2_r_bits_id),
    .mem_2_r_bits_data(mem_2_r_bits_data),
    .mem_2_r_bits_last(mem_2_r_bits_last),

    .mem_2_b_valid(mem_2_b_valid),
    .mem_2_b_ready(mem_2_b_ready),
    .mem_2_b_bits_resp(mem_2_b_bits_resp),
    .mem_2_b_bits_id(mem_2_b_bits_id),
`endif
`ifdef MEM_HAS_CHANNEL3
    .mem_3_ar_valid(mem_3_ar_valid),
    .mem_3_ar_ready(mem_3_ar_ready),
    .mem_3_ar_bits_addr(mem_3_ar_bits_addr),
    .mem_3_ar_bits_id(mem_3_ar_bits_id),
    .mem_3_ar_bits_size(mem_3_ar_bits_size),
    .mem_3_ar_bits_len(mem_3_ar_bits_len),

    .mem_3_aw_valid(mem_3_aw_valid),
    .mem_3_aw_ready(mem_3_aw_ready),
    .mem_3_aw_bits_addr(mem_3_aw_bits_addr),
    .mem_3_aw_bits_id(mem_3_aw_bits_id),
    .mem_3_aw_bits_size(mem_3_aw_bits_size),
    .mem_3_aw_bits_len(mem_3_aw_bits_len),

    .mem_3_w_valid(mem_3_w_valid),
    .mem_3_w_ready(mem_3_w_ready),
    .mem_3_w_bits_strb(mem_3_w_bits_strb),
    .mem_3_w_bits_data(mem_3_w_bits_data),
    .mem_3_w_bits_last(mem_3_w_bits_last),

    .mem_3_r_valid(mem_3_r_valid),
    .mem_3_r_ready(mem_3_r_ready),
    .mem_3_r_bits_resp(mem_3_r_bits_resp),
    .mem_3_r_bits_id(mem_3_r_bits_id),
    .mem_3_r_bits_data(mem_3_r_bits_data),
    .mem_3_r_bits_last(mem_3_r_bits_last),

    .mem_3_b_valid(mem_3_b_valid),
    .mem_3_b_ready(mem_3_b_ready),
    .mem_3_b_bits_resp(mem_3_b_bits_resp),
    .mem_3_b_bits_id(mem_3_b_bits_id),
`endif
    .clock(clock),
    .reset(reset)
  );
  /* verilator lint_on PINMISSING */
endmodule;
