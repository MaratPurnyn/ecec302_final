library IEEE
use IEEE.STD_LOGIC_1164.ALL;
entity PE is
port(	x, cin, sel : in std_logic;
		z, cout : out std_logic
);
end PE;
architecture beh of PE is
begin
	process(x, c_in, sel)
	begin
		if sel = '0' then 
			z <= x;
			c_out <= '0';
		else
			z <= not x xor c_in;
			c_out <= not x and c_in;
		end if;
	end process;
end beh;

library IEEE;
use IEEE.STD_LOGIC.ALL;
entity array_abs is
port( 	x : in std_logic_vector(7 downto 0);
		z : out std_logic_vector(7 downto 0)
);
end array_abs;
architecture struc of array_abs is
signal	c : std_logic_vector(7 downto 0);
component PE
port(	x, c_in, sel : in std_logic;
		z, c_out : std_logic
);
end component;
begin
c(0) <= x(7);

G1: for i in 0 to 7 generate
	G2: if i<7 generate --right 6 cells 	cout goes to cin of next cell
		U2: PE port map( x(i), c(i), x(7), z(i), c(i+1) );
	end generate G2;
	G3: if i=7 generate --leftmost cell
		U2: PE port map( x(i), c(i), x(7), z(i), open );
	end generate G3;
end generate G1;
end struc;