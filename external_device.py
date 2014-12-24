import pygame
import threading
from pygame.locals import *
from font_table import *
import time
SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480
VRAM_ADDRESS = 0x10000000

def full_hex(x):
    assert isinstance(x, int), "Not a int type"
    h = hex((x) & 0xffffffff)
    return '0'*(8 - (len(h) - 2)) + h[2:]

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

class VGAdrawer(threading.Thread):
    def __init__(self, px_arr, base_y, step, mode, bus, cx, cy, cw):
        super(VGAdrawer, self).__init__()
        print('base is', base_y, 'step is', step)
        self.running = False
        self.px_arr = px_arr
        self.base_y = base_y
        self.step = step
        self.mode = mode
        self.bus = bus
        self.cursor_x = cx
        self.cursor_y = cy
        self.cursor_switch = cw

    def run(self):
        self.running = True
        while True:
            if not self.running:
                break
            # px_arr[:] = (255, 255, 255)
            for x in range(SCREEN_WIDTH):
                # for y in range(SCREEN_HEIGHT):
                for y in range(0, self.step):
                    self.draw(self.px_arr, x, y + self.base_y)
            # self.screen.blit(px_arr.make_surface(), (0, 0))
            # pygame.display.update()

    def draw(self, px_arr, x, y):
        width = 16
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
            zi = FontTable[code]
            if self.cursor_switch:
                if blink:
                    px_arr[x, y] = (0, 0, 0)
                elif (zi[char_y] >> (width - 1 - char_x)) & 1:
                    px_arr[x, y] = (r, g, b)
            else:
                if (zi[char_y] >> (width - 1 - char_x)) & 1:
                    px_arr[x, y] = (r, g, b)

    def stop(self):
        self.running = False

class VideoGraphArray(threading.Thread):
    def __init__(self, bus):
        super(VideoGraphArray, self).__init__()
        self.thread_number = 30
        self.VGA_thread = []
        self.address_array = []
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
        # print("success")

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
        print("VGA read at ", full_hex(address))
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
        return data

    def update(self, address):
        self.address_array.append(address)

    def run(self):
        # version 3
        self.running = True
        # px_arr = pygame.PixelArray(self.background)
        while True:
            time.sleep(0.05)
            if not self.running:
                break
            add_arr = self.address_array[:]
            # if (len(self.address_array) > 0):
            #     print(len(self.address_array))
            self.address_array = []
            for addr in add_arr:
                self.blit(addr)
            self.screen.blit(self.px_arr.make_surface(), (0, 0))
            pygame.display.update()

        # version 2
        # self.running = True
        # px_arr = pygame.PixelArray(self.background)
        # step = SCREEN_HEIGHT // self.thread_number
        # print(step)
        # for i in range(self.thread_number):
        #     new_thread = VGAdrawer(px_arr, i * step,\
        #         step, self.mode, self.bus, self.cursor_x, self.cursor_y, self.cursor_switch)
        #     self.VGA_thread.append(new_thread)

        # for i in range(self.thread_number):
        #     self.VGA_thread[i].start()

        # while True:
        #     if not self.running:
        #         break
        #     time.sleep(1)
        #     self.screen.blit(px_arr.make_surface(), (0, 0))
        #     pygame.display.update()

        # for i in range(self.thread_number):
        #     self.VGA_thread[i].join()

        # version 1
        # self.running = True
        # px_arr = pygame.PixelArray(self.background)
        # while True:
        #     if not self.running:
        #         break
        #     px_arr[:] = (255, 255, 255)
        #     for x in range(SCREEN_WIDTH):
        #         # for y in range(SCREEN_HEIGHT):
        #         for y in range(0, 16):
        #             self.draw(px_arr, x, y)
        #     self.screen.blit(px_arr.make_surface(), (0, 0))
        #     pygame.display.update()

    def stop(self):
        self.running = False
        # for i in range(self.thread_number):
        #     self.VGA_thread[i].stop()

    def blit(self, address):
        width = 16
        height = 16
        if self.mode:
            x = (address >> 2) & 0x3ff
            y = (address >> 12) & 0x1ff
            data = self.bus.read(VRAM_ADDRESS + address)
            r = int(((data >> 5) & 0b111) / 7.0 * 255)
            g = int(((data >> 2) & 0b111) / 7.0 * 255)
            b = int((data & 0b11) / 3.0 * 255)
            self.px_arr[x, y] = (r, g, b)
        else:
            block_x = (address >> 2) & 0x7f
            block_y = (address >> 9) & 0x1f
            data = self.bus.read(VRAM_ADDRESS + address)
            r = int(((data >> 2) & 1) * 255)
            g = int(((data >> 1) & 1) * 255)
            b = int((data & 1) * 255)
            code = (data >> 3) & 0xff
            zi = FontTable[code]
            char_x = 0
            char_y = 0
            for x in range(block_x * width, (block_x + 1) * width):
                char_y = 0
                for y in range(block_y * height, (block_y + 1) * height):
                    
                    if (zi[char_y] >> (width - 1 - char_x)) & 1:
                        self.px_arr[x, y] = (r, g, b)
                    else:
                        self.px_arr[x, y] = (255, 255, 255)
                    char_y += 1
                char_x += 1

    def draw(self, px_arr, x, y):
        width = 16
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
            zi = FontTable[code]
            # zi = FontTable[code - ord(' ')]
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
        # self.vga = VideoGraphArray(self.vm.bus)
        self.keyboard = None
        self.running = False

    def address_map(self, address):
        device = None
        print('External IO at address: ', full_hex(address))
        address = (address >> 8) & 0xff
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
        device = self.address_map(address)
        device.write(address, data)

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
        self.vm.bus.vram.vga = self.vga
        self.vga.start()
        # print("vga started")

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



                