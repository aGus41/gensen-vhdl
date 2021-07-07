----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.02.2021 18:13:44
-- Design Name: 
-- Module Name: GenSen_tb - simulation
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GenSen_tb is
end GenSen_tb;

architecture simulation of GenSen_tb is

    component GenSen
     port (
     Clk : in std_logic;
     Reset : in std_logic;
     per : in std_logic_vector(1 downto 0);
     led : out signed(7 downto 0);
     dac : out unsigned(7 downto 0)
     );
    end component;
   
    signal Clk : std_logic;
    signal Reset :  std_logic;
    signal per :  std_logic_vector(1 downto 0);
    signal led :  signed(7 downto 0);
    signal dac :  unsigned(7 downto 0);
    
    constant SEMIPERIODO: time:= 5 ns;
    constant CICLO: time:= 2*SEMIPERIODO;

begin
    process
    begin
        Clk <= '0'; wait for SEMIPERIODO;
        Clk <= '1'; wait for SEMIPERIODO;
    end process;

    process
    begin
       Reset <= '1'; wait for 2*CICLO; Reset <= '0';
       
       per  <= "00"; wait for 4001 us;
       per  <= "01"; wait for 2001 us;
       per  <= "10"; wait for 1001 us;
       per  <= "11"; wait for 500 us; 
       
       assert FALSE
       report "fin de la simulacion"
        severity FAILURE;
     end process;
 
        
     UUT: GenSen
     port map(
     Clk  => Clk,
     Reset  => Reset,
     per  => per,
     led  => led,
     dac  => dac
     );

end simulation;
