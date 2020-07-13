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

type cache_data is array (0 to 13) of std_logic_vector(31 downto 0);
-- Valores de teste
constant cache: cache_data := (
	-- Instrução 0: addi $t0, $0, 5 # Add 0 + 5 and store the result in t0
	"00100000000010000000000000000101",
	-- Instrução 1: addi $t1, $0, 6 # Add 0 + 6 and store the result in t1
	"00100000000010010000000000000110",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	-- Instrução 2: slt  $t2, $t1, $t0 # if($t1 < $t0) $t2 = 1; else $t2 = 0
	"00000001001010000101000000101010",
	-- Instrução 3: slti $t0, $t1, 7   # if($t1 < 0x7) $t0 = 1; else $t0 = 0 
	"00101001001010000000000000000111",
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