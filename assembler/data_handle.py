from initial import get_code
import struct
def initdata(instruction):
	temp=''
	data_type=instruction.split(' ')[0]
	data_content=instruction.split(' ')[1]
	new_data=[]
	if (data_type=='.ascii'):
		# data_content
		temp=data_content
		exec('temp='+data_content)
		# print (temp)
		for char in temp:
			new_data+=[bin(ord(char))[2:]]
	if (data_type=='.asciiz'):
		exec('temp='+data_content)
		for char in temp:
			new_data+=[bin(ord(char))[2:]]
		new_data+=['00000000']
	if (data_type=='.byte'):
		exec('temp='+data_content)
		for i in temp:
			new_data+=[getcode(i,8)]
	if  (data_type=='.double'):
		exec('temps='+data_content)
		for temp in temps:
			packed=struct.pack('>d',temp)
			bytes=struct.unpack('bbbbbbbb',packed)
			for byte in bytes:
				new_data+=[getcode(byte,8)]
	if (data_type=='.float'):
		exec('temps='+data_content)
		for temp in temps:
			packed=struct.pack('>f',temp)
			bytes=struct.unpack('bbbb',packed)
			for byte in bytes:
				new_data+=[getcode(byte,8)]
	if (data_type=='.half'):
		exec('temps='+data_content)
		for temp in temps:
			packed=struct.pack('>h',temp)
			bytes=struct.unpack('bb',packed)
			for byte in bytes:
				new_data+=[getcode(byte,8)]
	if (data_type=='.word'):
		exec('temps='+data_content)
		for temp in temps:
			packed=struct.pack('>i',temp)
			bytes=struct.unpack('bbbb',packed)
			for byte in bytes:
				new_data+=[getcode(byte,8)]
	return new_data