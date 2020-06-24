library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity data_memory is
port (ph1, ph2, memRead, memWrite: in std_logic;
		address, addressW, dataW: in std_logic_vector(31 downto 0);
		dataOutput: out std_logic_vector(31 downto 0)
		);
end entity;

architecture arch of data_memory is
begin

	-- PRECISA IMPLEMENTAR A MEMÓRIA PRINCIPAL

end architecture;