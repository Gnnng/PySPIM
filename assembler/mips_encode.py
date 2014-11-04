from single_instruction import *
from data_handle import *
def encode(input_list):
	mode=''
	instruction_list=[]
	variable_list={}
	label_list={}
	temp=None
	max_address=0
	data_set=[]
	for instruction_input in input_list:
		instruction_input=instruction_input.strip()
		print("======NOW instruction======")
		print (instruction_input)
		print("===========================")
		if (instruction_input==""):
			continue
		if (instruction_input[0]=="#"):
			continue
		if (instruction_input=='.data'):
			mode='data'
			continue
		if (instruction_input=='.text'):
			mode='text'
			continue
		if (mode=='data'):
			if (temp):
				print ("have temp")
				print (temp.content)
				if (temp.content==''):
					temp.add_instruction(instruction_input)
			else:
				temp=UserInstruction(instruction_input)
			print ("label:",temp.label)
			if (temp.content!=''):
				print('now content:'+temp.content)
				if (temp.label):
					for each_label in temp.label:
					# print("now label:"+temp.label)
						try:
							test=variable_list[each_label]
							raise ValueError('redefine label:'+each_label)
						except:
							variable_list[each_label]=max_address
				newdatas=initdata(temp.content)
				data_set+=newdatas
				max_address+=len(newdatas)
				temp=None
		if (mode=='text'):
			# print (instruction_input)
			if (temp):
				print ("have temp")
				if (temp.content==''):
					temp.add_instruction(instruction_input)
			else:
				print("no temp")
				temp=UserInstruction(instruction_input)
			if (temp.content!=''):
				print("add!")
				instruction_list.append(temp)
				temp=None
	real_instruction_list=[]
	print ("====first step finished====")
	print ("====var list=====")
	for each_label in variable_list:
		print (each_label)
	for instruction in instruction_list:
		print("=====now instruction=====",instruction.content,"|label:",instruction.label)
		new_real_list=pesudo_encode(instruction,variable_list)
		print('===new===')
		for show in new_real_list:
			print('label:',show.label,'content:',show.content,'note,',show.note)
		print('=========')
		real_instruction_list+=new_real_list
	label_list={}
	print("===real instruction start===")
	for index,instruction in enumerate(real_instruction_list):
		print("=====now instruction=====",instruction.content,"|label:",instruction.label)
		if (instruction.label):
			print ("handling labellist",instruction.label)
			for each_label in instruction.label:
				try:
					test=label_list[each_label]
					raise ValueError('redefine label:'+instruction.label)
				except:
					label_list[each_label]=index
	print ("======label list======")
	for each_label in label_list:
		print (each_label)
	# print (label_list["clear"])
	print ("======begin encode======")
	for index,instruction in enumerate(real_instruction_list):
		print ("======now ins======"+ instruction.content)
		instruction.code=single_encode(instruction.content,label_list,index)
	for instruction in real_instruction_list:
		# pass
		print (instruction.content)
		print (instruction.code)
print("========program start=======")
ins_file=open('instruction.txt')
input_list=[]
for line in ins_file:
	input_list.append(line[:-1])
	# print (line[:-1])
encode(input_list)
# try:
# 	a=single_encode(input_instruction)
# 	print (a)
# 	a='0b'+a
# 	print (hex(int(a,2)))
# except ValueError as msg:
# 	print (msg)
