library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity banco_registradores is
port (rw, ph1, ph2: 		 in std_logic;
		endA, endB, endW:  in  std_logic_vector(4 downto 0);
		dataW: 				 in std_logic_vector(31 downto 0);
		dataA, dataB: 		 out std_logic_vector(31 downto 0) := (others => '0')
		);
end entity;

architecture arch of banco_registradores is

component registrador is
generic (numBits: integer);
port (clock, reset: in std_logic;
		input: in std_logic_vector(numBits - 1 downto 0);
		output: out std_logic_vector(numBits - 1 downto 0) := (others => '0')
		);
end component;


-- Registradores funcionando até o momento: $t0 (8) e $s1-$s2 (17-18)
signal outputT0, outputS1, outputS2: std_logic_vector(31 downto 0);
signal rwT0, rwS1, rwS2: std_logic;

begin

t0Reg: registrador
generic map(32)
port map(rwT0, '0', dataW, outputT0);

s1Reg: registrador
generic map(32)
port map(rwS1, '0', dataW, outputS1);

s2Reg: registrador
generic map(32)
port map(rwS2, '0', dataW, outputS2);

	dataA <= outputT0 when endA = "01000" else
				outputS1 when endA = "10001" else
				outputS2 when endA = "10010" else
				(others => '0');
				
	dataB <= outputT0 when endB = "01000" else
				outputS1 when endB = "10001" else
				outputS2 when endB = "10010" else
				(others => '0');
				
	rwT0 <= rw when endW = "01000" else '0';
	rwS1 <= rw when endW = "10001" else '0';
	rwS2 <= rw when endW = "10010" else '0';
	

end architecture;