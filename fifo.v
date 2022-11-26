


//Implementing 64x8 Byte FiFo

module fifo(

input [7:0]fifo_in,
input clk,rst,wr,rd,
output reg [7:0]fifo_out,
output reg fifo_full,fifo_empty
);

reg [5:0]rd_ptr,wr_ptr;
reg [6:0]fifo_counter;

reg [7:0] fifo[63:0];//Creating a memory

	//Generating signals based on Counter
	
	always@(fifo_counter)
	begin
		
		fifo_full=fifo_counter==6'd63;
		fifo_empty=fifo_counter==6'd0;
	
	end
	
	//Implementing Counter
	
	always@(posedge clk or posedge rst)
	begin
	
		if(rst)
			
			fifo_counter<=6'd0;
		
		else if((wr&&!fifo_full)&&(rd&&!fifo_empty))
			
			fifo_counter<=fifo_counter;
		
		else if(rd&&!fifo_empty)
			
			fifo_counter<=fifo_counter-1;
			
		else if(wr&&!fifo_full)
			
			fifo_counter<=fifo_counter+1;
		
		else 
			
			fifo_counter<=fifo_counter;
			
	end
	
	//Reading from FiFo

	always@(posedge clk or posedge rst)
	begin 
		
		if(rst)
			
			fifo_out<=8'd0;
		
		else 
			
			begin 
		
				if((rd&&!fifo_empty))
					
					fifo_out<=fifo[rd_ptr];
				
				else
					
					fifo_out<=fifo_out;
		   end
		
	end
	
	//Writing into FIFo
		
	always@(posedge clk)
	begin 
		
		if(wr&&!fifo_full)
			
			fifo[wr_ptr]<=fifo_in;
		
		else
			
			fifo[wr_ptr]<=fifo[wr_ptr];
	end
	
	//updating pointers
	
	always@(posedge clk or posedge rst)
	begin
		
		if(rst) 
			begin
			
			wr_ptr<=6'd0;
			rd_ptr<=6'd0;
			
			end
			
		else
			begin
			
			if(rd&&!fifo_empty)
				
				rd_ptr<=rd_ptr+1;
			else 
				
				rd_ptr<=rd_ptr;
			
			if(wr&&!fifo_full)
				
				wr_ptr<=wr_ptr;
			
			else
				
				wr_ptr<=wr_ptr;
		   end	
	end
endmodule