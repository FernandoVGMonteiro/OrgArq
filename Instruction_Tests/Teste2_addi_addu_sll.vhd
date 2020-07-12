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

type cache_data is array (0 to 18) of std_logic_vector(31 downto 0);
-- Valores de teste
constant cache: cache_data := (
	-- Instrução 0: addi $t0, $0, 3 # Add 0 + 3 and store the result in t0
	"00100000000010000000000000000011",
	-- Instrução 1: addi $t1, $0, 4 # Add 0 + 4 and store the result in t1
	"00100000000010010000000000000100",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	-- Instrução 2: addu $t2, $t0, $t1 # Add t0 + t1 and store the result in t2
	"00000001000010010101000000100001",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	-- Instrução 4: sll $t3, $t2, 2 # Shift the contents of t2 left by 2 bits
	"00000000000010100101100010000000",
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