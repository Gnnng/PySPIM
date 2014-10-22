from single_instruction import *
from data_handle import *
def encode(input_list):
	mode=''
	instruction_list=[]
	variable_list={}
	temp=None
	max_address=0
	data_set=[]
	for instruction_input in input_list:
		instruction_input.strip(' ')
		if (instruction_input=='.data'):
			mode='data'
			continue
		if (instruction_input=='.text'):
			mode='text'
			continue
		if (mode=='data'):
			if (temp):
				if (temp.content==''):
					temp.add_content(instruction_input)
					continue
			temp=UserInstruction(instruction_input)
			if (temp.content!=''):
				variable_list[temp.label]=max_address
				newdatas=initdata(temp.content)
				data_set+=newdatas
				max_address+=len(newdatas)
		if (mode=='text'):
			# print (instruction_input)
			if (temp):
				if (temp.content==''):
					temp.add_content(instruction_input)
					instruction_list.append(temp)
					continue
			temp=UserInstruction(instruction_input)
			if (temp.content!=''):
				instruction_list.append(temp)
	real_instruction_list=[]
	for instruction in instruction_list:
		new_real_list=pesudo_encode(instruction,variable_list)
		print('=====')
		for show in new_real_list:
			print(show.label,'[]',show.content,'[]',show.note,'[]')
		print('=====')
		real_instruction_list+=new_real_list
	label_list={}
	for index,instruction in enumerate(real_instruction_list):
		if (instruction.label):
			try:
				test=label_list[instruction.label]
				raise ValueError('redefine label:'+instruction.label)
			except:
				label_list[instruction.label]=index
	for index,instruction in enumerate(real_instruction_list):
		instruction.code=single_encode(instruction.content,label_list,index)
	for instruction in real_instruction_list:
		print (instruction.code)
ins_file=open('instruction.txt')
input_list=[]
for line in ins_file:
	input_list.append(line[:-1])
	print (line[:-1])
encode(input_list)
# try:
# 	a=single_encode(input_instruction)
# 	print (a)
# 	a='0b'+a
# 	print (hex(int(a,2)))
# except ValueError as msg:
# 	print (msg)
