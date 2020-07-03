library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

entity unidade_de_controle is
port (clock:			in  std_logic;
		functcode:		in  std_logic_vector(5 downto 0);
		opcode:			in  std_logic_vector(5 downto 0);
		contWB:			out std_logic_vector(1 downto 0);
		contM:			out std_logic_vector(2 downto 0);
		contEX:			out std_logic_vector(3 downto 0);
		functcodeULA:	in  std_logic_vector(5 downto 0);
		ulaOpcode:		in  std_logic_vector(1 downto 0);
		ulaOp:			out std_logic_vector(3 downto 0)
		
);
end entity;

architecture arch of unidade_de_controle is

component controle_1 is
port (
		funct: 	in  std_logic_vector(5 downto 0);
		contin:  in  std_logic_vector(5 downto 0);
		cWB: out std_logic_vector(1 downto 0);
		cM:  out std_logic_vector(2 downto 0);
		cEX: out std_logic_vector(3 downto 0)
		);
end component;

component controle_ula is
port (
		input:  in  std_logic_vector(5 downto 0);
		ulaOp:  in  std_logic_vector(1 downto 0);
		output: out std_logic_vector(3 downto 0)
		);
end component;

begin

UC1: controle_1
port map(functcode, opcode, contWB, contM, contEX);

ULA_controle: controle_ula
port map(functcodeULA, ulaOpcode, ulaOp);

end architecture;