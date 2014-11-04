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
			self.code=None
			self.label=None
			self.note=None
			self.content=None
			self.code=None
			print("instruction init")
			self.add_instruction(origin_instruction)
	def add_instruction(self,origin_instruction):
		print("entered add_instruction")
		print("oins:"+origin_instruction)
		label_regular=re.compile('^ *([A-Za-z0-9_]*?): *(.*)')
		label_match=label_regular.match(origin_instruction)
		if (label_match):
			print ("matched")
			print (label_match.group(2))
			if (self.label==None):
				self.label=[label_match.group(1).strip()]
			else:
				self.label+=[label_match.group(1).strip()]
			# print (self.label)
			# print (label_match)
			nolabel_instruction=label_match.group(2)
			# print (nolabel_instruction)
		else:
			print("not matched")
			nolabel_instruction=origin_instruction
		print ("nolabel_ins:"+nolabel_instruction)
		self.add_content(nolabel_instruction)
	def add_content(self,nolabel_instruction):
		print("===entered add_content===")
		print("now label:",self.label)
		note_regular=re.compile('(.*) *#(.*)')
		note_match=note_regular.match(nolabel_instruction)
		if (note_match):
			self.note=note_match.group(2)
			self.content=note_match.group(1)
			print ("final content:"+self.content)
		else:
			self.note=None
			self.content=nolabel_instruction
		self.format()
	def format(self):
		if (self.content):
			self.content=self.content.strip()
		if (self.note):
			self.note=self.note.strip()
		if (self.label):
			for each_label in self.label:
				each_label=each_label.strip()
def single_encode(input_instruction,label_list,index):
	# print(input_instruction)
	operator=input_instruction.split()[0]
	other_asm=""
	other_asm=other_asm.join(input_instruction.split()[1:])
	input_instruction=input_instruction.strip()
	print ("now trans:"+other_asm)
	# print (other_asm)
	try:
		code=instruction_template[operator].mips_code(other_asm,index,label_list)
		return code
	except KeyError:
		raise ValueError('no such operator called:'+operator)
def pesudo_encode(input_instruction,var_list):
	operator=input_instruction.content.split()[0]
	other_asm=""
	other_asm=other_asm.join(input_instruction.content.split()[1:])
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