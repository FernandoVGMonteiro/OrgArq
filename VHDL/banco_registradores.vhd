library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity banco_registradores is
port (rw, ph1, ph2: 		 in std_logic;
		endA, endB, endW:  in  std_logic_vector(4 downto 0);
		dataW: 				 in std_logic_vector(31 downto 0);
		dataA, dataB: 		 out std_logic_vector(31 downto 0) := (others => '0')
		);
end entity;

architecture arch of banco_registradores is

component registrador is
generic (numBits: integer);
port (clock, reset: in std_logic;
		input: in std_logic_vector(numBits - 1 downto 0);
		output: out std_logic_vector(numBits - 1 downto 0) := (others => '0')
		);
end component;


-- Registradores funcionando até o momento: $t0 (8) e $s1-$s2 (17-18)
signal outputZE, outputAT, outputGP, outputSP, outputFP, outputRA, outputK0, outputK1: std_logic_vector(31 downto 0);
signal outputV0, outputV1, outputA0, outputA1, outputA2, outputA3: std_logic_vector(31 downto 0);
signal outputT0, outputT1, outputT2, outputT3, outputT4, outputT5, outputT6, outputT7, outputT8, outputT9: std_logic_vector(31 downto 0);
signal outputS0, outputS1, outputS2, outputS3, outputS4, outputS5, outputS6, outputS7: std_logic_vector(31 downto 0);

signal rwZE, rwAT, rwGP, rwSP, rwFP, rwRA, rwK0, rwK1: std_logic;
signal rwV0, rwV1, rwA0, rwA1, rwA2, rwA3: std_logic;
signal rwT0, rwT1, rwT2, rwT3, rwT4, rwT5, rwT6, rwT7, rwT8, rwT9: std_logic;
signal rwS0, rwS1, rwS2, rwS3, rwS4, rwS5, rwS6, rwS7: std_logic;

begin

zeReg: registrador
generic map(32)
port map(rwZE, '0', dataW, outputZE);

atReg: registrador
generic map(32)
port map(rwAT, '0', dataW, outputAT);

v0Reg: registrador
generic map(32)
port map(rwV0, '0', dataW, outputV0);

v1Reg: registrador
generic map(32)
port map(rwV1, '0', dataW, outputV1);

a0Reg: registrador
generic map(32)
port map(rwA0, '0', dataW, outputA0);

a1Reg: registrador
generic map(32)
port map(rwA1, '0', dataW, outputA1);

a2Reg: registrador
generic map(32)
port map(rwA2, '0', dataW, outputA2);

a3Reg: registrador
generic map(32)
port map(rwA3, '0', dataW, outputA3);

t0Reg: registrador
generic map(32)
port map(rwT0, '0', dataW, outputT0);

t1Reg: registrador
generic map(32)
port map(rwT1, '0', dataW, outputT1);

t2Reg: registrador
generic map(32)
port map(rwT2, '0', dataW, outputT2);

t3Reg: registrador
generic map(32)
port map(rwT3, '0', dataW, outputT3);

t4Reg: registrador
generic map(32)
port map(rwT4, '0', dataW, outputT4);

t5Reg: registrador
generic map(32)
port map(rwT5, '0', dataW, outputT5);

t6Reg: registrador
generic map(32)
port map(rwT6, '0', dataW, outputT6);

t7Reg: registrador
generic map(32)
port map(rwT7, '0', dataW, outputT7);

s0Reg: registrador
generic map(32)
port map(rwS0, '0', dataW, outputS0);

s1Reg: registrador
generic map(32)
port map(rwS1, '0', dataW, outputS1);

s2Reg: registrador
generic map(32)
port map(rwS2, '0', dataW, outputS2);

s3Reg: registrador
generic map(32)
port map(rwS3, '0', dataW, outputS3);

s4Reg: registrador
generic map(32)
port map(rwS4, '0', dataW, outputS4);

s5Reg: registrador
generic map(32)
port map(rwS5, '0', dataW, outputS5);

s6Reg: registrador
generic map(32)
port map(rwS6, '0', dataW, outputS6);

s7Reg: registrador
generic map(32)
port map(rwS7, '0', dataW, outputS7);

t8Reg: registrador
generic map(32)
port map(rwT8, '0', dataW, outputT8);

t9Reg: registrador
generic map(32)
port map(rwT9, '0', dataW, outputT9);

k0Reg: registrador
generic map(32)
port map(rwK0, '0', dataW, outputK0);

k1Reg: registrador
generic map(32)
port map(rwK1, '0', dataW, outputK1);

gpReg: registrador
generic map(32)
port map(rwGP, '0', dataW, outputGP);

spReg: registrador
generic map(32)
port map(rwSP, '0', dataW, outputSP);

fpReg: registrador
generic map(32)
port map(rwFP, '0', dataW, outputFP);

raReg: registrador
generic map(32)
port map(rwRA, '0', dataW, outputRA);

	dataA <= outputZE when endA = "00000" else
				outputAT when endA = "00001" else
				outputV0 when endA = "00010" else
				outputV1 when endA = "00011" else
				outputA0 when endA = "00100" else
				outputA1 when endA = "00101" else
				outputA2 when endA = "00110" else
				outputA3 when endA = "00111" else
				outputT0 when endA = "01000" else
				outputT1 when endA = "01001" else
				outputT2 when endA = "01010" else
				outputT3 when endA = "01011" else
				outputT4 when endA = "01100" else
				outputT5 when endA = "01101" else
				outputT6 when endA = "01110" else
				outputT7 when endA = "01111" else
				outputS0 when endA = "10000" else
				outputS1 when endA = "10001" else
				outputS2 when endA = "10010" else
				outputS3 when endA = "10011" else
				outputS4 when endA = "10100" else
				outputS5 when endA = "10101" else
				outputS6 when endA = "10110" else
				outputS7 when endA = "10111" else
				outputT8 when endA = "11000" else
				outputT9 when endA = "11001" else
				outputK0 when endA = "11010" else
				outputK1 when endA = "11011" else
				outputGP when endA = "11100" else
				outputSP when endA = "11101" else
				outputFP when endA = "11110" else
				outputRA when endA = "11111" else
				(others => '0');
				
	dataB <= outputZE when endB = "00000" else
				outputAT when endB = "00001" else
				outputV0 when endB = "00010" else
				outputV1 when endB = "00011" else
				outputA0 when endB = "00100" else
				outputA1 when endB = "00101" else
				outputA2 when endB = "00110" else
				outputA3 when endB = "00111" else
				outputT0 when endB = "01000" else
				outputT1 when endB = "01001" else
				outputT2 when endB = "01010" else
				outputT3 when endB = "01011" else
				outputT4 when endB = "01100" else
				outputT5 when endB = "01101" else
				outputT6 when endB = "01110" else
				outputT7 when endB = "01111" else
				outputS0 when endB = "10000" else
				outputS1 when endB = "10001" else
				outputS2 when endB = "10010" else
				outputS3 when endB = "10011" else
				outputS4 when endB = "10100" else
				outputS5 when endB = "10101" else
				outputS6 when endB = "10110" else
				outputS7 when endB = "10111" else
				outputT8 when endB = "11000" else
				outputT9 when endB = "11001" else
				outputK0 when endB = "11010" else
				outputK1 when endB = "11011" else
				outputGP when endB = "11100" else
				outputSP when endB = "11101" else
				outputFP when endB = "11110" else
				outputRA when endB = "11111" else
				(others => '0');
				
	rwZE <= rw when endW = "00000" else '0';
	rwAT <= rw when endW = "00001" else '0';
	rwV0 <= rw when endW = "00010" else '0';
	rwV1 <= rw when endW = "00011" else '0';
	rwA0 <= rw when endW = "00100" else '0';
	rwA1 <= rw when endW = "00101" else '0';
	rwA2 <= rw when endW = "00110" else '0';
	rwA3 <= rw when endW = "00111" else '0';
	rwT0 <= rw when endW = "01000" else '0';
	rwT1 <= rw when endW = "01001" else '0';
	rwT2 <= rw when endW = "01010" else '0';
	rwT3 <= rw when endW = "01011" else '0';
	rwT4 <= rw when endW = "01100" else '0';
	rwT5 <= rw when endW = "01101" else '0';
	rwT6 <= rw when endW = "01110" else '0';
	rwT7 <= rw when endW = "01111" else '0';
	rwS0 <= rw when endW = "10000" else '0';
	rwS1 <= rw when endW = "10001" else '0';
	rwS2 <= rw when endW = "10010" else '0';
	rwS3 <= rw when endW = "10011" else '0';
	rwS4 <= rw when endW = "10100" else '0';
	rwS5 <= rw when endW = "10101" else '0';
	rwS6 <= rw when endW = "10110" else '0';
	rwS7 <= rw when endW = "10111" else '0';
	rwT8 <= rw when endW = "11000" else '0';
	rwT9 <= rw when endW = "11001" else '0';
	rwK0 <= rw when endW = "11010" else '0';
	rwK1 <= rw when endW = "11011" else '0';
	rwGP <= rw when endW = "11100" else '0';
	rwSP <= rw when endW = "11101" else '0';
	rwFP <= rw when endW = "11110" else '0';
	rwRA <= rw when endW = "11111" else '0';

end architecture;