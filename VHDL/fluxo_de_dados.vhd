library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity fluxo_de_dados is
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
end entity;

architecture arch of fluxo_de_dados is

signal reset: std_logic := '0';

-- Declaração de sinais do Pipeline

-- IF: Instruction Fetch
signal NPC: std_logic_vector(31 downto 0) := (others => '0'); -- PC + 4
signal NPCJ: std_logic_vector(31 downto 0) := (others => '0'); -- PC vindo de desvio
signal RIin: std_logic_vector(63 downto 0) := (others => '0'); -- Saída registrador IF_EX
signal RIout: std_logic_vector(63 downto 0) := (others => '0'); -- Saída registrador IF_EX
signal newpc: std_logic_vector(31 downto 0) := (others => '0'); -- Instrução selecionada (Desvio ou +4)
signal PCa: std_logic_vector(31 downto 0) := (others => '0'); -- Endereço da nova instrução
signal instrucao: std_logic_vector(31 downto 0) := (others => '0'); -- Instrução
signal pcsrc: std_logic := '0'; -- Seletor da nova instrução

-- ID: Instruction Decode
signal dataw: std_logic_vector(31 downto 0) := (others => '0');
signal enderw: std_logic_vector(4 downto 0) := (others => '0');
signal regOutA: std_logic_vector(31 downto 0) := (others => '0');
signal regOutB: std_logic_vector(31 downto 0) := (others => '0');
signal rw: std_logic := '0';
signal ph1: std_logic := '0';
signal ph2: std_logic := '0';
signal signExtOut: std_logic_vector(31 downto 0) := (others => '0');
signal IDEXin: std_logic_vector(151 downto 0) := (others => '0');
signal IDEXout: std_logic_vector(151 downto 0) := (others => '0');
signal cEXo: std_logic_vector(3 downto 0) := (others => '0');

-- EX: Instruction Execution
signal sl2Out: std_logic_vector(31 downto 0) := (others => '0');
signal npcjEx: std_logic_vector(31 downto 0) := (others => '0');
signal ulaInputB: std_logic_vector(31 downto 0) := (others => '0');
signal ulaOutput: std_logic_vector(31 downto 0) := (others => '0');
signal endReg: std_logic_vector(4 downto 0) := (others => '0');
signal zero: std_logic;
signal EXMDin: std_logic_vector(106 downto 0) := (others => '0');
signal EXMDout: std_logic_vector(106 downto 0) := (others => '0');

-- MEM: Memory Execution
signal ph1MEM, ph2MEM: std_logic := '0';
signal DMout: std_logic_vector(31 downto 0) := (others => '0');
signal MEMWBin: std_logic_vector(102 downto 0) := (others => '0');
signal MEMWBout: std_logic_vector(102 downto 0) := (others => '0');

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
		Zero, Overflow:	out std_logic;
		Shamt:				in  std_logic_vector(4 downto 0)
		
);
end component;

component data_memory is
port (clock, ph1, ph2, memRead, memWrite: in std_logic;
		address, addressW, dataW: in std_logic_vector(31 downto 0);
		dataOutput: out std_logic_vector(31 downto 0)
		);
end component;

begin

-- Componentes Instruction Fetch (IF)
-- Instr: (63 downto 32)
-- NPC:   (31 downto 0)
RIin <= instrucao & NPC;

RI: registrador
generic map(64)
port map(clock, reset, RIin, RIout);

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

-- CONTROLE 1
functcode <= RIout(37 downto 32);
opcode <= RIout(63 downto 58);

MemReg: banco_registradores
port map(rw, ph1, ph2, RIout(57 downto 53), RIout(52 downto 48), enderw, dataw, regOutA, regOutB);

Sign_ext: extensao_sinal
port map(RIout(47 downto 32), signExtOut);

-- Shamt:(151 downto 147)
-- cWB:  (146 downto 145)
-- cM:   (144 downto 142)
-- cEX:  (141 downto 138)
-- rt:   (137 downto 133)
-- rd:   (132 downto 128)
-- sext: (127 downto 96)
-- Regb: (95 downto 64)
-- Rega: (63 downto 32)
-- NPC:  (31 downto 0)
IDEXin <= RIout(42 downto 38) & contWB & contM & contEX & RIout(52 downto 48) & RIout(47 downto 43) & signExtOut & regOutA & regOutB & RIout(31 downto 0);

IDEX: registrador
generic map(152)
port map(clock, reset, IDEXin, IDEXout);

-- Componentes: Instruction Execution - EX
cEXo <= IDEXout(141 downto 138);

SL2: shift_left_2 -- Entra saída do SignExtend
port map(IDEXout(127 downto 96), sl2Out);

somador2: somador -- NPC + SignExtend deslocado
port map(IDEXout(31 downto 0), sl2Out, npcjEX);

Mux2: mux2x1 -- Seleciona entre RegA e saída do SignExtend
generic map(32)
port map(cEXo(3), IDEXout(63 downto 32), IDEXout(127 downto 96), ulaInputB);

Mux1: mux2x1 -- Seleciona entre RT e RD
generic map(5)
port map(cEXo(0), IDEXout(137 downto 133), IDEXout(132 downto 128), endReg);
 
ULA_1: ULA
port map(IDEXout(95 downto 64), ulaInputB, ulaOp, '0', ulaOutput, zero, open, IDEXout(151 downto 147));

-- CONTROLE ULA
functCodeULA <= IDEXout(101 downto 96);
ulaOpcode <= cEXo(2 downto 1);


-- cWBo:   (106 downto 105)
-- cMo:    (104 downto 102)
-- Zero:   (101)
-- EndReg: (100 downto 96)
-- Reg:    (95 downto 64)
-- ULA:    (63 downto 32)
-- NPCJ:   (31 downto 0)
EXMDin <= IDEXout(146 downto 142) & zero & endReg & IDEXout(63 downto 32) & ulaOutput & npcjEX;

EXMEM: registrador
generic map(107)
port map(clock, reset, EXMDin, EXMDout);

-- Componentes: Memory Execution
memoriaPrincipal: data_memory
port map(clock, ph1MEM, ph2MEM, EXMDout(103), EXMDout(104), EXMDout(63 downto 32), EXMDout(63 downto 32), EXMDout(95 downto 64), DMout);

pcsrc <= EXMDout(102) and EXMDout(101);

NPCJ <= EXMDout(31 downto 0);

-- cWBo:   (102 downto 101)
-- DMout:  (100 downto 69)
-- Enderw: (68 downto 64)
-- Reg:    (63 downto 32)
-- ULAo:   (31 downto 0)
MEMWBin <= EXMDout(106 downto 105) & DMout & EXMDout(100 downto 96) & EXMDout(95 downto 64) & EXMDout(63 downto 32);

MEMWB: registrador
generic map(103)
port map(clock, reset, MEMWBin, MEMWBout);

-- Componentes: Write Back
MX3: mux2x1
generic map(32)
port map(MEMWBout(101), MEMWBout(31 downto 0), MEMWBout(100 downto 69), dataw);

enderw <= MEMWBout(68 downto 64);

rw <= MEMWBout(102);

end architecture;