-------------------------------------------------------
--	2-digit BCD subtract cell
--	use for building array BCD subtract
--	or serial BCD subtract
--------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity bcd_sub is
PORT(	a, b: in std_logic_vector(3 downto 0);
		c: out std_logic_vector(3 downto 0);
		borrow_in: in std_logic;
		borrow_out: out std_logic
);
end bcd_sub;
architecture behavioral of bcd_sub is
begin
	process(a, b, borrow_in)
		variable temp, tempa, tempb:
		std_logic_vector(4 downto 0);
	begin
		tempa := '0'&a;
		tempb := '0'&b;
		case borrow_in is --prepare tempa for subtraction
			when '1' => --be careful a can be zero
				if tempa < tempb + 1 then
					borrow_out <= '1';
					temp := tempa + "01001"; -- 9
				else 
					borrow_out <= '0';
					tempa := tempa - 1;
				end if;
			when '0' =>
				if tempa < tempb then
					borrow_out <= '1';
					tempa := tempa + "01010"; -- 10
				else
					borrow_out <= '0';
				end if;
			when others => null;
		end case;
		temp := tempa - tempb;
		c <= temp(3 downto 0);
	end behavioral;
	