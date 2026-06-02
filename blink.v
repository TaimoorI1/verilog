module blink;
  reg clk = 0;
  reg [3:0] count = 0;

  always #5 clk = ~clk;
  always @(posedge clk) count <= count + 1;
  always @(posedge clk) $display("time=%0t count=%0d", $time, count);

  initial begin
    $dumpfile("blink.vcd");
    $dumpvars(0, blink);
    #100 $finish;
  end
endmodule