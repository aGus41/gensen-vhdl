library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rom is
    port (
        Clk: in std_logic;
        dataOut : out std_logic_vector (7 downto 0); -- Cada dato es de 8 bits
        address : in std_logic_vector (3 downto 0)   -- 16 addresses
    );
end rom;

architecture arch of rom is
    type rom_array is array (0 to 15) of std_logic_vector(7 downto 0);
    
    constant mem: rom_array :=
    (
     "00000000", -- 0
     "00110001",
     "01011010",
     "01110101",
     "01111111", -- 127
     "01110101",
     "01011010",
     "00110001",
     "00000000", -- 0
     "11001111",
     "10100110",
     "10001011",
     "10000001", -- -127
     "10001011",
     "10100110",
     "11001111"
    );
    
begin
    process(clk)
    begin
        if rising_edge(clk) then
            dataOut <= mem(to_integer(unsigned(address)));
        end if;
    end process;
    
end arch;