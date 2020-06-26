library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity controle_ula is
port (
		input:  in  std_logic_vector(5 downto 0);
		ulaOp:  in  std_logic_vector(1 downto 0);
		output: out std_logic_vector(3 downto 0) := (others => '0')
		);
end entity;

architecture arch of controle_ula is

begin

	-- Instrução: LW ou SW -> OperaçãoULA: ADD
	output <= "0010" when ulaOp = "00" else
	-- Instrução: BEQ -> OperaçãoULA: SUB
				 "0110" when ulaOp = "01" else
	-- Instrução: ADD -> OperaçãoULA: ADD
				 "0010" when ulaOp = "10" and input = "100000" else
	-- Instrução: SUB -> OperaçãoULA: SUB
				 "0110" when ulaOp = "10" and input = "100010" else
	-- Instrução: AND -> OperaçãoULA: AND
				 "0000" when ulaOp = "10" and input = "100100" else
	-- Instrução: OR -> OperaçãoULA: OR
				 "0001" when ulaOp = "10" and input = "100101" else
	-- Instrução: SET_ON_LESS_THAN -> OperaçãoULA: SET_ON_LESS_THAN
				 "0111" when ulaOp = "10" and input = "101010" else
				 "0000"; -- Opção inválida

end architecture;