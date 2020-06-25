library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity controle_1 is
port (
		-- !!! Descobrir se é (5 downto 0) ou (7 downto 0)
		contin:  in  std_logic_vector(5 downto 0);
		cWB: out std_logic_vector(1 downto 0) := (others => '0');
		cM:  out std_logic_vector(2 downto 0) := (others => '0');
		cEX: out std_logic_vector(3 downto 0) := (others => '0')
		);
end entity;

architecture arch of controle_1 is
begin

	-- MONTAR AQUI AS CONDICÔES DE CONTROLE
	-- DO BLOCO UC1, SLIDE DO INSTRUCTION DECODE
	-- AULA 1 SEMANA 9

end architecture;