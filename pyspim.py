#!/usr/bin/python3
# -*- coding: UTF-8 -*-
import sys
import control_fsm as fsm
import alu_operation as aop
import external_device as ed
import os

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

def full_hex(x):
    assert isinstance(x, int), "Not a int type"
    h = hex(x)
    return '0'*(8 - (len(h) - 2)) + h[2:]

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
            'epc': 14,
            'ebase': 15
        }
        self.int_all_address = 0x80
        self.int_vector_table = 0x100
        self.set_int_enable()
        self.alive = False
        self.old_pc = 0
        self.reglist=["ze","at","v0","v1","a0","a1","a2","a3","t0",\
            "t1","t2","t3","t4","t5","t6","t7","s0","s1","s2","s3",\
            "s4","s5","s6","s7","t8","t9","k0","k1","gp","sp","fp","ra"]
        self.old_reg_file = [0] * 32
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
        

    def peek(self, pr=False, pe=False):
        # if pr == None:
        #     pr == True;
        # if pe == None;
        #     pe == False;
        print('=== current ===')
        print('Current PC', full_hex(self.old_pc))
        if pr:
            print('Curret regs')
            reg_lines = ''
            for i in range(32):
                flag = self.old_reg_file[i] != self.reg_file[i]
                if flag:
                    print(' \032', end='')
                else:
                    print('  ', end='')
                print(' $'+self.reglist[i]+'\t'+full_hex(self.reg_file[i]), end='')
                if i % 4 == 3:
                    print()
        # print(reg_lines)
        print('==== next ====')
        if pe:
            print('Next cp0 regs')
            for k in self.cp0_name:
                print('$' + k.ljust(8), full_hex(self.cp0_reg_file[self.cp0_name[k]]))
            print()
        print('Next PC', full_hex(self.pc))
        print('Next instruction', full_hex(self.instruction))
        return self.pc // 4;

    def set_int_level(self, flag):
        if flag:
            self.cp0_reg_file[self.cp0_name['status']] |= 0b10
        else:
            self.cp0_reg_file[self.cp0_name['status']] &= 0xfffffffd

    def run(self):
        while True:
            self.step()

    def regCheck(self):
        for i in range(32):
            assert isinstance(self.reg_file[i], int), "Wrong type to write into a register"
            assert isinstance(self.cp0_reg_file[i], int), "Wrong type to write into a cp0 register"

    def step(self):
        """run one instruction at one time"""
        self.alive = True
        pc = self.pc
        self.old_pc = pc
        self.old_reg_file = self.reg_file[:]
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
        self.int_hit = False
        if self.is_int_enable() and not self.is_int_level(): # allow int
            if self.keyboard_int: # key int
                self.set_int_level(True)
                self.int_hit = True
                print('Got keyboard int')
                self.keyboard_int = False
                self.set_excode(0)      
                self.epc = pc;
                pc = self.int_all_address
                # print('pc in int', pc)
            elif opcode == 0 and func == 0xc: # syscall
                self.set_int_level(True)
                self.int_hit = True
                self.set_excode(8)
                self.epc = pc + 4 # can add 4 in the interrupt service
                pc = self.int_all_address


        if self.int_hit:
            pass
            # self.reg_file[0] = 0
            # self.pc = pc
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
            elif func in [0b000100, 0b000110, 0b000111]: # [sllv, srlv, srav]
                op1 = self.reg_file[rt]
                op2 = self.reg_file[rs]
                shift_by_reg_map = {
                    0b000100: aop.SLL,
                    0b000110: aop.SRL,
                    0b000111: aop.SRA
                }
                self.reg_file[rd], self.zero, self.carry, self.overflow = \
                    alu_calc(shift_by_reg_map[func], op1, op2)
                pc = pc + 4
            elif func == 0b001000:  # jump reg
                pc = self.reg_file[rs]
            elif func == 0b001001:  # jump reg and link
                self.reg_file[rd] = pc + 4
                pc = self.reg_file[rs]


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
                self.reg_file[rt] = (imme << 16) & 0xffffffff
                pc = pc + 4
            elif opcode == 0b000010:
                pc = ((pc + 4) & 0xf0000000) | ((addr << 2) & 0x0fffffff)
            elif opcode == 0b000011:
                self.reg_file[31] = pc + 4
                pc = ((pc + 4) & 0xf0000000) | ((addr << 2) & 0x0fffffff)
            elif opcode == 0x10: # mfc0/mtc0/eret
                if rs == 0: # mfc0
                    self.reg_file[rt] = self.cp0_reg_file[rd]
                    pc = pc + 4
                elif rs == 4: # mtc0
                    self.cp0_reg_file[rd] = self.reg_file[rt]
                    pc = pc + 4
                elif rs == 16 and func == 0x18: # eret
                    # print("Return from interrupt", self.epc)
                    self.set_int_level(False) # exiting interrupt
                    pc = self.epc


        self.pc = pc
        self.reg_file[0] = 0
        self.regCheck()
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
            # print('read in external device at', address)
            device = self.external_device
        return device

    def read(self, logic_address):
        device = self.address_map(logic_address)
        return device.read(logic_address)

    def write(self, logic_address, data):
        assert isinstance(data, int), "Not a int type to write: " + str(data);
        device = self.address_map(logic_address)
        device.write(logic_address, data)

class Ram(object):
    def __init__(self, init_data):
        self.memory = [0] * 0x10000
        for x in range(0, len(init_data)):
            self.memory[x] = init_data[x]

    def read(self, address):
        address &= 0xffff
        return self.memory[address >> 2]

    def write(self, address, data):
        address &= 0xffff
        self.memory[address >> 2] = data

    def peek(self, start_addr = 0):
        print('========= ram ==========')
        for i in range(start_addr >> 2, (start_addr >> 2) + 32, 4):
            ram_line = '0x' + full_hex(i << 2) + ': '
            line_tail = ' '
            for j in range(i, i + 4):
                hex_str = full_hex(self.memory[j])
                ram_line += ' ' + hex_str
                for k in range(0, 4):
                    x = 'b"\\x' + hex_str[k*2:k*2+2] + '"'
                    y = eval(x)
                    if (len(str(y))) == 4:
                        y = str(y)[2:3]
                    else:
                        y = '.'
                    line_tail += y#str(eval('b"\\x' + hex_str[k*2:k*2+2] + '"'))
            ram_line += line_tail
            print(ram_line)


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
        print('Writae vram at', full_hex(address))
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
        return self.cpu.peek()
        #self.ram.peek()

    def reset(self):
        pass

def main():
    disasm_code = None
    if (len(sys.argv) == 2):
        with open(sys.argv[1]) as code_file:
            machineCode = code_file.read()
        with open('disasm.txt') as disasm_file:
            disasm_code = disasm_file.readlines()
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
        try:
            input_str = input('Run command: ')
            if input_str == 's' or input_str == 'step' or input_str == '':
                vm.step()
                lineNo = vm.peek()
                print(disasm_code[lineNo])
            elif input_str == 'r' or input_str == 'run':
                vm.run()
            elif input_str == 't' or input_str == 'test':
                for i in range(100000):
                    vm.step()
            elif input_str.startswith('p') or input_str.startswith('peek'):
                pr = input_str.find('r') != -1
                pe = input_str.find('e') != -1
                lineNo = vm.cpu.peek(pr, pe)
                print(disasm_code[lineNo])
            elif input_str == 'l' or input_str == 'list':
                lineNo = vm.cpu.old_pc // 4
                for i in range(vm.cpu.old_pc // 4 - 5, vm.cpu.old_pc//4 + 5):
                    if i >= 0 and i < len(disasm_code):
                        if i != lineNo:
                            print('   ' + disasm_code[i], end='')
                        else:
                            print(' \032 ' + disasm_code[i], end='')
                print()
            elif input_str[0] == 'n' or input_str[0:4] == 'next':
                n = '0' + input_str.strip('next ')
                print(int(n))
                for i in range(int(n)):
                    print('PC ', full_hex(vm.cpu.old_pc))
                    vm.step()
                lineNo = vm.peek()
                print(disasm_code[lineNo])
            elif input_str.startswith('b') or input_str.startswith('break'):
                n = input_str.strip('break ')
                flag = False
                for i in range(10000):
                    vm.step()
                    if vm.cpu.old_pc == eval(n):
                        flag = True
                        break
                if not flag:
                    raise Exception('Dead loop in execution of "' + input_str + '"')
            elif input_str.startswith('m') or input_str.startswith('memory'):
                n = input_str.strip('memory ')
                if len(n) == 0:
                    n += '0'
                vm.ram.peek(eval(n))
            elif input_str == 'e' or input_str == 'exit':
                print("Exiting...")
                t.stop()
                exit()
            else:
                print('Unkown command. PySPIM support commands as follows')
                indent = 20
                help_info = '\n'+\
                '  s[tep]'.ljust(indent) +\
                    'Run one step\n' +\
                '  n[ext] [n]'.ljust(indent) +\
                    'Run for n steps\n' +\
                '  t[est]'.ljust(indent) +\
                    'Run about 100000 times\n' +\
                '  r[un]'.ljust(indent) +\
                    'Run forever\n'+\
                '  p[eek]'.ljust(indent) +\
                    'Peek at the VM\n'+\
                '  l[ist]'.ljust(indent) +\
                    'List codes near PC\n'+\
                '  m[emory] [addr]'.ljust(indent) +\
                    'Dump memory content start at address(e.g 0x10 or 32)\n' +\
                '  b[reak] [addr]'.ljust(indent) +\
                    'Break at address (e.g. 0x10 or 32)\n' +\
                '  e[xit]'.ljust(indent) +\
                    'Exit PySPIM\n\n' +\
                '  Use Ctrl+C to exit at any time\n'
                print(help_info)
        except Exception as ex:
            print(str(ex))
            print('============ VM info ============')
            print()
            lineNo = vm.peek()
            print(disasm_code[lineNo])
            print('============ Exception ==========')
            t.stop()
            raise ex

if __name__ == '__main__':
    try:
        main()
    except:
        print('Exiting')
        os._exit(0)

