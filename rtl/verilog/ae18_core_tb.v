//                              -*- Mode: Verilog -*-
// Filename        : ae18_core_tb.v
// Description     : AE18 Simulation Testbench
// Author          : Shawn Tan Ser Ngiap <shawn.tan@aeste.net>
// Created On      : Fri Dec 29 05:02:51 2006
// Last Modified By: Shawn Tan
// Last Modified On: 2006-12-29
// Update Count    : 0
// Status          : Beta/Stable

/*
 *
 * $Id: ae18_core_tb.v,v 1.2 2006-12-29 18:08:11 sybreon Exp $
 * 
 * Copyright (C) 2006 Shawn Tan Ser Ngiap <shawn.tan@aeste.net>
 *  
 * This library is free software; you can redistribute it and/or modify it 
 * under the terms of the GNU Lesser General Public License as published by 
 * the Free Software Foundation; either version 2.1 of the License, 
 * or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful, but 
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public 
 * License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License 
 * along with this library; if not, write to the Free Software Foundation, Inc.,
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 
 *
 * DESCRIPTION
 * Simple unit test with fake ROM and fake RAM contents. It loads the ROM 
 * from the ae18_core.rom file. This file will usually contain the test
 * software from ae18_core.asm in the software directory.
 * 
 * HISTORY
 * $Log: not supported by cvs2svn $
 * 
 */

module ae18_core_tb (/*AUTOARG*/);
   parameter ISIZ = 16;
   parameter DSIZ = 10;
   
   wire [ISIZ-1:1] iwb_adr_o;
   wire [DSIZ-1:0] dwb_adr_o;
   wire [7:0] 	   dwb_dat_o;
   wire [7:0] 	   dwb_dat_i;   
   wire [15:0] 	   iwb_dat_o;
   wire [1:0] 	   iwb_sel_o;
   wire 	   iwb_stb_o, iwb_we_o, dwb_stb_o, dwb_we_o;
   wire [1:0] 	   qfsm_o, qmod_o;
   wire [3:0] 	   qena_o;

   reg 		   clk_i, rst_i;
   reg [1:0] 	   int_i;
   reg [7:6] 	   inte_i;   
   reg 		   dwb_ack_i, iwb_ack_i;
   reg [15:0] 	   iwb_dat_i;   

   // Dump Files
   initial begin
      $dumpfile("ae18_core.vcd");      
      $dumpvars(1, iwb_adr_o,iwb_dat_i,iwb_stb_o,iwb_we_o,iwb_sel_o);
      $dumpvars(1, dwb_adr_o,dwb_dat_i,dwb_dat_o,dwb_we_o,dwb_stb_o);
      $dumpvars(1, clk_i,int_i);      
      $dumpvars(1, dut);      
   end

   initial begin
      clk_i = 1;
      rst_i = 0;
      int_i = 2'b00;

      #50 rst_i = 1;
      #20000 int_i = 2'b10;
      #50 int_i = 2'b00;      
   end

   // Test Points
   initial fork
      #20000 if (dut.rFSM != 2'b11) $display("*** SLEEP error ***");
      #30000 if (dut.rFSM != 2'b00) $display("*** WAKEUP error ***");
      #40000 if (dut.rFSM != 2'b11) $display("*** RESET error ***");
      #60000 if (dut.rFSM != 2'b00) $display("*** WDT error ***");      
      #70000 if (dut.rFSM == 2'b11) $display("Test response OK!!");
      #80000
	$finish;      
   join
   
   always #5 clk_i = ~clk_i;   

   reg [15:0]  rom [0:65535];

   // Load ROM contents
   initial begin
      $readmemh ("ae18_core.rom", rom);
   end   

   // Fake Memory Signals
   always @(posedge clk_i) begin
      dwb_ack_i <= dwb_stb_o;
      iwb_ack_i <= iwb_stb_o;      
      if (iwb_stb_o) iwb_dat_i <= rom[iwb_adr_o];
   end   

   ae18_sram #(8,DSIZ)
     ram (
	  .radr(dwb_adr_o), .wadr(dwb_adr_o),
	  .rdat(dwb_dat_i), .wdat(dwb_dat_o),
	  .we(dwb_we_o & dwb_stb_o),
	  // Inputs
	  .clk	(clk_i));

   // AE18 test core   
   ae18_core #(ISIZ,DSIZ,11)
     dut (/*AUTOINST*/
	  // Outputs
	  .wb_clk_o			(wb_clk_o),
	  .wb_rst_o			(wb_rst_o),
	  .iwb_adr_o			(iwb_adr_o[ISIZ-1:1]),
	  .iwb_dat_o			(iwb_dat_o[15:0]),
	  .iwb_stb_o			(iwb_stb_o),
	  .iwb_we_o			(iwb_we_o),
	  .iwb_sel_o			(iwb_sel_o[1:0]),
	  .dwb_adr_o			(dwb_adr_o[DSIZ-1:0]),
	  .dwb_dat_o			(dwb_dat_o[7:0]),
	  .dwb_stb_o			(dwb_stb_o),
	  .dwb_we_o			(dwb_we_o),
	  // Inputs
	  .iwb_dat_i			(iwb_dat_i[15:0]),
	  .iwb_ack_i			(iwb_ack_i),
	  .dwb_dat_i			(dwb_dat_i[7:0]),
	  .dwb_ack_i			(dwb_ack_i),
	  .int_i			(int_i[1:0]),
	  .inte_i			(inte_i[7:6]),
	  .clk_i			(clk_i),
	  .rst_i			(rst_i));
   
endmodule // ae18_core_tb
