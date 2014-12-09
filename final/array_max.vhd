---
-- looks at 4	2 bit vectors and compares them one to the next until it determines the max value and outputs it into a 2 bit vector
---

library IEEE;
use IEEE.STD_LOGIC_1164.ALL, 
	IEEE.STD_LOGIC_UNSIGNED.ALL,
	IEEE.STD_LOGIC_ARITH.ALL;
entity array_max is
	generic(	N: natural := 4;
				M: natural := 2);
	PORT(	x: in std_logic_vector(m*n-1 downto 0);
			z: out_std_logic_vector(m-1 downto 0) 
	);
end array_max;
architecture struc of array_max is
	component PE
		generic(	m: natural := 2 );
		PORT(	a, b : in std_logic_vector(m-1 downto 0);
				c : out std_logic_vector(m-1 downto 0)
		);
	end PE
	type vector_array is array ( natural range <> ) of std_logic_vector( m-1 downto 0);
	signal w:	vector_array( n-1 downto 0 );
begin
	w(n-1) <= (others => '0');
	G1: for i in 0 to n-1 generate
		G2: if i>0 generate
			U2: PE generic map(m) PORT MAP( w(i), x(m*(i+1)-1 downto m*i), w(i+1) );
		end generate G2;
		G3: if i=0 generate
			U2: PE generic map(m) port map( w(i), x(m*(i+1)-1 downto m*i), z) );
		end generate G3;
	end generate G1;
end struc;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL,
	IEEE.STD_LOGIC_UNSIGNED.ALL,
	IEEE.STD_LOGIC_ARITH.ALL;
entity PE is
	generic(m: natural := 2);
	PORT(	a, b : in STD_LOGIC_VECTOR(m-1 downto 0);
			c : out STD_LOGIC_VECTOR(m-1 downto 0) 
	);
end PE;
architecture beh of PE is
begin
	process(a,b)
	begin
		if a<b then
			c <= b;
		else
			c <= a;
		end if;
	end process;
