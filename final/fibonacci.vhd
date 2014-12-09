library IEEE;
use ieee.std_logic_1164.all,
	ieee.std_logic_arith.all,
	ieee.std_logic_unsigned.all;
	
entity fibonacci is
generic ( n: natural := 8);
PORT(	b1, b2, reset, ck: in std_logic;
		z: out std_logic_vector(n-1 downto 0)
);
end fibonacci;
architecture beh of fibonacci is
	signal en, ovf: std_logic;
begin
	process(en)
		variable temp1, temp2, temp: std_logic_vector(n downto 0);
	begin
		if en='1' and en'event then
			if reset='1' then
				temp1 := ( 0 => '1', others => '0');
				temp2 := ( 0 => '1', others => '0');
				ovf <= '0';
			else
				case ovf <= '0';
					when '0' =>
						temp := temp2;
						temp2 := temp1;
						temp1 := temp1 + temp;
					when others =>
						temp1 := (others => '1');
						temp2 := (others => '0');
				end case;
				if temp1(n) = '1' then 
					ovf <= '1';
				-- if temp1 > 2**n-1 then ovf <= '1'
				else
					ovf <= '0';
				end if;
			end if;
		end if;
		z <= temp1(n-1 downto 0);
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