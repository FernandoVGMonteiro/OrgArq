library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity controle_ula is
port (
		input:  in  std_logic_vector(5 downto 0);
		ulaOp:  in  std_logic_vector(1 downto 0);
		output: out std_logic_vector(3 downto 0)
		);
end entity;

architecture arch of controle_ula is

begin

	-- IMPLEMENTAR O CONTROLE DA ULA

end architecture;