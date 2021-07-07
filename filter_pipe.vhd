----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2021 18:46:33
-- Design Name: 
-- Module Name: filter_pipe - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FILTER_pipe is
 generic(a0 : integer;
         a1 : integer;
         a2 : integer;
         a3 : integer;
         a4 : integer;
         a5 : integer;
         a6 : integer;
         a7 : integer;
         a8 : integer;
         a9 : integer;
         a10 : integer );
         
 port (  Clk : in STD_LOGIC;
         Reset : in STD_LOGIC;
         DataIn : in SIGNED (7 downto 0);
         Enable : in STD_LOGIC;
         DataOut: out SIGNED (7 downto 0));

end FILTER_pipe;

architecture Behavioral of FILTER_pipe is

  type data1 is array (0 to 10) of signed(8 downto 0); -- maximo valor = 52, con 5 btis + 1 (signo) nos da.
  type data3 is array (0 to 10) of signed(7 downto 0);
      signal aX: data3;
      
      signal aY:data3;
      
 constant A : data1 := ( to_signed(a0,9), to_signed( a1,9), to_signed( a2,9), to_signed( a3,9), to_signed( a4,9)
                            , to_signed( a5,9), to_signed( a6,9), to_signed( a7,9), to_signed( a8,9), to_signed( a9,9), 
                          to_signed( a10,9));
      
      type data2 is array (0 to 10) of signed (16 downto 0); 

      signal temp : data2;
      
      signal combY: signed (7 downto 0);

begin

  process(Clk,Reset)
  begin
    if Reset='1' then 
      aX <= (others=> (others=>'0')); 
      aY <= (others=> (others=>'0')); 
      temp(2) <= (others=>'0');
      temp(5) <= (others=>'0');
      temp(8) <= (others=>'0');
    elsif rising_edge(Clk) then 
      if Enable='1' then 
        aX(0) <= dataIn; 
        aX(1) <= aX(0);         
        aX(2) <= aX(1);
        aX(3) <= aX(2);         
        aX(4) <= aX(3); 
        aX(5) <= aX(4);         
        aX(6) <= aX(5); 
        aX(7) <= aX(6);         
        aX(8) <= aX(7); 
        aX(9) <= aX(8);         
        aX(10) <= aX(9);                  
        aY(0) <= combY;
        temp(2) <= temp(1) + A(2)*aX(2);   --
        temp(5) <= temp(4) + A(5)*aX(6);    -- aX(6), he añadido un biestable extra 
        temp(8) <= temp(7) + A(8)*aX(10);   -- aX(10), he añadido 2 biestables extra
           
      end if; 
    end if; 
  end process;


  temp(0) <=           A(0)*aX(0); 
  temp(1) <= temp(0) + A(1)*aX(1);     
 -- temp(2) <= temp(1) + A(2)*aX(2);     
  temp(3) <= temp(2) + A(3)*aX(3);         
  temp(4) <= temp(3) + A(4)*aX(4); 
 -- temp(5) <= temp(4) + A(5)*aX(5);     
  temp(6) <= temp(5) + A(6)*aX(6);     
  temp(7) <= temp(6) + A(7)*aX(7);         
 -- temp(8) <= temp(7) + A(8)*aX(8);
  temp(9) <= temp(8) + A(9)*aX(9); 
  temp(10) <= temp(9) + A(10)*aX(10); 


  combY   <= temp(10)(16 downto 9);


  dataOut <= aY(0);         

end Behavioral;