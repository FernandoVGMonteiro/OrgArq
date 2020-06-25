library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity instruction_cache is
port (clock: in std_logic;
		address: in  std_logic_vector(31 downto 0);
		dataOut: out std_logic_vector(31 downto 0) := (others => '0')
		);
end entity;

architecture arch of instruction_cache is

type cache_data is array (0 to 6) of std_logic_vector(31 downto 0);
-- Valores de teste
constant cache: cache_data := (
	-- Instrução 0: add $t0, $s1, $s2
	"00000010001100100100000000100000",
	-- Instrução 1
	"00000000000000000000000000001110",
	-- Instrução 2
	"00000000000000000000000000011100",
	-- Instrução 3
	"00000000000000000000000000111000",
	-- Instrução 4
	"00000000000000000000000001110000",
	-- Instrução 5
	"00000000000000000000000011100000",
	-- Instrução 6
	"00000000000000000000000111000000"
	);

signal addressInt: integer := 0;
signal addressInt_div4: integer := 0;
	
begin
	
	addressInt <= to_integer(unsigned(address));
	addressInt_div4 <= addressInt / 4;
	dataOut <= cache(addressInt_div4);

end architecture;