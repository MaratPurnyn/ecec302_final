library IEEE;
use ieee.std_logic_1164.all;

entity dec is
generic(n : natural);
PORT(	x:	in std_logic_vector(n-1 downto 0);
		z:	out std_logic_vector(2**n - 1 downto 0)
);
end dec;
architecture beh of dec is
begin
	process(x)
		variable temp: integer;
	begin
		temp := 0; --convert x to integer
		for i in 0 to n-1 loop
			if x(i) = '1' then
				temp := temp + 2**i;
			end if;
		end loop;
		z(temp) <= '1'; --assign outputs
		for i in 0 to 2**n - 1 loop
			if not(i=temp) then 
				z(i) <= '0';
			end if;
		end loop;
	end process;
end beh;

			