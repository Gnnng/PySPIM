#!/usr/bin/python3
# -*- coding: UTF-8 -*-
import sys
import control_fsm as fsm
import alu_operation as aop
import external_device as ed

RESET = 0

def alu_calc(operation, op1, op2):
    result, overflow, carry = 0, False, False
    signed_32 = lambda x: {0: x, 1: -(2**32 - x)}[(x >> 31) & 1]
    if operation == aop.AND:
        result = (op1 & op2) & 0xffffffff   
    if operation == aop.OR:
        result = (op1 | op2) & 0xffffffff
    if operation == aop.ADD:
        sop1 = signed_32(op1)
        sop2 = signed_32(op2)
        result = sop1 + sop2
        overflow = (sop1 > 0 and sop2 > 0 and result > 0x7fffffff) or \
            (sop1 < 0 and sop2 < 0 and result < -1 * 2**31)
        result = signed_32(result & 0xffffffff)
    if operation == aop.SUB:
        sop1 = signed_32(op1)
        sop2 = signed_32(op2)
        # print("sop1 = ", sop1)
        # print("sop2 = ", sop2)
        result = sop1 - sop2
        overflow = (sop1 > 0 and sop2 < 0 and result > 0x7fffffff) or \
            (sop1 < 0 and sop2 > 0 and result < -1 * 2**31)
        result = signed_32(result & 0xffffffff)
    if operation == aop.SLT:
        if signed_32(op1) < signed_32(op2):
            result = 1
        else:
            result = 0
    if operation == aop.XOR:
        result = (op1 ^ op2) & 0xffffffff
    if operation == aop.SLL:
        result = (op1 << op2) & 0xffffffff
    if operation == aop.SRL:
        result = (op1 >> op2) & 0xffffffff
    if operation == aop.SRA:
        sop1 = signed_32(op1)
        result = (sop1 >> op2) & 0xffffffff
    if operation == aop.NOR:
        result = (~(op1 | op2)) & 0xffffffff
    if operation == aop.ADDU:
        result = op1 + op2
        carry = result > 2**32
    if operation == aop.SUBU:
        result = op1 - op2
        carry = result < 0
    if operation == aop.SLTU:
        if op1 < op2:
            result = 1
        else:
            result = 0
    return (result, result == 0, carry, overflow)

class Cpu(object):
    
    def __init__(self, bus):
        self.pc = 0
        self.reg_file = [0] * 32
        self.cp0_reg_file = [0] * 32
        self.bus = bus
        self.instruction = 0
        self.zero = False
        self.carry = False
        self.overflow = False
        self.keyboard_int = False
        self.cp0_name = {
            'status': 12,
            'cause': 13,
            'epc': 14
        }
        self.int_all_address = 4
        self.int_vector_table = 0x100
        self.set_int_enable()
        self.alive = False

    def ready_to_int(self):
        return not self.is_int_level() and self.alive

    def is_int_enable(self):
        return (self.cp0_reg_file[self.cp0_name['status']] & 1) != 0

    def set_int_enable(self):
        self.cp0_reg_file[self.cp0_name['status']] |= 1

    def is_int_level(self):
        return (self.cp0_reg_file[self.cp0_name['status']] & 0b10) != 0

    def set_excode(self, code):
        self.cp0_reg_file[self.cp0_name['cause']] &= 0xffffff83
        self.cp0_reg_file[self.cp0_name['cause']] |= (code << 2)
        

    def peek(self):
        print('Instruction', self.instruction)
        print('PC', self.pc)
        # print('Flags', self.zero, self.carry, self.overflow)
        print('Regs', self.reg_file)

    def set_int_level(self, flag):
        if flag:
            self.cp0_reg_file[self.cp0_name['status']] |= 0b01
        else:
            self.cp0_reg_file[self.cp0_name['status']] &= 0xfffffffd
    def run(self):
        while True:
            self.step()

    def step(self):
        """run one instruction at one time"""
        self.alive = True
        pc = self.pc
        inst = self.bus.read(pc)
        self.instruction = inst
        opcode = (inst >> 26) & 0x3f
        rs = (inst >> 21) & 0x1f
        rt = (inst >> 16) & 0x1f
        rd = (inst >> 11) & 0x1f
        shamt = (inst >> 6) & 0x1f
        func = (inst) & 0x3f
        imme = (inst) & 0xffff 
        addr = (inst) & 0x03ffffff
        signed_ext_16_to_32 = lambda x: {0: x, 1: -(2**16 - x)}[(x >> 15) & 1]
        if self.is_int_enable() and not self.is_int_level(): # allow int
            self.int_hit = False
            if self.keyboard_int: # key int
                print('Got keyboard int')
                self.keyboard_int = False
                self.set_excode(0)      
                self.epc = pc;
                pc = self.int_all_address
                self.set_int_level(True)
                self.int_hit = True
            elif opcode == 0 and func == 0xc: # syscall
                self.set_excode(8)
                self.epc = pc + 4 # can add 4 in the interrupt service
                pc = self.int_all_address
                self.set_int_level(True)
                self.int_hit = True

        if self.int_hit:
            self.reg_file[0] = 0
            self.pc = pc
        elif opcode == 0b000000:
            # r - type
            alu_op = aop.convert_func(func)
            if alu_op:
                if alu_op in (aop.SLL, aop.SRA, aop.SRL):
                    op1 = self.reg_file[rt]
                    op2 = shamt
                else:
                    op1 = self.reg_file[rs]
                    op2 = self.reg_file[rt]
                self.reg_file[rd], self.zero, self.carry, self.overflow = \
                    alu_calc(alu_op, op1, op2)
                pc = pc + 4
            elif func == 0b001000:  # jump
                pc = self.reg_file[rs]
            # elif func = 0xc: # syscall

        else:
            alu_op = aop.convert_opcode(opcode)
            if alu_op:
                op1 = self.reg_file[rs]
                if alu_op in (aop.ADD, aop.SLT):
                    op2 = signed_ext_16_to_32(imme)
                else:
                    op2 = imme
                self.reg_file[rt], self.zero, self.carry, self.overflow = \
                    alu_calc(alu_op, op1, op2)
                pc = pc + 4
            elif opcode == 0b100011: # lw
                address = self.reg_file[rs] + signed_ext_16_to_32(imme)
                self.reg_file[rt] = self.bus.read(address)
                pc = pc + 4
            elif opcode == 0b101011: # sw
                address = self.reg_file[rs] + signed_ext_16_to_32(imme)
                self.bus.write(address, self.reg_file[rt])
                pc = pc + 4
            elif opcode == 0b000100:
                if self.reg_file[rs] == self.reg_file[rt]:
                    pc = pc + 4 + (signed_ext_16_to_32(imme) << 2)
                else:
                    pc = pc + 4
            elif opcode == 0b000101:
                if self.reg_file[rs] != self.reg_file[rt]:
                    pc = pc + 4 + (signed_ext_16_to_32(imme) << 2)
                else:
                    pc = pc + 4
            elif opcode == 0b001111:
                self.reg_file[rt] = imme << 16
                pc = pc + 4
            elif opcode == 0b000010:
                pc = ((pc + 4) & 0xf0000000) | ((addr << 2) & 0x0fffffff)
            elif opcode == 0b000011:
                pc = ((pc + 4) & 0xf0000000) | ((addr << 2) & 0x0fffffff)
                self.reg_file[31] = pc + 4
            elif opcode == 0x10: # mfc0/mtc0/eret
                if rs == 0: # mfc0
                    self.reg_file[rt] = self.cp0_reg_file[rd]
                    pc = pc + 4
                elif rs == 4: # mtc0
                    self.cp0_reg_file[rd] = self.reg_file[rt]
                    pc = pc + 4
                elif rs == 16 and func == 0x18: # eret
                    self.set_int_level(False) # exiting interrupt
                    pc = self.epc


        self.pc = pc
        self.reg_file[0] = 0
        self.alive = False

class Bus(object):
    def __init__(self, ram):
        self.ram = ram
        self.vram = VideoRam()
        self.external_device = None

    def add_device(self, device):
        self.external_device = device

    def address_map(self, address):
        device = None
        if address < 0x10000000:
            device = self.ram
        elif address < 0xffff0000:
            device = self.vram
        else:
            print('read in external device at', address)
            device = self.external_device
        return device

    def read(self, logic_address):
        device = self.address_map(logic_address)
        return device.read(logic_address)

    def write(self, logic_address, data):
        device = self.address_map(logic_address)
        device.write(logic_address, data)

class Ram(object):
    def __init__(self, init_data):
        self.memory = [0] * 1024
        for x in range(0, len(init_data)):
            self.memory[x] = init_data[x]

    def read(self, address):
        address &= 0xffff
        return self.memory[address >> 2]

    def write(self, address, data):
        address &= 0xffff
        self.memory[address >> 2] = data

    def peek(self, start = 0, len = 10):
        print("Ram ", self.memory[start << 2: (start + len) << 2])

class VideoRam(object):
    def __init__(self):
        self.memory = [0] * (2**19)

        # count = 0
        # for x in 'a'*79:
        #     self.memory[count] = int(ord(x)) << 3;
        #     count += 1

        # count = 0
        # for x in 'b'*79:
        #     self.memory[(1 << 7) + count] = int(ord(x)) << 3;
        #     count += 1

        # count = 0
        # for x in 'c'*78:
        #     self.memory[(2 << 7) + count] = int(ord(x)) << 3;
        #     count += 1

        # count = 0
        # for x in 'd'*76:
        #     self.memory[(3 << 7) + count] = int(ord(x)) << 3;
        #     count += 1

        # count = 0
        # for x in 'e'*75:
        #     self.memory[(4 << 7) + count] = int(ord(x)) << 3;
        #     count += 1
    def read(self, address):
        address &= 0x1fffff
        return self.memory[address >> 2]

    def write(self, address, data):
        print('vram write at', address)
        address &= 0x1fffff
        self.memory[address >> 2] = data


class VirtualMachine(object):
    byteWidth = 16
    def __init__(self, ram):
        self.ram = Ram(ram)
        self.bus = Bus(self.ram)
        self.cpu = Cpu(self.bus)

    def interrupt(self, code):
        self.cpu.interrupt(code)

    def run(self):
        self.cpu.run()

    def step(self):
        self.cpu.step()

    def peek(self):
        self.cpu.peek()
        self.ram.peek()

    def reset(self):
        pass

def main():
    if (len(sys.argv) == 2):
        with open(sys.argv[1]) as code_file:
            machineCode = code_file.read()
    else:
        machineCode = input(
            'Please input machine code, one instruction per line\n')

    if len(machineCode) == 0:
        print('No content of code')
        exit()
    
    codes = []
    for x in machineCode.split('\n'):
        if len(x) > 0:
            codes.append(int(x, 2))
    vm = VirtualMachine(codes)
    t = ed.ExternalDevice(vm)
    vm.bus.add_device(t)
    t.start()
    while True:
        input_str = input('Run command: ')
        if input_str == 's' or input_str == 'step' or input_str == '':
            vm.step()
            vm.peek()
        elif input_str == 'r' or input_str == 'run':
            vm.run()
        elif input_str == 't' or input_str == 'test':
            for i in range(100000):
                vm.step()
        elif input_str == 'p' or input_str == 'peek':
            vm.cpu.peek()
            vm.ram.peek()
        elif input_str == 'e' or input_str == 'exit':
            print("Exiting...")
            t.stop()
            exit()

if __name__ == '__main__':
    main()
