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

end architecture;