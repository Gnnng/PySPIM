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

class Alu(object):

    def __ini__(self, control):
        self.control = control
        self.overflow = 0
        self.zero = 0
    def calc(self, op1, op2):
        operation = self.control.signals['ALUop']
        result = 0
        self.overflow = 0
        if operation == aop.AND:
            result = (op1 & op2) & 0xffffffff
        if operation == aop.OR:
            result = (op1 | op2) & 0xffffffff
        if operation == aop.ADD:
            result = op1 + op2
            if op1 > 0 and op2 > 0 and result > 0x7fffffff:
                self.overflow = 1
            if op1 < 0 and op2 < 0 and result < -2 * 2**31:
                self.overflow = 1
            result = result & 0xffffffff
        if operation == aop.SUB:
            result = op1 - op2
            if op1 > 0 and op2 < 0 and result > 0x7fffffff:
                self.overflow = 1
            if op1 < 0 and op2 > 0 and result < -2 * 2**31:
                self.overflow = 1
            result = result & 0xffffffff
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
        if result == 0:
            self.zero = 1
        else:
            self.zero = 0
        return result

class Cpu(object):
    
    def __init__(self, bus):
        self.pc = 0
        self.last_pc = 0
        self.reg_file = [0] * 32
        self.bus = bus
        self.control = Control(bus)
        self.signals = None
        self.pc_new = 0
        self.alu_out = 0
        self.ir = None

    def step(self):
        """Run one instruction"""
        i = 12
        while True:
            print('Running at', i)
            self.control.next_state() # enter new state
            self.signals = self.control.signals
            if self.signals['PCWrite'] == '1' or (self.sig)
            self.pc_new_signal = self.signals['PCWrite'] 
            if self.control.state == fsm.IF:
                self.control.instruction = self.bus.read(self.pc)
            if self.control.state == fsm.ID:


            # print(signals)
            i = i - 1
            if i == 0:
                break

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
        self.reset = True
        self.ram = Ram(ram)
        self.vram = VideoRam()
        self.bus = Bus(self.ram)
        self.cpu = Cpu(self.bus)
        self.alu = Alu(self.control)
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
