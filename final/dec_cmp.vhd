library IEEE;
use ieee.std_logic_1164.all,
	ieee.std_logic_arith.all,
	ieee.std_logic_unsigned.all;
	
entity dec_cmp is
	PORT(	x, y : in std_logic_vector(3 downto 0);
			eq, gt : out std_logic;
			ck, b1, b2, reset : in std_logic
	);
end dec_cmp;
architecture beh of dec_cmp is
	signal eq_flag, gt_flag, en: std_logic;
begin
	process(en, reset)
begin
	if reset = '1' then
		eq_flag <= '1';
		gt_flag <= '0';
	elsif en = '1' and en'event then
		if eq_flag = '1' then
			if x > y then
				eq_flag <= '0';
				gt_flag <= '1';
			elsif x < y then
				eq_flag <= '0';
				gt_flag <= '0';
			elsif x = y  then
				eq_flag <= '1';
				gt_flag <= '0';
			end if;
		end if;
	end if;
end process;
eq <= eq_flag;
grt <= gt_flag;

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