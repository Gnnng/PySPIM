import unittest
import alu_operation as aop
import pyspim

class ALUTestCase(unittest.TestCase):

    def setUp(self):
        pass

    def tearDown(self):
        pass

    def test_AND(self):
        c = pyspim.alu_calc
        f = self.assertTupleEqual
        f(c(aop.AND, 0xffff0000, 0xa0a0a0a0), (0xa0a00000, False, False, False))

    def test_OR(self):
        c = pyspim.alu_calc
        f = self.assertTupleEqual
        f(c(aop.OR, 0xffff0000, 0xa0a0a0a0), (0xffffa0a0, False, False, False))

    def test_ADD(self):    
        c = pyspim.alu_calc
        f = self.assertTupleEqual
        # postive add
        f(c(aop.ADD, 0x1, 0x1), (2, False, False, False)) 
        # zero flag
        f(c(aop.ADD, 0xffffffff, 0x1), (0, True, False, False))
        # negtive add
        f(c(aop.ADD, 0xffffffff, 0xffffffff), (-2, False, False, False))
        # upward overflow 
        f(c(aop.ADD, 0x7fffffff, 1)[1:4], (False, False, True))
        # downward overflow
        f(c(aop.ADD, 0x80000000, 0xffffffff)[1:4], (False, False, True))

    def test_SUB(self):
        c = pyspim.alu_calc
        f = self.assertTupleEqual
        # sub
        f(c(aop.SUB, 10, 10), (0, True, False, False))
        f(c(aop.SUB, 0xffffffff, 0xffffffff), (0, True, False, False))
        # upward overflow
        f(c(aop.SUB, 0x7fffffff, 0xffffffff)[1:4], (False, False, True))
        # downward overflow
        f(c(aop.SUB, 0x80000000, 1)[1:4], (False, False, True))

    def test_SLT(self):
        c = pyspim.alu_calc
        f = self.assertTupleEqual
        f(c(aop.SLT, 0xffffffff, 0x00000001), (1, False, False, False))
        f(c(aop.SLT, 0x0fffffff, 0x00000001), (0, True, False, False))

    def test_XOR(self):
        c = pyspim.alu_calc
        f = self.assertTupleEqual
        f(c(aop.XOR, 0xffff0000, 0xa0a0a0a0), (0x5f5fa0a0, False, False, False))

    def test_SLL(self):
        c = pyspim.alu_calc
        f = self.assertTupleEqual
        f(c(aop.SLL, 0x00000001, 0x2), (0x00000004, False, False, False))

    def test_SRL(self):
        c = pyspim.alu_calc
        f = self.assertTupleEqual
        f(c(aop.SRL, 0xf0000000, 0x4), (0x0f000000, False, False, False))

    def test_SRA(self):
        c = pyspim.alu_calc
        f = self.assertTupleEqual
        f(c(aop.SRA, 0xf0000000, 0x4), (0xff000000, False, False, False))

    def test_NOR(self):
        c = pyspim.alu_calc
        f = self.assertTupleEqual
        f(c(aop.NOR, 0xffff0000, 0xa0a0a0a0), (0x00005f5f, False, False, False))

    def test_ADDU(self):
        c = pyspim.alu_calc
        f = self.assertTupleEqual
        f(c(aop.ADDU, 0x3fffffff, 0x70000000), 
            (0xafffffff, False, False, False))
        f(c(aop.ADDU, 0x3fffffff, 0xf0000000)[1:4], (False, True, False))

    def test_SUBU(self):
        c = pyspim.alu_calc
        f = self.assertTupleEqual
        f(c(aop.SUBU, 0x3fffffff, 0x0fffffff), 
            (0x30000000, False, False, False))
        f(c(aop.SUBU, 0x3fffffff, 0x70000000)[1:4], (False, True, False))

    def test_SLTU(self):
        c = pyspim.alu_calc
        f = self.assertTupleEqual
        f(c(aop.SLTU, 0x8fffffff, 0x70000000), (0, True, False, False))
        f(c(aop.SLTU, 0x3fffffff, 0x80000000), (1, False, False, False))

if __name__ == '__main__':
    unittest.main()