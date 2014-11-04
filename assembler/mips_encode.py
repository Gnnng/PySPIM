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
				temp.type='data'
				instruction_list.append(temp)
				# print('now content:'+temp.content)
				# if (temp.label):
				# 	for each_label in temp.label:
				# 	# print("now label:"+temp.label)
				# 		try:
				# 			test=variable_list[each_label]
				# 			raise ValueError('redefine label:'+each_label)
				# 		except:
				# 			variable_list[each_label]=max_address
				# newdatas=initdata(temp.content)
				# data_set+=newdatas
				# max_address+=len(newdatas)
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
				temp.type='text'
				instruction_list.append(temp)
				temp=None
	real_instruction_list=[]
	print ("====first step finished====")
	print ("====var list=====")
	for each_label in variable_list:
		print (each_label)
	for instruction in instruction_list:
		print("=====now instruction=====",instruction.content,"|label:",instruction.label)
		if (instruction.type=='text'):
			new_real_list=pesudo_encode(instruction,variable_list)
		else:
			new_real_list=[instruction]
		print('===new===')
		for show in new_real_list:
			print('label:',show.label,'content:',show.content,'note,',show.note)
		print('=========')
		real_instruction_list+=new_real_list
	label_list={}
	print("===real instruction start===")
	index=0
	for instruction in real_instruction_list:
		print("=====now instruction=====",instruction.content,"|label:",instruction.label)
		if (instruction.type=='data'):
			print('now content:'+instruction.content)
			if (instruction.label):
				for each_label in instruction.label:
				# print("now label:"+instruction.label)
					try:
						test=variable_list[each_label]
						raise ValueError('redefine label:'+each_label)
					except:
						
						address=max_address+index*4
						address_code=get_code(address,32)
						high_code=address_code[:16]
						low_code=address_code[16:]
						variable_list[each_label]=address
						label_list[each_label+'[high]']=int('0b'+high_code,2)
						label_list[each_label+'[low]']=int('0b'+low_code,2)
						if each_label=="gill_hint":
							print("!@#$%",max_address,index)
							print("gill_hint[low]="+hex(label_list['gill_hint[low]']))
			newdatas=initdata(instruction.content)
			data_set+=newdatas
			max_address+=len(newdatas)
		else:
			if (instruction.label):
				print ("handling labellist",instruction.label)
				for each_label in instruction.label:
					try:
						test=label_list[each_label]
						raise ValueError('redefine label:'+instruction.label)
					except:
						label_list[each_label]=index+max_address
			index+=1
	print ("======label list======")
	for each_label in label_list:
		print (each_label)
	# print (label_list["clear"])
	print ("======begin encode======")
	for index,instruction in enumerate(real_instruction_list):
		print ("======now ins======"+ instruction.content)
		if (instruction.type=='text'):
			instruction.code=single_encode(instruction.content,label_list,index)
	for instruction in real_instruction_list:
		# pass
		if (instruction.type=='text'):
			# print (instruction.content)
			# print (instruction.code)
			a=instruction.code;
			a='0b'+a;
			print(hex(int(a,2)));
	print data_set
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
