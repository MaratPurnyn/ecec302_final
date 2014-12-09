-----------------------------------------------
--	compares two vectors and outputs an equal bit or greater than bit
-- 	EQ	GT
--	1	0	equal
--	0	1	greater than
--	0	0	less than
-----------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity PE is
PORT(	eq_i, gt_i, x, y : in std_logic;
		eq_o, gt_o : out std_logic
);
end PE;

architecture Behavioural of PE is
begin
	process(eq_i, gt_i, x,y)
	begin
		if eq_i = '1' then	--still equal then compare
			--greater
			if x='1' and y='0' then 
				eq_o <= '0'; 
				gt_o <= '1';
			--less
			elsif x='0' and y='1' then
				eq_o <= '0';
				gt_o <= '0'; --equal
			else 
				eq_o <= '1';
				gt_o <= '0' --equal
			end if;
		else -- winner had been declared just pass the flags
			eq_o <= eq_i;
			gt_o <= gt_i;
		end if;
	end process
end Behavioral;

library IEEE;
use IEEE.std_logic_1164.ALL;

entity array_cmp is
generic( n : natural := 4);
PORT (	x, y : in std_logic_vector(n-1 downto 0);
		eq, gt : out std_logic
);
end array_cmp;
architecture struc of array_cmp is
component PE
	PORT(	eq_i, gt_i, x, y : in std_logic;
			eq_o, gt_o :  out std_logic;
		);
end component;
--wires for equal and greater than flags
--wires go into node i get index i
signal w_eq, w_gt : std_logic_vector(n-1 downto 0);
begin
--initial eq and gt flag
w_eq(n-1) <= '1';
w_gt(n-1) <= '0';
G1: for i in n-1 downto 0 generate
	G2: if i>0 generate
		node: PE PORT MAP(	wq(i), w_gt(i), x(i), y(i),
							w_eq(i-1), w_gt(i-1) );
	end generate G2;
	G3: if i=0 generate
		node: PE PORT MAP(	w_eq(i), w_gt(i), x(i), y(i),
							eq, gt );
	end generate G3;
end generate G1;
end struc;