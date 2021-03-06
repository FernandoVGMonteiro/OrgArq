library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

entity ULA is
port(
		-- Entradas da ULA: A e B de 31 bits
		A, B:					in  std_logic_vector(31 downto 0);
		-- Sinal de controle para identificar a operação que será realizada
		Controle:			in  std_logic_vector( 3 downto 0);
		-- Sinal de VemUm para conectar a ULA com outras ULAs
		VemUm:				in  std_logic;
		-- Saída C com o resultado da operação
		C:						out std_logic_vector(31 downto 0) := (others => '0');
		-- Sinal de Zero para quando o resultado da operação é Zero
		-- e Overflow para quando o resultado estrapola a capacidade
		-- de 32 bits.
		Zero, Overflow:	out std_logic := '0';
		Shamt:				in  std_logic_vector(4 downto 0)
		
);
end entity;

architecture arch of ULA is
	
	-- Inicializa variável temporária para fazer os cálculos 
	-- A variável foi inicializada com 33 bits para conseguir avaliar
	-- a ocorrência de Overflow na soma sem sinal
	signal temp: 			signed(32 downto 0) := (others => '0');
	
	-- Aqui adicionamos um zero aos operandos A e B para ser possível
	-- identificar Overflow na operação de soma unsigned
	signal A_ext, B_ext:	unsigned(32 downto 0) := (others => '0');
	signal SLT_sub: signed(32 downto 0) := (others => '0');	
	signal Shamt_int: integer range 0 to 31 := 0;
	
begin

	Shamt_int <= to_integer(unsigned(Shamt));
	A_ext <= unsigned('0' & A);
	B_ext <= unsigned('0' & B);
	SLT_sub <= signed(A_ext - B_ext);
	
			  -- Controle = "0000" seleciona operação AND
	temp <= '0' & signed(A and B) when Controle = "0000" else
			  -- Controle = "0001" seleciona operação OR
			  '0' & signed(A or B) when Controle = "0001" else
			  -- Controle = "0010" seleciona operação Add Unsigned
			  -- O operando ("" & VemUm) acrescenta uma unidade caso VemUm = '1'
			  signed(A_ext + B_ext + ("" & VemUm)) when Controle = "0010" else
			  -- Controle = "0011" seleciona operação Add Signed
			  '0' & signed(A) + signed(B) + ("" & VemUm) when Controle = "0011" else
			  -- Controle = "0100" seleciona operação Set on Less Than
			  "00000000000000000000000000000000" & SLT_sub(32) when Controle = "0100" else
			  -- Controle = "0101" seleciona operação Subtract Unsigned
			  signed(A_ext - B_ext) when Controle = "0101" else
			  -- Controle = "0110" seleciona operação Subtract Signed
			  '0' & signed(A) - signed(B) when Controle = "0110" else
			  -- Controle = "1000" seleciona shift left (Shamt)
			  signed(B_ext sll Shamt_int) when Controle = "0111" else
			  -- Qualquer outro valor coloca zeros na saída
			  (others => '0');
	
	C <= std_logic_vector(temp(31 downto 0));
	Overflow <= temp(32);
	Zero 	<= '1' when temp = "00000000000000000000000000000000" else
				'0';

end architecture;