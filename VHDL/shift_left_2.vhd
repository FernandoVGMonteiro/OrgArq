library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity shift_left_2 is
port (
		input:  in  std_logic_vector(31 downto 0);
		output: out std_logic_vector(31 downto 0)
		);
end entity;

architecture arch of shift_left_2 is

begin

	output <= input(29 downto 0) & "00";

end architecture;