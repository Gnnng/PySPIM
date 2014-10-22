from initial import *
from pesudo import *
import re
class UserInstruction:
	def __init__(self,origin_instruction=None):
		if (origin_instruction==None):
			self.code=None
			self.label=None
			self.note=None
			self.content=None
			self.code=None
		else:
			label_regular=re.compile(' *(.*): *(.*)')
			label_match=label_regular.match(origin_instruction)
			if (label_match):
				self.label=label_match.group(1)
				# print (self.label)
				# print (label_match)
				nolabel_instruction=label_match.group(2)
				# print (nolabel_instruction)
			else:
				self.label=None
				nolabel_instruction=origin_instruction
			self.add_content(nolabel_instruction)
	def add_content(self,nolabel_instruction):
		note_regular=re.compile('(.*) *#(.*)')
		note_match=note_regular.match(nolabel_instruction)
		if (note_match):
			self.note=note_match.group(2)
			self.content=note_match.group(1)
		else:
			self.note=None
			self.content=nolabel_instruction
		self.format()
	def format(self):
		if (self.content):
			self.content.strip(' ')
		if (self.note):
			self.note.strip(' ')
		if (self.label):
			self.label.strip(' ')
def single_encode(input_instruction,label_list,index):
	# print(input_instruction)
	operator=input_instruction.split(' ')[0]
	other_asm=input_instruction.split(' ')[1]
	# print (other_asm)
	try:
		code=instruction_template[operator].mips_code(other_asm,index,label_list)
		return code
	except KeyError:
		raise ValueError('no such operator called:'+operator)
def pesudo_encode(input_instruction,var_list):
	operator=input_instruction.content.split(' ')[0]
	other_asm=input_instruction.content.split(' ')[1]
	# real_list=[]
	if (operator in pesudo_list):
		# real_list=encode_pesudo_la(other_asm,var_list)
		real_list=pesudo_function[operator](other_asm,var_list)
		# print (real_list)
	else:
		return[input_instruction]
	real_instrution=[]
	for real in real_list:
		temp=UserInstruction()
		temp.content=real
		real_instrution+=[temp]
	real_instrution[0].label=input_instruction.label
	real_instrution[0].note=input_instruction.note
	return real_instrution