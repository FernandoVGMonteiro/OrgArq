library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity registrador is
generic (numBits: integer);
port (clock, reset: in std_logic;
		input: in std_logic_vector(numBits - 1 downto 0);
		output: out std_logic_vector(numBits - 1 downto 0) := (others => '0')
		);
end entity;

architecture arch of registrador is
begin

	process(clock, reset)
	begin
	
		if (reset = '1') then
			output <= (others => '0');
		elsif (clock'event and clock = '1') then
			output <= input;
		end if;
			
	end process;

end architecture;