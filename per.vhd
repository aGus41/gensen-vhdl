----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.02.2021 14:50:36
-- Design Name: 
-- Module Name: per - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity c_per is
  Port ( 
   per : in std_logic_vector(1 downto 0);
   per_out: out integer range 0 to 100000000
);
end c_per;

architecture Behavioral of c_per is

begin

  process(per)
  begin
    case per is
    when "00" => per_out <= 12500; -- f = 500 Hz, 
    when "01" => per_out <= 6250;  --f = 1000 Hz
    when "10" => per_out <= 3125;  -- f = 2000 Hz
    when others => per_out <= 1563;  -- f = 4000 Hz
    end case;
  end process;


end Behavioral;
