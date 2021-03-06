library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity extensao_sinal is
port (
		input:  in  std_logic_vector(15 downto 0);
		output: out std_logic_vector(31 downto 0) := (others => '0')
		);
end entity;

architecture arch of extensao_sinal is

signal extended_bit: std_logic_vector(15 downto 0) := (others => '0');

begin

	extended_bit <= (others => input(15));
	output <= extended_bit & input;

end architecture;