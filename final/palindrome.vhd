library IEEE;
use ieee.std_logic_1164.all;

entity palindrome is
PORT(	x, reset, ck, b1, b2 : in std_logic;
		z : out std_logic;
		d : out std_logic_vector(3 downto 0) 
); -- state leds
end palindrome;

architecture beh of palindrome is
signal temp : std_logic_vector(2 downto 0);
	type my_state is (s0,s1,s2,s3,s4,s5,s6,s6,s7,s8,s9,s10,s11);
	signal n_s : my_state;
	type db_state is (not_rdy, rdy ,pulse);
	signal db_ns : db_state;
	signal en : std_logic;
begin
	--next state logic
	process(en)
	begin
			if en='1' and en'event then
				if reset = '1' then n_s <= s0;
			else --reset='1' then '0' to execute the case statement
				case n_s is
					when s0 => temp(0) <= x;
						n_s <= s1;
						z <= '1';
						d <= "0000";
					when s1 => temp(1) <= x;
						n_s <= s2;
						z <= '0';
						d <= "0001";
					when s2 => temp(2) <= x;
						n_s <= s7;
						z <= '0';
						d <= "0010";
					when s7 => 
						if temp(2) <= x then
							n_s <= s8;
						else
							n_s <= s11;
						end if;
						z <= '0';
						d <= "0111";
					when s8 => temp(1) 
						if temp(2) <= x then
							n_s <= s9;
						else
							n_s <= s11;
						end if;
						z <= '0';
						d <= "1000";
					when s9 => 
						if temp(2) <= x then
							n_s <= s10;
							z <= '1';
						else
							n_s <= s11;
							z <= '0';
						end if;
						d <= "1001";
					when s10 =>
						z <= '1';
						d <= "1010";
					when s11 =>
						z <= '0';
						d <= "1011";
					when others => null;
				end case;
			end if;
		end if;
	end process;
	
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
					en <= '1';
					db_ns := not_rdy;
				when others => null;
			end case;
		end if;
	end process;
end beh;