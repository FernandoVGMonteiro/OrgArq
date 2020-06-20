library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity fluxo_de_dados is
port (clock:	in std_logic;
		reset:	in std_logic
		);
end entity;

architecture arch of fluxo_de_dados is

-- Declaração de sinais do Pipeline

-- IF: Instruction Fetch
signal NPC: std_logic_vector(31 downto 0); -- PC + 4
signal NPCJ: std_logic_vector(31 downto 0); -- PC vindo de desvio
signal RIout: std_logic_vector(63 downto 0); -- Saída registrador IF_EX
signal newpc: std_logic_vector(31 downto 0); -- Instrução selecionada (Desvio ou +4)
signal PCa: std_logic_vector(31 downto 0); -- Endereço da nova instrução
signal instrucao: std_logic_vector(31 downto 0); -- Instrução
signal pcsrc: std_logic; -- Seletor da nova instrução
signal Ctc4: std_logic_vector(31 downto 0); -- ??????

-- ID: Instruction Decode
signal contWB: std_logic_vector(1 downto 0);
signal contM: std_logic_vector(2 downto 0);
signal contEX: std_logic_vector(3 downto 0);
signal dataw: std_logic_vector(31 downto 0);
signal enderw: std_logic_vector(4 downto 0);
signal regOutA: std_logic_vector(31 downto 0);
signal regOutB: std_logic_vector(31 downto 0);
signal rw: std_logic;
signal ph1: std_logic;
signal ph2: std_logic;
signal signExtOut: std_logic_vector(31 downto 0);
signal IDEXout: std_logic_vector(146 downto 0);
signal cWBo: std_logic_vector(1 downto 0);
signal cMo:  std_logic_vector(2 downto 0);
signal cEXo: std_logic_vector(3 downto 0);

-- Declaração dos demais componentes
component registrador is
generic (numBits: integer);
port (clock, reset: in std_logic;
		input: in std_logic_vector(numBits - 1 downto 0);
		output: out std_logic_vector(numBits - 1 downto 0)
		);
end component;

component mux2x1 is
generic (numBits: integer);
port (seletor: in std_logic;
		input1, input2: in std_logic_vector(numBits - 1 downto 0);
		output: out std_logic_vector(numBits - 1 downto 0)
		);
end component;

component instruction_cache is
port (clock: in std_logic;
		address: in  std_logic_vector(31 downto 0);
		dataOut: out std_logic_vector(31 downto 0)
		);
end component;

component add_4 is
port (
		input:  in  std_logic_vector(31 downto 0);
		output: out std_logic_vector(31 downto 0)
		);
end component;

component controle_1 is
port (
		contin:  in  std_logic_vector(5 downto 0);
		cWB: out std_logic_vector(1 downto 0);
		cM:  out std_logic_vector(2 downto 0);
		cEX: out std_logic_vector(3 downto 0)
		);
end component;

component banco_registradores is
port (rw, ph1, ph2: 		 in std_logic;
		endA, endB, endW:  in  std_logic_vector(4 downto 0);
		dataW: 				 in std_logic_vector(31 downto 0);
		dataA, dataB: 		 out std_logic_vector(31 downto 0)
		);
end component;

component extensao_sinal is
port (
		input:  in  std_logic_vector(15 downto 0);
		output: out std_logic_vector(31 downto 0)
		);
end component;

begin

-- Componentes Instruction Fetch (IF)
RI: registrador
generic map(64)
port map(clock, reset, NPC & instrucao, RIout);

Mxpc: mux2x1
generic map(32)
port map(pcsrc, NPC, NPCJ, newPC);

PC: registrador
generic map(32)
port map(clock, reset, newpc, PCa);

ICache: instruction_cache
port map(clock, PCa, instrucao);

Soma4: add_4
port map(PCa, NPC);

-- Componentes: Instruction Decode - ID
-- !!! Levar esse componente pra UC
UC1: controle_1
port map(RIout(63 downto 58), contWB, contM, contEX);

MemReg: banco_registradores
port map(rw, ph1, ph2, RIout(57 downto 53), RIout(52 downto 48), enderw, dataw, regOutA, regOutB);

Sign_ext: extensao_sinal
port map(RIout(47 downto 32), signExtOut);


IDEX: registrador
generic map(147)
port map(clock, reset, contWB & contM & contEX & RIout(31 downto 0) & regOutA & regOutB & signExtOut & RIout(52 downto 48) & RIout(47 downto 43), IDEXout);







end architecture;