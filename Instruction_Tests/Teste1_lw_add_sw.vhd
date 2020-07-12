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

type cache_data is array (0 to 17) of std_logic_vector(31 downto 0);
-- Valores de teste
constant cache: cache_data := (
	-- Instrução 0: lw $s1, 7($s2) (Carrega o valor MEM[7 + $s2] no registrador $s1)
	"10001110010100010000000000000111",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	-- Instrução 1: add $t0, $s1, $s2 (Salva em $t0 o valor da soma $s1 + $s2)
	"00000010001100100100000000100000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	-- Instrução 2: sw $t0, 8($s2) (Salva em MEM[8 + $s2] o valor de t0)
	"10101110010010000000000000001000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000"
	);

signal addressInt: integer := 0;
signal addressInt_div4: integer := 0;
	
begin
	
	addressInt <= to_integer(unsigned(address));
	addressInt_div4 <= addressInt / 4;
	dataOut <= cache(addressInt_div4);

end architecture;