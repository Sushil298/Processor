library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;

entity Decoder is
	port (instruction_in : in STD_LOGIC_VECTOR (15 downto 0);

		opcode_out : out opcode_type;

		Rd_addr_out : out STD_LOGIC_VECTOR (2 downto 0);
		Rs1_addr_out : out STD_LOGIC_VECTOR (2 downto 0);
		Rs2_addr_out : out STD_LOGIC_VECTOR (2 downto 0);

		immediate_out : out STD_LOGIC_VECTOR (13 downto 0)
	     );
end Decoder;

architecture Behavioral of Decoder is

signal opcode_internal : opcode_type;
signal Rd_addr_internal : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal Rs1_addr_internal : STD_LOGIC_VECTOR (2 downto 0):= (others => '0');
signal Rs2_addr_internal : STD_LOGIC_VECTOR (2 downto 0):= (others => '0');
signal tail : STD_LOGIC_VECTOR (2 downto 0):= (others => '0');
signal immediate_internal:  STD_LOGIC_VECTOR (13 downto 0):= (others => '0');

begin
	opcode_out <= opcode_internal;
	Rd_addr_out <= Rd_addr_internal;
	Rs1_addr_out <= Rs1_addr_internal;
	Rs2_addr_out <= Rs2_addr_internal;
	immediate_out <= immediate_internal;
	

	opcode_internal <= std_logic_vector_to_opcode_type( instruction_in(15 downto 12) );
	Rd_addr_internal <=  instruction_in(11 downto 9);
	Rs1_addr_internal <=  instruction_in(8 downto 6);
	Rs2_addr_internal <=  instruction_in(5 downto 3);
	tail <=  instruction_in(2 downto 0);
	

	process (opcode_internal,tail,Rs1_addr_internal,Rs2_addr_internal)
	begin
	if (opcode_internal = OP_ANDI) then 
	immediate_internal <= "11111111" &Rs2_addr_internal & tail;
	elsif (opcode_internal = OP_ORI) then 
	immediate_internal <= "00000000" &Rs2_addr_internal & tail;
	elsif (opcode_internal = OP_XORI) then 
	immediate_internal <= "00000000" &Rs2_addr_internal & tail;
	elsif (opcode_internal = OP_SLL) then 
	immediate_internal <= "00000000000" &tail;
	elsif (opcode_internal = OP_SRL) then 
	immediate_internal <= "00000000000" &tail;
	
	elsif (opcode_internal = OP_ADDI) then 
		if  (Rs2_addr_internal(2) = '1') then
		immediate_internal <= "11111111" &Rs2_addr_internal &tail;
		else
		immediate_internal <= "00000000" &Rs2_addr_internal &tail;
		end if;
	elsif (opcode_internal = OP_SUBI) then 
		if  (Rs2_addr_internal(2) = '1') then
		immediate_internal <= "11111111" &Rs2_addr_internal &tail;
		else
		immediate_internal <= "00000000" &Rs2_addr_internal &tail;
		end if;
	elsif (opcode_internal = OP_BLT) then 
		if  (Rd_addr_internal(2) = '1') then
		immediate_internal <= "11111111" &Rd_addr_internal &tail;
		else
		immediate_internal <= "00000000" &Rd_addr_internal &tail;
		end if;
	elsif (opcode_internal = OP_BE) then 
		if  (Rd_addr_internal(2) = '1') then
		immediate_internal <= "11111111" &Rd_addr_internal &tail;
		else
		immediate_internal <= "00000000" &Rd_addr_internal &tail;
		end if;
	elsif (opcode_internal = OP_JMP) then 
		if  (Rd_addr_internal(2) = '1') then
		immediate_internal <= "11111111" &Rd_addr_internal &tail;
		else
		immediate_internal <= "00000000" &Rd_addr_internal &tail;
		end if;
	else
	immediate_internal <="XXXXXXXXXXXXXX";
	end if;			
	end process;
end Behavioral;
