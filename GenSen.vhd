----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.02.2021 14:18:29
-- Design Name: 
-- Module Name: GenSen - Behavioral
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
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity GenSen is
 port (Clk : in std_logic;
 Reset : in std_logic;
 per : in std_logic_vector(1 downto 0);
 led : out signed(7 downto 0);
 dac : out unsigned(7 downto 0)
 );
end GenSen;


architecture Behavioral of GenSen is

  component temporizador is
  --generic (MAXCOUNT: integer );
  port (
    MAXCOUNT: in integer range 0 to 10000000;
    Reset: in  std_logic;
    Clk:   in  std_logic;
    Ena:   in  std_logic;
    Clr:   in  std_logic;
    EoC:   out std_logic;
    Q:     out integer range 0 to 10000000
  );
  end component;
  
  component rom is
  port (
    Clk: in std_logic;
    dataOut : out std_logic_vector (7 downto 0);
    address : in std_logic_vector (3 downto 0) 
  );
  end component;
  
  component c_per is 
  port(
    per : in std_logic_vector(1 downto 0);
    per_out: out integer range 0 to 100000000
    );
   end component;
 
 -- COMPONENTE PARALELO  
   
   
--  component FILTER is 
-- generic(a0 : integer;
--         a1 : integer;
--         a2 : integer;
--         a3 : integer;
--         a4 : integer;
--         a5 : integer;
--         a6 : integer;
--         a7 : integer;
--         a8 : integer;
--         a9 : integer;
--         a10 : integer );
         
-- port (  Clk : in STD_LOGIC;
--         Reset : in STD_LOGIC;
--         DataIn : in SIGNED (7 downto 0);
--         Enable : in STD_LOGIC;
--         DataOut: out SIGNED (7 downto 0));

--end component;
   
 component FILTER_pipe is
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

end component;
   
 
        
  signal sMaxCount: integer range 0 to 100000000; -- 100MHz 
  signal EoC1: std_logic;
  --signal Ena: std_logic;
  --signal Clr: std_logic;
  signal Q_rom: integer range 0 to 15;
  signal uQ_rom: std_logic_vector(3 downto 0);
  signal udataOut : std_logic_vector(7 downto 0);   
  
  signal m_EoC: std_logic;
  signal dac_out: signed(7 downto 0);
  
  

begin

  per1: c_per
  port map (
    per => per,
    per_out => sMaxCount
  );
  
  Cont1: temporizador -- cuenta de 0 hasta MAXCOUNT definido por per
  port map (
    MAXCOUNT => sMaxCount,
    Reset => Reset,
    Clk   => Clk  ,
    Ena   => '1'  ,
    Clr   => '0'  ,
    EoC   => EoC1  ,
    Q     => open    
  );
  
  Cont2: temporizador -- Contador que indica el dato de memoria que se muestra en los leds
 -- generic map (
 --     MAXCOUNT => 16 )
  port map (
    MAXCOUNT => 15,
    Reset => Reset,
    Clk   => Clk  ,
    Ena   => EoC1  ,
    Clr   => '0'  ,
    EoC   => open  ,
    Q     => Q_rom    
  );
  
  uQ_rom <= std_logic_vector(to_unsigned(Q_rom,4));
  ROM_m: rom
  port map(
    Clk => Clk,
    address => uQ_rom,
    dataOut => udataOut
  );
  
  

  
  led <= signed(udataOut);
  --dac <= unsigned(udataOut) + "10000000";
  
  


  Cont3: temporizador -- Frecuencia de muestreo Fs = 10KHz
  port map (
    MAXCOUNT => 9998, -- 100 us - Tclk (20 ns)
    Reset => Reset,
    Clk   => Clk  ,
    Ena   => '1'  ,
    Clr   => '0'  ,
    EoC   => m_EoC  ,
    Q     => open    
  );

-- DESCOMENTAR PARA FILTRO PARALELO 


--  filter_p: filter
---- generic map (a0 => -2,  -- valores con K= 9
----             a1  => 22,
----             a2  =>51,
----             a3  => 78,
----             a4  => 98,
----             a5  => 105,
----             a6  => 98,
----             a7  => 78,
----             a8  => 51,
----             a9  => 22,
----             a10 => -2 )

--  generic map (a0 => -1, -- valores con K = 8
--             a1  => 11,
--             a2  =>25,
--             a3  => 39,
--             a4  => 49,
--             a5  => 52,
--             a6  => 49,
--             a7  => 39,
--             a8  => 25,
--             a9  => 11,
--             a10 => -1 )
         
-- port map (  Clk => Clk,
--         Reset => Reset,
--         DataIn  => signed(udataOut),
--         Enable => m_EoC,
--         DataOut => dac_out
--);

  filter2_pipe: filter_pipe
-- generic map (a0 => -2,  -- valores con K= 9
--             a1  => 22,
--             a2  =>51,
--             a3  => 78,
--             a4  => 98,
--             a5  => 105,
--             a6  => 98,
--             a7  => 78,
--             a8  => 51,
--             a9  => 22,
--             a10 => -2 )

  generic map (a0 => -1, -- valores con K = 8
             a1  => 11,
             a2  =>25,
             a3  => 39,
             a4  => 49,
             a5  => 52,
             a6  => 49,
             a7  => 39,
             a8  => 25,
             a9  => 11,
             a10 => -1 )
         
 port map (  Clk => Clk,
         Reset => Reset,
         DataIn  => signed(udataOut),
         Enable => m_EoC,
         DataOut => dac_out
);


dac <= unsigned(dac_out) + "10000000";

  
end Behavioral;
