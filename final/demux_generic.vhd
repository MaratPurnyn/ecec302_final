library IEEE;
use ieee.std_logic_1164.all;

entity demux_generic is
generic(	n: natural := 2;
			m: natural := 3
);
port(	x: in std_logic;
		sel: in std_logic_vector(n-1 downto 0);
		z : out std_logic_vector(m-1 downto 0)
);
end demux_generic;
architecture beh of demux_generic is
begin
	process(x, sel)
		subtype my_int is integer range 0 to 2**n - 1;
		variable temp : my_int;
	begin
		temp := 0;
		for i in 0 to n-1 loop --convert_to_integer, computing temp
			if sel(i)='1' then 
				temp := temp + 2**i; 
			end if;
		end loop;
		for i in m-1 downto 0 loop
			if i=temp then 
				z(i) <= x;
			else
				z(i) <= '0';
			end if;
		end loop;
	end loop;
end process;
end beh;

---------------------------------------------------
--	instance	n=3	m=5
---------------------------------------------------

library IEEE;
use ieee.std_logic_1164.all;

entity demux_35 is
port(	x: in std_logic;
		sel: in std_logic_vector(2 downto 0);
		z: out std_logic_vector(4 downto 0);
		disp_en: out std_logic_vector(3 downto 0)
);
end component;
begin
	disp_en <= "1111";
	U2: demux_generic generic map(3,5) PORT MAP(x,sel,z);
end tb;