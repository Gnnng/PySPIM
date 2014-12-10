import re
from setup import Setup
def get_code(num,i):
	code=bin(num)
	filled=i*'0'
	if (code[0]=='0'):
		code=filled+code[2:]
		code=code[-i:]
	else:
		code=bin(2**i+num)
		code=code[2:]
	return code
class Treg:
	def __init__(self,sig):
		reglist=["zero","at","v0","v1","a0","a1","a2","a3","t0","t1","t2","t3","t4","t5","t6","t7","s0","s1","s2","s3","s4","s5","s6","s7","t8","t9","k0","k1","gp","sp","fp","ra"]
		print ("sig="+sig)
		if (sig[0]!='$'):
			self.binnum=sig
			self.num=int('0b'+sig,2)
			self.regname=reglist[sig]
		else:
			self.regname=sig
			try:
				if (sig[1].isalpha()):
					self.num=reglist.index(sig[1:])
				else:
					self.num=eval(sig[1:])
			except:
				raise ValueError('No Such reg called:'+sig)
			self.binnum=bin(self.num)[2:]
			self.binnum='00000'+self.binnum
			self.binnum=self.binnum[-5:]
class Tinstruction:
	def __init__(self,ope_s,Itype,regular,func,default_list={}):
		self.func=func
		self.type=Itype
		self.regular=re.compile(regular)
		self.default_list=default_list
		self.ope_s=ope_s
	def mips_code(self,mips_asm,index,label_list):
		print ("begin coding each")
		code=''

		match_result=self.regular.match(mips_asm)
		if  (not match_result):
			raise ValueError('Instruction syntax error')
		if (self.type=='S'):
			if (self.ope_s=="syscall"):
				if (Setup.special_syscall==True):	
					syscall_num=eval(mips_asm);
					syscall_num_code=get_code(syscall_num,10);
					code="0000000000000000"+syscall_num_code+"001100"
				else:
					code=self.func
			else:
				code=self.func;
			return code
		if (self.type=='R' or self.type=='R1'):
			if (self.type=='R'):
				code=code+'000000'
				tail=self.func
			else:
				code=code+self.func
				tail='000000'
			reg_tofill=['rs','rt','rd','shamt']
			for each_reg in reg_tofill:
				try:
					print ("now reg:"+each_reg)
					print (self.default_list)
					regcode=self.default_list[each_reg]
					print ("now reg code:"+regcode)
				except:
					try:
						if (each_reg=="shamt"):
							regcode=get_code(int(match_result.group(each_reg)),5)
						else:
							regname=match_result.group(each_reg)
							regcode=Treg(regname).binnum
					except IndexError:
						regcode='00000'
				code=code+regcode
			code=code+tail
			return code
		if (self.type=='I'):
			code=code+self.func
			reg_tofill=['rs','rt'];
			for each_reg in reg_tofill:
				try:
					print ("now reg:"+each_reg)
					print (self.default_list)
					regcode=self.default_list[each_reg]
					print ("now reg code:"+regcode)
				except:
					try:
						regname=match_result.group(each_reg)
						print ("now reg:"+regname)
						regcode=Treg(regname).binnum
						print ("now reg code:"+regcode)
					except IndexError:
						regcode='00000'
				code=code+regcode
			try:
				immediate=match_result.group('immediate')
				# print (immediate)
				immediate_result=eval(immediate)
				# immediate_code=bin(immediate_result)[2:]
				# immediate_code='0000000000000000'+immediate_code
				# immediate_code=immediate_code[-16:]
				immediate_code=get_code(immediate_result,16)
				code=code+immediate_code
			except SyntaxError:
				raise ValueError('Error expression:'+ immediate)
			except IndexError:
				try:
					label=match_result.group('label')
					print ('label:',label)

					try:
						label_location=label_list[label]
						print(label_location, index)
						offset=label_location-index-1
						# offset_code=bin(offset)[2:]
						# print(offset_code)
						# offset_code='0000000000000000'+offset_code
						offset_code=get_code(offset,16)
						code=code+offset_code
					except IndexError:
						raise ValueError('No label:'+label)
				except IndexError:
					variable=match_result.group('variable')
					print ('label:',variable)
					try:
						label_location=label_list[variable]
						# offset_code=bin(offset)[2:]
						# print(offset_code)
						# offset_code='0000000000000000'+offset_code
						offset_code=get_code(label_location,16)
						code=code+offset_code
					except IndexError:
						raise ValueError('No label:'+variable)
			return code
		if (self.type=='J'):
			code=code+self.func
			target=match_result.group('target')
			if (target[0].isalpha()):
				try:
					label_location=label_list[target]
					target_code=get_code(label_location,26)
					print (target_code)
					code=code+target_code
					print (code)
				except:
					raise ValueError('No label:'+target)
			return code
instruction_template={}
instruction_template['add']=Tinstruction('add','R','(?P<rd>.*?), *(?P<rs>.*?), *(?P<rt>.*)','100000')
instruction_template['addu']=Tinstruction('addu','R','(?P<rd>.*?), *(?P<rs>.*?), *(?P<rt>.*)','100001')
instruction_template['sub']=Tinstruction('sub','R','(?P<rd>.*?), *(?P<rs>.*?), *(?P<rt>.*)','100010')
instruction_template['subu']=Tinstruction('subu','R','(?P<rd>.*?), *(?P<rs>.*?), *(?P<rt>.*)','100011')
instruction_template['addi']=Tinstruction('addi','I','(?P<rt>.*?), *(?P<rs>.*?), *(?P<immediate>.*)','001000')
instruction_template['addiu']=Tinstruction('addiu','I','(?P<rt>.*?), *(?P<rs>.*?), *(?P<immediate>.*)','001001')
instruction_template['and']=Tinstruction('and','R','(?P<rd>.*?), *(?P<rs>.*?), *(?P<rt>.*)','100100')
instruction_template['andi']=Tinstruction('andi','I','(?P<rt>.*?), *(?P<rs>.*?), *(?P<immediate>.*)','001100')
instruction_template['div']=Tinstruction('div','R','(?P<rs>.*?), *(?P<rt>.*)','011010')
instruction_template['divu']=Tinstruction('divu','R','(?P<rs>.*?), *(?P<rt>.*)','011011')
instruction_template['mult']=Tinstruction('mult','R','(?P<rs>.*?), *(?P<rt>.*)','011000')
instruction_template['multu']=Tinstruction('multu','R','(?P<rs>.*?), *(?P<rt>.*)','011001')
instruction_template['or']=Tinstruction('or','R','(?P<rd>.*?), *(?P<rs>.*?), *(?P<rt>.*)','100101')
instruction_template['ori']=Tinstruction('ori','I','(?P<rt>.*?), *(?P<rs>.*?), *(?P<immediate>.*)','001101')
instruction_template['lalo']=Tinstruction('lalo','I','(?P<rt>.*?), *(?P<rs>.*?), *(?P<variable>.*)','001101')
instruction_template['xor']=Tinstruction('xor','R','(?P<rd>.*?), *(?P<rs>.*?), *(?P<rt>.*)','100110')
instruction_template['xori']=Tinstruction('xori','I','(?P<rt>.*?), *(?P<rs>.*?), *(?P<immediate>.*)','001110')
instruction_template['lui']=Tinstruction('lui','I','(?P<rt>.*?), *(?P<immediate>.*)','001111')
instruction_template['lahi']=Tinstruction('lahi','I','(?P<rt>.*?), *(?P<variable>.*)','001111')
instruction_template['nor']=Tinstruction('nor','R','(?P<rd>.*?), *(?P<rs>.*?), *(?P<rt>.*)','100111')
instruction_template['slt']=Tinstruction('slt','R','(?P<rd>.*?), *(?P<rs>.*?), *(?P<rt>.*)','101010')
instruction_template['sltu']=Tinstruction('sltu','R','(?P<rd>.*?), *(?P<rs>.*?), *(?P<rt>.*)','101011')
instruction_template['slti']=Tinstruction('slti','I','(?P<rt>.*?), *(?P<rs>.*?), *(?P<immediate>.*)','001010')
instruction_template['sltiu']=Tinstruction('sltiu','I','(?P<rt>.*?), *(?P<rs>.*?), *(?P<immediate>.*)','001011')
instruction_template['beq']=Tinstruction('beq','I','(?P<rs>.*?), *(?P<rt>.*?), *(?P<label>.*)','000100')
instruction_template['bgez']=Tinstruction('bgez','I','(?P<rs>.*?), *(?P<label>.*)','000001',{'rt':'00001'})
instruction_template['bgezal']=Tinstruction('bgezal','I','(?P<rs>.*?), *(?P<label>.*)','000001',{'rt':'10001'})
instruction_template['bgtz']=Tinstruction('bgtz','I','(?P<rs>.*?), *(?P<label>.*)','000111',{'rt':'00000'})
instruction_template['blez']=Tinstruction('blez','I','(?P<rs>.*?), *(?P<label>.*)','000110',{'rt':'00000'})
instruction_template['bltzal']=Tinstruction('bltzal','I','(?P<rs>.*?), *(?P<label>.*)','000001',{'rt':'10000'})
instruction_template['bltz']=Tinstruction('bltz','I','(?P<rs>.*?), *(?P<label>.*)','000001',{'rt':'00000'})
instruction_template['bne']=Tinstruction('bne','I','(?P<rs>.*?), *(?P<rt>.*?), *(?P<label>.*)','000101')
instruction_template['sll']=Tinstruction('sll','R','(?P<rt>.*?), *(?P<rd>.*?), *(?P<shamt>.*)','000000')
instruction_template['srl']=Tinstruction('srl','R','(?P<rt>.*?), *(?P<rd>.*?), *(?P<shamt>.*)','000010')
instruction_template['sra']=Tinstruction('sra','R','(?P<rt>.*?), *(?P<rd>.*?), *(?P<shamt>.*)','000011')
instruction_template['sllv']=Tinstruction('sllv','R','(?P<rd>.*?), *(?P<rt>.*?), *(?P<rs>.*)','000100')
instruction_template['srlv']=Tinstruction('srlv','R','(?P<rd>.*?), *(?P<rt>.*?), *(?P<rs>.*)','000110')
instruction_template['srav']=Tinstruction('srav','R','(?P<rd>.*?), *(?P<rt>.*?), *(?P<rs>.*)','000111')
instruction_template['jr']=Tinstruction('jr','R','(?P<rs>.*)','001000')
instruction_template['jalr']=Tinstruction('jalr','R','(?P<rs>.*?), *(?P<rd>.*)','001001')
instruction_template['j']=Tinstruction('j','J','(?P<target>.*)','000010')
instruction_template['jal']=Tinstruction('jal','J','(?P<target>.*)','000011')
instruction_template['teq']=Tinstruction('teq','R','(?P<rs>.*?), *(?P<rt>.*)','110100')
instruction_template['teqi']=Tinstruction('teqi','I','(?P<rs>.*?), *(?P<immediate>.*)','000001',{'rt':'01100'})
instruction_template['tne']=Tinstruction('tne','R','(?P<rs>.*?), *(?P<rt>.*)','110110')
instruction_template['tnei']=Tinstruction('tnei','I','(?P<rs>.*?), *(?P<immediate>.*)','000001',{'rt':'01110'})
instruction_template['tge']=Tinstruction('tge','R','(?P<rs>.*?), *(?P<rt>.*)','110000')
instruction_template['tgeu']=Tinstruction('tgeu','R','(?P<rs>.*?), *(?P<rt>.*)','110001')
instruction_template['tgei']=Tinstruction('tgei','I','(?P<rs>.*?), *(?P<immediate>.*)','000001',{'rt':'01000'})
instruction_template['tgeiu']=Tinstruction('tgeiu','I','(?P<rs>.*?), *(?P<immediate>.*)','000001',{'rt':'01001'})
instruction_template['tlt']=Tinstruction('tlt','R','(?P<rs>.*?), *(?P<rt>.*)','110010')
instruction_template['tltu']=Tinstruction('tltu','R','(?P<rs>.*?), *(?P<rt>.*)','110011')
instruction_template['tlti']=Tinstruction('tlti','I','(?P<rs>.*?), *(?P<immediate>.*)','000001',{'rt':'01010'})
instruction_template['tltiu']=Tinstruction('tltiu','I','(?P<rs>.*?), *(?P<immediate>.*)','000001',{'rt':'01011'})
instruction_template['lb']=Tinstruction('lb','I','(?P<rt>.*?), *(?P<immediate>.*?)\((?P<rs>\$.*?)\)','100000')
instruction_template['lbu']=Tinstruction('lbu','I','(?P<rt>.*?), *(?P<immediate>.*?)\((?P<rs>\$.*?)\)','100100')
instruction_template['lh']=Tinstruction('lh','I','(?P<rt>.*?), *(?P<immediate>.*?)\((?P<rs>\$.*?)\)','100001')
instruction_template['lhu']=Tinstruction('lhu','I','(?P<rt>.*?), *(?P<immediate>.*?)\((?P<rs>\$.*?)\)','100101')
instruction_template['lw']=Tinstruction('lw','I','(?P<rt>.*?), *(?P<immediate>.*?)\((?P<rs>\$.*?)\)','100011')
instruction_template['lwl']=Tinstruction('lwl','I','(?P<rt>.*?), *(?P<immediate>.*?)\((?P<rs>\$.*?)\)','100010')
instruction_template['lwr']=Tinstruction('lwr','I','(?P<rt>.*?), *(?P<immediate>.*?)\((?P<rs>\$.*?)\)','100110')
instruction_template['ll']=Tinstruction('ll','I','(?P<rt>.*?), *(?P<immediate>.*?)\((?P<rs>\$.*?)\)','110000')
instruction_template['sb']=Tinstruction('sb','I','(?P<rt>.*?), *(?P<immediate>.*?)\((?P<rs>\$.*?)\)','101000')
instruction_template['sh']=Tinstruction('sh','I','(?P<rt>.*?), *(?P<immediate>.*?)\((?P<rs>\$.*?)\)','101001')
instruction_template['sw']=Tinstruction('sw','I','(?P<rt>.*?), *(?P<immediate>.*?)\((?P<rs>\$.*?)\)','101011')
instruction_template['swl']=Tinstruction('swl','I','(?P<rt>.*?), *(?P<immediate>.*?)\((?P<rs>\$.*?)\)','101010')
instruction_template['swr']=Tinstruction('swr','I','(?P<rt>.*?), *(?P<immediate>.*?)\((?P<rs>\$.*?)\)','101110')
instruction_template['sc']=Tinstruction('sc','I','(?P<rt>.*?), *(?P<immediate>.*?)\((?P<rs>\$.*?)\)','111000')
instruction_template['mfhi']=Tinstruction('mfhi','R','(?P<rd>.*)','010000')
instruction_template['mflo']=Tinstruction('mflo','R','(?P<rd>.*)','010010')
instruction_template['mthi']=Tinstruction('mthi','R','(?P<rs>.*)','010001')
instruction_template['mtlo']=Tinstruction('mtlo','R','(?P<rs>.*)','010011')
instruction_template['movn']=Tinstruction('movn','R','(?P<rd>.*?), *(?P<rs>.*?), *(?P<rt>.*)','001011')
instruction_template['movz']=Tinstruction('movz','R','(?P<rd>.*?), *(?P<rs>.*?), *(?P<rt>.*)','001010')
instruction_template['syscall']=Tinstruction('syscall','S','','00000000000000000000000000001100')
instruction_template['eret']=Tinstruction('eret','S','','01000010000000000000000000011000')
instruction_template['break']=Tinstruction('break','S','','00000000000000000000000000001101')
instruction_template['nop']=Tinstruction('nop','S','','00000000000000000000000000000000')
instruction_template['mfc0']=Tinstruction('mfc0','R1','(?P<rt>.*?), *(?P<rd>.*)','010000')
instruction_template['mtc0']=Tinstruction('mtc0','R1','(?P<rd>.*?), *(?P<rt>.*)','010000',{'rs':'00100'})












