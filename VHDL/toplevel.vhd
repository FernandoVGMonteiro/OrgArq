library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

entity toplevel is
port (clock:	in std_logic;
		-- Reset está desconectado
		reset:	in std_logic
		);
end entity;

architecture arch of toplevel is

component fluxo_de_dados is
port (clock:			in std_logic;
		functcode:		out  std_logic_vector(5 downto 0);
		opcode:			out  std_logic_vector(5 downto 0);
		contWB:			in std_logic_vector(1 downto 0);
		contM:			in std_logic_vector(2 downto 0);
		contEX:			in std_logic_vector(3 downto 0);
		functcodeULA:	out  std_logic_vector(5 downto 0);
		ulaOpCode:		out  std_logic_vector(1 downto 0);
		ulaOp:			in std_logic_vector(3 downto 0)
);
end component;

component unidade_de_controle is
port (clock:			in  std_logic;
		functcode:		in  std_logic_vector(5 downto 0);
		opcode:			in  std_logic_vector(5 downto 0);
		contWB:			out std_logic_vector(1 downto 0);
		contM:			out std_logic_vector(2 downto 0);
		contEX:			out std_logic_vector(3 downto 0);
		functcodeULA:	in  std_logic_vector(5 downto 0);
		ulaOpCode:		in  std_logic_vector(1 downto 0);
		ulaOp:			out std_logic_vector(3 downto 0)
		
);
end component;

signal functcode:		std_logic_vector(5 downto 0);
signal opcode:			std_logic_vector(5 downto 0);
signal contWB: 		std_logic_vector(1 downto 0);
signal contM: 			std_logic_vector(2 downto 0);
signal contEX:			std_logic_vector(3 downto 0);
signal functcodeULA:	std_logic_vector(5 downto 0);
signal ulaOpcode:		std_logic_vector(1 downto 0);
signal ulaOp:			std_logic_vector(3 downto 0);

begin

fluxoDeDados: fluxo_de_dados
port map(clock, functcode, opcode, contWB, contM, contEX, functcodeULA, ulaOpcode, ulaOp);

unidadeDeControle: unidade_de_controle
port map(clock, functcode, opcode, contWB, contM, contEX, functcodeULA, ulaOpcode, ulaOp);

end architecture;