---------------------------------------------
--	implement a sequential circuit that after a reset
--	keeps track of the minimum and maximum input
--	appeared at port x, and displays the current min
--	and max at ports z_min	and	z_min
---------------------------------------------
library IEEE;
use ieee.std_logic_1164.all,
	ieee.std_logic_arith.all,
	ieee.std_logic_unsigned.all;
entity current_min_max is
	PORT(	x:	in	std_logic_vector(3 downto 0);
			z_min, z_max:	out	std_logic_vector(3 downto 0);
			ck, b2, b1, reset: in std_logic
	);
end current_min_max;
architecture beh of current_min_max is
	signal min, max: std_logic_vector(3 downto 0);
	signal en : std_logic;
begin
process(en)
begin
	if en='1' and en'event then
		if reset = '1' then
			max <= (others => '0');
			min <= (others => '1');
		else
			if x > max then
				max <= x;
			end if;
			if x < min then
				min <= x;
			end if;
		end if;
	end if;
end process;
z_min <= min;
z_max <= max;

--single step, debounce (db)
process(ck)
	type db_state is (not_rdy, rdy, pulse);
	variable db_ns: db_state;
begin
	if ck='1' and ck'event then
		case db_ns is
			when not_rdy =>
				en <= '0';
				if b2 = 1 then
					db_ns := rdy;
				end if;
			when rdy =>
				en <= '0';
				if b1 = '1' then
					db_ns := pulse;
				end if;
			when pulse =>
				end <= '1';
				db_ns := not_rdy;
			when others => null;
		end case;
	end if;
end process;
end beh;