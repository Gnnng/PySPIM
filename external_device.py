import pygame
import threading
from pygame.locals import *
from font_table import *
import time
SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480
VRAM_ADDRESS = 0x10000000

class KeyBoard(threading.Thread):
    def __init__(self, cpu):
        super(KeyBoard, self).__init__()
        self.cpu = cpu
        self.running = False
        # self.buffer = []

    def write(self, address, data):
        raise Exception("Not implemented") 

    def read(self, address):
        address &= 0xff
        data = 0
        if address == 0:
            data = self.scan_code
            print('read in keyboard device')
            self.scan_code = 0
        else:
            raise Exception("Invalid address")
        return data

    def run(self):
        self.running = True

        while True:
            if not self.running:
                break
            for event in pygame.event.get([KEYDOWN, KEYUP]):
                time.sleep(0.1)
                if self.cpu.ready_to_int():
                    if event.type == KEYDOWN:
                        self.scan_code = event.key + (1 << 16);
                    elif event.type == KEYUP:
                        self.scan_code = event.key;
                    self.cpu.keyboard_int = True

    def stop(self):
        self.running = False

class VideoGraphArray(threading.Thread):
    def __init__(self, bus):
        super(VideoGraphArray, self).__init__()
        self.bus = bus
        self.cursor_x = 0
        self.cursor_y = 0
        self.cursor_switch = 0
        self.mode = 0
        self.screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
        self.background = pygame.Surface((SCREEN_WIDTH, SCREEN_HEIGHT))
        self.background.fill((255, 255, 255))
        self.screen.blit(self.background, (0, 0))
        pygame.display.update()
        self.px_arr = pygame.PixelArray(self.background)
        # self.px_arr = pygame.surfarray.pixels2d(self.background)
        
        self.blink_counter = 0

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

    def run(self):
        self.running = True
        x = 0
        y = 0
        px_arr = pygame.PixelArray(self.background)
        while True:
            if not self.running:
                break
            px_arr[:] = (255, 255, 255)
            for x in range(SCREEN_WIDTH):
                # for y in range(SCREEN_HEIGHT):
                for y in range(0, 16):
                    self.draw(px_arr, x, y)
            self.screen.blit(px_arr.make_surface(), (0, 0))
            pygame.display.update()

    def stop(self):
        self.running = False

    def draw(self, px_arr, x, y):
        width = 8
        height = 16
        if (self.mode):
            address = VRAM_ADDRESS + (((y << 10) + x) << 2)
            data = self.bus.read(address)
            r = int(((data >> 5) & 0b111) / 7.0 * 255)
            g = int(((data >> 2) & 0b111) / 7.0 * 255)
            b = int((data & 0b11) / 3.0 * 255)
            px_arr[x, y] = (r, g, b)
        else:
            block_x = int(x / width)
            block_y = int(y / height)
            char_x = x % width
            char_y = y % height
            address = VRAM_ADDRESS + (((block_y << 7) + block_x) << 2)
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
                elif (zi[char_y] >> (width - 1 - char_x)) & 1:
                    px_arr[x, y] = (r, g, b)
            else:
                if (zi[char_y] >> (width - 1 - char_x)) & 1:
                    px_arr[x, y] = (r, g, b)

class ExternalDevice(threading.Thread):
    def __init__(self, vm):
        super(ExternalDevice, self).__init__()
        self.vm = vm
        self.vga = None
        self.keyboard = None
        self.running = False

    def address_map(self, address):
        device = None
        print('address is', address)
        address = (address & 0xffff) >> 8
        if address == 0:
            device = self.vga
        elif address == 1:
            device = self.keyboard
        else:
            raise Exception('Unkown external device address')
        return device

    def read(self, address):
        device = self.address_map(address)
        return device.read(address)
        
    def write(self, address, data):
        device = self.select_device(address)
        return device.write(address, data)

    def run(self):
        self.running = True
        # start pygame
        pygame.init()
        pygame.display.set_caption("PySPIM")

        # event settings
        pygame.event.set_allowed(None)
        pygame.event.set_allowed([KEYDOWN, KEYUP, QUIT])

        # start vga
        self.vga = VideoGraphArray(self.vm.bus)
        self.vga.start()

        # start keyboard
        self.keyboard = KeyBoard(self.vm.cpu)
        self.keyboard.start()

        # main loop
        while True:
            if not self.running:
                break
            for event in pygame.event.get([QUIT]):
                self.stop()

        self.vga.join()
        self.keyboard.join()
        pygame.quit()

    def stop(self):
        self.running = False
        self.vga.stop()
        self.keyboard.stop()



                