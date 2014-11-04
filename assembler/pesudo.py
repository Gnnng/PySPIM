import re
from initial import get_code
pesudo_list=['la','li']
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
		address=var_list[variable]
		# print(address)
		address_code=get_code(address,32)
		high_code=address_code[:16]
		low_code=address_code[16:]
		real_list+=['lui '+rs+','+'0b'+high_code]
		real_list+=['ori '+rs+','+rs+','+'0b'+low_code]
	except:
		raise ValueError('no variable:'+variable)
	return real_list
def encode_pesudo_li(origin_instruction,var_list):
	li_match=re.compile('(?P<rs>.*?),(?P<immediate>.*)').match(origin_instruction)
	if (not li_match):
		raise ValueError('Instruction syntax error')	
	immediate=la_match.group('immediate')
	rs=la_match.group('rs')
	real_list=[]
	try:
		immediate=eval(immediate)
		immediate_code=get_code(immediate,32)
		high_code=immediate_code[:16]
		low_code=immediate[16:]
		real_list+=['lui'+rs+','+'0b'+high_code]
		real_list+=['ori'+rs+','+rs+','+'0b'+low_code]
	except SyntaxError:
		raise ValueError('Error expression:'+ immediate)
	return real_list
pesudo_function={
	'la':encode_pesudo_la,
	'li':encode_pesudo_li
}
