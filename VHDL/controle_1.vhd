library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity controle_1 is
port (
		funct: 	in  std_logic_vector(5 downto 0);
		contin:  in  std_logic_vector(5 downto 0);
		cWB: out std_logic_vector(1 downto 0) := (others => '0');
		cM:  out std_logic_vector(2 downto 0) := (others => '0');
		cEX: out std_logic_vector(3 downto 0) := (others => '0')
		);
end entity;

architecture arch of controle_1 is

-- Sinal contendo todos os sinais de controle
signal controle: std_logic_vector(8 downto 0) := (others => '0');

-- Sinais de controle individuais
-- Controle da execução / cálculo de endereço
signal RegDst, ALUOp1, ALUOp0, ALUSrc: std_logic;
-- Controle do acesso à memória
signal Branch, MemRead, MemWrite: std_logic;
-- Controle do WriteBack
signal RegWrite, MemtoReg: std_logic;

begin

	-- Instruções R-type
	controle <= "110000010" when contin = "000000" else
	-- Instrução LW
					"000101011" when contin = "100011" else
	-- Instrução SW 
					"X0010010X" when contin = "101011" else
	-- Instrução BNE
					"X0101000X" when contin = "000101" else
	-- Instrução ADDI
					"000100010" when contin = "001000" else
	-- Instrução SLT
					"011100010" when contin = "001010" else
	-- Instruções inválidas
					"000000000";

	RegDst 	<= controle(8);
	ALUOp1 	<= controle(7);
	ALUOp0 	<= controle(6);
	ALUSrc 	<= controle(5);
	Branch 	<= controle(4);
	MemRead 	<= controle(3);
	MemWrite <= controle(2);
	RegWrite <= controle(1);
	MemtoReg <= controle(0);
	
	cEX <= ALUSrc & ALUOp1 & ALUOp0 & RegDst;
	cM  <= MemWrite & MemRead & Branch;
	cWB <= RegWrite & MemtoReg;
	
end architecture;