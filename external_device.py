import pygame
import threading
from pygame.locals import *
from font_table import *
SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480
VRAM_ADDRESS = 0x10000000

class VideoGraphArray(object):
    def __init__(self, bus):
        self.bus = bus
        self.cursor_x = 0
        self.cursor_y = 0
        self.cursor_switch = 0
        self.mode = 0
        # self.px_arr = px_arr
        # self.screen = screen
        # self.background = pygame.Surface((SCREEN_WIDTH, SCREEN_HEIGHT))
        self.blink_counter = 0
        self.BLINKTIME = 100000
    def write(self, address, data):
        select = address & 0xff
        if select == 0:
            self.cursor_x = data
        elif select == 1:
            self.cursor_y = data
        elif select == 2:
            self.cursor_switch = data
        elif select == 3:
            self.mode = data

    def read(self, address):
        select = address & 0xff
        data = 0
        if select == 0:
            data = self.cursor_x
        elif select == 1:
            data = self.cursor_y
        elif select == 2:
            data = self.cursor_switch
        elif select == 3:
            data = self.mode

    def draw(self, px_arr, x, y):
        self.blink_counter += 1
        if self.blink_counter == self.BLINKTIME:
            self.blink_counter = 0
        width = 8
        height = 16
        fg_color = 1
        fg_full_color = 8
        byte = 16
        data_width = 12
        # self.background.fill((255, 255, 255))
        # px_arr = pygame.PixelArray(self.background)
        # px_arr = self.px_arr
        # px_arr[:] = (255, 255, 255)
        if (self.mode):
            # for x in range(SCREEN_WIDTH):
            if True:
                if True:
                # for y in range(SCREEN_HEIGHT):
                    address = VRAM_ADDRESS + (((y << 10) + x) << 2)
                    data = self.bus.read(address)
                    r = int(((data >> 5) & 0b111) / 7.0 * 255)
                    g = int(((data >> 2) & 0b111) / 7.0 * 255)
                    b = int((data & 0b11) / 3.0 * 255)

                    # self.background.set_at((x, y), (r, g, b))
        else:
            if True:
                if True:
            # for x in range(SCREEN_HEIGHT):
                # for y in  range(SCREEN_HEIGHT):
                    block_x = int(x / width)
                    block_y = int(y / height)
                    char_x = x % width
                    char_y = y % height
                    # blink = self.cursor_x == block_x \
                    #     and self.cursor_y == block_y \
                    #     and self.blink_counter > (self.BLINKTIME / 2)
                    address = VRAM_ADDRESS + (((block_y << 5) + block_x) << 2)
                    data = self.bus.read(address)
                    r = int(((data >> 2) & 1) * 255)
                    g = int(((data >> 1) & 1) * 255)
                    b = int((data & 1) * 255)
                    code = (data >> 3) & 0xff
                    if code < ord(' '):
                        code = ord(' ')
                    zi = FontTable[code - ord(' ')]
                    if self.cursor_switch:
                        if blink:
                            px_arr[x, y] = (0, 0, 0)
                            # self.background.set_at((x, y), (0, 0, 0))
                        elif (zi[char_y] >> (width - 1 - char_x)) & 1:
                            px_arr[x, y] = (r, g, b)
                            # self.background.set_at((x, y), (r, g, b))
                    else:
                        if (zi[char_y] >> (width - 1 - char_x)) & 1:
                            px_arr[x, y] = (r, g, b)
                            # self.background.set_at((x, y), (r, g, b))
        # del px_arr
        # self.screen.blit(self.background, (0, 0))
        # pygame.display.update()

class ExternalDevice(threading.Thread):
    def __init__(self, vm):
        super(ExternalDevice, self).__init__()
        self.vm = vm
        self.running = True
        
    def select_device(address):
        device = None
        address = (address & 0xffff) >> 16
        if address == 0:
            device = self.vga
        return device

    def read(self, address):
        device = self.select_device(address)
        if not device:
            raise Exception('Unkown external device address')
        return device.read(address)
        
    def write(self, address, data):
        device = self.select_device(address)
        if not device:
            raise Exception('Unkown external device address')
        return device.write(address, data)

    def run(self):
        pygame.init()
        pygame.display.set_caption("PySPIM")
        screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
        background = pygame.Surface((SCREEN_WIDTH, SCREEN_HEIGHT))
        px_arr = pygame.PixelArray(background)
        # background.fill((255, 0, 0))
        # screen.blit(background, (0, 0))
        # pygame.display.update()
        self.vga = VideoGraphArray(self.vm.bus)
        pygame.event.set_allowed(None)
        pygame.event.set_allowed([KEYDOWN, QUIT])
        self.keyboard_int = [];
        self.keyboard_count = 0;
        x = 0
        y = 0

        vga_thread = threading.Thread(target=vga_task, args=(self.vga, screen, px_arr)) 
        vga_thread.start()
        while True:
            if not self.running:
                break
            
            self.keyboard_int.extend(pygame.event.get(KEYDOWN))
            # if len(self.keyboard_int) > 0:
            #     self.vm.peek()
            #     self.vm.cpu.keyboard_int = True
            #     self.keyboard_int.pop(0)
            # else:
            #     self.vm.cpu.keyboard_int = False
            if self.keyboard_count > 0:
                self.keyboard_count -= 1
            elif len(self.keyboard_int) > 0:
                # print('hit key')
                self.vm.cpu.keyboard_int = True
                self.keyboard_count = 5000
                # self.vm.peek()
                self.keyboard_int.pop(0)
            else:
                self.vm.cpu.keyboard_int = False

            for event in pygame.event.get(QUIT):
                if event.type == QUIT:
                    self.stop()
                # print(event)

            # self.vga.draw(px_arr, x, y)
            
            # x += 1
            # if (x == SCREEN_WIDTH):
            #     y += 1
            #     x = 0
            #     if (y == SCREEN_HEIGHT):
            #         y = 0
            #         newbg = px_arr.make_surface()
            #         screen.blit(newbg, (0, 0))
            #         pygame.display.update()
            #         px_arr[:] = (255, 255, 255)

    def stop(self):
        self.running = False

def vga_task(*args):
    vga = args[0]
    screen = args[1]
    px_arr = args[2]
    x = 0
    y = 0
    while True:
        vga.draw(px_arr, x, y)
        newbg = px_arr.make_surface()
        screen.blit(newbg, (0, 0))
        pygame.display.update()
        
        x += 1
        if (x == SCREEN_WIDTH):
            y += 1
            x = 0
            if (y == SCREEN_HEIGHT):
                y = 0
                px_arr[:] = (255, 255, 255)
                