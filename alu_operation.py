AND = '0000'
OR = '0001'
ADD = '0010'
SUB = '0011'
SLT = '0100'
XOR = '0101'
SLL = '0110'
SRL = '0111'
SRA = '1000'
NOR = '1001'
ADDU = '1010'
SUBU = '1011'
SLTU = '1100'

def main():
	pass

def convert_func(func):
	func_map = {
		0b100000: ADD,
		0b100001: ADDU,
		0b100010: SUB,
		0b100011: SUBU,
		0b100100: AND,
		0b100101: OR,
		0b100110: XOR,
		0b101010: SLT,
		0b000000: SLL,
		0b000010: SRL,
		0b000011: SRA
	}
	if func in func_map:
		return func_map[func]
	return None

def convert_opcode(opcode):
	opcode_map = {
		0b001000: ADD,
		0b001001: ADDU,
		0b001100: AND,
		0b001101: OR,
		0b001110: XOR,
		0b001010: SLT,
		0b001011: SLTU
	}
	if opcode in opcode_map:
		return opcode_map[opcode]
	return None

if __name__ == '__main__':
	main()