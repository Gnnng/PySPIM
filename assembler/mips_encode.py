from single_instruction import *
from data_handle import *
import sys
from setup import Setup
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
		print (instruction_input)
		print("======NOW instruction======")
		print (instruction_input)
		print("===========================")
		if (instruction_input==""):
			continue
		if (instruction_input[0]=="#"):
			continue
		if (instruction_input.split(" ")[0]=='.data'):
			mode='data'
			try:
				temploc=UserInstruction();
				temploc.type="location"
				temploc.content=instruction_input.split(" ")[1]
			except:
				temploc=None
				continue
			print("append")
			instruction_list.append(temploc)
			continue
		if (instruction_input.split(" ")[0]=='.text'):
			mode='text'
			try:
				temploc=UserInstruction();
				temploc.type="location"
				temploc.content=instruction_input.split(" ")[1]
			except:
				temploc=None
				continue
			print("append")
			instruction_list.append(temploc)
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
		print ("type",instruction.type)
		if (instruction.type=="location"):
			real_instruction_list+=[instruction]
			continue
		print("=====now instruction=====",instruction.content,"|label:",instruction.label)
		if (instruction.type=='text'):
			print("text")
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
	word_instruction_list=[]
	now_begin=0
	for instruction in real_instruction_list:
		if (instruction.type=="location"):
			now_begin=eval(instruction.content)
			index=0;
			word_instruction_list+=[instruction]
			continue
		print("=====now instruction=====",instruction.content,"|label:",instruction.label)
		if (instruction.type=='data' or instruction.type=='text'):
			print('now content:'+instruction.content)
			if (instruction.label):
				for each_label in instruction.label:
				# print("now label:"+instruction.label)
					try:
						test=variable_list[each_label]
						raise ValueError('redefine label:'+each_label)
					except:
						
						address=index*4+now_begin
						address_code=get_code(address,32)
						high_code=address_code[:16]
						low_code=address_code[16:]
						variable_list[each_label]=address
						label_list[each_label+'[high]']=int('0b'+high_code,2)
						label_list[each_label+'[low]']=int('0b'+low_code,2)
						if each_label=="gill_hint":
							print("!@#$%",max_address,index)
							print("gill_hint[low]="+hex(label_list['gill_hint[low]']))
			print ('======data======')
			if (instruction.type=='data'):
				newdatas=initdata(instruction.content)
				word_cut=4
				while (word_cut<len(newdatas)):
					temp=UserInstruction()
					temp.code=''.join(newdatas[word_cut-4:word_cut])
					temp.type='data'
					word_instruction_list+=[temp]
					index+=1
					word_cut+=4
				temp=UserInstruction()
				print (newdatas[word_cut-4:])
				temp.code=''.join(newdatas[word_cut-4:])+((word_cut-len(newdatas))*8)*'0'
				temp.type='data'
				word_instruction_list+=[temp]
				index+=1
			# data_set+=newdatas
			# max_address+=len(newdatas)			
		if (instruction.type=='text'):
			instruction.index=index+now_begin//4
			word_instruction_list+=[instruction]
			if (instruction.label):
				print ("handling labellist",instruction.label)
				for each_label in instruction.label:
					try:
						test=label_list[each_label]
						raise ValueError('redefine label:'+instruction.label)
					except:
						label_list[each_label]=index+now_begin//4
			index+=1
	print ("======label list======")
	for each_label in label_list:
		print (each_label)
	# print (label_list["clear"])
	print ("======begin encode======")
	for index,instruction in enumerate(word_instruction_list):
		if (instruction.type=='text'):
			print ("======now ins======"+ instruction.content)
			print (index)
			instruction.code=single_encode(instruction.content,label_list,instruction.index)
	# result_file=file('code.txt','w')
	result_file=open('code.txt','w')
	now_loc=0
	loc_ins={}
	max_loc=0
	source_code = {}
	for instruction in word_instruction_list:
		if (instruction.type=="location"):
			print("loc!")
			print(instruction.content)
			now_loc=eval(instruction.content)//4
			if (now_loc>max_loc):
				max_loc=now_loc
			continue

		# pass
		# if (instruction.type=='text'):
		print (instruction.content)
		# print (now_loc)
		# result_file.write(instruction.code+'\n')
		# print (instruction.code,file=result_file)
		loc_ins[now_loc]=instruction.code;
		source_content = ''
		source_note = ''
		if instruction.content:
			source_content = instruction.content
		if instruction.note:
			source_note = instruction.note
		source_code[now_loc]= source_content + " #" + source_note
		now_loc+=1
			# print (instruction.code)
		try:
			a=instruction.code;
			a='0b'+a;
			print(("0"*8+hex(int(a,2))[2:])[-8:]);
		except:
			pass
	# print data_set
	i=0
	flag=0

	print("maxloc",max_loc)
	disasm_file = open('disasm.txt', 'w')
	while True:
		try:
			print (loc_ins[i],file=result_file)
			print (source_code[i], file=disasm_file)
		except:
			if (flag==1):
				break;
			print ("00000000000000000000000000000000",file=result_file)
			print ("nop", file=disasm_file)
		if (i==max_loc):
			flag=1
		i+=1
changeline=0
print("========program start=======")
ins_file=open(sys.argv[1])
# ins_file=open('test_error.s')
input_list=[]
global special_syscall
if (len(sys.argv)>=2):
	if (sys.argv[1]=="-s"):
		Setup.special_syscall=True
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
