library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity somador is
port (
		inputA, inputB:  in  std_logic_vector(31 downto 0);
		output: out std_logic_vector(31 downto 0) := (others => '0')
		);
end entity;

architecture arch of somador is

signal output_aux: unsigned(31 downto 0) := (others => '0');

begin

	output_aux <= unsigned(inputA) + unsigned(inputB);
	output <= std_logic_vector(output_aux);

end architecture;