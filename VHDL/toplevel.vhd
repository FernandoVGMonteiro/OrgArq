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
port (clock:	in std_logic);
end component;

begin

fluxoDeDados: fluxo_de_dados
port map(clock);

end architecture;