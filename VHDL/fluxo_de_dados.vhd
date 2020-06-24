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

-- EX: Instruction Execution
signal sl2Out: std_logic_vector(31 downto 0);
signal npcjEx: std_logic_vector(31 downto 0);
signal ulaInputB: std_logic_vector(31 downto 0);
signal ulaOutput: std_logic_vector(31 downto 0);
signal ulaOp: std_logic_vector(3 downto 0);
signal endReg: std_logic_vector(4 downto 0);
signal zero: std_logic;
signal EXMDout: std_logic_vector(106 downto 0);

-- MEM: Memory Execution
signal ph1MEM, ph2MEM: std_logic;
signal DMout: std_logic_vector(31 downto 0);
signal MEMWBDout: std_logic_vector(102 downto 0);

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

component somador is
port (
		inputA, inputB:  in  std_logic_vector(31 downto 0);
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

component shift_left_2 is
port (
		input:  in  std_logic_vector(31 downto 0);
		output: out std_logic_vector(31 downto 0)
		);
end component;

component ULA is
port(
		A, B:					in  std_logic_vector(31 downto 0);
		Controle:			in  std_logic_vector( 3 downto 0);
		VemUm:				in  std_logic;
		C:						out std_logic_vector(31 downto 0);
		Zero, Overflow:	out std_logic 
		
);
end component;

component controle_ula is
port (
		input:  in  std_logic_vector(5 downto 0);
		ulaOp:  in  std_logic_vector(1 downto 0);
		output: out std_logic_vector(3 downto 0)
		);
end component;

component data_memory is
port (ph1, ph2, memRead, memWrite: in std_logic;
		address, addressW, dataW: in std_logic_vector(31 downto 0);
		dataOutput: out std_logic_vector(31 downto 0)
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

Soma4: somador
port map(PCa, "00000000000000000000000000000100", NPC);

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

-- Componentes: Instruction Execution - EX
SL2: shift_left_2
port map(IDEXout(41 downto 10), sl2Out);

somador2: somador
port map(IDEXout(137 downto 106), sl2Out, npcjEX);

Mux2: mux2x1
generic map(32)
port map(cEXo(3), IDEXout(73 downto 42), IDEXout(41 downto 10), ulaInputB);

Mux1: mux2x1
generic map(5)
port map(cEXo(0), IDEXout(9 downto 5), IDEXout(4 downto 0), endReg);
 
ULA_1: ULA
port map(IDEXout(105 downto 74), ulaInputB, ulaOp, '0', ulaOutput, zero, open);

ULA_controle: controle_ula
port map(IDEXout(15 downto 10), cEXo(2 downto 1), ulaOp);

-- cWBo: 106 downto 105
-- cMo: 104 downto 102
-- Zero: 101
EXMEM: registrador
generic map(107)
port map(clock, reset, IDEXout(146 downto 142) & zero & endReg & IDEXout(73 downto 42) & ulaOutput & npcjEX, EXMDout);

-- Componentes: Memory Execution
memoriaPrincipal: data_memory
port map(ph1MEM, ph2MEM, EXMDout(103), EXMDout(104), EXMDout(63 downto 32), EXMDout(63 downto 32), EXMDout(95 downto 64), DMout);

pcsrc <= EXMDout(102) and EXMDout(101);

NPCJ <= EXMDout(31 downto 0);

-- 100 downto 69: DMout
-- 102 downto 101: cWBp
MEMWB: registrador
generic map(103)
port map(clock, reset, EXMDout(106 downto 105) & DMout & EXMDout(100 downto 96) & EXMDout(95 downto 64) & EXMDout(63 downto 32), MEMWBDout);












end architecture;