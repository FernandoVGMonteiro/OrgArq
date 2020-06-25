library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity mux2x1 is
generic (numBits: integer);
port (seletor: in std_logic;
		input1, input2: in std_logic_vector(numBits - 1 downto 0);
		output: out std_logic_vector(numBits - 1 downto 0) := (others => '0')
		);
end entity;

architecture arch of mux2x1 is
begin

	output <= input2 when seletor = '1' else
				 input1;

end architecture;