from initial import get_code
import struct
def initdata(instruction):
	temp=''
	data_type=instruction.split()[0]
	data_content=""
	data_content=data_content.join(instruction.split()[1:])
	new_data=[]
	if (data_type=='.ascii'):
		# data_content
		temp=data_content
		exec('temp='+data_content)
		# print (temp)
		for char in temp:
			new_data+=[get_code(ord(char),8)]
	if (data_type=='.asciiz'):
		exec('temp='+data_content)
		for char in temp:
			new_data+=[get_code(ord(char),8)]
		new_data+=['00000000']
	if (data_type=='.byte'):
		exec('temp='+data_content)
		for i in temp:
			new_data+=[get_code(i,8)]
	if  (data_type=='.double'):
		temps=eval('['+data_content+']')
		for temp in temps:
			packed=struct.pack('>d',temp)
			bytes=struct.unpack('bbbbbbbb',packed)
			for byte in bytes:
				new_data+=[get_code(byte,8)]
	if (data_type=='.float'):
		temps=eval('['+data_content+']')
		for temp in temps:
			packed=struct.pack('>f',temp)
			bytes=struct.unpack('bbbb',packed)
			for byte in bytes:
				new_data+=[get_code(byte,8)]
	if (data_type=='.half'):
		temps=eval('['+data_content+']')
		for temp in temps:
			packed=struct.pack('>h',temp)
			bytes=struct.unpack('bb',packed)
			for byte in bytes:
				new_data+=[get_code(byte,8)]
	if (data_type=='.word'):
		print("data="+data_content)
		# exec('temps=['+data_content+']')
		temps=eval('['+data_content+']')
		print ('temps=['+data_content+']')
		for temp in temps:
			packed=struct.pack('>i',temp)
			bytes=struct.unpack('bbbb',packed)
			for byte in bytes:
				new_data+=[get_code(byte,8)]
	return new_data