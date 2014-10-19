import sys
import asyncio as jj

IF = 0
ID = 1
ADDR = 2
MEM_R = 3
MEMREG = 4
MEM_W = 5
RTYPE = 6
ALUREG = 7
BEQ = 8
J = 9
BNE = 10
JR = 11
LUI = 12
JAL = 13
ALUREGI = 14
ERROR = 30
START = 31

def gen():
	print('This is gen result')

def main():
	if len(sys.argv) == 2 and sys.argv[1] == 'gen':
		gen()


if __name__ == '__main__':
	main()