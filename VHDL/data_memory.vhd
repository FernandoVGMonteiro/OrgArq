library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity data_memory is
port (clock, ph1, ph2, memRead, memWrite: in std_logic;
		address, addressW, dataW: in std_logic_vector(31 downto 0);
		dataOutput: out std_logic_vector(31 downto 0) := (others => '0')
		);
end entity;

architecture arch of data_memory is
type memory_data is array (0 to 15) of std_logic_vector(31 downto 0);
-- Valores de teste
signal memory: memory_data := (
	"00000000000000000000000000000000", -- Valor 0
	"00000000000000000000000000000001", -- Valor 1
	"00000000000000000000000000000010", -- Valor 2
	"00000000000000000000000000000011", -- Valor 3
	"00000000000000000000000000000100", -- Valor 4
	"00000000000000000000000000000101", -- Valor 5
	"00000000000000000000000000000110", -- Valor 6
	"00000000000000000000000000000111", -- Valor 7
	"00000000000000000000000000001000", -- Valor 8
	"00000000000000000000000000001001", -- Valor 9
	"00000000000000000000000000001010", -- Valor 10
	"00000000000000000000000000001011", -- Valor 11
	"00000000000000000000000000001100", -- Valor 12
	"00000000000000000000000000001101", -- Valor 13
	"00000000000000000000000000001110", -- Valor 14
	"00000000000000000000000000001111"  -- Valor 15
	);

signal addressInt: integer := 0;
signal addressWInt: integer := 0;

begin
	
	addressInt <= to_integer(unsigned(address));
	addressWInt <= to_integer(unsigned(addressW));
	
	process(clock, address)
	begin
		
		-- Leitura e escrita em memória acontecem na borda de descida
		if clock'event and clock = '0' then
			if memRead = '1' then
				dataOutput <= memory(addressInt);
			else
				dataOutput <= (others => '0');
			end if;
		end if;
		
	
	end process;
	
	process(clock, addressW)
	begin
		
		-- Leitura e escrita em memória acontecem na borda de descida
		if clock'event and clock = '0' then
			if memWrite = '1' then
				memory(addressWInt) <= dataW;
			end if;
		end if;
		
	end process;
	
end architecture;