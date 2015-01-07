import re
from initial import get_code
pesudo_list=['la','li','pop','push']
def encode_pesudo_la(origin_instruction,var_list):
	# print (var_list)
	# print ("ins:",origin_instruction)
	la_match=re.compile('(?P<rs>.*?),(?P<variable>.*)').match(origin_instruction)
	if (not la_match):
		raise ValueError('Instruction syntax error')
	variable=la_match.group('variable')
	# print ("var:",variable)
	rs=la_match.group('rs')
	real_list=[]
	try:
		# address=var_list[variable]
		# # print(address)
		# address_code=get_code(address,32)
		# high_code=address_code[:16]
		# low_code=address_code[16:]

		real_list+=['lahi '+rs+','+variable+'[high]']
		real_list+=['lalo '+rs+','+rs+','+variable+'[low]']
	except:
		raise ValueError('no variable:'+variable)
	return real_list
def encode_pesudo_li(origin_instruction,var_list):
	li_match=re.compile('(?P<rs>.*?),(?P<immediate>.*)').match(origin_instruction)
	if (not li_match):
		raise ValueError('Instruction syntax error')	
	immediate=li_match.group('immediate')
	rs=li_match.group('rs')
	real_list=[]
	try:
		immediate=eval(immediate)
		print(immediate)
		immediate_code=get_code(immediate,32)
		print(immediate_code)
		high_code=immediate_code[:16]
		low_code=immediate_code[16:]
		real_list+=['lui '+rs+','+'0b'+high_code]
		real_list+=['ori '+rs+','+rs+','+'0b'+low_code]
	except SyntaxError:
		raise ValueError('Error expression:'+ immediate)
	return real_list
def encode_pesudo_push(origin_instruction,var_list):
	real_list=[]
	reg_list=origin_instruction.split(',');
	real_list+=['addi $sp,$sp,'+str(len(reg_list)*(-4))]
	pint=0
	for reg in reg_list:
		real_list+=['sw '+reg+','+str(pint)+'($sp)']
		pint+=4
	# print ("real")
	# print (real_list)
	return real_list
def encode_pesudo_pop(origin_instruction,var_list):
	real_list=[]
	reg_list=origin_instruction.split(',');
	pint=0
	for reg in reg_list:
		real_list+=['lw '+reg+','+str(pint)+'($sp)']
		pint+=4
	# print ("real")
	# print (real_list)
	real_list+=['addi $sp,$sp,'+str(len(reg_list)*(4))]
	return real_list
pesudo_function={
	'la':encode_pesudo_la,
	'li':encode_pesudo_li,
	'pop':encode_pesudo_pop,
	'push':encode_pesudo_push 
}
