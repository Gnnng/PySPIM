#!/usr/bin/python3
# -*- coding: UTF-8 -*-
import sys
import control_fsm as fsm
import alu_operation as aop

RESET = 0

class Control(object):
        def __init__(self, bus):
            self.signals = {
                'PCWriteCond': '0',
                'PCWrite': '0',
                'IorD': '0',
                'MemRead': '0',
                'MemWrite': '0',
                'MemtoReg': '00',
                'IRWrite': '0',
                'RegDst': '00',
                'RegWrite': '0',
                'PCsource': '00',
                'ALUsrcA': '0',
                'ALUsrcB': '00',
                'ALUop': '0000',
                'Beq': '0',
                'Sign': '0'
            }
            self.state = fsm.START
            self.bus = bus

        def _signal_convert(self, raw_signals):
            signals = self.signals
            signals['PCWriteCond'] = raw_signals[0: 1]
            signals['PCWrite'] = raw_signals[1: 2]
            signals['IorD'] = raw_signals[2: 3]
            signals['MemRead'] = raw_signals[3: 4]
            signals['MemWrite'] = raw_signals[4: 5]
            signals['MemtoReg'] = raw_signals[5: 7]
            signals['IRWrite'] = raw_signals[7: 8]
            signals['RegDst'] = raw_signals[8: 10]
            signals['RegWrite'] = raw_signals[10: 11]
            signals['PCsource'] = raw_signals[11: 13]
            signals['ALUsrcA'] = raw_signals[13: 14]
            signals['ALUsrcB'] = raw_signals[14: 16]
            signals['ALUop'] = raw_signals[16: 20]
            signals['Beq'] = raw_signals[20: 21]
            signals['Sign'] = raw_signals[21: 22]
            return signals

        def next_state(self):
            # print('before change', self.state)
            inst = 0
            if self.state in (fsm.START, fsm.ALUREG):
                self.state = fsm.IF
                self.signals = self._signal_convert(fsm.SIGNALS[self.state])
            elif self.state == fsm.IF:
                self.state = fsm.ID
                self.signals = self._signal_convert(fsm.SIGNALS[self.state])
            elif self.state == fsm.ID:
                self.state = fsm.RTYPE
                self.signals = self._signal_convert(fsm.SIGNALS[self.state])
            elif self.state == fsm.RTYPE:
                self.state = fsm.ALUREG
                self.signals = self._signal_convert(fsm.SIGNALS[self.state])
            # print('after change', self.state)

# test _signal_convert
# c = Control(1)
# print(c.signals)
# c._signal_convert('0101000100000001000000')
# print(c.signals)

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
            (sop1 < 0 and sop2 < 0 and result < -2 * 2**31)
        result = signed_32(result & 0xffffffff)
    if operation == aop.SUB:
        sop1 = signed_32(op1)
        sop2 = signed_32(op2)
        result = sop1 - sop2
        overflow = (sop1 > 0 and sop2 < 0 and result > 0x7fffffff) or \
            (sop1 < 0 and sop2 > 0 and result < -2 * 2**31)
        result = signed_32(result & 0xffffffff)
    if operation == aop.SLT:
        if op1 < op2:
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
        result = (op1 >> op2) & 0xffffffff
    if operation == aop.NOR:
        result = (~(op1 | op2)) & 0xffffffff
    if operation == aop.ADDU:
        result = op1 + op2
        carry = result > 2**32
    if operation == aop.SUBU:
        result = op1 - op2
        carry = result < 0
    return (result, result == 0, carry, overflow)

class Cpu(object):
    
    def __init__(self, bus):
        self.pc = 0
        self.reg_file = [0] * 32
        self.bus = bus
        self.alu = Alu()
        self.instruction = 0

    def step(self):
        """run one instruction at one time"""
        inst = self.bus.read()
        self.instruction = inst
        opcode = (inst >> 26) & 0x3f
        rs = (inst >> 21) & 0x1f
        rt = (inst >> 16) & 0x1f
        rd = (inst >> 11) & 0x1f
        shamt = (inst >> 6) & 0x1f
        func = (inst) & 0x3f
        imme = (inst) & 0xffff 

        if opcode == 0b000000:
            # r - type
            if func == 0b100000


class Bus(object):
    def __init__(self, ram):
        self.ram = ram

    def read(self, logic_address):
        ram.read(logic_address)

    def write(self, logic_address, data):
        ram.write(logic_address, data)


class Ram(object):
    def __init__(self, init_data):
        self.memory = init_data

    def read(self, address):
        return memory[address >> 2]

    def write(self, address, data):
        memory[address >> 2] = data

class VideoRam(object):
    def __init__(self):
        pass

class VirtualMachine(object):
    byteWidth = 16
    def __init__(self, ram):
        self.ram = Ram(ram)
        self.bus = Bus(self.ram)
        self.cpu = Cpu(self.bus)

    def run(self):
        self.cpu.run()

    def step(self):
        self.cpu.step()

    def reset(self):
        pass

def main():
    # if (len(sys.argv) == 2):
    #     # print(sys.argv[1])
    #     with open(sys.argv[1]) as machineCode:
    #         print(machineCode)             
    # else:
    #     machineCode = input(
    #         'Please input machine code, one instruction per line\n')

    # if len(machineCode) == 0:
    #     print('No content of code')
    #     exit()

    machineCode = ['00000000101000000010000000100000']
    vm = VirtualMachine(machineCode)
    vm.step()
    # while True:
    #     vm.step()

if __name__ == '__main__':
    main()
