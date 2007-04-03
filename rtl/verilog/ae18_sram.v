//                              -*- Mode: Verilog -*-
// Filename        : ae18_sram.v
// Description     : AE18 Synchronous RAM
// Author          : Shawn Tan Ser Ngiap <shawn.tan@aeste.net>
// Created On      : Fri Dec 29 05:12:03 2006
// Last Modified By: $Author: sybreon $
// Last Modified On: $Date: 2007-04-03 22:10:52 $
// Update Count    : $Revision: 1.3 $
// Status          : $State: Exp $

/*
 *
 * $Id: ae18_sram.v,v 1.3 2007-04-03 22:10:52 sybreon Exp $
 * 
 * AE18 Synchronous Single Port RAM Block
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
 * AE18 small block of RAM.
 * 
 * HISTORY
 * $Log: not supported by cvs2svn $
 * Revision 1.2  2006/12/29 18:03:07  sybreon
 * *** empty log message ***
 * 
 */

module ae18_sram (/*AUTOARG*/
   // Outputs
   rdat,
   // Inputs
   wdat, radr, wadr, we, clk
   );
   parameter ISIZ = 24;
   parameter SSIZ = 5;

   output [ISIZ-1:0] rdat;
   input [ISIZ-1:0]  wdat;
   input [SSIZ-1:0]  radr, wadr;
   input 	     we;   
   input 	     clk;

   reg [SSIZ-1:0]    rADR;
   reg [ISIZ-1:0]    rMEM [0:(1<<SSIZ)-1];

   assign 	     rdat = rMEM[rADR];
   
   always @(posedge clk) begin
      if (we) rMEM[wadr] <= #1 wdat;      
      rADR <= #1 radr;      
   end     

   /* SIMULATION CONSTRUCT */
   integer i;   
   initial begin
      $display ("Clearing RAM block for simulation.");      
      for (i=0;i<((1<<SSIZ)-1);i=i+1)
	rMEM[i] <= 0;      
   end
   
endmodule // ae18_sram
