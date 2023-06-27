import re
import sys
import os

matches = """
  16cec8:       f453c8e3                blt     t2,t0,16ce18 <github.com/ethereum/go-ethereum/crypto/btcec.(*KoblitzCurve).ScalarBaseMult+0xb8>
  16cecc:       f2dff06f                j       16cdf8 <github.com/ethereum/go-ethereum/crypto/btcec.(*KoblitzCurve).ScalarBaseMult+0x98>
  16ced0:       000a8293                mv      t0,s5
  16ced4:       d24050ef                jal     723f8 <runtime.panicIndex>
  16ced8:       00000013                nop
  16cedc:       0000                    unimp
        ...

000000000016cee0 <github.com/ethereum/go-ethereum/crypto/btcec.initAll>:
  16cee0:       010db303                ld      t1,16(s11)
  16cee4:       00236663                bltu    t1,sp,16cef0 <github.com/ethereum/go-ethereum/crypto/btcec.initAll+0x10>
  16cee8:       950032ef                jal     t0,70038 <runtime.morestack_noctxt.abi0>

"""

m2 = """
[2023-06-23T04:18:48Z DEBUG risc0_zkvm::exec] pc: 0x00011fe4, insn: 0x05013603 => ld x12, 80(x2)
"""
mapping = {}
with open(sys.argv[1], 'r') as trace_file:
    with open(sys.argv[2], 'r') as assembly_file:
        with open(sys.argv[3], 'wb+') as output:
            for assm_line in assembly_file.readlines():
                matchea = re.findall(r'^(000(\w+) (\<.*\>))', assm_line)
                if len(matchea) > 0 and len(matchea[0]) > 0:
                    mapping[int(matchea[0][1], 16)] = matchea[0][2]
            for trace_line in trace_file.readlines():
                matchea = re.findall(r'pc\: (\w+), insn',trace_line)
                if len(matchea) > 0:
                    if mapping.get(int(matchea[0], 16)) is not None:
                        output.write(((trace_line + ' ' + mapping.get(int(matchea[0], 16))).replace('\n', '') + '\n').encode())
                        continue
                output.write(trace_line.encode())

