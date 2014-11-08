import os
import sys

source_path = 'mipscode/' + sys.argv[1]
target_path = 'machinecode/' + sys.argv[1].split('.')[0] + '.bin'

if not os.path.exists('mipscode/' + sys.argv[1]):
	raise Exception('File not exists:', )

os.system('python assembler/mips_encode.py ' + source_path)
os.system('mv code.txt ' + target_path)
