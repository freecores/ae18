//                              -*- Mode: Verilog -*-
// Filename        : ae18_aram.v
// Description     : AE18 Asynchronous RAM
// Author          : Shawn Tan Ser Ngiap <shawn.tan@aeste.net>
// Created On      : Fri Dec 29 05:12:35 2006
// Last Modified By: Shawn Tan
// Last Modified On: 2006-12-29
// Update Count    : 0
// Status          : Beta/Stable

/*
 *
 * $Id: ae18_aram.v,v 1.2 2006-12-29 18:04:04 sybreon Exp $
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
 * Basic asynchronous inferred RAM.
 *
 * HISTORY
 * $Log
 * 
 */

module ae18_aram (/*AUTOARG*/
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

   reg [ISIZ-1:0]    rMEM [0:(1<<SSIZ)-1];

   assign 	     rdat = rMEM[radr];
   
   always @(posedge clk) begin
      if (we) rMEM[wadr] <= #1 wdat;            
   end     
   
endmodule // ae18_sram
