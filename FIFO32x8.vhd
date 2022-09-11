library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity FIFO32x8 is
	generic (wide:integer:=8);
   port(
      clk, rst:		in std_logic;
      RdPtrClr, WrPtrClr:	in std_logic;    
      RdInc, WrInc:	in std_logic;
      DataIn:	 in std_logic_vector(wide-1 downto 0);
      DataOut: out std_logic_vector(wide-1 downto 0);
      rden, wren: in std_logic
	);
end entity FIFO32x8;

architecture RTL of FIFO32x8 is
	--signal declarations
	
	constant depth:integer:=32;
	type fifo_array is array(depth-1 downto 0) of std_logic_vector(wide-1 downto 0);  -- makes use of VHDLâs enumerated type
	signal fifo:  fifo_array;
	signal wrptr, rdptr: unsigned(4 downto 0);
	signal dmuxout: std_logic_vector(7 downto 0);--output of mux

begin


	Synchronus_FIFO:process(clk,rst)
	begin 
		
		if(rst='1')then --Ansynchornus reset
			
			for i in 7 downto 0 loop
				
				fifo(i)<=(others=>'0');
			
			end loop;
		
		elsif(rising_edge(clk))then 
			
			if(wren='1')then 
				
				fifo(to_integer(wrptr))<=dataIn;
			end if ;
		end if;
	end process;
	
	dmuxout<=fifo(to_integer(rdptr));
	
	read_counter: process(clk,rdInc,rst)
	begin 
		
		if(rst='1')then 
			
			rdptr<=(others=>'0');
		
		elsif(rising_edge(clk))then 
			
			if(rdInc='1')then 
				
				rdptr<=rdptr+"01";
			
			elsif(rdptrClr='1')then
				
				rdptr<=(others=>'0');
			end if;
		end if;
	end process;
	
	write_counter:process(clk,wrInc)
	begin 
	
		if(rst='1')then 
			
			wrptr<=(others=>'0');
		
		elsif(rising_edge(clk))then
			
			if(wrInc='1')then 
				
				wrptr<=wrptr+"01";
			
			elsif(wrptrClr='1')then 
				
				wrptr<=(others=>'0');
			end if;
		
		end if;
	end process;
	
	three_state: process(clk,rden,rst)
	begin 
		
		if(rden='1')then 
			
			dataOut<=dmuxout;
		else	
			
			dataOut<=(others=>'Z');
		end if;
	
	end process;

end architecture;