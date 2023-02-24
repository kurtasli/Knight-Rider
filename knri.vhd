----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity knri is
    Port ( CLK : in  STD_LOGIC;
           btnR: in  STD_LOGIC;
           btnL: in  STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (7 downto 0));
end knri;
architecture Behavioral of knri is
  signal divcntr: integer;
  constant MAXCNT: integer:=1000000;
  signal clk2 : STD_LOGIC;
  signal cntr : STD_LOGIC_VECTOR(3 downto 0);
  signal Rp,Lp : std_logic;
  signal ffR,ffL : std_logic;
begin
  CLKDIVDR: process(clk,clk2,divcntr) is begin
    if(rising_edge(clk)) then
      if(divcntr>=MAXCNT) then divcntr<=0; clk2<=not(clk2);
      else divcntr<=divcntr+1; end if;
    end if;
  end process;
  MYCNTR: process(clk2,cntr,btnR,btnL,Rp,Lp,ffR,ffL) is begin
    if(rising_edge(clk2)) then
      Rp <= btnR;
      if(Rp&btnR="01") then ffR <='1'; cntr <= "0000"; end if;
      if(ffR='1') then 
         if((cntr="0111")and(btnR='0')) then ffR <= '0'; end if;
         cntr<=cntr+1; 
      end if;
      Lp <= btnL;
      if(Lp&btnL="01") then ffL <='1'; cntr <= "0111"; end if;
      if(ffL='1') then 
         if((cntr="0000")and(btnL='0')) then ffL <= '0'; end if;
         cntr<=cntr-1; 
      end if;
    end if;
  end process;
  LED  <= "00000000" when cntr="1111" else
          "00000001" when cntr="0000" else
          "00000010" when cntr="0001" else
          "00000100" when cntr="0010" else
          "00001000" when cntr="0011" else
          "00010000" when cntr="0100" else
          "00100000" when cntr="0101" else
          "01000000" when cntr="0110" else
          "10000000" when cntr="0111" else
          "00000000"; -- when cntr="1000"

end Behavioral;

