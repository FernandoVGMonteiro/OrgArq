library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity add_4 is
port (
		input:  in  std_logic_vector(31 downto 0);
		output: out std_logic_vector(31 downto 0)
		);
end entity;

architecture arch of add_4 is

signal output_aux: unsigned(31 downto 0);
signal const4: std_logic_vector(31 downto 0) := "00000000000000000000000000000100";

begin

	output_aux <= unsigned(input) + unsigned(const4);
	output <= std_logic_vector(output_aux);

end architecture;