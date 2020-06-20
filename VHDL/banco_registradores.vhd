library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity banco_registradores is
port (rw, ph1, ph2: 		 in std_logic;
		endA, endB, endW:  in  std_logic_vector(4 downto 0);
		dataW: 				 in std_logic_vector(31 downto 0);
		dataA, dataB: 		 out std_logic_vector(31 downto 0)
		);
end entity;

architecture arch of banco_registradores is
begin

	-- MONTAR BANCO DE REGISTRADORES

end architecture;