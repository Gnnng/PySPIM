import pygame
from pygame.locals import *
from sys import exit
from fonttable import *

class VgaMonitor(object):
	def __init__(self,bus):
		self.bus=bus

	def draw_frame(self,mode):#if mode=0 then print context,if mode=1 then print the picture
		
		width=8
		height=16
		line_limit=640/width
		fg_color=1
		fg_full_color=8
		byte=16
		data_width=32

		data=self.bus#bus.read(address)

		pygame.init()

		screen=pygame.display.set_mode((640,480))
		pygame.display.set_caption("VgaMonitor")
		background=pygame.Surface((640,480))
		background.fill((255,255,255))

		if(mode):#enter the picture mode
			while True:
				h=0
				offset=0;
				while(offset<640*480):#condition?
					data=bus

					r_color=(data>>(data_width-fg_full_color))&0b11111111
					g_color=(data>>(data_width-2*fg_full_color))&0b11111111
					b_color=(data>>(data_width-3*fg_full_color))&0b11111111

					for event in pygame.event.get():
						if(event.type==QUIT):
							exit()

					offset+=1

					if(offset%640==0):
						h+=1
					
					background.set_at((offset%640,h),(r_color,g_color,b_color))
				screen.blit(background,(0,0))
				pygame.display.update()

		else:#enter the context mode
			while True:
				c=1
				h=-height
				offset=0
				while(offset<100):
					data=bus
					zi=FontTable[(data>>byte)-ord(" ")]

					r_color=(data>>(data_width-byte-fg_color))&0b11111
					g_color=(data>>(data_width-byte-2*fg_color))&0b11111
					b_color=(data>>(data_width-byte-3*fg_color))&0b11111

					for event in pygame.event.get():
						if(event.type==QUIT):
							exit()
					
					if(offset%line_limit==0):
						h+=16
					for y in range(h,h+height*c,c):
						for x in range(0,width*c,c):
							xx=(width-1)-x/c
							yy=(y%height)/c
							if (zi[yy]>>(xx) & 1==1):
								for i in range(x+(offset%line_limit)*width,x+c+(offset%line_limit)*width):
									for j in range(y,y+c):
										background.set_at((i,j),(r_color,g_color,b_color))
					offset+=1
				screen.blit(background,(0,0))
				pygame.display.update()

# class Bus(object):
# 	def __init__(self,addr):
# 		self.addr=addr

# 	def read(self):
# 		return self.addr



bus=0b11110000101011110000101000000000
# bus=0b00000000011001110000000000000000
vga_monitor=VgaMonitor(bus)
vga_monitor.draw_frame(1)









