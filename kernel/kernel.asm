
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	b8010113          	addi	sp,sp,-1152 # 80007b80 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	02a000ef          	jal	ra,80000040 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000002e:	306027f3          	csrr	a5,mcounteren
  
  // enable the sstc extension (i.e. stimecmp).
//  w_menvcfg(r_menvcfg() | (1L << 63)); 
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000032:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000036:	30679073          	csrw	mcounteren,a5
  
  // ask for the very first timer interrupt.
 // w_stimecmp(r_time() + 1000000);
}
    8000003a:	6422                	ld	s0,8(sp)
    8000003c:	0141                	addi	sp,sp,16
    8000003e:	8082                	ret

0000000080000040 <start>:
{
    80000040:	1141                	addi	sp,sp,-16
    80000042:	e406                	sd	ra,8(sp)
    80000044:	e022                	sd	s0,0(sp)
    80000046:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000048:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000004c:	7779                	lui	a4,0xffffe
    8000004e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd94f>
    80000052:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000054:	6705                	lui	a4,0x1
    80000056:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000005a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000005c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000060:	00001797          	auipc	a5,0x1
    80000064:	dbc78793          	addi	a5,a5,-580 # 80000e1c <main>
    80000068:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000006c:	4781                	li	a5,0
    8000006e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000072:	67c1                	lui	a5,0x10
    80000074:	17fd                	addi	a5,a5,-1
    80000076:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000007a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000007e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80000082:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80000086:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000008a:	57fd                	li	a5,-1
    8000008c:	83a9                	srli	a5,a5,0xa
    8000008e:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80000092:	47bd                	li	a5,15
    80000094:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80000098:	f85ff0ef          	jal	ra,8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000009c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000a0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000a2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000a4:	30200073          	mret
}
    800000a8:	60a2                	ld	ra,8(sp)
    800000aa:	6402                	ld	s0,0(sp)
    800000ac:	0141                	addi	sp,sp,16
    800000ae:	8082                	ret

00000000800000b0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000b0:	715d                	addi	sp,sp,-80
    800000b2:	e486                	sd	ra,72(sp)
    800000b4:	e0a2                	sd	s0,64(sp)
    800000b6:	fc26                	sd	s1,56(sp)
    800000b8:	f84a                	sd	s2,48(sp)
    800000ba:	f44e                	sd	s3,40(sp)
    800000bc:	f052                	sd	s4,32(sp)
    800000be:	ec56                	sd	s5,24(sp)
    800000c0:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000c2:	04c05263          	blez	a2,80000106 <consolewrite+0x56>
    800000c6:	8a2a                	mv	s4,a0
    800000c8:	84ae                	mv	s1,a1
    800000ca:	89b2                	mv	s3,a2
    800000cc:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ce:	5afd                	li	s5,-1
    800000d0:	4685                	li	a3,1
    800000d2:	8626                	mv	a2,s1
    800000d4:	85d2                	mv	a1,s4
    800000d6:	fbf40513          	addi	a0,s0,-65
    800000da:	1dc020ef          	jal	ra,800022b6 <either_copyin>
    800000de:	01550a63          	beq	a0,s5,800000f2 <consolewrite+0x42>
      break;
    uartputc(c);
    800000e2:	fbf44503          	lbu	a0,-65(s0)
    800000e6:	7da000ef          	jal	ra,800008c0 <uartputc>
  for(i = 0; i < n; i++){
    800000ea:	2905                	addiw	s2,s2,1
    800000ec:	0485                	addi	s1,s1,1
    800000ee:	ff2991e3          	bne	s3,s2,800000d0 <consolewrite+0x20>
  }

  return i;
}
    800000f2:	854a                	mv	a0,s2
    800000f4:	60a6                	ld	ra,72(sp)
    800000f6:	6406                	ld	s0,64(sp)
    800000f8:	74e2                	ld	s1,56(sp)
    800000fa:	7942                	ld	s2,48(sp)
    800000fc:	79a2                	ld	s3,40(sp)
    800000fe:	7a02                	ld	s4,32(sp)
    80000100:	6ae2                	ld	s5,24(sp)
    80000102:	6161                	addi	sp,sp,80
    80000104:	8082                	ret
  for(i = 0; i < n; i++){
    80000106:	4901                	li	s2,0
    80000108:	b7ed                	j	800000f2 <consolewrite+0x42>

000000008000010a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000010a:	7159                	addi	sp,sp,-112
    8000010c:	f486                	sd	ra,104(sp)
    8000010e:	f0a2                	sd	s0,96(sp)
    80000110:	eca6                	sd	s1,88(sp)
    80000112:	e8ca                	sd	s2,80(sp)
    80000114:	e4ce                	sd	s3,72(sp)
    80000116:	e0d2                	sd	s4,64(sp)
    80000118:	fc56                	sd	s5,56(sp)
    8000011a:	f85a                	sd	s6,48(sp)
    8000011c:	f45e                	sd	s7,40(sp)
    8000011e:	f062                	sd	s8,32(sp)
    80000120:	ec66                	sd	s9,24(sp)
    80000122:	e86a                	sd	s10,16(sp)
    80000124:	1880                	addi	s0,sp,112
    80000126:	8aaa                	mv	s5,a0
    80000128:	8a2e                	mv	s4,a1
    8000012a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000012c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000130:	00010517          	auipc	a0,0x10
    80000134:	a5050513          	addi	a0,a0,-1456 # 8000fb80 <cons>
    80000138:	26f000ef          	jal	ra,80000ba6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000013c:	00010497          	auipc	s1,0x10
    80000140:	a4448493          	addi	s1,s1,-1468 # 8000fb80 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000144:	00010917          	auipc	s2,0x10
    80000148:	ad490913          	addi	s2,s2,-1324 # 8000fc18 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    8000014c:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000014e:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80000150:	4ca9                	li	s9,10
  while(n > 0){
    80000152:	07305363          	blez	s3,800001b8 <consoleread+0xae>
    while(cons.r == cons.w){
    80000156:	0984a783          	lw	a5,152(s1)
    8000015a:	09c4a703          	lw	a4,156(s1)
    8000015e:	02f71163          	bne	a4,a5,80000180 <consoleread+0x76>
      if(killed(myproc())){
    80000162:	7e2010ef          	jal	ra,80001944 <myproc>
    80000166:	7e3010ef          	jal	ra,80002148 <killed>
    8000016a:	e125                	bnez	a0,800001ca <consoleread+0xc0>
      sleep(&cons.r, &cons.lock);
    8000016c:	85a6                	mv	a1,s1
    8000016e:	854a                	mv	a0,s2
    80000170:	5a1010ef          	jal	ra,80001f10 <sleep>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	fef703e3          	beq	a4,a5,80000162 <consoleread+0x58>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80000180:	0017871b          	addiw	a4,a5,1
    80000184:	08e4ac23          	sw	a4,152(s1)
    80000188:	07f7f713          	andi	a4,a5,127
    8000018c:	9726                	add	a4,a4,s1
    8000018e:	01874703          	lbu	a4,24(a4)
    80000192:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000196:	057d0f63          	beq	s10,s7,800001f4 <consoleread+0xea>
    cbuf = c;
    8000019a:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000019e:	4685                	li	a3,1
    800001a0:	f9f40613          	addi	a2,s0,-97
    800001a4:	85d2                	mv	a1,s4
    800001a6:	8556                	mv	a0,s5
    800001a8:	0c4020ef          	jal	ra,8000226c <either_copyout>
    800001ac:	01850663          	beq	a0,s8,800001b8 <consoleread+0xae>
    dst++;
    800001b0:	0a05                	addi	s4,s4,1
    --n;
    800001b2:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    800001b4:	f99d1fe3          	bne	s10,s9,80000152 <consoleread+0x48>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800001b8:	00010517          	auipc	a0,0x10
    800001bc:	9c850513          	addi	a0,a0,-1592 # 8000fb80 <cons>
    800001c0:	27f000ef          	jal	ra,80000c3e <release>

  return target - n;
    800001c4:	413b053b          	subw	a0,s6,s3
    800001c8:	a801                	j	800001d8 <consoleread+0xce>
        release(&cons.lock);
    800001ca:	00010517          	auipc	a0,0x10
    800001ce:	9b650513          	addi	a0,a0,-1610 # 8000fb80 <cons>
    800001d2:	26d000ef          	jal	ra,80000c3e <release>
        return -1;
    800001d6:	557d                	li	a0,-1
}
    800001d8:	70a6                	ld	ra,104(sp)
    800001da:	7406                	ld	s0,96(sp)
    800001dc:	64e6                	ld	s1,88(sp)
    800001de:	6946                	ld	s2,80(sp)
    800001e0:	69a6                	ld	s3,72(sp)
    800001e2:	6a06                	ld	s4,64(sp)
    800001e4:	7ae2                	ld	s5,56(sp)
    800001e6:	7b42                	ld	s6,48(sp)
    800001e8:	7ba2                	ld	s7,40(sp)
    800001ea:	7c02                	ld	s8,32(sp)
    800001ec:	6ce2                	ld	s9,24(sp)
    800001ee:	6d42                	ld	s10,16(sp)
    800001f0:	6165                	addi	sp,sp,112
    800001f2:	8082                	ret
      if(n < target){
    800001f4:	0009871b          	sext.w	a4,s3
    800001f8:	fd6770e3          	bgeu	a4,s6,800001b8 <consoleread+0xae>
        cons.r--;
    800001fc:	00010717          	auipc	a4,0x10
    80000200:	a0f72e23          	sw	a5,-1508(a4) # 8000fc18 <cons+0x98>
    80000204:	bf55                	j	800001b8 <consoleread+0xae>

0000000080000206 <consputc>:
{
    80000206:	1141                	addi	sp,sp,-16
    80000208:	e406                	sd	ra,8(sp)
    8000020a:	e022                	sd	s0,0(sp)
    8000020c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000020e:	10000793          	li	a5,256
    80000212:	00f50863          	beq	a0,a5,80000222 <consputc+0x1c>
    uartputc_sync(c);
    80000216:	5d4000ef          	jal	ra,800007ea <uartputc_sync>
}
    8000021a:	60a2                	ld	ra,8(sp)
    8000021c:	6402                	ld	s0,0(sp)
    8000021e:	0141                	addi	sp,sp,16
    80000220:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000222:	4521                	li	a0,8
    80000224:	5c6000ef          	jal	ra,800007ea <uartputc_sync>
    80000228:	02000513          	li	a0,32
    8000022c:	5be000ef          	jal	ra,800007ea <uartputc_sync>
    80000230:	4521                	li	a0,8
    80000232:	5b8000ef          	jal	ra,800007ea <uartputc_sync>
    80000236:	b7d5                	j	8000021a <consputc+0x14>

0000000080000238 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000238:	1101                	addi	sp,sp,-32
    8000023a:	ec06                	sd	ra,24(sp)
    8000023c:	e822                	sd	s0,16(sp)
    8000023e:	e426                	sd	s1,8(sp)
    80000240:	e04a                	sd	s2,0(sp)
    80000242:	1000                	addi	s0,sp,32
    80000244:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80000246:	00010517          	auipc	a0,0x10
    8000024a:	93a50513          	addi	a0,a0,-1734 # 8000fb80 <cons>
    8000024e:	159000ef          	jal	ra,80000ba6 <acquire>

  switch(c){
    80000252:	47d5                	li	a5,21
    80000254:	0af48063          	beq	s1,a5,800002f4 <consoleintr+0xbc>
    80000258:	0297c663          	blt	a5,s1,80000284 <consoleintr+0x4c>
    8000025c:	47a1                	li	a5,8
    8000025e:	0cf48f63          	beq	s1,a5,8000033c <consoleintr+0x104>
    80000262:	47c1                	li	a5,16
    80000264:	10f49063          	bne	s1,a5,80000364 <consoleintr+0x12c>
  case C('P'):  // Print process list.
    procdump();
    80000268:	098020ef          	jal	ra,80002300 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000026c:	00010517          	auipc	a0,0x10
    80000270:	91450513          	addi	a0,a0,-1772 # 8000fb80 <cons>
    80000274:	1cb000ef          	jal	ra,80000c3e <release>
}
    80000278:	60e2                	ld	ra,24(sp)
    8000027a:	6442                	ld	s0,16(sp)
    8000027c:	64a2                	ld	s1,8(sp)
    8000027e:	6902                	ld	s2,0(sp)
    80000280:	6105                	addi	sp,sp,32
    80000282:	8082                	ret
  switch(c){
    80000284:	07f00793          	li	a5,127
    80000288:	0af48a63          	beq	s1,a5,8000033c <consoleintr+0x104>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000028c:	00010717          	auipc	a4,0x10
    80000290:	8f470713          	addi	a4,a4,-1804 # 8000fb80 <cons>
    80000294:	0a072783          	lw	a5,160(a4)
    80000298:	09872703          	lw	a4,152(a4)
    8000029c:	9f99                	subw	a5,a5,a4
    8000029e:	07f00713          	li	a4,127
    800002a2:	fcf765e3          	bltu	a4,a5,8000026c <consoleintr+0x34>
      c = (c == '\r') ? '\n' : c;
    800002a6:	47b5                	li	a5,13
    800002a8:	0cf48163          	beq	s1,a5,8000036a <consoleintr+0x132>
      consputc(c);
    800002ac:	8526                	mv	a0,s1
    800002ae:	f59ff0ef          	jal	ra,80000206 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002b2:	00010797          	auipc	a5,0x10
    800002b6:	8ce78793          	addi	a5,a5,-1842 # 8000fb80 <cons>
    800002ba:	0a07a683          	lw	a3,160(a5)
    800002be:	0016871b          	addiw	a4,a3,1
    800002c2:	0007061b          	sext.w	a2,a4
    800002c6:	0ae7a023          	sw	a4,160(a5)
    800002ca:	07f6f693          	andi	a3,a3,127
    800002ce:	97b6                	add	a5,a5,a3
    800002d0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800002d4:	47a9                	li	a5,10
    800002d6:	0af48f63          	beq	s1,a5,80000394 <consoleintr+0x15c>
    800002da:	4791                	li	a5,4
    800002dc:	0af48c63          	beq	s1,a5,80000394 <consoleintr+0x15c>
    800002e0:	00010797          	auipc	a5,0x10
    800002e4:	9387a783          	lw	a5,-1736(a5) # 8000fc18 <cons+0x98>
    800002e8:	9f1d                	subw	a4,a4,a5
    800002ea:	08000793          	li	a5,128
    800002ee:	f6f71fe3          	bne	a4,a5,8000026c <consoleintr+0x34>
    800002f2:	a04d                	j	80000394 <consoleintr+0x15c>
    while(cons.e != cons.w &&
    800002f4:	00010717          	auipc	a4,0x10
    800002f8:	88c70713          	addi	a4,a4,-1908 # 8000fb80 <cons>
    800002fc:	0a072783          	lw	a5,160(a4)
    80000300:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000304:	00010497          	auipc	s1,0x10
    80000308:	87c48493          	addi	s1,s1,-1924 # 8000fb80 <cons>
    while(cons.e != cons.w &&
    8000030c:	4929                	li	s2,10
    8000030e:	f4f70fe3          	beq	a4,a5,8000026c <consoleintr+0x34>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000312:	37fd                	addiw	a5,a5,-1
    80000314:	07f7f713          	andi	a4,a5,127
    80000318:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000031a:	01874703          	lbu	a4,24(a4)
    8000031e:	f52707e3          	beq	a4,s2,8000026c <consoleintr+0x34>
      cons.e--;
    80000322:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000326:	10000513          	li	a0,256
    8000032a:	eddff0ef          	jal	ra,80000206 <consputc>
    while(cons.e != cons.w &&
    8000032e:	0a04a783          	lw	a5,160(s1)
    80000332:	09c4a703          	lw	a4,156(s1)
    80000336:	fcf71ee3          	bne	a4,a5,80000312 <consoleintr+0xda>
    8000033a:	bf0d                	j	8000026c <consoleintr+0x34>
    if(cons.e != cons.w){
    8000033c:	00010717          	auipc	a4,0x10
    80000340:	84470713          	addi	a4,a4,-1980 # 8000fb80 <cons>
    80000344:	0a072783          	lw	a5,160(a4)
    80000348:	09c72703          	lw	a4,156(a4)
    8000034c:	f2f700e3          	beq	a4,a5,8000026c <consoleintr+0x34>
      cons.e--;
    80000350:	37fd                	addiw	a5,a5,-1
    80000352:	00010717          	auipc	a4,0x10
    80000356:	8cf72723          	sw	a5,-1842(a4) # 8000fc20 <cons+0xa0>
      consputc(BACKSPACE);
    8000035a:	10000513          	li	a0,256
    8000035e:	ea9ff0ef          	jal	ra,80000206 <consputc>
    80000362:	b729                	j	8000026c <consoleintr+0x34>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000364:	f00484e3          	beqz	s1,8000026c <consoleintr+0x34>
    80000368:	b715                	j	8000028c <consoleintr+0x54>
      consputc(c);
    8000036a:	4529                	li	a0,10
    8000036c:	e9bff0ef          	jal	ra,80000206 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000370:	00010797          	auipc	a5,0x10
    80000374:	81078793          	addi	a5,a5,-2032 # 8000fb80 <cons>
    80000378:	0a07a703          	lw	a4,160(a5)
    8000037c:	0017069b          	addiw	a3,a4,1
    80000380:	0006861b          	sext.w	a2,a3
    80000384:	0ad7a023          	sw	a3,160(a5)
    80000388:	07f77713          	andi	a4,a4,127
    8000038c:	97ba                	add	a5,a5,a4
    8000038e:	4729                	li	a4,10
    80000390:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000394:	00010797          	auipc	a5,0x10
    80000398:	88c7a423          	sw	a2,-1912(a5) # 8000fc1c <cons+0x9c>
        wakeup(&cons.r);
    8000039c:	00010517          	auipc	a0,0x10
    800003a0:	87c50513          	addi	a0,a0,-1924 # 8000fc18 <cons+0x98>
    800003a4:	3b9010ef          	jal	ra,80001f5c <wakeup>
    800003a8:	b5d1                	j	8000026c <consoleintr+0x34>

00000000800003aa <consoleinit>:

void
consoleinit(void)
{
    800003aa:	1141                	addi	sp,sp,-16
    800003ac:	e406                	sd	ra,8(sp)
    800003ae:	e022                	sd	s0,0(sp)
    800003b0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800003b2:	00007597          	auipc	a1,0x7
    800003b6:	c5e58593          	addi	a1,a1,-930 # 80007010 <etext+0x10>
    800003ba:	0000f517          	auipc	a0,0xf
    800003be:	7c650513          	addi	a0,a0,1990 # 8000fb80 <cons>
    800003c2:	764000ef          	jal	ra,80000b26 <initlock>

  uartinit();
    800003c6:	3d8000ef          	jal	ra,8000079e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800003ca:	00020797          	auipc	a5,0x20
    800003ce:	94e78793          	addi	a5,a5,-1714 # 8001fd18 <devsw>
    800003d2:	00000717          	auipc	a4,0x0
    800003d6:	d3870713          	addi	a4,a4,-712 # 8000010a <consoleread>
    800003da:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800003dc:	00000717          	auipc	a4,0x0
    800003e0:	cd470713          	addi	a4,a4,-812 # 800000b0 <consolewrite>
    800003e4:	ef98                	sd	a4,24(a5)
}
    800003e6:	60a2                	ld	ra,8(sp)
    800003e8:	6402                	ld	s0,0(sp)
    800003ea:	0141                	addi	sp,sp,16
    800003ec:	8082                	ret

00000000800003ee <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800003ee:	7179                	addi	sp,sp,-48
    800003f0:	f406                	sd	ra,40(sp)
    800003f2:	f022                	sd	s0,32(sp)
    800003f4:	ec26                	sd	s1,24(sp)
    800003f6:	e84a                	sd	s2,16(sp)
    800003f8:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800003fa:	c219                	beqz	a2,80000400 <printint+0x12>
    800003fc:	06054f63          	bltz	a0,8000047a <printint+0x8c>
    x = -xx;
  else
    x = xx;
    80000400:	4881                	li	a7,0
    80000402:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000406:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000408:	00007617          	auipc	a2,0x7
    8000040c:	c3060613          	addi	a2,a2,-976 # 80007038 <digits>
    80000410:	883e                	mv	a6,a5
    80000412:	2785                	addiw	a5,a5,1
    80000414:	02b57733          	remu	a4,a0,a1
    80000418:	9732                	add	a4,a4,a2
    8000041a:	00074703          	lbu	a4,0(a4)
    8000041e:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000422:	872a                	mv	a4,a0
    80000424:	02b55533          	divu	a0,a0,a1
    80000428:	0685                	addi	a3,a3,1
    8000042a:	feb773e3          	bgeu	a4,a1,80000410 <printint+0x22>

  if(sign)
    8000042e:	00088b63          	beqz	a7,80000444 <printint+0x56>
    buf[i++] = '-';
    80000432:	fe040713          	addi	a4,s0,-32
    80000436:	97ba                	add	a5,a5,a4
    80000438:	02d00713          	li	a4,45
    8000043c:	fee78823          	sb	a4,-16(a5)
    80000440:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80000444:	02f05563          	blez	a5,8000046e <printint+0x80>
    80000448:	fd040713          	addi	a4,s0,-48
    8000044c:	00f704b3          	add	s1,a4,a5
    80000450:	fff70913          	addi	s2,a4,-1
    80000454:	993e                	add	s2,s2,a5
    80000456:	37fd                	addiw	a5,a5,-1
    80000458:	1782                	slli	a5,a5,0x20
    8000045a:	9381                	srli	a5,a5,0x20
    8000045c:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    80000460:	fff4c503          	lbu	a0,-1(s1)
    80000464:	da3ff0ef          	jal	ra,80000206 <consputc>
  while(--i >= 0)
    80000468:	14fd                	addi	s1,s1,-1
    8000046a:	ff249be3          	bne	s1,s2,80000460 <printint+0x72>
}
    8000046e:	70a2                	ld	ra,40(sp)
    80000470:	7402                	ld	s0,32(sp)
    80000472:	64e2                	ld	s1,24(sp)
    80000474:	6942                	ld	s2,16(sp)
    80000476:	6145                	addi	sp,sp,48
    80000478:	8082                	ret
    x = -xx;
    8000047a:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000047e:	4885                	li	a7,1
    x = -xx;
    80000480:	b749                	j	80000402 <printint+0x14>

0000000080000482 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80000482:	7155                	addi	sp,sp,-208
    80000484:	e506                	sd	ra,136(sp)
    80000486:	e122                	sd	s0,128(sp)
    80000488:	fca6                	sd	s1,120(sp)
    8000048a:	f8ca                	sd	s2,112(sp)
    8000048c:	f4ce                	sd	s3,104(sp)
    8000048e:	f0d2                	sd	s4,96(sp)
    80000490:	ecd6                	sd	s5,88(sp)
    80000492:	e8da                	sd	s6,80(sp)
    80000494:	e4de                	sd	s7,72(sp)
    80000496:	e0e2                	sd	s8,64(sp)
    80000498:	fc66                	sd	s9,56(sp)
    8000049a:	f86a                	sd	s10,48(sp)
    8000049c:	f46e                	sd	s11,40(sp)
    8000049e:	0900                	addi	s0,sp,144
    800004a0:	8a2a                	mv	s4,a0
    800004a2:	e40c                	sd	a1,8(s0)
    800004a4:	e810                	sd	a2,16(s0)
    800004a6:	ec14                	sd	a3,24(s0)
    800004a8:	f018                	sd	a4,32(s0)
    800004aa:	f41c                	sd	a5,40(s0)
    800004ac:	03043823          	sd	a6,48(s0)
    800004b0:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004b4:	0000f797          	auipc	a5,0xf
    800004b8:	78c7a783          	lw	a5,1932(a5) # 8000fc40 <pr+0x18>
    800004bc:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004c0:	eb9d                	bnez	a5,800004f6 <printf+0x74>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004c2:	00840793          	addi	a5,s0,8
    800004c6:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800004ca:	00054503          	lbu	a0,0(a0)
    800004ce:	24050463          	beqz	a0,80000716 <printf+0x294>
    800004d2:	4981                	li	s3,0
    if(cx != '%'){
    800004d4:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800004d8:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800004dc:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800004e0:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800004e4:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800004e8:	07000d93          	li	s11,112
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800004ec:	00007b97          	auipc	s7,0x7
    800004f0:	b4cb8b93          	addi	s7,s7,-1204 # 80007038 <digits>
    800004f4:	a081                	j	80000534 <printf+0xb2>
    acquire(&pr.lock);
    800004f6:	0000f517          	auipc	a0,0xf
    800004fa:	73250513          	addi	a0,a0,1842 # 8000fc28 <pr>
    800004fe:	6a8000ef          	jal	ra,80000ba6 <acquire>
  va_start(ap, fmt);
    80000502:	00840793          	addi	a5,s0,8
    80000506:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000050a:	000a4503          	lbu	a0,0(s4)
    8000050e:	f171                	bnez	a0,800004d2 <printf+0x50>
#endif
  }
  va_end(ap);

  if(locking)
    release(&pr.lock);
    80000510:	0000f517          	auipc	a0,0xf
    80000514:	71850513          	addi	a0,a0,1816 # 8000fc28 <pr>
    80000518:	726000ef          	jal	ra,80000c3e <release>
    8000051c:	aaed                	j	80000716 <printf+0x294>
      consputc(cx);
    8000051e:	ce9ff0ef          	jal	ra,80000206 <consputc>
      continue;
    80000522:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000524:	0014899b          	addiw	s3,s1,1
    80000528:	013a07b3          	add	a5,s4,s3
    8000052c:	0007c503          	lbu	a0,0(a5)
    80000530:	1c050f63          	beqz	a0,8000070e <printf+0x28c>
    if(cx != '%'){
    80000534:	ff5515e3          	bne	a0,s5,8000051e <printf+0x9c>
    i++;
    80000538:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    8000053c:	009a07b3          	add	a5,s4,s1
    80000540:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000544:	1c090563          	beqz	s2,8000070e <printf+0x28c>
    80000548:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    8000054c:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    8000054e:	c789                	beqz	a5,80000558 <printf+0xd6>
    80000550:	009a0733          	add	a4,s4,s1
    80000554:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000558:	03690463          	beq	s2,s6,80000580 <printf+0xfe>
    } else if(c0 == 'l' && c1 == 'd'){
    8000055c:	03890e63          	beq	s2,s8,80000598 <printf+0x116>
    } else if(c0 == 'u'){
    80000560:	0b990d63          	beq	s2,s9,8000061a <printf+0x198>
    } else if(c0 == 'x'){
    80000564:	11a90363          	beq	s2,s10,8000066a <printf+0x1e8>
    } else if(c0 == 'p'){
    80000568:	13b90b63          	beq	s2,s11,8000069e <printf+0x21c>
    } else if(c0 == 's'){
    8000056c:	07300793          	li	a5,115
    80000570:	16f90363          	beq	s2,a5,800006d6 <printf+0x254>
    } else if(c0 == '%'){
    80000574:	03591c63          	bne	s2,s5,800005ac <printf+0x12a>
      consputc('%');
    80000578:	8556                	mv	a0,s5
    8000057a:	c8dff0ef          	jal	ra,80000206 <consputc>
    8000057e:	b75d                	j	80000524 <printf+0xa2>
      printint(va_arg(ap, int), 10, 1);
    80000580:	f8843783          	ld	a5,-120(s0)
    80000584:	00878713          	addi	a4,a5,8
    80000588:	f8e43423          	sd	a4,-120(s0)
    8000058c:	4605                	li	a2,1
    8000058e:	45a9                	li	a1,10
    80000590:	4388                	lw	a0,0(a5)
    80000592:	e5dff0ef          	jal	ra,800003ee <printint>
    80000596:	b779                	j	80000524 <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'd'){
    80000598:	03678163          	beq	a5,s6,800005ba <printf+0x138>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000059c:	03878d63          	beq	a5,s8,800005d6 <printf+0x154>
    } else if(c0 == 'l' && c1 == 'u'){
    800005a0:	09978963          	beq	a5,s9,80000632 <printf+0x1b0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800005a4:	03878b63          	beq	a5,s8,800005da <printf+0x158>
    } else if(c0 == 'l' && c1 == 'x'){
    800005a8:	0da78d63          	beq	a5,s10,80000682 <printf+0x200>
      consputc('%');
    800005ac:	8556                	mv	a0,s5
    800005ae:	c59ff0ef          	jal	ra,80000206 <consputc>
      consputc(c0);
    800005b2:	854a                	mv	a0,s2
    800005b4:	c53ff0ef          	jal	ra,80000206 <consputc>
    800005b8:	b7b5                	j	80000524 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    800005ba:	f8843783          	ld	a5,-120(s0)
    800005be:	00878713          	addi	a4,a5,8
    800005c2:	f8e43423          	sd	a4,-120(s0)
    800005c6:	4605                	li	a2,1
    800005c8:	45a9                	li	a1,10
    800005ca:	6388                	ld	a0,0(a5)
    800005cc:	e23ff0ef          	jal	ra,800003ee <printint>
      i += 1;
    800005d0:	0029849b          	addiw	s1,s3,2
    800005d4:	bf81                	j	80000524 <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005d6:	03668463          	beq	a3,s6,800005fe <printf+0x17c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800005da:	07968a63          	beq	a3,s9,8000064e <printf+0x1cc>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800005de:	fda697e3          	bne	a3,s10,800005ac <printf+0x12a>
      printint(va_arg(ap, uint64), 16, 0);
    800005e2:	f8843783          	ld	a5,-120(s0)
    800005e6:	00878713          	addi	a4,a5,8
    800005ea:	f8e43423          	sd	a4,-120(s0)
    800005ee:	4601                	li	a2,0
    800005f0:	45c1                	li	a1,16
    800005f2:	6388                	ld	a0,0(a5)
    800005f4:	dfbff0ef          	jal	ra,800003ee <printint>
      i += 2;
    800005f8:	0039849b          	addiw	s1,s3,3
    800005fc:	b725                	j	80000524 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    800005fe:	f8843783          	ld	a5,-120(s0)
    80000602:	00878713          	addi	a4,a5,8
    80000606:	f8e43423          	sd	a4,-120(s0)
    8000060a:	4605                	li	a2,1
    8000060c:	45a9                	li	a1,10
    8000060e:	6388                	ld	a0,0(a5)
    80000610:	ddfff0ef          	jal	ra,800003ee <printint>
      i += 2;
    80000614:	0039849b          	addiw	s1,s3,3
    80000618:	b731                	j	80000524 <printf+0xa2>
      printint(va_arg(ap, int), 10, 0);
    8000061a:	f8843783          	ld	a5,-120(s0)
    8000061e:	00878713          	addi	a4,a5,8
    80000622:	f8e43423          	sd	a4,-120(s0)
    80000626:	4601                	li	a2,0
    80000628:	45a9                	li	a1,10
    8000062a:	4388                	lw	a0,0(a5)
    8000062c:	dc3ff0ef          	jal	ra,800003ee <printint>
    80000630:	bdd5                	j	80000524 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    80000632:	f8843783          	ld	a5,-120(s0)
    80000636:	00878713          	addi	a4,a5,8
    8000063a:	f8e43423          	sd	a4,-120(s0)
    8000063e:	4601                	li	a2,0
    80000640:	45a9                	li	a1,10
    80000642:	6388                	ld	a0,0(a5)
    80000644:	dabff0ef          	jal	ra,800003ee <printint>
      i += 1;
    80000648:	0029849b          	addiw	s1,s3,2
    8000064c:	bde1                	j	80000524 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    8000064e:	f8843783          	ld	a5,-120(s0)
    80000652:	00878713          	addi	a4,a5,8
    80000656:	f8e43423          	sd	a4,-120(s0)
    8000065a:	4601                	li	a2,0
    8000065c:	45a9                	li	a1,10
    8000065e:	6388                	ld	a0,0(a5)
    80000660:	d8fff0ef          	jal	ra,800003ee <printint>
      i += 2;
    80000664:	0039849b          	addiw	s1,s3,3
    80000668:	bd75                	j	80000524 <printf+0xa2>
      printint(va_arg(ap, int), 16, 0);
    8000066a:	f8843783          	ld	a5,-120(s0)
    8000066e:	00878713          	addi	a4,a5,8
    80000672:	f8e43423          	sd	a4,-120(s0)
    80000676:	4601                	li	a2,0
    80000678:	45c1                	li	a1,16
    8000067a:	4388                	lw	a0,0(a5)
    8000067c:	d73ff0ef          	jal	ra,800003ee <printint>
    80000680:	b555                	j	80000524 <printf+0xa2>
      printint(va_arg(ap, uint64), 16, 0);
    80000682:	f8843783          	ld	a5,-120(s0)
    80000686:	00878713          	addi	a4,a5,8
    8000068a:	f8e43423          	sd	a4,-120(s0)
    8000068e:	4601                	li	a2,0
    80000690:	45c1                	li	a1,16
    80000692:	6388                	ld	a0,0(a5)
    80000694:	d5bff0ef          	jal	ra,800003ee <printint>
      i += 1;
    80000698:	0029849b          	addiw	s1,s3,2
    8000069c:	b561                	j	80000524 <printf+0xa2>
      printptr(va_arg(ap, uint64));
    8000069e:	f8843783          	ld	a5,-120(s0)
    800006a2:	00878713          	addi	a4,a5,8
    800006a6:	f8e43423          	sd	a4,-120(s0)
    800006aa:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006ae:	03000513          	li	a0,48
    800006b2:	b55ff0ef          	jal	ra,80000206 <consputc>
  consputc('x');
    800006b6:	856a                	mv	a0,s10
    800006b8:	b4fff0ef          	jal	ra,80000206 <consputc>
    800006bc:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006be:	03c9d793          	srli	a5,s3,0x3c
    800006c2:	97de                	add	a5,a5,s7
    800006c4:	0007c503          	lbu	a0,0(a5)
    800006c8:	b3fff0ef          	jal	ra,80000206 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006cc:	0992                	slli	s3,s3,0x4
    800006ce:	397d                	addiw	s2,s2,-1
    800006d0:	fe0917e3          	bnez	s2,800006be <printf+0x23c>
    800006d4:	bd81                	j	80000524 <printf+0xa2>
      if((s = va_arg(ap, char*)) == 0)
    800006d6:	f8843783          	ld	a5,-120(s0)
    800006da:	00878713          	addi	a4,a5,8
    800006de:	f8e43423          	sd	a4,-120(s0)
    800006e2:	0007b903          	ld	s2,0(a5)
    800006e6:	00090d63          	beqz	s2,80000700 <printf+0x27e>
      for(; *s; s++)
    800006ea:	00094503          	lbu	a0,0(s2)
    800006ee:	e2050be3          	beqz	a0,80000524 <printf+0xa2>
        consputc(*s);
    800006f2:	b15ff0ef          	jal	ra,80000206 <consputc>
      for(; *s; s++)
    800006f6:	0905                	addi	s2,s2,1
    800006f8:	00094503          	lbu	a0,0(s2)
    800006fc:	f97d                	bnez	a0,800006f2 <printf+0x270>
    800006fe:	b51d                	j	80000524 <printf+0xa2>
        s = "(null)";
    80000700:	00007917          	auipc	s2,0x7
    80000704:	91890913          	addi	s2,s2,-1768 # 80007018 <etext+0x18>
      for(; *s; s++)
    80000708:	02800513          	li	a0,40
    8000070c:	b7dd                	j	800006f2 <printf+0x270>
  if(locking)
    8000070e:	f7843783          	ld	a5,-136(s0)
    80000712:	de079fe3          	bnez	a5,80000510 <printf+0x8e>

  return 0;
}
    80000716:	4501                	li	a0,0
    80000718:	60aa                	ld	ra,136(sp)
    8000071a:	640a                	ld	s0,128(sp)
    8000071c:	74e6                	ld	s1,120(sp)
    8000071e:	7946                	ld	s2,112(sp)
    80000720:	79a6                	ld	s3,104(sp)
    80000722:	7a06                	ld	s4,96(sp)
    80000724:	6ae6                	ld	s5,88(sp)
    80000726:	6b46                	ld	s6,80(sp)
    80000728:	6ba6                	ld	s7,72(sp)
    8000072a:	6c06                	ld	s8,64(sp)
    8000072c:	7ce2                	ld	s9,56(sp)
    8000072e:	7d42                	ld	s10,48(sp)
    80000730:	7da2                	ld	s11,40(sp)
    80000732:	6169                	addi	sp,sp,208
    80000734:	8082                	ret

0000000080000736 <panic>:

void
panic(char *s)
{
    80000736:	1101                	addi	sp,sp,-32
    80000738:	ec06                	sd	ra,24(sp)
    8000073a:	e822                	sd	s0,16(sp)
    8000073c:	e426                	sd	s1,8(sp)
    8000073e:	1000                	addi	s0,sp,32
    80000740:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000742:	0000f797          	auipc	a5,0xf
    80000746:	4e07af23          	sw	zero,1278(a5) # 8000fc40 <pr+0x18>
  printf("panic: ");
    8000074a:	00007517          	auipc	a0,0x7
    8000074e:	8d650513          	addi	a0,a0,-1834 # 80007020 <etext+0x20>
    80000752:	d31ff0ef          	jal	ra,80000482 <printf>
  printf("%s\n", s);
    80000756:	85a6                	mv	a1,s1
    80000758:	00007517          	auipc	a0,0x7
    8000075c:	8d050513          	addi	a0,a0,-1840 # 80007028 <etext+0x28>
    80000760:	d23ff0ef          	jal	ra,80000482 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000764:	4785                	li	a5,1
    80000766:	00007717          	auipc	a4,0x7
    8000076a:	3cf72d23          	sw	a5,986(a4) # 80007b40 <panicked>
  for(;;)
    8000076e:	a001                	j	8000076e <panic+0x38>

0000000080000770 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000770:	1101                	addi	sp,sp,-32
    80000772:	ec06                	sd	ra,24(sp)
    80000774:	e822                	sd	s0,16(sp)
    80000776:	e426                	sd	s1,8(sp)
    80000778:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000077a:	0000f497          	auipc	s1,0xf
    8000077e:	4ae48493          	addi	s1,s1,1198 # 8000fc28 <pr>
    80000782:	00007597          	auipc	a1,0x7
    80000786:	8ae58593          	addi	a1,a1,-1874 # 80007030 <etext+0x30>
    8000078a:	8526                	mv	a0,s1
    8000078c:	39a000ef          	jal	ra,80000b26 <initlock>
  pr.locking = 1;
    80000790:	4785                	li	a5,1
    80000792:	cc9c                	sw	a5,24(s1)
}
    80000794:	60e2                	ld	ra,24(sp)
    80000796:	6442                	ld	s0,16(sp)
    80000798:	64a2                	ld	s1,8(sp)
    8000079a:	6105                	addi	sp,sp,32
    8000079c:	8082                	ret

000000008000079e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000079e:	1141                	addi	sp,sp,-16
    800007a0:	e406                	sd	ra,8(sp)
    800007a2:	e022                	sd	s0,0(sp)
    800007a4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a6:	100007b7          	lui	a5,0x10000
    800007aa:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ae:	f8000713          	li	a4,-128
    800007b2:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b6:	470d                	li	a4,3
    800007b8:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007bc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007c0:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c4:	469d                	li	a3,7
    800007c6:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007ca:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007ce:	00007597          	auipc	a1,0x7
    800007d2:	88258593          	addi	a1,a1,-1918 # 80007050 <digits+0x18>
    800007d6:	0000f517          	auipc	a0,0xf
    800007da:	47250513          	addi	a0,a0,1138 # 8000fc48 <uart_tx_lock>
    800007de:	348000ef          	jal	ra,80000b26 <initlock>
}
    800007e2:	60a2                	ld	ra,8(sp)
    800007e4:	6402                	ld	s0,0(sp)
    800007e6:	0141                	addi	sp,sp,16
    800007e8:	8082                	ret

00000000800007ea <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007ea:	1101                	addi	sp,sp,-32
    800007ec:	ec06                	sd	ra,24(sp)
    800007ee:	e822                	sd	s0,16(sp)
    800007f0:	e426                	sd	s1,8(sp)
    800007f2:	1000                	addi	s0,sp,32
    800007f4:	84aa                	mv	s1,a0
  push_off();
    800007f6:	370000ef          	jal	ra,80000b66 <push_off>

  if(panicked){
    800007fa:	00007797          	auipc	a5,0x7
    800007fe:	3467a783          	lw	a5,838(a5) # 80007b40 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000802:	10000737          	lui	a4,0x10000
  if(panicked){
    80000806:	c391                	beqz	a5,8000080a <uartputc_sync+0x20>
    for(;;)
    80000808:	a001                	j	80000808 <uartputc_sync+0x1e>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000080e:	0207f793          	andi	a5,a5,32
    80000812:	dfe5                	beqz	a5,8000080a <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    80000814:	0ff4f513          	andi	a0,s1,255
    80000818:	100007b7          	lui	a5,0x10000
    8000081c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000820:	3ca000ef          	jal	ra,80000bea <pop_off>
}
    80000824:	60e2                	ld	ra,24(sp)
    80000826:	6442                	ld	s0,16(sp)
    80000828:	64a2                	ld	s1,8(sp)
    8000082a:	6105                	addi	sp,sp,32
    8000082c:	8082                	ret

000000008000082e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000082e:	00007797          	auipc	a5,0x7
    80000832:	31a7b783          	ld	a5,794(a5) # 80007b48 <uart_tx_r>
    80000836:	00007717          	auipc	a4,0x7
    8000083a:	31a73703          	ld	a4,794(a4) # 80007b50 <uart_tx_w>
    8000083e:	06f70c63          	beq	a4,a5,800008b6 <uartstart+0x88>
{
    80000842:	7139                	addi	sp,sp,-64
    80000844:	fc06                	sd	ra,56(sp)
    80000846:	f822                	sd	s0,48(sp)
    80000848:	f426                	sd	s1,40(sp)
    8000084a:	f04a                	sd	s2,32(sp)
    8000084c:	ec4e                	sd	s3,24(sp)
    8000084e:	e852                	sd	s4,16(sp)
    80000850:	e456                	sd	s5,8(sp)
    80000852:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000854:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000858:	0000fa17          	auipc	s4,0xf
    8000085c:	3f0a0a13          	addi	s4,s4,1008 # 8000fc48 <uart_tx_lock>
    uart_tx_r += 1;
    80000860:	00007497          	auipc	s1,0x7
    80000864:	2e848493          	addi	s1,s1,744 # 80007b48 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000868:	00007997          	auipc	s3,0x7
    8000086c:	2e898993          	addi	s3,s3,744 # 80007b50 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000870:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000874:	02077713          	andi	a4,a4,32
    80000878:	c715                	beqz	a4,800008a4 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000087a:	01f7f713          	andi	a4,a5,31
    8000087e:	9752                	add	a4,a4,s4
    80000880:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80000884:	0785                	addi	a5,a5,1
    80000886:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000888:	8526                	mv	a0,s1
    8000088a:	6d2010ef          	jal	ra,80001f5c <wakeup>
    
    WriteReg(THR, c);
    8000088e:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80000892:	609c                	ld	a5,0(s1)
    80000894:	0009b703          	ld	a4,0(s3)
    80000898:	fcf71ce3          	bne	a4,a5,80000870 <uartstart+0x42>
      ReadReg(ISR);
    8000089c:	100007b7          	lui	a5,0x10000
    800008a0:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    800008a4:	70e2                	ld	ra,56(sp)
    800008a6:	7442                	ld	s0,48(sp)
    800008a8:	74a2                	ld	s1,40(sp)
    800008aa:	7902                	ld	s2,32(sp)
    800008ac:	69e2                	ld	s3,24(sp)
    800008ae:	6a42                	ld	s4,16(sp)
    800008b0:	6aa2                	ld	s5,8(sp)
    800008b2:	6121                	addi	sp,sp,64
    800008b4:	8082                	ret
      ReadReg(ISR);
    800008b6:	100007b7          	lui	a5,0x10000
    800008ba:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    800008be:	8082                	ret

00000000800008c0 <uartputc>:
{
    800008c0:	7179                	addi	sp,sp,-48
    800008c2:	f406                	sd	ra,40(sp)
    800008c4:	f022                	sd	s0,32(sp)
    800008c6:	ec26                	sd	s1,24(sp)
    800008c8:	e84a                	sd	s2,16(sp)
    800008ca:	e44e                	sd	s3,8(sp)
    800008cc:	e052                	sd	s4,0(sp)
    800008ce:	1800                	addi	s0,sp,48
    800008d0:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008d2:	0000f517          	auipc	a0,0xf
    800008d6:	37650513          	addi	a0,a0,886 # 8000fc48 <uart_tx_lock>
    800008da:	2cc000ef          	jal	ra,80000ba6 <acquire>
  if(panicked){
    800008de:	00007797          	auipc	a5,0x7
    800008e2:	2627a783          	lw	a5,610(a5) # 80007b40 <panicked>
    800008e6:	efbd                	bnez	a5,80000964 <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008e8:	00007717          	auipc	a4,0x7
    800008ec:	26873703          	ld	a4,616(a4) # 80007b50 <uart_tx_w>
    800008f0:	00007797          	auipc	a5,0x7
    800008f4:	2587b783          	ld	a5,600(a5) # 80007b48 <uart_tx_r>
    800008f8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fc:	0000f997          	auipc	s3,0xf
    80000900:	34c98993          	addi	s3,s3,844 # 8000fc48 <uart_tx_lock>
    80000904:	00007497          	auipc	s1,0x7
    80000908:	24448493          	addi	s1,s1,580 # 80007b48 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090c:	00007917          	auipc	s2,0x7
    80000910:	24490913          	addi	s2,s2,580 # 80007b50 <uart_tx_w>
    80000914:	00e79d63          	bne	a5,a4,8000092e <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000918:	85ce                	mv	a1,s3
    8000091a:	8526                	mv	a0,s1
    8000091c:	5f4010ef          	jal	ra,80001f10 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000920:	00093703          	ld	a4,0(s2)
    80000924:	609c                	ld	a5,0(s1)
    80000926:	02078793          	addi	a5,a5,32
    8000092a:	fee787e3          	beq	a5,a4,80000918 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000092e:	0000f497          	auipc	s1,0xf
    80000932:	31a48493          	addi	s1,s1,794 # 8000fc48 <uart_tx_lock>
    80000936:	01f77793          	andi	a5,a4,31
    8000093a:	97a6                	add	a5,a5,s1
    8000093c:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000940:	0705                	addi	a4,a4,1
    80000942:	00007797          	auipc	a5,0x7
    80000946:	20e7b723          	sd	a4,526(a5) # 80007b50 <uart_tx_w>
  uartstart();
    8000094a:	ee5ff0ef          	jal	ra,8000082e <uartstart>
  release(&uart_tx_lock);
    8000094e:	8526                	mv	a0,s1
    80000950:	2ee000ef          	jal	ra,80000c3e <release>
}
    80000954:	70a2                	ld	ra,40(sp)
    80000956:	7402                	ld	s0,32(sp)
    80000958:	64e2                	ld	s1,24(sp)
    8000095a:	6942                	ld	s2,16(sp)
    8000095c:	69a2                	ld	s3,8(sp)
    8000095e:	6a02                	ld	s4,0(sp)
    80000960:	6145                	addi	sp,sp,48
    80000962:	8082                	ret
    for(;;)
    80000964:	a001                	j	80000964 <uartputc+0xa4>

0000000080000966 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000966:	1141                	addi	sp,sp,-16
    80000968:	e422                	sd	s0,8(sp)
    8000096a:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000096c:	100007b7          	lui	a5,0x10000
    80000970:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000974:	8b85                	andi	a5,a5,1
    80000976:	cb91                	beqz	a5,8000098a <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000978:	100007b7          	lui	a5,0x10000
    8000097c:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000980:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80000984:	6422                	ld	s0,8(sp)
    80000986:	0141                	addi	sp,sp,16
    80000988:	8082                	ret
    return -1;
    8000098a:	557d                	li	a0,-1
    8000098c:	bfe5                	j	80000984 <uartgetc+0x1e>

000000008000098e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000098e:	1101                	addi	sp,sp,-32
    80000990:	ec06                	sd	ra,24(sp)
    80000992:	e822                	sd	s0,16(sp)
    80000994:	e426                	sd	s1,8(sp)
    80000996:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000998:	54fd                	li	s1,-1
    8000099a:	a019                	j	800009a0 <uartintr+0x12>
      break;
    consoleintr(c);
    8000099c:	89dff0ef          	jal	ra,80000238 <consoleintr>
    int c = uartgetc();
    800009a0:	fc7ff0ef          	jal	ra,80000966 <uartgetc>
    if(c == -1)
    800009a4:	fe951ce3          	bne	a0,s1,8000099c <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009a8:	0000f497          	auipc	s1,0xf
    800009ac:	2a048493          	addi	s1,s1,672 # 8000fc48 <uart_tx_lock>
    800009b0:	8526                	mv	a0,s1
    800009b2:	1f4000ef          	jal	ra,80000ba6 <acquire>
  uartstart();
    800009b6:	e79ff0ef          	jal	ra,8000082e <uartstart>
  release(&uart_tx_lock);
    800009ba:	8526                	mv	a0,s1
    800009bc:	282000ef          	jal	ra,80000c3e <release>
}
    800009c0:	60e2                	ld	ra,24(sp)
    800009c2:	6442                	ld	s0,16(sp)
    800009c4:	64a2                	ld	s1,8(sp)
    800009c6:	6105                	addi	sp,sp,32
    800009c8:	8082                	ret

00000000800009ca <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009ca:	1101                	addi	sp,sp,-32
    800009cc:	ec06                	sd	ra,24(sp)
    800009ce:	e822                	sd	s0,16(sp)
    800009d0:	e426                	sd	s1,8(sp)
    800009d2:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009d4:	03451793          	slli	a5,a0,0x34
    800009d8:	ef85                	bnez	a5,80000a10 <kfree+0x46>
    800009da:	84aa                	mv	s1,a0
    800009dc:	00020797          	auipc	a5,0x20
    800009e0:	4d478793          	addi	a5,a5,1236 # 80020eb0 <end>
    800009e4:	02f56663          	bltu	a0,a5,80000a10 <kfree+0x46>
    800009e8:	47c5                	li	a5,17
    800009ea:	07ee                	slli	a5,a5,0x1b
    800009ec:	02f57263          	bgeu	a0,a5,80000a10 <kfree+0x46>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800009f0:	6605                	lui	a2,0x1
    800009f2:	4585                	li	a1,1
    800009f4:	286000ef          	jal	ra,80000c7a <memset>

  r = (struct run*)pa;

//  acquire(&kmem.lock);
  r->next = kmem.freelist;
    800009f8:	0000f797          	auipc	a5,0xf
    800009fc:	28878793          	addi	a5,a5,648 # 8000fc80 <kmem>
    80000a00:	6f98                	ld	a4,24(a5)
    80000a02:	e098                	sd	a4,0(s1)
  kmem.freelist = r;
    80000a04:	ef84                	sd	s1,24(a5)
//  release(&kmem.lock);
}
    80000a06:	60e2                	ld	ra,24(sp)
    80000a08:	6442                	ld	s0,16(sp)
    80000a0a:	64a2                	ld	s1,8(sp)
    80000a0c:	6105                	addi	sp,sp,32
    80000a0e:	8082                	ret
    panic("kfree");
    80000a10:	00006517          	auipc	a0,0x6
    80000a14:	64850513          	addi	a0,a0,1608 # 80007058 <digits+0x20>
    80000a18:	d1fff0ef          	jal	ra,80000736 <panic>

0000000080000a1c <freerange>:
{
    80000a1c:	7179                	addi	sp,sp,-48
    80000a1e:	f406                	sd	ra,40(sp)
    80000a20:	f022                	sd	s0,32(sp)
    80000a22:	ec26                	sd	s1,24(sp)
    80000a24:	e84a                	sd	s2,16(sp)
    80000a26:	e44e                	sd	s3,8(sp)
    80000a28:	e052                	sd	s4,0(sp)
    80000a2a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a2c:	6785                	lui	a5,0x1
    80000a2e:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a32:	94aa                	add	s1,s1,a0
    80000a34:	757d                	lui	a0,0xfffff
    80000a36:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a38:	94be                	add	s1,s1,a5
    80000a3a:	0095ec63          	bltu	a1,s1,80000a52 <freerange+0x36>
    80000a3e:	892e                	mv	s2,a1
    kfree(p);
    80000a40:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a42:	6985                	lui	s3,0x1
    kfree(p);
    80000a44:	01448533          	add	a0,s1,s4
    80000a48:	f83ff0ef          	jal	ra,800009ca <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a4c:	94ce                	add	s1,s1,s3
    80000a4e:	fe997be3          	bgeu	s2,s1,80000a44 <freerange+0x28>
}
    80000a52:	70a2                	ld	ra,40(sp)
    80000a54:	7402                	ld	s0,32(sp)
    80000a56:	64e2                	ld	s1,24(sp)
    80000a58:	6942                	ld	s2,16(sp)
    80000a5a:	69a2                	ld	s3,8(sp)
    80000a5c:	6a02                	ld	s4,0(sp)
    80000a5e:	6145                	addi	sp,sp,48
    80000a60:	8082                	ret

0000000080000a62 <kinit>:
{
    80000a62:	1141                	addi	sp,sp,-16
    80000a64:	e406                	sd	ra,8(sp)
    80000a66:	e022                	sd	s0,0(sp)
    80000a68:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000a6a:	00006597          	auipc	a1,0x6
    80000a6e:	5f658593          	addi	a1,a1,1526 # 80007060 <digits+0x28>
    80000a72:	0000f517          	auipc	a0,0xf
    80000a76:	20e50513          	addi	a0,a0,526 # 8000fc80 <kmem>
    80000a7a:	0ac000ef          	jal	ra,80000b26 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000a7e:	45c5                	li	a1,17
    80000a80:	05ee                	slli	a1,a1,0x1b
    80000a82:	00020517          	auipc	a0,0x20
    80000a86:	42e50513          	addi	a0,a0,1070 # 80020eb0 <end>
    80000a8a:	f93ff0ef          	jal	ra,80000a1c <freerange>
}
    80000a8e:	60a2                	ld	ra,8(sp)
    80000a90:	6402                	ld	s0,0(sp)
    80000a92:	0141                	addi	sp,sp,16
    80000a94:	8082                	ret

0000000080000a96 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000a96:	1101                	addi	sp,sp,-32
    80000a98:	ec06                	sd	ra,24(sp)
    80000a9a:	e822                	sd	s0,16(sp)
    80000a9c:	e426                	sd	s1,8(sp)
    80000a9e:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000aa0:	0000f497          	auipc	s1,0xf
    80000aa4:	1e048493          	addi	s1,s1,480 # 8000fc80 <kmem>
    80000aa8:	8526                	mv	a0,s1
    80000aaa:	0fc000ef          	jal	ra,80000ba6 <acquire>
  r = kmem.freelist;
    80000aae:	6c84                	ld	s1,24(s1)
  if(r)
    80000ab0:	c485                	beqz	s1,80000ad8 <kalloc+0x42>
    kmem.freelist = r->next;
    80000ab2:	609c                	ld	a5,0(s1)
    80000ab4:	0000f517          	auipc	a0,0xf
    80000ab8:	1cc50513          	addi	a0,a0,460 # 8000fc80 <kmem>
    80000abc:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000abe:	180000ef          	jal	ra,80000c3e <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000ac2:	6605                	lui	a2,0x1
    80000ac4:	4595                	li	a1,5
    80000ac6:	8526                	mv	a0,s1
    80000ac8:	1b2000ef          	jal	ra,80000c7a <memset>
  return (void*)r;
}
    80000acc:	8526                	mv	a0,s1
    80000ace:	60e2                	ld	ra,24(sp)
    80000ad0:	6442                	ld	s0,16(sp)
    80000ad2:	64a2                	ld	s1,8(sp)
    80000ad4:	6105                	addi	sp,sp,32
    80000ad6:	8082                	ret
  release(&kmem.lock);
    80000ad8:	0000f517          	auipc	a0,0xf
    80000adc:	1a850513          	addi	a0,a0,424 # 8000fc80 <kmem>
    80000ae0:	15e000ef          	jal	ra,80000c3e <release>
  if(r)
    80000ae4:	b7e5                	j	80000acc <kalloc+0x36>

0000000080000ae6 <countpages>:

// this 
int
countpages()
{
    80000ae6:	1101                	addi	sp,sp,-32
    80000ae8:	ec06                	sd	ra,24(sp)
    80000aea:	e822                	sd	s0,16(sp)
    80000aec:	e426                	sd	s1,8(sp)
    80000aee:	1000                	addi	s0,sp,32
    int count = 0;

    struct run *r;
// the free list structure has pointers to the avaliable free memory pages
    acquire(&kmem.lock);
    80000af0:	0000f497          	auipc	s1,0xf
    80000af4:	19048493          	addi	s1,s1,400 # 8000fc80 <kmem>
    80000af8:	8526                	mv	a0,s1
    80000afa:	0ac000ef          	jal	ra,80000ba6 <acquire>
    r = kmem.freelist;
    80000afe:	6c9c                	ld	a5,24(s1)

    //iterate over linked list until it ends
    while (r != 0) {
    80000b00:	c38d                	beqz	a5,80000b22 <countpages+0x3c>
    int count = 0;
    80000b02:	4481                	li	s1,0
        count += 1;
    80000b04:	2485                	addiw	s1,s1,1
        r = r->next;
    80000b06:	639c                	ld	a5,0(a5)
    while (r != 0) {
    80000b08:	fff5                	bnez	a5,80000b04 <countpages+0x1e>
    }

    release(&kmem.lock);
    80000b0a:	0000f517          	auipc	a0,0xf
    80000b0e:	17650513          	addi	a0,a0,374 # 8000fc80 <kmem>
    80000b12:	12c000ef          	jal	ra,80000c3e <release>

    return count;
}
    80000b16:	8526                	mv	a0,s1
    80000b18:	60e2                	ld	ra,24(sp)
    80000b1a:	6442                	ld	s0,16(sp)
    80000b1c:	64a2                	ld	s1,8(sp)
    80000b1e:	6105                	addi	sp,sp,32
    80000b20:	8082                	ret
    int count = 0;
    80000b22:	4481                	li	s1,0
    80000b24:	b7dd                	j	80000b0a <countpages+0x24>

0000000080000b26 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b26:	1141                	addi	sp,sp,-16
    80000b28:	e422                	sd	s0,8(sp)
    80000b2a:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b2c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b2e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b32:	00053823          	sd	zero,16(a0)
}
    80000b36:	6422                	ld	s0,8(sp)
    80000b38:	0141                	addi	sp,sp,16
    80000b3a:	8082                	ret

0000000080000b3c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b3c:	411c                	lw	a5,0(a0)
    80000b3e:	e399                	bnez	a5,80000b44 <holding+0x8>
    80000b40:	4501                	li	a0,0
  return r;
}
    80000b42:	8082                	ret
{
    80000b44:	1101                	addi	sp,sp,-32
    80000b46:	ec06                	sd	ra,24(sp)
    80000b48:	e822                	sd	s0,16(sp)
    80000b4a:	e426                	sd	s1,8(sp)
    80000b4c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b4e:	6904                	ld	s1,16(a0)
    80000b50:	5d9000ef          	jal	ra,80001928 <mycpu>
    80000b54:	40a48533          	sub	a0,s1,a0
    80000b58:	00153513          	seqz	a0,a0
}
    80000b5c:	60e2                	ld	ra,24(sp)
    80000b5e:	6442                	ld	s0,16(sp)
    80000b60:	64a2                	ld	s1,8(sp)
    80000b62:	6105                	addi	sp,sp,32
    80000b64:	8082                	ret

0000000080000b66 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b66:	1101                	addi	sp,sp,-32
    80000b68:	ec06                	sd	ra,24(sp)
    80000b6a:	e822                	sd	s0,16(sp)
    80000b6c:	e426                	sd	s1,8(sp)
    80000b6e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b70:	100024f3          	csrr	s1,sstatus
    80000b74:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b78:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b7a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b7e:	5ab000ef          	jal	ra,80001928 <mycpu>
    80000b82:	5d3c                	lw	a5,120(a0)
    80000b84:	cb99                	beqz	a5,80000b9a <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b86:	5a3000ef          	jal	ra,80001928 <mycpu>
    80000b8a:	5d3c                	lw	a5,120(a0)
    80000b8c:	2785                	addiw	a5,a5,1
    80000b8e:	dd3c                	sw	a5,120(a0)
}
    80000b90:	60e2                	ld	ra,24(sp)
    80000b92:	6442                	ld	s0,16(sp)
    80000b94:	64a2                	ld	s1,8(sp)
    80000b96:	6105                	addi	sp,sp,32
    80000b98:	8082                	ret
    mycpu()->intena = old;
    80000b9a:	58f000ef          	jal	ra,80001928 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000b9e:	8085                	srli	s1,s1,0x1
    80000ba0:	8885                	andi	s1,s1,1
    80000ba2:	dd64                	sw	s1,124(a0)
    80000ba4:	b7cd                	j	80000b86 <push_off+0x20>

0000000080000ba6 <acquire>:
{
    80000ba6:	1101                	addi	sp,sp,-32
    80000ba8:	ec06                	sd	ra,24(sp)
    80000baa:	e822                	sd	s0,16(sp)
    80000bac:	e426                	sd	s1,8(sp)
    80000bae:	1000                	addi	s0,sp,32
    80000bb0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bb2:	fb5ff0ef          	jal	ra,80000b66 <push_off>
  if(holding(lk))
    80000bb6:	8526                	mv	a0,s1
    80000bb8:	f85ff0ef          	jal	ra,80000b3c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bbc:	4705                	li	a4,1
  if(holding(lk))
    80000bbe:	e105                	bnez	a0,80000bde <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bc0:	87ba                	mv	a5,a4
    80000bc2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bc6:	2781                	sext.w	a5,a5
    80000bc8:	ffe5                	bnez	a5,80000bc0 <acquire+0x1a>
  __sync_synchronize();
    80000bca:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000bce:	55b000ef          	jal	ra,80001928 <mycpu>
    80000bd2:	e888                	sd	a0,16(s1)
}
    80000bd4:	60e2                	ld	ra,24(sp)
    80000bd6:	6442                	ld	s0,16(sp)
    80000bd8:	64a2                	ld	s1,8(sp)
    80000bda:	6105                	addi	sp,sp,32
    80000bdc:	8082                	ret
    panic("acquire");
    80000bde:	00006517          	auipc	a0,0x6
    80000be2:	48a50513          	addi	a0,a0,1162 # 80007068 <digits+0x30>
    80000be6:	b51ff0ef          	jal	ra,80000736 <panic>

0000000080000bea <pop_off>:

void
pop_off(void)
{
    80000bea:	1141                	addi	sp,sp,-16
    80000bec:	e406                	sd	ra,8(sp)
    80000bee:	e022                	sd	s0,0(sp)
    80000bf0:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000bf2:	537000ef          	jal	ra,80001928 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bf6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000bfa:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000bfc:	e78d                	bnez	a5,80000c26 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000bfe:	5d3c                	lw	a5,120(a0)
    80000c00:	02f05963          	blez	a5,80000c32 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c04:	37fd                	addiw	a5,a5,-1
    80000c06:	0007871b          	sext.w	a4,a5
    80000c0a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c0c:	eb09                	bnez	a4,80000c1e <pop_off+0x34>
    80000c0e:	5d7c                	lw	a5,124(a0)
    80000c10:	c799                	beqz	a5,80000c1e <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c12:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c16:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c1a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c1e:	60a2                	ld	ra,8(sp)
    80000c20:	6402                	ld	s0,0(sp)
    80000c22:	0141                	addi	sp,sp,16
    80000c24:	8082                	ret
    panic("pop_off - interruptible");
    80000c26:	00006517          	auipc	a0,0x6
    80000c2a:	44a50513          	addi	a0,a0,1098 # 80007070 <digits+0x38>
    80000c2e:	b09ff0ef          	jal	ra,80000736 <panic>
    panic("pop_off");
    80000c32:	00006517          	auipc	a0,0x6
    80000c36:	45650513          	addi	a0,a0,1110 # 80007088 <digits+0x50>
    80000c3a:	afdff0ef          	jal	ra,80000736 <panic>

0000000080000c3e <release>:
{
    80000c3e:	1101                	addi	sp,sp,-32
    80000c40:	ec06                	sd	ra,24(sp)
    80000c42:	e822                	sd	s0,16(sp)
    80000c44:	e426                	sd	s1,8(sp)
    80000c46:	1000                	addi	s0,sp,32
    80000c48:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c4a:	ef3ff0ef          	jal	ra,80000b3c <holding>
    80000c4e:	c105                	beqz	a0,80000c6e <release+0x30>
  lk->cpu = 0;
    80000c50:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c54:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000c58:	0f50000f          	fence	iorw,ow
    80000c5c:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000c60:	f8bff0ef          	jal	ra,80000bea <pop_off>
}
    80000c64:	60e2                	ld	ra,24(sp)
    80000c66:	6442                	ld	s0,16(sp)
    80000c68:	64a2                	ld	s1,8(sp)
    80000c6a:	6105                	addi	sp,sp,32
    80000c6c:	8082                	ret
    panic("release");
    80000c6e:	00006517          	auipc	a0,0x6
    80000c72:	42250513          	addi	a0,a0,1058 # 80007090 <digits+0x58>
    80000c76:	ac1ff0ef          	jal	ra,80000736 <panic>

0000000080000c7a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000c7a:	1141                	addi	sp,sp,-16
    80000c7c:	e422                	sd	s0,8(sp)
    80000c7e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000c80:	ca19                	beqz	a2,80000c96 <memset+0x1c>
    80000c82:	87aa                	mv	a5,a0
    80000c84:	1602                	slli	a2,a2,0x20
    80000c86:	9201                	srli	a2,a2,0x20
    80000c88:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000c8c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000c90:	0785                	addi	a5,a5,1
    80000c92:	fee79de3          	bne	a5,a4,80000c8c <memset+0x12>
  }
  return dst;
}
    80000c96:	6422                	ld	s0,8(sp)
    80000c98:	0141                	addi	sp,sp,16
    80000c9a:	8082                	ret

0000000080000c9c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000c9c:	1141                	addi	sp,sp,-16
    80000c9e:	e422                	sd	s0,8(sp)
    80000ca0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000ca2:	ca05                	beqz	a2,80000cd2 <memcmp+0x36>
    80000ca4:	fff6069b          	addiw	a3,a2,-1
    80000ca8:	1682                	slli	a3,a3,0x20
    80000caa:	9281                	srli	a3,a3,0x20
    80000cac:	0685                	addi	a3,a3,1
    80000cae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cb0:	00054783          	lbu	a5,0(a0)
    80000cb4:	0005c703          	lbu	a4,0(a1)
    80000cb8:	00e79863          	bne	a5,a4,80000cc8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000cbc:	0505                	addi	a0,a0,1
    80000cbe:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000cc0:	fed518e3          	bne	a0,a3,80000cb0 <memcmp+0x14>
  }

  return 0;
    80000cc4:	4501                	li	a0,0
    80000cc6:	a019                	j	80000ccc <memcmp+0x30>
      return *s1 - *s2;
    80000cc8:	40e7853b          	subw	a0,a5,a4
}
    80000ccc:	6422                	ld	s0,8(sp)
    80000cce:	0141                	addi	sp,sp,16
    80000cd0:	8082                	ret
  return 0;
    80000cd2:	4501                	li	a0,0
    80000cd4:	bfe5                	j	80000ccc <memcmp+0x30>

0000000080000cd6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000cd6:	1141                	addi	sp,sp,-16
    80000cd8:	e422                	sd	s0,8(sp)
    80000cda:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000cdc:	c205                	beqz	a2,80000cfc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000cde:	02a5e263          	bltu	a1,a0,80000d02 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000ce2:	1602                	slli	a2,a2,0x20
    80000ce4:	9201                	srli	a2,a2,0x20
    80000ce6:	00c587b3          	add	a5,a1,a2
{
    80000cea:	872a                	mv	a4,a0
      *d++ = *s++;
    80000cec:	0585                	addi	a1,a1,1
    80000cee:	0705                	addi	a4,a4,1
    80000cf0:	fff5c683          	lbu	a3,-1(a1)
    80000cf4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000cf8:	fef59ae3          	bne	a1,a5,80000cec <memmove+0x16>

  return dst;
}
    80000cfc:	6422                	ld	s0,8(sp)
    80000cfe:	0141                	addi	sp,sp,16
    80000d00:	8082                	ret
  if(s < d && s + n > d){
    80000d02:	02061693          	slli	a3,a2,0x20
    80000d06:	9281                	srli	a3,a3,0x20
    80000d08:	00d58733          	add	a4,a1,a3
    80000d0c:	fce57be3          	bgeu	a0,a4,80000ce2 <memmove+0xc>
    d += n;
    80000d10:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d12:	fff6079b          	addiw	a5,a2,-1
    80000d16:	1782                	slli	a5,a5,0x20
    80000d18:	9381                	srli	a5,a5,0x20
    80000d1a:	fff7c793          	not	a5,a5
    80000d1e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d20:	177d                	addi	a4,a4,-1
    80000d22:	16fd                	addi	a3,a3,-1
    80000d24:	00074603          	lbu	a2,0(a4)
    80000d28:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d2c:	fee79ae3          	bne	a5,a4,80000d20 <memmove+0x4a>
    80000d30:	b7f1                	j	80000cfc <memmove+0x26>

0000000080000d32 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d32:	1141                	addi	sp,sp,-16
    80000d34:	e406                	sd	ra,8(sp)
    80000d36:	e022                	sd	s0,0(sp)
    80000d38:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d3a:	f9dff0ef          	jal	ra,80000cd6 <memmove>
}
    80000d3e:	60a2                	ld	ra,8(sp)
    80000d40:	6402                	ld	s0,0(sp)
    80000d42:	0141                	addi	sp,sp,16
    80000d44:	8082                	ret

0000000080000d46 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d46:	1141                	addi	sp,sp,-16
    80000d48:	e422                	sd	s0,8(sp)
    80000d4a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d4c:	ce11                	beqz	a2,80000d68 <strncmp+0x22>
    80000d4e:	00054783          	lbu	a5,0(a0)
    80000d52:	cf89                	beqz	a5,80000d6c <strncmp+0x26>
    80000d54:	0005c703          	lbu	a4,0(a1)
    80000d58:	00f71a63          	bne	a4,a5,80000d6c <strncmp+0x26>
    n--, p++, q++;
    80000d5c:	367d                	addiw	a2,a2,-1
    80000d5e:	0505                	addi	a0,a0,1
    80000d60:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000d62:	f675                	bnez	a2,80000d4e <strncmp+0x8>
  if(n == 0)
    return 0;
    80000d64:	4501                	li	a0,0
    80000d66:	a809                	j	80000d78 <strncmp+0x32>
    80000d68:	4501                	li	a0,0
    80000d6a:	a039                	j	80000d78 <strncmp+0x32>
  if(n == 0)
    80000d6c:	ca09                	beqz	a2,80000d7e <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000d6e:	00054503          	lbu	a0,0(a0)
    80000d72:	0005c783          	lbu	a5,0(a1)
    80000d76:	9d1d                	subw	a0,a0,a5
}
    80000d78:	6422                	ld	s0,8(sp)
    80000d7a:	0141                	addi	sp,sp,16
    80000d7c:	8082                	ret
    return 0;
    80000d7e:	4501                	li	a0,0
    80000d80:	bfe5                	j	80000d78 <strncmp+0x32>

0000000080000d82 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000d82:	1141                	addi	sp,sp,-16
    80000d84:	e422                	sd	s0,8(sp)
    80000d86:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000d88:	872a                	mv	a4,a0
    80000d8a:	8832                	mv	a6,a2
    80000d8c:	367d                	addiw	a2,a2,-1
    80000d8e:	01005963          	blez	a6,80000da0 <strncpy+0x1e>
    80000d92:	0705                	addi	a4,a4,1
    80000d94:	0005c783          	lbu	a5,0(a1)
    80000d98:	fef70fa3          	sb	a5,-1(a4)
    80000d9c:	0585                	addi	a1,a1,1
    80000d9e:	f7f5                	bnez	a5,80000d8a <strncpy+0x8>
    ;
  while(n-- > 0)
    80000da0:	86ba                	mv	a3,a4
    80000da2:	00c05c63          	blez	a2,80000dba <strncpy+0x38>
    *s++ = 0;
    80000da6:	0685                	addi	a3,a3,1
    80000da8:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000dac:	fff6c793          	not	a5,a3
    80000db0:	9fb9                	addw	a5,a5,a4
    80000db2:	010787bb          	addw	a5,a5,a6
    80000db6:	fef048e3          	bgtz	a5,80000da6 <strncpy+0x24>
  return os;
}
    80000dba:	6422                	ld	s0,8(sp)
    80000dbc:	0141                	addi	sp,sp,16
    80000dbe:	8082                	ret

0000000080000dc0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000dc0:	1141                	addi	sp,sp,-16
    80000dc2:	e422                	sd	s0,8(sp)
    80000dc4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000dc6:	02c05363          	blez	a2,80000dec <safestrcpy+0x2c>
    80000dca:	fff6069b          	addiw	a3,a2,-1
    80000dce:	1682                	slli	a3,a3,0x20
    80000dd0:	9281                	srli	a3,a3,0x20
    80000dd2:	96ae                	add	a3,a3,a1
    80000dd4:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000dd6:	00d58963          	beq	a1,a3,80000de8 <safestrcpy+0x28>
    80000dda:	0585                	addi	a1,a1,1
    80000ddc:	0785                	addi	a5,a5,1
    80000dde:	fff5c703          	lbu	a4,-1(a1)
    80000de2:	fee78fa3          	sb	a4,-1(a5)
    80000de6:	fb65                	bnez	a4,80000dd6 <safestrcpy+0x16>
    ;
  *s = 0;
    80000de8:	00078023          	sb	zero,0(a5)
  return os;
}
    80000dec:	6422                	ld	s0,8(sp)
    80000dee:	0141                	addi	sp,sp,16
    80000df0:	8082                	ret

0000000080000df2 <strlen>:

int
strlen(const char *s)
{
    80000df2:	1141                	addi	sp,sp,-16
    80000df4:	e422                	sd	s0,8(sp)
    80000df6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000df8:	00054783          	lbu	a5,0(a0)
    80000dfc:	cf91                	beqz	a5,80000e18 <strlen+0x26>
    80000dfe:	0505                	addi	a0,a0,1
    80000e00:	87aa                	mv	a5,a0
    80000e02:	4685                	li	a3,1
    80000e04:	9e89                	subw	a3,a3,a0
    80000e06:	00f6853b          	addw	a0,a3,a5
    80000e0a:	0785                	addi	a5,a5,1
    80000e0c:	fff7c703          	lbu	a4,-1(a5)
    80000e10:	fb7d                	bnez	a4,80000e06 <strlen+0x14>
    ;
  return n;
}
    80000e12:	6422                	ld	s0,8(sp)
    80000e14:	0141                	addi	sp,sp,16
    80000e16:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e18:	4501                	li	a0,0
    80000e1a:	bfe5                	j	80000e12 <strlen+0x20>

0000000080000e1c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e1c:	7169                	addi	sp,sp,-304
    80000e1e:	f606                	sd	ra,296(sp)
    80000e20:	f222                	sd	s0,288(sp)
    80000e22:	ee26                	sd	s1,280(sp)
    80000e24:	ea4a                	sd	s2,272(sp)
    80000e26:	e64e                	sd	s3,264(sp)
    80000e28:	e252                	sd	s4,256(sp)
    80000e2a:	1a00                	addi	s0,sp,304

  if(cpuid() == 0){
    80000e2c:	2ed000ef          	jal	ra,80001918 <cpuid>
    __sync_synchronize();
    started = 1;
   
    
  } else {
    while(started == 0)
    80000e30:	00007717          	auipc	a4,0x7
    80000e34:	d2870713          	addi	a4,a4,-728 # 80007b58 <started>
  if(cpuid() == 0){
    80000e38:	c51d                	beqz	a0,80000e66 <main+0x4a>
    while(started == 0)
    80000e3a:	431c                	lw	a5,0(a4)
    80000e3c:	2781                	sext.w	a5,a5
    80000e3e:	dff5                	beqz	a5,80000e3a <main+0x1e>
      ;
    __sync_synchronize();
    80000e40:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e44:	2d5000ef          	jal	ra,80001918 <cpuid>
    80000e48:	85aa                	mv	a1,a0
    80000e4a:	00006517          	auipc	a0,0x6
    80000e4e:	34e50513          	addi	a0,a0,846 # 80007198 <digits+0x160>
    80000e52:	e30ff0ef          	jal	ra,80000482 <printf>
    kvminithart();    // turn on paging
    80000e56:	184000ef          	jal	ra,80000fda <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e5a:	68a010ef          	jal	ra,800024e4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e5e:	506040ef          	jal	ra,80005364 <plicinithart>


  }
  scheduler(); 
    80000e62:	715000ef          	jal	ra,80001d76 <scheduler>
    consoleinit();
    80000e66:	d44ff0ef          	jal	ra,800003aa <consoleinit>
    printfinit();
    80000e6a:	907ff0ef          	jal	ra,80000770 <printfinit>
    printf("\n");
    80000e6e:	00006517          	auipc	a0,0x6
    80000e72:	29250513          	addi	a0,a0,658 # 80007100 <digits+0xc8>
    80000e76:	e0cff0ef          	jal	ra,80000482 <printf>
    printf("xv6 kernel is booting\n");       
    80000e7a:	00006517          	auipc	a0,0x6
    80000e7e:	21e50513          	addi	a0,a0,542 # 80007098 <digits+0x60>
    80000e82:	e00ff0ef          	jal	ra,80000482 <printf>
    kinit();         // physical page allocator
    80000e86:	bddff0ef          	jal	ra,80000a62 <kinit>
    kvminit();       // create kernel page table
    80000e8a:	3da000ef          	jal	ra,80001264 <kvminit>
    kvminithart();   // turn on paging
    80000e8e:	14c000ef          	jal	ra,80000fda <kvminithart>
    procinit();      // process table
    80000e92:	1df000ef          	jal	ra,80001870 <procinit>
    trapinit();      // trap vectors
    80000e96:	61c010ef          	jal	ra,800024b2 <trapinit>
    trapinithart();  // install kernel trap vector
    80000e9a:	64a010ef          	jal	ra,800024e4 <trapinithart>
    plicinit();      // set up interrupt controller
    80000e9e:	4b0040ef          	jal	ra,8000534e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000ea2:	4c2040ef          	jal	ra,80005364 <plicinithart>
    binit();         // buffer cache
    80000ea6:	543010ef          	jal	ra,80002be8 <binit>
    iinit();         // inode table
    80000eaa:	322020ef          	jal	ra,800031cc <iinit>
    fileinit();      // file table
    80000eae:	0bc030ef          	jal	ra,80003f6a <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000eb2:	5a2040ef          	jal	ra,80005454 <virtio_disk_init>
     char input[] = "testing_kernel_implementation"; 
    80000eb6:	00006797          	auipc	a5,0x6
    80000eba:	2fa78793          	addi	a5,a5,762 # 800071b0 <digits+0x178>
    80000ebe:	6390                	ld	a2,0(a5)
    80000ec0:	6794                	ld	a3,8(a5)
    80000ec2:	6b98                	ld	a4,16(a5)
    80000ec4:	ecc43c23          	sd	a2,-296(s0)
    80000ec8:	eed43023          	sd	a3,-288(s0)
    80000ecc:	eee43423          	sd	a4,-280(s0)
    80000ed0:	4f98                	lw	a4,24(a5)
    80000ed2:	eee42823          	sw	a4,-272(s0)
    80000ed6:	01c7d783          	lhu	a5,28(a5)
    80000eda:	eef41a23          	sh	a5,-268(s0)
  asm volatile("csrr %0, time" : "=r" (x) );
    80000ede:	c01024f3          	rdtime	s1
    sha256_init(&ctx);                            // Initialize SHA-256 context
    80000ee2:	f6040513          	addi	a0,s0,-160
    80000ee6:	3d7040ef          	jal	ra,80005abc <sha256_init>
    sha256_update(&ctx, (uint8*)input, strlen(input));  // Process the input string
    80000eea:	ed840513          	addi	a0,s0,-296
    80000eee:	f05ff0ef          	jal	ra,80000df2 <strlen>
    80000ef2:	0005061b          	sext.w	a2,a0
    80000ef6:	ed840593          	addi	a1,s0,-296
    80000efa:	f6040513          	addi	a0,s0,-160
    80000efe:	423040ef          	jal	ra,80005b20 <sha256_update>
    sha256_final(&ctx, hash);                     // Finalize the hash
    80000f02:	ef840593          	addi	a1,s0,-264
    80000f06:	f6040513          	addi	a0,s0,-160
    80000f0a:	48b040ef          	jal	ra,80005b94 <sha256_final>
    80000f0e:	c0102a73          	rdtime	s4
int final_time = end_time - start_time;
    80000f12:	409a0a3b          	subw	s4,s4,s1
    for (i = 0; i < 32; i++) {
    80000f16:	ef840913          	addi	s2,s0,-264
    80000f1a:	f1840493          	addi	s1,s0,-232
    80000f1e:	f5840993          	addi	s3,s0,-168
        byte_to_hex(hash[i], &hex_output[i * 2]);
    80000f22:	85a6                	mv	a1,s1
    80000f24:	00094503          	lbu	a0,0(s2)
    80000f28:	5e9040ef          	jal	ra,80005d10 <byte_to_hex>
    for (i = 0; i < 32; i++) {
    80000f2c:	0905                	addi	s2,s2,1
    80000f2e:	0489                	addi	s1,s1,2
    80000f30:	ff3499e3          	bne	s1,s3,80000f22 <main+0x106>
    hex_output[64] = '\0';  // Null-terminate the string
    80000f34:	f4040c23          	sb	zero,-168(s0)
    printf("\n");
    80000f38:	00006517          	auipc	a0,0x6
    80000f3c:	1c850513          	addi	a0,a0,456 # 80007100 <digits+0xc8>
    80000f40:	d42ff0ef          	jal	ra,80000482 <printf>
    printf("\n");
    80000f44:	00006517          	auipc	a0,0x6
    80000f48:	1bc50513          	addi	a0,a0,444 # 80007100 <digits+0xc8>
    80000f4c:	d36ff0ef          	jal	ra,80000482 <printf>
    printf("Input for Kernel Space =  %s\n", input);
    80000f50:	ed840593          	addi	a1,s0,-296
    80000f54:	00006517          	auipc	a0,0x6
    80000f58:	15c50513          	addi	a0,a0,348 # 800070b0 <digits+0x78>
    80000f5c:	d26ff0ef          	jal	ra,80000482 <printf>
    printf("SHA-256 hash = %s\n", hex_output);
    80000f60:	f1840593          	addi	a1,s0,-232
    80000f64:	00006517          	auipc	a0,0x6
    80000f68:	16c50513          	addi	a0,a0,364 # 800070d0 <digits+0x98>
    80000f6c:	d16ff0ef          	jal	ra,80000482 <printf>
    printf("\nComputed in Ticks =  %d\n", final_time);
    80000f70:	85d2                	mv	a1,s4
    80000f72:	00006517          	auipc	a0,0x6
    80000f76:	17650513          	addi	a0,a0,374 # 800070e8 <digits+0xb0>
    80000f7a:	d08ff0ef          	jal	ra,80000482 <printf>
    printf("\n");
    80000f7e:	00006517          	auipc	a0,0x6
    80000f82:	18250513          	addi	a0,a0,386 # 80007100 <digits+0xc8>
    80000f86:	cfcff0ef          	jal	ra,80000482 <printf>
    printf("\n");
    80000f8a:	00006517          	auipc	a0,0x6
    80000f8e:	17650513          	addi	a0,a0,374 # 80007100 <digits+0xc8>
    80000f92:	cf0ff0ef          	jal	ra,80000482 <printf>
   printf("-------Use sha256 sample.txt for user space implementation\n");
    80000f96:	00006517          	auipc	a0,0x6
    80000f9a:	17250513          	addi	a0,a0,370 # 80007108 <digits+0xd0>
    80000f9e:	ce4ff0ef          	jal	ra,80000482 <printf>
   printf("-------Use sha_syscall {string to be hashed} for system call implementation\n");
    80000fa2:	00006517          	auipc	a0,0x6
    80000fa6:	1a650513          	addi	a0,a0,422 # 80007148 <digits+0x110>
    80000faa:	cd8ff0ef          	jal	ra,80000482 <printf>
   printf("\n");
    80000fae:	00006517          	auipc	a0,0x6
    80000fb2:	15250513          	addi	a0,a0,338 # 80007100 <digits+0xc8>
    80000fb6:	cccff0ef          	jal	ra,80000482 <printf>
   printf("\n");
    80000fba:	00006517          	auipc	a0,0x6
    80000fbe:	14650513          	addi	a0,a0,326 # 80007100 <digits+0xc8>
    80000fc2:	cc0ff0ef          	jal	ra,80000482 <printf>
    userinit();      // first user process
    80000fc6:	3e7000ef          	jal	ra,80001bac <userinit>
    __sync_synchronize();
    80000fca:	0ff0000f          	fence
    started = 1;
    80000fce:	4785                	li	a5,1
    80000fd0:	00007717          	auipc	a4,0x7
    80000fd4:	b8f72423          	sw	a5,-1144(a4) # 80007b58 <started>
    80000fd8:	b569                	j	80000e62 <main+0x46>

0000000080000fda <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000fda:	1141                	addi	sp,sp,-16
    80000fdc:	e422                	sd	s0,8(sp)
    80000fde:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fe0:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000fe4:	00007797          	auipc	a5,0x7
    80000fe8:	b7c7b783          	ld	a5,-1156(a5) # 80007b60 <kernel_pagetable>
    80000fec:	83b1                	srli	a5,a5,0xc
    80000fee:	577d                	li	a4,-1
    80000ff0:	177e                	slli	a4,a4,0x3f
    80000ff2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000ff4:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000ff8:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000ffc:	6422                	ld	s0,8(sp)
    80000ffe:	0141                	addi	sp,sp,16
    80001000:	8082                	ret

0000000080001002 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001002:	7139                	addi	sp,sp,-64
    80001004:	fc06                	sd	ra,56(sp)
    80001006:	f822                	sd	s0,48(sp)
    80001008:	f426                	sd	s1,40(sp)
    8000100a:	f04a                	sd	s2,32(sp)
    8000100c:	ec4e                	sd	s3,24(sp)
    8000100e:	e852                	sd	s4,16(sp)
    80001010:	e456                	sd	s5,8(sp)
    80001012:	e05a                	sd	s6,0(sp)
    80001014:	0080                	addi	s0,sp,64
    80001016:	84aa                	mv	s1,a0
    80001018:	89ae                	mv	s3,a1
    8000101a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000101c:	57fd                	li	a5,-1
    8000101e:	83e9                	srli	a5,a5,0x1a
    80001020:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001022:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001024:	02b7fc63          	bgeu	a5,a1,8000105c <walk+0x5a>
    panic("walk");
    80001028:	00006517          	auipc	a0,0x6
    8000102c:	1a850513          	addi	a0,a0,424 # 800071d0 <digits+0x198>
    80001030:	f06ff0ef          	jal	ra,80000736 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001034:	060a8263          	beqz	s5,80001098 <walk+0x96>
    80001038:	a5fff0ef          	jal	ra,80000a96 <kalloc>
    8000103c:	84aa                	mv	s1,a0
    8000103e:	c139                	beqz	a0,80001084 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001040:	6605                	lui	a2,0x1
    80001042:	4581                	li	a1,0
    80001044:	c37ff0ef          	jal	ra,80000c7a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001048:	00c4d793          	srli	a5,s1,0xc
    8000104c:	07aa                	slli	a5,a5,0xa
    8000104e:	0017e793          	ori	a5,a5,1
    80001052:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001056:	3a5d                	addiw	s4,s4,-9
    80001058:	036a0063          	beq	s4,s6,80001078 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    8000105c:	0149d933          	srl	s2,s3,s4
    80001060:	1ff97913          	andi	s2,s2,511
    80001064:	090e                	slli	s2,s2,0x3
    80001066:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001068:	00093483          	ld	s1,0(s2)
    8000106c:	0014f793          	andi	a5,s1,1
    80001070:	d3f1                	beqz	a5,80001034 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001072:	80a9                	srli	s1,s1,0xa
    80001074:	04b2                	slli	s1,s1,0xc
    80001076:	b7c5                	j	80001056 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80001078:	00c9d513          	srli	a0,s3,0xc
    8000107c:	1ff57513          	andi	a0,a0,511
    80001080:	050e                	slli	a0,a0,0x3
    80001082:	9526                	add	a0,a0,s1
}
    80001084:	70e2                	ld	ra,56(sp)
    80001086:	7442                	ld	s0,48(sp)
    80001088:	74a2                	ld	s1,40(sp)
    8000108a:	7902                	ld	s2,32(sp)
    8000108c:	69e2                	ld	s3,24(sp)
    8000108e:	6a42                	ld	s4,16(sp)
    80001090:	6aa2                	ld	s5,8(sp)
    80001092:	6b02                	ld	s6,0(sp)
    80001094:	6121                	addi	sp,sp,64
    80001096:	8082                	ret
        return 0;
    80001098:	4501                	li	a0,0
    8000109a:	b7ed                	j	80001084 <walk+0x82>

000000008000109c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000109c:	57fd                	li	a5,-1
    8000109e:	83e9                	srli	a5,a5,0x1a
    800010a0:	00b7f463          	bgeu	a5,a1,800010a8 <walkaddr+0xc>
    return 0;
    800010a4:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010a6:	8082                	ret
{
    800010a8:	1141                	addi	sp,sp,-16
    800010aa:	e406                	sd	ra,8(sp)
    800010ac:	e022                	sd	s0,0(sp)
    800010ae:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010b0:	4601                	li	a2,0
    800010b2:	f51ff0ef          	jal	ra,80001002 <walk>
  if(pte == 0)
    800010b6:	c105                	beqz	a0,800010d6 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    800010b8:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010ba:	0117f693          	andi	a3,a5,17
    800010be:	4745                	li	a4,17
    return 0;
    800010c0:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010c2:	00e68663          	beq	a3,a4,800010ce <walkaddr+0x32>
}
    800010c6:	60a2                	ld	ra,8(sp)
    800010c8:	6402                	ld	s0,0(sp)
    800010ca:	0141                	addi	sp,sp,16
    800010cc:	8082                	ret
  pa = PTE2PA(*pte);
    800010ce:	00a7d513          	srli	a0,a5,0xa
    800010d2:	0532                	slli	a0,a0,0xc
  return pa;
    800010d4:	bfcd                	j	800010c6 <walkaddr+0x2a>
    return 0;
    800010d6:	4501                	li	a0,0
    800010d8:	b7fd                	j	800010c6 <walkaddr+0x2a>

00000000800010da <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800010da:	715d                	addi	sp,sp,-80
    800010dc:	e486                	sd	ra,72(sp)
    800010de:	e0a2                	sd	s0,64(sp)
    800010e0:	fc26                	sd	s1,56(sp)
    800010e2:	f84a                	sd	s2,48(sp)
    800010e4:	f44e                	sd	s3,40(sp)
    800010e6:	f052                	sd	s4,32(sp)
    800010e8:	ec56                	sd	s5,24(sp)
    800010ea:	e85a                	sd	s6,16(sp)
    800010ec:	e45e                	sd	s7,8(sp)
    800010ee:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800010f0:	03459793          	slli	a5,a1,0x34
    800010f4:	e7a9                	bnez	a5,8000113e <mappages+0x64>
    800010f6:	8aaa                	mv	s5,a0
    800010f8:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800010fa:	03461793          	slli	a5,a2,0x34
    800010fe:	e7b1                	bnez	a5,8000114a <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80001100:	ca39                	beqz	a2,80001156 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80001102:	79fd                	lui	s3,0xfffff
    80001104:	964e                	add	a2,a2,s3
    80001106:	00b609b3          	add	s3,a2,a1
  a = va;
    8000110a:	892e                	mv	s2,a1
    8000110c:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001110:	6b85                	lui	s7,0x1
    80001112:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001116:	4605                	li	a2,1
    80001118:	85ca                	mv	a1,s2
    8000111a:	8556                	mv	a0,s5
    8000111c:	ee7ff0ef          	jal	ra,80001002 <walk>
    80001120:	c539                	beqz	a0,8000116e <mappages+0x94>
    if(*pte & PTE_V)
    80001122:	611c                	ld	a5,0(a0)
    80001124:	8b85                	andi	a5,a5,1
    80001126:	ef95                	bnez	a5,80001162 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001128:	80b1                	srli	s1,s1,0xc
    8000112a:	04aa                	slli	s1,s1,0xa
    8000112c:	0164e4b3          	or	s1,s1,s6
    80001130:	0014e493          	ori	s1,s1,1
    80001134:	e104                	sd	s1,0(a0)
    if(a == last)
    80001136:	05390863          	beq	s2,s3,80001186 <mappages+0xac>
    a += PGSIZE;
    8000113a:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000113c:	bfd9                	j	80001112 <mappages+0x38>
    panic("mappages: va not aligned");
    8000113e:	00006517          	auipc	a0,0x6
    80001142:	09a50513          	addi	a0,a0,154 # 800071d8 <digits+0x1a0>
    80001146:	df0ff0ef          	jal	ra,80000736 <panic>
    panic("mappages: size not aligned");
    8000114a:	00006517          	auipc	a0,0x6
    8000114e:	0ae50513          	addi	a0,a0,174 # 800071f8 <digits+0x1c0>
    80001152:	de4ff0ef          	jal	ra,80000736 <panic>
    panic("mappages: size");
    80001156:	00006517          	auipc	a0,0x6
    8000115a:	0c250513          	addi	a0,a0,194 # 80007218 <digits+0x1e0>
    8000115e:	dd8ff0ef          	jal	ra,80000736 <panic>
      panic("mappages: remap");
    80001162:	00006517          	auipc	a0,0x6
    80001166:	0c650513          	addi	a0,a0,198 # 80007228 <digits+0x1f0>
    8000116a:	dccff0ef          	jal	ra,80000736 <panic>
      return -1;
    8000116e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001170:	60a6                	ld	ra,72(sp)
    80001172:	6406                	ld	s0,64(sp)
    80001174:	74e2                	ld	s1,56(sp)
    80001176:	7942                	ld	s2,48(sp)
    80001178:	79a2                	ld	s3,40(sp)
    8000117a:	7a02                	ld	s4,32(sp)
    8000117c:	6ae2                	ld	s5,24(sp)
    8000117e:	6b42                	ld	s6,16(sp)
    80001180:	6ba2                	ld	s7,8(sp)
    80001182:	6161                	addi	sp,sp,80
    80001184:	8082                	ret
  return 0;
    80001186:	4501                	li	a0,0
    80001188:	b7e5                	j	80001170 <mappages+0x96>

000000008000118a <kvmmap>:
{
    8000118a:	1141                	addi	sp,sp,-16
    8000118c:	e406                	sd	ra,8(sp)
    8000118e:	e022                	sd	s0,0(sp)
    80001190:	0800                	addi	s0,sp,16
    80001192:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001194:	86b2                	mv	a3,a2
    80001196:	863e                	mv	a2,a5
    80001198:	f43ff0ef          	jal	ra,800010da <mappages>
    8000119c:	e509                	bnez	a0,800011a6 <kvmmap+0x1c>
}
    8000119e:	60a2                	ld	ra,8(sp)
    800011a0:	6402                	ld	s0,0(sp)
    800011a2:	0141                	addi	sp,sp,16
    800011a4:	8082                	ret
    panic("kvmmap");
    800011a6:	00006517          	auipc	a0,0x6
    800011aa:	09250513          	addi	a0,a0,146 # 80007238 <digits+0x200>
    800011ae:	d88ff0ef          	jal	ra,80000736 <panic>

00000000800011b2 <kvmmake>:
{
    800011b2:	1101                	addi	sp,sp,-32
    800011b4:	ec06                	sd	ra,24(sp)
    800011b6:	e822                	sd	s0,16(sp)
    800011b8:	e426                	sd	s1,8(sp)
    800011ba:	e04a                	sd	s2,0(sp)
    800011bc:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800011be:	8d9ff0ef          	jal	ra,80000a96 <kalloc>
    800011c2:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800011c4:	6605                	lui	a2,0x1
    800011c6:	4581                	li	a1,0
    800011c8:	ab3ff0ef          	jal	ra,80000c7a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800011cc:	4719                	li	a4,6
    800011ce:	6685                	lui	a3,0x1
    800011d0:	10000637          	lui	a2,0x10000
    800011d4:	100005b7          	lui	a1,0x10000
    800011d8:	8526                	mv	a0,s1
    800011da:	fb1ff0ef          	jal	ra,8000118a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800011de:	4719                	li	a4,6
    800011e0:	6685                	lui	a3,0x1
    800011e2:	10001637          	lui	a2,0x10001
    800011e6:	100015b7          	lui	a1,0x10001
    800011ea:	8526                	mv	a0,s1
    800011ec:	f9fff0ef          	jal	ra,8000118a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800011f0:	4719                	li	a4,6
    800011f2:	040006b7          	lui	a3,0x4000
    800011f6:	0c000637          	lui	a2,0xc000
    800011fa:	0c0005b7          	lui	a1,0xc000
    800011fe:	8526                	mv	a0,s1
    80001200:	f8bff0ef          	jal	ra,8000118a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001204:	00006917          	auipc	s2,0x6
    80001208:	dfc90913          	addi	s2,s2,-516 # 80007000 <etext>
    8000120c:	4729                	li	a4,10
    8000120e:	80006697          	auipc	a3,0x80006
    80001212:	df268693          	addi	a3,a3,-526 # 7000 <_entry-0x7fff9000>
    80001216:	4605                	li	a2,1
    80001218:	067e                	slli	a2,a2,0x1f
    8000121a:	85b2                	mv	a1,a2
    8000121c:	8526                	mv	a0,s1
    8000121e:	f6dff0ef          	jal	ra,8000118a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001222:	4719                	li	a4,6
    80001224:	46c5                	li	a3,17
    80001226:	06ee                	slli	a3,a3,0x1b
    80001228:	412686b3          	sub	a3,a3,s2
    8000122c:	864a                	mv	a2,s2
    8000122e:	85ca                	mv	a1,s2
    80001230:	8526                	mv	a0,s1
    80001232:	f59ff0ef          	jal	ra,8000118a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001236:	4729                	li	a4,10
    80001238:	6685                	lui	a3,0x1
    8000123a:	00005617          	auipc	a2,0x5
    8000123e:	dc660613          	addi	a2,a2,-570 # 80006000 <_trampoline>
    80001242:	040005b7          	lui	a1,0x4000
    80001246:	15fd                	addi	a1,a1,-1
    80001248:	05b2                	slli	a1,a1,0xc
    8000124a:	8526                	mv	a0,s1
    8000124c:	f3fff0ef          	jal	ra,8000118a <kvmmap>
  proc_mapstacks(kpgtbl);
    80001250:	8526                	mv	a0,s1
    80001252:	594000ef          	jal	ra,800017e6 <proc_mapstacks>
}
    80001256:	8526                	mv	a0,s1
    80001258:	60e2                	ld	ra,24(sp)
    8000125a:	6442                	ld	s0,16(sp)
    8000125c:	64a2                	ld	s1,8(sp)
    8000125e:	6902                	ld	s2,0(sp)
    80001260:	6105                	addi	sp,sp,32
    80001262:	8082                	ret

0000000080001264 <kvminit>:
{
    80001264:	1141                	addi	sp,sp,-16
    80001266:	e406                	sd	ra,8(sp)
    80001268:	e022                	sd	s0,0(sp)
    8000126a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000126c:	f47ff0ef          	jal	ra,800011b2 <kvmmake>
    80001270:	00007797          	auipc	a5,0x7
    80001274:	8ea7b823          	sd	a0,-1808(a5) # 80007b60 <kernel_pagetable>
}
    80001278:	60a2                	ld	ra,8(sp)
    8000127a:	6402                	ld	s0,0(sp)
    8000127c:	0141                	addi	sp,sp,16
    8000127e:	8082                	ret

0000000080001280 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001280:	715d                	addi	sp,sp,-80
    80001282:	e486                	sd	ra,72(sp)
    80001284:	e0a2                	sd	s0,64(sp)
    80001286:	fc26                	sd	s1,56(sp)
    80001288:	f84a                	sd	s2,48(sp)
    8000128a:	f44e                	sd	s3,40(sp)
    8000128c:	f052                	sd	s4,32(sp)
    8000128e:	ec56                	sd	s5,24(sp)
    80001290:	e85a                	sd	s6,16(sp)
    80001292:	e45e                	sd	s7,8(sp)
    80001294:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001296:	03459793          	slli	a5,a1,0x34
    8000129a:	e795                	bnez	a5,800012c6 <uvmunmap+0x46>
    8000129c:	8a2a                	mv	s4,a0
    8000129e:	892e                	mv	s2,a1
    800012a0:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012a2:	0632                	slli	a2,a2,0xc
    800012a4:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012a8:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012aa:	6b05                	lui	s6,0x1
    800012ac:	0535ea63          	bltu	a1,s3,80001300 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800012b0:	60a6                	ld	ra,72(sp)
    800012b2:	6406                	ld	s0,64(sp)
    800012b4:	74e2                	ld	s1,56(sp)
    800012b6:	7942                	ld	s2,48(sp)
    800012b8:	79a2                	ld	s3,40(sp)
    800012ba:	7a02                	ld	s4,32(sp)
    800012bc:	6ae2                	ld	s5,24(sp)
    800012be:	6b42                	ld	s6,16(sp)
    800012c0:	6ba2                	ld	s7,8(sp)
    800012c2:	6161                	addi	sp,sp,80
    800012c4:	8082                	ret
    panic("uvmunmap: not aligned");
    800012c6:	00006517          	auipc	a0,0x6
    800012ca:	f7a50513          	addi	a0,a0,-134 # 80007240 <digits+0x208>
    800012ce:	c68ff0ef          	jal	ra,80000736 <panic>
      panic("uvmunmap: walk");
    800012d2:	00006517          	auipc	a0,0x6
    800012d6:	f8650513          	addi	a0,a0,-122 # 80007258 <digits+0x220>
    800012da:	c5cff0ef          	jal	ra,80000736 <panic>
      panic("uvmunmap: not mapped");
    800012de:	00006517          	auipc	a0,0x6
    800012e2:	f8a50513          	addi	a0,a0,-118 # 80007268 <digits+0x230>
    800012e6:	c50ff0ef          	jal	ra,80000736 <panic>
      panic("uvmunmap: not a leaf");
    800012ea:	00006517          	auipc	a0,0x6
    800012ee:	f9650513          	addi	a0,a0,-106 # 80007280 <digits+0x248>
    800012f2:	c44ff0ef          	jal	ra,80000736 <panic>
    *pte = 0;
    800012f6:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012fa:	995a                	add	s2,s2,s6
    800012fc:	fb397ae3          	bgeu	s2,s3,800012b0 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001300:	4601                	li	a2,0
    80001302:	85ca                	mv	a1,s2
    80001304:	8552                	mv	a0,s4
    80001306:	cfdff0ef          	jal	ra,80001002 <walk>
    8000130a:	84aa                	mv	s1,a0
    8000130c:	d179                	beqz	a0,800012d2 <uvmunmap+0x52>
    if((*pte & PTE_V) == 0)
    8000130e:	6108                	ld	a0,0(a0)
    80001310:	00157793          	andi	a5,a0,1
    80001314:	d7e9                	beqz	a5,800012de <uvmunmap+0x5e>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001316:	3ff57793          	andi	a5,a0,1023
    8000131a:	fd7788e3          	beq	a5,s7,800012ea <uvmunmap+0x6a>
    if(do_free){
    8000131e:	fc0a8ce3          	beqz	s5,800012f6 <uvmunmap+0x76>
      uint64 pa = PTE2PA(*pte);
    80001322:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001324:	0532                	slli	a0,a0,0xc
    80001326:	ea4ff0ef          	jal	ra,800009ca <kfree>
    8000132a:	b7f1                	j	800012f6 <uvmunmap+0x76>

000000008000132c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000132c:	1101                	addi	sp,sp,-32
    8000132e:	ec06                	sd	ra,24(sp)
    80001330:	e822                	sd	s0,16(sp)
    80001332:	e426                	sd	s1,8(sp)
    80001334:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001336:	f60ff0ef          	jal	ra,80000a96 <kalloc>
    8000133a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000133c:	c509                	beqz	a0,80001346 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000133e:	6605                	lui	a2,0x1
    80001340:	4581                	li	a1,0
    80001342:	939ff0ef          	jal	ra,80000c7a <memset>
  return pagetable;
}
    80001346:	8526                	mv	a0,s1
    80001348:	60e2                	ld	ra,24(sp)
    8000134a:	6442                	ld	s0,16(sp)
    8000134c:	64a2                	ld	s1,8(sp)
    8000134e:	6105                	addi	sp,sp,32
    80001350:	8082                	ret

0000000080001352 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001352:	7179                	addi	sp,sp,-48
    80001354:	f406                	sd	ra,40(sp)
    80001356:	f022                	sd	s0,32(sp)
    80001358:	ec26                	sd	s1,24(sp)
    8000135a:	e84a                	sd	s2,16(sp)
    8000135c:	e44e                	sd	s3,8(sp)
    8000135e:	e052                	sd	s4,0(sp)
    80001360:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001362:	6785                	lui	a5,0x1
    80001364:	04f67063          	bgeu	a2,a5,800013a4 <uvmfirst+0x52>
    80001368:	8a2a                	mv	s4,a0
    8000136a:	89ae                	mv	s3,a1
    8000136c:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000136e:	f28ff0ef          	jal	ra,80000a96 <kalloc>
    80001372:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001374:	6605                	lui	a2,0x1
    80001376:	4581                	li	a1,0
    80001378:	903ff0ef          	jal	ra,80000c7a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000137c:	4779                	li	a4,30
    8000137e:	86ca                	mv	a3,s2
    80001380:	6605                	lui	a2,0x1
    80001382:	4581                	li	a1,0
    80001384:	8552                	mv	a0,s4
    80001386:	d55ff0ef          	jal	ra,800010da <mappages>
  memmove(mem, src, sz);
    8000138a:	8626                	mv	a2,s1
    8000138c:	85ce                	mv	a1,s3
    8000138e:	854a                	mv	a0,s2
    80001390:	947ff0ef          	jal	ra,80000cd6 <memmove>
}
    80001394:	70a2                	ld	ra,40(sp)
    80001396:	7402                	ld	s0,32(sp)
    80001398:	64e2                	ld	s1,24(sp)
    8000139a:	6942                	ld	s2,16(sp)
    8000139c:	69a2                	ld	s3,8(sp)
    8000139e:	6a02                	ld	s4,0(sp)
    800013a0:	6145                	addi	sp,sp,48
    800013a2:	8082                	ret
    panic("uvmfirst: more than a page");
    800013a4:	00006517          	auipc	a0,0x6
    800013a8:	ef450513          	addi	a0,a0,-268 # 80007298 <digits+0x260>
    800013ac:	b8aff0ef          	jal	ra,80000736 <panic>

00000000800013b0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013b0:	1101                	addi	sp,sp,-32
    800013b2:	ec06                	sd	ra,24(sp)
    800013b4:	e822                	sd	s0,16(sp)
    800013b6:	e426                	sd	s1,8(sp)
    800013b8:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013ba:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013bc:	00b67d63          	bgeu	a2,a1,800013d6 <uvmdealloc+0x26>
    800013c0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013c2:	6785                	lui	a5,0x1
    800013c4:	17fd                	addi	a5,a5,-1
    800013c6:	00f60733          	add	a4,a2,a5
    800013ca:	767d                	lui	a2,0xfffff
    800013cc:	8f71                	and	a4,a4,a2
    800013ce:	97ae                	add	a5,a5,a1
    800013d0:	8ff1                	and	a5,a5,a2
    800013d2:	00f76863          	bltu	a4,a5,800013e2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013d6:	8526                	mv	a0,s1
    800013d8:	60e2                	ld	ra,24(sp)
    800013da:	6442                	ld	s0,16(sp)
    800013dc:	64a2                	ld	s1,8(sp)
    800013de:	6105                	addi	sp,sp,32
    800013e0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013e2:	8f99                	sub	a5,a5,a4
    800013e4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013e6:	4685                	li	a3,1
    800013e8:	0007861b          	sext.w	a2,a5
    800013ec:	85ba                	mv	a1,a4
    800013ee:	e93ff0ef          	jal	ra,80001280 <uvmunmap>
    800013f2:	b7d5                	j	800013d6 <uvmdealloc+0x26>

00000000800013f4 <uvmalloc>:
  if(newsz < oldsz)
    800013f4:	08b66963          	bltu	a2,a1,80001486 <uvmalloc+0x92>
{
    800013f8:	7139                	addi	sp,sp,-64
    800013fa:	fc06                	sd	ra,56(sp)
    800013fc:	f822                	sd	s0,48(sp)
    800013fe:	f426                	sd	s1,40(sp)
    80001400:	f04a                	sd	s2,32(sp)
    80001402:	ec4e                	sd	s3,24(sp)
    80001404:	e852                	sd	s4,16(sp)
    80001406:	e456                	sd	s5,8(sp)
    80001408:	e05a                	sd	s6,0(sp)
    8000140a:	0080                	addi	s0,sp,64
    8000140c:	8aaa                	mv	s5,a0
    8000140e:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001410:	6985                	lui	s3,0x1
    80001412:	19fd                	addi	s3,s3,-1
    80001414:	95ce                	add	a1,a1,s3
    80001416:	79fd                	lui	s3,0xfffff
    80001418:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000141c:	06c9f763          	bgeu	s3,a2,8000148a <uvmalloc+0x96>
    80001420:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001422:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001426:	e70ff0ef          	jal	ra,80000a96 <kalloc>
    8000142a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000142c:	c11d                	beqz	a0,80001452 <uvmalloc+0x5e>
    memset(mem, 0, PGSIZE);
    8000142e:	6605                	lui	a2,0x1
    80001430:	4581                	li	a1,0
    80001432:	849ff0ef          	jal	ra,80000c7a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001436:	875a                	mv	a4,s6
    80001438:	86a6                	mv	a3,s1
    8000143a:	6605                	lui	a2,0x1
    8000143c:	85ca                	mv	a1,s2
    8000143e:	8556                	mv	a0,s5
    80001440:	c9bff0ef          	jal	ra,800010da <mappages>
    80001444:	e51d                	bnez	a0,80001472 <uvmalloc+0x7e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001446:	6785                	lui	a5,0x1
    80001448:	993e                	add	s2,s2,a5
    8000144a:	fd496ee3          	bltu	s2,s4,80001426 <uvmalloc+0x32>
  return newsz;
    8000144e:	8552                	mv	a0,s4
    80001450:	a039                	j	8000145e <uvmalloc+0x6a>
      uvmdealloc(pagetable, a, oldsz);
    80001452:	864e                	mv	a2,s3
    80001454:	85ca                	mv	a1,s2
    80001456:	8556                	mv	a0,s5
    80001458:	f59ff0ef          	jal	ra,800013b0 <uvmdealloc>
      return 0;
    8000145c:	4501                	li	a0,0
}
    8000145e:	70e2                	ld	ra,56(sp)
    80001460:	7442                	ld	s0,48(sp)
    80001462:	74a2                	ld	s1,40(sp)
    80001464:	7902                	ld	s2,32(sp)
    80001466:	69e2                	ld	s3,24(sp)
    80001468:	6a42                	ld	s4,16(sp)
    8000146a:	6aa2                	ld	s5,8(sp)
    8000146c:	6b02                	ld	s6,0(sp)
    8000146e:	6121                	addi	sp,sp,64
    80001470:	8082                	ret
      kfree(mem);
    80001472:	8526                	mv	a0,s1
    80001474:	d56ff0ef          	jal	ra,800009ca <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001478:	864e                	mv	a2,s3
    8000147a:	85ca                	mv	a1,s2
    8000147c:	8556                	mv	a0,s5
    8000147e:	f33ff0ef          	jal	ra,800013b0 <uvmdealloc>
      return 0;
    80001482:	4501                	li	a0,0
    80001484:	bfe9                	j	8000145e <uvmalloc+0x6a>
    return oldsz;
    80001486:	852e                	mv	a0,a1
}
    80001488:	8082                	ret
  return newsz;
    8000148a:	8532                	mv	a0,a2
    8000148c:	bfc9                	j	8000145e <uvmalloc+0x6a>

000000008000148e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000148e:	7179                	addi	sp,sp,-48
    80001490:	f406                	sd	ra,40(sp)
    80001492:	f022                	sd	s0,32(sp)
    80001494:	ec26                	sd	s1,24(sp)
    80001496:	e84a                	sd	s2,16(sp)
    80001498:	e44e                	sd	s3,8(sp)
    8000149a:	e052                	sd	s4,0(sp)
    8000149c:	1800                	addi	s0,sp,48
    8000149e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014a0:	84aa                	mv	s1,a0
    800014a2:	6905                	lui	s2,0x1
    800014a4:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014a6:	4985                	li	s3,1
    800014a8:	a811                	j	800014bc <freewalk+0x2e>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014aa:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800014ac:	0532                	slli	a0,a0,0xc
    800014ae:	fe1ff0ef          	jal	ra,8000148e <freewalk>
      pagetable[i] = 0;
    800014b2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014b6:	04a1                	addi	s1,s1,8
    800014b8:	01248f63          	beq	s1,s2,800014d6 <freewalk+0x48>
    pte_t pte = pagetable[i];
    800014bc:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014be:	00f57793          	andi	a5,a0,15
    800014c2:	ff3784e3          	beq	a5,s3,800014aa <freewalk+0x1c>
    } else if(pte & PTE_V){
    800014c6:	8905                	andi	a0,a0,1
    800014c8:	d57d                	beqz	a0,800014b6 <freewalk+0x28>
      panic("freewalk: leaf");
    800014ca:	00006517          	auipc	a0,0x6
    800014ce:	dee50513          	addi	a0,a0,-530 # 800072b8 <digits+0x280>
    800014d2:	a64ff0ef          	jal	ra,80000736 <panic>
    }
  }
  kfree((void*)pagetable);
    800014d6:	8552                	mv	a0,s4
    800014d8:	cf2ff0ef          	jal	ra,800009ca <kfree>
}
    800014dc:	70a2                	ld	ra,40(sp)
    800014de:	7402                	ld	s0,32(sp)
    800014e0:	64e2                	ld	s1,24(sp)
    800014e2:	6942                	ld	s2,16(sp)
    800014e4:	69a2                	ld	s3,8(sp)
    800014e6:	6a02                	ld	s4,0(sp)
    800014e8:	6145                	addi	sp,sp,48
    800014ea:	8082                	ret

00000000800014ec <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800014ec:	1101                	addi	sp,sp,-32
    800014ee:	ec06                	sd	ra,24(sp)
    800014f0:	e822                	sd	s0,16(sp)
    800014f2:	e426                	sd	s1,8(sp)
    800014f4:	1000                	addi	s0,sp,32
    800014f6:	84aa                	mv	s1,a0
  if(sz > 0)
    800014f8:	e989                	bnez	a1,8000150a <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800014fa:	8526                	mv	a0,s1
    800014fc:	f93ff0ef          	jal	ra,8000148e <freewalk>
}
    80001500:	60e2                	ld	ra,24(sp)
    80001502:	6442                	ld	s0,16(sp)
    80001504:	64a2                	ld	s1,8(sp)
    80001506:	6105                	addi	sp,sp,32
    80001508:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000150a:	6605                	lui	a2,0x1
    8000150c:	167d                	addi	a2,a2,-1
    8000150e:	962e                	add	a2,a2,a1
    80001510:	4685                	li	a3,1
    80001512:	8231                	srli	a2,a2,0xc
    80001514:	4581                	li	a1,0
    80001516:	d6bff0ef          	jal	ra,80001280 <uvmunmap>
    8000151a:	b7c5                	j	800014fa <uvmfree+0xe>

000000008000151c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000151c:	c65d                	beqz	a2,800015ca <uvmcopy+0xae>
{
    8000151e:	715d                	addi	sp,sp,-80
    80001520:	e486                	sd	ra,72(sp)
    80001522:	e0a2                	sd	s0,64(sp)
    80001524:	fc26                	sd	s1,56(sp)
    80001526:	f84a                	sd	s2,48(sp)
    80001528:	f44e                	sd	s3,40(sp)
    8000152a:	f052                	sd	s4,32(sp)
    8000152c:	ec56                	sd	s5,24(sp)
    8000152e:	e85a                	sd	s6,16(sp)
    80001530:	e45e                	sd	s7,8(sp)
    80001532:	0880                	addi	s0,sp,80
    80001534:	8b2a                	mv	s6,a0
    80001536:	8aae                	mv	s5,a1
    80001538:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000153a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000153c:	4601                	li	a2,0
    8000153e:	85ce                	mv	a1,s3
    80001540:	855a                	mv	a0,s6
    80001542:	ac1ff0ef          	jal	ra,80001002 <walk>
    80001546:	c121                	beqz	a0,80001586 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001548:	6118                	ld	a4,0(a0)
    8000154a:	00177793          	andi	a5,a4,1
    8000154e:	c3b1                	beqz	a5,80001592 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001550:	00a75593          	srli	a1,a4,0xa
    80001554:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001558:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000155c:	d3aff0ef          	jal	ra,80000a96 <kalloc>
    80001560:	892a                	mv	s2,a0
    80001562:	c129                	beqz	a0,800015a4 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001564:	6605                	lui	a2,0x1
    80001566:	85de                	mv	a1,s7
    80001568:	f6eff0ef          	jal	ra,80000cd6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000156c:	8726                	mv	a4,s1
    8000156e:	86ca                	mv	a3,s2
    80001570:	6605                	lui	a2,0x1
    80001572:	85ce                	mv	a1,s3
    80001574:	8556                	mv	a0,s5
    80001576:	b65ff0ef          	jal	ra,800010da <mappages>
    8000157a:	e115                	bnez	a0,8000159e <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    8000157c:	6785                	lui	a5,0x1
    8000157e:	99be                	add	s3,s3,a5
    80001580:	fb49eee3          	bltu	s3,s4,8000153c <uvmcopy+0x20>
    80001584:	a805                	j	800015b4 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80001586:	00006517          	auipc	a0,0x6
    8000158a:	d4250513          	addi	a0,a0,-702 # 800072c8 <digits+0x290>
    8000158e:	9a8ff0ef          	jal	ra,80000736 <panic>
      panic("uvmcopy: page not present");
    80001592:	00006517          	auipc	a0,0x6
    80001596:	d5650513          	addi	a0,a0,-682 # 800072e8 <digits+0x2b0>
    8000159a:	99cff0ef          	jal	ra,80000736 <panic>
      kfree(mem);
    8000159e:	854a                	mv	a0,s2
    800015a0:	c2aff0ef          	jal	ra,800009ca <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800015a4:	4685                	li	a3,1
    800015a6:	00c9d613          	srli	a2,s3,0xc
    800015aa:	4581                	li	a1,0
    800015ac:	8556                	mv	a0,s5
    800015ae:	cd3ff0ef          	jal	ra,80001280 <uvmunmap>
  return -1;
    800015b2:	557d                	li	a0,-1
}
    800015b4:	60a6                	ld	ra,72(sp)
    800015b6:	6406                	ld	s0,64(sp)
    800015b8:	74e2                	ld	s1,56(sp)
    800015ba:	7942                	ld	s2,48(sp)
    800015bc:	79a2                	ld	s3,40(sp)
    800015be:	7a02                	ld	s4,32(sp)
    800015c0:	6ae2                	ld	s5,24(sp)
    800015c2:	6b42                	ld	s6,16(sp)
    800015c4:	6ba2                	ld	s7,8(sp)
    800015c6:	6161                	addi	sp,sp,80
    800015c8:	8082                	ret
  return 0;
    800015ca:	4501                	li	a0,0
}
    800015cc:	8082                	ret

00000000800015ce <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800015ce:	1141                	addi	sp,sp,-16
    800015d0:	e406                	sd	ra,8(sp)
    800015d2:	e022                	sd	s0,0(sp)
    800015d4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800015d6:	4601                	li	a2,0
    800015d8:	a2bff0ef          	jal	ra,80001002 <walk>
  if(pte == 0)
    800015dc:	c901                	beqz	a0,800015ec <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800015de:	611c                	ld	a5,0(a0)
    800015e0:	9bbd                	andi	a5,a5,-17
    800015e2:	e11c                	sd	a5,0(a0)
}
    800015e4:	60a2                	ld	ra,8(sp)
    800015e6:	6402                	ld	s0,0(sp)
    800015e8:	0141                	addi	sp,sp,16
    800015ea:	8082                	ret
    panic("uvmclear");
    800015ec:	00006517          	auipc	a0,0x6
    800015f0:	d1c50513          	addi	a0,a0,-740 # 80007308 <digits+0x2d0>
    800015f4:	942ff0ef          	jal	ra,80000736 <panic>

00000000800015f8 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800015f8:	c6c9                	beqz	a3,80001682 <copyout+0x8a>
{
    800015fa:	711d                	addi	sp,sp,-96
    800015fc:	ec86                	sd	ra,88(sp)
    800015fe:	e8a2                	sd	s0,80(sp)
    80001600:	e4a6                	sd	s1,72(sp)
    80001602:	e0ca                	sd	s2,64(sp)
    80001604:	fc4e                	sd	s3,56(sp)
    80001606:	f852                	sd	s4,48(sp)
    80001608:	f456                	sd	s5,40(sp)
    8000160a:	f05a                	sd	s6,32(sp)
    8000160c:	ec5e                	sd	s7,24(sp)
    8000160e:	e862                	sd	s8,16(sp)
    80001610:	e466                	sd	s9,8(sp)
    80001612:	e06a                	sd	s10,0(sp)
    80001614:	1080                	addi	s0,sp,96
    80001616:	8baa                	mv	s7,a0
    80001618:	8aae                	mv	s5,a1
    8000161a:	8b32                	mv	s6,a2
    8000161c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000161e:	74fd                	lui	s1,0xfffff
    80001620:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001622:	57fd                	li	a5,-1
    80001624:	83e9                	srli	a5,a5,0x1a
    80001626:	0697e063          	bltu	a5,s1,80001686 <copyout+0x8e>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    8000162a:	4cd5                	li	s9,21
    8000162c:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    8000162e:	8c3e                	mv	s8,a5
    80001630:	a025                	j	80001658 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80001632:	83a9                	srli	a5,a5,0xa
    80001634:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001636:	409a8533          	sub	a0,s5,s1
    8000163a:	0009061b          	sext.w	a2,s2
    8000163e:	85da                	mv	a1,s6
    80001640:	953e                	add	a0,a0,a5
    80001642:	e94ff0ef          	jal	ra,80000cd6 <memmove>

    len -= n;
    80001646:	412989b3          	sub	s3,s3,s2
    src += n;
    8000164a:	9b4a                	add	s6,s6,s2
  while(len > 0){
    8000164c:	02098963          	beqz	s3,8000167e <copyout+0x86>
    if(va0 >= MAXVA)
    80001650:	034c6d63          	bltu	s8,s4,8000168a <copyout+0x92>
    va0 = PGROUNDDOWN(dstva);
    80001654:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80001656:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80001658:	4601                	li	a2,0
    8000165a:	85a6                	mv	a1,s1
    8000165c:	855e                	mv	a0,s7
    8000165e:	9a5ff0ef          	jal	ra,80001002 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001662:	c515                	beqz	a0,8000168e <copyout+0x96>
    80001664:	611c                	ld	a5,0(a0)
    80001666:	0157f713          	andi	a4,a5,21
    8000166a:	05971163          	bne	a4,s9,800016ac <copyout+0xb4>
    n = PGSIZE - (dstva - va0);
    8000166e:	01a48a33          	add	s4,s1,s10
    80001672:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80001676:	fb29fee3          	bgeu	s3,s2,80001632 <copyout+0x3a>
    8000167a:	894e                	mv	s2,s3
    8000167c:	bf5d                	j	80001632 <copyout+0x3a>
  }
  return 0;
    8000167e:	4501                	li	a0,0
    80001680:	a801                	j	80001690 <copyout+0x98>
    80001682:	4501                	li	a0,0
}
    80001684:	8082                	ret
      return -1;
    80001686:	557d                	li	a0,-1
    80001688:	a021                	j	80001690 <copyout+0x98>
    8000168a:	557d                	li	a0,-1
    8000168c:	a011                	j	80001690 <copyout+0x98>
      return -1;
    8000168e:	557d                	li	a0,-1
}
    80001690:	60e6                	ld	ra,88(sp)
    80001692:	6446                	ld	s0,80(sp)
    80001694:	64a6                	ld	s1,72(sp)
    80001696:	6906                	ld	s2,64(sp)
    80001698:	79e2                	ld	s3,56(sp)
    8000169a:	7a42                	ld	s4,48(sp)
    8000169c:	7aa2                	ld	s5,40(sp)
    8000169e:	7b02                	ld	s6,32(sp)
    800016a0:	6be2                	ld	s7,24(sp)
    800016a2:	6c42                	ld	s8,16(sp)
    800016a4:	6ca2                	ld	s9,8(sp)
    800016a6:	6d02                	ld	s10,0(sp)
    800016a8:	6125                	addi	sp,sp,96
    800016aa:	8082                	ret
      return -1;
    800016ac:	557d                	li	a0,-1
    800016ae:	b7cd                	j	80001690 <copyout+0x98>

00000000800016b0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016b0:	c6a5                	beqz	a3,80001718 <copyin+0x68>
{
    800016b2:	715d                	addi	sp,sp,-80
    800016b4:	e486                	sd	ra,72(sp)
    800016b6:	e0a2                	sd	s0,64(sp)
    800016b8:	fc26                	sd	s1,56(sp)
    800016ba:	f84a                	sd	s2,48(sp)
    800016bc:	f44e                	sd	s3,40(sp)
    800016be:	f052                	sd	s4,32(sp)
    800016c0:	ec56                	sd	s5,24(sp)
    800016c2:	e85a                	sd	s6,16(sp)
    800016c4:	e45e                	sd	s7,8(sp)
    800016c6:	e062                	sd	s8,0(sp)
    800016c8:	0880                	addi	s0,sp,80
    800016ca:	8b2a                	mv	s6,a0
    800016cc:	8a2e                	mv	s4,a1
    800016ce:	8c32                	mv	s8,a2
    800016d0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800016d2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016d4:	6a85                	lui	s5,0x1
    800016d6:	a00d                	j	800016f8 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800016d8:	018505b3          	add	a1,a0,s8
    800016dc:	0004861b          	sext.w	a2,s1
    800016e0:	412585b3          	sub	a1,a1,s2
    800016e4:	8552                	mv	a0,s4
    800016e6:	df0ff0ef          	jal	ra,80000cd6 <memmove>

    len -= n;
    800016ea:	409989b3          	sub	s3,s3,s1
    dst += n;
    800016ee:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800016f0:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800016f4:	02098063          	beqz	s3,80001714 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    800016f8:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016fc:	85ca                	mv	a1,s2
    800016fe:	855a                	mv	a0,s6
    80001700:	99dff0ef          	jal	ra,8000109c <walkaddr>
    if(pa0 == 0)
    80001704:	cd01                	beqz	a0,8000171c <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80001706:	418904b3          	sub	s1,s2,s8
    8000170a:	94d6                	add	s1,s1,s5
    if(n > len)
    8000170c:	fc99f6e3          	bgeu	s3,s1,800016d8 <copyin+0x28>
    80001710:	84ce                	mv	s1,s3
    80001712:	b7d9                	j	800016d8 <copyin+0x28>
  }
  return 0;
    80001714:	4501                	li	a0,0
    80001716:	a021                	j	8000171e <copyin+0x6e>
    80001718:	4501                	li	a0,0
}
    8000171a:	8082                	ret
      return -1;
    8000171c:	557d                	li	a0,-1
}
    8000171e:	60a6                	ld	ra,72(sp)
    80001720:	6406                	ld	s0,64(sp)
    80001722:	74e2                	ld	s1,56(sp)
    80001724:	7942                	ld	s2,48(sp)
    80001726:	79a2                	ld	s3,40(sp)
    80001728:	7a02                	ld	s4,32(sp)
    8000172a:	6ae2                	ld	s5,24(sp)
    8000172c:	6b42                	ld	s6,16(sp)
    8000172e:	6ba2                	ld	s7,8(sp)
    80001730:	6c02                	ld	s8,0(sp)
    80001732:	6161                	addi	sp,sp,80
    80001734:	8082                	ret

0000000080001736 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001736:	c2d5                	beqz	a3,800017da <copyinstr+0xa4>
{
    80001738:	715d                	addi	sp,sp,-80
    8000173a:	e486                	sd	ra,72(sp)
    8000173c:	e0a2                	sd	s0,64(sp)
    8000173e:	fc26                	sd	s1,56(sp)
    80001740:	f84a                	sd	s2,48(sp)
    80001742:	f44e                	sd	s3,40(sp)
    80001744:	f052                	sd	s4,32(sp)
    80001746:	ec56                	sd	s5,24(sp)
    80001748:	e85a                	sd	s6,16(sp)
    8000174a:	e45e                	sd	s7,8(sp)
    8000174c:	0880                	addi	s0,sp,80
    8000174e:	8a2a                	mv	s4,a0
    80001750:	8b2e                	mv	s6,a1
    80001752:	8bb2                	mv	s7,a2
    80001754:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001756:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001758:	6985                	lui	s3,0x1
    8000175a:	a035                	j	80001786 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000175c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001760:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001762:	0017b793          	seqz	a5,a5
    80001766:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000176a:	60a6                	ld	ra,72(sp)
    8000176c:	6406                	ld	s0,64(sp)
    8000176e:	74e2                	ld	s1,56(sp)
    80001770:	7942                	ld	s2,48(sp)
    80001772:	79a2                	ld	s3,40(sp)
    80001774:	7a02                	ld	s4,32(sp)
    80001776:	6ae2                	ld	s5,24(sp)
    80001778:	6b42                	ld	s6,16(sp)
    8000177a:	6ba2                	ld	s7,8(sp)
    8000177c:	6161                	addi	sp,sp,80
    8000177e:	8082                	ret
    srcva = va0 + PGSIZE;
    80001780:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001784:	c4b9                	beqz	s1,800017d2 <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    80001786:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000178a:	85ca                	mv	a1,s2
    8000178c:	8552                	mv	a0,s4
    8000178e:	90fff0ef          	jal	ra,8000109c <walkaddr>
    if(pa0 == 0)
    80001792:	c131                	beqz	a0,800017d6 <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    80001794:	41790833          	sub	a6,s2,s7
    80001798:	984e                	add	a6,a6,s3
    if(n > max)
    8000179a:	0104f363          	bgeu	s1,a6,800017a0 <copyinstr+0x6a>
    8000179e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017a0:	955e                	add	a0,a0,s7
    800017a2:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017a6:	fc080de3          	beqz	a6,80001780 <copyinstr+0x4a>
    800017aa:	985a                	add	a6,a6,s6
    800017ac:	87da                	mv	a5,s6
      if(*p == '\0'){
    800017ae:	41650633          	sub	a2,a0,s6
    800017b2:	14fd                	addi	s1,s1,-1
    800017b4:	9b26                	add	s6,s6,s1
    800017b6:	00f60733          	add	a4,a2,a5
    800017ba:	00074703          	lbu	a4,0(a4)
    800017be:	df59                	beqz	a4,8000175c <copyinstr+0x26>
        *dst = *p;
    800017c0:	00e78023          	sb	a4,0(a5)
      --max;
    800017c4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800017c8:	0785                	addi	a5,a5,1
    while(n > 0){
    800017ca:	ff0796e3          	bne	a5,a6,800017b6 <copyinstr+0x80>
      dst++;
    800017ce:	8b42                	mv	s6,a6
    800017d0:	bf45                	j	80001780 <copyinstr+0x4a>
    800017d2:	4781                	li	a5,0
    800017d4:	b779                	j	80001762 <copyinstr+0x2c>
      return -1;
    800017d6:	557d                	li	a0,-1
    800017d8:	bf49                	j	8000176a <copyinstr+0x34>
  int got_null = 0;
    800017da:	4781                	li	a5,0
  if(got_null){
    800017dc:	0017b793          	seqz	a5,a5
    800017e0:	40f00533          	neg	a0,a5
}
    800017e4:	8082                	ret

00000000800017e6 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800017e6:	7139                	addi	sp,sp,-64
    800017e8:	fc06                	sd	ra,56(sp)
    800017ea:	f822                	sd	s0,48(sp)
    800017ec:	f426                	sd	s1,40(sp)
    800017ee:	f04a                	sd	s2,32(sp)
    800017f0:	ec4e                	sd	s3,24(sp)
    800017f2:	e852                	sd	s4,16(sp)
    800017f4:	e456                	sd	s5,8(sp)
    800017f6:	e05a                	sd	s6,0(sp)
    800017f8:	0080                	addi	s0,sp,64
    800017fa:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800017fc:	0000f497          	auipc	s1,0xf
    80001800:	8d448493          	addi	s1,s1,-1836 # 800100d0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001804:	8b26                	mv	s6,s1
    80001806:	00005a97          	auipc	s5,0x5
    8000180a:	7faa8a93          	addi	s5,s5,2042 # 80007000 <etext>
    8000180e:	04000937          	lui	s2,0x4000
    80001812:	197d                	addi	s2,s2,-1
    80001814:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001816:	00014a17          	auipc	s4,0x14
    8000181a:	2baa0a13          	addi	s4,s4,698 # 80015ad0 <tickslock>
    char *pa = kalloc();
    8000181e:	a78ff0ef          	jal	ra,80000a96 <kalloc>
    80001822:	862a                	mv	a2,a0
    if(pa == 0)
    80001824:	c121                	beqz	a0,80001864 <proc_mapstacks+0x7e>
    uint64 va = KSTACK((int) (p - proc));
    80001826:	416485b3          	sub	a1,s1,s6
    8000182a:	858d                	srai	a1,a1,0x3
    8000182c:	000ab783          	ld	a5,0(s5)
    80001830:	02f585b3          	mul	a1,a1,a5
    80001834:	2585                	addiw	a1,a1,1
    80001836:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000183a:	4719                	li	a4,6
    8000183c:	6685                	lui	a3,0x1
    8000183e:	40b905b3          	sub	a1,s2,a1
    80001842:	854e                	mv	a0,s3
    80001844:	947ff0ef          	jal	ra,8000118a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001848:	16848493          	addi	s1,s1,360
    8000184c:	fd4499e3          	bne	s1,s4,8000181e <proc_mapstacks+0x38>
  }
}
    80001850:	70e2                	ld	ra,56(sp)
    80001852:	7442                	ld	s0,48(sp)
    80001854:	74a2                	ld	s1,40(sp)
    80001856:	7902                	ld	s2,32(sp)
    80001858:	69e2                	ld	s3,24(sp)
    8000185a:	6a42                	ld	s4,16(sp)
    8000185c:	6aa2                	ld	s5,8(sp)
    8000185e:	6b02                	ld	s6,0(sp)
    80001860:	6121                	addi	sp,sp,64
    80001862:	8082                	ret
      panic("kalloc");
    80001864:	00006517          	auipc	a0,0x6
    80001868:	ab450513          	addi	a0,a0,-1356 # 80007318 <digits+0x2e0>
    8000186c:	ecbfe0ef          	jal	ra,80000736 <panic>

0000000080001870 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001870:	7139                	addi	sp,sp,-64
    80001872:	fc06                	sd	ra,56(sp)
    80001874:	f822                	sd	s0,48(sp)
    80001876:	f426                	sd	s1,40(sp)
    80001878:	f04a                	sd	s2,32(sp)
    8000187a:	ec4e                	sd	s3,24(sp)
    8000187c:	e852                	sd	s4,16(sp)
    8000187e:	e456                	sd	s5,8(sp)
    80001880:	e05a                	sd	s6,0(sp)
    80001882:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001884:	00006597          	auipc	a1,0x6
    80001888:	a9c58593          	addi	a1,a1,-1380 # 80007320 <digits+0x2e8>
    8000188c:	0000e517          	auipc	a0,0xe
    80001890:	41450513          	addi	a0,a0,1044 # 8000fca0 <pid_lock>
    80001894:	a92ff0ef          	jal	ra,80000b26 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001898:	00006597          	auipc	a1,0x6
    8000189c:	a9058593          	addi	a1,a1,-1392 # 80007328 <digits+0x2f0>
    800018a0:	0000e517          	auipc	a0,0xe
    800018a4:	41850513          	addi	a0,a0,1048 # 8000fcb8 <wait_lock>
    800018a8:	a7eff0ef          	jal	ra,80000b26 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ac:	0000f497          	auipc	s1,0xf
    800018b0:	82448493          	addi	s1,s1,-2012 # 800100d0 <proc>
      initlock(&p->lock, "proc");
    800018b4:	00006b17          	auipc	s6,0x6
    800018b8:	a84b0b13          	addi	s6,s6,-1404 # 80007338 <digits+0x300>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    800018bc:	8aa6                	mv	s5,s1
    800018be:	00005a17          	auipc	s4,0x5
    800018c2:	742a0a13          	addi	s4,s4,1858 # 80007000 <etext>
    800018c6:	04000937          	lui	s2,0x4000
    800018ca:	197d                	addi	s2,s2,-1
    800018cc:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ce:	00014997          	auipc	s3,0x14
    800018d2:	20298993          	addi	s3,s3,514 # 80015ad0 <tickslock>
      initlock(&p->lock, "proc");
    800018d6:	85da                	mv	a1,s6
    800018d8:	8526                	mv	a0,s1
    800018da:	a4cff0ef          	jal	ra,80000b26 <initlock>
      p->state = UNUSED;
    800018de:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800018e2:	415487b3          	sub	a5,s1,s5
    800018e6:	878d                	srai	a5,a5,0x3
    800018e8:	000a3703          	ld	a4,0(s4)
    800018ec:	02e787b3          	mul	a5,a5,a4
    800018f0:	2785                	addiw	a5,a5,1
    800018f2:	00d7979b          	slliw	a5,a5,0xd
    800018f6:	40f907b3          	sub	a5,s2,a5
    800018fa:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018fc:	16848493          	addi	s1,s1,360
    80001900:	fd349be3          	bne	s1,s3,800018d6 <procinit+0x66>
  }
}
    80001904:	70e2                	ld	ra,56(sp)
    80001906:	7442                	ld	s0,48(sp)
    80001908:	74a2                	ld	s1,40(sp)
    8000190a:	7902                	ld	s2,32(sp)
    8000190c:	69e2                	ld	s3,24(sp)
    8000190e:	6a42                	ld	s4,16(sp)
    80001910:	6aa2                	ld	s5,8(sp)
    80001912:	6b02                	ld	s6,0(sp)
    80001914:	6121                	addi	sp,sp,64
    80001916:	8082                	ret

0000000080001918 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001918:	1141                	addi	sp,sp,-16
    8000191a:	e422                	sd	s0,8(sp)
    8000191c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000191e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001920:	2501                	sext.w	a0,a0
    80001922:	6422                	ld	s0,8(sp)
    80001924:	0141                	addi	sp,sp,16
    80001926:	8082                	ret

0000000080001928 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001928:	1141                	addi	sp,sp,-16
    8000192a:	e422                	sd	s0,8(sp)
    8000192c:	0800                	addi	s0,sp,16
    8000192e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001930:	2781                	sext.w	a5,a5
    80001932:	079e                	slli	a5,a5,0x7
  return c;
}
    80001934:	0000e517          	auipc	a0,0xe
    80001938:	39c50513          	addi	a0,a0,924 # 8000fcd0 <cpus>
    8000193c:	953e                	add	a0,a0,a5
    8000193e:	6422                	ld	s0,8(sp)
    80001940:	0141                	addi	sp,sp,16
    80001942:	8082                	ret

0000000080001944 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001944:	1101                	addi	sp,sp,-32
    80001946:	ec06                	sd	ra,24(sp)
    80001948:	e822                	sd	s0,16(sp)
    8000194a:	e426                	sd	s1,8(sp)
    8000194c:	1000                	addi	s0,sp,32
  push_off();
    8000194e:	a18ff0ef          	jal	ra,80000b66 <push_off>
    80001952:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001954:	2781                	sext.w	a5,a5
    80001956:	079e                	slli	a5,a5,0x7
    80001958:	0000e717          	auipc	a4,0xe
    8000195c:	34870713          	addi	a4,a4,840 # 8000fca0 <pid_lock>
    80001960:	97ba                	add	a5,a5,a4
    80001962:	7b84                	ld	s1,48(a5)
  pop_off();
    80001964:	a86ff0ef          	jal	ra,80000bea <pop_off>
  return p;
}
    80001968:	8526                	mv	a0,s1
    8000196a:	60e2                	ld	ra,24(sp)
    8000196c:	6442                	ld	s0,16(sp)
    8000196e:	64a2                	ld	s1,8(sp)
    80001970:	6105                	addi	sp,sp,32
    80001972:	8082                	ret

0000000080001974 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001974:	1141                	addi	sp,sp,-16
    80001976:	e406                	sd	ra,8(sp)
    80001978:	e022                	sd	s0,0(sp)
    8000197a:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000197c:	fc9ff0ef          	jal	ra,80001944 <myproc>
    80001980:	abeff0ef          	jal	ra,80000c3e <release>

  if (first) {
    80001984:	00006797          	auipc	a5,0x6
    80001988:	16c7a783          	lw	a5,364(a5) # 80007af0 <first.1>
    8000198c:	e799                	bnez	a5,8000199a <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    8000198e:	36f000ef          	jal	ra,800024fc <usertrapret>
}
    80001992:	60a2                	ld	ra,8(sp)
    80001994:	6402                	ld	s0,0(sp)
    80001996:	0141                	addi	sp,sp,16
    80001998:	8082                	ret
    fsinit(ROOTDEV);
    8000199a:	4505                	li	a0,1
    8000199c:	7c4010ef          	jal	ra,80003160 <fsinit>
    first = 0;
    800019a0:	00006797          	auipc	a5,0x6
    800019a4:	1407a823          	sw	zero,336(a5) # 80007af0 <first.1>
    __sync_synchronize();
    800019a8:	0ff0000f          	fence
    800019ac:	b7cd                	j	8000198e <forkret+0x1a>

00000000800019ae <allocpid>:
{
    800019ae:	1101                	addi	sp,sp,-32
    800019b0:	ec06                	sd	ra,24(sp)
    800019b2:	e822                	sd	s0,16(sp)
    800019b4:	e426                	sd	s1,8(sp)
    800019b6:	e04a                	sd	s2,0(sp)
    800019b8:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800019ba:	0000e917          	auipc	s2,0xe
    800019be:	2e690913          	addi	s2,s2,742 # 8000fca0 <pid_lock>
    800019c2:	854a                	mv	a0,s2
    800019c4:	9e2ff0ef          	jal	ra,80000ba6 <acquire>
  pid = nextpid;
    800019c8:	00006797          	auipc	a5,0x6
    800019cc:	12c78793          	addi	a5,a5,300 # 80007af4 <nextpid>
    800019d0:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800019d2:	0014871b          	addiw	a4,s1,1
    800019d6:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800019d8:	854a                	mv	a0,s2
    800019da:	a64ff0ef          	jal	ra,80000c3e <release>
}
    800019de:	8526                	mv	a0,s1
    800019e0:	60e2                	ld	ra,24(sp)
    800019e2:	6442                	ld	s0,16(sp)
    800019e4:	64a2                	ld	s1,8(sp)
    800019e6:	6902                	ld	s2,0(sp)
    800019e8:	6105                	addi	sp,sp,32
    800019ea:	8082                	ret

00000000800019ec <proc_pagetable>:
{
    800019ec:	1101                	addi	sp,sp,-32
    800019ee:	ec06                	sd	ra,24(sp)
    800019f0:	e822                	sd	s0,16(sp)
    800019f2:	e426                	sd	s1,8(sp)
    800019f4:	e04a                	sd	s2,0(sp)
    800019f6:	1000                	addi	s0,sp,32
    800019f8:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800019fa:	933ff0ef          	jal	ra,8000132c <uvmcreate>
    800019fe:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a00:	cd05                	beqz	a0,80001a38 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a02:	4729                	li	a4,10
    80001a04:	00004697          	auipc	a3,0x4
    80001a08:	5fc68693          	addi	a3,a3,1532 # 80006000 <_trampoline>
    80001a0c:	6605                	lui	a2,0x1
    80001a0e:	040005b7          	lui	a1,0x4000
    80001a12:	15fd                	addi	a1,a1,-1
    80001a14:	05b2                	slli	a1,a1,0xc
    80001a16:	ec4ff0ef          	jal	ra,800010da <mappages>
    80001a1a:	02054663          	bltz	a0,80001a46 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001a1e:	4719                	li	a4,6
    80001a20:	05893683          	ld	a3,88(s2)
    80001a24:	6605                	lui	a2,0x1
    80001a26:	020005b7          	lui	a1,0x2000
    80001a2a:	15fd                	addi	a1,a1,-1
    80001a2c:	05b6                	slli	a1,a1,0xd
    80001a2e:	8526                	mv	a0,s1
    80001a30:	eaaff0ef          	jal	ra,800010da <mappages>
    80001a34:	00054f63          	bltz	a0,80001a52 <proc_pagetable+0x66>
}
    80001a38:	8526                	mv	a0,s1
    80001a3a:	60e2                	ld	ra,24(sp)
    80001a3c:	6442                	ld	s0,16(sp)
    80001a3e:	64a2                	ld	s1,8(sp)
    80001a40:	6902                	ld	s2,0(sp)
    80001a42:	6105                	addi	sp,sp,32
    80001a44:	8082                	ret
    uvmfree(pagetable, 0);
    80001a46:	4581                	li	a1,0
    80001a48:	8526                	mv	a0,s1
    80001a4a:	aa3ff0ef          	jal	ra,800014ec <uvmfree>
    return 0;
    80001a4e:	4481                	li	s1,0
    80001a50:	b7e5                	j	80001a38 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a52:	4681                	li	a3,0
    80001a54:	4605                	li	a2,1
    80001a56:	040005b7          	lui	a1,0x4000
    80001a5a:	15fd                	addi	a1,a1,-1
    80001a5c:	05b2                	slli	a1,a1,0xc
    80001a5e:	8526                	mv	a0,s1
    80001a60:	821ff0ef          	jal	ra,80001280 <uvmunmap>
    uvmfree(pagetable, 0);
    80001a64:	4581                	li	a1,0
    80001a66:	8526                	mv	a0,s1
    80001a68:	a85ff0ef          	jal	ra,800014ec <uvmfree>
    return 0;
    80001a6c:	4481                	li	s1,0
    80001a6e:	b7e9                	j	80001a38 <proc_pagetable+0x4c>

0000000080001a70 <proc_freepagetable>:
{
    80001a70:	1101                	addi	sp,sp,-32
    80001a72:	ec06                	sd	ra,24(sp)
    80001a74:	e822                	sd	s0,16(sp)
    80001a76:	e426                	sd	s1,8(sp)
    80001a78:	e04a                	sd	s2,0(sp)
    80001a7a:	1000                	addi	s0,sp,32
    80001a7c:	84aa                	mv	s1,a0
    80001a7e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a80:	4681                	li	a3,0
    80001a82:	4605                	li	a2,1
    80001a84:	040005b7          	lui	a1,0x4000
    80001a88:	15fd                	addi	a1,a1,-1
    80001a8a:	05b2                	slli	a1,a1,0xc
    80001a8c:	ff4ff0ef          	jal	ra,80001280 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a90:	4681                	li	a3,0
    80001a92:	4605                	li	a2,1
    80001a94:	020005b7          	lui	a1,0x2000
    80001a98:	15fd                	addi	a1,a1,-1
    80001a9a:	05b6                	slli	a1,a1,0xd
    80001a9c:	8526                	mv	a0,s1
    80001a9e:	fe2ff0ef          	jal	ra,80001280 <uvmunmap>
  uvmfree(pagetable, sz);
    80001aa2:	85ca                	mv	a1,s2
    80001aa4:	8526                	mv	a0,s1
    80001aa6:	a47ff0ef          	jal	ra,800014ec <uvmfree>
}
    80001aaa:	60e2                	ld	ra,24(sp)
    80001aac:	6442                	ld	s0,16(sp)
    80001aae:	64a2                	ld	s1,8(sp)
    80001ab0:	6902                	ld	s2,0(sp)
    80001ab2:	6105                	addi	sp,sp,32
    80001ab4:	8082                	ret

0000000080001ab6 <freeproc>:
{
    80001ab6:	1101                	addi	sp,sp,-32
    80001ab8:	ec06                	sd	ra,24(sp)
    80001aba:	e822                	sd	s0,16(sp)
    80001abc:	e426                	sd	s1,8(sp)
    80001abe:	1000                	addi	s0,sp,32
    80001ac0:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001ac2:	6d28                	ld	a0,88(a0)
    80001ac4:	c119                	beqz	a0,80001aca <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001ac6:	f05fe0ef          	jal	ra,800009ca <kfree>
  p->trapframe = 0;
    80001aca:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001ace:	68a8                	ld	a0,80(s1)
    80001ad0:	c501                	beqz	a0,80001ad8 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001ad2:	64ac                	ld	a1,72(s1)
    80001ad4:	f9dff0ef          	jal	ra,80001a70 <proc_freepagetable>
  p->pagetable = 0;
    80001ad8:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001adc:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001ae0:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001ae4:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001ae8:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001aec:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001af0:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001af4:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001af8:	0004ac23          	sw	zero,24(s1)
}
    80001afc:	60e2                	ld	ra,24(sp)
    80001afe:	6442                	ld	s0,16(sp)
    80001b00:	64a2                	ld	s1,8(sp)
    80001b02:	6105                	addi	sp,sp,32
    80001b04:	8082                	ret

0000000080001b06 <allocproc>:
{
    80001b06:	1101                	addi	sp,sp,-32
    80001b08:	ec06                	sd	ra,24(sp)
    80001b0a:	e822                	sd	s0,16(sp)
    80001b0c:	e426                	sd	s1,8(sp)
    80001b0e:	e04a                	sd	s2,0(sp)
    80001b10:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b12:	0000e497          	auipc	s1,0xe
    80001b16:	5be48493          	addi	s1,s1,1470 # 800100d0 <proc>
    80001b1a:	00014917          	auipc	s2,0x14
    80001b1e:	fb690913          	addi	s2,s2,-74 # 80015ad0 <tickslock>
    acquire(&p->lock);
    80001b22:	8526                	mv	a0,s1
    80001b24:	882ff0ef          	jal	ra,80000ba6 <acquire>
    if(p->state == UNUSED) {
    80001b28:	4c9c                	lw	a5,24(s1)
    80001b2a:	cb91                	beqz	a5,80001b3e <allocproc+0x38>
      release(&p->lock);
    80001b2c:	8526                	mv	a0,s1
    80001b2e:	910ff0ef          	jal	ra,80000c3e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b32:	16848493          	addi	s1,s1,360
    80001b36:	ff2496e3          	bne	s1,s2,80001b22 <allocproc+0x1c>
  return 0;
    80001b3a:	4481                	li	s1,0
    80001b3c:	a089                	j	80001b7e <allocproc+0x78>
  p->pid = allocpid();
    80001b3e:	e71ff0ef          	jal	ra,800019ae <allocpid>
    80001b42:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b44:	4785                	li	a5,1
    80001b46:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001b48:	f4ffe0ef          	jal	ra,80000a96 <kalloc>
    80001b4c:	892a                	mv	s2,a0
    80001b4e:	eca8                	sd	a0,88(s1)
    80001b50:	cd15                	beqz	a0,80001b8c <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001b52:	8526                	mv	a0,s1
    80001b54:	e99ff0ef          	jal	ra,800019ec <proc_pagetable>
    80001b58:	892a                	mv	s2,a0
    80001b5a:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001b5c:	c121                	beqz	a0,80001b9c <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001b5e:	07000613          	li	a2,112
    80001b62:	4581                	li	a1,0
    80001b64:	06048513          	addi	a0,s1,96
    80001b68:	912ff0ef          	jal	ra,80000c7a <memset>
  p->context.ra = (uint64)forkret;
    80001b6c:	00000797          	auipc	a5,0x0
    80001b70:	e0878793          	addi	a5,a5,-504 # 80001974 <forkret>
    80001b74:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b76:	60bc                	ld	a5,64(s1)
    80001b78:	6705                	lui	a4,0x1
    80001b7a:	97ba                	add	a5,a5,a4
    80001b7c:	f4bc                	sd	a5,104(s1)
}
    80001b7e:	8526                	mv	a0,s1
    80001b80:	60e2                	ld	ra,24(sp)
    80001b82:	6442                	ld	s0,16(sp)
    80001b84:	64a2                	ld	s1,8(sp)
    80001b86:	6902                	ld	s2,0(sp)
    80001b88:	6105                	addi	sp,sp,32
    80001b8a:	8082                	ret
    freeproc(p);
    80001b8c:	8526                	mv	a0,s1
    80001b8e:	f29ff0ef          	jal	ra,80001ab6 <freeproc>
    release(&p->lock);
    80001b92:	8526                	mv	a0,s1
    80001b94:	8aaff0ef          	jal	ra,80000c3e <release>
    return 0;
    80001b98:	84ca                	mv	s1,s2
    80001b9a:	b7d5                	j	80001b7e <allocproc+0x78>
    freeproc(p);
    80001b9c:	8526                	mv	a0,s1
    80001b9e:	f19ff0ef          	jal	ra,80001ab6 <freeproc>
    release(&p->lock);
    80001ba2:	8526                	mv	a0,s1
    80001ba4:	89aff0ef          	jal	ra,80000c3e <release>
    return 0;
    80001ba8:	84ca                	mv	s1,s2
    80001baa:	bfd1                	j	80001b7e <allocproc+0x78>

0000000080001bac <userinit>:
{
    80001bac:	1101                	addi	sp,sp,-32
    80001bae:	ec06                	sd	ra,24(sp)
    80001bb0:	e822                	sd	s0,16(sp)
    80001bb2:	e426                	sd	s1,8(sp)
    80001bb4:	1000                	addi	s0,sp,32
  p = allocproc();
    80001bb6:	f51ff0ef          	jal	ra,80001b06 <allocproc>
    80001bba:	84aa                	mv	s1,a0
  initproc = p;
    80001bbc:	00006797          	auipc	a5,0x6
    80001bc0:	faa7b623          	sd	a0,-84(a5) # 80007b68 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001bc4:	03400613          	li	a2,52
    80001bc8:	00006597          	auipc	a1,0x6
    80001bcc:	f3858593          	addi	a1,a1,-200 # 80007b00 <initcode>
    80001bd0:	6928                	ld	a0,80(a0)
    80001bd2:	f80ff0ef          	jal	ra,80001352 <uvmfirst>
  p->sz = PGSIZE;
    80001bd6:	6785                	lui	a5,0x1
    80001bd8:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001bda:	6cb8                	ld	a4,88(s1)
    80001bdc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001be0:	6cb8                	ld	a4,88(s1)
    80001be2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001be4:	4641                	li	a2,16
    80001be6:	00005597          	auipc	a1,0x5
    80001bea:	75a58593          	addi	a1,a1,1882 # 80007340 <digits+0x308>
    80001bee:	15848513          	addi	a0,s1,344
    80001bf2:	9ceff0ef          	jal	ra,80000dc0 <safestrcpy>
  p->cwd = namei("/");
    80001bf6:	00005517          	auipc	a0,0x5
    80001bfa:	75a50513          	addi	a0,a0,1882 # 80007350 <digits+0x318>
    80001bfe:	641010ef          	jal	ra,80003a3e <namei>
    80001c02:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001c06:	478d                	li	a5,3
    80001c08:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001c0a:	8526                	mv	a0,s1
    80001c0c:	832ff0ef          	jal	ra,80000c3e <release>
}
    80001c10:	60e2                	ld	ra,24(sp)
    80001c12:	6442                	ld	s0,16(sp)
    80001c14:	64a2                	ld	s1,8(sp)
    80001c16:	6105                	addi	sp,sp,32
    80001c18:	8082                	ret

0000000080001c1a <growproc>:
{
    80001c1a:	1101                	addi	sp,sp,-32
    80001c1c:	ec06                	sd	ra,24(sp)
    80001c1e:	e822                	sd	s0,16(sp)
    80001c20:	e426                	sd	s1,8(sp)
    80001c22:	e04a                	sd	s2,0(sp)
    80001c24:	1000                	addi	s0,sp,32
    80001c26:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001c28:	d1dff0ef          	jal	ra,80001944 <myproc>
    80001c2c:	84aa                	mv	s1,a0
  sz = p->sz;
    80001c2e:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001c30:	01204c63          	bgtz	s2,80001c48 <growproc+0x2e>
  } else if(n < 0){
    80001c34:	02094463          	bltz	s2,80001c5c <growproc+0x42>
  p->sz = sz;
    80001c38:	e4ac                	sd	a1,72(s1)
  return 0;
    80001c3a:	4501                	li	a0,0
}
    80001c3c:	60e2                	ld	ra,24(sp)
    80001c3e:	6442                	ld	s0,16(sp)
    80001c40:	64a2                	ld	s1,8(sp)
    80001c42:	6902                	ld	s2,0(sp)
    80001c44:	6105                	addi	sp,sp,32
    80001c46:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c48:	4691                	li	a3,4
    80001c4a:	00b90633          	add	a2,s2,a1
    80001c4e:	6928                	ld	a0,80(a0)
    80001c50:	fa4ff0ef          	jal	ra,800013f4 <uvmalloc>
    80001c54:	85aa                	mv	a1,a0
    80001c56:	f16d                	bnez	a0,80001c38 <growproc+0x1e>
      return -1;
    80001c58:	557d                	li	a0,-1
    80001c5a:	b7cd                	j	80001c3c <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c5c:	00b90633          	add	a2,s2,a1
    80001c60:	6928                	ld	a0,80(a0)
    80001c62:	f4eff0ef          	jal	ra,800013b0 <uvmdealloc>
    80001c66:	85aa                	mv	a1,a0
    80001c68:	bfc1                	j	80001c38 <growproc+0x1e>

0000000080001c6a <fork>:
{
    80001c6a:	7139                	addi	sp,sp,-64
    80001c6c:	fc06                	sd	ra,56(sp)
    80001c6e:	f822                	sd	s0,48(sp)
    80001c70:	f426                	sd	s1,40(sp)
    80001c72:	f04a                	sd	s2,32(sp)
    80001c74:	ec4e                	sd	s3,24(sp)
    80001c76:	e852                	sd	s4,16(sp)
    80001c78:	e456                	sd	s5,8(sp)
    80001c7a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c7c:	cc9ff0ef          	jal	ra,80001944 <myproc>
    80001c80:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001c82:	e85ff0ef          	jal	ra,80001b06 <allocproc>
    80001c86:	0e050663          	beqz	a0,80001d72 <fork+0x108>
    80001c8a:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001c8c:	048ab603          	ld	a2,72(s5)
    80001c90:	692c                	ld	a1,80(a0)
    80001c92:	050ab503          	ld	a0,80(s5)
    80001c96:	887ff0ef          	jal	ra,8000151c <uvmcopy>
    80001c9a:	04054863          	bltz	a0,80001cea <fork+0x80>
  np->sz = p->sz;
    80001c9e:	048ab783          	ld	a5,72(s5)
    80001ca2:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001ca6:	058ab683          	ld	a3,88(s5)
    80001caa:	87b6                	mv	a5,a3
    80001cac:	058a3703          	ld	a4,88(s4)
    80001cb0:	12068693          	addi	a3,a3,288
    80001cb4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001cb8:	6788                	ld	a0,8(a5)
    80001cba:	6b8c                	ld	a1,16(a5)
    80001cbc:	6f90                	ld	a2,24(a5)
    80001cbe:	01073023          	sd	a6,0(a4)
    80001cc2:	e708                	sd	a0,8(a4)
    80001cc4:	eb0c                	sd	a1,16(a4)
    80001cc6:	ef10                	sd	a2,24(a4)
    80001cc8:	02078793          	addi	a5,a5,32
    80001ccc:	02070713          	addi	a4,a4,32
    80001cd0:	fed792e3          	bne	a5,a3,80001cb4 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001cd4:	058a3783          	ld	a5,88(s4)
    80001cd8:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001cdc:	0d0a8493          	addi	s1,s5,208
    80001ce0:	0d0a0913          	addi	s2,s4,208
    80001ce4:	150a8993          	addi	s3,s5,336
    80001ce8:	a829                	j	80001d02 <fork+0x98>
    freeproc(np);
    80001cea:	8552                	mv	a0,s4
    80001cec:	dcbff0ef          	jal	ra,80001ab6 <freeproc>
    release(&np->lock);
    80001cf0:	8552                	mv	a0,s4
    80001cf2:	f4dfe0ef          	jal	ra,80000c3e <release>
    return -1;
    80001cf6:	597d                	li	s2,-1
    80001cf8:	a09d                	j	80001d5e <fork+0xf4>
  for(i = 0; i < NOFILE; i++)
    80001cfa:	04a1                	addi	s1,s1,8
    80001cfc:	0921                	addi	s2,s2,8
    80001cfe:	01348963          	beq	s1,s3,80001d10 <fork+0xa6>
    if(p->ofile[i])
    80001d02:	6088                	ld	a0,0(s1)
    80001d04:	d97d                	beqz	a0,80001cfa <fork+0x90>
      np->ofile[i] = filedup(p->ofile[i]);
    80001d06:	2e6020ef          	jal	ra,80003fec <filedup>
    80001d0a:	00a93023          	sd	a0,0(s2)
    80001d0e:	b7f5                	j	80001cfa <fork+0x90>
  np->cwd = idup(p->cwd);
    80001d10:	150ab503          	ld	a0,336(s5)
    80001d14:	642010ef          	jal	ra,80003356 <idup>
    80001d18:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001d1c:	4641                	li	a2,16
    80001d1e:	158a8593          	addi	a1,s5,344
    80001d22:	158a0513          	addi	a0,s4,344
    80001d26:	89aff0ef          	jal	ra,80000dc0 <safestrcpy>
  pid = np->pid;
    80001d2a:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001d2e:	8552                	mv	a0,s4
    80001d30:	f0ffe0ef          	jal	ra,80000c3e <release>
  acquire(&wait_lock);
    80001d34:	0000e497          	auipc	s1,0xe
    80001d38:	f8448493          	addi	s1,s1,-124 # 8000fcb8 <wait_lock>
    80001d3c:	8526                	mv	a0,s1
    80001d3e:	e69fe0ef          	jal	ra,80000ba6 <acquire>
  np->parent = p;
    80001d42:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001d46:	8526                	mv	a0,s1
    80001d48:	ef7fe0ef          	jal	ra,80000c3e <release>
  acquire(&np->lock);
    80001d4c:	8552                	mv	a0,s4
    80001d4e:	e59fe0ef          	jal	ra,80000ba6 <acquire>
  np->state = RUNNABLE;
    80001d52:	478d                	li	a5,3
    80001d54:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001d58:	8552                	mv	a0,s4
    80001d5a:	ee5fe0ef          	jal	ra,80000c3e <release>
}
    80001d5e:	854a                	mv	a0,s2
    80001d60:	70e2                	ld	ra,56(sp)
    80001d62:	7442                	ld	s0,48(sp)
    80001d64:	74a2                	ld	s1,40(sp)
    80001d66:	7902                	ld	s2,32(sp)
    80001d68:	69e2                	ld	s3,24(sp)
    80001d6a:	6a42                	ld	s4,16(sp)
    80001d6c:	6aa2                	ld	s5,8(sp)
    80001d6e:	6121                	addi	sp,sp,64
    80001d70:	8082                	ret
    return -1;
    80001d72:	597d                	li	s2,-1
    80001d74:	b7ed                	j	80001d5e <fork+0xf4>

0000000080001d76 <scheduler>:
{
    80001d76:	715d                	addi	sp,sp,-80
    80001d78:	e486                	sd	ra,72(sp)
    80001d7a:	e0a2                	sd	s0,64(sp)
    80001d7c:	fc26                	sd	s1,56(sp)
    80001d7e:	f84a                	sd	s2,48(sp)
    80001d80:	f44e                	sd	s3,40(sp)
    80001d82:	f052                	sd	s4,32(sp)
    80001d84:	ec56                	sd	s5,24(sp)
    80001d86:	e85a                	sd	s6,16(sp)
    80001d88:	e45e                	sd	s7,8(sp)
    80001d8a:	e062                	sd	s8,0(sp)
    80001d8c:	0880                	addi	s0,sp,80
    80001d8e:	8792                	mv	a5,tp
  int id = r_tp();
    80001d90:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d92:	00779b13          	slli	s6,a5,0x7
    80001d96:	0000e717          	auipc	a4,0xe
    80001d9a:	f0a70713          	addi	a4,a4,-246 # 8000fca0 <pid_lock>
    80001d9e:	975a                	add	a4,a4,s6
    80001da0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001da4:	0000e717          	auipc	a4,0xe
    80001da8:	f3470713          	addi	a4,a4,-204 # 8000fcd8 <cpus+0x8>
    80001dac:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001dae:	4c11                	li	s8,4
        c->proc = p;
    80001db0:	079e                	slli	a5,a5,0x7
    80001db2:	0000ea17          	auipc	s4,0xe
    80001db6:	eeea0a13          	addi	s4,s4,-274 # 8000fca0 <pid_lock>
    80001dba:	9a3e                	add	s4,s4,a5
        found = 1;
    80001dbc:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001dbe:	00014997          	auipc	s3,0x14
    80001dc2:	d1298993          	addi	s3,s3,-750 # 80015ad0 <tickslock>
    80001dc6:	a0a9                	j	80001e10 <scheduler+0x9a>
      release(&p->lock);
    80001dc8:	8526                	mv	a0,s1
    80001dca:	e75fe0ef          	jal	ra,80000c3e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001dce:	16848493          	addi	s1,s1,360
    80001dd2:	03348563          	beq	s1,s3,80001dfc <scheduler+0x86>
      acquire(&p->lock);
    80001dd6:	8526                	mv	a0,s1
    80001dd8:	dcffe0ef          	jal	ra,80000ba6 <acquire>
      if(p->state == RUNNABLE) {
    80001ddc:	4c9c                	lw	a5,24(s1)
    80001dde:	ff2795e3          	bne	a5,s2,80001dc8 <scheduler+0x52>
        p->state = RUNNING;
    80001de2:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001de6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001dea:	06048593          	addi	a1,s1,96
    80001dee:	855a                	mv	a0,s6
    80001df0:	658000ef          	jal	ra,80002448 <swtch>
        c->proc = 0;
    80001df4:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001df8:	8ade                	mv	s5,s7
    80001dfa:	b7f9                	j	80001dc8 <scheduler+0x52>
    if(found == 0) {
    80001dfc:	000a9a63          	bnez	s5,80001e10 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e00:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e04:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e08:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001e0c:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e10:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e14:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e18:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001e1c:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e1e:	0000e497          	auipc	s1,0xe
    80001e22:	2b248493          	addi	s1,s1,690 # 800100d0 <proc>
      if(p->state == RUNNABLE) {
    80001e26:	490d                	li	s2,3
    80001e28:	b77d                	j	80001dd6 <scheduler+0x60>

0000000080001e2a <sched>:
{
    80001e2a:	7179                	addi	sp,sp,-48
    80001e2c:	f406                	sd	ra,40(sp)
    80001e2e:	f022                	sd	s0,32(sp)
    80001e30:	ec26                	sd	s1,24(sp)
    80001e32:	e84a                	sd	s2,16(sp)
    80001e34:	e44e                	sd	s3,8(sp)
    80001e36:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e38:	b0dff0ef          	jal	ra,80001944 <myproc>
    80001e3c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001e3e:	cfffe0ef          	jal	ra,80000b3c <holding>
    80001e42:	c92d                	beqz	a0,80001eb4 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e44:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001e46:	2781                	sext.w	a5,a5
    80001e48:	079e                	slli	a5,a5,0x7
    80001e4a:	0000e717          	auipc	a4,0xe
    80001e4e:	e5670713          	addi	a4,a4,-426 # 8000fca0 <pid_lock>
    80001e52:	97ba                	add	a5,a5,a4
    80001e54:	0a87a703          	lw	a4,168(a5)
    80001e58:	4785                	li	a5,1
    80001e5a:	06f71363          	bne	a4,a5,80001ec0 <sched+0x96>
  if(p->state == RUNNING)
    80001e5e:	4c98                	lw	a4,24(s1)
    80001e60:	4791                	li	a5,4
    80001e62:	06f70563          	beq	a4,a5,80001ecc <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e66:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e6a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e6c:	e7b5                	bnez	a5,80001ed8 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e6e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e70:	0000e917          	auipc	s2,0xe
    80001e74:	e3090913          	addi	s2,s2,-464 # 8000fca0 <pid_lock>
    80001e78:	2781                	sext.w	a5,a5
    80001e7a:	079e                	slli	a5,a5,0x7
    80001e7c:	97ca                	add	a5,a5,s2
    80001e7e:	0ac7a983          	lw	s3,172(a5)
    80001e82:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e84:	2781                	sext.w	a5,a5
    80001e86:	079e                	slli	a5,a5,0x7
    80001e88:	0000e597          	auipc	a1,0xe
    80001e8c:	e5058593          	addi	a1,a1,-432 # 8000fcd8 <cpus+0x8>
    80001e90:	95be                	add	a1,a1,a5
    80001e92:	06048513          	addi	a0,s1,96
    80001e96:	5b2000ef          	jal	ra,80002448 <swtch>
    80001e9a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001e9c:	2781                	sext.w	a5,a5
    80001e9e:	079e                	slli	a5,a5,0x7
    80001ea0:	97ca                	add	a5,a5,s2
    80001ea2:	0b37a623          	sw	s3,172(a5)
}
    80001ea6:	70a2                	ld	ra,40(sp)
    80001ea8:	7402                	ld	s0,32(sp)
    80001eaa:	64e2                	ld	s1,24(sp)
    80001eac:	6942                	ld	s2,16(sp)
    80001eae:	69a2                	ld	s3,8(sp)
    80001eb0:	6145                	addi	sp,sp,48
    80001eb2:	8082                	ret
    panic("sched p->lock");
    80001eb4:	00005517          	auipc	a0,0x5
    80001eb8:	4a450513          	addi	a0,a0,1188 # 80007358 <digits+0x320>
    80001ebc:	87bfe0ef          	jal	ra,80000736 <panic>
    panic("sched locks");
    80001ec0:	00005517          	auipc	a0,0x5
    80001ec4:	4a850513          	addi	a0,a0,1192 # 80007368 <digits+0x330>
    80001ec8:	86ffe0ef          	jal	ra,80000736 <panic>
    panic("sched running");
    80001ecc:	00005517          	auipc	a0,0x5
    80001ed0:	4ac50513          	addi	a0,a0,1196 # 80007378 <digits+0x340>
    80001ed4:	863fe0ef          	jal	ra,80000736 <panic>
    panic("sched interruptible");
    80001ed8:	00005517          	auipc	a0,0x5
    80001edc:	4b050513          	addi	a0,a0,1200 # 80007388 <digits+0x350>
    80001ee0:	857fe0ef          	jal	ra,80000736 <panic>

0000000080001ee4 <yield>:
{
    80001ee4:	1101                	addi	sp,sp,-32
    80001ee6:	ec06                	sd	ra,24(sp)
    80001ee8:	e822                	sd	s0,16(sp)
    80001eea:	e426                	sd	s1,8(sp)
    80001eec:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001eee:	a57ff0ef          	jal	ra,80001944 <myproc>
    80001ef2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001ef4:	cb3fe0ef          	jal	ra,80000ba6 <acquire>
  p->state = RUNNABLE;
    80001ef8:	478d                	li	a5,3
    80001efa:	cc9c                	sw	a5,24(s1)
  sched();
    80001efc:	f2fff0ef          	jal	ra,80001e2a <sched>
  release(&p->lock);
    80001f00:	8526                	mv	a0,s1
    80001f02:	d3dfe0ef          	jal	ra,80000c3e <release>
}
    80001f06:	60e2                	ld	ra,24(sp)
    80001f08:	6442                	ld	s0,16(sp)
    80001f0a:	64a2                	ld	s1,8(sp)
    80001f0c:	6105                	addi	sp,sp,32
    80001f0e:	8082                	ret

0000000080001f10 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001f10:	7179                	addi	sp,sp,-48
    80001f12:	f406                	sd	ra,40(sp)
    80001f14:	f022                	sd	s0,32(sp)
    80001f16:	ec26                	sd	s1,24(sp)
    80001f18:	e84a                	sd	s2,16(sp)
    80001f1a:	e44e                	sd	s3,8(sp)
    80001f1c:	1800                	addi	s0,sp,48
    80001f1e:	89aa                	mv	s3,a0
    80001f20:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f22:	a23ff0ef          	jal	ra,80001944 <myproc>
    80001f26:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001f28:	c7ffe0ef          	jal	ra,80000ba6 <acquire>
  release(lk);
    80001f2c:	854a                	mv	a0,s2
    80001f2e:	d11fe0ef          	jal	ra,80000c3e <release>

  // Go to sleep.
  p->chan = chan;
    80001f32:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001f36:	4789                	li	a5,2
    80001f38:	cc9c                	sw	a5,24(s1)

  sched();
    80001f3a:	ef1ff0ef          	jal	ra,80001e2a <sched>

  // Tidy up.
  p->chan = 0;
    80001f3e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001f42:	8526                	mv	a0,s1
    80001f44:	cfbfe0ef          	jal	ra,80000c3e <release>
  acquire(lk);
    80001f48:	854a                	mv	a0,s2
    80001f4a:	c5dfe0ef          	jal	ra,80000ba6 <acquire>
}
    80001f4e:	70a2                	ld	ra,40(sp)
    80001f50:	7402                	ld	s0,32(sp)
    80001f52:	64e2                	ld	s1,24(sp)
    80001f54:	6942                	ld	s2,16(sp)
    80001f56:	69a2                	ld	s3,8(sp)
    80001f58:	6145                	addi	sp,sp,48
    80001f5a:	8082                	ret

0000000080001f5c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001f5c:	7139                	addi	sp,sp,-64
    80001f5e:	fc06                	sd	ra,56(sp)
    80001f60:	f822                	sd	s0,48(sp)
    80001f62:	f426                	sd	s1,40(sp)
    80001f64:	f04a                	sd	s2,32(sp)
    80001f66:	ec4e                	sd	s3,24(sp)
    80001f68:	e852                	sd	s4,16(sp)
    80001f6a:	e456                	sd	s5,8(sp)
    80001f6c:	0080                	addi	s0,sp,64
    80001f6e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001f70:	0000e497          	auipc	s1,0xe
    80001f74:	16048493          	addi	s1,s1,352 # 800100d0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001f78:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001f7a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f7c:	00014917          	auipc	s2,0x14
    80001f80:	b5490913          	addi	s2,s2,-1196 # 80015ad0 <tickslock>
    80001f84:	a801                	j	80001f94 <wakeup+0x38>
      }
      release(&p->lock);
    80001f86:	8526                	mv	a0,s1
    80001f88:	cb7fe0ef          	jal	ra,80000c3e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f8c:	16848493          	addi	s1,s1,360
    80001f90:	03248263          	beq	s1,s2,80001fb4 <wakeup+0x58>
    if(p != myproc()){
    80001f94:	9b1ff0ef          	jal	ra,80001944 <myproc>
    80001f98:	fea48ae3          	beq	s1,a0,80001f8c <wakeup+0x30>
      acquire(&p->lock);
    80001f9c:	8526                	mv	a0,s1
    80001f9e:	c09fe0ef          	jal	ra,80000ba6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001fa2:	4c9c                	lw	a5,24(s1)
    80001fa4:	ff3791e3          	bne	a5,s3,80001f86 <wakeup+0x2a>
    80001fa8:	709c                	ld	a5,32(s1)
    80001faa:	fd479ee3          	bne	a5,s4,80001f86 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001fae:	0154ac23          	sw	s5,24(s1)
    80001fb2:	bfd1                	j	80001f86 <wakeup+0x2a>
    }
  }
}
    80001fb4:	70e2                	ld	ra,56(sp)
    80001fb6:	7442                	ld	s0,48(sp)
    80001fb8:	74a2                	ld	s1,40(sp)
    80001fba:	7902                	ld	s2,32(sp)
    80001fbc:	69e2                	ld	s3,24(sp)
    80001fbe:	6a42                	ld	s4,16(sp)
    80001fc0:	6aa2                	ld	s5,8(sp)
    80001fc2:	6121                	addi	sp,sp,64
    80001fc4:	8082                	ret

0000000080001fc6 <reparent>:
{
    80001fc6:	7179                	addi	sp,sp,-48
    80001fc8:	f406                	sd	ra,40(sp)
    80001fca:	f022                	sd	s0,32(sp)
    80001fcc:	ec26                	sd	s1,24(sp)
    80001fce:	e84a                	sd	s2,16(sp)
    80001fd0:	e44e                	sd	s3,8(sp)
    80001fd2:	e052                	sd	s4,0(sp)
    80001fd4:	1800                	addi	s0,sp,48
    80001fd6:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001fd8:	0000e497          	auipc	s1,0xe
    80001fdc:	0f848493          	addi	s1,s1,248 # 800100d0 <proc>
      pp->parent = initproc;
    80001fe0:	00006a17          	auipc	s4,0x6
    80001fe4:	b88a0a13          	addi	s4,s4,-1144 # 80007b68 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001fe8:	00014997          	auipc	s3,0x14
    80001fec:	ae898993          	addi	s3,s3,-1304 # 80015ad0 <tickslock>
    80001ff0:	a029                	j	80001ffa <reparent+0x34>
    80001ff2:	16848493          	addi	s1,s1,360
    80001ff6:	01348b63          	beq	s1,s3,8000200c <reparent+0x46>
    if(pp->parent == p){
    80001ffa:	7c9c                	ld	a5,56(s1)
    80001ffc:	ff279be3          	bne	a5,s2,80001ff2 <reparent+0x2c>
      pp->parent = initproc;
    80002000:	000a3503          	ld	a0,0(s4)
    80002004:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002006:	f57ff0ef          	jal	ra,80001f5c <wakeup>
    8000200a:	b7e5                	j	80001ff2 <reparent+0x2c>
}
    8000200c:	70a2                	ld	ra,40(sp)
    8000200e:	7402                	ld	s0,32(sp)
    80002010:	64e2                	ld	s1,24(sp)
    80002012:	6942                	ld	s2,16(sp)
    80002014:	69a2                	ld	s3,8(sp)
    80002016:	6a02                	ld	s4,0(sp)
    80002018:	6145                	addi	sp,sp,48
    8000201a:	8082                	ret

000000008000201c <exit>:
{
    8000201c:	7179                	addi	sp,sp,-48
    8000201e:	f406                	sd	ra,40(sp)
    80002020:	f022                	sd	s0,32(sp)
    80002022:	ec26                	sd	s1,24(sp)
    80002024:	e84a                	sd	s2,16(sp)
    80002026:	e44e                	sd	s3,8(sp)
    80002028:	e052                	sd	s4,0(sp)
    8000202a:	1800                	addi	s0,sp,48
    8000202c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000202e:	917ff0ef          	jal	ra,80001944 <myproc>
    80002032:	89aa                	mv	s3,a0
  if(p == initproc)
    80002034:	00006797          	auipc	a5,0x6
    80002038:	b347b783          	ld	a5,-1228(a5) # 80007b68 <initproc>
    8000203c:	0d050493          	addi	s1,a0,208
    80002040:	15050913          	addi	s2,a0,336
    80002044:	00a79f63          	bne	a5,a0,80002062 <exit+0x46>
    panic("init exiting");
    80002048:	00005517          	auipc	a0,0x5
    8000204c:	35850513          	addi	a0,a0,856 # 800073a0 <digits+0x368>
    80002050:	ee6fe0ef          	jal	ra,80000736 <panic>
      fileclose(f);
    80002054:	7df010ef          	jal	ra,80004032 <fileclose>
      p->ofile[fd] = 0;
    80002058:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000205c:	04a1                	addi	s1,s1,8
    8000205e:	01248563          	beq	s1,s2,80002068 <exit+0x4c>
    if(p->ofile[fd]){
    80002062:	6088                	ld	a0,0(s1)
    80002064:	f965                	bnez	a0,80002054 <exit+0x38>
    80002066:	bfdd                	j	8000205c <exit+0x40>
  begin_op();
    80002068:	3af010ef          	jal	ra,80003c16 <begin_op>
  iput(p->cwd);
    8000206c:	1509b503          	ld	a0,336(s3)
    80002070:	49a010ef          	jal	ra,8000350a <iput>
  end_op();
    80002074:	413010ef          	jal	ra,80003c86 <end_op>
  p->cwd = 0;
    80002078:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000207c:	0000e497          	auipc	s1,0xe
    80002080:	c3c48493          	addi	s1,s1,-964 # 8000fcb8 <wait_lock>
    80002084:	8526                	mv	a0,s1
    80002086:	b21fe0ef          	jal	ra,80000ba6 <acquire>
  reparent(p);
    8000208a:	854e                	mv	a0,s3
    8000208c:	f3bff0ef          	jal	ra,80001fc6 <reparent>
  wakeup(p->parent);
    80002090:	0389b503          	ld	a0,56(s3)
    80002094:	ec9ff0ef          	jal	ra,80001f5c <wakeup>
  acquire(&p->lock);
    80002098:	854e                	mv	a0,s3
    8000209a:	b0dfe0ef          	jal	ra,80000ba6 <acquire>
  p->xstate = status;
    8000209e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800020a2:	4795                	li	a5,5
    800020a4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800020a8:	8526                	mv	a0,s1
    800020aa:	b95fe0ef          	jal	ra,80000c3e <release>
  sched();
    800020ae:	d7dff0ef          	jal	ra,80001e2a <sched>
  panic("zombie exit");
    800020b2:	00005517          	auipc	a0,0x5
    800020b6:	2fe50513          	addi	a0,a0,766 # 800073b0 <digits+0x378>
    800020ba:	e7cfe0ef          	jal	ra,80000736 <panic>

00000000800020be <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800020be:	7179                	addi	sp,sp,-48
    800020c0:	f406                	sd	ra,40(sp)
    800020c2:	f022                	sd	s0,32(sp)
    800020c4:	ec26                	sd	s1,24(sp)
    800020c6:	e84a                	sd	s2,16(sp)
    800020c8:	e44e                	sd	s3,8(sp)
    800020ca:	1800                	addi	s0,sp,48
    800020cc:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800020ce:	0000e497          	auipc	s1,0xe
    800020d2:	00248493          	addi	s1,s1,2 # 800100d0 <proc>
    800020d6:	00014997          	auipc	s3,0x14
    800020da:	9fa98993          	addi	s3,s3,-1542 # 80015ad0 <tickslock>
    acquire(&p->lock);
    800020de:	8526                	mv	a0,s1
    800020e0:	ac7fe0ef          	jal	ra,80000ba6 <acquire>
    if(p->pid == pid){
    800020e4:	589c                	lw	a5,48(s1)
    800020e6:	01278b63          	beq	a5,s2,800020fc <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800020ea:	8526                	mv	a0,s1
    800020ec:	b53fe0ef          	jal	ra,80000c3e <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800020f0:	16848493          	addi	s1,s1,360
    800020f4:	ff3495e3          	bne	s1,s3,800020de <kill+0x20>
  }
  return -1;
    800020f8:	557d                	li	a0,-1
    800020fa:	a819                	j	80002110 <kill+0x52>
      p->killed = 1;
    800020fc:	4785                	li	a5,1
    800020fe:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002100:	4c98                	lw	a4,24(s1)
    80002102:	4789                	li	a5,2
    80002104:	00f70d63          	beq	a4,a5,8000211e <kill+0x60>
      release(&p->lock);
    80002108:	8526                	mv	a0,s1
    8000210a:	b35fe0ef          	jal	ra,80000c3e <release>
      return 0;
    8000210e:	4501                	li	a0,0
}
    80002110:	70a2                	ld	ra,40(sp)
    80002112:	7402                	ld	s0,32(sp)
    80002114:	64e2                	ld	s1,24(sp)
    80002116:	6942                	ld	s2,16(sp)
    80002118:	69a2                	ld	s3,8(sp)
    8000211a:	6145                	addi	sp,sp,48
    8000211c:	8082                	ret
        p->state = RUNNABLE;
    8000211e:	478d                	li	a5,3
    80002120:	cc9c                	sw	a5,24(s1)
    80002122:	b7dd                	j	80002108 <kill+0x4a>

0000000080002124 <setkilled>:

void
setkilled(struct proc *p)
{
    80002124:	1101                	addi	sp,sp,-32
    80002126:	ec06                	sd	ra,24(sp)
    80002128:	e822                	sd	s0,16(sp)
    8000212a:	e426                	sd	s1,8(sp)
    8000212c:	1000                	addi	s0,sp,32
    8000212e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002130:	a77fe0ef          	jal	ra,80000ba6 <acquire>
  p->killed = 1;
    80002134:	4785                	li	a5,1
    80002136:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002138:	8526                	mv	a0,s1
    8000213a:	b05fe0ef          	jal	ra,80000c3e <release>
}
    8000213e:	60e2                	ld	ra,24(sp)
    80002140:	6442                	ld	s0,16(sp)
    80002142:	64a2                	ld	s1,8(sp)
    80002144:	6105                	addi	sp,sp,32
    80002146:	8082                	ret

0000000080002148 <killed>:

int
killed(struct proc *p)
{
    80002148:	1101                	addi	sp,sp,-32
    8000214a:	ec06                	sd	ra,24(sp)
    8000214c:	e822                	sd	s0,16(sp)
    8000214e:	e426                	sd	s1,8(sp)
    80002150:	e04a                	sd	s2,0(sp)
    80002152:	1000                	addi	s0,sp,32
    80002154:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002156:	a51fe0ef          	jal	ra,80000ba6 <acquire>
  k = p->killed;
    8000215a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000215e:	8526                	mv	a0,s1
    80002160:	adffe0ef          	jal	ra,80000c3e <release>
  return k;
}
    80002164:	854a                	mv	a0,s2
    80002166:	60e2                	ld	ra,24(sp)
    80002168:	6442                	ld	s0,16(sp)
    8000216a:	64a2                	ld	s1,8(sp)
    8000216c:	6902                	ld	s2,0(sp)
    8000216e:	6105                	addi	sp,sp,32
    80002170:	8082                	ret

0000000080002172 <wait>:
{
    80002172:	715d                	addi	sp,sp,-80
    80002174:	e486                	sd	ra,72(sp)
    80002176:	e0a2                	sd	s0,64(sp)
    80002178:	fc26                	sd	s1,56(sp)
    8000217a:	f84a                	sd	s2,48(sp)
    8000217c:	f44e                	sd	s3,40(sp)
    8000217e:	f052                	sd	s4,32(sp)
    80002180:	ec56                	sd	s5,24(sp)
    80002182:	e85a                	sd	s6,16(sp)
    80002184:	e45e                	sd	s7,8(sp)
    80002186:	e062                	sd	s8,0(sp)
    80002188:	0880                	addi	s0,sp,80
    8000218a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000218c:	fb8ff0ef          	jal	ra,80001944 <myproc>
    80002190:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002192:	0000e517          	auipc	a0,0xe
    80002196:	b2650513          	addi	a0,a0,-1242 # 8000fcb8 <wait_lock>
    8000219a:	a0dfe0ef          	jal	ra,80000ba6 <acquire>
    havekids = 0;
    8000219e:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800021a0:	4a15                	li	s4,5
        havekids = 1;
    800021a2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021a4:	00014997          	auipc	s3,0x14
    800021a8:	92c98993          	addi	s3,s3,-1748 # 80015ad0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800021ac:	0000ec17          	auipc	s8,0xe
    800021b0:	b0cc0c13          	addi	s8,s8,-1268 # 8000fcb8 <wait_lock>
    havekids = 0;
    800021b4:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021b6:	0000e497          	auipc	s1,0xe
    800021ba:	f1a48493          	addi	s1,s1,-230 # 800100d0 <proc>
    800021be:	a899                	j	80002214 <wait+0xa2>
          pid = pp->pid;
    800021c0:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800021c4:	000b0c63          	beqz	s6,800021dc <wait+0x6a>
    800021c8:	4691                	li	a3,4
    800021ca:	02c48613          	addi	a2,s1,44
    800021ce:	85da                	mv	a1,s6
    800021d0:	05093503          	ld	a0,80(s2)
    800021d4:	c24ff0ef          	jal	ra,800015f8 <copyout>
    800021d8:	00054f63          	bltz	a0,800021f6 <wait+0x84>
          freeproc(pp);
    800021dc:	8526                	mv	a0,s1
    800021de:	8d9ff0ef          	jal	ra,80001ab6 <freeproc>
          release(&pp->lock);
    800021e2:	8526                	mv	a0,s1
    800021e4:	a5bfe0ef          	jal	ra,80000c3e <release>
          release(&wait_lock);
    800021e8:	0000e517          	auipc	a0,0xe
    800021ec:	ad050513          	addi	a0,a0,-1328 # 8000fcb8 <wait_lock>
    800021f0:	a4ffe0ef          	jal	ra,80000c3e <release>
          return pid;
    800021f4:	a891                	j	80002248 <wait+0xd6>
            release(&pp->lock);
    800021f6:	8526                	mv	a0,s1
    800021f8:	a47fe0ef          	jal	ra,80000c3e <release>
            release(&wait_lock);
    800021fc:	0000e517          	auipc	a0,0xe
    80002200:	abc50513          	addi	a0,a0,-1348 # 8000fcb8 <wait_lock>
    80002204:	a3bfe0ef          	jal	ra,80000c3e <release>
            return -1;
    80002208:	59fd                	li	s3,-1
    8000220a:	a83d                	j	80002248 <wait+0xd6>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000220c:	16848493          	addi	s1,s1,360
    80002210:	03348063          	beq	s1,s3,80002230 <wait+0xbe>
      if(pp->parent == p){
    80002214:	7c9c                	ld	a5,56(s1)
    80002216:	ff279be3          	bne	a5,s2,8000220c <wait+0x9a>
        acquire(&pp->lock);
    8000221a:	8526                	mv	a0,s1
    8000221c:	98bfe0ef          	jal	ra,80000ba6 <acquire>
        if(pp->state == ZOMBIE){
    80002220:	4c9c                	lw	a5,24(s1)
    80002222:	f9478fe3          	beq	a5,s4,800021c0 <wait+0x4e>
        release(&pp->lock);
    80002226:	8526                	mv	a0,s1
    80002228:	a17fe0ef          	jal	ra,80000c3e <release>
        havekids = 1;
    8000222c:	8756                	mv	a4,s5
    8000222e:	bff9                	j	8000220c <wait+0x9a>
    if(!havekids || killed(p)){
    80002230:	c709                	beqz	a4,8000223a <wait+0xc8>
    80002232:	854a                	mv	a0,s2
    80002234:	f15ff0ef          	jal	ra,80002148 <killed>
    80002238:	c50d                	beqz	a0,80002262 <wait+0xf0>
      release(&wait_lock);
    8000223a:	0000e517          	auipc	a0,0xe
    8000223e:	a7e50513          	addi	a0,a0,-1410 # 8000fcb8 <wait_lock>
    80002242:	9fdfe0ef          	jal	ra,80000c3e <release>
      return -1;
    80002246:	59fd                	li	s3,-1
}
    80002248:	854e                	mv	a0,s3
    8000224a:	60a6                	ld	ra,72(sp)
    8000224c:	6406                	ld	s0,64(sp)
    8000224e:	74e2                	ld	s1,56(sp)
    80002250:	7942                	ld	s2,48(sp)
    80002252:	79a2                	ld	s3,40(sp)
    80002254:	7a02                	ld	s4,32(sp)
    80002256:	6ae2                	ld	s5,24(sp)
    80002258:	6b42                	ld	s6,16(sp)
    8000225a:	6ba2                	ld	s7,8(sp)
    8000225c:	6c02                	ld	s8,0(sp)
    8000225e:	6161                	addi	sp,sp,80
    80002260:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002262:	85e2                	mv	a1,s8
    80002264:	854a                	mv	a0,s2
    80002266:	cabff0ef          	jal	ra,80001f10 <sleep>
    havekids = 0;
    8000226a:	b7a9                	j	800021b4 <wait+0x42>

000000008000226c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000226c:	7179                	addi	sp,sp,-48
    8000226e:	f406                	sd	ra,40(sp)
    80002270:	f022                	sd	s0,32(sp)
    80002272:	ec26                	sd	s1,24(sp)
    80002274:	e84a                	sd	s2,16(sp)
    80002276:	e44e                	sd	s3,8(sp)
    80002278:	e052                	sd	s4,0(sp)
    8000227a:	1800                	addi	s0,sp,48
    8000227c:	84aa                	mv	s1,a0
    8000227e:	892e                	mv	s2,a1
    80002280:	89b2                	mv	s3,a2
    80002282:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002284:	ec0ff0ef          	jal	ra,80001944 <myproc>
  if(user_dst){
    80002288:	cc99                	beqz	s1,800022a6 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000228a:	86d2                	mv	a3,s4
    8000228c:	864e                	mv	a2,s3
    8000228e:	85ca                	mv	a1,s2
    80002290:	6928                	ld	a0,80(a0)
    80002292:	b66ff0ef          	jal	ra,800015f8 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002296:	70a2                	ld	ra,40(sp)
    80002298:	7402                	ld	s0,32(sp)
    8000229a:	64e2                	ld	s1,24(sp)
    8000229c:	6942                	ld	s2,16(sp)
    8000229e:	69a2                	ld	s3,8(sp)
    800022a0:	6a02                	ld	s4,0(sp)
    800022a2:	6145                	addi	sp,sp,48
    800022a4:	8082                	ret
    memmove((char *)dst, src, len);
    800022a6:	000a061b          	sext.w	a2,s4
    800022aa:	85ce                	mv	a1,s3
    800022ac:	854a                	mv	a0,s2
    800022ae:	a29fe0ef          	jal	ra,80000cd6 <memmove>
    return 0;
    800022b2:	8526                	mv	a0,s1
    800022b4:	b7cd                	j	80002296 <either_copyout+0x2a>

00000000800022b6 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800022b6:	7179                	addi	sp,sp,-48
    800022b8:	f406                	sd	ra,40(sp)
    800022ba:	f022                	sd	s0,32(sp)
    800022bc:	ec26                	sd	s1,24(sp)
    800022be:	e84a                	sd	s2,16(sp)
    800022c0:	e44e                	sd	s3,8(sp)
    800022c2:	e052                	sd	s4,0(sp)
    800022c4:	1800                	addi	s0,sp,48
    800022c6:	892a                	mv	s2,a0
    800022c8:	84ae                	mv	s1,a1
    800022ca:	89b2                	mv	s3,a2
    800022cc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800022ce:	e76ff0ef          	jal	ra,80001944 <myproc>
  if(user_src){
    800022d2:	cc99                	beqz	s1,800022f0 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800022d4:	86d2                	mv	a3,s4
    800022d6:	864e                	mv	a2,s3
    800022d8:	85ca                	mv	a1,s2
    800022da:	6928                	ld	a0,80(a0)
    800022dc:	bd4ff0ef          	jal	ra,800016b0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800022e0:	70a2                	ld	ra,40(sp)
    800022e2:	7402                	ld	s0,32(sp)
    800022e4:	64e2                	ld	s1,24(sp)
    800022e6:	6942                	ld	s2,16(sp)
    800022e8:	69a2                	ld	s3,8(sp)
    800022ea:	6a02                	ld	s4,0(sp)
    800022ec:	6145                	addi	sp,sp,48
    800022ee:	8082                	ret
    memmove(dst, (char*)src, len);
    800022f0:	000a061b          	sext.w	a2,s4
    800022f4:	85ce                	mv	a1,s3
    800022f6:	854a                	mv	a0,s2
    800022f8:	9dffe0ef          	jal	ra,80000cd6 <memmove>
    return 0;
    800022fc:	8526                	mv	a0,s1
    800022fe:	b7cd                	j	800022e0 <either_copyin+0x2a>

0000000080002300 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002300:	715d                	addi	sp,sp,-80
    80002302:	e486                	sd	ra,72(sp)
    80002304:	e0a2                	sd	s0,64(sp)
    80002306:	fc26                	sd	s1,56(sp)
    80002308:	f84a                	sd	s2,48(sp)
    8000230a:	f44e                	sd	s3,40(sp)
    8000230c:	f052                	sd	s4,32(sp)
    8000230e:	ec56                	sd	s5,24(sp)
    80002310:	e85a                	sd	s6,16(sp)
    80002312:	e45e                	sd	s7,8(sp)
    80002314:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002316:	00005517          	auipc	a0,0x5
    8000231a:	dea50513          	addi	a0,a0,-534 # 80007100 <digits+0xc8>
    8000231e:	964fe0ef          	jal	ra,80000482 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002322:	0000e497          	auipc	s1,0xe
    80002326:	f0648493          	addi	s1,s1,-250 # 80010228 <proc+0x158>
    8000232a:	00014917          	auipc	s2,0x14
    8000232e:	8fe90913          	addi	s2,s2,-1794 # 80015c28 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002332:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002334:	00005997          	auipc	s3,0x5
    80002338:	08c98993          	addi	s3,s3,140 # 800073c0 <digits+0x388>
    printf("%d %s %s", p->pid, state, p->name);
    8000233c:	00005a97          	auipc	s5,0x5
    80002340:	08ca8a93          	addi	s5,s5,140 # 800073c8 <digits+0x390>
    printf("\n");
    80002344:	00005a17          	auipc	s4,0x5
    80002348:	dbca0a13          	addi	s4,s4,-580 # 80007100 <digits+0xc8>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000234c:	00005b97          	auipc	s7,0x5
    80002350:	0bcb8b93          	addi	s7,s7,188 # 80007408 <states.0>
    80002354:	a829                	j	8000236e <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002356:	ed86a583          	lw	a1,-296(a3)
    8000235a:	8556                	mv	a0,s5
    8000235c:	926fe0ef          	jal	ra,80000482 <printf>
    printf("\n");
    80002360:	8552                	mv	a0,s4
    80002362:	920fe0ef          	jal	ra,80000482 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002366:	16848493          	addi	s1,s1,360
    8000236a:	03248163          	beq	s1,s2,8000238c <procdump+0x8c>
    if(p->state == UNUSED)
    8000236e:	86a6                	mv	a3,s1
    80002370:	ec04a783          	lw	a5,-320(s1)
    80002374:	dbed                	beqz	a5,80002366 <procdump+0x66>
      state = "???";
    80002376:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002378:	fcfb6fe3          	bltu	s6,a5,80002356 <procdump+0x56>
    8000237c:	1782                	slli	a5,a5,0x20
    8000237e:	9381                	srli	a5,a5,0x20
    80002380:	078e                	slli	a5,a5,0x3
    80002382:	97de                	add	a5,a5,s7
    80002384:	6390                	ld	a2,0(a5)
    80002386:	fa61                	bnez	a2,80002356 <procdump+0x56>
      state = "???";
    80002388:	864e                	mv	a2,s3
    8000238a:	b7f1                	j	80002356 <procdump+0x56>
  }
}
    8000238c:	60a6                	ld	ra,72(sp)
    8000238e:	6406                	ld	s0,64(sp)
    80002390:	74e2                	ld	s1,56(sp)
    80002392:	7942                	ld	s2,48(sp)
    80002394:	79a2                	ld	s3,40(sp)
    80002396:	7a02                	ld	s4,32(sp)
    80002398:	6ae2                	ld	s5,24(sp)
    8000239a:	6b42                	ld	s6,16(sp)
    8000239c:	6ba2                	ld	s7,8(sp)
    8000239e:	6161                	addi	sp,sp,80
    800023a0:	8082                	ret

00000000800023a2 <kernel_sha256>:


uint64
kernel_sha256(void) {
    800023a2:	716d                	addi	sp,sp,-272
    800023a4:	e606                	sd	ra,264(sp)
    800023a6:	e222                	sd	s0,256(sp)
    800023a8:	fda6                	sd	s1,248(sp)
    800023aa:	f9ca                	sd	s2,240(sp)
    800023ac:	f5ce                	sd	s3,232(sp)
    800023ae:	0a00                	addi	s0,sp,272
    // Hardcoded input string
    char input[] = "kernel"; 
    800023b0:	6e7267b7          	lui	a5,0x6e726
    800023b4:	56b78793          	addi	a5,a5,1387 # 6e72656b <_entry-0x118d9a95>
    800023b8:	fcf42423          	sw	a5,-56(s0)
    800023bc:	679d                	lui	a5,0x7
    800023be:	c6578793          	addi	a5,a5,-923 # 6c65 <_entry-0x7fff939b>
    800023c2:	fcf41623          	sh	a5,-52(s0)
    800023c6:	fc040723          	sb	zero,-50(s0)
    SHA256_CTX ctx;          // SHA-256 context
    char hex_output[65];     // Buffer for the hexadecimal hash string
    int i;

    // SHA-256 computation steps
    sha256_init(&ctx);                            // Initialize SHA-256 context
    800023ca:	f3840513          	addi	a0,s0,-200
    800023ce:	6ee030ef          	jal	ra,80005abc <sha256_init>
    sha256_update(&ctx, (uint8*)input, strlen(input));  // Process the input string
    800023d2:	fc840513          	addi	a0,s0,-56
    800023d6:	a1dfe0ef          	jal	ra,80000df2 <strlen>
    800023da:	0005061b          	sext.w	a2,a0
    800023de:	fc840593          	addi	a1,s0,-56
    800023e2:	f3840513          	addi	a0,s0,-200
    800023e6:	73a030ef          	jal	ra,80005b20 <sha256_update>
    sha256_final(&ctx, hash);                     // Finalize the hash
    800023ea:	fa840593          	addi	a1,s0,-88
    800023ee:	f3840513          	addi	a0,s0,-200
    800023f2:	7a2030ef          	jal	ra,80005b94 <sha256_final>

    // Convert hash to hexadecimal string
    for (i = 0; i < 32; i++) {
    800023f6:	fa840913          	addi	s2,s0,-88
    800023fa:	ef040493          	addi	s1,s0,-272
    800023fe:	f3040993          	addi	s3,s0,-208
        byte_to_hex(hash[i], &hex_output[i * 2]);
    80002402:	85a6                	mv	a1,s1
    80002404:	00094503          	lbu	a0,0(s2)
    80002408:	109030ef          	jal	ra,80005d10 <byte_to_hex>
    for (i = 0; i < 32; i++) {
    8000240c:	0905                	addi	s2,s2,1
    8000240e:	0489                	addi	s1,s1,2
    80002410:	ff3499e3          	bne	s1,s3,80002402 <kernel_sha256+0x60>
    }
    hex_output[64] = '\0';  // Null-terminate the string
    80002414:	f2040823          	sb	zero,-208(s0)

    // Print the hash
    printf("Input for Kernel Space =  %s\n", input);
    80002418:	fc840593          	addi	a1,s0,-56
    8000241c:	00005517          	auipc	a0,0x5
    80002420:	c9450513          	addi	a0,a0,-876 # 800070b0 <digits+0x78>
    80002424:	85efe0ef          	jal	ra,80000482 <printf>
    printf("SHA-256 hash = %s\n", hex_output);
    80002428:	ef040593          	addi	a1,s0,-272
    8000242c:	00005517          	auipc	a0,0x5
    80002430:	ca450513          	addi	a0,a0,-860 # 800070d0 <digits+0x98>
    80002434:	84efe0ef          	jal	ra,80000482 <printf>

    return 0;
}
    80002438:	4501                	li	a0,0
    8000243a:	60b2                	ld	ra,264(sp)
    8000243c:	6412                	ld	s0,256(sp)
    8000243e:	74ee                	ld	s1,248(sp)
    80002440:	794e                	ld	s2,240(sp)
    80002442:	79ae                	ld	s3,232(sp)
    80002444:	6151                	addi	sp,sp,272
    80002446:	8082                	ret

0000000080002448 <swtch>:
    80002448:	00153023          	sd	ra,0(a0)
    8000244c:	00253423          	sd	sp,8(a0)
    80002450:	e900                	sd	s0,16(a0)
    80002452:	ed04                	sd	s1,24(a0)
    80002454:	03253023          	sd	s2,32(a0)
    80002458:	03353423          	sd	s3,40(a0)
    8000245c:	03453823          	sd	s4,48(a0)
    80002460:	03553c23          	sd	s5,56(a0)
    80002464:	05653023          	sd	s6,64(a0)
    80002468:	05753423          	sd	s7,72(a0)
    8000246c:	05853823          	sd	s8,80(a0)
    80002470:	05953c23          	sd	s9,88(a0)
    80002474:	07a53023          	sd	s10,96(a0)
    80002478:	07b53423          	sd	s11,104(a0)
    8000247c:	0005b083          	ld	ra,0(a1)
    80002480:	0085b103          	ld	sp,8(a1)
    80002484:	6980                	ld	s0,16(a1)
    80002486:	6d84                	ld	s1,24(a1)
    80002488:	0205b903          	ld	s2,32(a1)
    8000248c:	0285b983          	ld	s3,40(a1)
    80002490:	0305ba03          	ld	s4,48(a1)
    80002494:	0385ba83          	ld	s5,56(a1)
    80002498:	0405bb03          	ld	s6,64(a1)
    8000249c:	0485bb83          	ld	s7,72(a1)
    800024a0:	0505bc03          	ld	s8,80(a1)
    800024a4:	0585bc83          	ld	s9,88(a1)
    800024a8:	0605bd03          	ld	s10,96(a1)
    800024ac:	0685bd83          	ld	s11,104(a1)
    800024b0:	8082                	ret

00000000800024b2 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800024b2:	1141                	addi	sp,sp,-16
    800024b4:	e406                	sd	ra,8(sp)
    800024b6:	e022                	sd	s0,0(sp)
    800024b8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");ticks++;
    800024ba:	00005597          	auipc	a1,0x5
    800024be:	f7e58593          	addi	a1,a1,-130 # 80007438 <states.0+0x30>
    800024c2:	00013517          	auipc	a0,0x13
    800024c6:	60e50513          	addi	a0,a0,1550 # 80015ad0 <tickslock>
    800024ca:	e5cfe0ef          	jal	ra,80000b26 <initlock>
    800024ce:	00005717          	auipc	a4,0x5
    800024d2:	6a270713          	addi	a4,a4,1698 # 80007b70 <ticks>
    800024d6:	431c                	lw	a5,0(a4)
    800024d8:	2785                	addiw	a5,a5,1
    800024da:	c31c                	sw	a5,0(a4)
}
    800024dc:	60a2                	ld	ra,8(sp)
    800024de:	6402                	ld	s0,0(sp)
    800024e0:	0141                	addi	sp,sp,16
    800024e2:	8082                	ret

00000000800024e4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800024e4:	1141                	addi	sp,sp,-16
    800024e6:	e422                	sd	s0,8(sp)
    800024e8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800024ea:	00003797          	auipc	a5,0x3
    800024ee:	e0678793          	addi	a5,a5,-506 # 800052f0 <kernelvec>
    800024f2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800024f6:	6422                	ld	s0,8(sp)
    800024f8:	0141                	addi	sp,sp,16
    800024fa:	8082                	ret

00000000800024fc <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800024fc:	1141                	addi	sp,sp,-16
    800024fe:	e406                	sd	ra,8(sp)
    80002500:	e022                	sd	s0,0(sp)
    80002502:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002504:	c40ff0ef          	jal	ra,80001944 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002508:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000250c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000250e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002512:	00004617          	auipc	a2,0x4
    80002516:	aee60613          	addi	a2,a2,-1298 # 80006000 <_trampoline>
    8000251a:	00004697          	auipc	a3,0x4
    8000251e:	ae668693          	addi	a3,a3,-1306 # 80006000 <_trampoline>
    80002522:	8e91                	sub	a3,a3,a2
    80002524:	040007b7          	lui	a5,0x4000
    80002528:	17fd                	addi	a5,a5,-1
    8000252a:	07b2                	slli	a5,a5,0xc
    8000252c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000252e:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002532:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002534:	180026f3          	csrr	a3,satp
    80002538:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000253a:	6d38                	ld	a4,88(a0)
    8000253c:	6134                	ld	a3,64(a0)
    8000253e:	6585                	lui	a1,0x1
    80002540:	96ae                	add	a3,a3,a1
    80002542:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002544:	6d38                	ld	a4,88(a0)
    80002546:	00000697          	auipc	a3,0x0
    8000254a:	11668693          	addi	a3,a3,278 # 8000265c <usertrap>
    8000254e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002550:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002552:	8692                	mv	a3,tp
    80002554:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002556:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000255a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000255e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002562:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002566:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002568:	6f18                	ld	a4,24(a4)
    8000256a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000256e:	6928                	ld	a0,80(a0)
    80002570:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002572:	00004717          	auipc	a4,0x4
    80002576:	b2a70713          	addi	a4,a4,-1238 # 8000609c <userret>
    8000257a:	8f11                	sub	a4,a4,a2
    8000257c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000257e:	577d                	li	a4,-1
    80002580:	177e                	slli	a4,a4,0x3f
    80002582:	8d59                	or	a0,a0,a4
    80002584:	9782                	jalr	a5
}
    80002586:	60a2                	ld	ra,8(sp)
    80002588:	6402                	ld	s0,0(sp)
    8000258a:	0141                	addi	sp,sp,16
    8000258c:	8082                	ret

000000008000258e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000258e:	7139                	addi	sp,sp,-64
    80002590:	fc06                	sd	ra,56(sp)
    80002592:	f822                	sd	s0,48(sp)
    80002594:	f426                	sd	s1,40(sp)
    80002596:	f04a                	sd	s2,32(sp)
    80002598:	ec4e                	sd	s3,24(sp)
    8000259a:	0080                	addi	s0,sp,64
 while (1) {
    acquire(&tickslock);
    8000259c:	00013997          	auipc	s3,0x13
    800025a0:	53498993          	addi	s3,s3,1332 # 80015ad0 <tickslock>
    ticks++;
    800025a4:	00005497          	auipc	s1,0x5
    800025a8:	5cc48493          	addi	s1,s1,1484 # 80007b70 <ticks>
    wakeup(&ticks);  // Wake up any processes waiting on ticks
    release(&tickslock);
    
    // Introduce a delay to simulate the passage of time (e.g., 100ms)
    for (volatile int i = 0; i < 1000000; i++) {
    800025ac:	000f4937          	lui	s2,0xf4
    800025b0:	23f90913          	addi	s2,s2,575 # f423f <_entry-0x7ff0bdc1>
    acquire(&tickslock);
    800025b4:	854e                	mv	a0,s3
    800025b6:	df0fe0ef          	jal	ra,80000ba6 <acquire>
    ticks++;
    800025ba:	409c                	lw	a5,0(s1)
    800025bc:	2785                	addiw	a5,a5,1
    800025be:	c09c                	sw	a5,0(s1)
    wakeup(&ticks);  // Wake up any processes waiting on ticks
    800025c0:	8526                	mv	a0,s1
    800025c2:	99bff0ef          	jal	ra,80001f5c <wakeup>
    release(&tickslock);
    800025c6:	854e                	mv	a0,s3
    800025c8:	e76fe0ef          	jal	ra,80000c3e <release>
    for (volatile int i = 0; i < 1000000; i++) {
    800025cc:	fc042623          	sw	zero,-52(s0)
    800025d0:	fcc42783          	lw	a5,-52(s0)
    800025d4:	2781                	sext.w	a5,a5
    800025d6:	fcf94fe3          	blt	s2,a5,800025b4 <clockintr+0x26>
    800025da:	fcc42783          	lw	a5,-52(s0)
    800025de:	2785                	addiw	a5,a5,1
    800025e0:	fcf42623          	sw	a5,-52(s0)
    800025e4:	fcc42783          	lw	a5,-52(s0)
    800025e8:	2781                	sext.w	a5,a5
    800025ea:	fef958e3          	bge	s2,a5,800025da <clockintr+0x4c>
    800025ee:	b7d9                	j	800025b4 <clockintr+0x26>

00000000800025f0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800025f0:	1101                	addi	sp,sp,-32
    800025f2:	ec06                	sd	ra,24(sp)
    800025f4:	e822                	sd	s0,16(sp)
    800025f6:	e426                	sd	s1,8(sp)
    800025f8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800025fa:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800025fe:	57fd                	li	a5,-1
    80002600:	17fe                	slli	a5,a5,0x3f
    80002602:	07a5                	addi	a5,a5,9
    80002604:	00f70d63          	beq	a4,a5,8000261e <devintr+0x2e>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002608:	57fd                	li	a5,-1
    8000260a:	17fe                	slli	a5,a5,0x3f
    8000260c:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000260e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002610:	04f70463          	beq	a4,a5,80002658 <devintr+0x68>
  }
}
    80002614:	60e2                	ld	ra,24(sp)
    80002616:	6442                	ld	s0,16(sp)
    80002618:	64a2                	ld	s1,8(sp)
    8000261a:	6105                	addi	sp,sp,32
    8000261c:	8082                	ret
    int irq = plic_claim();
    8000261e:	57b020ef          	jal	ra,80005398 <plic_claim>
    80002622:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002624:	47a9                	li	a5,10
    80002626:	02f50363          	beq	a0,a5,8000264c <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    8000262a:	4785                	li	a5,1
    8000262c:	02f50363          	beq	a0,a5,80002652 <devintr+0x62>
    return 1;
    80002630:	4505                	li	a0,1
    } else if(irq){
    80002632:	d0ed                	beqz	s1,80002614 <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    80002634:	85a6                	mv	a1,s1
    80002636:	00005517          	auipc	a0,0x5
    8000263a:	e0a50513          	addi	a0,a0,-502 # 80007440 <states.0+0x38>
    8000263e:	e45fd0ef          	jal	ra,80000482 <printf>
      plic_complete(irq);
    80002642:	8526                	mv	a0,s1
    80002644:	575020ef          	jal	ra,800053b8 <plic_complete>
    return 1;
    80002648:	4505                	li	a0,1
    8000264a:	b7e9                	j	80002614 <devintr+0x24>
      uartintr();
    8000264c:	b42fe0ef          	jal	ra,8000098e <uartintr>
    80002650:	bfcd                	j	80002642 <devintr+0x52>
      virtio_disk_intr();
    80002652:	1d6030ef          	jal	ra,80005828 <virtio_disk_intr>
    80002656:	b7f5                	j	80002642 <devintr+0x52>
    clockintr();
    80002658:	f37ff0ef          	jal	ra,8000258e <clockintr>

000000008000265c <usertrap>:
{
    8000265c:	1101                	addi	sp,sp,-32
    8000265e:	ec06                	sd	ra,24(sp)
    80002660:	e822                	sd	s0,16(sp)
    80002662:	e426                	sd	s1,8(sp)
    80002664:	e04a                	sd	s2,0(sp)
    80002666:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002668:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000266c:	1007f793          	andi	a5,a5,256
    80002670:	ef85                	bnez	a5,800026a8 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002672:	00003797          	auipc	a5,0x3
    80002676:	c7e78793          	addi	a5,a5,-898 # 800052f0 <kernelvec>
    8000267a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000267e:	ac6ff0ef          	jal	ra,80001944 <myproc>
    80002682:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002684:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002686:	14102773          	csrr	a4,sepc
    8000268a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000268c:	14202773          	csrr	a4,scause
if(r_scause() == 8){
    80002690:	47a1                	li	a5,8
    80002692:	02f70163          	beq	a4,a5,800026b4 <usertrap+0x58>
  else if((which_dev = devintr()) != 0){
    80002696:	f5bff0ef          	jal	ra,800025f0 <devintr>
    8000269a:	892a                	mv	s2,a0
    8000269c:	c135                	beqz	a0,80002700 <usertrap+0xa4>
  if(killed(p))
    8000269e:	8526                	mv	a0,s1
    800026a0:	aa9ff0ef          	jal	ra,80002148 <killed>
    800026a4:	cd1d                	beqz	a0,800026e2 <usertrap+0x86>
    800026a6:	a81d                	j	800026dc <usertrap+0x80>
    panic("usertrap: not from user mode");
    800026a8:	00005517          	auipc	a0,0x5
    800026ac:	db850513          	addi	a0,a0,-584 # 80007460 <states.0+0x58>
    800026b0:	886fe0ef          	jal	ra,80000736 <panic>
    if(killed(p))
    800026b4:	a95ff0ef          	jal	ra,80002148 <killed>
    800026b8:	e121                	bnez	a0,800026f8 <usertrap+0x9c>
    p->trapframe->epc += 4;
    800026ba:	6cb8                	ld	a4,88(s1)
    800026bc:	6f1c                	ld	a5,24(a4)
    800026be:	0791                	addi	a5,a5,4
    800026c0:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026c2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800026c6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026ca:	10079073          	csrw	sstatus,a5
   syscall();
    800026ce:	248000ef          	jal	ra,80002916 <syscall>
  if(killed(p))
    800026d2:	8526                	mv	a0,s1
    800026d4:	a75ff0ef          	jal	ra,80002148 <killed>
    800026d8:	c901                	beqz	a0,800026e8 <usertrap+0x8c>
    800026da:	4901                	li	s2,0
    exit(-1);
    800026dc:	557d                	li	a0,-1
    800026de:	93fff0ef          	jal	ra,8000201c <exit>
  if(which_dev == 2)
    800026e2:	4789                	li	a5,2
    800026e4:	04f90563          	beq	s2,a5,8000272e <usertrap+0xd2>
  usertrapret();
    800026e8:	e15ff0ef          	jal	ra,800024fc <usertrapret>
}
    800026ec:	60e2                	ld	ra,24(sp)
    800026ee:	6442                	ld	s0,16(sp)
    800026f0:	64a2                	ld	s1,8(sp)
    800026f2:	6902                	ld	s2,0(sp)
    800026f4:	6105                	addi	sp,sp,32
    800026f6:	8082                	ret
      exit(-1);
    800026f8:	557d                	li	a0,-1
    800026fa:	923ff0ef          	jal	ra,8000201c <exit>
    800026fe:	bf75                	j	800026ba <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002700:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002704:	5890                	lw	a2,48(s1)
    80002706:	00005517          	auipc	a0,0x5
    8000270a:	d7a50513          	addi	a0,a0,-646 # 80007480 <states.0+0x78>
    8000270e:	d75fd0ef          	jal	ra,80000482 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002712:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002716:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    8000271a:	00005517          	auipc	a0,0x5
    8000271e:	d9650513          	addi	a0,a0,-618 # 800074b0 <states.0+0xa8>
    80002722:	d61fd0ef          	jal	ra,80000482 <printf>
    setkilled(p);
    80002726:	8526                	mv	a0,s1
    80002728:	9fdff0ef          	jal	ra,80002124 <setkilled>
    8000272c:	b75d                	j	800026d2 <usertrap+0x76>
    yield();
    8000272e:	fb6ff0ef          	jal	ra,80001ee4 <yield>
    80002732:	bf5d                	j	800026e8 <usertrap+0x8c>

0000000080002734 <kerneltrap>:
{
    80002734:	7179                	addi	sp,sp,-48
    80002736:	f406                	sd	ra,40(sp)
    80002738:	f022                	sd	s0,32(sp)
    8000273a:	ec26                	sd	s1,24(sp)
    8000273c:	e84a                	sd	s2,16(sp)
    8000273e:	e44e                	sd	s3,8(sp)
    80002740:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002742:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002746:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000274a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    8000274e:	1004f793          	andi	a5,s1,256
    80002752:	c795                	beqz	a5,8000277e <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002754:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002758:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000275a:	eb85                	bnez	a5,8000278a <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    8000275c:	e95ff0ef          	jal	ra,800025f0 <devintr>
    80002760:	c91d                	beqz	a0,80002796 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002762:	4789                	li	a5,2
    80002764:	04f50a63          	beq	a0,a5,800027b8 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002768:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000276c:	10049073          	csrw	sstatus,s1
}
    80002770:	70a2                	ld	ra,40(sp)
    80002772:	7402                	ld	s0,32(sp)
    80002774:	64e2                	ld	s1,24(sp)
    80002776:	6942                	ld	s2,16(sp)
    80002778:	69a2                	ld	s3,8(sp)
    8000277a:	6145                	addi	sp,sp,48
    8000277c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000277e:	00005517          	auipc	a0,0x5
    80002782:	d5a50513          	addi	a0,a0,-678 # 800074d8 <states.0+0xd0>
    80002786:	fb1fd0ef          	jal	ra,80000736 <panic>
    panic("kerneltrap: interrupts enabled");
    8000278a:	00005517          	auipc	a0,0x5
    8000278e:	d7650513          	addi	a0,a0,-650 # 80007500 <states.0+0xf8>
    80002792:	fa5fd0ef          	jal	ra,80000736 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002796:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000279a:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    8000279e:	85ce                	mv	a1,s3
    800027a0:	00005517          	auipc	a0,0x5
    800027a4:	d8050513          	addi	a0,a0,-640 # 80007520 <states.0+0x118>
    800027a8:	cdbfd0ef          	jal	ra,80000482 <printf>
    panic("kerneltrap");
    800027ac:	00005517          	auipc	a0,0x5
    800027b0:	d9c50513          	addi	a0,a0,-612 # 80007548 <states.0+0x140>
    800027b4:	f83fd0ef          	jal	ra,80000736 <panic>
  if(which_dev == 2 && myproc() != 0)
    800027b8:	98cff0ef          	jal	ra,80001944 <myproc>
    800027bc:	d555                	beqz	a0,80002768 <kerneltrap+0x34>
    yield();
    800027be:	f26ff0ef          	jal	ra,80001ee4 <yield>
    800027c2:	b75d                	j	80002768 <kerneltrap+0x34>

00000000800027c4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800027c4:	1101                	addi	sp,sp,-32
    800027c6:	ec06                	sd	ra,24(sp)
    800027c8:	e822                	sd	s0,16(sp)
    800027ca:	e426                	sd	s1,8(sp)
    800027cc:	1000                	addi	s0,sp,32
    800027ce:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800027d0:	974ff0ef          	jal	ra,80001944 <myproc>
  switch (n) {
    800027d4:	4795                	li	a5,5
    800027d6:	0497e163          	bltu	a5,s1,80002818 <argraw+0x54>
    800027da:	048a                	slli	s1,s1,0x2
    800027dc:	00005717          	auipc	a4,0x5
    800027e0:	da470713          	addi	a4,a4,-604 # 80007580 <states.0+0x178>
    800027e4:	94ba                	add	s1,s1,a4
    800027e6:	409c                	lw	a5,0(s1)
    800027e8:	97ba                	add	a5,a5,a4
    800027ea:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800027ec:	6d3c                	ld	a5,88(a0)
    800027ee:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800027f0:	60e2                	ld	ra,24(sp)
    800027f2:	6442                	ld	s0,16(sp)
    800027f4:	64a2                	ld	s1,8(sp)
    800027f6:	6105                	addi	sp,sp,32
    800027f8:	8082                	ret
    return p->trapframe->a1;
    800027fa:	6d3c                	ld	a5,88(a0)
    800027fc:	7fa8                	ld	a0,120(a5)
    800027fe:	bfcd                	j	800027f0 <argraw+0x2c>
    return p->trapframe->a2;
    80002800:	6d3c                	ld	a5,88(a0)
    80002802:	63c8                	ld	a0,128(a5)
    80002804:	b7f5                	j	800027f0 <argraw+0x2c>
    return p->trapframe->a3;
    80002806:	6d3c                	ld	a5,88(a0)
    80002808:	67c8                	ld	a0,136(a5)
    8000280a:	b7dd                	j	800027f0 <argraw+0x2c>
    return p->trapframe->a4;
    8000280c:	6d3c                	ld	a5,88(a0)
    8000280e:	6bc8                	ld	a0,144(a5)
    80002810:	b7c5                	j	800027f0 <argraw+0x2c>
    return p->trapframe->a5;
    80002812:	6d3c                	ld	a5,88(a0)
    80002814:	6fc8                	ld	a0,152(a5)
    80002816:	bfe9                	j	800027f0 <argraw+0x2c>
  panic("argraw");
    80002818:	00005517          	auipc	a0,0x5
    8000281c:	d4050513          	addi	a0,a0,-704 # 80007558 <states.0+0x150>
    80002820:	f17fd0ef          	jal	ra,80000736 <panic>

0000000080002824 <fetchaddr>:
{
    80002824:	1101                	addi	sp,sp,-32
    80002826:	ec06                	sd	ra,24(sp)
    80002828:	e822                	sd	s0,16(sp)
    8000282a:	e426                	sd	s1,8(sp)
    8000282c:	e04a                	sd	s2,0(sp)
    8000282e:	1000                	addi	s0,sp,32
    80002830:	84aa                	mv	s1,a0
    80002832:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002834:	910ff0ef          	jal	ra,80001944 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002838:	653c                	ld	a5,72(a0)
    8000283a:	02f4f663          	bgeu	s1,a5,80002866 <fetchaddr+0x42>
    8000283e:	00848713          	addi	a4,s1,8
    80002842:	02e7e463          	bltu	a5,a4,8000286a <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002846:	46a1                	li	a3,8
    80002848:	8626                	mv	a2,s1
    8000284a:	85ca                	mv	a1,s2
    8000284c:	6928                	ld	a0,80(a0)
    8000284e:	e63fe0ef          	jal	ra,800016b0 <copyin>
    80002852:	00a03533          	snez	a0,a0
    80002856:	40a00533          	neg	a0,a0
}
    8000285a:	60e2                	ld	ra,24(sp)
    8000285c:	6442                	ld	s0,16(sp)
    8000285e:	64a2                	ld	s1,8(sp)
    80002860:	6902                	ld	s2,0(sp)
    80002862:	6105                	addi	sp,sp,32
    80002864:	8082                	ret
    return -1;
    80002866:	557d                	li	a0,-1
    80002868:	bfcd                	j	8000285a <fetchaddr+0x36>
    8000286a:	557d                	li	a0,-1
    8000286c:	b7fd                	j	8000285a <fetchaddr+0x36>

000000008000286e <fetchstr>:
{
    8000286e:	7179                	addi	sp,sp,-48
    80002870:	f406                	sd	ra,40(sp)
    80002872:	f022                	sd	s0,32(sp)
    80002874:	ec26                	sd	s1,24(sp)
    80002876:	e84a                	sd	s2,16(sp)
    80002878:	e44e                	sd	s3,8(sp)
    8000287a:	1800                	addi	s0,sp,48
    8000287c:	892a                	mv	s2,a0
    8000287e:	84ae                	mv	s1,a1
    80002880:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002882:	8c2ff0ef          	jal	ra,80001944 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002886:	86ce                	mv	a3,s3
    80002888:	864a                	mv	a2,s2
    8000288a:	85a6                	mv	a1,s1
    8000288c:	6928                	ld	a0,80(a0)
    8000288e:	ea9fe0ef          	jal	ra,80001736 <copyinstr>
    80002892:	00054c63          	bltz	a0,800028aa <fetchstr+0x3c>
  return strlen(buf);
    80002896:	8526                	mv	a0,s1
    80002898:	d5afe0ef          	jal	ra,80000df2 <strlen>
}
    8000289c:	70a2                	ld	ra,40(sp)
    8000289e:	7402                	ld	s0,32(sp)
    800028a0:	64e2                	ld	s1,24(sp)
    800028a2:	6942                	ld	s2,16(sp)
    800028a4:	69a2                	ld	s3,8(sp)
    800028a6:	6145                	addi	sp,sp,48
    800028a8:	8082                	ret
    return -1;
    800028aa:	557d                	li	a0,-1
    800028ac:	bfc5                	j	8000289c <fetchstr+0x2e>

00000000800028ae <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800028ae:	1101                	addi	sp,sp,-32
    800028b0:	ec06                	sd	ra,24(sp)
    800028b2:	e822                	sd	s0,16(sp)
    800028b4:	e426                	sd	s1,8(sp)
    800028b6:	1000                	addi	s0,sp,32
    800028b8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800028ba:	f0bff0ef          	jal	ra,800027c4 <argraw>
    800028be:	c088                	sw	a0,0(s1)
}
    800028c0:	60e2                	ld	ra,24(sp)
    800028c2:	6442                	ld	s0,16(sp)
    800028c4:	64a2                	ld	s1,8(sp)
    800028c6:	6105                	addi	sp,sp,32
    800028c8:	8082                	ret

00000000800028ca <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800028ca:	1101                	addi	sp,sp,-32
    800028cc:	ec06                	sd	ra,24(sp)
    800028ce:	e822                	sd	s0,16(sp)
    800028d0:	e426                	sd	s1,8(sp)
    800028d2:	1000                	addi	s0,sp,32
    800028d4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800028d6:	eefff0ef          	jal	ra,800027c4 <argraw>
    800028da:	e088                	sd	a0,0(s1)
}
    800028dc:	60e2                	ld	ra,24(sp)
    800028de:	6442                	ld	s0,16(sp)
    800028e0:	64a2                	ld	s1,8(sp)
    800028e2:	6105                	addi	sp,sp,32
    800028e4:	8082                	ret

00000000800028e6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800028e6:	7179                	addi	sp,sp,-48
    800028e8:	f406                	sd	ra,40(sp)
    800028ea:	f022                	sd	s0,32(sp)
    800028ec:	ec26                	sd	s1,24(sp)
    800028ee:	e84a                	sd	s2,16(sp)
    800028f0:	1800                	addi	s0,sp,48
    800028f2:	84ae                	mv	s1,a1
    800028f4:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800028f6:	fd840593          	addi	a1,s0,-40
    800028fa:	fd1ff0ef          	jal	ra,800028ca <argaddr>
  return fetchstr(addr, buf, max);
    800028fe:	864a                	mv	a2,s2
    80002900:	85a6                	mv	a1,s1
    80002902:	fd843503          	ld	a0,-40(s0)
    80002906:	f69ff0ef          	jal	ra,8000286e <fetchstr>
}
    8000290a:	70a2                	ld	ra,40(sp)
    8000290c:	7402                	ld	s0,32(sp)
    8000290e:	64e2                	ld	s1,24(sp)
    80002910:	6942                	ld	s2,16(sp)
    80002912:	6145                	addi	sp,sp,48
    80002914:	8082                	ret

0000000080002916 <syscall>:

};
//@Qamar == very imp function
void
syscall(void)
{
    80002916:	1101                	addi	sp,sp,-32
    80002918:	ec06                	sd	ra,24(sp)
    8000291a:	e822                	sd	s0,16(sp)
    8000291c:	e426                	sd	s1,8(sp)
    8000291e:	e04a                	sd	s2,0(sp)
    80002920:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002922:	822ff0ef          	jal	ra,80001944 <myproc>
    80002926:	84aa                	mv	s1,a0

//the syscall number is stored in register a7, this line retrieves it
  num = p->trapframe->a7;
    80002928:	05853903          	ld	s2,88(a0)
    8000292c:	0a893783          	ld	a5,168(s2)
    80002930:	0007869b          	sext.w	a3,a5

//this condition checks if it is valid, must be greater than 0 and less than 
// the len of syscall array and that the syscall actually exists
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002934:	37fd                	addiw	a5,a5,-1
    80002936:	475d                	li	a4,23
    80002938:	00f76f63          	bltu	a4,a5,80002956 <syscall+0x40>
    8000293c:	00369713          	slli	a4,a3,0x3
    80002940:	00005797          	auipc	a5,0x5
    80002944:	c5878793          	addi	a5,a5,-936 # 80007598 <syscalls>
    80002948:	97ba                	add	a5,a5,a4
    8000294a:	639c                	ld	a5,0(a5)
    8000294c:	c789                	beqz	a5,80002956 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000294e:	9782                	jalr	a5
    80002950:	06a93823          	sd	a0,112(s2)
    80002954:	a829                	j	8000296e <syscall+0x58>
  }

// else handle the error
 else {
    printf("%d %s: unknown sys call %d\n",
    80002956:	15848613          	addi	a2,s1,344
    8000295a:	588c                	lw	a1,48(s1)
    8000295c:	00005517          	auipc	a0,0x5
    80002960:	c0450513          	addi	a0,a0,-1020 # 80007560 <states.0+0x158>
    80002964:	b1ffd0ef          	jal	ra,80000482 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002968:	6cbc                	ld	a5,88(s1)
    8000296a:	577d                	li	a4,-1
    8000296c:	fbb8                	sd	a4,112(a5)
  }
}
    8000296e:	60e2                	ld	ra,24(sp)
    80002970:	6442                	ld	s0,16(sp)
    80002972:	64a2                	ld	s1,8(sp)
    80002974:	6902                	ld	s2,0(sp)
    80002976:	6105                	addi	sp,sp,32
    80002978:	8082                	ret

000000008000297a <sys_exit>:
#include "sha256.h"


uint64
sys_exit(void)
{
    8000297a:	1101                	addi	sp,sp,-32
    8000297c:	ec06                	sd	ra,24(sp)
    8000297e:	e822                	sd	s0,16(sp)
    80002980:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002982:	fec40593          	addi	a1,s0,-20
    80002986:	4501                	li	a0,0
    80002988:	f27ff0ef          	jal	ra,800028ae <argint>
  exit(n);
    8000298c:	fec42503          	lw	a0,-20(s0)
    80002990:	e8cff0ef          	jal	ra,8000201c <exit>
  return 0;  // not reached
}
    80002994:	4501                	li	a0,0
    80002996:	60e2                	ld	ra,24(sp)
    80002998:	6442                	ld	s0,16(sp)
    8000299a:	6105                	addi	sp,sp,32
    8000299c:	8082                	ret

000000008000299e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000299e:	1141                	addi	sp,sp,-16
    800029a0:	e406                	sd	ra,8(sp)
    800029a2:	e022                	sd	s0,0(sp)
    800029a4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800029a6:	f9ffe0ef          	jal	ra,80001944 <myproc>
}
    800029aa:	5908                	lw	a0,48(a0)
    800029ac:	60a2                	ld	ra,8(sp)
    800029ae:	6402                	ld	s0,0(sp)
    800029b0:	0141                	addi	sp,sp,16
    800029b2:	8082                	ret

00000000800029b4 <sys_fork>:

uint64
sys_fork(void)
{
    800029b4:	1141                	addi	sp,sp,-16
    800029b6:	e406                	sd	ra,8(sp)
    800029b8:	e022                	sd	s0,0(sp)
    800029ba:	0800                	addi	s0,sp,16
  return fork();
    800029bc:	aaeff0ef          	jal	ra,80001c6a <fork>
}
    800029c0:	60a2                	ld	ra,8(sp)
    800029c2:	6402                	ld	s0,0(sp)
    800029c4:	0141                	addi	sp,sp,16
    800029c6:	8082                	ret

00000000800029c8 <sys_wait>:

uint64
sys_wait(void)
{
    800029c8:	1101                	addi	sp,sp,-32
    800029ca:	ec06                	sd	ra,24(sp)
    800029cc:	e822                	sd	s0,16(sp)
    800029ce:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800029d0:	fe840593          	addi	a1,s0,-24
    800029d4:	4501                	li	a0,0
    800029d6:	ef5ff0ef          	jal	ra,800028ca <argaddr>
  return wait(p);
    800029da:	fe843503          	ld	a0,-24(s0)
    800029de:	f94ff0ef          	jal	ra,80002172 <wait>
}
    800029e2:	60e2                	ld	ra,24(sp)
    800029e4:	6442                	ld	s0,16(sp)
    800029e6:	6105                	addi	sp,sp,32
    800029e8:	8082                	ret

00000000800029ea <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800029ea:	7179                	addi	sp,sp,-48
    800029ec:	f406                	sd	ra,40(sp)
    800029ee:	f022                	sd	s0,32(sp)
    800029f0:	ec26                	sd	s1,24(sp)
    800029f2:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800029f4:	fdc40593          	addi	a1,s0,-36
    800029f8:	4501                	li	a0,0
    800029fa:	eb5ff0ef          	jal	ra,800028ae <argint>
  addr = myproc()->sz;
    800029fe:	f47fe0ef          	jal	ra,80001944 <myproc>
    80002a02:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002a04:	fdc42503          	lw	a0,-36(s0)
    80002a08:	a12ff0ef          	jal	ra,80001c1a <growproc>
    80002a0c:	00054863          	bltz	a0,80002a1c <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002a10:	8526                	mv	a0,s1
    80002a12:	70a2                	ld	ra,40(sp)
    80002a14:	7402                	ld	s0,32(sp)
    80002a16:	64e2                	ld	s1,24(sp)
    80002a18:	6145                	addi	sp,sp,48
    80002a1a:	8082                	ret
    return -1;
    80002a1c:	54fd                	li	s1,-1
    80002a1e:	bfcd                	j	80002a10 <sys_sbrk+0x26>

0000000080002a20 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002a20:	7139                	addi	sp,sp,-64
    80002a22:	fc06                	sd	ra,56(sp)
    80002a24:	f822                	sd	s0,48(sp)
    80002a26:	f426                	sd	s1,40(sp)
    80002a28:	f04a                	sd	s2,32(sp)
    80002a2a:	ec4e                	sd	s3,24(sp)
    80002a2c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002a2e:	fcc40593          	addi	a1,s0,-52
    80002a32:	4501                	li	a0,0
    80002a34:	e7bff0ef          	jal	ra,800028ae <argint>
  if(n < 0)
    80002a38:	fcc42783          	lw	a5,-52(s0)
    80002a3c:	0607c563          	bltz	a5,80002aa6 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002a40:	00013517          	auipc	a0,0x13
    80002a44:	09050513          	addi	a0,a0,144 # 80015ad0 <tickslock>
    80002a48:	95efe0ef          	jal	ra,80000ba6 <acquire>
  ticks0 = ticks;
    80002a4c:	00005917          	auipc	s2,0x5
    80002a50:	12492903          	lw	s2,292(s2) # 80007b70 <ticks>
  while(ticks - ticks0 < n){
    80002a54:	fcc42783          	lw	a5,-52(s0)
    80002a58:	cb8d                	beqz	a5,80002a8a <sys_sleep+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002a5a:	00013997          	auipc	s3,0x13
    80002a5e:	07698993          	addi	s3,s3,118 # 80015ad0 <tickslock>
    80002a62:	00005497          	auipc	s1,0x5
    80002a66:	10e48493          	addi	s1,s1,270 # 80007b70 <ticks>
    if(killed(myproc())){
    80002a6a:	edbfe0ef          	jal	ra,80001944 <myproc>
    80002a6e:	edaff0ef          	jal	ra,80002148 <killed>
    80002a72:	ed0d                	bnez	a0,80002aac <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002a74:	85ce                	mv	a1,s3
    80002a76:	8526                	mv	a0,s1
    80002a78:	c98ff0ef          	jal	ra,80001f10 <sleep>
  while(ticks - ticks0 < n){
    80002a7c:	409c                	lw	a5,0(s1)
    80002a7e:	412787bb          	subw	a5,a5,s2
    80002a82:	fcc42703          	lw	a4,-52(s0)
    80002a86:	fee7e2e3          	bltu	a5,a4,80002a6a <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002a8a:	00013517          	auipc	a0,0x13
    80002a8e:	04650513          	addi	a0,a0,70 # 80015ad0 <tickslock>
    80002a92:	9acfe0ef          	jal	ra,80000c3e <release>
  return 0;
    80002a96:	4501                	li	a0,0
}
    80002a98:	70e2                	ld	ra,56(sp)
    80002a9a:	7442                	ld	s0,48(sp)
    80002a9c:	74a2                	ld	s1,40(sp)
    80002a9e:	7902                	ld	s2,32(sp)
    80002aa0:	69e2                	ld	s3,24(sp)
    80002aa2:	6121                	addi	sp,sp,64
    80002aa4:	8082                	ret
    n = 0;
    80002aa6:	fc042623          	sw	zero,-52(s0)
    80002aaa:	bf59                	j	80002a40 <sys_sleep+0x20>
      release(&tickslock);
    80002aac:	00013517          	auipc	a0,0x13
    80002ab0:	02450513          	addi	a0,a0,36 # 80015ad0 <tickslock>
    80002ab4:	98afe0ef          	jal	ra,80000c3e <release>
      return -1;
    80002ab8:	557d                	li	a0,-1
    80002aba:	bff9                	j	80002a98 <sys_sleep+0x78>

0000000080002abc <sys_kill>:

uint64
sys_kill(void)
{
    80002abc:	1101                	addi	sp,sp,-32
    80002abe:	ec06                	sd	ra,24(sp)
    80002ac0:	e822                	sd	s0,16(sp)
    80002ac2:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002ac4:	fec40593          	addi	a1,s0,-20
    80002ac8:	4501                	li	a0,0
    80002aca:	de5ff0ef          	jal	ra,800028ae <argint>
  return kill(pid);
    80002ace:	fec42503          	lw	a0,-20(s0)
    80002ad2:	decff0ef          	jal	ra,800020be <kill>
}
    80002ad6:	60e2                	ld	ra,24(sp)
    80002ad8:	6442                	ld	s0,16(sp)
    80002ada:	6105                	addi	sp,sp,32
    80002adc:	8082                	ret

0000000080002ade <sys_uptime>:
extern struct spinlock tickslock;
extern uint ticks;

uint64
sys_uptime(void)
{
    80002ade:	1101                	addi	sp,sp,-32
    80002ae0:	ec06                	sd	ra,24(sp)
    80002ae2:	e822                	sd	s0,16(sp)
    80002ae4:	e426                	sd	s1,8(sp)
    80002ae6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002ae8:	00013517          	auipc	a0,0x13
    80002aec:	fe850513          	addi	a0,a0,-24 # 80015ad0 <tickslock>
    80002af0:	8b6fe0ef          	jal	ra,80000ba6 <acquire>
  xticks = ticks;
    80002af4:	00005497          	auipc	s1,0x5
    80002af8:	07c4a483          	lw	s1,124(s1) # 80007b70 <ticks>
  release(&tickslock);
    80002afc:	00013517          	auipc	a0,0x13
    80002b00:	fd450513          	addi	a0,a0,-44 # 80015ad0 <tickslock>
    80002b04:	93afe0ef          	jal	ra,80000c3e <release>

  return xticks;
}
    80002b08:	02049513          	slli	a0,s1,0x20
    80002b0c:	9101                	srli	a0,a0,0x20
    80002b0e:	60e2                	ld	ra,24(sp)
    80002b10:	6442                	ld	s0,16(sp)
    80002b12:	64a2                	ld	s1,8(sp)
    80002b14:	6105                	addi	sp,sp,32
    80002b16:	8082                	ret

0000000080002b18 <sys_time>:

uint64
sys_time(void) {
    80002b18:	1141                	addi	sp,sp,-16
    80002b1a:	e422                	sd	s0,8(sp)
    80002b1c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, time" : "=r" (x) );
    80002b1e:	c0102573          	rdtime	a0
uint64 current_time = r_time();  // Call r_time to get the current timer value
    return current_time; 


}
    80002b22:	6422                	ld	s0,8(sp)
    80002b24:	0141                	addi	sp,sp,16
    80002b26:	8082                	ret

0000000080002b28 <sys_getmem>:
uint64
sys_getmem(void) {
    80002b28:	1141                	addi	sp,sp,-16
    80002b2a:	e406                	sd	ra,8(sp)
    80002b2c:	e022                	sd	s0,0(sp)
    80002b2e:	0800                	addi	s0,sp,16
    int page_count;
    page_count = countpages(); // countpages() returns the number of free pages
    80002b30:	fb7fd0ef          	jal	ra,80000ae6 <countpages>
				// it is defined in kernel/kalloc.c
				// it is also placed in kernel/defs.h so that it can be accessed 
                                //here or any place with kernel/defs.h header
    int megabytes;
    megabytes = (page_count * 4096) / (1024 * 1024); // Convert bytes to MB
    80002b34:	41f5579b          	sraiw	a5,a0,0x1f
    80002b38:	0187d79b          	srliw	a5,a5,0x18
    80002b3c:	9d3d                	addw	a0,a0,a5
    return megabytes;
}
    80002b3e:	4085551b          	sraiw	a0,a0,0x8
    80002b42:	60a2                	ld	ra,8(sp)
    80002b44:	6402                	ld	s0,0(sp)
    80002b46:	0141                	addi	sp,sp,16
    80002b48:	8082                	ret

0000000080002b4a <sys_get_sha256>:

uint64
sys_get_sha256(void) {
    80002b4a:	7149                	addi	sp,sp,-368
    80002b4c:	f686                	sd	ra,360(sp)
    80002b4e:	f2a2                	sd	s0,352(sp)
    80002b50:	eea6                	sd	s1,344(sp)
    80002b52:	eaca                	sd	s2,336(sp)
    80002b54:	e6ce                	sd	s3,328(sp)
    80002b56:	1a80                	addi	s0,sp,368
    SHA256_CTX ctx;
    char hex_output[65];
    int i;

    // Use argstr to retrieve the string argument
    if (argstr(0, input, sizeof(input)) < 0) {
    80002b58:	06400613          	li	a2,100
    80002b5c:	f6840593          	addi	a1,s0,-152
    80002b60:	4501                	li	a0,0
    80002b62:	d85ff0ef          	jal	ra,800028e6 <argstr>
    80002b66:	06054963          	bltz	a0,80002bd8 <sys_get_sha256+0x8e>
        printf("Failed to retrieve input\n");
        return -1; // Error code if argument retrieval fails
    }

    // SHA-256 computation steps
    sha256_init(&ctx);
    80002b6a:	ed840513          	addi	a0,s0,-296
    80002b6e:	74f020ef          	jal	ra,80005abc <sha256_init>
    sha256_update(&ctx, (uint8*)input, strlen(input));
    80002b72:	f6840513          	addi	a0,s0,-152
    80002b76:	a7cfe0ef          	jal	ra,80000df2 <strlen>
    80002b7a:	0005061b          	sext.w	a2,a0
    80002b7e:	f6840593          	addi	a1,s0,-152
    80002b82:	ed840513          	addi	a0,s0,-296
    80002b86:	79b020ef          	jal	ra,80005b20 <sha256_update>
    sha256_final(&ctx, hash);
    80002b8a:	f4840593          	addi	a1,s0,-184
    80002b8e:	ed840513          	addi	a0,s0,-296
    80002b92:	002030ef          	jal	ra,80005b94 <sha256_final>

    for (i = 0; i < 32; i++) {
    80002b96:	f4840913          	addi	s2,s0,-184
    80002b9a:	e9040493          	addi	s1,s0,-368
    80002b9e:	ed040993          	addi	s3,s0,-304
        byte_to_hex(hash[i], &hex_output[i * 2]);
    80002ba2:	85a6                	mv	a1,s1
    80002ba4:	00094503          	lbu	a0,0(s2)
    80002ba8:	168030ef          	jal	ra,80005d10 <byte_to_hex>
    for (i = 0; i < 32; i++) {
    80002bac:	0905                	addi	s2,s2,1
    80002bae:	0489                	addi	s1,s1,2
    80002bb0:	ff3499e3          	bne	s1,s3,80002ba2 <sys_get_sha256+0x58>
    }
    hex_output[64] = '\0'; // to terminate the null string
    80002bb4:	ec040823          	sb	zero,-304(s0)

    printf("SHA-256 hash: %s\n", hex_output);
    80002bb8:	e9040593          	addi	a1,s0,-368
    80002bbc:	00005517          	auipc	a0,0x5
    80002bc0:	ac450513          	addi	a0,a0,-1340 # 80007680 <syscalls+0xe8>
    80002bc4:	8bffd0ef          	jal	ra,80000482 <printf>

    return 0;
    80002bc8:	4501                	li	a0,0
}
    80002bca:	70b6                	ld	ra,360(sp)
    80002bcc:	7416                	ld	s0,352(sp)
    80002bce:	64f6                	ld	s1,344(sp)
    80002bd0:	6956                	ld	s2,336(sp)
    80002bd2:	69b6                	ld	s3,328(sp)
    80002bd4:	6175                	addi	sp,sp,368
    80002bd6:	8082                	ret
        printf("Failed to retrieve input\n");
    80002bd8:	00005517          	auipc	a0,0x5
    80002bdc:	a8850513          	addi	a0,a0,-1400 # 80007660 <syscalls+0xc8>
    80002be0:	8a3fd0ef          	jal	ra,80000482 <printf>
        return -1; // Error code if argument retrieval fails
    80002be4:	557d                	li	a0,-1
    80002be6:	b7d5                	j	80002bca <sys_get_sha256+0x80>

0000000080002be8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002be8:	7179                	addi	sp,sp,-48
    80002bea:	f406                	sd	ra,40(sp)
    80002bec:	f022                	sd	s0,32(sp)
    80002bee:	ec26                	sd	s1,24(sp)
    80002bf0:	e84a                	sd	s2,16(sp)
    80002bf2:	e44e                	sd	s3,8(sp)
    80002bf4:	e052                	sd	s4,0(sp)
    80002bf6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002bf8:	00005597          	auipc	a1,0x5
    80002bfc:	aa058593          	addi	a1,a1,-1376 # 80007698 <syscalls+0x100>
    80002c00:	00013517          	auipc	a0,0x13
    80002c04:	ee850513          	addi	a0,a0,-280 # 80015ae8 <bcache>
    80002c08:	f1ffd0ef          	jal	ra,80000b26 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002c0c:	0001b797          	auipc	a5,0x1b
    80002c10:	edc78793          	addi	a5,a5,-292 # 8001dae8 <bcache+0x8000>
    80002c14:	0001b717          	auipc	a4,0x1b
    80002c18:	13c70713          	addi	a4,a4,316 # 8001dd50 <bcache+0x8268>
    80002c1c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002c20:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002c24:	00013497          	auipc	s1,0x13
    80002c28:	edc48493          	addi	s1,s1,-292 # 80015b00 <bcache+0x18>
    b->next = bcache.head.next;
    80002c2c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002c2e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002c30:	00005a17          	auipc	s4,0x5
    80002c34:	a70a0a13          	addi	s4,s4,-1424 # 800076a0 <syscalls+0x108>
    b->next = bcache.head.next;
    80002c38:	2b893783          	ld	a5,696(s2)
    80002c3c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002c3e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002c42:	85d2                	mv	a1,s4
    80002c44:	01048513          	addi	a0,s1,16
    80002c48:	224010ef          	jal	ra,80003e6c <initsleeplock>
    bcache.head.next->prev = b;
    80002c4c:	2b893783          	ld	a5,696(s2)
    80002c50:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002c52:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002c56:	45848493          	addi	s1,s1,1112
    80002c5a:	fd349fe3          	bne	s1,s3,80002c38 <binit+0x50>
  }
}
    80002c5e:	70a2                	ld	ra,40(sp)
    80002c60:	7402                	ld	s0,32(sp)
    80002c62:	64e2                	ld	s1,24(sp)
    80002c64:	6942                	ld	s2,16(sp)
    80002c66:	69a2                	ld	s3,8(sp)
    80002c68:	6a02                	ld	s4,0(sp)
    80002c6a:	6145                	addi	sp,sp,48
    80002c6c:	8082                	ret

0000000080002c6e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002c6e:	7179                	addi	sp,sp,-48
    80002c70:	f406                	sd	ra,40(sp)
    80002c72:	f022                	sd	s0,32(sp)
    80002c74:	ec26                	sd	s1,24(sp)
    80002c76:	e84a                	sd	s2,16(sp)
    80002c78:	e44e                	sd	s3,8(sp)
    80002c7a:	1800                	addi	s0,sp,48
    80002c7c:	892a                	mv	s2,a0
    80002c7e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002c80:	00013517          	auipc	a0,0x13
    80002c84:	e6850513          	addi	a0,a0,-408 # 80015ae8 <bcache>
    80002c88:	f1ffd0ef          	jal	ra,80000ba6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002c8c:	0001b497          	auipc	s1,0x1b
    80002c90:	1144b483          	ld	s1,276(s1) # 8001dda0 <bcache+0x82b8>
    80002c94:	0001b797          	auipc	a5,0x1b
    80002c98:	0bc78793          	addi	a5,a5,188 # 8001dd50 <bcache+0x8268>
    80002c9c:	02f48b63          	beq	s1,a5,80002cd2 <bread+0x64>
    80002ca0:	873e                	mv	a4,a5
    80002ca2:	a021                	j	80002caa <bread+0x3c>
    80002ca4:	68a4                	ld	s1,80(s1)
    80002ca6:	02e48663          	beq	s1,a4,80002cd2 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002caa:	449c                	lw	a5,8(s1)
    80002cac:	ff279ce3          	bne	a5,s2,80002ca4 <bread+0x36>
    80002cb0:	44dc                	lw	a5,12(s1)
    80002cb2:	ff3799e3          	bne	a5,s3,80002ca4 <bread+0x36>
      b->refcnt++;
    80002cb6:	40bc                	lw	a5,64(s1)
    80002cb8:	2785                	addiw	a5,a5,1
    80002cba:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002cbc:	00013517          	auipc	a0,0x13
    80002cc0:	e2c50513          	addi	a0,a0,-468 # 80015ae8 <bcache>
    80002cc4:	f7bfd0ef          	jal	ra,80000c3e <release>
      acquiresleep(&b->lock);
    80002cc8:	01048513          	addi	a0,s1,16
    80002ccc:	1d6010ef          	jal	ra,80003ea2 <acquiresleep>
      return b;
    80002cd0:	a889                	j	80002d22 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002cd2:	0001b497          	auipc	s1,0x1b
    80002cd6:	0c64b483          	ld	s1,198(s1) # 8001dd98 <bcache+0x82b0>
    80002cda:	0001b797          	auipc	a5,0x1b
    80002cde:	07678793          	addi	a5,a5,118 # 8001dd50 <bcache+0x8268>
    80002ce2:	00f48863          	beq	s1,a5,80002cf2 <bread+0x84>
    80002ce6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002ce8:	40bc                	lw	a5,64(s1)
    80002cea:	cb91                	beqz	a5,80002cfe <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002cec:	64a4                	ld	s1,72(s1)
    80002cee:	fee49de3          	bne	s1,a4,80002ce8 <bread+0x7a>
  panic("bget: no buffers");
    80002cf2:	00005517          	auipc	a0,0x5
    80002cf6:	9b650513          	addi	a0,a0,-1610 # 800076a8 <syscalls+0x110>
    80002cfa:	a3dfd0ef          	jal	ra,80000736 <panic>
      b->dev = dev;
    80002cfe:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002d02:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002d06:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002d0a:	4785                	li	a5,1
    80002d0c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d0e:	00013517          	auipc	a0,0x13
    80002d12:	dda50513          	addi	a0,a0,-550 # 80015ae8 <bcache>
    80002d16:	f29fd0ef          	jal	ra,80000c3e <release>
      acquiresleep(&b->lock);
    80002d1a:	01048513          	addi	a0,s1,16
    80002d1e:	184010ef          	jal	ra,80003ea2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002d22:	409c                	lw	a5,0(s1)
    80002d24:	cb89                	beqz	a5,80002d36 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002d26:	8526                	mv	a0,s1
    80002d28:	70a2                	ld	ra,40(sp)
    80002d2a:	7402                	ld	s0,32(sp)
    80002d2c:	64e2                	ld	s1,24(sp)
    80002d2e:	6942                	ld	s2,16(sp)
    80002d30:	69a2                	ld	s3,8(sp)
    80002d32:	6145                	addi	sp,sp,48
    80002d34:	8082                	ret
    virtio_disk_rw(b, 0);
    80002d36:	4581                	li	a1,0
    80002d38:	8526                	mv	a0,s1
    80002d3a:	0d3020ef          	jal	ra,8000560c <virtio_disk_rw>
    b->valid = 1;
    80002d3e:	4785                	li	a5,1
    80002d40:	c09c                	sw	a5,0(s1)
  return b;
    80002d42:	b7d5                	j	80002d26 <bread+0xb8>

0000000080002d44 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002d44:	1101                	addi	sp,sp,-32
    80002d46:	ec06                	sd	ra,24(sp)
    80002d48:	e822                	sd	s0,16(sp)
    80002d4a:	e426                	sd	s1,8(sp)
    80002d4c:	1000                	addi	s0,sp,32
    80002d4e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002d50:	0541                	addi	a0,a0,16
    80002d52:	1ce010ef          	jal	ra,80003f20 <holdingsleep>
    80002d56:	c911                	beqz	a0,80002d6a <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002d58:	4585                	li	a1,1
    80002d5a:	8526                	mv	a0,s1
    80002d5c:	0b1020ef          	jal	ra,8000560c <virtio_disk_rw>
}
    80002d60:	60e2                	ld	ra,24(sp)
    80002d62:	6442                	ld	s0,16(sp)
    80002d64:	64a2                	ld	s1,8(sp)
    80002d66:	6105                	addi	sp,sp,32
    80002d68:	8082                	ret
    panic("bwrite");
    80002d6a:	00005517          	auipc	a0,0x5
    80002d6e:	95650513          	addi	a0,a0,-1706 # 800076c0 <syscalls+0x128>
    80002d72:	9c5fd0ef          	jal	ra,80000736 <panic>

0000000080002d76 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002d76:	1101                	addi	sp,sp,-32
    80002d78:	ec06                	sd	ra,24(sp)
    80002d7a:	e822                	sd	s0,16(sp)
    80002d7c:	e426                	sd	s1,8(sp)
    80002d7e:	e04a                	sd	s2,0(sp)
    80002d80:	1000                	addi	s0,sp,32
    80002d82:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002d84:	01050913          	addi	s2,a0,16
    80002d88:	854a                	mv	a0,s2
    80002d8a:	196010ef          	jal	ra,80003f20 <holdingsleep>
    80002d8e:	c13d                	beqz	a0,80002df4 <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
    80002d90:	854a                	mv	a0,s2
    80002d92:	156010ef          	jal	ra,80003ee8 <releasesleep>

  acquire(&bcache.lock);
    80002d96:	00013517          	auipc	a0,0x13
    80002d9a:	d5250513          	addi	a0,a0,-686 # 80015ae8 <bcache>
    80002d9e:	e09fd0ef          	jal	ra,80000ba6 <acquire>
  b->refcnt--;
    80002da2:	40bc                	lw	a5,64(s1)
    80002da4:	37fd                	addiw	a5,a5,-1
    80002da6:	0007871b          	sext.w	a4,a5
    80002daa:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002dac:	eb05                	bnez	a4,80002ddc <brelse+0x66>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002dae:	68bc                	ld	a5,80(s1)
    80002db0:	64b8                	ld	a4,72(s1)
    80002db2:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002db4:	64bc                	ld	a5,72(s1)
    80002db6:	68b8                	ld	a4,80(s1)
    80002db8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002dba:	0001b797          	auipc	a5,0x1b
    80002dbe:	d2e78793          	addi	a5,a5,-722 # 8001dae8 <bcache+0x8000>
    80002dc2:	2b87b703          	ld	a4,696(a5)
    80002dc6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002dc8:	0001b717          	auipc	a4,0x1b
    80002dcc:	f8870713          	addi	a4,a4,-120 # 8001dd50 <bcache+0x8268>
    80002dd0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002dd2:	2b87b703          	ld	a4,696(a5)
    80002dd6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002dd8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002ddc:	00013517          	auipc	a0,0x13
    80002de0:	d0c50513          	addi	a0,a0,-756 # 80015ae8 <bcache>
    80002de4:	e5bfd0ef          	jal	ra,80000c3e <release>
}
    80002de8:	60e2                	ld	ra,24(sp)
    80002dea:	6442                	ld	s0,16(sp)
    80002dec:	64a2                	ld	s1,8(sp)
    80002dee:	6902                	ld	s2,0(sp)
    80002df0:	6105                	addi	sp,sp,32
    80002df2:	8082                	ret
    panic("brelse");
    80002df4:	00005517          	auipc	a0,0x5
    80002df8:	8d450513          	addi	a0,a0,-1836 # 800076c8 <syscalls+0x130>
    80002dfc:	93bfd0ef          	jal	ra,80000736 <panic>

0000000080002e00 <bpin>:

void
bpin(struct buf *b) {
    80002e00:	1101                	addi	sp,sp,-32
    80002e02:	ec06                	sd	ra,24(sp)
    80002e04:	e822                	sd	s0,16(sp)
    80002e06:	e426                	sd	s1,8(sp)
    80002e08:	1000                	addi	s0,sp,32
    80002e0a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e0c:	00013517          	auipc	a0,0x13
    80002e10:	cdc50513          	addi	a0,a0,-804 # 80015ae8 <bcache>
    80002e14:	d93fd0ef          	jal	ra,80000ba6 <acquire>
  b->refcnt++;
    80002e18:	40bc                	lw	a5,64(s1)
    80002e1a:	2785                	addiw	a5,a5,1
    80002e1c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e1e:	00013517          	auipc	a0,0x13
    80002e22:	cca50513          	addi	a0,a0,-822 # 80015ae8 <bcache>
    80002e26:	e19fd0ef          	jal	ra,80000c3e <release>
}
    80002e2a:	60e2                	ld	ra,24(sp)
    80002e2c:	6442                	ld	s0,16(sp)
    80002e2e:	64a2                	ld	s1,8(sp)
    80002e30:	6105                	addi	sp,sp,32
    80002e32:	8082                	ret

0000000080002e34 <bunpin>:

void
bunpin(struct buf *b) {
    80002e34:	1101                	addi	sp,sp,-32
    80002e36:	ec06                	sd	ra,24(sp)
    80002e38:	e822                	sd	s0,16(sp)
    80002e3a:	e426                	sd	s1,8(sp)
    80002e3c:	1000                	addi	s0,sp,32
    80002e3e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e40:	00013517          	auipc	a0,0x13
    80002e44:	ca850513          	addi	a0,a0,-856 # 80015ae8 <bcache>
    80002e48:	d5ffd0ef          	jal	ra,80000ba6 <acquire>
  b->refcnt--;
    80002e4c:	40bc                	lw	a5,64(s1)
    80002e4e:	37fd                	addiw	a5,a5,-1
    80002e50:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e52:	00013517          	auipc	a0,0x13
    80002e56:	c9650513          	addi	a0,a0,-874 # 80015ae8 <bcache>
    80002e5a:	de5fd0ef          	jal	ra,80000c3e <release>
}
    80002e5e:	60e2                	ld	ra,24(sp)
    80002e60:	6442                	ld	s0,16(sp)
    80002e62:	64a2                	ld	s1,8(sp)
    80002e64:	6105                	addi	sp,sp,32
    80002e66:	8082                	ret

0000000080002e68 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002e68:	1101                	addi	sp,sp,-32
    80002e6a:	ec06                	sd	ra,24(sp)
    80002e6c:	e822                	sd	s0,16(sp)
    80002e6e:	e426                	sd	s1,8(sp)
    80002e70:	e04a                	sd	s2,0(sp)
    80002e72:	1000                	addi	s0,sp,32
    80002e74:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002e76:	00d5d59b          	srliw	a1,a1,0xd
    80002e7a:	0001b797          	auipc	a5,0x1b
    80002e7e:	34a7a783          	lw	a5,842(a5) # 8001e1c4 <sb+0x1c>
    80002e82:	9dbd                	addw	a1,a1,a5
    80002e84:	debff0ef          	jal	ra,80002c6e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002e88:	0074f713          	andi	a4,s1,7
    80002e8c:	4785                	li	a5,1
    80002e8e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002e92:	14ce                	slli	s1,s1,0x33
    80002e94:	90d9                	srli	s1,s1,0x36
    80002e96:	00950733          	add	a4,a0,s1
    80002e9a:	05874703          	lbu	a4,88(a4)
    80002e9e:	00e7f6b3          	and	a3,a5,a4
    80002ea2:	c29d                	beqz	a3,80002ec8 <bfree+0x60>
    80002ea4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002ea6:	94aa                	add	s1,s1,a0
    80002ea8:	fff7c793          	not	a5,a5
    80002eac:	8ff9                	and	a5,a5,a4
    80002eae:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002eb2:	6e9000ef          	jal	ra,80003d9a <log_write>
  brelse(bp);
    80002eb6:	854a                	mv	a0,s2
    80002eb8:	ebfff0ef          	jal	ra,80002d76 <brelse>
}
    80002ebc:	60e2                	ld	ra,24(sp)
    80002ebe:	6442                	ld	s0,16(sp)
    80002ec0:	64a2                	ld	s1,8(sp)
    80002ec2:	6902                	ld	s2,0(sp)
    80002ec4:	6105                	addi	sp,sp,32
    80002ec6:	8082                	ret
    panic("freeing free block");
    80002ec8:	00005517          	auipc	a0,0x5
    80002ecc:	80850513          	addi	a0,a0,-2040 # 800076d0 <syscalls+0x138>
    80002ed0:	867fd0ef          	jal	ra,80000736 <panic>

0000000080002ed4 <balloc>:
{
    80002ed4:	711d                	addi	sp,sp,-96
    80002ed6:	ec86                	sd	ra,88(sp)
    80002ed8:	e8a2                	sd	s0,80(sp)
    80002eda:	e4a6                	sd	s1,72(sp)
    80002edc:	e0ca                	sd	s2,64(sp)
    80002ede:	fc4e                	sd	s3,56(sp)
    80002ee0:	f852                	sd	s4,48(sp)
    80002ee2:	f456                	sd	s5,40(sp)
    80002ee4:	f05a                	sd	s6,32(sp)
    80002ee6:	ec5e                	sd	s7,24(sp)
    80002ee8:	e862                	sd	s8,16(sp)
    80002eea:	e466                	sd	s9,8(sp)
    80002eec:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002eee:	0001b797          	auipc	a5,0x1b
    80002ef2:	2be7a783          	lw	a5,702(a5) # 8001e1ac <sb+0x4>
    80002ef6:	0e078163          	beqz	a5,80002fd8 <balloc+0x104>
    80002efa:	8baa                	mv	s7,a0
    80002efc:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002efe:	0001bb17          	auipc	s6,0x1b
    80002f02:	2aab0b13          	addi	s6,s6,682 # 8001e1a8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f06:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002f08:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f0a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002f0c:	6c89                	lui	s9,0x2
    80002f0e:	a0b5                	j	80002f7a <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002f10:	974a                	add	a4,a4,s2
    80002f12:	8fd5                	or	a5,a5,a3
    80002f14:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002f18:	854a                	mv	a0,s2
    80002f1a:	681000ef          	jal	ra,80003d9a <log_write>
        brelse(bp);
    80002f1e:	854a                	mv	a0,s2
    80002f20:	e57ff0ef          	jal	ra,80002d76 <brelse>
  bp = bread(dev, bno);
    80002f24:	85a6                	mv	a1,s1
    80002f26:	855e                	mv	a0,s7
    80002f28:	d47ff0ef          	jal	ra,80002c6e <bread>
    80002f2c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002f2e:	40000613          	li	a2,1024
    80002f32:	4581                	li	a1,0
    80002f34:	05850513          	addi	a0,a0,88
    80002f38:	d43fd0ef          	jal	ra,80000c7a <memset>
  log_write(bp);
    80002f3c:	854a                	mv	a0,s2
    80002f3e:	65d000ef          	jal	ra,80003d9a <log_write>
  brelse(bp);
    80002f42:	854a                	mv	a0,s2
    80002f44:	e33ff0ef          	jal	ra,80002d76 <brelse>
}
    80002f48:	8526                	mv	a0,s1
    80002f4a:	60e6                	ld	ra,88(sp)
    80002f4c:	6446                	ld	s0,80(sp)
    80002f4e:	64a6                	ld	s1,72(sp)
    80002f50:	6906                	ld	s2,64(sp)
    80002f52:	79e2                	ld	s3,56(sp)
    80002f54:	7a42                	ld	s4,48(sp)
    80002f56:	7aa2                	ld	s5,40(sp)
    80002f58:	7b02                	ld	s6,32(sp)
    80002f5a:	6be2                	ld	s7,24(sp)
    80002f5c:	6c42                	ld	s8,16(sp)
    80002f5e:	6ca2                	ld	s9,8(sp)
    80002f60:	6125                	addi	sp,sp,96
    80002f62:	8082                	ret
    brelse(bp);
    80002f64:	854a                	mv	a0,s2
    80002f66:	e11ff0ef          	jal	ra,80002d76 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002f6a:	015c87bb          	addw	a5,s9,s5
    80002f6e:	00078a9b          	sext.w	s5,a5
    80002f72:	004b2703          	lw	a4,4(s6)
    80002f76:	06eaf163          	bgeu	s5,a4,80002fd8 <balloc+0x104>
    bp = bread(dev, BBLOCK(b, sb));
    80002f7a:	41fad79b          	sraiw	a5,s5,0x1f
    80002f7e:	0137d79b          	srliw	a5,a5,0x13
    80002f82:	015787bb          	addw	a5,a5,s5
    80002f86:	40d7d79b          	sraiw	a5,a5,0xd
    80002f8a:	01cb2583          	lw	a1,28(s6)
    80002f8e:	9dbd                	addw	a1,a1,a5
    80002f90:	855e                	mv	a0,s7
    80002f92:	cddff0ef          	jal	ra,80002c6e <bread>
    80002f96:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f98:	004b2503          	lw	a0,4(s6)
    80002f9c:	000a849b          	sext.w	s1,s5
    80002fa0:	8662                	mv	a2,s8
    80002fa2:	fca4f1e3          	bgeu	s1,a0,80002f64 <balloc+0x90>
      m = 1 << (bi % 8);
    80002fa6:	41f6579b          	sraiw	a5,a2,0x1f
    80002faa:	01d7d69b          	srliw	a3,a5,0x1d
    80002fae:	00c6873b          	addw	a4,a3,a2
    80002fb2:	00777793          	andi	a5,a4,7
    80002fb6:	9f95                	subw	a5,a5,a3
    80002fb8:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002fbc:	4037571b          	sraiw	a4,a4,0x3
    80002fc0:	00e906b3          	add	a3,s2,a4
    80002fc4:	0586c683          	lbu	a3,88(a3)
    80002fc8:	00d7f5b3          	and	a1,a5,a3
    80002fcc:	d1b1                	beqz	a1,80002f10 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002fce:	2605                	addiw	a2,a2,1
    80002fd0:	2485                	addiw	s1,s1,1
    80002fd2:	fd4618e3          	bne	a2,s4,80002fa2 <balloc+0xce>
    80002fd6:	b779                	j	80002f64 <balloc+0x90>
  printf("balloc: out of blocks\n");
    80002fd8:	00004517          	auipc	a0,0x4
    80002fdc:	71050513          	addi	a0,a0,1808 # 800076e8 <syscalls+0x150>
    80002fe0:	ca2fd0ef          	jal	ra,80000482 <printf>
  return 0;
    80002fe4:	4481                	li	s1,0
    80002fe6:	b78d                	j	80002f48 <balloc+0x74>

0000000080002fe8 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002fe8:	7179                	addi	sp,sp,-48
    80002fea:	f406                	sd	ra,40(sp)
    80002fec:	f022                	sd	s0,32(sp)
    80002fee:	ec26                	sd	s1,24(sp)
    80002ff0:	e84a                	sd	s2,16(sp)
    80002ff2:	e44e                	sd	s3,8(sp)
    80002ff4:	e052                	sd	s4,0(sp)
    80002ff6:	1800                	addi	s0,sp,48
    80002ff8:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002ffa:	47ad                	li	a5,11
    80002ffc:	02b7e563          	bltu	a5,a1,80003026 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80003000:	02059493          	slli	s1,a1,0x20
    80003004:	9081                	srli	s1,s1,0x20
    80003006:	048a                	slli	s1,s1,0x2
    80003008:	94aa                	add	s1,s1,a0
    8000300a:	0504a903          	lw	s2,80(s1)
    8000300e:	06091663          	bnez	s2,8000307a <bmap+0x92>
      addr = balloc(ip->dev);
    80003012:	4108                	lw	a0,0(a0)
    80003014:	ec1ff0ef          	jal	ra,80002ed4 <balloc>
    80003018:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000301c:	04090f63          	beqz	s2,8000307a <bmap+0x92>
        return 0;
      ip->addrs[bn] = addr;
    80003020:	0524a823          	sw	s2,80(s1)
    80003024:	a899                	j	8000307a <bmap+0x92>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003026:	ff45849b          	addiw	s1,a1,-12
    8000302a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000302e:	0ff00793          	li	a5,255
    80003032:	06e7eb63          	bltu	a5,a4,800030a8 <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003036:	08052903          	lw	s2,128(a0)
    8000303a:	00091b63          	bnez	s2,80003050 <bmap+0x68>
      addr = balloc(ip->dev);
    8000303e:	4108                	lw	a0,0(a0)
    80003040:	e95ff0ef          	jal	ra,80002ed4 <balloc>
    80003044:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003048:	02090963          	beqz	s2,8000307a <bmap+0x92>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000304c:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003050:	85ca                	mv	a1,s2
    80003052:	0009a503          	lw	a0,0(s3)
    80003056:	c19ff0ef          	jal	ra,80002c6e <bread>
    8000305a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000305c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003060:	02049593          	slli	a1,s1,0x20
    80003064:	9181                	srli	a1,a1,0x20
    80003066:	058a                	slli	a1,a1,0x2
    80003068:	00b784b3          	add	s1,a5,a1
    8000306c:	0004a903          	lw	s2,0(s1)
    80003070:	00090e63          	beqz	s2,8000308c <bmap+0xa4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003074:	8552                	mv	a0,s4
    80003076:	d01ff0ef          	jal	ra,80002d76 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000307a:	854a                	mv	a0,s2
    8000307c:	70a2                	ld	ra,40(sp)
    8000307e:	7402                	ld	s0,32(sp)
    80003080:	64e2                	ld	s1,24(sp)
    80003082:	6942                	ld	s2,16(sp)
    80003084:	69a2                	ld	s3,8(sp)
    80003086:	6a02                	ld	s4,0(sp)
    80003088:	6145                	addi	sp,sp,48
    8000308a:	8082                	ret
      addr = balloc(ip->dev);
    8000308c:	0009a503          	lw	a0,0(s3)
    80003090:	e45ff0ef          	jal	ra,80002ed4 <balloc>
    80003094:	0005091b          	sext.w	s2,a0
      if(addr){
    80003098:	fc090ee3          	beqz	s2,80003074 <bmap+0x8c>
        a[bn] = addr;
    8000309c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800030a0:	8552                	mv	a0,s4
    800030a2:	4f9000ef          	jal	ra,80003d9a <log_write>
    800030a6:	b7f9                	j	80003074 <bmap+0x8c>
  panic("bmap: out of range");
    800030a8:	00004517          	auipc	a0,0x4
    800030ac:	65850513          	addi	a0,a0,1624 # 80007700 <syscalls+0x168>
    800030b0:	e86fd0ef          	jal	ra,80000736 <panic>

00000000800030b4 <iget>:
{
    800030b4:	7179                	addi	sp,sp,-48
    800030b6:	f406                	sd	ra,40(sp)
    800030b8:	f022                	sd	s0,32(sp)
    800030ba:	ec26                	sd	s1,24(sp)
    800030bc:	e84a                	sd	s2,16(sp)
    800030be:	e44e                	sd	s3,8(sp)
    800030c0:	e052                	sd	s4,0(sp)
    800030c2:	1800                	addi	s0,sp,48
    800030c4:	89aa                	mv	s3,a0
    800030c6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800030c8:	0001b517          	auipc	a0,0x1b
    800030cc:	10050513          	addi	a0,a0,256 # 8001e1c8 <itable>
    800030d0:	ad7fd0ef          	jal	ra,80000ba6 <acquire>
  empty = 0;
    800030d4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800030d6:	0001b497          	auipc	s1,0x1b
    800030da:	10a48493          	addi	s1,s1,266 # 8001e1e0 <itable+0x18>
    800030de:	0001d697          	auipc	a3,0x1d
    800030e2:	b9268693          	addi	a3,a3,-1134 # 8001fc70 <log>
    800030e6:	a039                	j	800030f4 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800030e8:	02090963          	beqz	s2,8000311a <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800030ec:	08848493          	addi	s1,s1,136
    800030f0:	02d48863          	beq	s1,a3,80003120 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800030f4:	449c                	lw	a5,8(s1)
    800030f6:	fef059e3          	blez	a5,800030e8 <iget+0x34>
    800030fa:	4098                	lw	a4,0(s1)
    800030fc:	ff3716e3          	bne	a4,s3,800030e8 <iget+0x34>
    80003100:	40d8                	lw	a4,4(s1)
    80003102:	ff4713e3          	bne	a4,s4,800030e8 <iget+0x34>
      ip->ref++;
    80003106:	2785                	addiw	a5,a5,1
    80003108:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000310a:	0001b517          	auipc	a0,0x1b
    8000310e:	0be50513          	addi	a0,a0,190 # 8001e1c8 <itable>
    80003112:	b2dfd0ef          	jal	ra,80000c3e <release>
      return ip;
    80003116:	8926                	mv	s2,s1
    80003118:	a02d                	j	80003142 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000311a:	fbe9                	bnez	a5,800030ec <iget+0x38>
    8000311c:	8926                	mv	s2,s1
    8000311e:	b7f9                	j	800030ec <iget+0x38>
  if(empty == 0)
    80003120:	02090a63          	beqz	s2,80003154 <iget+0xa0>
  ip->dev = dev;
    80003124:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003128:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000312c:	4785                	li	a5,1
    8000312e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003132:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003136:	0001b517          	auipc	a0,0x1b
    8000313a:	09250513          	addi	a0,a0,146 # 8001e1c8 <itable>
    8000313e:	b01fd0ef          	jal	ra,80000c3e <release>
}
    80003142:	854a                	mv	a0,s2
    80003144:	70a2                	ld	ra,40(sp)
    80003146:	7402                	ld	s0,32(sp)
    80003148:	64e2                	ld	s1,24(sp)
    8000314a:	6942                	ld	s2,16(sp)
    8000314c:	69a2                	ld	s3,8(sp)
    8000314e:	6a02                	ld	s4,0(sp)
    80003150:	6145                	addi	sp,sp,48
    80003152:	8082                	ret
    panic("iget: no inodes");
    80003154:	00004517          	auipc	a0,0x4
    80003158:	5c450513          	addi	a0,a0,1476 # 80007718 <syscalls+0x180>
    8000315c:	ddafd0ef          	jal	ra,80000736 <panic>

0000000080003160 <fsinit>:
fsinit(int dev) {
    80003160:	7179                	addi	sp,sp,-48
    80003162:	f406                	sd	ra,40(sp)
    80003164:	f022                	sd	s0,32(sp)
    80003166:	ec26                	sd	s1,24(sp)
    80003168:	e84a                	sd	s2,16(sp)
    8000316a:	e44e                	sd	s3,8(sp)
    8000316c:	1800                	addi	s0,sp,48
    8000316e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003170:	4585                	li	a1,1
    80003172:	afdff0ef          	jal	ra,80002c6e <bread>
    80003176:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003178:	0001b997          	auipc	s3,0x1b
    8000317c:	03098993          	addi	s3,s3,48 # 8001e1a8 <sb>
    80003180:	02000613          	li	a2,32
    80003184:	05850593          	addi	a1,a0,88
    80003188:	854e                	mv	a0,s3
    8000318a:	b4dfd0ef          	jal	ra,80000cd6 <memmove>
  brelse(bp);
    8000318e:	8526                	mv	a0,s1
    80003190:	be7ff0ef          	jal	ra,80002d76 <brelse>
  if(sb.magic != FSMAGIC)
    80003194:	0009a703          	lw	a4,0(s3)
    80003198:	102037b7          	lui	a5,0x10203
    8000319c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800031a0:	02f71063          	bne	a4,a5,800031c0 <fsinit+0x60>
  initlog(dev, &sb);
    800031a4:	0001b597          	auipc	a1,0x1b
    800031a8:	00458593          	addi	a1,a1,4 # 8001e1a8 <sb>
    800031ac:	854a                	mv	a0,s2
    800031ae:	1d9000ef          	jal	ra,80003b86 <initlog>
}
    800031b2:	70a2                	ld	ra,40(sp)
    800031b4:	7402                	ld	s0,32(sp)
    800031b6:	64e2                	ld	s1,24(sp)
    800031b8:	6942                	ld	s2,16(sp)
    800031ba:	69a2                	ld	s3,8(sp)
    800031bc:	6145                	addi	sp,sp,48
    800031be:	8082                	ret
    panic("invalid file system");
    800031c0:	00004517          	auipc	a0,0x4
    800031c4:	56850513          	addi	a0,a0,1384 # 80007728 <syscalls+0x190>
    800031c8:	d6efd0ef          	jal	ra,80000736 <panic>

00000000800031cc <iinit>:
{
    800031cc:	7179                	addi	sp,sp,-48
    800031ce:	f406                	sd	ra,40(sp)
    800031d0:	f022                	sd	s0,32(sp)
    800031d2:	ec26                	sd	s1,24(sp)
    800031d4:	e84a                	sd	s2,16(sp)
    800031d6:	e44e                	sd	s3,8(sp)
    800031d8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800031da:	00004597          	auipc	a1,0x4
    800031de:	56658593          	addi	a1,a1,1382 # 80007740 <syscalls+0x1a8>
    800031e2:	0001b517          	auipc	a0,0x1b
    800031e6:	fe650513          	addi	a0,a0,-26 # 8001e1c8 <itable>
    800031ea:	93dfd0ef          	jal	ra,80000b26 <initlock>
  for(i = 0; i < NINODE; i++) {
    800031ee:	0001b497          	auipc	s1,0x1b
    800031f2:	00248493          	addi	s1,s1,2 # 8001e1f0 <itable+0x28>
    800031f6:	0001d997          	auipc	s3,0x1d
    800031fa:	a8a98993          	addi	s3,s3,-1398 # 8001fc80 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800031fe:	00004917          	auipc	s2,0x4
    80003202:	54a90913          	addi	s2,s2,1354 # 80007748 <syscalls+0x1b0>
    80003206:	85ca                	mv	a1,s2
    80003208:	8526                	mv	a0,s1
    8000320a:	463000ef          	jal	ra,80003e6c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000320e:	08848493          	addi	s1,s1,136
    80003212:	ff349ae3          	bne	s1,s3,80003206 <iinit+0x3a>
}
    80003216:	70a2                	ld	ra,40(sp)
    80003218:	7402                	ld	s0,32(sp)
    8000321a:	64e2                	ld	s1,24(sp)
    8000321c:	6942                	ld	s2,16(sp)
    8000321e:	69a2                	ld	s3,8(sp)
    80003220:	6145                	addi	sp,sp,48
    80003222:	8082                	ret

0000000080003224 <ialloc>:
{
    80003224:	715d                	addi	sp,sp,-80
    80003226:	e486                	sd	ra,72(sp)
    80003228:	e0a2                	sd	s0,64(sp)
    8000322a:	fc26                	sd	s1,56(sp)
    8000322c:	f84a                	sd	s2,48(sp)
    8000322e:	f44e                	sd	s3,40(sp)
    80003230:	f052                	sd	s4,32(sp)
    80003232:	ec56                	sd	s5,24(sp)
    80003234:	e85a                	sd	s6,16(sp)
    80003236:	e45e                	sd	s7,8(sp)
    80003238:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000323a:	0001b717          	auipc	a4,0x1b
    8000323e:	f7a72703          	lw	a4,-134(a4) # 8001e1b4 <sb+0xc>
    80003242:	4785                	li	a5,1
    80003244:	04e7f663          	bgeu	a5,a4,80003290 <ialloc+0x6c>
    80003248:	8aaa                	mv	s5,a0
    8000324a:	8bae                	mv	s7,a1
    8000324c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000324e:	0001ba17          	auipc	s4,0x1b
    80003252:	f5aa0a13          	addi	s4,s4,-166 # 8001e1a8 <sb>
    80003256:	00048b1b          	sext.w	s6,s1
    8000325a:	0044d793          	srli	a5,s1,0x4
    8000325e:	018a2583          	lw	a1,24(s4)
    80003262:	9dbd                	addw	a1,a1,a5
    80003264:	8556                	mv	a0,s5
    80003266:	a09ff0ef          	jal	ra,80002c6e <bread>
    8000326a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000326c:	05850993          	addi	s3,a0,88
    80003270:	00f4f793          	andi	a5,s1,15
    80003274:	079a                	slli	a5,a5,0x6
    80003276:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003278:	00099783          	lh	a5,0(s3)
    8000327c:	cf85                	beqz	a5,800032b4 <ialloc+0x90>
    brelse(bp);
    8000327e:	af9ff0ef          	jal	ra,80002d76 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003282:	0485                	addi	s1,s1,1
    80003284:	00ca2703          	lw	a4,12(s4)
    80003288:	0004879b          	sext.w	a5,s1
    8000328c:	fce7e5e3          	bltu	a5,a4,80003256 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003290:	00004517          	auipc	a0,0x4
    80003294:	4c050513          	addi	a0,a0,1216 # 80007750 <syscalls+0x1b8>
    80003298:	9eafd0ef          	jal	ra,80000482 <printf>
  return 0;
    8000329c:	4501                	li	a0,0
}
    8000329e:	60a6                	ld	ra,72(sp)
    800032a0:	6406                	ld	s0,64(sp)
    800032a2:	74e2                	ld	s1,56(sp)
    800032a4:	7942                	ld	s2,48(sp)
    800032a6:	79a2                	ld	s3,40(sp)
    800032a8:	7a02                	ld	s4,32(sp)
    800032aa:	6ae2                	ld	s5,24(sp)
    800032ac:	6b42                	ld	s6,16(sp)
    800032ae:	6ba2                	ld	s7,8(sp)
    800032b0:	6161                	addi	sp,sp,80
    800032b2:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800032b4:	04000613          	li	a2,64
    800032b8:	4581                	li	a1,0
    800032ba:	854e                	mv	a0,s3
    800032bc:	9bffd0ef          	jal	ra,80000c7a <memset>
      dip->type = type;
    800032c0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800032c4:	854a                	mv	a0,s2
    800032c6:	2d5000ef          	jal	ra,80003d9a <log_write>
      brelse(bp);
    800032ca:	854a                	mv	a0,s2
    800032cc:	aabff0ef          	jal	ra,80002d76 <brelse>
      return iget(dev, inum);
    800032d0:	85da                	mv	a1,s6
    800032d2:	8556                	mv	a0,s5
    800032d4:	de1ff0ef          	jal	ra,800030b4 <iget>
    800032d8:	b7d9                	j	8000329e <ialloc+0x7a>

00000000800032da <iupdate>:
{
    800032da:	1101                	addi	sp,sp,-32
    800032dc:	ec06                	sd	ra,24(sp)
    800032de:	e822                	sd	s0,16(sp)
    800032e0:	e426                	sd	s1,8(sp)
    800032e2:	e04a                	sd	s2,0(sp)
    800032e4:	1000                	addi	s0,sp,32
    800032e6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800032e8:	415c                	lw	a5,4(a0)
    800032ea:	0047d79b          	srliw	a5,a5,0x4
    800032ee:	0001b597          	auipc	a1,0x1b
    800032f2:	ed25a583          	lw	a1,-302(a1) # 8001e1c0 <sb+0x18>
    800032f6:	9dbd                	addw	a1,a1,a5
    800032f8:	4108                	lw	a0,0(a0)
    800032fa:	975ff0ef          	jal	ra,80002c6e <bread>
    800032fe:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003300:	05850793          	addi	a5,a0,88
    80003304:	40c8                	lw	a0,4(s1)
    80003306:	893d                	andi	a0,a0,15
    80003308:	051a                	slli	a0,a0,0x6
    8000330a:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    8000330c:	04449703          	lh	a4,68(s1)
    80003310:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003314:	04649703          	lh	a4,70(s1)
    80003318:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    8000331c:	04849703          	lh	a4,72(s1)
    80003320:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003324:	04a49703          	lh	a4,74(s1)
    80003328:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    8000332c:	44f8                	lw	a4,76(s1)
    8000332e:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003330:	03400613          	li	a2,52
    80003334:	05048593          	addi	a1,s1,80
    80003338:	0531                	addi	a0,a0,12
    8000333a:	99dfd0ef          	jal	ra,80000cd6 <memmove>
  log_write(bp);
    8000333e:	854a                	mv	a0,s2
    80003340:	25b000ef          	jal	ra,80003d9a <log_write>
  brelse(bp);
    80003344:	854a                	mv	a0,s2
    80003346:	a31ff0ef          	jal	ra,80002d76 <brelse>
}
    8000334a:	60e2                	ld	ra,24(sp)
    8000334c:	6442                	ld	s0,16(sp)
    8000334e:	64a2                	ld	s1,8(sp)
    80003350:	6902                	ld	s2,0(sp)
    80003352:	6105                	addi	sp,sp,32
    80003354:	8082                	ret

0000000080003356 <idup>:
{
    80003356:	1101                	addi	sp,sp,-32
    80003358:	ec06                	sd	ra,24(sp)
    8000335a:	e822                	sd	s0,16(sp)
    8000335c:	e426                	sd	s1,8(sp)
    8000335e:	1000                	addi	s0,sp,32
    80003360:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003362:	0001b517          	auipc	a0,0x1b
    80003366:	e6650513          	addi	a0,a0,-410 # 8001e1c8 <itable>
    8000336a:	83dfd0ef          	jal	ra,80000ba6 <acquire>
  ip->ref++;
    8000336e:	449c                	lw	a5,8(s1)
    80003370:	2785                	addiw	a5,a5,1
    80003372:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003374:	0001b517          	auipc	a0,0x1b
    80003378:	e5450513          	addi	a0,a0,-428 # 8001e1c8 <itable>
    8000337c:	8c3fd0ef          	jal	ra,80000c3e <release>
}
    80003380:	8526                	mv	a0,s1
    80003382:	60e2                	ld	ra,24(sp)
    80003384:	6442                	ld	s0,16(sp)
    80003386:	64a2                	ld	s1,8(sp)
    80003388:	6105                	addi	sp,sp,32
    8000338a:	8082                	ret

000000008000338c <ilock>:
{
    8000338c:	1101                	addi	sp,sp,-32
    8000338e:	ec06                	sd	ra,24(sp)
    80003390:	e822                	sd	s0,16(sp)
    80003392:	e426                	sd	s1,8(sp)
    80003394:	e04a                	sd	s2,0(sp)
    80003396:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003398:	c105                	beqz	a0,800033b8 <ilock+0x2c>
    8000339a:	84aa                	mv	s1,a0
    8000339c:	451c                	lw	a5,8(a0)
    8000339e:	00f05d63          	blez	a5,800033b8 <ilock+0x2c>
  acquiresleep(&ip->lock);
    800033a2:	0541                	addi	a0,a0,16
    800033a4:	2ff000ef          	jal	ra,80003ea2 <acquiresleep>
  if(ip->valid == 0){
    800033a8:	40bc                	lw	a5,64(s1)
    800033aa:	cf89                	beqz	a5,800033c4 <ilock+0x38>
}
    800033ac:	60e2                	ld	ra,24(sp)
    800033ae:	6442                	ld	s0,16(sp)
    800033b0:	64a2                	ld	s1,8(sp)
    800033b2:	6902                	ld	s2,0(sp)
    800033b4:	6105                	addi	sp,sp,32
    800033b6:	8082                	ret
    panic("ilock");
    800033b8:	00004517          	auipc	a0,0x4
    800033bc:	3b050513          	addi	a0,a0,944 # 80007768 <syscalls+0x1d0>
    800033c0:	b76fd0ef          	jal	ra,80000736 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800033c4:	40dc                	lw	a5,4(s1)
    800033c6:	0047d79b          	srliw	a5,a5,0x4
    800033ca:	0001b597          	auipc	a1,0x1b
    800033ce:	df65a583          	lw	a1,-522(a1) # 8001e1c0 <sb+0x18>
    800033d2:	9dbd                	addw	a1,a1,a5
    800033d4:	4088                	lw	a0,0(s1)
    800033d6:	899ff0ef          	jal	ra,80002c6e <bread>
    800033da:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800033dc:	05850593          	addi	a1,a0,88
    800033e0:	40dc                	lw	a5,4(s1)
    800033e2:	8bbd                	andi	a5,a5,15
    800033e4:	079a                	slli	a5,a5,0x6
    800033e6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800033e8:	00059783          	lh	a5,0(a1)
    800033ec:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800033f0:	00259783          	lh	a5,2(a1)
    800033f4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800033f8:	00459783          	lh	a5,4(a1)
    800033fc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003400:	00659783          	lh	a5,6(a1)
    80003404:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003408:	459c                	lw	a5,8(a1)
    8000340a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000340c:	03400613          	li	a2,52
    80003410:	05b1                	addi	a1,a1,12
    80003412:	05048513          	addi	a0,s1,80
    80003416:	8c1fd0ef          	jal	ra,80000cd6 <memmove>
    brelse(bp);
    8000341a:	854a                	mv	a0,s2
    8000341c:	95bff0ef          	jal	ra,80002d76 <brelse>
    ip->valid = 1;
    80003420:	4785                	li	a5,1
    80003422:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003424:	04449783          	lh	a5,68(s1)
    80003428:	f3d1                	bnez	a5,800033ac <ilock+0x20>
      panic("ilock: no type");
    8000342a:	00004517          	auipc	a0,0x4
    8000342e:	34650513          	addi	a0,a0,838 # 80007770 <syscalls+0x1d8>
    80003432:	b04fd0ef          	jal	ra,80000736 <panic>

0000000080003436 <iunlock>:
{
    80003436:	1101                	addi	sp,sp,-32
    80003438:	ec06                	sd	ra,24(sp)
    8000343a:	e822                	sd	s0,16(sp)
    8000343c:	e426                	sd	s1,8(sp)
    8000343e:	e04a                	sd	s2,0(sp)
    80003440:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003442:	c505                	beqz	a0,8000346a <iunlock+0x34>
    80003444:	84aa                	mv	s1,a0
    80003446:	01050913          	addi	s2,a0,16
    8000344a:	854a                	mv	a0,s2
    8000344c:	2d5000ef          	jal	ra,80003f20 <holdingsleep>
    80003450:	cd09                	beqz	a0,8000346a <iunlock+0x34>
    80003452:	449c                	lw	a5,8(s1)
    80003454:	00f05b63          	blez	a5,8000346a <iunlock+0x34>
  releasesleep(&ip->lock);
    80003458:	854a                	mv	a0,s2
    8000345a:	28f000ef          	jal	ra,80003ee8 <releasesleep>
}
    8000345e:	60e2                	ld	ra,24(sp)
    80003460:	6442                	ld	s0,16(sp)
    80003462:	64a2                	ld	s1,8(sp)
    80003464:	6902                	ld	s2,0(sp)
    80003466:	6105                	addi	sp,sp,32
    80003468:	8082                	ret
    panic("iunlock");
    8000346a:	00004517          	auipc	a0,0x4
    8000346e:	31650513          	addi	a0,a0,790 # 80007780 <syscalls+0x1e8>
    80003472:	ac4fd0ef          	jal	ra,80000736 <panic>

0000000080003476 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003476:	7179                	addi	sp,sp,-48
    80003478:	f406                	sd	ra,40(sp)
    8000347a:	f022                	sd	s0,32(sp)
    8000347c:	ec26                	sd	s1,24(sp)
    8000347e:	e84a                	sd	s2,16(sp)
    80003480:	e44e                	sd	s3,8(sp)
    80003482:	e052                	sd	s4,0(sp)
    80003484:	1800                	addi	s0,sp,48
    80003486:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003488:	05050493          	addi	s1,a0,80
    8000348c:	08050913          	addi	s2,a0,128
    80003490:	a021                	j	80003498 <itrunc+0x22>
    80003492:	0491                	addi	s1,s1,4
    80003494:	01248b63          	beq	s1,s2,800034aa <itrunc+0x34>
    if(ip->addrs[i]){
    80003498:	408c                	lw	a1,0(s1)
    8000349a:	dde5                	beqz	a1,80003492 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    8000349c:	0009a503          	lw	a0,0(s3)
    800034a0:	9c9ff0ef          	jal	ra,80002e68 <bfree>
      ip->addrs[i] = 0;
    800034a4:	0004a023          	sw	zero,0(s1)
    800034a8:	b7ed                	j	80003492 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    800034aa:	0809a583          	lw	a1,128(s3)
    800034ae:	ed91                	bnez	a1,800034ca <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800034b0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800034b4:	854e                	mv	a0,s3
    800034b6:	e25ff0ef          	jal	ra,800032da <iupdate>
}
    800034ba:	70a2                	ld	ra,40(sp)
    800034bc:	7402                	ld	s0,32(sp)
    800034be:	64e2                	ld	s1,24(sp)
    800034c0:	6942                	ld	s2,16(sp)
    800034c2:	69a2                	ld	s3,8(sp)
    800034c4:	6a02                	ld	s4,0(sp)
    800034c6:	6145                	addi	sp,sp,48
    800034c8:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800034ca:	0009a503          	lw	a0,0(s3)
    800034ce:	fa0ff0ef          	jal	ra,80002c6e <bread>
    800034d2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800034d4:	05850493          	addi	s1,a0,88
    800034d8:	45850913          	addi	s2,a0,1112
    800034dc:	a021                	j	800034e4 <itrunc+0x6e>
    800034de:	0491                	addi	s1,s1,4
    800034e0:	01248963          	beq	s1,s2,800034f2 <itrunc+0x7c>
      if(a[j])
    800034e4:	408c                	lw	a1,0(s1)
    800034e6:	dde5                	beqz	a1,800034de <itrunc+0x68>
        bfree(ip->dev, a[j]);
    800034e8:	0009a503          	lw	a0,0(s3)
    800034ec:	97dff0ef          	jal	ra,80002e68 <bfree>
    800034f0:	b7fd                	j	800034de <itrunc+0x68>
    brelse(bp);
    800034f2:	8552                	mv	a0,s4
    800034f4:	883ff0ef          	jal	ra,80002d76 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800034f8:	0809a583          	lw	a1,128(s3)
    800034fc:	0009a503          	lw	a0,0(s3)
    80003500:	969ff0ef          	jal	ra,80002e68 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003504:	0809a023          	sw	zero,128(s3)
    80003508:	b765                	j	800034b0 <itrunc+0x3a>

000000008000350a <iput>:
{
    8000350a:	1101                	addi	sp,sp,-32
    8000350c:	ec06                	sd	ra,24(sp)
    8000350e:	e822                	sd	s0,16(sp)
    80003510:	e426                	sd	s1,8(sp)
    80003512:	e04a                	sd	s2,0(sp)
    80003514:	1000                	addi	s0,sp,32
    80003516:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003518:	0001b517          	auipc	a0,0x1b
    8000351c:	cb050513          	addi	a0,a0,-848 # 8001e1c8 <itable>
    80003520:	e86fd0ef          	jal	ra,80000ba6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003524:	4498                	lw	a4,8(s1)
    80003526:	4785                	li	a5,1
    80003528:	02f70163          	beq	a4,a5,8000354a <iput+0x40>
  ip->ref--;
    8000352c:	449c                	lw	a5,8(s1)
    8000352e:	37fd                	addiw	a5,a5,-1
    80003530:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003532:	0001b517          	auipc	a0,0x1b
    80003536:	c9650513          	addi	a0,a0,-874 # 8001e1c8 <itable>
    8000353a:	f04fd0ef          	jal	ra,80000c3e <release>
}
    8000353e:	60e2                	ld	ra,24(sp)
    80003540:	6442                	ld	s0,16(sp)
    80003542:	64a2                	ld	s1,8(sp)
    80003544:	6902                	ld	s2,0(sp)
    80003546:	6105                	addi	sp,sp,32
    80003548:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000354a:	40bc                	lw	a5,64(s1)
    8000354c:	d3e5                	beqz	a5,8000352c <iput+0x22>
    8000354e:	04a49783          	lh	a5,74(s1)
    80003552:	ffe9                	bnez	a5,8000352c <iput+0x22>
    acquiresleep(&ip->lock);
    80003554:	01048913          	addi	s2,s1,16
    80003558:	854a                	mv	a0,s2
    8000355a:	149000ef          	jal	ra,80003ea2 <acquiresleep>
    release(&itable.lock);
    8000355e:	0001b517          	auipc	a0,0x1b
    80003562:	c6a50513          	addi	a0,a0,-918 # 8001e1c8 <itable>
    80003566:	ed8fd0ef          	jal	ra,80000c3e <release>
    itrunc(ip);
    8000356a:	8526                	mv	a0,s1
    8000356c:	f0bff0ef          	jal	ra,80003476 <itrunc>
    ip->type = 0;
    80003570:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003574:	8526                	mv	a0,s1
    80003576:	d65ff0ef          	jal	ra,800032da <iupdate>
    ip->valid = 0;
    8000357a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000357e:	854a                	mv	a0,s2
    80003580:	169000ef          	jal	ra,80003ee8 <releasesleep>
    acquire(&itable.lock);
    80003584:	0001b517          	auipc	a0,0x1b
    80003588:	c4450513          	addi	a0,a0,-956 # 8001e1c8 <itable>
    8000358c:	e1afd0ef          	jal	ra,80000ba6 <acquire>
    80003590:	bf71                	j	8000352c <iput+0x22>

0000000080003592 <iunlockput>:
{
    80003592:	1101                	addi	sp,sp,-32
    80003594:	ec06                	sd	ra,24(sp)
    80003596:	e822                	sd	s0,16(sp)
    80003598:	e426                	sd	s1,8(sp)
    8000359a:	1000                	addi	s0,sp,32
    8000359c:	84aa                	mv	s1,a0
  iunlock(ip);
    8000359e:	e99ff0ef          	jal	ra,80003436 <iunlock>
  iput(ip);
    800035a2:	8526                	mv	a0,s1
    800035a4:	f67ff0ef          	jal	ra,8000350a <iput>
}
    800035a8:	60e2                	ld	ra,24(sp)
    800035aa:	6442                	ld	s0,16(sp)
    800035ac:	64a2                	ld	s1,8(sp)
    800035ae:	6105                	addi	sp,sp,32
    800035b0:	8082                	ret

00000000800035b2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800035b2:	1141                	addi	sp,sp,-16
    800035b4:	e422                	sd	s0,8(sp)
    800035b6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800035b8:	411c                	lw	a5,0(a0)
    800035ba:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800035bc:	415c                	lw	a5,4(a0)
    800035be:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800035c0:	04451783          	lh	a5,68(a0)
    800035c4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800035c8:	04a51783          	lh	a5,74(a0)
    800035cc:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800035d0:	04c56783          	lwu	a5,76(a0)
    800035d4:	e99c                	sd	a5,16(a1)
}
    800035d6:	6422                	ld	s0,8(sp)
    800035d8:	0141                	addi	sp,sp,16
    800035da:	8082                	ret

00000000800035dc <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800035dc:	457c                	lw	a5,76(a0)
    800035de:	0cd7ef63          	bltu	a5,a3,800036bc <readi+0xe0>
{
    800035e2:	7159                	addi	sp,sp,-112
    800035e4:	f486                	sd	ra,104(sp)
    800035e6:	f0a2                	sd	s0,96(sp)
    800035e8:	eca6                	sd	s1,88(sp)
    800035ea:	e8ca                	sd	s2,80(sp)
    800035ec:	e4ce                	sd	s3,72(sp)
    800035ee:	e0d2                	sd	s4,64(sp)
    800035f0:	fc56                	sd	s5,56(sp)
    800035f2:	f85a                	sd	s6,48(sp)
    800035f4:	f45e                	sd	s7,40(sp)
    800035f6:	f062                	sd	s8,32(sp)
    800035f8:	ec66                	sd	s9,24(sp)
    800035fa:	e86a                	sd	s10,16(sp)
    800035fc:	e46e                	sd	s11,8(sp)
    800035fe:	1880                	addi	s0,sp,112
    80003600:	8b2a                	mv	s6,a0
    80003602:	8bae                	mv	s7,a1
    80003604:	8a32                	mv	s4,a2
    80003606:	84b6                	mv	s1,a3
    80003608:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000360a:	9f35                	addw	a4,a4,a3
    return 0;
    8000360c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000360e:	08d76663          	bltu	a4,a3,8000369a <readi+0xbe>
  if(off + n > ip->size)
    80003612:	00e7f463          	bgeu	a5,a4,8000361a <readi+0x3e>
    n = ip->size - off;
    80003616:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000361a:	080a8f63          	beqz	s5,800036b8 <readi+0xdc>
    8000361e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003620:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003624:	5c7d                	li	s8,-1
    80003626:	a80d                	j	80003658 <readi+0x7c>
    80003628:	020d1d93          	slli	s11,s10,0x20
    8000362c:	020ddd93          	srli	s11,s11,0x20
    80003630:	05890793          	addi	a5,s2,88
    80003634:	86ee                	mv	a3,s11
    80003636:	963e                	add	a2,a2,a5
    80003638:	85d2                	mv	a1,s4
    8000363a:	855e                	mv	a0,s7
    8000363c:	c31fe0ef          	jal	ra,8000226c <either_copyout>
    80003640:	05850763          	beq	a0,s8,8000368e <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003644:	854a                	mv	a0,s2
    80003646:	f30ff0ef          	jal	ra,80002d76 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000364a:	013d09bb          	addw	s3,s10,s3
    8000364e:	009d04bb          	addw	s1,s10,s1
    80003652:	9a6e                	add	s4,s4,s11
    80003654:	0559f163          	bgeu	s3,s5,80003696 <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    80003658:	00a4d59b          	srliw	a1,s1,0xa
    8000365c:	855a                	mv	a0,s6
    8000365e:	98bff0ef          	jal	ra,80002fe8 <bmap>
    80003662:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003666:	c985                	beqz	a1,80003696 <readi+0xba>
    bp = bread(ip->dev, addr);
    80003668:	000b2503          	lw	a0,0(s6)
    8000366c:	e02ff0ef          	jal	ra,80002c6e <bread>
    80003670:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003672:	3ff4f613          	andi	a2,s1,1023
    80003676:	40cc87bb          	subw	a5,s9,a2
    8000367a:	413a873b          	subw	a4,s5,s3
    8000367e:	8d3e                	mv	s10,a5
    80003680:	2781                	sext.w	a5,a5
    80003682:	0007069b          	sext.w	a3,a4
    80003686:	faf6f1e3          	bgeu	a3,a5,80003628 <readi+0x4c>
    8000368a:	8d3a                	mv	s10,a4
    8000368c:	bf71                	j	80003628 <readi+0x4c>
      brelse(bp);
    8000368e:	854a                	mv	a0,s2
    80003690:	ee6ff0ef          	jal	ra,80002d76 <brelse>
      tot = -1;
    80003694:	59fd                	li	s3,-1
  }
  return tot;
    80003696:	0009851b          	sext.w	a0,s3
}
    8000369a:	70a6                	ld	ra,104(sp)
    8000369c:	7406                	ld	s0,96(sp)
    8000369e:	64e6                	ld	s1,88(sp)
    800036a0:	6946                	ld	s2,80(sp)
    800036a2:	69a6                	ld	s3,72(sp)
    800036a4:	6a06                	ld	s4,64(sp)
    800036a6:	7ae2                	ld	s5,56(sp)
    800036a8:	7b42                	ld	s6,48(sp)
    800036aa:	7ba2                	ld	s7,40(sp)
    800036ac:	7c02                	ld	s8,32(sp)
    800036ae:	6ce2                	ld	s9,24(sp)
    800036b0:	6d42                	ld	s10,16(sp)
    800036b2:	6da2                	ld	s11,8(sp)
    800036b4:	6165                	addi	sp,sp,112
    800036b6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800036b8:	89d6                	mv	s3,s5
    800036ba:	bff1                	j	80003696 <readi+0xba>
    return 0;
    800036bc:	4501                	li	a0,0
}
    800036be:	8082                	ret

00000000800036c0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800036c0:	457c                	lw	a5,76(a0)
    800036c2:	0ed7ea63          	bltu	a5,a3,800037b6 <writei+0xf6>
{
    800036c6:	7159                	addi	sp,sp,-112
    800036c8:	f486                	sd	ra,104(sp)
    800036ca:	f0a2                	sd	s0,96(sp)
    800036cc:	eca6                	sd	s1,88(sp)
    800036ce:	e8ca                	sd	s2,80(sp)
    800036d0:	e4ce                	sd	s3,72(sp)
    800036d2:	e0d2                	sd	s4,64(sp)
    800036d4:	fc56                	sd	s5,56(sp)
    800036d6:	f85a                	sd	s6,48(sp)
    800036d8:	f45e                	sd	s7,40(sp)
    800036da:	f062                	sd	s8,32(sp)
    800036dc:	ec66                	sd	s9,24(sp)
    800036de:	e86a                	sd	s10,16(sp)
    800036e0:	e46e                	sd	s11,8(sp)
    800036e2:	1880                	addi	s0,sp,112
    800036e4:	8aaa                	mv	s5,a0
    800036e6:	8bae                	mv	s7,a1
    800036e8:	8a32                	mv	s4,a2
    800036ea:	8936                	mv	s2,a3
    800036ec:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800036ee:	00e687bb          	addw	a5,a3,a4
    800036f2:	0cd7e463          	bltu	a5,a3,800037ba <writei+0xfa>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800036f6:	00043737          	lui	a4,0x43
    800036fa:	0cf76263          	bltu	a4,a5,800037be <writei+0xfe>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800036fe:	0a0b0a63          	beqz	s6,800037b2 <writei+0xf2>
    80003702:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003704:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003708:	5c7d                	li	s8,-1
    8000370a:	a825                	j	80003742 <writei+0x82>
    8000370c:	020d1d93          	slli	s11,s10,0x20
    80003710:	020ddd93          	srli	s11,s11,0x20
    80003714:	05848793          	addi	a5,s1,88
    80003718:	86ee                	mv	a3,s11
    8000371a:	8652                	mv	a2,s4
    8000371c:	85de                	mv	a1,s7
    8000371e:	953e                	add	a0,a0,a5
    80003720:	b97fe0ef          	jal	ra,800022b6 <either_copyin>
    80003724:	05850a63          	beq	a0,s8,80003778 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003728:	8526                	mv	a0,s1
    8000372a:	670000ef          	jal	ra,80003d9a <log_write>
    brelse(bp);
    8000372e:	8526                	mv	a0,s1
    80003730:	e46ff0ef          	jal	ra,80002d76 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003734:	013d09bb          	addw	s3,s10,s3
    80003738:	012d093b          	addw	s2,s10,s2
    8000373c:	9a6e                	add	s4,s4,s11
    8000373e:	0569f063          	bgeu	s3,s6,8000377e <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003742:	00a9559b          	srliw	a1,s2,0xa
    80003746:	8556                	mv	a0,s5
    80003748:	8a1ff0ef          	jal	ra,80002fe8 <bmap>
    8000374c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003750:	c59d                	beqz	a1,8000377e <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003752:	000aa503          	lw	a0,0(s5)
    80003756:	d18ff0ef          	jal	ra,80002c6e <bread>
    8000375a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000375c:	3ff97513          	andi	a0,s2,1023
    80003760:	40ac87bb          	subw	a5,s9,a0
    80003764:	413b073b          	subw	a4,s6,s3
    80003768:	8d3e                	mv	s10,a5
    8000376a:	2781                	sext.w	a5,a5
    8000376c:	0007069b          	sext.w	a3,a4
    80003770:	f8f6fee3          	bgeu	a3,a5,8000370c <writei+0x4c>
    80003774:	8d3a                	mv	s10,a4
    80003776:	bf59                	j	8000370c <writei+0x4c>
      brelse(bp);
    80003778:	8526                	mv	a0,s1
    8000377a:	dfcff0ef          	jal	ra,80002d76 <brelse>
  }

  if(off > ip->size)
    8000377e:	04caa783          	lw	a5,76(s5)
    80003782:	0127f463          	bgeu	a5,s2,8000378a <writei+0xca>
    ip->size = off;
    80003786:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000378a:	8556                	mv	a0,s5
    8000378c:	b4fff0ef          	jal	ra,800032da <iupdate>

  return tot;
    80003790:	0009851b          	sext.w	a0,s3
}
    80003794:	70a6                	ld	ra,104(sp)
    80003796:	7406                	ld	s0,96(sp)
    80003798:	64e6                	ld	s1,88(sp)
    8000379a:	6946                	ld	s2,80(sp)
    8000379c:	69a6                	ld	s3,72(sp)
    8000379e:	6a06                	ld	s4,64(sp)
    800037a0:	7ae2                	ld	s5,56(sp)
    800037a2:	7b42                	ld	s6,48(sp)
    800037a4:	7ba2                	ld	s7,40(sp)
    800037a6:	7c02                	ld	s8,32(sp)
    800037a8:	6ce2                	ld	s9,24(sp)
    800037aa:	6d42                	ld	s10,16(sp)
    800037ac:	6da2                	ld	s11,8(sp)
    800037ae:	6165                	addi	sp,sp,112
    800037b0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800037b2:	89da                	mv	s3,s6
    800037b4:	bfd9                	j	8000378a <writei+0xca>
    return -1;
    800037b6:	557d                	li	a0,-1
}
    800037b8:	8082                	ret
    return -1;
    800037ba:	557d                	li	a0,-1
    800037bc:	bfe1                	j	80003794 <writei+0xd4>
    return -1;
    800037be:	557d                	li	a0,-1
    800037c0:	bfd1                	j	80003794 <writei+0xd4>

00000000800037c2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800037c2:	1141                	addi	sp,sp,-16
    800037c4:	e406                	sd	ra,8(sp)
    800037c6:	e022                	sd	s0,0(sp)
    800037c8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800037ca:	4639                	li	a2,14
    800037cc:	d7afd0ef          	jal	ra,80000d46 <strncmp>
}
    800037d0:	60a2                	ld	ra,8(sp)
    800037d2:	6402                	ld	s0,0(sp)
    800037d4:	0141                	addi	sp,sp,16
    800037d6:	8082                	ret

00000000800037d8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800037d8:	7139                	addi	sp,sp,-64
    800037da:	fc06                	sd	ra,56(sp)
    800037dc:	f822                	sd	s0,48(sp)
    800037de:	f426                	sd	s1,40(sp)
    800037e0:	f04a                	sd	s2,32(sp)
    800037e2:	ec4e                	sd	s3,24(sp)
    800037e4:	e852                	sd	s4,16(sp)
    800037e6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800037e8:	04451703          	lh	a4,68(a0)
    800037ec:	4785                	li	a5,1
    800037ee:	00f71a63          	bne	a4,a5,80003802 <dirlookup+0x2a>
    800037f2:	892a                	mv	s2,a0
    800037f4:	89ae                	mv	s3,a1
    800037f6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800037f8:	457c                	lw	a5,76(a0)
    800037fa:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800037fc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800037fe:	e39d                	bnez	a5,80003824 <dirlookup+0x4c>
    80003800:	a095                	j	80003864 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003802:	00004517          	auipc	a0,0x4
    80003806:	f8650513          	addi	a0,a0,-122 # 80007788 <syscalls+0x1f0>
    8000380a:	f2dfc0ef          	jal	ra,80000736 <panic>
      panic("dirlookup read");
    8000380e:	00004517          	auipc	a0,0x4
    80003812:	f9250513          	addi	a0,a0,-110 # 800077a0 <syscalls+0x208>
    80003816:	f21fc0ef          	jal	ra,80000736 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000381a:	24c1                	addiw	s1,s1,16
    8000381c:	04c92783          	lw	a5,76(s2)
    80003820:	04f4f163          	bgeu	s1,a5,80003862 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003824:	4741                	li	a4,16
    80003826:	86a6                	mv	a3,s1
    80003828:	fc040613          	addi	a2,s0,-64
    8000382c:	4581                	li	a1,0
    8000382e:	854a                	mv	a0,s2
    80003830:	dadff0ef          	jal	ra,800035dc <readi>
    80003834:	47c1                	li	a5,16
    80003836:	fcf51ce3          	bne	a0,a5,8000380e <dirlookup+0x36>
    if(de.inum == 0)
    8000383a:	fc045783          	lhu	a5,-64(s0)
    8000383e:	dff1                	beqz	a5,8000381a <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003840:	fc240593          	addi	a1,s0,-62
    80003844:	854e                	mv	a0,s3
    80003846:	f7dff0ef          	jal	ra,800037c2 <namecmp>
    8000384a:	f961                	bnez	a0,8000381a <dirlookup+0x42>
      if(poff)
    8000384c:	000a0463          	beqz	s4,80003854 <dirlookup+0x7c>
        *poff = off;
    80003850:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003854:	fc045583          	lhu	a1,-64(s0)
    80003858:	00092503          	lw	a0,0(s2)
    8000385c:	859ff0ef          	jal	ra,800030b4 <iget>
    80003860:	a011                	j	80003864 <dirlookup+0x8c>
  return 0;
    80003862:	4501                	li	a0,0
}
    80003864:	70e2                	ld	ra,56(sp)
    80003866:	7442                	ld	s0,48(sp)
    80003868:	74a2                	ld	s1,40(sp)
    8000386a:	7902                	ld	s2,32(sp)
    8000386c:	69e2                	ld	s3,24(sp)
    8000386e:	6a42                	ld	s4,16(sp)
    80003870:	6121                	addi	sp,sp,64
    80003872:	8082                	ret

0000000080003874 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003874:	711d                	addi	sp,sp,-96
    80003876:	ec86                	sd	ra,88(sp)
    80003878:	e8a2                	sd	s0,80(sp)
    8000387a:	e4a6                	sd	s1,72(sp)
    8000387c:	e0ca                	sd	s2,64(sp)
    8000387e:	fc4e                	sd	s3,56(sp)
    80003880:	f852                	sd	s4,48(sp)
    80003882:	f456                	sd	s5,40(sp)
    80003884:	f05a                	sd	s6,32(sp)
    80003886:	ec5e                	sd	s7,24(sp)
    80003888:	e862                	sd	s8,16(sp)
    8000388a:	e466                	sd	s9,8(sp)
    8000388c:	1080                	addi	s0,sp,96
    8000388e:	84aa                	mv	s1,a0
    80003890:	8aae                	mv	s5,a1
    80003892:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003894:	00054703          	lbu	a4,0(a0)
    80003898:	02f00793          	li	a5,47
    8000389c:	00f70f63          	beq	a4,a5,800038ba <namex+0x46>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800038a0:	8a4fe0ef          	jal	ra,80001944 <myproc>
    800038a4:	15053503          	ld	a0,336(a0)
    800038a8:	aafff0ef          	jal	ra,80003356 <idup>
    800038ac:	89aa                	mv	s3,a0
  while(*path == '/')
    800038ae:	02f00913          	li	s2,47
  len = path - s;
    800038b2:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    800038b4:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800038b6:	4b85                	li	s7,1
    800038b8:	a861                	j	80003950 <namex+0xdc>
    ip = iget(ROOTDEV, ROOTINO);
    800038ba:	4585                	li	a1,1
    800038bc:	4505                	li	a0,1
    800038be:	ff6ff0ef          	jal	ra,800030b4 <iget>
    800038c2:	89aa                	mv	s3,a0
    800038c4:	b7ed                	j	800038ae <namex+0x3a>
      iunlockput(ip);
    800038c6:	854e                	mv	a0,s3
    800038c8:	ccbff0ef          	jal	ra,80003592 <iunlockput>
      return 0;
    800038cc:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800038ce:	854e                	mv	a0,s3
    800038d0:	60e6                	ld	ra,88(sp)
    800038d2:	6446                	ld	s0,80(sp)
    800038d4:	64a6                	ld	s1,72(sp)
    800038d6:	6906                	ld	s2,64(sp)
    800038d8:	79e2                	ld	s3,56(sp)
    800038da:	7a42                	ld	s4,48(sp)
    800038dc:	7aa2                	ld	s5,40(sp)
    800038de:	7b02                	ld	s6,32(sp)
    800038e0:	6be2                	ld	s7,24(sp)
    800038e2:	6c42                	ld	s8,16(sp)
    800038e4:	6ca2                	ld	s9,8(sp)
    800038e6:	6125                	addi	sp,sp,96
    800038e8:	8082                	ret
      iunlock(ip);
    800038ea:	854e                	mv	a0,s3
    800038ec:	b4bff0ef          	jal	ra,80003436 <iunlock>
      return ip;
    800038f0:	bff9                	j	800038ce <namex+0x5a>
      iunlockput(ip);
    800038f2:	854e                	mv	a0,s3
    800038f4:	c9fff0ef          	jal	ra,80003592 <iunlockput>
      return 0;
    800038f8:	89e6                	mv	s3,s9
    800038fa:	bfd1                	j	800038ce <namex+0x5a>
  len = path - s;
    800038fc:	40b48633          	sub	a2,s1,a1
    80003900:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003904:	079c5c63          	bge	s8,s9,8000397c <namex+0x108>
    memmove(name, s, DIRSIZ);
    80003908:	4639                	li	a2,14
    8000390a:	8552                	mv	a0,s4
    8000390c:	bcafd0ef          	jal	ra,80000cd6 <memmove>
  while(*path == '/')
    80003910:	0004c783          	lbu	a5,0(s1)
    80003914:	01279763          	bne	a5,s2,80003922 <namex+0xae>
    path++;
    80003918:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000391a:	0004c783          	lbu	a5,0(s1)
    8000391e:	ff278de3          	beq	a5,s2,80003918 <namex+0xa4>
    ilock(ip);
    80003922:	854e                	mv	a0,s3
    80003924:	a69ff0ef          	jal	ra,8000338c <ilock>
    if(ip->type != T_DIR){
    80003928:	04499783          	lh	a5,68(s3)
    8000392c:	f9779de3          	bne	a5,s7,800038c6 <namex+0x52>
    if(nameiparent && *path == '\0'){
    80003930:	000a8563          	beqz	s5,8000393a <namex+0xc6>
    80003934:	0004c783          	lbu	a5,0(s1)
    80003938:	dbcd                	beqz	a5,800038ea <namex+0x76>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000393a:	865a                	mv	a2,s6
    8000393c:	85d2                	mv	a1,s4
    8000393e:	854e                	mv	a0,s3
    80003940:	e99ff0ef          	jal	ra,800037d8 <dirlookup>
    80003944:	8caa                	mv	s9,a0
    80003946:	d555                	beqz	a0,800038f2 <namex+0x7e>
    iunlockput(ip);
    80003948:	854e                	mv	a0,s3
    8000394a:	c49ff0ef          	jal	ra,80003592 <iunlockput>
    ip = next;
    8000394e:	89e6                	mv	s3,s9
  while(*path == '/')
    80003950:	0004c783          	lbu	a5,0(s1)
    80003954:	05279363          	bne	a5,s2,8000399a <namex+0x126>
    path++;
    80003958:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000395a:	0004c783          	lbu	a5,0(s1)
    8000395e:	ff278de3          	beq	a5,s2,80003958 <namex+0xe4>
  if(*path == 0)
    80003962:	c78d                	beqz	a5,8000398c <namex+0x118>
    path++;
    80003964:	85a6                	mv	a1,s1
  len = path - s;
    80003966:	8cda                	mv	s9,s6
    80003968:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    8000396a:	01278963          	beq	a5,s2,8000397c <namex+0x108>
    8000396e:	d7d9                	beqz	a5,800038fc <namex+0x88>
    path++;
    80003970:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003972:	0004c783          	lbu	a5,0(s1)
    80003976:	ff279ce3          	bne	a5,s2,8000396e <namex+0xfa>
    8000397a:	b749                	j	800038fc <namex+0x88>
    memmove(name, s, len);
    8000397c:	2601                	sext.w	a2,a2
    8000397e:	8552                	mv	a0,s4
    80003980:	b56fd0ef          	jal	ra,80000cd6 <memmove>
    name[len] = 0;
    80003984:	9cd2                	add	s9,s9,s4
    80003986:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000398a:	b759                	j	80003910 <namex+0x9c>
  if(nameiparent){
    8000398c:	f40a81e3          	beqz	s5,800038ce <namex+0x5a>
    iput(ip);
    80003990:	854e                	mv	a0,s3
    80003992:	b79ff0ef          	jal	ra,8000350a <iput>
    return 0;
    80003996:	4981                	li	s3,0
    80003998:	bf1d                	j	800038ce <namex+0x5a>
  if(*path == 0)
    8000399a:	dbed                	beqz	a5,8000398c <namex+0x118>
  while(*path != '/' && *path != 0)
    8000399c:	0004c783          	lbu	a5,0(s1)
    800039a0:	85a6                	mv	a1,s1
    800039a2:	b7f1                	j	8000396e <namex+0xfa>

00000000800039a4 <dirlink>:
{
    800039a4:	7139                	addi	sp,sp,-64
    800039a6:	fc06                	sd	ra,56(sp)
    800039a8:	f822                	sd	s0,48(sp)
    800039aa:	f426                	sd	s1,40(sp)
    800039ac:	f04a                	sd	s2,32(sp)
    800039ae:	ec4e                	sd	s3,24(sp)
    800039b0:	e852                	sd	s4,16(sp)
    800039b2:	0080                	addi	s0,sp,64
    800039b4:	892a                	mv	s2,a0
    800039b6:	8a2e                	mv	s4,a1
    800039b8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800039ba:	4601                	li	a2,0
    800039bc:	e1dff0ef          	jal	ra,800037d8 <dirlookup>
    800039c0:	e52d                	bnez	a0,80003a2a <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800039c2:	04c92483          	lw	s1,76(s2)
    800039c6:	c48d                	beqz	s1,800039f0 <dirlink+0x4c>
    800039c8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800039ca:	4741                	li	a4,16
    800039cc:	86a6                	mv	a3,s1
    800039ce:	fc040613          	addi	a2,s0,-64
    800039d2:	4581                	li	a1,0
    800039d4:	854a                	mv	a0,s2
    800039d6:	c07ff0ef          	jal	ra,800035dc <readi>
    800039da:	47c1                	li	a5,16
    800039dc:	04f51b63          	bne	a0,a5,80003a32 <dirlink+0x8e>
    if(de.inum == 0)
    800039e0:	fc045783          	lhu	a5,-64(s0)
    800039e4:	c791                	beqz	a5,800039f0 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800039e6:	24c1                	addiw	s1,s1,16
    800039e8:	04c92783          	lw	a5,76(s2)
    800039ec:	fcf4efe3          	bltu	s1,a5,800039ca <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    800039f0:	4639                	li	a2,14
    800039f2:	85d2                	mv	a1,s4
    800039f4:	fc240513          	addi	a0,s0,-62
    800039f8:	b8afd0ef          	jal	ra,80000d82 <strncpy>
  de.inum = inum;
    800039fc:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a00:	4741                	li	a4,16
    80003a02:	86a6                	mv	a3,s1
    80003a04:	fc040613          	addi	a2,s0,-64
    80003a08:	4581                	li	a1,0
    80003a0a:	854a                	mv	a0,s2
    80003a0c:	cb5ff0ef          	jal	ra,800036c0 <writei>
    80003a10:	1541                	addi	a0,a0,-16
    80003a12:	00a03533          	snez	a0,a0
    80003a16:	40a00533          	neg	a0,a0
}
    80003a1a:	70e2                	ld	ra,56(sp)
    80003a1c:	7442                	ld	s0,48(sp)
    80003a1e:	74a2                	ld	s1,40(sp)
    80003a20:	7902                	ld	s2,32(sp)
    80003a22:	69e2                	ld	s3,24(sp)
    80003a24:	6a42                	ld	s4,16(sp)
    80003a26:	6121                	addi	sp,sp,64
    80003a28:	8082                	ret
    iput(ip);
    80003a2a:	ae1ff0ef          	jal	ra,8000350a <iput>
    return -1;
    80003a2e:	557d                	li	a0,-1
    80003a30:	b7ed                	j	80003a1a <dirlink+0x76>
      panic("dirlink read");
    80003a32:	00004517          	auipc	a0,0x4
    80003a36:	d7e50513          	addi	a0,a0,-642 # 800077b0 <syscalls+0x218>
    80003a3a:	cfdfc0ef          	jal	ra,80000736 <panic>

0000000080003a3e <namei>:

struct inode*
namei(char *path)
{
    80003a3e:	1101                	addi	sp,sp,-32
    80003a40:	ec06                	sd	ra,24(sp)
    80003a42:	e822                	sd	s0,16(sp)
    80003a44:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003a46:	fe040613          	addi	a2,s0,-32
    80003a4a:	4581                	li	a1,0
    80003a4c:	e29ff0ef          	jal	ra,80003874 <namex>
}
    80003a50:	60e2                	ld	ra,24(sp)
    80003a52:	6442                	ld	s0,16(sp)
    80003a54:	6105                	addi	sp,sp,32
    80003a56:	8082                	ret

0000000080003a58 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003a58:	1141                	addi	sp,sp,-16
    80003a5a:	e406                	sd	ra,8(sp)
    80003a5c:	e022                	sd	s0,0(sp)
    80003a5e:	0800                	addi	s0,sp,16
    80003a60:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003a62:	4585                	li	a1,1
    80003a64:	e11ff0ef          	jal	ra,80003874 <namex>
}
    80003a68:	60a2                	ld	ra,8(sp)
    80003a6a:	6402                	ld	s0,0(sp)
    80003a6c:	0141                	addi	sp,sp,16
    80003a6e:	8082                	ret

0000000080003a70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003a70:	1101                	addi	sp,sp,-32
    80003a72:	ec06                	sd	ra,24(sp)
    80003a74:	e822                	sd	s0,16(sp)
    80003a76:	e426                	sd	s1,8(sp)
    80003a78:	e04a                	sd	s2,0(sp)
    80003a7a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003a7c:	0001c917          	auipc	s2,0x1c
    80003a80:	1f490913          	addi	s2,s2,500 # 8001fc70 <log>
    80003a84:	01892583          	lw	a1,24(s2)
    80003a88:	02892503          	lw	a0,40(s2)
    80003a8c:	9e2ff0ef          	jal	ra,80002c6e <bread>
    80003a90:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003a92:	02c92683          	lw	a3,44(s2)
    80003a96:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003a98:	02d05763          	blez	a3,80003ac6 <write_head+0x56>
    80003a9c:	0001c797          	auipc	a5,0x1c
    80003aa0:	20478793          	addi	a5,a5,516 # 8001fca0 <log+0x30>
    80003aa4:	05c50713          	addi	a4,a0,92
    80003aa8:	36fd                	addiw	a3,a3,-1
    80003aaa:	1682                	slli	a3,a3,0x20
    80003aac:	9281                	srli	a3,a3,0x20
    80003aae:	068a                	slli	a3,a3,0x2
    80003ab0:	0001c617          	auipc	a2,0x1c
    80003ab4:	1f460613          	addi	a2,a2,500 # 8001fca4 <log+0x34>
    80003ab8:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003aba:	4390                	lw	a2,0(a5)
    80003abc:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003abe:	0791                	addi	a5,a5,4
    80003ac0:	0711                	addi	a4,a4,4
    80003ac2:	fed79ce3          	bne	a5,a3,80003aba <write_head+0x4a>
  }
  bwrite(buf);
    80003ac6:	8526                	mv	a0,s1
    80003ac8:	a7cff0ef          	jal	ra,80002d44 <bwrite>
  brelse(buf);
    80003acc:	8526                	mv	a0,s1
    80003ace:	aa8ff0ef          	jal	ra,80002d76 <brelse>
}
    80003ad2:	60e2                	ld	ra,24(sp)
    80003ad4:	6442                	ld	s0,16(sp)
    80003ad6:	64a2                	ld	s1,8(sp)
    80003ad8:	6902                	ld	s2,0(sp)
    80003ada:	6105                	addi	sp,sp,32
    80003adc:	8082                	ret

0000000080003ade <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ade:	0001c797          	auipc	a5,0x1c
    80003ae2:	1be7a783          	lw	a5,446(a5) # 8001fc9c <log+0x2c>
    80003ae6:	08f05f63          	blez	a5,80003b84 <install_trans+0xa6>
{
    80003aea:	7139                	addi	sp,sp,-64
    80003aec:	fc06                	sd	ra,56(sp)
    80003aee:	f822                	sd	s0,48(sp)
    80003af0:	f426                	sd	s1,40(sp)
    80003af2:	f04a                	sd	s2,32(sp)
    80003af4:	ec4e                	sd	s3,24(sp)
    80003af6:	e852                	sd	s4,16(sp)
    80003af8:	e456                	sd	s5,8(sp)
    80003afa:	e05a                	sd	s6,0(sp)
    80003afc:	0080                	addi	s0,sp,64
    80003afe:	8b2a                	mv	s6,a0
    80003b00:	0001ca97          	auipc	s5,0x1c
    80003b04:	1a0a8a93          	addi	s5,s5,416 # 8001fca0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b08:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003b0a:	0001c997          	auipc	s3,0x1c
    80003b0e:	16698993          	addi	s3,s3,358 # 8001fc70 <log>
    80003b12:	a829                	j	80003b2c <install_trans+0x4e>
    brelse(lbuf);
    80003b14:	854a                	mv	a0,s2
    80003b16:	a60ff0ef          	jal	ra,80002d76 <brelse>
    brelse(dbuf);
    80003b1a:	8526                	mv	a0,s1
    80003b1c:	a5aff0ef          	jal	ra,80002d76 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b20:	2a05                	addiw	s4,s4,1
    80003b22:	0a91                	addi	s5,s5,4
    80003b24:	02c9a783          	lw	a5,44(s3)
    80003b28:	04fa5463          	bge	s4,a5,80003b70 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003b2c:	0189a583          	lw	a1,24(s3)
    80003b30:	014585bb          	addw	a1,a1,s4
    80003b34:	2585                	addiw	a1,a1,1
    80003b36:	0289a503          	lw	a0,40(s3)
    80003b3a:	934ff0ef          	jal	ra,80002c6e <bread>
    80003b3e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003b40:	000aa583          	lw	a1,0(s5)
    80003b44:	0289a503          	lw	a0,40(s3)
    80003b48:	926ff0ef          	jal	ra,80002c6e <bread>
    80003b4c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003b4e:	40000613          	li	a2,1024
    80003b52:	05890593          	addi	a1,s2,88
    80003b56:	05850513          	addi	a0,a0,88
    80003b5a:	97cfd0ef          	jal	ra,80000cd6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003b5e:	8526                	mv	a0,s1
    80003b60:	9e4ff0ef          	jal	ra,80002d44 <bwrite>
    if(recovering == 0)
    80003b64:	fa0b18e3          	bnez	s6,80003b14 <install_trans+0x36>
      bunpin(dbuf);
    80003b68:	8526                	mv	a0,s1
    80003b6a:	acaff0ef          	jal	ra,80002e34 <bunpin>
    80003b6e:	b75d                	j	80003b14 <install_trans+0x36>
}
    80003b70:	70e2                	ld	ra,56(sp)
    80003b72:	7442                	ld	s0,48(sp)
    80003b74:	74a2                	ld	s1,40(sp)
    80003b76:	7902                	ld	s2,32(sp)
    80003b78:	69e2                	ld	s3,24(sp)
    80003b7a:	6a42                	ld	s4,16(sp)
    80003b7c:	6aa2                	ld	s5,8(sp)
    80003b7e:	6b02                	ld	s6,0(sp)
    80003b80:	6121                	addi	sp,sp,64
    80003b82:	8082                	ret
    80003b84:	8082                	ret

0000000080003b86 <initlog>:
{
    80003b86:	7179                	addi	sp,sp,-48
    80003b88:	f406                	sd	ra,40(sp)
    80003b8a:	f022                	sd	s0,32(sp)
    80003b8c:	ec26                	sd	s1,24(sp)
    80003b8e:	e84a                	sd	s2,16(sp)
    80003b90:	e44e                	sd	s3,8(sp)
    80003b92:	1800                	addi	s0,sp,48
    80003b94:	892a                	mv	s2,a0
    80003b96:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003b98:	0001c497          	auipc	s1,0x1c
    80003b9c:	0d848493          	addi	s1,s1,216 # 8001fc70 <log>
    80003ba0:	00004597          	auipc	a1,0x4
    80003ba4:	c2058593          	addi	a1,a1,-992 # 800077c0 <syscalls+0x228>
    80003ba8:	8526                	mv	a0,s1
    80003baa:	f7dfc0ef          	jal	ra,80000b26 <initlock>
  log.start = sb->logstart;
    80003bae:	0149a583          	lw	a1,20(s3)
    80003bb2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003bb4:	0109a783          	lw	a5,16(s3)
    80003bb8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003bba:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003bbe:	854a                	mv	a0,s2
    80003bc0:	8aeff0ef          	jal	ra,80002c6e <bread>
  log.lh.n = lh->n;
    80003bc4:	4d34                	lw	a3,88(a0)
    80003bc6:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003bc8:	02d05563          	blez	a3,80003bf2 <initlog+0x6c>
    80003bcc:	05c50793          	addi	a5,a0,92
    80003bd0:	0001c717          	auipc	a4,0x1c
    80003bd4:	0d070713          	addi	a4,a4,208 # 8001fca0 <log+0x30>
    80003bd8:	36fd                	addiw	a3,a3,-1
    80003bda:	1682                	slli	a3,a3,0x20
    80003bdc:	9281                	srli	a3,a3,0x20
    80003bde:	068a                	slli	a3,a3,0x2
    80003be0:	06050613          	addi	a2,a0,96
    80003be4:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003be6:	4390                	lw	a2,0(a5)
    80003be8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003bea:	0791                	addi	a5,a5,4
    80003bec:	0711                	addi	a4,a4,4
    80003bee:	fed79ce3          	bne	a5,a3,80003be6 <initlog+0x60>
  brelse(buf);
    80003bf2:	984ff0ef          	jal	ra,80002d76 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003bf6:	4505                	li	a0,1
    80003bf8:	ee7ff0ef          	jal	ra,80003ade <install_trans>
  log.lh.n = 0;
    80003bfc:	0001c797          	auipc	a5,0x1c
    80003c00:	0a07a023          	sw	zero,160(a5) # 8001fc9c <log+0x2c>
  write_head(); // clear the log
    80003c04:	e6dff0ef          	jal	ra,80003a70 <write_head>
}
    80003c08:	70a2                	ld	ra,40(sp)
    80003c0a:	7402                	ld	s0,32(sp)
    80003c0c:	64e2                	ld	s1,24(sp)
    80003c0e:	6942                	ld	s2,16(sp)
    80003c10:	69a2                	ld	s3,8(sp)
    80003c12:	6145                	addi	sp,sp,48
    80003c14:	8082                	ret

0000000080003c16 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003c16:	1101                	addi	sp,sp,-32
    80003c18:	ec06                	sd	ra,24(sp)
    80003c1a:	e822                	sd	s0,16(sp)
    80003c1c:	e426                	sd	s1,8(sp)
    80003c1e:	e04a                	sd	s2,0(sp)
    80003c20:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003c22:	0001c517          	auipc	a0,0x1c
    80003c26:	04e50513          	addi	a0,a0,78 # 8001fc70 <log>
    80003c2a:	f7dfc0ef          	jal	ra,80000ba6 <acquire>
  while(1){
    if(log.committing){
    80003c2e:	0001c497          	auipc	s1,0x1c
    80003c32:	04248493          	addi	s1,s1,66 # 8001fc70 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003c36:	4979                	li	s2,30
    80003c38:	a029                	j	80003c42 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003c3a:	85a6                	mv	a1,s1
    80003c3c:	8526                	mv	a0,s1
    80003c3e:	ad2fe0ef          	jal	ra,80001f10 <sleep>
    if(log.committing){
    80003c42:	50dc                	lw	a5,36(s1)
    80003c44:	fbfd                	bnez	a5,80003c3a <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003c46:	509c                	lw	a5,32(s1)
    80003c48:	0017871b          	addiw	a4,a5,1
    80003c4c:	0007069b          	sext.w	a3,a4
    80003c50:	0027179b          	slliw	a5,a4,0x2
    80003c54:	9fb9                	addw	a5,a5,a4
    80003c56:	0017979b          	slliw	a5,a5,0x1
    80003c5a:	54d8                	lw	a4,44(s1)
    80003c5c:	9fb9                	addw	a5,a5,a4
    80003c5e:	00f95763          	bge	s2,a5,80003c6c <begin_op+0x56>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003c62:	85a6                	mv	a1,s1
    80003c64:	8526                	mv	a0,s1
    80003c66:	aaafe0ef          	jal	ra,80001f10 <sleep>
    80003c6a:	bfe1                	j	80003c42 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003c6c:	0001c517          	auipc	a0,0x1c
    80003c70:	00450513          	addi	a0,a0,4 # 8001fc70 <log>
    80003c74:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003c76:	fc9fc0ef          	jal	ra,80000c3e <release>
      break;
    }
  }
}
    80003c7a:	60e2                	ld	ra,24(sp)
    80003c7c:	6442                	ld	s0,16(sp)
    80003c7e:	64a2                	ld	s1,8(sp)
    80003c80:	6902                	ld	s2,0(sp)
    80003c82:	6105                	addi	sp,sp,32
    80003c84:	8082                	ret

0000000080003c86 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003c86:	7139                	addi	sp,sp,-64
    80003c88:	fc06                	sd	ra,56(sp)
    80003c8a:	f822                	sd	s0,48(sp)
    80003c8c:	f426                	sd	s1,40(sp)
    80003c8e:	f04a                	sd	s2,32(sp)
    80003c90:	ec4e                	sd	s3,24(sp)
    80003c92:	e852                	sd	s4,16(sp)
    80003c94:	e456                	sd	s5,8(sp)
    80003c96:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003c98:	0001c497          	auipc	s1,0x1c
    80003c9c:	fd848493          	addi	s1,s1,-40 # 8001fc70 <log>
    80003ca0:	8526                	mv	a0,s1
    80003ca2:	f05fc0ef          	jal	ra,80000ba6 <acquire>
  log.outstanding -= 1;
    80003ca6:	509c                	lw	a5,32(s1)
    80003ca8:	37fd                	addiw	a5,a5,-1
    80003caa:	0007891b          	sext.w	s2,a5
    80003cae:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003cb0:	50dc                	lw	a5,36(s1)
    80003cb2:	ef9d                	bnez	a5,80003cf0 <end_op+0x6a>
    panic("log.committing");
  if(log.outstanding == 0){
    80003cb4:	04091463          	bnez	s2,80003cfc <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003cb8:	0001c497          	auipc	s1,0x1c
    80003cbc:	fb848493          	addi	s1,s1,-72 # 8001fc70 <log>
    80003cc0:	4785                	li	a5,1
    80003cc2:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003cc4:	8526                	mv	a0,s1
    80003cc6:	f79fc0ef          	jal	ra,80000c3e <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003cca:	54dc                	lw	a5,44(s1)
    80003ccc:	04f04b63          	bgtz	a5,80003d22 <end_op+0x9c>
    acquire(&log.lock);
    80003cd0:	0001c497          	auipc	s1,0x1c
    80003cd4:	fa048493          	addi	s1,s1,-96 # 8001fc70 <log>
    80003cd8:	8526                	mv	a0,s1
    80003cda:	ecdfc0ef          	jal	ra,80000ba6 <acquire>
    log.committing = 0;
    80003cde:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003ce2:	8526                	mv	a0,s1
    80003ce4:	a78fe0ef          	jal	ra,80001f5c <wakeup>
    release(&log.lock);
    80003ce8:	8526                	mv	a0,s1
    80003cea:	f55fc0ef          	jal	ra,80000c3e <release>
}
    80003cee:	a00d                	j	80003d10 <end_op+0x8a>
    panic("log.committing");
    80003cf0:	00004517          	auipc	a0,0x4
    80003cf4:	ad850513          	addi	a0,a0,-1320 # 800077c8 <syscalls+0x230>
    80003cf8:	a3ffc0ef          	jal	ra,80000736 <panic>
    wakeup(&log);
    80003cfc:	0001c497          	auipc	s1,0x1c
    80003d00:	f7448493          	addi	s1,s1,-140 # 8001fc70 <log>
    80003d04:	8526                	mv	a0,s1
    80003d06:	a56fe0ef          	jal	ra,80001f5c <wakeup>
  release(&log.lock);
    80003d0a:	8526                	mv	a0,s1
    80003d0c:	f33fc0ef          	jal	ra,80000c3e <release>
}
    80003d10:	70e2                	ld	ra,56(sp)
    80003d12:	7442                	ld	s0,48(sp)
    80003d14:	74a2                	ld	s1,40(sp)
    80003d16:	7902                	ld	s2,32(sp)
    80003d18:	69e2                	ld	s3,24(sp)
    80003d1a:	6a42                	ld	s4,16(sp)
    80003d1c:	6aa2                	ld	s5,8(sp)
    80003d1e:	6121                	addi	sp,sp,64
    80003d20:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d22:	0001ca97          	auipc	s5,0x1c
    80003d26:	f7ea8a93          	addi	s5,s5,-130 # 8001fca0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003d2a:	0001ca17          	auipc	s4,0x1c
    80003d2e:	f46a0a13          	addi	s4,s4,-186 # 8001fc70 <log>
    80003d32:	018a2583          	lw	a1,24(s4)
    80003d36:	012585bb          	addw	a1,a1,s2
    80003d3a:	2585                	addiw	a1,a1,1
    80003d3c:	028a2503          	lw	a0,40(s4)
    80003d40:	f2ffe0ef          	jal	ra,80002c6e <bread>
    80003d44:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003d46:	000aa583          	lw	a1,0(s5)
    80003d4a:	028a2503          	lw	a0,40(s4)
    80003d4e:	f21fe0ef          	jal	ra,80002c6e <bread>
    80003d52:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003d54:	40000613          	li	a2,1024
    80003d58:	05850593          	addi	a1,a0,88
    80003d5c:	05848513          	addi	a0,s1,88
    80003d60:	f77fc0ef          	jal	ra,80000cd6 <memmove>
    bwrite(to);  // write the log
    80003d64:	8526                	mv	a0,s1
    80003d66:	fdffe0ef          	jal	ra,80002d44 <bwrite>
    brelse(from);
    80003d6a:	854e                	mv	a0,s3
    80003d6c:	80aff0ef          	jal	ra,80002d76 <brelse>
    brelse(to);
    80003d70:	8526                	mv	a0,s1
    80003d72:	804ff0ef          	jal	ra,80002d76 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d76:	2905                	addiw	s2,s2,1
    80003d78:	0a91                	addi	s5,s5,4
    80003d7a:	02ca2783          	lw	a5,44(s4)
    80003d7e:	faf94ae3          	blt	s2,a5,80003d32 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003d82:	cefff0ef          	jal	ra,80003a70 <write_head>
    install_trans(0); // Now install writes to home locations
    80003d86:	4501                	li	a0,0
    80003d88:	d57ff0ef          	jal	ra,80003ade <install_trans>
    log.lh.n = 0;
    80003d8c:	0001c797          	auipc	a5,0x1c
    80003d90:	f007a823          	sw	zero,-240(a5) # 8001fc9c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003d94:	cddff0ef          	jal	ra,80003a70 <write_head>
    80003d98:	bf25                	j	80003cd0 <end_op+0x4a>

0000000080003d9a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003d9a:	1101                	addi	sp,sp,-32
    80003d9c:	ec06                	sd	ra,24(sp)
    80003d9e:	e822                	sd	s0,16(sp)
    80003da0:	e426                	sd	s1,8(sp)
    80003da2:	e04a                	sd	s2,0(sp)
    80003da4:	1000                	addi	s0,sp,32
    80003da6:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003da8:	0001c917          	auipc	s2,0x1c
    80003dac:	ec890913          	addi	s2,s2,-312 # 8001fc70 <log>
    80003db0:	854a                	mv	a0,s2
    80003db2:	df5fc0ef          	jal	ra,80000ba6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003db6:	02c92603          	lw	a2,44(s2)
    80003dba:	47f5                	li	a5,29
    80003dbc:	06c7c363          	blt	a5,a2,80003e22 <log_write+0x88>
    80003dc0:	0001c797          	auipc	a5,0x1c
    80003dc4:	ecc7a783          	lw	a5,-308(a5) # 8001fc8c <log+0x1c>
    80003dc8:	37fd                	addiw	a5,a5,-1
    80003dca:	04f65c63          	bge	a2,a5,80003e22 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003dce:	0001c797          	auipc	a5,0x1c
    80003dd2:	ec27a783          	lw	a5,-318(a5) # 8001fc90 <log+0x20>
    80003dd6:	04f05c63          	blez	a5,80003e2e <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003dda:	4781                	li	a5,0
    80003ddc:	04c05f63          	blez	a2,80003e3a <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003de0:	44cc                	lw	a1,12(s1)
    80003de2:	0001c717          	auipc	a4,0x1c
    80003de6:	ebe70713          	addi	a4,a4,-322 # 8001fca0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003dea:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003dec:	4314                	lw	a3,0(a4)
    80003dee:	04b68663          	beq	a3,a1,80003e3a <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003df2:	2785                	addiw	a5,a5,1
    80003df4:	0711                	addi	a4,a4,4
    80003df6:	fef61be3          	bne	a2,a5,80003dec <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003dfa:	0621                	addi	a2,a2,8
    80003dfc:	060a                	slli	a2,a2,0x2
    80003dfe:	0001c797          	auipc	a5,0x1c
    80003e02:	e7278793          	addi	a5,a5,-398 # 8001fc70 <log>
    80003e06:	963e                	add	a2,a2,a5
    80003e08:	44dc                	lw	a5,12(s1)
    80003e0a:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003e0c:	8526                	mv	a0,s1
    80003e0e:	ff3fe0ef          	jal	ra,80002e00 <bpin>
    log.lh.n++;
    80003e12:	0001c717          	auipc	a4,0x1c
    80003e16:	e5e70713          	addi	a4,a4,-418 # 8001fc70 <log>
    80003e1a:	575c                	lw	a5,44(a4)
    80003e1c:	2785                	addiw	a5,a5,1
    80003e1e:	d75c                	sw	a5,44(a4)
    80003e20:	a815                	j	80003e54 <log_write+0xba>
    panic("too big a transaction");
    80003e22:	00004517          	auipc	a0,0x4
    80003e26:	9b650513          	addi	a0,a0,-1610 # 800077d8 <syscalls+0x240>
    80003e2a:	90dfc0ef          	jal	ra,80000736 <panic>
    panic("log_write outside of trans");
    80003e2e:	00004517          	auipc	a0,0x4
    80003e32:	9c250513          	addi	a0,a0,-1598 # 800077f0 <syscalls+0x258>
    80003e36:	901fc0ef          	jal	ra,80000736 <panic>
  log.lh.block[i] = b->blockno;
    80003e3a:	00878713          	addi	a4,a5,8
    80003e3e:	00271693          	slli	a3,a4,0x2
    80003e42:	0001c717          	auipc	a4,0x1c
    80003e46:	e2e70713          	addi	a4,a4,-466 # 8001fc70 <log>
    80003e4a:	9736                	add	a4,a4,a3
    80003e4c:	44d4                	lw	a3,12(s1)
    80003e4e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003e50:	faf60ee3          	beq	a2,a5,80003e0c <log_write+0x72>
  }
  release(&log.lock);
    80003e54:	0001c517          	auipc	a0,0x1c
    80003e58:	e1c50513          	addi	a0,a0,-484 # 8001fc70 <log>
    80003e5c:	de3fc0ef          	jal	ra,80000c3e <release>
}
    80003e60:	60e2                	ld	ra,24(sp)
    80003e62:	6442                	ld	s0,16(sp)
    80003e64:	64a2                	ld	s1,8(sp)
    80003e66:	6902                	ld	s2,0(sp)
    80003e68:	6105                	addi	sp,sp,32
    80003e6a:	8082                	ret

0000000080003e6c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003e6c:	1101                	addi	sp,sp,-32
    80003e6e:	ec06                	sd	ra,24(sp)
    80003e70:	e822                	sd	s0,16(sp)
    80003e72:	e426                	sd	s1,8(sp)
    80003e74:	e04a                	sd	s2,0(sp)
    80003e76:	1000                	addi	s0,sp,32
    80003e78:	84aa                	mv	s1,a0
    80003e7a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003e7c:	00004597          	auipc	a1,0x4
    80003e80:	99458593          	addi	a1,a1,-1644 # 80007810 <syscalls+0x278>
    80003e84:	0521                	addi	a0,a0,8
    80003e86:	ca1fc0ef          	jal	ra,80000b26 <initlock>
  lk->name = name;
    80003e8a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003e8e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003e92:	0204a423          	sw	zero,40(s1)
}
    80003e96:	60e2                	ld	ra,24(sp)
    80003e98:	6442                	ld	s0,16(sp)
    80003e9a:	64a2                	ld	s1,8(sp)
    80003e9c:	6902                	ld	s2,0(sp)
    80003e9e:	6105                	addi	sp,sp,32
    80003ea0:	8082                	ret

0000000080003ea2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003ea2:	1101                	addi	sp,sp,-32
    80003ea4:	ec06                	sd	ra,24(sp)
    80003ea6:	e822                	sd	s0,16(sp)
    80003ea8:	e426                	sd	s1,8(sp)
    80003eaa:	e04a                	sd	s2,0(sp)
    80003eac:	1000                	addi	s0,sp,32
    80003eae:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003eb0:	00850913          	addi	s2,a0,8
    80003eb4:	854a                	mv	a0,s2
    80003eb6:	cf1fc0ef          	jal	ra,80000ba6 <acquire>
  while (lk->locked) {
    80003eba:	409c                	lw	a5,0(s1)
    80003ebc:	c799                	beqz	a5,80003eca <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003ebe:	85ca                	mv	a1,s2
    80003ec0:	8526                	mv	a0,s1
    80003ec2:	84efe0ef          	jal	ra,80001f10 <sleep>
  while (lk->locked) {
    80003ec6:	409c                	lw	a5,0(s1)
    80003ec8:	fbfd                	bnez	a5,80003ebe <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003eca:	4785                	li	a5,1
    80003ecc:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003ece:	a77fd0ef          	jal	ra,80001944 <myproc>
    80003ed2:	591c                	lw	a5,48(a0)
    80003ed4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003ed6:	854a                	mv	a0,s2
    80003ed8:	d67fc0ef          	jal	ra,80000c3e <release>
}
    80003edc:	60e2                	ld	ra,24(sp)
    80003ede:	6442                	ld	s0,16(sp)
    80003ee0:	64a2                	ld	s1,8(sp)
    80003ee2:	6902                	ld	s2,0(sp)
    80003ee4:	6105                	addi	sp,sp,32
    80003ee6:	8082                	ret

0000000080003ee8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003ee8:	1101                	addi	sp,sp,-32
    80003eea:	ec06                	sd	ra,24(sp)
    80003eec:	e822                	sd	s0,16(sp)
    80003eee:	e426                	sd	s1,8(sp)
    80003ef0:	e04a                	sd	s2,0(sp)
    80003ef2:	1000                	addi	s0,sp,32
    80003ef4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ef6:	00850913          	addi	s2,a0,8
    80003efa:	854a                	mv	a0,s2
    80003efc:	cabfc0ef          	jal	ra,80000ba6 <acquire>
  lk->locked = 0;
    80003f00:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003f04:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003f08:	8526                	mv	a0,s1
    80003f0a:	852fe0ef          	jal	ra,80001f5c <wakeup>
  release(&lk->lk);
    80003f0e:	854a                	mv	a0,s2
    80003f10:	d2ffc0ef          	jal	ra,80000c3e <release>
}
    80003f14:	60e2                	ld	ra,24(sp)
    80003f16:	6442                	ld	s0,16(sp)
    80003f18:	64a2                	ld	s1,8(sp)
    80003f1a:	6902                	ld	s2,0(sp)
    80003f1c:	6105                	addi	sp,sp,32
    80003f1e:	8082                	ret

0000000080003f20 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003f20:	7179                	addi	sp,sp,-48
    80003f22:	f406                	sd	ra,40(sp)
    80003f24:	f022                	sd	s0,32(sp)
    80003f26:	ec26                	sd	s1,24(sp)
    80003f28:	e84a                	sd	s2,16(sp)
    80003f2a:	e44e                	sd	s3,8(sp)
    80003f2c:	1800                	addi	s0,sp,48
    80003f2e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003f30:	00850913          	addi	s2,a0,8
    80003f34:	854a                	mv	a0,s2
    80003f36:	c71fc0ef          	jal	ra,80000ba6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003f3a:	409c                	lw	a5,0(s1)
    80003f3c:	ef89                	bnez	a5,80003f56 <holdingsleep+0x36>
    80003f3e:	4481                	li	s1,0
  release(&lk->lk);
    80003f40:	854a                	mv	a0,s2
    80003f42:	cfdfc0ef          	jal	ra,80000c3e <release>
  return r;
}
    80003f46:	8526                	mv	a0,s1
    80003f48:	70a2                	ld	ra,40(sp)
    80003f4a:	7402                	ld	s0,32(sp)
    80003f4c:	64e2                	ld	s1,24(sp)
    80003f4e:	6942                	ld	s2,16(sp)
    80003f50:	69a2                	ld	s3,8(sp)
    80003f52:	6145                	addi	sp,sp,48
    80003f54:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003f56:	0284a983          	lw	s3,40(s1)
    80003f5a:	9ebfd0ef          	jal	ra,80001944 <myproc>
    80003f5e:	5904                	lw	s1,48(a0)
    80003f60:	413484b3          	sub	s1,s1,s3
    80003f64:	0014b493          	seqz	s1,s1
    80003f68:	bfe1                	j	80003f40 <holdingsleep+0x20>

0000000080003f6a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003f6a:	1141                	addi	sp,sp,-16
    80003f6c:	e406                	sd	ra,8(sp)
    80003f6e:	e022                	sd	s0,0(sp)
    80003f70:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003f72:	00004597          	auipc	a1,0x4
    80003f76:	8ae58593          	addi	a1,a1,-1874 # 80007820 <syscalls+0x288>
    80003f7a:	0001c517          	auipc	a0,0x1c
    80003f7e:	e3e50513          	addi	a0,a0,-450 # 8001fdb8 <ftable>
    80003f82:	ba5fc0ef          	jal	ra,80000b26 <initlock>
}
    80003f86:	60a2                	ld	ra,8(sp)
    80003f88:	6402                	ld	s0,0(sp)
    80003f8a:	0141                	addi	sp,sp,16
    80003f8c:	8082                	ret

0000000080003f8e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003f8e:	1101                	addi	sp,sp,-32
    80003f90:	ec06                	sd	ra,24(sp)
    80003f92:	e822                	sd	s0,16(sp)
    80003f94:	e426                	sd	s1,8(sp)
    80003f96:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003f98:	0001c517          	auipc	a0,0x1c
    80003f9c:	e2050513          	addi	a0,a0,-480 # 8001fdb8 <ftable>
    80003fa0:	c07fc0ef          	jal	ra,80000ba6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003fa4:	0001c497          	auipc	s1,0x1c
    80003fa8:	e2c48493          	addi	s1,s1,-468 # 8001fdd0 <ftable+0x18>
    80003fac:	0001d717          	auipc	a4,0x1d
    80003fb0:	dc470713          	addi	a4,a4,-572 # 80020d70 <disk>
    if(f->ref == 0){
    80003fb4:	40dc                	lw	a5,4(s1)
    80003fb6:	cf89                	beqz	a5,80003fd0 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003fb8:	02848493          	addi	s1,s1,40
    80003fbc:	fee49ce3          	bne	s1,a4,80003fb4 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003fc0:	0001c517          	auipc	a0,0x1c
    80003fc4:	df850513          	addi	a0,a0,-520 # 8001fdb8 <ftable>
    80003fc8:	c77fc0ef          	jal	ra,80000c3e <release>
  return 0;
    80003fcc:	4481                	li	s1,0
    80003fce:	a809                	j	80003fe0 <filealloc+0x52>
      f->ref = 1;
    80003fd0:	4785                	li	a5,1
    80003fd2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003fd4:	0001c517          	auipc	a0,0x1c
    80003fd8:	de450513          	addi	a0,a0,-540 # 8001fdb8 <ftable>
    80003fdc:	c63fc0ef          	jal	ra,80000c3e <release>
}
    80003fe0:	8526                	mv	a0,s1
    80003fe2:	60e2                	ld	ra,24(sp)
    80003fe4:	6442                	ld	s0,16(sp)
    80003fe6:	64a2                	ld	s1,8(sp)
    80003fe8:	6105                	addi	sp,sp,32
    80003fea:	8082                	ret

0000000080003fec <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003fec:	1101                	addi	sp,sp,-32
    80003fee:	ec06                	sd	ra,24(sp)
    80003ff0:	e822                	sd	s0,16(sp)
    80003ff2:	e426                	sd	s1,8(sp)
    80003ff4:	1000                	addi	s0,sp,32
    80003ff6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ff8:	0001c517          	auipc	a0,0x1c
    80003ffc:	dc050513          	addi	a0,a0,-576 # 8001fdb8 <ftable>
    80004000:	ba7fc0ef          	jal	ra,80000ba6 <acquire>
  if(f->ref < 1)
    80004004:	40dc                	lw	a5,4(s1)
    80004006:	02f05063          	blez	a5,80004026 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000400a:	2785                	addiw	a5,a5,1
    8000400c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000400e:	0001c517          	auipc	a0,0x1c
    80004012:	daa50513          	addi	a0,a0,-598 # 8001fdb8 <ftable>
    80004016:	c29fc0ef          	jal	ra,80000c3e <release>
  return f;
}
    8000401a:	8526                	mv	a0,s1
    8000401c:	60e2                	ld	ra,24(sp)
    8000401e:	6442                	ld	s0,16(sp)
    80004020:	64a2                	ld	s1,8(sp)
    80004022:	6105                	addi	sp,sp,32
    80004024:	8082                	ret
    panic("filedup");
    80004026:	00004517          	auipc	a0,0x4
    8000402a:	80250513          	addi	a0,a0,-2046 # 80007828 <syscalls+0x290>
    8000402e:	f08fc0ef          	jal	ra,80000736 <panic>

0000000080004032 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004032:	7139                	addi	sp,sp,-64
    80004034:	fc06                	sd	ra,56(sp)
    80004036:	f822                	sd	s0,48(sp)
    80004038:	f426                	sd	s1,40(sp)
    8000403a:	f04a                	sd	s2,32(sp)
    8000403c:	ec4e                	sd	s3,24(sp)
    8000403e:	e852                	sd	s4,16(sp)
    80004040:	e456                	sd	s5,8(sp)
    80004042:	0080                	addi	s0,sp,64
    80004044:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004046:	0001c517          	auipc	a0,0x1c
    8000404a:	d7250513          	addi	a0,a0,-654 # 8001fdb8 <ftable>
    8000404e:	b59fc0ef          	jal	ra,80000ba6 <acquire>
  if(f->ref < 1)
    80004052:	40dc                	lw	a5,4(s1)
    80004054:	04f05963          	blez	a5,800040a6 <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    80004058:	37fd                	addiw	a5,a5,-1
    8000405a:	0007871b          	sext.w	a4,a5
    8000405e:	c0dc                	sw	a5,4(s1)
    80004060:	04e04963          	bgtz	a4,800040b2 <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004064:	0004a903          	lw	s2,0(s1)
    80004068:	0094ca83          	lbu	s5,9(s1)
    8000406c:	0104ba03          	ld	s4,16(s1)
    80004070:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004074:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004078:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000407c:	0001c517          	auipc	a0,0x1c
    80004080:	d3c50513          	addi	a0,a0,-708 # 8001fdb8 <ftable>
    80004084:	bbbfc0ef          	jal	ra,80000c3e <release>

  if(ff.type == FD_PIPE){
    80004088:	4785                	li	a5,1
    8000408a:	04f90363          	beq	s2,a5,800040d0 <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000408e:	3979                	addiw	s2,s2,-2
    80004090:	4785                	li	a5,1
    80004092:	0327e663          	bltu	a5,s2,800040be <fileclose+0x8c>
    begin_op();
    80004096:	b81ff0ef          	jal	ra,80003c16 <begin_op>
    iput(ff.ip);
    8000409a:	854e                	mv	a0,s3
    8000409c:	c6eff0ef          	jal	ra,8000350a <iput>
    end_op();
    800040a0:	be7ff0ef          	jal	ra,80003c86 <end_op>
    800040a4:	a829                	j	800040be <fileclose+0x8c>
    panic("fileclose");
    800040a6:	00003517          	auipc	a0,0x3
    800040aa:	78a50513          	addi	a0,a0,1930 # 80007830 <syscalls+0x298>
    800040ae:	e88fc0ef          	jal	ra,80000736 <panic>
    release(&ftable.lock);
    800040b2:	0001c517          	auipc	a0,0x1c
    800040b6:	d0650513          	addi	a0,a0,-762 # 8001fdb8 <ftable>
    800040ba:	b85fc0ef          	jal	ra,80000c3e <release>
  }
}
    800040be:	70e2                	ld	ra,56(sp)
    800040c0:	7442                	ld	s0,48(sp)
    800040c2:	74a2                	ld	s1,40(sp)
    800040c4:	7902                	ld	s2,32(sp)
    800040c6:	69e2                	ld	s3,24(sp)
    800040c8:	6a42                	ld	s4,16(sp)
    800040ca:	6aa2                	ld	s5,8(sp)
    800040cc:	6121                	addi	sp,sp,64
    800040ce:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800040d0:	85d6                	mv	a1,s5
    800040d2:	8552                	mv	a0,s4
    800040d4:	2ec000ef          	jal	ra,800043c0 <pipeclose>
    800040d8:	b7dd                	j	800040be <fileclose+0x8c>

00000000800040da <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800040da:	715d                	addi	sp,sp,-80
    800040dc:	e486                	sd	ra,72(sp)
    800040de:	e0a2                	sd	s0,64(sp)
    800040e0:	fc26                	sd	s1,56(sp)
    800040e2:	f84a                	sd	s2,48(sp)
    800040e4:	f44e                	sd	s3,40(sp)
    800040e6:	0880                	addi	s0,sp,80
    800040e8:	84aa                	mv	s1,a0
    800040ea:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800040ec:	859fd0ef          	jal	ra,80001944 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800040f0:	409c                	lw	a5,0(s1)
    800040f2:	37f9                	addiw	a5,a5,-2
    800040f4:	4705                	li	a4,1
    800040f6:	02f76f63          	bltu	a4,a5,80004134 <filestat+0x5a>
    800040fa:	892a                	mv	s2,a0
    ilock(f->ip);
    800040fc:	6c88                	ld	a0,24(s1)
    800040fe:	a8eff0ef          	jal	ra,8000338c <ilock>
    stati(f->ip, &st);
    80004102:	fb840593          	addi	a1,s0,-72
    80004106:	6c88                	ld	a0,24(s1)
    80004108:	caaff0ef          	jal	ra,800035b2 <stati>
    iunlock(f->ip);
    8000410c:	6c88                	ld	a0,24(s1)
    8000410e:	b28ff0ef          	jal	ra,80003436 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004112:	46e1                	li	a3,24
    80004114:	fb840613          	addi	a2,s0,-72
    80004118:	85ce                	mv	a1,s3
    8000411a:	05093503          	ld	a0,80(s2)
    8000411e:	cdafd0ef          	jal	ra,800015f8 <copyout>
    80004122:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004126:	60a6                	ld	ra,72(sp)
    80004128:	6406                	ld	s0,64(sp)
    8000412a:	74e2                	ld	s1,56(sp)
    8000412c:	7942                	ld	s2,48(sp)
    8000412e:	79a2                	ld	s3,40(sp)
    80004130:	6161                	addi	sp,sp,80
    80004132:	8082                	ret
  return -1;
    80004134:	557d                	li	a0,-1
    80004136:	bfc5                	j	80004126 <filestat+0x4c>

0000000080004138 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004138:	7179                	addi	sp,sp,-48
    8000413a:	f406                	sd	ra,40(sp)
    8000413c:	f022                	sd	s0,32(sp)
    8000413e:	ec26                	sd	s1,24(sp)
    80004140:	e84a                	sd	s2,16(sp)
    80004142:	e44e                	sd	s3,8(sp)
    80004144:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004146:	00854783          	lbu	a5,8(a0)
    8000414a:	cbc1                	beqz	a5,800041da <fileread+0xa2>
    8000414c:	84aa                	mv	s1,a0
    8000414e:	89ae                	mv	s3,a1
    80004150:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004152:	411c                	lw	a5,0(a0)
    80004154:	4705                	li	a4,1
    80004156:	04e78363          	beq	a5,a4,8000419c <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000415a:	470d                	li	a4,3
    8000415c:	04e78563          	beq	a5,a4,800041a6 <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004160:	4709                	li	a4,2
    80004162:	06e79663          	bne	a5,a4,800041ce <fileread+0x96>
    ilock(f->ip);
    80004166:	6d08                	ld	a0,24(a0)
    80004168:	a24ff0ef          	jal	ra,8000338c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000416c:	874a                	mv	a4,s2
    8000416e:	5094                	lw	a3,32(s1)
    80004170:	864e                	mv	a2,s3
    80004172:	4585                	li	a1,1
    80004174:	6c88                	ld	a0,24(s1)
    80004176:	c66ff0ef          	jal	ra,800035dc <readi>
    8000417a:	892a                	mv	s2,a0
    8000417c:	00a05563          	blez	a0,80004186 <fileread+0x4e>
      f->off += r;
    80004180:	509c                	lw	a5,32(s1)
    80004182:	9fa9                	addw	a5,a5,a0
    80004184:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004186:	6c88                	ld	a0,24(s1)
    80004188:	aaeff0ef          	jal	ra,80003436 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000418c:	854a                	mv	a0,s2
    8000418e:	70a2                	ld	ra,40(sp)
    80004190:	7402                	ld	s0,32(sp)
    80004192:	64e2                	ld	s1,24(sp)
    80004194:	6942                	ld	s2,16(sp)
    80004196:	69a2                	ld	s3,8(sp)
    80004198:	6145                	addi	sp,sp,48
    8000419a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000419c:	6908                	ld	a0,16(a0)
    8000419e:	34e000ef          	jal	ra,800044ec <piperead>
    800041a2:	892a                	mv	s2,a0
    800041a4:	b7e5                	j	8000418c <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800041a6:	02451783          	lh	a5,36(a0)
    800041aa:	03079693          	slli	a3,a5,0x30
    800041ae:	92c1                	srli	a3,a3,0x30
    800041b0:	4725                	li	a4,9
    800041b2:	02d76663          	bltu	a4,a3,800041de <fileread+0xa6>
    800041b6:	0792                	slli	a5,a5,0x4
    800041b8:	0001c717          	auipc	a4,0x1c
    800041bc:	b6070713          	addi	a4,a4,-1184 # 8001fd18 <devsw>
    800041c0:	97ba                	add	a5,a5,a4
    800041c2:	639c                	ld	a5,0(a5)
    800041c4:	cf99                	beqz	a5,800041e2 <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    800041c6:	4505                	li	a0,1
    800041c8:	9782                	jalr	a5
    800041ca:	892a                	mv	s2,a0
    800041cc:	b7c1                	j	8000418c <fileread+0x54>
    panic("fileread");
    800041ce:	00003517          	auipc	a0,0x3
    800041d2:	67250513          	addi	a0,a0,1650 # 80007840 <syscalls+0x2a8>
    800041d6:	d60fc0ef          	jal	ra,80000736 <panic>
    return -1;
    800041da:	597d                	li	s2,-1
    800041dc:	bf45                	j	8000418c <fileread+0x54>
      return -1;
    800041de:	597d                	li	s2,-1
    800041e0:	b775                	j	8000418c <fileread+0x54>
    800041e2:	597d                	li	s2,-1
    800041e4:	b765                	j	8000418c <fileread+0x54>

00000000800041e6 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    800041e6:	715d                	addi	sp,sp,-80
    800041e8:	e486                	sd	ra,72(sp)
    800041ea:	e0a2                	sd	s0,64(sp)
    800041ec:	fc26                	sd	s1,56(sp)
    800041ee:	f84a                	sd	s2,48(sp)
    800041f0:	f44e                	sd	s3,40(sp)
    800041f2:	f052                	sd	s4,32(sp)
    800041f4:	ec56                	sd	s5,24(sp)
    800041f6:	e85a                	sd	s6,16(sp)
    800041f8:	e45e                	sd	s7,8(sp)
    800041fa:	e062                	sd	s8,0(sp)
    800041fc:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    800041fe:	00954783          	lbu	a5,9(a0)
    80004202:	0e078863          	beqz	a5,800042f2 <filewrite+0x10c>
    80004206:	892a                	mv	s2,a0
    80004208:	8aae                	mv	s5,a1
    8000420a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000420c:	411c                	lw	a5,0(a0)
    8000420e:	4705                	li	a4,1
    80004210:	02e78263          	beq	a5,a4,80004234 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004214:	470d                	li	a4,3
    80004216:	02e78463          	beq	a5,a4,8000423e <filewrite+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000421a:	4709                	li	a4,2
    8000421c:	0ce79563          	bne	a5,a4,800042e6 <filewrite+0x100>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004220:	0ac05163          	blez	a2,800042c2 <filewrite+0xdc>
    int i = 0;
    80004224:	4981                	li	s3,0
    80004226:	6b05                	lui	s6,0x1
    80004228:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    8000422c:	6b85                	lui	s7,0x1
    8000422e:	c00b8b9b          	addiw	s7,s7,-1024
    80004232:	a041                	j	800042b2 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80004234:	6908                	ld	a0,16(a0)
    80004236:	1e2000ef          	jal	ra,80004418 <pipewrite>
    8000423a:	8a2a                	mv	s4,a0
    8000423c:	a071                	j	800042c8 <filewrite+0xe2>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000423e:	02451783          	lh	a5,36(a0)
    80004242:	03079693          	slli	a3,a5,0x30
    80004246:	92c1                	srli	a3,a3,0x30
    80004248:	4725                	li	a4,9
    8000424a:	0ad76663          	bltu	a4,a3,800042f6 <filewrite+0x110>
    8000424e:	0792                	slli	a5,a5,0x4
    80004250:	0001c717          	auipc	a4,0x1c
    80004254:	ac870713          	addi	a4,a4,-1336 # 8001fd18 <devsw>
    80004258:	97ba                	add	a5,a5,a4
    8000425a:	679c                	ld	a5,8(a5)
    8000425c:	cfd9                	beqz	a5,800042fa <filewrite+0x114>
    ret = devsw[f->major].write(1, addr, n);
    8000425e:	4505                	li	a0,1
    80004260:	9782                	jalr	a5
    80004262:	8a2a                	mv	s4,a0
    80004264:	a095                	j	800042c8 <filewrite+0xe2>
    80004266:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    8000426a:	9adff0ef          	jal	ra,80003c16 <begin_op>
      ilock(f->ip);
    8000426e:	01893503          	ld	a0,24(s2)
    80004272:	91aff0ef          	jal	ra,8000338c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004276:	8762                	mv	a4,s8
    80004278:	02092683          	lw	a3,32(s2)
    8000427c:	01598633          	add	a2,s3,s5
    80004280:	4585                	li	a1,1
    80004282:	01893503          	ld	a0,24(s2)
    80004286:	c3aff0ef          	jal	ra,800036c0 <writei>
    8000428a:	84aa                	mv	s1,a0
    8000428c:	00a05763          	blez	a0,8000429a <filewrite+0xb4>
        f->off += r;
    80004290:	02092783          	lw	a5,32(s2)
    80004294:	9fa9                	addw	a5,a5,a0
    80004296:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000429a:	01893503          	ld	a0,24(s2)
    8000429e:	998ff0ef          	jal	ra,80003436 <iunlock>
      end_op();
    800042a2:	9e5ff0ef          	jal	ra,80003c86 <end_op>

      if(r != n1){
    800042a6:	009c1f63          	bne	s8,s1,800042c4 <filewrite+0xde>
        // error from writei
        break;
      }
      i += r;
    800042aa:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800042ae:	0149db63          	bge	s3,s4,800042c4 <filewrite+0xde>
      int n1 = n - i;
    800042b2:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800042b6:	84be                	mv	s1,a5
    800042b8:	2781                	sext.w	a5,a5
    800042ba:	fafb56e3          	bge	s6,a5,80004266 <filewrite+0x80>
    800042be:	84de                	mv	s1,s7
    800042c0:	b75d                	j	80004266 <filewrite+0x80>
    int i = 0;
    800042c2:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800042c4:	013a1f63          	bne	s4,s3,800042e2 <filewrite+0xfc>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800042c8:	8552                	mv	a0,s4
    800042ca:	60a6                	ld	ra,72(sp)
    800042cc:	6406                	ld	s0,64(sp)
    800042ce:	74e2                	ld	s1,56(sp)
    800042d0:	7942                	ld	s2,48(sp)
    800042d2:	79a2                	ld	s3,40(sp)
    800042d4:	7a02                	ld	s4,32(sp)
    800042d6:	6ae2                	ld	s5,24(sp)
    800042d8:	6b42                	ld	s6,16(sp)
    800042da:	6ba2                	ld	s7,8(sp)
    800042dc:	6c02                	ld	s8,0(sp)
    800042de:	6161                	addi	sp,sp,80
    800042e0:	8082                	ret
    ret = (i == n ? n : -1);
    800042e2:	5a7d                	li	s4,-1
    800042e4:	b7d5                	j	800042c8 <filewrite+0xe2>
    panic("filewrite");
    800042e6:	00003517          	auipc	a0,0x3
    800042ea:	56a50513          	addi	a0,a0,1386 # 80007850 <syscalls+0x2b8>
    800042ee:	c48fc0ef          	jal	ra,80000736 <panic>
    return -1;
    800042f2:	5a7d                	li	s4,-1
    800042f4:	bfd1                	j	800042c8 <filewrite+0xe2>
      return -1;
    800042f6:	5a7d                	li	s4,-1
    800042f8:	bfc1                	j	800042c8 <filewrite+0xe2>
    800042fa:	5a7d                	li	s4,-1
    800042fc:	b7f1                	j	800042c8 <filewrite+0xe2>

00000000800042fe <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800042fe:	7179                	addi	sp,sp,-48
    80004300:	f406                	sd	ra,40(sp)
    80004302:	f022                	sd	s0,32(sp)
    80004304:	ec26                	sd	s1,24(sp)
    80004306:	e84a                	sd	s2,16(sp)
    80004308:	e44e                	sd	s3,8(sp)
    8000430a:	e052                	sd	s4,0(sp)
    8000430c:	1800                	addi	s0,sp,48
    8000430e:	84aa                	mv	s1,a0
    80004310:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004312:	0005b023          	sd	zero,0(a1)
    80004316:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000431a:	c75ff0ef          	jal	ra,80003f8e <filealloc>
    8000431e:	e088                	sd	a0,0(s1)
    80004320:	cd35                	beqz	a0,8000439c <pipealloc+0x9e>
    80004322:	c6dff0ef          	jal	ra,80003f8e <filealloc>
    80004326:	00aa3023          	sd	a0,0(s4)
    8000432a:	c52d                	beqz	a0,80004394 <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000432c:	f6afc0ef          	jal	ra,80000a96 <kalloc>
    80004330:	892a                	mv	s2,a0
    80004332:	cd31                	beqz	a0,8000438e <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    80004334:	4985                	li	s3,1
    80004336:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000433a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000433e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004342:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004346:	00003597          	auipc	a1,0x3
    8000434a:	51a58593          	addi	a1,a1,1306 # 80007860 <syscalls+0x2c8>
    8000434e:	fd8fc0ef          	jal	ra,80000b26 <initlock>
  (*f0)->type = FD_PIPE;
    80004352:	609c                	ld	a5,0(s1)
    80004354:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004358:	609c                	ld	a5,0(s1)
    8000435a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000435e:	609c                	ld	a5,0(s1)
    80004360:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004364:	609c                	ld	a5,0(s1)
    80004366:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000436a:	000a3783          	ld	a5,0(s4)
    8000436e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004372:	000a3783          	ld	a5,0(s4)
    80004376:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000437a:	000a3783          	ld	a5,0(s4)
    8000437e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004382:	000a3783          	ld	a5,0(s4)
    80004386:	0127b823          	sd	s2,16(a5)
  return 0;
    8000438a:	4501                	li	a0,0
    8000438c:	a005                	j	800043ac <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000438e:	6088                	ld	a0,0(s1)
    80004390:	e501                	bnez	a0,80004398 <pipealloc+0x9a>
    80004392:	a029                	j	8000439c <pipealloc+0x9e>
    80004394:	6088                	ld	a0,0(s1)
    80004396:	c11d                	beqz	a0,800043bc <pipealloc+0xbe>
    fileclose(*f0);
    80004398:	c9bff0ef          	jal	ra,80004032 <fileclose>
  if(*f1)
    8000439c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800043a0:	557d                	li	a0,-1
  if(*f1)
    800043a2:	c789                	beqz	a5,800043ac <pipealloc+0xae>
    fileclose(*f1);
    800043a4:	853e                	mv	a0,a5
    800043a6:	c8dff0ef          	jal	ra,80004032 <fileclose>
  return -1;
    800043aa:	557d                	li	a0,-1
}
    800043ac:	70a2                	ld	ra,40(sp)
    800043ae:	7402                	ld	s0,32(sp)
    800043b0:	64e2                	ld	s1,24(sp)
    800043b2:	6942                	ld	s2,16(sp)
    800043b4:	69a2                	ld	s3,8(sp)
    800043b6:	6a02                	ld	s4,0(sp)
    800043b8:	6145                	addi	sp,sp,48
    800043ba:	8082                	ret
  return -1;
    800043bc:	557d                	li	a0,-1
    800043be:	b7fd                	j	800043ac <pipealloc+0xae>

00000000800043c0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800043c0:	1101                	addi	sp,sp,-32
    800043c2:	ec06                	sd	ra,24(sp)
    800043c4:	e822                	sd	s0,16(sp)
    800043c6:	e426                	sd	s1,8(sp)
    800043c8:	e04a                	sd	s2,0(sp)
    800043ca:	1000                	addi	s0,sp,32
    800043cc:	84aa                	mv	s1,a0
    800043ce:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800043d0:	fd6fc0ef          	jal	ra,80000ba6 <acquire>
  if(writable){
    800043d4:	02090763          	beqz	s2,80004402 <pipeclose+0x42>
    pi->writeopen = 0;
    800043d8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800043dc:	21848513          	addi	a0,s1,536
    800043e0:	b7dfd0ef          	jal	ra,80001f5c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800043e4:	2204b783          	ld	a5,544(s1)
    800043e8:	e785                	bnez	a5,80004410 <pipeclose+0x50>
    release(&pi->lock);
    800043ea:	8526                	mv	a0,s1
    800043ec:	853fc0ef          	jal	ra,80000c3e <release>
    kfree((char*)pi);
    800043f0:	8526                	mv	a0,s1
    800043f2:	dd8fc0ef          	jal	ra,800009ca <kfree>
  } else
    release(&pi->lock);
}
    800043f6:	60e2                	ld	ra,24(sp)
    800043f8:	6442                	ld	s0,16(sp)
    800043fa:	64a2                	ld	s1,8(sp)
    800043fc:	6902                	ld	s2,0(sp)
    800043fe:	6105                	addi	sp,sp,32
    80004400:	8082                	ret
    pi->readopen = 0;
    80004402:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004406:	21c48513          	addi	a0,s1,540
    8000440a:	b53fd0ef          	jal	ra,80001f5c <wakeup>
    8000440e:	bfd9                	j	800043e4 <pipeclose+0x24>
    release(&pi->lock);
    80004410:	8526                	mv	a0,s1
    80004412:	82dfc0ef          	jal	ra,80000c3e <release>
}
    80004416:	b7c5                	j	800043f6 <pipeclose+0x36>

0000000080004418 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004418:	711d                	addi	sp,sp,-96
    8000441a:	ec86                	sd	ra,88(sp)
    8000441c:	e8a2                	sd	s0,80(sp)
    8000441e:	e4a6                	sd	s1,72(sp)
    80004420:	e0ca                	sd	s2,64(sp)
    80004422:	fc4e                	sd	s3,56(sp)
    80004424:	f852                	sd	s4,48(sp)
    80004426:	f456                	sd	s5,40(sp)
    80004428:	f05a                	sd	s6,32(sp)
    8000442a:	ec5e                	sd	s7,24(sp)
    8000442c:	e862                	sd	s8,16(sp)
    8000442e:	1080                	addi	s0,sp,96
    80004430:	84aa                	mv	s1,a0
    80004432:	8aae                	mv	s5,a1
    80004434:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004436:	d0efd0ef          	jal	ra,80001944 <myproc>
    8000443a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000443c:	8526                	mv	a0,s1
    8000443e:	f68fc0ef          	jal	ra,80000ba6 <acquire>
  while(i < n){
    80004442:	09405c63          	blez	s4,800044da <pipewrite+0xc2>
  int i = 0;
    80004446:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004448:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000444a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000444e:	21c48b93          	addi	s7,s1,540
    80004452:	a81d                	j	80004488 <pipewrite+0x70>
      release(&pi->lock);
    80004454:	8526                	mv	a0,s1
    80004456:	fe8fc0ef          	jal	ra,80000c3e <release>
      return -1;
    8000445a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000445c:	854a                	mv	a0,s2
    8000445e:	60e6                	ld	ra,88(sp)
    80004460:	6446                	ld	s0,80(sp)
    80004462:	64a6                	ld	s1,72(sp)
    80004464:	6906                	ld	s2,64(sp)
    80004466:	79e2                	ld	s3,56(sp)
    80004468:	7a42                	ld	s4,48(sp)
    8000446a:	7aa2                	ld	s5,40(sp)
    8000446c:	7b02                	ld	s6,32(sp)
    8000446e:	6be2                	ld	s7,24(sp)
    80004470:	6c42                	ld	s8,16(sp)
    80004472:	6125                	addi	sp,sp,96
    80004474:	8082                	ret
      wakeup(&pi->nread);
    80004476:	8562                	mv	a0,s8
    80004478:	ae5fd0ef          	jal	ra,80001f5c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000447c:	85a6                	mv	a1,s1
    8000447e:	855e                	mv	a0,s7
    80004480:	a91fd0ef          	jal	ra,80001f10 <sleep>
  while(i < n){
    80004484:	05495c63          	bge	s2,s4,800044dc <pipewrite+0xc4>
    if(pi->readopen == 0 || killed(pr)){
    80004488:	2204a783          	lw	a5,544(s1)
    8000448c:	d7e1                	beqz	a5,80004454 <pipewrite+0x3c>
    8000448e:	854e                	mv	a0,s3
    80004490:	cb9fd0ef          	jal	ra,80002148 <killed>
    80004494:	f161                	bnez	a0,80004454 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004496:	2184a783          	lw	a5,536(s1)
    8000449a:	21c4a703          	lw	a4,540(s1)
    8000449e:	2007879b          	addiw	a5,a5,512
    800044a2:	fcf70ae3          	beq	a4,a5,80004476 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800044a6:	4685                	li	a3,1
    800044a8:	01590633          	add	a2,s2,s5
    800044ac:	faf40593          	addi	a1,s0,-81
    800044b0:	0509b503          	ld	a0,80(s3)
    800044b4:	9fcfd0ef          	jal	ra,800016b0 <copyin>
    800044b8:	03650263          	beq	a0,s6,800044dc <pipewrite+0xc4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800044bc:	21c4a783          	lw	a5,540(s1)
    800044c0:	0017871b          	addiw	a4,a5,1
    800044c4:	20e4ae23          	sw	a4,540(s1)
    800044c8:	1ff7f793          	andi	a5,a5,511
    800044cc:	97a6                	add	a5,a5,s1
    800044ce:	faf44703          	lbu	a4,-81(s0)
    800044d2:	00e78c23          	sb	a4,24(a5)
      i++;
    800044d6:	2905                	addiw	s2,s2,1
    800044d8:	b775                	j	80004484 <pipewrite+0x6c>
  int i = 0;
    800044da:	4901                	li	s2,0
  wakeup(&pi->nread);
    800044dc:	21848513          	addi	a0,s1,536
    800044e0:	a7dfd0ef          	jal	ra,80001f5c <wakeup>
  release(&pi->lock);
    800044e4:	8526                	mv	a0,s1
    800044e6:	f58fc0ef          	jal	ra,80000c3e <release>
  return i;
    800044ea:	bf8d                	j	8000445c <pipewrite+0x44>

00000000800044ec <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800044ec:	715d                	addi	sp,sp,-80
    800044ee:	e486                	sd	ra,72(sp)
    800044f0:	e0a2                	sd	s0,64(sp)
    800044f2:	fc26                	sd	s1,56(sp)
    800044f4:	f84a                	sd	s2,48(sp)
    800044f6:	f44e                	sd	s3,40(sp)
    800044f8:	f052                	sd	s4,32(sp)
    800044fa:	ec56                	sd	s5,24(sp)
    800044fc:	e85a                	sd	s6,16(sp)
    800044fe:	0880                	addi	s0,sp,80
    80004500:	84aa                	mv	s1,a0
    80004502:	892e                	mv	s2,a1
    80004504:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004506:	c3efd0ef          	jal	ra,80001944 <myproc>
    8000450a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000450c:	8526                	mv	a0,s1
    8000450e:	e98fc0ef          	jal	ra,80000ba6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004512:	2184a703          	lw	a4,536(s1)
    80004516:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000451a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000451e:	02f71363          	bne	a4,a5,80004544 <piperead+0x58>
    80004522:	2244a783          	lw	a5,548(s1)
    80004526:	cf99                	beqz	a5,80004544 <piperead+0x58>
    if(killed(pr)){
    80004528:	8552                	mv	a0,s4
    8000452a:	c1ffd0ef          	jal	ra,80002148 <killed>
    8000452e:	e141                	bnez	a0,800045ae <piperead+0xc2>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004530:	85a6                	mv	a1,s1
    80004532:	854e                	mv	a0,s3
    80004534:	9ddfd0ef          	jal	ra,80001f10 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004538:	2184a703          	lw	a4,536(s1)
    8000453c:	21c4a783          	lw	a5,540(s1)
    80004540:	fef701e3          	beq	a4,a5,80004522 <piperead+0x36>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004544:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004546:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004548:	05505163          	blez	s5,8000458a <piperead+0x9e>
    if(pi->nread == pi->nwrite)
    8000454c:	2184a783          	lw	a5,536(s1)
    80004550:	21c4a703          	lw	a4,540(s1)
    80004554:	02f70b63          	beq	a4,a5,8000458a <piperead+0x9e>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004558:	0017871b          	addiw	a4,a5,1
    8000455c:	20e4ac23          	sw	a4,536(s1)
    80004560:	1ff7f793          	andi	a5,a5,511
    80004564:	97a6                	add	a5,a5,s1
    80004566:	0187c783          	lbu	a5,24(a5)
    8000456a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000456e:	4685                	li	a3,1
    80004570:	fbf40613          	addi	a2,s0,-65
    80004574:	85ca                	mv	a1,s2
    80004576:	050a3503          	ld	a0,80(s4)
    8000457a:	87efd0ef          	jal	ra,800015f8 <copyout>
    8000457e:	01650663          	beq	a0,s6,8000458a <piperead+0x9e>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004582:	2985                	addiw	s3,s3,1
    80004584:	0905                	addi	s2,s2,1
    80004586:	fd3a93e3          	bne	s5,s3,8000454c <piperead+0x60>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000458a:	21c48513          	addi	a0,s1,540
    8000458e:	9cffd0ef          	jal	ra,80001f5c <wakeup>
  release(&pi->lock);
    80004592:	8526                	mv	a0,s1
    80004594:	eaafc0ef          	jal	ra,80000c3e <release>
  return i;
}
    80004598:	854e                	mv	a0,s3
    8000459a:	60a6                	ld	ra,72(sp)
    8000459c:	6406                	ld	s0,64(sp)
    8000459e:	74e2                	ld	s1,56(sp)
    800045a0:	7942                	ld	s2,48(sp)
    800045a2:	79a2                	ld	s3,40(sp)
    800045a4:	7a02                	ld	s4,32(sp)
    800045a6:	6ae2                	ld	s5,24(sp)
    800045a8:	6b42                	ld	s6,16(sp)
    800045aa:	6161                	addi	sp,sp,80
    800045ac:	8082                	ret
      release(&pi->lock);
    800045ae:	8526                	mv	a0,s1
    800045b0:	e8efc0ef          	jal	ra,80000c3e <release>
      return -1;
    800045b4:	59fd                	li	s3,-1
    800045b6:	b7cd                	j	80004598 <piperead+0xac>

00000000800045b8 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800045b8:	1141                	addi	sp,sp,-16
    800045ba:	e422                	sd	s0,8(sp)
    800045bc:	0800                	addi	s0,sp,16
    800045be:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800045c0:	8905                	andi	a0,a0,1
    800045c2:	c111                	beqz	a0,800045c6 <flags2perm+0xe>
      perm = PTE_X;
    800045c4:	4521                	li	a0,8
    if(flags & 0x2)
    800045c6:	8b89                	andi	a5,a5,2
    800045c8:	c399                	beqz	a5,800045ce <flags2perm+0x16>
      perm |= PTE_W;
    800045ca:	00456513          	ori	a0,a0,4
    return perm;
}
    800045ce:	6422                	ld	s0,8(sp)
    800045d0:	0141                	addi	sp,sp,16
    800045d2:	8082                	ret

00000000800045d4 <exec>:

int
exec(char *path, char **argv)
{
    800045d4:	de010113          	addi	sp,sp,-544
    800045d8:	20113c23          	sd	ra,536(sp)
    800045dc:	20813823          	sd	s0,528(sp)
    800045e0:	20913423          	sd	s1,520(sp)
    800045e4:	21213023          	sd	s2,512(sp)
    800045e8:	ffce                	sd	s3,504(sp)
    800045ea:	fbd2                	sd	s4,496(sp)
    800045ec:	f7d6                	sd	s5,488(sp)
    800045ee:	f3da                	sd	s6,480(sp)
    800045f0:	efde                	sd	s7,472(sp)
    800045f2:	ebe2                	sd	s8,464(sp)
    800045f4:	e7e6                	sd	s9,456(sp)
    800045f6:	e3ea                	sd	s10,448(sp)
    800045f8:	ff6e                	sd	s11,440(sp)
    800045fa:	1400                	addi	s0,sp,544
    800045fc:	892a                	mv	s2,a0
    800045fe:	dea43423          	sd	a0,-536(s0)
    80004602:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004606:	b3efd0ef          	jal	ra,80001944 <myproc>
    8000460a:	84aa                	mv	s1,a0

  begin_op();
    8000460c:	e0aff0ef          	jal	ra,80003c16 <begin_op>

  if((ip = namei(path)) == 0){
    80004610:	854a                	mv	a0,s2
    80004612:	c2cff0ef          	jal	ra,80003a3e <namei>
    80004616:	c13d                	beqz	a0,8000467c <exec+0xa8>
    80004618:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000461a:	d73fe0ef          	jal	ra,8000338c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000461e:	04000713          	li	a4,64
    80004622:	4681                	li	a3,0
    80004624:	e5040613          	addi	a2,s0,-432
    80004628:	4581                	li	a1,0
    8000462a:	8556                	mv	a0,s5
    8000462c:	fb1fe0ef          	jal	ra,800035dc <readi>
    80004630:	04000793          	li	a5,64
    80004634:	00f51a63          	bne	a0,a5,80004648 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004638:	e5042703          	lw	a4,-432(s0)
    8000463c:	464c47b7          	lui	a5,0x464c4
    80004640:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004644:	04f70063          	beq	a4,a5,80004684 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004648:	8556                	mv	a0,s5
    8000464a:	f49fe0ef          	jal	ra,80003592 <iunlockput>
    end_op();
    8000464e:	e38ff0ef          	jal	ra,80003c86 <end_op>
  }
  return -1;
    80004652:	557d                	li	a0,-1
}
    80004654:	21813083          	ld	ra,536(sp)
    80004658:	21013403          	ld	s0,528(sp)
    8000465c:	20813483          	ld	s1,520(sp)
    80004660:	20013903          	ld	s2,512(sp)
    80004664:	79fe                	ld	s3,504(sp)
    80004666:	7a5e                	ld	s4,496(sp)
    80004668:	7abe                	ld	s5,488(sp)
    8000466a:	7b1e                	ld	s6,480(sp)
    8000466c:	6bfe                	ld	s7,472(sp)
    8000466e:	6c5e                	ld	s8,464(sp)
    80004670:	6cbe                	ld	s9,456(sp)
    80004672:	6d1e                	ld	s10,448(sp)
    80004674:	7dfa                	ld	s11,440(sp)
    80004676:	22010113          	addi	sp,sp,544
    8000467a:	8082                	ret
    end_op();
    8000467c:	e0aff0ef          	jal	ra,80003c86 <end_op>
    return -1;
    80004680:	557d                	li	a0,-1
    80004682:	bfc9                	j	80004654 <exec+0x80>
  if((pagetable = proc_pagetable(p)) == 0)
    80004684:	8526                	mv	a0,s1
    80004686:	b66fd0ef          	jal	ra,800019ec <proc_pagetable>
    8000468a:	8b2a                	mv	s6,a0
    8000468c:	dd55                	beqz	a0,80004648 <exec+0x74>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000468e:	e7042783          	lw	a5,-400(s0)
    80004692:	e8845703          	lhu	a4,-376(s0)
    80004696:	c325                	beqz	a4,800046f6 <exec+0x122>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004698:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000469a:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    8000469e:	6a05                	lui	s4,0x1
    800046a0:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800046a4:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800046a8:	6d85                	lui	s11,0x1
    800046aa:	7d7d                	lui	s10,0xfffff
    800046ac:	a411                	j	800048b0 <exec+0x2dc>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800046ae:	00003517          	auipc	a0,0x3
    800046b2:	1ba50513          	addi	a0,a0,442 # 80007868 <syscalls+0x2d0>
    800046b6:	880fc0ef          	jal	ra,80000736 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800046ba:	874a                	mv	a4,s2
    800046bc:	009c86bb          	addw	a3,s9,s1
    800046c0:	4581                	li	a1,0
    800046c2:	8556                	mv	a0,s5
    800046c4:	f19fe0ef          	jal	ra,800035dc <readi>
    800046c8:	2501                	sext.w	a0,a0
    800046ca:	18a91263          	bne	s2,a0,8000484e <exec+0x27a>
  for(i = 0; i < sz; i += PGSIZE){
    800046ce:	009d84bb          	addw	s1,s11,s1
    800046d2:	013d09bb          	addw	s3,s10,s3
    800046d6:	1b74fd63          	bgeu	s1,s7,80004890 <exec+0x2bc>
    pa = walkaddr(pagetable, va + i);
    800046da:	02049593          	slli	a1,s1,0x20
    800046de:	9181                	srli	a1,a1,0x20
    800046e0:	95e2                	add	a1,a1,s8
    800046e2:	855a                	mv	a0,s6
    800046e4:	9b9fc0ef          	jal	ra,8000109c <walkaddr>
    800046e8:	862a                	mv	a2,a0
    if(pa == 0)
    800046ea:	d171                	beqz	a0,800046ae <exec+0xda>
      n = PGSIZE;
    800046ec:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800046ee:	fd49f6e3          	bgeu	s3,s4,800046ba <exec+0xe6>
      n = sz - i;
    800046f2:	894e                	mv	s2,s3
    800046f4:	b7d9                	j	800046ba <exec+0xe6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800046f6:	4901                	li	s2,0
  iunlockput(ip);
    800046f8:	8556                	mv	a0,s5
    800046fa:	e99fe0ef          	jal	ra,80003592 <iunlockput>
  end_op();
    800046fe:	d88ff0ef          	jal	ra,80003c86 <end_op>
  p = myproc();
    80004702:	a42fd0ef          	jal	ra,80001944 <myproc>
    80004706:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004708:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000470c:	6785                	lui	a5,0x1
    8000470e:	17fd                	addi	a5,a5,-1
    80004710:	993e                	add	s2,s2,a5
    80004712:	77fd                	lui	a5,0xfffff
    80004714:	00f977b3          	and	a5,s2,a5
    80004718:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000471c:	4691                	li	a3,4
    8000471e:	6609                	lui	a2,0x2
    80004720:	963e                	add	a2,a2,a5
    80004722:	85be                	mv	a1,a5
    80004724:	855a                	mv	a0,s6
    80004726:	ccffc0ef          	jal	ra,800013f4 <uvmalloc>
    8000472a:	8c2a                	mv	s8,a0
  ip = 0;
    8000472c:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000472e:	12050063          	beqz	a0,8000484e <exec+0x27a>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004732:	75f9                	lui	a1,0xffffe
    80004734:	95aa                	add	a1,a1,a0
    80004736:	855a                	mv	a0,s6
    80004738:	e97fc0ef          	jal	ra,800015ce <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    8000473c:	7afd                	lui	s5,0xfffff
    8000473e:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004740:	df043783          	ld	a5,-528(s0)
    80004744:	6388                	ld	a0,0(a5)
    80004746:	c135                	beqz	a0,800047aa <exec+0x1d6>
    80004748:	e9040993          	addi	s3,s0,-368
    8000474c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004750:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004752:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004754:	e9efc0ef          	jal	ra,80000df2 <strlen>
    80004758:	0015079b          	addiw	a5,a0,1
    8000475c:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004760:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004764:	11596a63          	bltu	s2,s5,80004878 <exec+0x2a4>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004768:	df043d83          	ld	s11,-528(s0)
    8000476c:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004770:	8552                	mv	a0,s4
    80004772:	e80fc0ef          	jal	ra,80000df2 <strlen>
    80004776:	0015069b          	addiw	a3,a0,1
    8000477a:	8652                	mv	a2,s4
    8000477c:	85ca                	mv	a1,s2
    8000477e:	855a                	mv	a0,s6
    80004780:	e79fc0ef          	jal	ra,800015f8 <copyout>
    80004784:	0e054e63          	bltz	a0,80004880 <exec+0x2ac>
    ustack[argc] = sp;
    80004788:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000478c:	0485                	addi	s1,s1,1
    8000478e:	008d8793          	addi	a5,s11,8
    80004792:	def43823          	sd	a5,-528(s0)
    80004796:	008db503          	ld	a0,8(s11)
    8000479a:	c911                	beqz	a0,800047ae <exec+0x1da>
    if(argc >= MAXARG)
    8000479c:	09a1                	addi	s3,s3,8
    8000479e:	fb3c9be3          	bne	s9,s3,80004754 <exec+0x180>
  sz = sz1;
    800047a2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800047a6:	4a81                	li	s5,0
    800047a8:	a05d                	j	8000484e <exec+0x27a>
  sp = sz;
    800047aa:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800047ac:	4481                	li	s1,0
  ustack[argc] = 0;
    800047ae:	00349793          	slli	a5,s1,0x3
    800047b2:	f9040713          	addi	a4,s0,-112
    800047b6:	97ba                	add	a5,a5,a4
    800047b8:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffde050>
  sp -= (argc+1) * sizeof(uint64);
    800047bc:	00148693          	addi	a3,s1,1
    800047c0:	068e                	slli	a3,a3,0x3
    800047c2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800047c6:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800047ca:	01597663          	bgeu	s2,s5,800047d6 <exec+0x202>
  sz = sz1;
    800047ce:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800047d2:	4a81                	li	s5,0
    800047d4:	a8ad                	j	8000484e <exec+0x27a>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800047d6:	e9040613          	addi	a2,s0,-368
    800047da:	85ca                	mv	a1,s2
    800047dc:	855a                	mv	a0,s6
    800047de:	e1bfc0ef          	jal	ra,800015f8 <copyout>
    800047e2:	0a054363          	bltz	a0,80004888 <exec+0x2b4>
  p->trapframe->a1 = sp;
    800047e6:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800047ea:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800047ee:	de843783          	ld	a5,-536(s0)
    800047f2:	0007c703          	lbu	a4,0(a5)
    800047f6:	cf11                	beqz	a4,80004812 <exec+0x23e>
    800047f8:	0785                	addi	a5,a5,1
    if(*s == '/')
    800047fa:	02f00693          	li	a3,47
    800047fe:	a039                	j	8000480c <exec+0x238>
      last = s+1;
    80004800:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004804:	0785                	addi	a5,a5,1
    80004806:	fff7c703          	lbu	a4,-1(a5)
    8000480a:	c701                	beqz	a4,80004812 <exec+0x23e>
    if(*s == '/')
    8000480c:	fed71ce3          	bne	a4,a3,80004804 <exec+0x230>
    80004810:	bfc5                	j	80004800 <exec+0x22c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004812:	4641                	li	a2,16
    80004814:	de843583          	ld	a1,-536(s0)
    80004818:	158b8513          	addi	a0,s7,344
    8000481c:	da4fc0ef          	jal	ra,80000dc0 <safestrcpy>
  oldpagetable = p->pagetable;
    80004820:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004824:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004828:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000482c:	058bb783          	ld	a5,88(s7)
    80004830:	e6843703          	ld	a4,-408(s0)
    80004834:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004836:	058bb783          	ld	a5,88(s7)
    8000483a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000483e:	85ea                	mv	a1,s10
    80004840:	a30fd0ef          	jal	ra,80001a70 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004844:	0004851b          	sext.w	a0,s1
    80004848:	b531                	j	80004654 <exec+0x80>
    8000484a:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000484e:	df843583          	ld	a1,-520(s0)
    80004852:	855a                	mv	a0,s6
    80004854:	a1cfd0ef          	jal	ra,80001a70 <proc_freepagetable>
  if(ip){
    80004858:	de0a98e3          	bnez	s5,80004648 <exec+0x74>
  return -1;
    8000485c:	557d                	li	a0,-1
    8000485e:	bbdd                	j	80004654 <exec+0x80>
    80004860:	df243c23          	sd	s2,-520(s0)
    80004864:	b7ed                	j	8000484e <exec+0x27a>
    80004866:	df243c23          	sd	s2,-520(s0)
    8000486a:	b7d5                	j	8000484e <exec+0x27a>
    8000486c:	df243c23          	sd	s2,-520(s0)
    80004870:	bff9                	j	8000484e <exec+0x27a>
    80004872:	df243c23          	sd	s2,-520(s0)
    80004876:	bfe1                	j	8000484e <exec+0x27a>
  sz = sz1;
    80004878:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000487c:	4a81                	li	s5,0
    8000487e:	bfc1                	j	8000484e <exec+0x27a>
  sz = sz1;
    80004880:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004884:	4a81                	li	s5,0
    80004886:	b7e1                	j	8000484e <exec+0x27a>
  sz = sz1;
    80004888:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000488c:	4a81                	li	s5,0
    8000488e:	b7c1                	j	8000484e <exec+0x27a>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004890:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004894:	e0843783          	ld	a5,-504(s0)
    80004898:	0017869b          	addiw	a3,a5,1
    8000489c:	e0d43423          	sd	a3,-504(s0)
    800048a0:	e0043783          	ld	a5,-512(s0)
    800048a4:	0387879b          	addiw	a5,a5,56
    800048a8:	e8845703          	lhu	a4,-376(s0)
    800048ac:	e4e6d6e3          	bge	a3,a4,800046f8 <exec+0x124>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800048b0:	2781                	sext.w	a5,a5
    800048b2:	e0f43023          	sd	a5,-512(s0)
    800048b6:	03800713          	li	a4,56
    800048ba:	86be                	mv	a3,a5
    800048bc:	e1840613          	addi	a2,s0,-488
    800048c0:	4581                	li	a1,0
    800048c2:	8556                	mv	a0,s5
    800048c4:	d19fe0ef          	jal	ra,800035dc <readi>
    800048c8:	03800793          	li	a5,56
    800048cc:	f6f51fe3          	bne	a0,a5,8000484a <exec+0x276>
    if(ph.type != ELF_PROG_LOAD)
    800048d0:	e1842783          	lw	a5,-488(s0)
    800048d4:	4705                	li	a4,1
    800048d6:	fae79fe3          	bne	a5,a4,80004894 <exec+0x2c0>
    if(ph.memsz < ph.filesz)
    800048da:	e4043483          	ld	s1,-448(s0)
    800048de:	e3843783          	ld	a5,-456(s0)
    800048e2:	f6f4efe3          	bltu	s1,a5,80004860 <exec+0x28c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800048e6:	e2843783          	ld	a5,-472(s0)
    800048ea:	94be                	add	s1,s1,a5
    800048ec:	f6f4ede3          	bltu	s1,a5,80004866 <exec+0x292>
    if(ph.vaddr % PGSIZE != 0)
    800048f0:	de043703          	ld	a4,-544(s0)
    800048f4:	8ff9                	and	a5,a5,a4
    800048f6:	fbbd                	bnez	a5,8000486c <exec+0x298>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800048f8:	e1c42503          	lw	a0,-484(s0)
    800048fc:	cbdff0ef          	jal	ra,800045b8 <flags2perm>
    80004900:	86aa                	mv	a3,a0
    80004902:	8626                	mv	a2,s1
    80004904:	85ca                	mv	a1,s2
    80004906:	855a                	mv	a0,s6
    80004908:	aedfc0ef          	jal	ra,800013f4 <uvmalloc>
    8000490c:	dea43c23          	sd	a0,-520(s0)
    80004910:	d12d                	beqz	a0,80004872 <exec+0x29e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004912:	e2843c03          	ld	s8,-472(s0)
    80004916:	e2042c83          	lw	s9,-480(s0)
    8000491a:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000491e:	f60b89e3          	beqz	s7,80004890 <exec+0x2bc>
    80004922:	89de                	mv	s3,s7
    80004924:	4481                	li	s1,0
    80004926:	bb55                	j	800046da <exec+0x106>

0000000080004928 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004928:	7179                	addi	sp,sp,-48
    8000492a:	f406                	sd	ra,40(sp)
    8000492c:	f022                	sd	s0,32(sp)
    8000492e:	ec26                	sd	s1,24(sp)
    80004930:	e84a                	sd	s2,16(sp)
    80004932:	1800                	addi	s0,sp,48
    80004934:	892e                	mv	s2,a1
    80004936:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004938:	fdc40593          	addi	a1,s0,-36
    8000493c:	f73fd0ef          	jal	ra,800028ae <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004940:	fdc42703          	lw	a4,-36(s0)
    80004944:	47bd                	li	a5,15
    80004946:	02e7e963          	bltu	a5,a4,80004978 <argfd+0x50>
    8000494a:	ffbfc0ef          	jal	ra,80001944 <myproc>
    8000494e:	fdc42703          	lw	a4,-36(s0)
    80004952:	01a70793          	addi	a5,a4,26
    80004956:	078e                	slli	a5,a5,0x3
    80004958:	953e                	add	a0,a0,a5
    8000495a:	611c                	ld	a5,0(a0)
    8000495c:	c385                	beqz	a5,8000497c <argfd+0x54>
    return -1;
  if(pfd)
    8000495e:	00090463          	beqz	s2,80004966 <argfd+0x3e>
    *pfd = fd;
    80004962:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004966:	4501                	li	a0,0
  if(pf)
    80004968:	c091                	beqz	s1,8000496c <argfd+0x44>
    *pf = f;
    8000496a:	e09c                	sd	a5,0(s1)
}
    8000496c:	70a2                	ld	ra,40(sp)
    8000496e:	7402                	ld	s0,32(sp)
    80004970:	64e2                	ld	s1,24(sp)
    80004972:	6942                	ld	s2,16(sp)
    80004974:	6145                	addi	sp,sp,48
    80004976:	8082                	ret
    return -1;
    80004978:	557d                	li	a0,-1
    8000497a:	bfcd                	j	8000496c <argfd+0x44>
    8000497c:	557d                	li	a0,-1
    8000497e:	b7fd                	j	8000496c <argfd+0x44>

0000000080004980 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004980:	1101                	addi	sp,sp,-32
    80004982:	ec06                	sd	ra,24(sp)
    80004984:	e822                	sd	s0,16(sp)
    80004986:	e426                	sd	s1,8(sp)
    80004988:	1000                	addi	s0,sp,32
    8000498a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000498c:	fb9fc0ef          	jal	ra,80001944 <myproc>
    80004990:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004992:	0d050793          	addi	a5,a0,208
    80004996:	4501                	li	a0,0
    80004998:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000499a:	6398                	ld	a4,0(a5)
    8000499c:	cb19                	beqz	a4,800049b2 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    8000499e:	2505                	addiw	a0,a0,1
    800049a0:	07a1                	addi	a5,a5,8
    800049a2:	fed51ce3          	bne	a0,a3,8000499a <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800049a6:	557d                	li	a0,-1
}
    800049a8:	60e2                	ld	ra,24(sp)
    800049aa:	6442                	ld	s0,16(sp)
    800049ac:	64a2                	ld	s1,8(sp)
    800049ae:	6105                	addi	sp,sp,32
    800049b0:	8082                	ret
      p->ofile[fd] = f;
    800049b2:	01a50793          	addi	a5,a0,26
    800049b6:	078e                	slli	a5,a5,0x3
    800049b8:	963e                	add	a2,a2,a5
    800049ba:	e204                	sd	s1,0(a2)
      return fd;
    800049bc:	b7f5                	j	800049a8 <fdalloc+0x28>

00000000800049be <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800049be:	715d                	addi	sp,sp,-80
    800049c0:	e486                	sd	ra,72(sp)
    800049c2:	e0a2                	sd	s0,64(sp)
    800049c4:	fc26                	sd	s1,56(sp)
    800049c6:	f84a                	sd	s2,48(sp)
    800049c8:	f44e                	sd	s3,40(sp)
    800049ca:	f052                	sd	s4,32(sp)
    800049cc:	ec56                	sd	s5,24(sp)
    800049ce:	e85a                	sd	s6,16(sp)
    800049d0:	0880                	addi	s0,sp,80
    800049d2:	8b2e                	mv	s6,a1
    800049d4:	89b2                	mv	s3,a2
    800049d6:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800049d8:	fb040593          	addi	a1,s0,-80
    800049dc:	87cff0ef          	jal	ra,80003a58 <nameiparent>
    800049e0:	84aa                	mv	s1,a0
    800049e2:	10050b63          	beqz	a0,80004af8 <create+0x13a>
    return 0;

  ilock(dp);
    800049e6:	9a7fe0ef          	jal	ra,8000338c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800049ea:	4601                	li	a2,0
    800049ec:	fb040593          	addi	a1,s0,-80
    800049f0:	8526                	mv	a0,s1
    800049f2:	de7fe0ef          	jal	ra,800037d8 <dirlookup>
    800049f6:	8aaa                	mv	s5,a0
    800049f8:	c521                	beqz	a0,80004a40 <create+0x82>
    iunlockput(dp);
    800049fa:	8526                	mv	a0,s1
    800049fc:	b97fe0ef          	jal	ra,80003592 <iunlockput>
    ilock(ip);
    80004a00:	8556                	mv	a0,s5
    80004a02:	98bfe0ef          	jal	ra,8000338c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004a06:	000b059b          	sext.w	a1,s6
    80004a0a:	4789                	li	a5,2
    80004a0c:	02f59563          	bne	a1,a5,80004a36 <create+0x78>
    80004a10:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffde194>
    80004a14:	37f9                	addiw	a5,a5,-2
    80004a16:	17c2                	slli	a5,a5,0x30
    80004a18:	93c1                	srli	a5,a5,0x30
    80004a1a:	4705                	li	a4,1
    80004a1c:	00f76d63          	bltu	a4,a5,80004a36 <create+0x78>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004a20:	8556                	mv	a0,s5
    80004a22:	60a6                	ld	ra,72(sp)
    80004a24:	6406                	ld	s0,64(sp)
    80004a26:	74e2                	ld	s1,56(sp)
    80004a28:	7942                	ld	s2,48(sp)
    80004a2a:	79a2                	ld	s3,40(sp)
    80004a2c:	7a02                	ld	s4,32(sp)
    80004a2e:	6ae2                	ld	s5,24(sp)
    80004a30:	6b42                	ld	s6,16(sp)
    80004a32:	6161                	addi	sp,sp,80
    80004a34:	8082                	ret
    iunlockput(ip);
    80004a36:	8556                	mv	a0,s5
    80004a38:	b5bfe0ef          	jal	ra,80003592 <iunlockput>
    return 0;
    80004a3c:	4a81                	li	s5,0
    80004a3e:	b7cd                	j	80004a20 <create+0x62>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004a40:	85da                	mv	a1,s6
    80004a42:	4088                	lw	a0,0(s1)
    80004a44:	fe0fe0ef          	jal	ra,80003224 <ialloc>
    80004a48:	8a2a                	mv	s4,a0
    80004a4a:	cd1d                	beqz	a0,80004a88 <create+0xca>
  ilock(ip);
    80004a4c:	941fe0ef          	jal	ra,8000338c <ilock>
  ip->major = major;
    80004a50:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004a54:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004a58:	4905                	li	s2,1
    80004a5a:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004a5e:	8552                	mv	a0,s4
    80004a60:	87bfe0ef          	jal	ra,800032da <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004a64:	000b059b          	sext.w	a1,s6
    80004a68:	03258563          	beq	a1,s2,80004a92 <create+0xd4>
  if(dirlink(dp, name, ip->inum) < 0)
    80004a6c:	004a2603          	lw	a2,4(s4)
    80004a70:	fb040593          	addi	a1,s0,-80
    80004a74:	8526                	mv	a0,s1
    80004a76:	f2ffe0ef          	jal	ra,800039a4 <dirlink>
    80004a7a:	06054363          	bltz	a0,80004ae0 <create+0x122>
  iunlockput(dp);
    80004a7e:	8526                	mv	a0,s1
    80004a80:	b13fe0ef          	jal	ra,80003592 <iunlockput>
  return ip;
    80004a84:	8ad2                	mv	s5,s4
    80004a86:	bf69                	j	80004a20 <create+0x62>
    iunlockput(dp);
    80004a88:	8526                	mv	a0,s1
    80004a8a:	b09fe0ef          	jal	ra,80003592 <iunlockput>
    return 0;
    80004a8e:	8ad2                	mv	s5,s4
    80004a90:	bf41                	j	80004a20 <create+0x62>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004a92:	004a2603          	lw	a2,4(s4)
    80004a96:	00003597          	auipc	a1,0x3
    80004a9a:	df258593          	addi	a1,a1,-526 # 80007888 <syscalls+0x2f0>
    80004a9e:	8552                	mv	a0,s4
    80004aa0:	f05fe0ef          	jal	ra,800039a4 <dirlink>
    80004aa4:	02054e63          	bltz	a0,80004ae0 <create+0x122>
    80004aa8:	40d0                	lw	a2,4(s1)
    80004aaa:	00003597          	auipc	a1,0x3
    80004aae:	de658593          	addi	a1,a1,-538 # 80007890 <syscalls+0x2f8>
    80004ab2:	8552                	mv	a0,s4
    80004ab4:	ef1fe0ef          	jal	ra,800039a4 <dirlink>
    80004ab8:	02054463          	bltz	a0,80004ae0 <create+0x122>
  if(dirlink(dp, name, ip->inum) < 0)
    80004abc:	004a2603          	lw	a2,4(s4)
    80004ac0:	fb040593          	addi	a1,s0,-80
    80004ac4:	8526                	mv	a0,s1
    80004ac6:	edffe0ef          	jal	ra,800039a4 <dirlink>
    80004aca:	00054b63          	bltz	a0,80004ae0 <create+0x122>
    dp->nlink++;  // for ".."
    80004ace:	04a4d783          	lhu	a5,74(s1)
    80004ad2:	2785                	addiw	a5,a5,1
    80004ad4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ad8:	8526                	mv	a0,s1
    80004ada:	801fe0ef          	jal	ra,800032da <iupdate>
    80004ade:	b745                	j	80004a7e <create+0xc0>
  ip->nlink = 0;
    80004ae0:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004ae4:	8552                	mv	a0,s4
    80004ae6:	ff4fe0ef          	jal	ra,800032da <iupdate>
  iunlockput(ip);
    80004aea:	8552                	mv	a0,s4
    80004aec:	aa7fe0ef          	jal	ra,80003592 <iunlockput>
  iunlockput(dp);
    80004af0:	8526                	mv	a0,s1
    80004af2:	aa1fe0ef          	jal	ra,80003592 <iunlockput>
  return 0;
    80004af6:	b72d                	j	80004a20 <create+0x62>
    return 0;
    80004af8:	8aaa                	mv	s5,a0
    80004afa:	b71d                	j	80004a20 <create+0x62>

0000000080004afc <sys_dup>:
{
    80004afc:	7179                	addi	sp,sp,-48
    80004afe:	f406                	sd	ra,40(sp)
    80004b00:	f022                	sd	s0,32(sp)
    80004b02:	ec26                	sd	s1,24(sp)
    80004b04:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004b06:	fd840613          	addi	a2,s0,-40
    80004b0a:	4581                	li	a1,0
    80004b0c:	4501                	li	a0,0
    80004b0e:	e1bff0ef          	jal	ra,80004928 <argfd>
    return -1;
    80004b12:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004b14:	00054f63          	bltz	a0,80004b32 <sys_dup+0x36>
  if((fd=fdalloc(f)) < 0)
    80004b18:	fd843503          	ld	a0,-40(s0)
    80004b1c:	e65ff0ef          	jal	ra,80004980 <fdalloc>
    80004b20:	84aa                	mv	s1,a0
    return -1;
    80004b22:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004b24:	00054763          	bltz	a0,80004b32 <sys_dup+0x36>
  filedup(f);
    80004b28:	fd843503          	ld	a0,-40(s0)
    80004b2c:	cc0ff0ef          	jal	ra,80003fec <filedup>
  return fd;
    80004b30:	87a6                	mv	a5,s1
}
    80004b32:	853e                	mv	a0,a5
    80004b34:	70a2                	ld	ra,40(sp)
    80004b36:	7402                	ld	s0,32(sp)
    80004b38:	64e2                	ld	s1,24(sp)
    80004b3a:	6145                	addi	sp,sp,48
    80004b3c:	8082                	ret

0000000080004b3e <sys_read>:
{
    80004b3e:	7179                	addi	sp,sp,-48
    80004b40:	f406                	sd	ra,40(sp)
    80004b42:	f022                	sd	s0,32(sp)
    80004b44:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004b46:	fd840593          	addi	a1,s0,-40
    80004b4a:	4505                	li	a0,1
    80004b4c:	d7ffd0ef          	jal	ra,800028ca <argaddr>
  argint(2, &n);
    80004b50:	fe440593          	addi	a1,s0,-28
    80004b54:	4509                	li	a0,2
    80004b56:	d59fd0ef          	jal	ra,800028ae <argint>
  if(argfd(0, 0, &f) < 0)
    80004b5a:	fe840613          	addi	a2,s0,-24
    80004b5e:	4581                	li	a1,0
    80004b60:	4501                	li	a0,0
    80004b62:	dc7ff0ef          	jal	ra,80004928 <argfd>
    80004b66:	87aa                	mv	a5,a0
    return -1;
    80004b68:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b6a:	0007ca63          	bltz	a5,80004b7e <sys_read+0x40>
  return fileread(f, p, n);
    80004b6e:	fe442603          	lw	a2,-28(s0)
    80004b72:	fd843583          	ld	a1,-40(s0)
    80004b76:	fe843503          	ld	a0,-24(s0)
    80004b7a:	dbeff0ef          	jal	ra,80004138 <fileread>
}
    80004b7e:	70a2                	ld	ra,40(sp)
    80004b80:	7402                	ld	s0,32(sp)
    80004b82:	6145                	addi	sp,sp,48
    80004b84:	8082                	ret

0000000080004b86 <sys_write>:
{
    80004b86:	7179                	addi	sp,sp,-48
    80004b88:	f406                	sd	ra,40(sp)
    80004b8a:	f022                	sd	s0,32(sp)
    80004b8c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004b8e:	fd840593          	addi	a1,s0,-40
    80004b92:	4505                	li	a0,1
    80004b94:	d37fd0ef          	jal	ra,800028ca <argaddr>
  argint(2, &n);
    80004b98:	fe440593          	addi	a1,s0,-28
    80004b9c:	4509                	li	a0,2
    80004b9e:	d11fd0ef          	jal	ra,800028ae <argint>
  if(argfd(0, 0, &f) < 0)
    80004ba2:	fe840613          	addi	a2,s0,-24
    80004ba6:	4581                	li	a1,0
    80004ba8:	4501                	li	a0,0
    80004baa:	d7fff0ef          	jal	ra,80004928 <argfd>
    80004bae:	87aa                	mv	a5,a0
    return -1;
    80004bb0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004bb2:	0007ca63          	bltz	a5,80004bc6 <sys_write+0x40>
  return filewrite(f, p, n);
    80004bb6:	fe442603          	lw	a2,-28(s0)
    80004bba:	fd843583          	ld	a1,-40(s0)
    80004bbe:	fe843503          	ld	a0,-24(s0)
    80004bc2:	e24ff0ef          	jal	ra,800041e6 <filewrite>
}
    80004bc6:	70a2                	ld	ra,40(sp)
    80004bc8:	7402                	ld	s0,32(sp)
    80004bca:	6145                	addi	sp,sp,48
    80004bcc:	8082                	ret

0000000080004bce <sys_close>:
{
    80004bce:	1101                	addi	sp,sp,-32
    80004bd0:	ec06                	sd	ra,24(sp)
    80004bd2:	e822                	sd	s0,16(sp)
    80004bd4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004bd6:	fe040613          	addi	a2,s0,-32
    80004bda:	fec40593          	addi	a1,s0,-20
    80004bde:	4501                	li	a0,0
    80004be0:	d49ff0ef          	jal	ra,80004928 <argfd>
    return -1;
    80004be4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004be6:	02054063          	bltz	a0,80004c06 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004bea:	d5bfc0ef          	jal	ra,80001944 <myproc>
    80004bee:	fec42783          	lw	a5,-20(s0)
    80004bf2:	07e9                	addi	a5,a5,26
    80004bf4:	078e                	slli	a5,a5,0x3
    80004bf6:	97aa                	add	a5,a5,a0
    80004bf8:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004bfc:	fe043503          	ld	a0,-32(s0)
    80004c00:	c32ff0ef          	jal	ra,80004032 <fileclose>
  return 0;
    80004c04:	4781                	li	a5,0
}
    80004c06:	853e                	mv	a0,a5
    80004c08:	60e2                	ld	ra,24(sp)
    80004c0a:	6442                	ld	s0,16(sp)
    80004c0c:	6105                	addi	sp,sp,32
    80004c0e:	8082                	ret

0000000080004c10 <sys_fstat>:
{
    80004c10:	1101                	addi	sp,sp,-32
    80004c12:	ec06                	sd	ra,24(sp)
    80004c14:	e822                	sd	s0,16(sp)
    80004c16:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004c18:	fe040593          	addi	a1,s0,-32
    80004c1c:	4505                	li	a0,1
    80004c1e:	cadfd0ef          	jal	ra,800028ca <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004c22:	fe840613          	addi	a2,s0,-24
    80004c26:	4581                	li	a1,0
    80004c28:	4501                	li	a0,0
    80004c2a:	cffff0ef          	jal	ra,80004928 <argfd>
    80004c2e:	87aa                	mv	a5,a0
    return -1;
    80004c30:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c32:	0007c863          	bltz	a5,80004c42 <sys_fstat+0x32>
  return filestat(f, st);
    80004c36:	fe043583          	ld	a1,-32(s0)
    80004c3a:	fe843503          	ld	a0,-24(s0)
    80004c3e:	c9cff0ef          	jal	ra,800040da <filestat>
}
    80004c42:	60e2                	ld	ra,24(sp)
    80004c44:	6442                	ld	s0,16(sp)
    80004c46:	6105                	addi	sp,sp,32
    80004c48:	8082                	ret

0000000080004c4a <sys_link>:
{
    80004c4a:	7169                	addi	sp,sp,-304
    80004c4c:	f606                	sd	ra,296(sp)
    80004c4e:	f222                	sd	s0,288(sp)
    80004c50:	ee26                	sd	s1,280(sp)
    80004c52:	ea4a                	sd	s2,272(sp)
    80004c54:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004c56:	08000613          	li	a2,128
    80004c5a:	ed040593          	addi	a1,s0,-304
    80004c5e:	4501                	li	a0,0
    80004c60:	c87fd0ef          	jal	ra,800028e6 <argstr>
    return -1;
    80004c64:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004c66:	0c054663          	bltz	a0,80004d32 <sys_link+0xe8>
    80004c6a:	08000613          	li	a2,128
    80004c6e:	f5040593          	addi	a1,s0,-176
    80004c72:	4505                	li	a0,1
    80004c74:	c73fd0ef          	jal	ra,800028e6 <argstr>
    return -1;
    80004c78:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004c7a:	0a054c63          	bltz	a0,80004d32 <sys_link+0xe8>
  begin_op();
    80004c7e:	f99fe0ef          	jal	ra,80003c16 <begin_op>
  if((ip = namei(old)) == 0){
    80004c82:	ed040513          	addi	a0,s0,-304
    80004c86:	db9fe0ef          	jal	ra,80003a3e <namei>
    80004c8a:	84aa                	mv	s1,a0
    80004c8c:	c525                	beqz	a0,80004cf4 <sys_link+0xaa>
  ilock(ip);
    80004c8e:	efefe0ef          	jal	ra,8000338c <ilock>
  if(ip->type == T_DIR){
    80004c92:	04449703          	lh	a4,68(s1)
    80004c96:	4785                	li	a5,1
    80004c98:	06f70263          	beq	a4,a5,80004cfc <sys_link+0xb2>
  ip->nlink++;
    80004c9c:	04a4d783          	lhu	a5,74(s1)
    80004ca0:	2785                	addiw	a5,a5,1
    80004ca2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ca6:	8526                	mv	a0,s1
    80004ca8:	e32fe0ef          	jal	ra,800032da <iupdate>
  iunlock(ip);
    80004cac:	8526                	mv	a0,s1
    80004cae:	f88fe0ef          	jal	ra,80003436 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004cb2:	fd040593          	addi	a1,s0,-48
    80004cb6:	f5040513          	addi	a0,s0,-176
    80004cba:	d9ffe0ef          	jal	ra,80003a58 <nameiparent>
    80004cbe:	892a                	mv	s2,a0
    80004cc0:	c921                	beqz	a0,80004d10 <sys_link+0xc6>
  ilock(dp);
    80004cc2:	ecafe0ef          	jal	ra,8000338c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004cc6:	00092703          	lw	a4,0(s2)
    80004cca:	409c                	lw	a5,0(s1)
    80004ccc:	02f71f63          	bne	a4,a5,80004d0a <sys_link+0xc0>
    80004cd0:	40d0                	lw	a2,4(s1)
    80004cd2:	fd040593          	addi	a1,s0,-48
    80004cd6:	854a                	mv	a0,s2
    80004cd8:	ccdfe0ef          	jal	ra,800039a4 <dirlink>
    80004cdc:	02054763          	bltz	a0,80004d0a <sys_link+0xc0>
  iunlockput(dp);
    80004ce0:	854a                	mv	a0,s2
    80004ce2:	8b1fe0ef          	jal	ra,80003592 <iunlockput>
  iput(ip);
    80004ce6:	8526                	mv	a0,s1
    80004ce8:	823fe0ef          	jal	ra,8000350a <iput>
  end_op();
    80004cec:	f9bfe0ef          	jal	ra,80003c86 <end_op>
  return 0;
    80004cf0:	4781                	li	a5,0
    80004cf2:	a081                	j	80004d32 <sys_link+0xe8>
    end_op();
    80004cf4:	f93fe0ef          	jal	ra,80003c86 <end_op>
    return -1;
    80004cf8:	57fd                	li	a5,-1
    80004cfa:	a825                	j	80004d32 <sys_link+0xe8>
    iunlockput(ip);
    80004cfc:	8526                	mv	a0,s1
    80004cfe:	895fe0ef          	jal	ra,80003592 <iunlockput>
    end_op();
    80004d02:	f85fe0ef          	jal	ra,80003c86 <end_op>
    return -1;
    80004d06:	57fd                	li	a5,-1
    80004d08:	a02d                	j	80004d32 <sys_link+0xe8>
    iunlockput(dp);
    80004d0a:	854a                	mv	a0,s2
    80004d0c:	887fe0ef          	jal	ra,80003592 <iunlockput>
  ilock(ip);
    80004d10:	8526                	mv	a0,s1
    80004d12:	e7afe0ef          	jal	ra,8000338c <ilock>
  ip->nlink--;
    80004d16:	04a4d783          	lhu	a5,74(s1)
    80004d1a:	37fd                	addiw	a5,a5,-1
    80004d1c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004d20:	8526                	mv	a0,s1
    80004d22:	db8fe0ef          	jal	ra,800032da <iupdate>
  iunlockput(ip);
    80004d26:	8526                	mv	a0,s1
    80004d28:	86bfe0ef          	jal	ra,80003592 <iunlockput>
  end_op();
    80004d2c:	f5bfe0ef          	jal	ra,80003c86 <end_op>
  return -1;
    80004d30:	57fd                	li	a5,-1
}
    80004d32:	853e                	mv	a0,a5
    80004d34:	70b2                	ld	ra,296(sp)
    80004d36:	7412                	ld	s0,288(sp)
    80004d38:	64f2                	ld	s1,280(sp)
    80004d3a:	6952                	ld	s2,272(sp)
    80004d3c:	6155                	addi	sp,sp,304
    80004d3e:	8082                	ret

0000000080004d40 <sys_unlink>:
{
    80004d40:	7151                	addi	sp,sp,-240
    80004d42:	f586                	sd	ra,232(sp)
    80004d44:	f1a2                	sd	s0,224(sp)
    80004d46:	eda6                	sd	s1,216(sp)
    80004d48:	e9ca                	sd	s2,208(sp)
    80004d4a:	e5ce                	sd	s3,200(sp)
    80004d4c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004d4e:	08000613          	li	a2,128
    80004d52:	f3040593          	addi	a1,s0,-208
    80004d56:	4501                	li	a0,0
    80004d58:	b8ffd0ef          	jal	ra,800028e6 <argstr>
    80004d5c:	12054b63          	bltz	a0,80004e92 <sys_unlink+0x152>
  begin_op();
    80004d60:	eb7fe0ef          	jal	ra,80003c16 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004d64:	fb040593          	addi	a1,s0,-80
    80004d68:	f3040513          	addi	a0,s0,-208
    80004d6c:	cedfe0ef          	jal	ra,80003a58 <nameiparent>
    80004d70:	84aa                	mv	s1,a0
    80004d72:	c54d                	beqz	a0,80004e1c <sys_unlink+0xdc>
  ilock(dp);
    80004d74:	e18fe0ef          	jal	ra,8000338c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004d78:	00003597          	auipc	a1,0x3
    80004d7c:	b1058593          	addi	a1,a1,-1264 # 80007888 <syscalls+0x2f0>
    80004d80:	fb040513          	addi	a0,s0,-80
    80004d84:	a3ffe0ef          	jal	ra,800037c2 <namecmp>
    80004d88:	10050a63          	beqz	a0,80004e9c <sys_unlink+0x15c>
    80004d8c:	00003597          	auipc	a1,0x3
    80004d90:	b0458593          	addi	a1,a1,-1276 # 80007890 <syscalls+0x2f8>
    80004d94:	fb040513          	addi	a0,s0,-80
    80004d98:	a2bfe0ef          	jal	ra,800037c2 <namecmp>
    80004d9c:	10050063          	beqz	a0,80004e9c <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004da0:	f2c40613          	addi	a2,s0,-212
    80004da4:	fb040593          	addi	a1,s0,-80
    80004da8:	8526                	mv	a0,s1
    80004daa:	a2ffe0ef          	jal	ra,800037d8 <dirlookup>
    80004dae:	892a                	mv	s2,a0
    80004db0:	0e050663          	beqz	a0,80004e9c <sys_unlink+0x15c>
  ilock(ip);
    80004db4:	dd8fe0ef          	jal	ra,8000338c <ilock>
  if(ip->nlink < 1)
    80004db8:	04a91783          	lh	a5,74(s2)
    80004dbc:	06f05463          	blez	a5,80004e24 <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004dc0:	04491703          	lh	a4,68(s2)
    80004dc4:	4785                	li	a5,1
    80004dc6:	06f70563          	beq	a4,a5,80004e30 <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    80004dca:	4641                	li	a2,16
    80004dcc:	4581                	li	a1,0
    80004dce:	fc040513          	addi	a0,s0,-64
    80004dd2:	ea9fb0ef          	jal	ra,80000c7a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004dd6:	4741                	li	a4,16
    80004dd8:	f2c42683          	lw	a3,-212(s0)
    80004ddc:	fc040613          	addi	a2,s0,-64
    80004de0:	4581                	li	a1,0
    80004de2:	8526                	mv	a0,s1
    80004de4:	8ddfe0ef          	jal	ra,800036c0 <writei>
    80004de8:	47c1                	li	a5,16
    80004dea:	08f51563          	bne	a0,a5,80004e74 <sys_unlink+0x134>
  if(ip->type == T_DIR){
    80004dee:	04491703          	lh	a4,68(s2)
    80004df2:	4785                	li	a5,1
    80004df4:	08f70663          	beq	a4,a5,80004e80 <sys_unlink+0x140>
  iunlockput(dp);
    80004df8:	8526                	mv	a0,s1
    80004dfa:	f98fe0ef          	jal	ra,80003592 <iunlockput>
  ip->nlink--;
    80004dfe:	04a95783          	lhu	a5,74(s2)
    80004e02:	37fd                	addiw	a5,a5,-1
    80004e04:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004e08:	854a                	mv	a0,s2
    80004e0a:	cd0fe0ef          	jal	ra,800032da <iupdate>
  iunlockput(ip);
    80004e0e:	854a                	mv	a0,s2
    80004e10:	f82fe0ef          	jal	ra,80003592 <iunlockput>
  end_op();
    80004e14:	e73fe0ef          	jal	ra,80003c86 <end_op>
  return 0;
    80004e18:	4501                	li	a0,0
    80004e1a:	a079                	j	80004ea8 <sys_unlink+0x168>
    end_op();
    80004e1c:	e6bfe0ef          	jal	ra,80003c86 <end_op>
    return -1;
    80004e20:	557d                	li	a0,-1
    80004e22:	a059                	j	80004ea8 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004e24:	00003517          	auipc	a0,0x3
    80004e28:	a7450513          	addi	a0,a0,-1420 # 80007898 <syscalls+0x300>
    80004e2c:	90bfb0ef          	jal	ra,80000736 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e30:	04c92703          	lw	a4,76(s2)
    80004e34:	02000793          	li	a5,32
    80004e38:	f8e7f9e3          	bgeu	a5,a4,80004dca <sys_unlink+0x8a>
    80004e3c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004e40:	4741                	li	a4,16
    80004e42:	86ce                	mv	a3,s3
    80004e44:	f1840613          	addi	a2,s0,-232
    80004e48:	4581                	li	a1,0
    80004e4a:	854a                	mv	a0,s2
    80004e4c:	f90fe0ef          	jal	ra,800035dc <readi>
    80004e50:	47c1                	li	a5,16
    80004e52:	00f51b63          	bne	a0,a5,80004e68 <sys_unlink+0x128>
    if(de.inum != 0)
    80004e56:	f1845783          	lhu	a5,-232(s0)
    80004e5a:	ef95                	bnez	a5,80004e96 <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e5c:	29c1                	addiw	s3,s3,16
    80004e5e:	04c92783          	lw	a5,76(s2)
    80004e62:	fcf9efe3          	bltu	s3,a5,80004e40 <sys_unlink+0x100>
    80004e66:	b795                	j	80004dca <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004e68:	00003517          	auipc	a0,0x3
    80004e6c:	a4850513          	addi	a0,a0,-1464 # 800078b0 <syscalls+0x318>
    80004e70:	8c7fb0ef          	jal	ra,80000736 <panic>
    panic("unlink: writei");
    80004e74:	00003517          	auipc	a0,0x3
    80004e78:	a5450513          	addi	a0,a0,-1452 # 800078c8 <syscalls+0x330>
    80004e7c:	8bbfb0ef          	jal	ra,80000736 <panic>
    dp->nlink--;
    80004e80:	04a4d783          	lhu	a5,74(s1)
    80004e84:	37fd                	addiw	a5,a5,-1
    80004e86:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004e8a:	8526                	mv	a0,s1
    80004e8c:	c4efe0ef          	jal	ra,800032da <iupdate>
    80004e90:	b7a5                	j	80004df8 <sys_unlink+0xb8>
    return -1;
    80004e92:	557d                	li	a0,-1
    80004e94:	a811                	j	80004ea8 <sys_unlink+0x168>
    iunlockput(ip);
    80004e96:	854a                	mv	a0,s2
    80004e98:	efafe0ef          	jal	ra,80003592 <iunlockput>
  iunlockput(dp);
    80004e9c:	8526                	mv	a0,s1
    80004e9e:	ef4fe0ef          	jal	ra,80003592 <iunlockput>
  end_op();
    80004ea2:	de5fe0ef          	jal	ra,80003c86 <end_op>
  return -1;
    80004ea6:	557d                	li	a0,-1
}
    80004ea8:	70ae                	ld	ra,232(sp)
    80004eaa:	740e                	ld	s0,224(sp)
    80004eac:	64ee                	ld	s1,216(sp)
    80004eae:	694e                	ld	s2,208(sp)
    80004eb0:	69ae                	ld	s3,200(sp)
    80004eb2:	616d                	addi	sp,sp,240
    80004eb4:	8082                	ret

0000000080004eb6 <sys_open>:

uint64
sys_open(void)
{
    80004eb6:	7131                	addi	sp,sp,-192
    80004eb8:	fd06                	sd	ra,184(sp)
    80004eba:	f922                	sd	s0,176(sp)
    80004ebc:	f526                	sd	s1,168(sp)
    80004ebe:	f14a                	sd	s2,160(sp)
    80004ec0:	ed4e                	sd	s3,152(sp)
    80004ec2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004ec4:	f4c40593          	addi	a1,s0,-180
    80004ec8:	4505                	li	a0,1
    80004eca:	9e5fd0ef          	jal	ra,800028ae <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ece:	08000613          	li	a2,128
    80004ed2:	f5040593          	addi	a1,s0,-176
    80004ed6:	4501                	li	a0,0
    80004ed8:	a0ffd0ef          	jal	ra,800028e6 <argstr>
    80004edc:	87aa                	mv	a5,a0
    return -1;
    80004ede:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ee0:	0807cd63          	bltz	a5,80004f7a <sys_open+0xc4>

  begin_op();
    80004ee4:	d33fe0ef          	jal	ra,80003c16 <begin_op>

  if(omode & O_CREATE){
    80004ee8:	f4c42783          	lw	a5,-180(s0)
    80004eec:	2007f793          	andi	a5,a5,512
    80004ef0:	c3c5                	beqz	a5,80004f90 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004ef2:	4681                	li	a3,0
    80004ef4:	4601                	li	a2,0
    80004ef6:	4589                	li	a1,2
    80004ef8:	f5040513          	addi	a0,s0,-176
    80004efc:	ac3ff0ef          	jal	ra,800049be <create>
    80004f00:	84aa                	mv	s1,a0
    if(ip == 0){
    80004f02:	c159                	beqz	a0,80004f88 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004f04:	04449703          	lh	a4,68(s1)
    80004f08:	478d                	li	a5,3
    80004f0a:	00f71763          	bne	a4,a5,80004f18 <sys_open+0x62>
    80004f0e:	0464d703          	lhu	a4,70(s1)
    80004f12:	47a5                	li	a5,9
    80004f14:	0ae7e963          	bltu	a5,a4,80004fc6 <sys_open+0x110>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004f18:	876ff0ef          	jal	ra,80003f8e <filealloc>
    80004f1c:	89aa                	mv	s3,a0
    80004f1e:	0c050963          	beqz	a0,80004ff0 <sys_open+0x13a>
    80004f22:	a5fff0ef          	jal	ra,80004980 <fdalloc>
    80004f26:	892a                	mv	s2,a0
    80004f28:	0c054163          	bltz	a0,80004fea <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004f2c:	04449703          	lh	a4,68(s1)
    80004f30:	478d                	li	a5,3
    80004f32:	0af70163          	beq	a4,a5,80004fd4 <sys_open+0x11e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004f36:	4789                	li	a5,2
    80004f38:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004f3c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004f40:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004f44:	f4c42783          	lw	a5,-180(s0)
    80004f48:	0017c713          	xori	a4,a5,1
    80004f4c:	8b05                	andi	a4,a4,1
    80004f4e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f52:	0037f713          	andi	a4,a5,3
    80004f56:	00e03733          	snez	a4,a4
    80004f5a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004f5e:	4007f793          	andi	a5,a5,1024
    80004f62:	c791                	beqz	a5,80004f6e <sys_open+0xb8>
    80004f64:	04449703          	lh	a4,68(s1)
    80004f68:	4789                	li	a5,2
    80004f6a:	06f70c63          	beq	a4,a5,80004fe2 <sys_open+0x12c>
    itrunc(ip);
  }

  iunlock(ip);
    80004f6e:	8526                	mv	a0,s1
    80004f70:	cc6fe0ef          	jal	ra,80003436 <iunlock>
  end_op();
    80004f74:	d13fe0ef          	jal	ra,80003c86 <end_op>

  return fd;
    80004f78:	854a                	mv	a0,s2
}
    80004f7a:	70ea                	ld	ra,184(sp)
    80004f7c:	744a                	ld	s0,176(sp)
    80004f7e:	74aa                	ld	s1,168(sp)
    80004f80:	790a                	ld	s2,160(sp)
    80004f82:	69ea                	ld	s3,152(sp)
    80004f84:	6129                	addi	sp,sp,192
    80004f86:	8082                	ret
      end_op();
    80004f88:	cfffe0ef          	jal	ra,80003c86 <end_op>
      return -1;
    80004f8c:	557d                	li	a0,-1
    80004f8e:	b7f5                	j	80004f7a <sys_open+0xc4>
    if((ip = namei(path)) == 0){
    80004f90:	f5040513          	addi	a0,s0,-176
    80004f94:	aabfe0ef          	jal	ra,80003a3e <namei>
    80004f98:	84aa                	mv	s1,a0
    80004f9a:	c115                	beqz	a0,80004fbe <sys_open+0x108>
    ilock(ip);
    80004f9c:	bf0fe0ef          	jal	ra,8000338c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004fa0:	04449703          	lh	a4,68(s1)
    80004fa4:	4785                	li	a5,1
    80004fa6:	f4f71fe3          	bne	a4,a5,80004f04 <sys_open+0x4e>
    80004faa:	f4c42783          	lw	a5,-180(s0)
    80004fae:	d7ad                	beqz	a5,80004f18 <sys_open+0x62>
      iunlockput(ip);
    80004fb0:	8526                	mv	a0,s1
    80004fb2:	de0fe0ef          	jal	ra,80003592 <iunlockput>
      end_op();
    80004fb6:	cd1fe0ef          	jal	ra,80003c86 <end_op>
      return -1;
    80004fba:	557d                	li	a0,-1
    80004fbc:	bf7d                	j	80004f7a <sys_open+0xc4>
      end_op();
    80004fbe:	cc9fe0ef          	jal	ra,80003c86 <end_op>
      return -1;
    80004fc2:	557d                	li	a0,-1
    80004fc4:	bf5d                	j	80004f7a <sys_open+0xc4>
    iunlockput(ip);
    80004fc6:	8526                	mv	a0,s1
    80004fc8:	dcafe0ef          	jal	ra,80003592 <iunlockput>
    end_op();
    80004fcc:	cbbfe0ef          	jal	ra,80003c86 <end_op>
    return -1;
    80004fd0:	557d                	li	a0,-1
    80004fd2:	b765                	j	80004f7a <sys_open+0xc4>
    f->type = FD_DEVICE;
    80004fd4:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004fd8:	04649783          	lh	a5,70(s1)
    80004fdc:	02f99223          	sh	a5,36(s3)
    80004fe0:	b785                	j	80004f40 <sys_open+0x8a>
    itrunc(ip);
    80004fe2:	8526                	mv	a0,s1
    80004fe4:	c92fe0ef          	jal	ra,80003476 <itrunc>
    80004fe8:	b759                	j	80004f6e <sys_open+0xb8>
      fileclose(f);
    80004fea:	854e                	mv	a0,s3
    80004fec:	846ff0ef          	jal	ra,80004032 <fileclose>
    iunlockput(ip);
    80004ff0:	8526                	mv	a0,s1
    80004ff2:	da0fe0ef          	jal	ra,80003592 <iunlockput>
    end_op();
    80004ff6:	c91fe0ef          	jal	ra,80003c86 <end_op>
    return -1;
    80004ffa:	557d                	li	a0,-1
    80004ffc:	bfbd                	j	80004f7a <sys_open+0xc4>

0000000080004ffe <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ffe:	7175                	addi	sp,sp,-144
    80005000:	e506                	sd	ra,136(sp)
    80005002:	e122                	sd	s0,128(sp)
    80005004:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005006:	c11fe0ef          	jal	ra,80003c16 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000500a:	08000613          	li	a2,128
    8000500e:	f7040593          	addi	a1,s0,-144
    80005012:	4501                	li	a0,0
    80005014:	8d3fd0ef          	jal	ra,800028e6 <argstr>
    80005018:	02054363          	bltz	a0,8000503e <sys_mkdir+0x40>
    8000501c:	4681                	li	a3,0
    8000501e:	4601                	li	a2,0
    80005020:	4585                	li	a1,1
    80005022:	f7040513          	addi	a0,s0,-144
    80005026:	999ff0ef          	jal	ra,800049be <create>
    8000502a:	c911                	beqz	a0,8000503e <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000502c:	d66fe0ef          	jal	ra,80003592 <iunlockput>
  end_op();
    80005030:	c57fe0ef          	jal	ra,80003c86 <end_op>
  return 0;
    80005034:	4501                	li	a0,0
}
    80005036:	60aa                	ld	ra,136(sp)
    80005038:	640a                	ld	s0,128(sp)
    8000503a:	6149                	addi	sp,sp,144
    8000503c:	8082                	ret
    end_op();
    8000503e:	c49fe0ef          	jal	ra,80003c86 <end_op>
    return -1;
    80005042:	557d                	li	a0,-1
    80005044:	bfcd                	j	80005036 <sys_mkdir+0x38>

0000000080005046 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005046:	7135                	addi	sp,sp,-160
    80005048:	ed06                	sd	ra,152(sp)
    8000504a:	e922                	sd	s0,144(sp)
    8000504c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000504e:	bc9fe0ef          	jal	ra,80003c16 <begin_op>
  argint(1, &major);
    80005052:	f6c40593          	addi	a1,s0,-148
    80005056:	4505                	li	a0,1
    80005058:	857fd0ef          	jal	ra,800028ae <argint>
  argint(2, &minor);
    8000505c:	f6840593          	addi	a1,s0,-152
    80005060:	4509                	li	a0,2
    80005062:	84dfd0ef          	jal	ra,800028ae <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005066:	08000613          	li	a2,128
    8000506a:	f7040593          	addi	a1,s0,-144
    8000506e:	4501                	li	a0,0
    80005070:	877fd0ef          	jal	ra,800028e6 <argstr>
    80005074:	02054563          	bltz	a0,8000509e <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005078:	f6841683          	lh	a3,-152(s0)
    8000507c:	f6c41603          	lh	a2,-148(s0)
    80005080:	458d                	li	a1,3
    80005082:	f7040513          	addi	a0,s0,-144
    80005086:	939ff0ef          	jal	ra,800049be <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000508a:	c911                	beqz	a0,8000509e <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000508c:	d06fe0ef          	jal	ra,80003592 <iunlockput>
  end_op();
    80005090:	bf7fe0ef          	jal	ra,80003c86 <end_op>
  return 0;
    80005094:	4501                	li	a0,0
}
    80005096:	60ea                	ld	ra,152(sp)
    80005098:	644a                	ld	s0,144(sp)
    8000509a:	610d                	addi	sp,sp,160
    8000509c:	8082                	ret
    end_op();
    8000509e:	be9fe0ef          	jal	ra,80003c86 <end_op>
    return -1;
    800050a2:	557d                	li	a0,-1
    800050a4:	bfcd                	j	80005096 <sys_mknod+0x50>

00000000800050a6 <sys_chdir>:

uint64
sys_chdir(void)
{
    800050a6:	7135                	addi	sp,sp,-160
    800050a8:	ed06                	sd	ra,152(sp)
    800050aa:	e922                	sd	s0,144(sp)
    800050ac:	e526                	sd	s1,136(sp)
    800050ae:	e14a                	sd	s2,128(sp)
    800050b0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800050b2:	893fc0ef          	jal	ra,80001944 <myproc>
    800050b6:	892a                	mv	s2,a0
  
  begin_op();
    800050b8:	b5ffe0ef          	jal	ra,80003c16 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800050bc:	08000613          	li	a2,128
    800050c0:	f6040593          	addi	a1,s0,-160
    800050c4:	4501                	li	a0,0
    800050c6:	821fd0ef          	jal	ra,800028e6 <argstr>
    800050ca:	04054163          	bltz	a0,8000510c <sys_chdir+0x66>
    800050ce:	f6040513          	addi	a0,s0,-160
    800050d2:	96dfe0ef          	jal	ra,80003a3e <namei>
    800050d6:	84aa                	mv	s1,a0
    800050d8:	c915                	beqz	a0,8000510c <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800050da:	ab2fe0ef          	jal	ra,8000338c <ilock>
  if(ip->type != T_DIR){
    800050de:	04449703          	lh	a4,68(s1)
    800050e2:	4785                	li	a5,1
    800050e4:	02f71863          	bne	a4,a5,80005114 <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800050e8:	8526                	mv	a0,s1
    800050ea:	b4cfe0ef          	jal	ra,80003436 <iunlock>
  iput(p->cwd);
    800050ee:	15093503          	ld	a0,336(s2)
    800050f2:	c18fe0ef          	jal	ra,8000350a <iput>
  end_op();
    800050f6:	b91fe0ef          	jal	ra,80003c86 <end_op>
  p->cwd = ip;
    800050fa:	14993823          	sd	s1,336(s2)
  return 0;
    800050fe:	4501                	li	a0,0
}
    80005100:	60ea                	ld	ra,152(sp)
    80005102:	644a                	ld	s0,144(sp)
    80005104:	64aa                	ld	s1,136(sp)
    80005106:	690a                	ld	s2,128(sp)
    80005108:	610d                	addi	sp,sp,160
    8000510a:	8082                	ret
    end_op();
    8000510c:	b7bfe0ef          	jal	ra,80003c86 <end_op>
    return -1;
    80005110:	557d                	li	a0,-1
    80005112:	b7fd                	j	80005100 <sys_chdir+0x5a>
    iunlockput(ip);
    80005114:	8526                	mv	a0,s1
    80005116:	c7cfe0ef          	jal	ra,80003592 <iunlockput>
    end_op();
    8000511a:	b6dfe0ef          	jal	ra,80003c86 <end_op>
    return -1;
    8000511e:	557d                	li	a0,-1
    80005120:	b7c5                	j	80005100 <sys_chdir+0x5a>

0000000080005122 <sys_exec>:

uint64
sys_exec(void)
{
    80005122:	7145                	addi	sp,sp,-464
    80005124:	e786                	sd	ra,456(sp)
    80005126:	e3a2                	sd	s0,448(sp)
    80005128:	ff26                	sd	s1,440(sp)
    8000512a:	fb4a                	sd	s2,432(sp)
    8000512c:	f74e                	sd	s3,424(sp)
    8000512e:	f352                	sd	s4,416(sp)
    80005130:	ef56                	sd	s5,408(sp)
    80005132:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005134:	e3840593          	addi	a1,s0,-456
    80005138:	4505                	li	a0,1
    8000513a:	f90fd0ef          	jal	ra,800028ca <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000513e:	08000613          	li	a2,128
    80005142:	f4040593          	addi	a1,s0,-192
    80005146:	4501                	li	a0,0
    80005148:	f9efd0ef          	jal	ra,800028e6 <argstr>
    8000514c:	87aa                	mv	a5,a0
    return -1;
    8000514e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005150:	0a07c463          	bltz	a5,800051f8 <sys_exec+0xd6>
  }
  memset(argv, 0, sizeof(argv));
    80005154:	10000613          	li	a2,256
    80005158:	4581                	li	a1,0
    8000515a:	e4040513          	addi	a0,s0,-448
    8000515e:	b1dfb0ef          	jal	ra,80000c7a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005162:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005166:	89a6                	mv	s3,s1
    80005168:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000516a:	02000a13          	li	s4,32
    8000516e:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005172:	00391793          	slli	a5,s2,0x3
    80005176:	e3040593          	addi	a1,s0,-464
    8000517a:	e3843503          	ld	a0,-456(s0)
    8000517e:	953e                	add	a0,a0,a5
    80005180:	ea4fd0ef          	jal	ra,80002824 <fetchaddr>
    80005184:	02054663          	bltz	a0,800051b0 <sys_exec+0x8e>
      goto bad;
    }
    if(uarg == 0){
    80005188:	e3043783          	ld	a5,-464(s0)
    8000518c:	cf8d                	beqz	a5,800051c6 <sys_exec+0xa4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000518e:	909fb0ef          	jal	ra,80000a96 <kalloc>
    80005192:	85aa                	mv	a1,a0
    80005194:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005198:	cd01                	beqz	a0,800051b0 <sys_exec+0x8e>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000519a:	6605                	lui	a2,0x1
    8000519c:	e3043503          	ld	a0,-464(s0)
    800051a0:	ecefd0ef          	jal	ra,8000286e <fetchstr>
    800051a4:	00054663          	bltz	a0,800051b0 <sys_exec+0x8e>
    if(i >= NELEM(argv)){
    800051a8:	0905                	addi	s2,s2,1
    800051aa:	09a1                	addi	s3,s3,8
    800051ac:	fd4911e3          	bne	s2,s4,8000516e <sys_exec+0x4c>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051b0:	10048913          	addi	s2,s1,256
    800051b4:	6088                	ld	a0,0(s1)
    800051b6:	c121                	beqz	a0,800051f6 <sys_exec+0xd4>
    kfree(argv[i]);
    800051b8:	813fb0ef          	jal	ra,800009ca <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051bc:	04a1                	addi	s1,s1,8
    800051be:	ff249be3          	bne	s1,s2,800051b4 <sys_exec+0x92>
  return -1;
    800051c2:	557d                	li	a0,-1
    800051c4:	a815                	j	800051f8 <sys_exec+0xd6>
      argv[i] = 0;
    800051c6:	0a8e                	slli	s5,s5,0x3
    800051c8:	fc040793          	addi	a5,s0,-64
    800051cc:	9abe                	add	s5,s5,a5
    800051ce:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800051d2:	e4040593          	addi	a1,s0,-448
    800051d6:	f4040513          	addi	a0,s0,-192
    800051da:	bfaff0ef          	jal	ra,800045d4 <exec>
    800051de:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051e0:	10048993          	addi	s3,s1,256
    800051e4:	6088                	ld	a0,0(s1)
    800051e6:	c511                	beqz	a0,800051f2 <sys_exec+0xd0>
    kfree(argv[i]);
    800051e8:	fe2fb0ef          	jal	ra,800009ca <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051ec:	04a1                	addi	s1,s1,8
    800051ee:	ff349be3          	bne	s1,s3,800051e4 <sys_exec+0xc2>
  return ret;
    800051f2:	854a                	mv	a0,s2
    800051f4:	a011                	j	800051f8 <sys_exec+0xd6>
  return -1;
    800051f6:	557d                	li	a0,-1
}
    800051f8:	60be                	ld	ra,456(sp)
    800051fa:	641e                	ld	s0,448(sp)
    800051fc:	74fa                	ld	s1,440(sp)
    800051fe:	795a                	ld	s2,432(sp)
    80005200:	79ba                	ld	s3,424(sp)
    80005202:	7a1a                	ld	s4,416(sp)
    80005204:	6afa                	ld	s5,408(sp)
    80005206:	6179                	addi	sp,sp,464
    80005208:	8082                	ret

000000008000520a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000520a:	7139                	addi	sp,sp,-64
    8000520c:	fc06                	sd	ra,56(sp)
    8000520e:	f822                	sd	s0,48(sp)
    80005210:	f426                	sd	s1,40(sp)
    80005212:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005214:	f30fc0ef          	jal	ra,80001944 <myproc>
    80005218:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000521a:	fd840593          	addi	a1,s0,-40
    8000521e:	4501                	li	a0,0
    80005220:	eaafd0ef          	jal	ra,800028ca <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005224:	fc840593          	addi	a1,s0,-56
    80005228:	fd040513          	addi	a0,s0,-48
    8000522c:	8d2ff0ef          	jal	ra,800042fe <pipealloc>
    return -1;
    80005230:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005232:	0a054463          	bltz	a0,800052da <sys_pipe+0xd0>
  fd0 = -1;
    80005236:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000523a:	fd043503          	ld	a0,-48(s0)
    8000523e:	f42ff0ef          	jal	ra,80004980 <fdalloc>
    80005242:	fca42223          	sw	a0,-60(s0)
    80005246:	08054163          	bltz	a0,800052c8 <sys_pipe+0xbe>
    8000524a:	fc843503          	ld	a0,-56(s0)
    8000524e:	f32ff0ef          	jal	ra,80004980 <fdalloc>
    80005252:	fca42023          	sw	a0,-64(s0)
    80005256:	06054063          	bltz	a0,800052b6 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000525a:	4691                	li	a3,4
    8000525c:	fc440613          	addi	a2,s0,-60
    80005260:	fd843583          	ld	a1,-40(s0)
    80005264:	68a8                	ld	a0,80(s1)
    80005266:	b92fc0ef          	jal	ra,800015f8 <copyout>
    8000526a:	00054e63          	bltz	a0,80005286 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000526e:	4691                	li	a3,4
    80005270:	fc040613          	addi	a2,s0,-64
    80005274:	fd843583          	ld	a1,-40(s0)
    80005278:	0591                	addi	a1,a1,4
    8000527a:	68a8                	ld	a0,80(s1)
    8000527c:	b7cfc0ef          	jal	ra,800015f8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005280:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005282:	04055c63          	bgez	a0,800052da <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005286:	fc442783          	lw	a5,-60(s0)
    8000528a:	07e9                	addi	a5,a5,26
    8000528c:	078e                	slli	a5,a5,0x3
    8000528e:	97a6                	add	a5,a5,s1
    80005290:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005294:	fc042503          	lw	a0,-64(s0)
    80005298:	0569                	addi	a0,a0,26
    8000529a:	050e                	slli	a0,a0,0x3
    8000529c:	94aa                	add	s1,s1,a0
    8000529e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800052a2:	fd043503          	ld	a0,-48(s0)
    800052a6:	d8dfe0ef          	jal	ra,80004032 <fileclose>
    fileclose(wf);
    800052aa:	fc843503          	ld	a0,-56(s0)
    800052ae:	d85fe0ef          	jal	ra,80004032 <fileclose>
    return -1;
    800052b2:	57fd                	li	a5,-1
    800052b4:	a01d                	j	800052da <sys_pipe+0xd0>
    if(fd0 >= 0)
    800052b6:	fc442783          	lw	a5,-60(s0)
    800052ba:	0007c763          	bltz	a5,800052c8 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800052be:	07e9                	addi	a5,a5,26
    800052c0:	078e                	slli	a5,a5,0x3
    800052c2:	94be                	add	s1,s1,a5
    800052c4:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800052c8:	fd043503          	ld	a0,-48(s0)
    800052cc:	d67fe0ef          	jal	ra,80004032 <fileclose>
    fileclose(wf);
    800052d0:	fc843503          	ld	a0,-56(s0)
    800052d4:	d5ffe0ef          	jal	ra,80004032 <fileclose>
    return -1;
    800052d8:	57fd                	li	a5,-1
}
    800052da:	853e                	mv	a0,a5
    800052dc:	70e2                	ld	ra,56(sp)
    800052de:	7442                	ld	s0,48(sp)
    800052e0:	74a2                	ld	s1,40(sp)
    800052e2:	6121                	addi	sp,sp,64
    800052e4:	8082                	ret
	...

00000000800052f0 <kernelvec>:
    800052f0:	7111                	addi	sp,sp,-256
    800052f2:	e006                	sd	ra,0(sp)
    800052f4:	e40a                	sd	sp,8(sp)
    800052f6:	e80e                	sd	gp,16(sp)
    800052f8:	ec12                	sd	tp,24(sp)
    800052fa:	f016                	sd	t0,32(sp)
    800052fc:	f41a                	sd	t1,40(sp)
    800052fe:	f81e                	sd	t2,48(sp)
    80005300:	e4aa                	sd	a0,72(sp)
    80005302:	e8ae                	sd	a1,80(sp)
    80005304:	ecb2                	sd	a2,88(sp)
    80005306:	f0b6                	sd	a3,96(sp)
    80005308:	f4ba                	sd	a4,104(sp)
    8000530a:	f8be                	sd	a5,112(sp)
    8000530c:	fcc2                	sd	a6,120(sp)
    8000530e:	e146                	sd	a7,128(sp)
    80005310:	edf2                	sd	t3,216(sp)
    80005312:	f1f6                	sd	t4,224(sp)
    80005314:	f5fa                	sd	t5,232(sp)
    80005316:	f9fe                	sd	t6,240(sp)
    80005318:	c1cfd0ef          	jal	ra,80002734 <kerneltrap>
    8000531c:	6082                	ld	ra,0(sp)
    8000531e:	6122                	ld	sp,8(sp)
    80005320:	61c2                	ld	gp,16(sp)
    80005322:	7282                	ld	t0,32(sp)
    80005324:	7322                	ld	t1,40(sp)
    80005326:	73c2                	ld	t2,48(sp)
    80005328:	6526                	ld	a0,72(sp)
    8000532a:	65c6                	ld	a1,80(sp)
    8000532c:	6666                	ld	a2,88(sp)
    8000532e:	7686                	ld	a3,96(sp)
    80005330:	7726                	ld	a4,104(sp)
    80005332:	77c6                	ld	a5,112(sp)
    80005334:	7866                	ld	a6,120(sp)
    80005336:	688a                	ld	a7,128(sp)
    80005338:	6e6e                	ld	t3,216(sp)
    8000533a:	7e8e                	ld	t4,224(sp)
    8000533c:	7f2e                	ld	t5,232(sp)
    8000533e:	7fce                	ld	t6,240(sp)
    80005340:	6111                	addi	sp,sp,256
    80005342:	10200073          	sret
	...

000000008000534e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000534e:	1141                	addi	sp,sp,-16
    80005350:	e422                	sd	s0,8(sp)
    80005352:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005354:	0c0007b7          	lui	a5,0xc000
    80005358:	4705                	li	a4,1
    8000535a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000535c:	c3d8                	sw	a4,4(a5)
}
    8000535e:	6422                	ld	s0,8(sp)
    80005360:	0141                	addi	sp,sp,16
    80005362:	8082                	ret

0000000080005364 <plicinithart>:

void
plicinithart(void)
{
    80005364:	1141                	addi	sp,sp,-16
    80005366:	e406                	sd	ra,8(sp)
    80005368:	e022                	sd	s0,0(sp)
    8000536a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000536c:	dacfc0ef          	jal	ra,80001918 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005370:	0085171b          	slliw	a4,a0,0x8
    80005374:	0c0027b7          	lui	a5,0xc002
    80005378:	97ba                	add	a5,a5,a4
    8000537a:	40200713          	li	a4,1026
    8000537e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005382:	00d5151b          	slliw	a0,a0,0xd
    80005386:	0c2017b7          	lui	a5,0xc201
    8000538a:	953e                	add	a0,a0,a5
    8000538c:	00052023          	sw	zero,0(a0)
}
    80005390:	60a2                	ld	ra,8(sp)
    80005392:	6402                	ld	s0,0(sp)
    80005394:	0141                	addi	sp,sp,16
    80005396:	8082                	ret

0000000080005398 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005398:	1141                	addi	sp,sp,-16
    8000539a:	e406                	sd	ra,8(sp)
    8000539c:	e022                	sd	s0,0(sp)
    8000539e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053a0:	d78fc0ef          	jal	ra,80001918 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053a4:	00d5179b          	slliw	a5,a0,0xd
    800053a8:	0c201537          	lui	a0,0xc201
    800053ac:	953e                	add	a0,a0,a5
  return irq;
}
    800053ae:	4148                	lw	a0,4(a0)
    800053b0:	60a2                	ld	ra,8(sp)
    800053b2:	6402                	ld	s0,0(sp)
    800053b4:	0141                	addi	sp,sp,16
    800053b6:	8082                	ret

00000000800053b8 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053b8:	1101                	addi	sp,sp,-32
    800053ba:	ec06                	sd	ra,24(sp)
    800053bc:	e822                	sd	s0,16(sp)
    800053be:	e426                	sd	s1,8(sp)
    800053c0:	1000                	addi	s0,sp,32
    800053c2:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053c4:	d54fc0ef          	jal	ra,80001918 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053c8:	00d5151b          	slliw	a0,a0,0xd
    800053cc:	0c2017b7          	lui	a5,0xc201
    800053d0:	97aa                	add	a5,a5,a0
    800053d2:	c3c4                	sw	s1,4(a5)
}
    800053d4:	60e2                	ld	ra,24(sp)
    800053d6:	6442                	ld	s0,16(sp)
    800053d8:	64a2                	ld	s1,8(sp)
    800053da:	6105                	addi	sp,sp,32
    800053dc:	8082                	ret

00000000800053de <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053de:	1141                	addi	sp,sp,-16
    800053e0:	e406                	sd	ra,8(sp)
    800053e2:	e022                	sd	s0,0(sp)
    800053e4:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053e6:	479d                	li	a5,7
    800053e8:	04a7ca63          	blt	a5,a0,8000543c <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800053ec:	0001c797          	auipc	a5,0x1c
    800053f0:	98478793          	addi	a5,a5,-1660 # 80020d70 <disk>
    800053f4:	97aa                	add	a5,a5,a0
    800053f6:	0187c783          	lbu	a5,24(a5)
    800053fa:	e7b9                	bnez	a5,80005448 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053fc:	00451613          	slli	a2,a0,0x4
    80005400:	0001c797          	auipc	a5,0x1c
    80005404:	97078793          	addi	a5,a5,-1680 # 80020d70 <disk>
    80005408:	6394                	ld	a3,0(a5)
    8000540a:	96b2                	add	a3,a3,a2
    8000540c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005410:	6398                	ld	a4,0(a5)
    80005412:	9732                	add	a4,a4,a2
    80005414:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005418:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000541c:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005420:	953e                	add	a0,a0,a5
    80005422:	4785                	li	a5,1
    80005424:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005428:	0001c517          	auipc	a0,0x1c
    8000542c:	96050513          	addi	a0,a0,-1696 # 80020d88 <disk+0x18>
    80005430:	b2dfc0ef          	jal	ra,80001f5c <wakeup>
}
    80005434:	60a2                	ld	ra,8(sp)
    80005436:	6402                	ld	s0,0(sp)
    80005438:	0141                	addi	sp,sp,16
    8000543a:	8082                	ret
    panic("free_desc 1");
    8000543c:	00002517          	auipc	a0,0x2
    80005440:	49c50513          	addi	a0,a0,1180 # 800078d8 <syscalls+0x340>
    80005444:	af2fb0ef          	jal	ra,80000736 <panic>
    panic("free_desc 2");
    80005448:	00002517          	auipc	a0,0x2
    8000544c:	4a050513          	addi	a0,a0,1184 # 800078e8 <syscalls+0x350>
    80005450:	ae6fb0ef          	jal	ra,80000736 <panic>

0000000080005454 <virtio_disk_init>:
{
    80005454:	1101                	addi	sp,sp,-32
    80005456:	ec06                	sd	ra,24(sp)
    80005458:	e822                	sd	s0,16(sp)
    8000545a:	e426                	sd	s1,8(sp)
    8000545c:	e04a                	sd	s2,0(sp)
    8000545e:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005460:	00002597          	auipc	a1,0x2
    80005464:	49858593          	addi	a1,a1,1176 # 800078f8 <syscalls+0x360>
    80005468:	0001c517          	auipc	a0,0x1c
    8000546c:	a3050513          	addi	a0,a0,-1488 # 80020e98 <disk+0x128>
    80005470:	eb6fb0ef          	jal	ra,80000b26 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005474:	100017b7          	lui	a5,0x10001
    80005478:	4398                	lw	a4,0(a5)
    8000547a:	2701                	sext.w	a4,a4
    8000547c:	747277b7          	lui	a5,0x74727
    80005480:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005484:	14f71063          	bne	a4,a5,800055c4 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005488:	100017b7          	lui	a5,0x10001
    8000548c:	43dc                	lw	a5,4(a5)
    8000548e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005490:	4709                	li	a4,2
    80005492:	12e79963          	bne	a5,a4,800055c4 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005496:	100017b7          	lui	a5,0x10001
    8000549a:	479c                	lw	a5,8(a5)
    8000549c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000549e:	12e79363          	bne	a5,a4,800055c4 <virtio_disk_init+0x170>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054a2:	100017b7          	lui	a5,0x10001
    800054a6:	47d8                	lw	a4,12(a5)
    800054a8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054aa:	554d47b7          	lui	a5,0x554d4
    800054ae:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054b2:	10f71963          	bne	a4,a5,800055c4 <virtio_disk_init+0x170>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054b6:	100017b7          	lui	a5,0x10001
    800054ba:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054be:	4705                	li	a4,1
    800054c0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054c2:	470d                	li	a4,3
    800054c4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054c6:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800054c8:	c7ffe737          	lui	a4,0xc7ffe
    800054cc:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd8af>
    800054d0:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054d2:	2701                	sext.w	a4,a4
    800054d4:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054d6:	472d                	li	a4,11
    800054d8:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800054da:	5bbc                	lw	a5,112(a5)
    800054dc:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800054e0:	8ba1                	andi	a5,a5,8
    800054e2:	0e078763          	beqz	a5,800055d0 <virtio_disk_init+0x17c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054e6:	100017b7          	lui	a5,0x10001
    800054ea:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800054ee:	43fc                	lw	a5,68(a5)
    800054f0:	2781                	sext.w	a5,a5
    800054f2:	0e079563          	bnez	a5,800055dc <virtio_disk_init+0x188>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054f6:	100017b7          	lui	a5,0x10001
    800054fa:	5bdc                	lw	a5,52(a5)
    800054fc:	2781                	sext.w	a5,a5
  if(max == 0)
    800054fe:	0e078563          	beqz	a5,800055e8 <virtio_disk_init+0x194>
  if(max < NUM)
    80005502:	471d                	li	a4,7
    80005504:	0ef77863          	bgeu	a4,a5,800055f4 <virtio_disk_init+0x1a0>
  disk.desc = kalloc();
    80005508:	d8efb0ef          	jal	ra,80000a96 <kalloc>
    8000550c:	0001c497          	auipc	s1,0x1c
    80005510:	86448493          	addi	s1,s1,-1948 # 80020d70 <disk>
    80005514:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005516:	d80fb0ef          	jal	ra,80000a96 <kalloc>
    8000551a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000551c:	d7afb0ef          	jal	ra,80000a96 <kalloc>
    80005520:	87aa                	mv	a5,a0
    80005522:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005524:	6088                	ld	a0,0(s1)
    80005526:	cd69                	beqz	a0,80005600 <virtio_disk_init+0x1ac>
    80005528:	0001c717          	auipc	a4,0x1c
    8000552c:	85073703          	ld	a4,-1968(a4) # 80020d78 <disk+0x8>
    80005530:	cb61                	beqz	a4,80005600 <virtio_disk_init+0x1ac>
    80005532:	c7f9                	beqz	a5,80005600 <virtio_disk_init+0x1ac>
  memset(disk.desc, 0, PGSIZE);
    80005534:	6605                	lui	a2,0x1
    80005536:	4581                	li	a1,0
    80005538:	f42fb0ef          	jal	ra,80000c7a <memset>
  memset(disk.avail, 0, PGSIZE);
    8000553c:	0001c497          	auipc	s1,0x1c
    80005540:	83448493          	addi	s1,s1,-1996 # 80020d70 <disk>
    80005544:	6605                	lui	a2,0x1
    80005546:	4581                	li	a1,0
    80005548:	6488                	ld	a0,8(s1)
    8000554a:	f30fb0ef          	jal	ra,80000c7a <memset>
  memset(disk.used, 0, PGSIZE);
    8000554e:	6605                	lui	a2,0x1
    80005550:	4581                	li	a1,0
    80005552:	6888                	ld	a0,16(s1)
    80005554:	f26fb0ef          	jal	ra,80000c7a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005558:	100017b7          	lui	a5,0x10001
    8000555c:	4721                	li	a4,8
    8000555e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005560:	4098                	lw	a4,0(s1)
    80005562:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005566:	40d8                	lw	a4,4(s1)
    80005568:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000556c:	6498                	ld	a4,8(s1)
    8000556e:	0007069b          	sext.w	a3,a4
    80005572:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005576:	9701                	srai	a4,a4,0x20
    80005578:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000557c:	6898                	ld	a4,16(s1)
    8000557e:	0007069b          	sext.w	a3,a4
    80005582:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005586:	9701                	srai	a4,a4,0x20
    80005588:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000558c:	4705                	li	a4,1
    8000558e:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005590:	00e48c23          	sb	a4,24(s1)
    80005594:	00e48ca3          	sb	a4,25(s1)
    80005598:	00e48d23          	sb	a4,26(s1)
    8000559c:	00e48da3          	sb	a4,27(s1)
    800055a0:	00e48e23          	sb	a4,28(s1)
    800055a4:	00e48ea3          	sb	a4,29(s1)
    800055a8:	00e48f23          	sb	a4,30(s1)
    800055ac:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800055b0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800055b4:	0727a823          	sw	s2,112(a5)
}
    800055b8:	60e2                	ld	ra,24(sp)
    800055ba:	6442                	ld	s0,16(sp)
    800055bc:	64a2                	ld	s1,8(sp)
    800055be:	6902                	ld	s2,0(sp)
    800055c0:	6105                	addi	sp,sp,32
    800055c2:	8082                	ret
    panic("could not find virtio disk");
    800055c4:	00002517          	auipc	a0,0x2
    800055c8:	34450513          	addi	a0,a0,836 # 80007908 <syscalls+0x370>
    800055cc:	96afb0ef          	jal	ra,80000736 <panic>
    panic("virtio disk FEATURES_OK unset");
    800055d0:	00002517          	auipc	a0,0x2
    800055d4:	35850513          	addi	a0,a0,856 # 80007928 <syscalls+0x390>
    800055d8:	95efb0ef          	jal	ra,80000736 <panic>
    panic("virtio disk should not be ready");
    800055dc:	00002517          	auipc	a0,0x2
    800055e0:	36c50513          	addi	a0,a0,876 # 80007948 <syscalls+0x3b0>
    800055e4:	952fb0ef          	jal	ra,80000736 <panic>
    panic("virtio disk has no queue 0");
    800055e8:	00002517          	auipc	a0,0x2
    800055ec:	38050513          	addi	a0,a0,896 # 80007968 <syscalls+0x3d0>
    800055f0:	946fb0ef          	jal	ra,80000736 <panic>
    panic("virtio disk max queue too short");
    800055f4:	00002517          	auipc	a0,0x2
    800055f8:	39450513          	addi	a0,a0,916 # 80007988 <syscalls+0x3f0>
    800055fc:	93afb0ef          	jal	ra,80000736 <panic>
    panic("virtio disk kalloc");
    80005600:	00002517          	auipc	a0,0x2
    80005604:	3a850513          	addi	a0,a0,936 # 800079a8 <syscalls+0x410>
    80005608:	92efb0ef          	jal	ra,80000736 <panic>

000000008000560c <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000560c:	7119                	addi	sp,sp,-128
    8000560e:	fc86                	sd	ra,120(sp)
    80005610:	f8a2                	sd	s0,112(sp)
    80005612:	f4a6                	sd	s1,104(sp)
    80005614:	f0ca                	sd	s2,96(sp)
    80005616:	ecce                	sd	s3,88(sp)
    80005618:	e8d2                	sd	s4,80(sp)
    8000561a:	e4d6                	sd	s5,72(sp)
    8000561c:	e0da                	sd	s6,64(sp)
    8000561e:	fc5e                	sd	s7,56(sp)
    80005620:	f862                	sd	s8,48(sp)
    80005622:	f466                	sd	s9,40(sp)
    80005624:	f06a                	sd	s10,32(sp)
    80005626:	ec6e                	sd	s11,24(sp)
    80005628:	0100                	addi	s0,sp,128
    8000562a:	8aaa                	mv	s5,a0
    8000562c:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000562e:	00c52d03          	lw	s10,12(a0)
    80005632:	001d1d1b          	slliw	s10,s10,0x1
    80005636:	1d02                	slli	s10,s10,0x20
    80005638:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    8000563c:	0001c517          	auipc	a0,0x1c
    80005640:	85c50513          	addi	a0,a0,-1956 # 80020e98 <disk+0x128>
    80005644:	d62fb0ef          	jal	ra,80000ba6 <acquire>
  for(int i = 0; i < 3; i++){
    80005648:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000564a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000564c:	0001bb97          	auipc	s7,0x1b
    80005650:	724b8b93          	addi	s7,s7,1828 # 80020d70 <disk>
  for(int i = 0; i < 3; i++){
    80005654:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005656:	0001cc97          	auipc	s9,0x1c
    8000565a:	842c8c93          	addi	s9,s9,-1982 # 80020e98 <disk+0x128>
    8000565e:	a8a9                	j	800056b8 <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005660:	00fb8733          	add	a4,s7,a5
    80005664:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005668:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000566a:	0207c563          	bltz	a5,80005694 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000566e:	2905                	addiw	s2,s2,1
    80005670:	0611                	addi	a2,a2,4
    80005672:	05690863          	beq	s2,s6,800056c2 <virtio_disk_rw+0xb6>
    idx[i] = alloc_desc();
    80005676:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005678:	0001b717          	auipc	a4,0x1b
    8000567c:	6f870713          	addi	a4,a4,1784 # 80020d70 <disk>
    80005680:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005682:	01874683          	lbu	a3,24(a4)
    80005686:	fee9                	bnez	a3,80005660 <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80005688:	2785                	addiw	a5,a5,1
    8000568a:	0705                	addi	a4,a4,1
    8000568c:	fe979be3          	bne	a5,s1,80005682 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005690:	57fd                	li	a5,-1
    80005692:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005694:	01205b63          	blez	s2,800056aa <virtio_disk_rw+0x9e>
    80005698:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    8000569a:	000a2503          	lw	a0,0(s4)
    8000569e:	d41ff0ef          	jal	ra,800053de <free_desc>
      for(int j = 0; j < i; j++)
    800056a2:	2d85                	addiw	s11,s11,1
    800056a4:	0a11                	addi	s4,s4,4
    800056a6:	ffb91ae3          	bne	s2,s11,8000569a <virtio_disk_rw+0x8e>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056aa:	85e6                	mv	a1,s9
    800056ac:	0001b517          	auipc	a0,0x1b
    800056b0:	6dc50513          	addi	a0,a0,1756 # 80020d88 <disk+0x18>
    800056b4:	85dfc0ef          	jal	ra,80001f10 <sleep>
  for(int i = 0; i < 3; i++){
    800056b8:	f8040a13          	addi	s4,s0,-128
{
    800056bc:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800056be:	894e                	mv	s2,s3
    800056c0:	bf5d                	j	80005676 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056c2:	f8042583          	lw	a1,-128(s0)
    800056c6:	00a58793          	addi	a5,a1,10
    800056ca:	0792                	slli	a5,a5,0x4

  if(write)
    800056cc:	0001b617          	auipc	a2,0x1b
    800056d0:	6a460613          	addi	a2,a2,1700 # 80020d70 <disk>
    800056d4:	00f60733          	add	a4,a2,a5
    800056d8:	018036b3          	snez	a3,s8
    800056dc:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800056de:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800056e2:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800056e6:	f6078693          	addi	a3,a5,-160
    800056ea:	6218                	ld	a4,0(a2)
    800056ec:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056ee:	00878513          	addi	a0,a5,8
    800056f2:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    800056f4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800056f6:	6208                	ld	a0,0(a2)
    800056f8:	96aa                	add	a3,a3,a0
    800056fa:	4741                	li	a4,16
    800056fc:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800056fe:	4705                	li	a4,1
    80005700:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005704:	f8442703          	lw	a4,-124(s0)
    80005708:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000570c:	0712                	slli	a4,a4,0x4
    8000570e:	953a                	add	a0,a0,a4
    80005710:	058a8693          	addi	a3,s5,88
    80005714:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    80005716:	6208                	ld	a0,0(a2)
    80005718:	972a                	add	a4,a4,a0
    8000571a:	40000693          	li	a3,1024
    8000571e:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005720:	001c3c13          	seqz	s8,s8
    80005724:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005726:	001c6c13          	ori	s8,s8,1
    8000572a:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000572e:	f8842603          	lw	a2,-120(s0)
    80005732:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005736:	0001b697          	auipc	a3,0x1b
    8000573a:	63a68693          	addi	a3,a3,1594 # 80020d70 <disk>
    8000573e:	00258713          	addi	a4,a1,2
    80005742:	0712                	slli	a4,a4,0x4
    80005744:	9736                	add	a4,a4,a3
    80005746:	587d                	li	a6,-1
    80005748:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000574c:	0612                	slli	a2,a2,0x4
    8000574e:	9532                	add	a0,a0,a2
    80005750:	f9078793          	addi	a5,a5,-112
    80005754:	97b6                	add	a5,a5,a3
    80005756:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    80005758:	629c                	ld	a5,0(a3)
    8000575a:	97b2                	add	a5,a5,a2
    8000575c:	4605                	li	a2,1
    8000575e:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005760:	4509                	li	a0,2
    80005762:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    80005766:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000576a:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000576e:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005772:	6698                	ld	a4,8(a3)
    80005774:	00275783          	lhu	a5,2(a4)
    80005778:	8b9d                	andi	a5,a5,7
    8000577a:	0786                	slli	a5,a5,0x1
    8000577c:	97ba                	add	a5,a5,a4
    8000577e:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005782:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005786:	6698                	ld	a4,8(a3)
    80005788:	00275783          	lhu	a5,2(a4)
    8000578c:	2785                	addiw	a5,a5,1
    8000578e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005792:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005796:	100017b7          	lui	a5,0x10001
    8000579a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000579e:	004aa783          	lw	a5,4(s5)
    800057a2:	00c79f63          	bne	a5,a2,800057c0 <virtio_disk_rw+0x1b4>
    sleep(b, &disk.vdisk_lock);
    800057a6:	0001b917          	auipc	s2,0x1b
    800057aa:	6f290913          	addi	s2,s2,1778 # 80020e98 <disk+0x128>
  while(b->disk == 1) {
    800057ae:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800057b0:	85ca                	mv	a1,s2
    800057b2:	8556                	mv	a0,s5
    800057b4:	f5cfc0ef          	jal	ra,80001f10 <sleep>
  while(b->disk == 1) {
    800057b8:	004aa783          	lw	a5,4(s5)
    800057bc:	fe978ae3          	beq	a5,s1,800057b0 <virtio_disk_rw+0x1a4>
  }

  disk.info[idx[0]].b = 0;
    800057c0:	f8042903          	lw	s2,-128(s0)
    800057c4:	00290793          	addi	a5,s2,2
    800057c8:	00479713          	slli	a4,a5,0x4
    800057cc:	0001b797          	auipc	a5,0x1b
    800057d0:	5a478793          	addi	a5,a5,1444 # 80020d70 <disk>
    800057d4:	97ba                	add	a5,a5,a4
    800057d6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800057da:	0001b997          	auipc	s3,0x1b
    800057de:	59698993          	addi	s3,s3,1430 # 80020d70 <disk>
    800057e2:	00491713          	slli	a4,s2,0x4
    800057e6:	0009b783          	ld	a5,0(s3)
    800057ea:	97ba                	add	a5,a5,a4
    800057ec:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057f0:	854a                	mv	a0,s2
    800057f2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057f6:	be9ff0ef          	jal	ra,800053de <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057fa:	8885                	andi	s1,s1,1
    800057fc:	f0fd                	bnez	s1,800057e2 <virtio_disk_rw+0x1d6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057fe:	0001b517          	auipc	a0,0x1b
    80005802:	69a50513          	addi	a0,a0,1690 # 80020e98 <disk+0x128>
    80005806:	c38fb0ef          	jal	ra,80000c3e <release>
}
    8000580a:	70e6                	ld	ra,120(sp)
    8000580c:	7446                	ld	s0,112(sp)
    8000580e:	74a6                	ld	s1,104(sp)
    80005810:	7906                	ld	s2,96(sp)
    80005812:	69e6                	ld	s3,88(sp)
    80005814:	6a46                	ld	s4,80(sp)
    80005816:	6aa6                	ld	s5,72(sp)
    80005818:	6b06                	ld	s6,64(sp)
    8000581a:	7be2                	ld	s7,56(sp)
    8000581c:	7c42                	ld	s8,48(sp)
    8000581e:	7ca2                	ld	s9,40(sp)
    80005820:	7d02                	ld	s10,32(sp)
    80005822:	6de2                	ld	s11,24(sp)
    80005824:	6109                	addi	sp,sp,128
    80005826:	8082                	ret

0000000080005828 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005828:	1101                	addi	sp,sp,-32
    8000582a:	ec06                	sd	ra,24(sp)
    8000582c:	e822                	sd	s0,16(sp)
    8000582e:	e426                	sd	s1,8(sp)
    80005830:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005832:	0001b497          	auipc	s1,0x1b
    80005836:	53e48493          	addi	s1,s1,1342 # 80020d70 <disk>
    8000583a:	0001b517          	auipc	a0,0x1b
    8000583e:	65e50513          	addi	a0,a0,1630 # 80020e98 <disk+0x128>
    80005842:	b64fb0ef          	jal	ra,80000ba6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005846:	10001737          	lui	a4,0x10001
    8000584a:	533c                	lw	a5,96(a4)
    8000584c:	8b8d                	andi	a5,a5,3
    8000584e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005850:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005854:	689c                	ld	a5,16(s1)
    80005856:	0204d703          	lhu	a4,32(s1)
    8000585a:	0027d783          	lhu	a5,2(a5)
    8000585e:	04f70663          	beq	a4,a5,800058aa <virtio_disk_intr+0x82>
    __sync_synchronize();
    80005862:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005866:	6898                	ld	a4,16(s1)
    80005868:	0204d783          	lhu	a5,32(s1)
    8000586c:	8b9d                	andi	a5,a5,7
    8000586e:	078e                	slli	a5,a5,0x3
    80005870:	97ba                	add	a5,a5,a4
    80005872:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005874:	00278713          	addi	a4,a5,2
    80005878:	0712                	slli	a4,a4,0x4
    8000587a:	9726                	add	a4,a4,s1
    8000587c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005880:	e321                	bnez	a4,800058c0 <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005882:	0789                	addi	a5,a5,2
    80005884:	0792                	slli	a5,a5,0x4
    80005886:	97a6                	add	a5,a5,s1
    80005888:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000588a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000588e:	ecefc0ef          	jal	ra,80001f5c <wakeup>

    disk.used_idx += 1;
    80005892:	0204d783          	lhu	a5,32(s1)
    80005896:	2785                	addiw	a5,a5,1
    80005898:	17c2                	slli	a5,a5,0x30
    8000589a:	93c1                	srli	a5,a5,0x30
    8000589c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058a0:	6898                	ld	a4,16(s1)
    800058a2:	00275703          	lhu	a4,2(a4)
    800058a6:	faf71ee3          	bne	a4,a5,80005862 <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    800058aa:	0001b517          	auipc	a0,0x1b
    800058ae:	5ee50513          	addi	a0,a0,1518 # 80020e98 <disk+0x128>
    800058b2:	b8cfb0ef          	jal	ra,80000c3e <release>
}
    800058b6:	60e2                	ld	ra,24(sp)
    800058b8:	6442                	ld	s0,16(sp)
    800058ba:	64a2                	ld	s1,8(sp)
    800058bc:	6105                	addi	sp,sp,32
    800058be:	8082                	ret
      panic("virtio_disk_intr status");
    800058c0:	00002517          	auipc	a0,0x2
    800058c4:	10050513          	addi	a0,a0,256 # 800079c0 <syscalls+0x428>
    800058c8:	e6ffa0ef          	jal	ra,80000736 <panic>

00000000800058cc <sha256_transform>:
    uint32 datalen;
    uint64 bitlen;
    uint32 state[8];
} SHA256_CTX;

void sha256_transform(SHA256_CTX *ctx, uint8 data[]) {
    800058cc:	714d                	addi	sp,sp,-336
    800058ce:	e6a2                	sd	s0,328(sp)
    800058d0:	e2a6                	sd	s1,320(sp)
    800058d2:	fe4a                	sd	s2,312(sp)
    800058d4:	fa4e                	sd	s3,304(sp)
    800058d6:	f652                	sd	s4,296(sp)
    800058d8:	f256                	sd	s5,288(sp)
    800058da:	ee5a                	sd	s6,280(sp)
    800058dc:	ea5e                	sd	s7,272(sp)
    800058de:	e662                	sd	s8,264(sp)
    800058e0:	e266                	sd	s9,256(sp)
    800058e2:	0a80                	addi	s0,sp,336
    uint32 a, b, c, d, e, f, g, h, i, j, t1, t2, m[64];

    for (i = 0, j = 0; i < 16; ++i, j += 4)
    800058e4:	eb040e13          	addi	t3,s0,-336
    800058e8:	ef040613          	addi	a2,s0,-272
void sha256_transform(SHA256_CTX *ctx, uint8 data[]) {
    800058ec:	8772                	mv	a4,t3
        m[i] = (data[j] << 24) | (data[j + 1] << 16) | (data[j + 2] << 8) | (data[j + 3]);
    800058ee:	0005c783          	lbu	a5,0(a1)
    800058f2:	0187979b          	slliw	a5,a5,0x18
    800058f6:	0015c683          	lbu	a3,1(a1)
    800058fa:	0106969b          	slliw	a3,a3,0x10
    800058fe:	8fd5                	or	a5,a5,a3
    80005900:	0035c683          	lbu	a3,3(a1)
    80005904:	8fd5                	or	a5,a5,a3
    80005906:	0025c683          	lbu	a3,2(a1)
    8000590a:	0086969b          	slliw	a3,a3,0x8
    8000590e:	8fd5                	or	a5,a5,a3
    80005910:	c31c                	sw	a5,0(a4)
    for (i = 0, j = 0; i < 16; ++i, j += 4)
    80005912:	0591                	addi	a1,a1,4
    80005914:	0711                	addi	a4,a4,4
    80005916:	fcc71ce3          	bne	a4,a2,800058ee <sha256_transform+0x22>
    for (; i < 64; ++i)
    8000591a:	0c0e0893          	addi	a7,t3,192
    for (i = 0, j = 0; i < 16; ++i, j += 4)
    8000591e:	87f2                	mv	a5,t3
        m[i] = SIG1(m[i - 2]) + m[i - 7] + SIG0(m[i - 15]) + m[i - 16];
    80005920:	5f8c                	lw	a1,56(a5)
    80005922:	43d0                	lw	a2,4(a5)
    80005924:	00f5971b          	slliw	a4,a1,0xf
    80005928:	0115d69b          	srliw	a3,a1,0x11
    8000592c:	8f55                	or	a4,a4,a3
    8000592e:	00d5969b          	slliw	a3,a1,0xd
    80005932:	0135d81b          	srliw	a6,a1,0x13
    80005936:	0106e6b3          	or	a3,a3,a6
    8000593a:	8f35                	xor	a4,a4,a3
    8000593c:	00a5d69b          	srliw	a3,a1,0xa
    80005940:	8eb9                	xor	a3,a3,a4
    80005942:	53d8                	lw	a4,36(a5)
    80005944:	438c                	lw	a1,0(a5)
    80005946:	9f2d                	addw	a4,a4,a1
    80005948:	9f35                	addw	a4,a4,a3
    8000594a:	0076569b          	srliw	a3,a2,0x7
    8000594e:	0196159b          	slliw	a1,a2,0x19
    80005952:	8ecd                	or	a3,a3,a1
    80005954:	00e6159b          	slliw	a1,a2,0xe
    80005958:	0126581b          	srliw	a6,a2,0x12
    8000595c:	0105e5b3          	or	a1,a1,a6
    80005960:	8ead                	xor	a3,a3,a1
    80005962:	0036561b          	srliw	a2,a2,0x3
    80005966:	8eb1                	xor	a3,a3,a2
    80005968:	9f35                	addw	a4,a4,a3
    8000596a:	c3b8                	sw	a4,64(a5)
    for (; i < 64; ++i)
    8000596c:	0791                	addi	a5,a5,4
    8000596e:	faf899e3          	bne	a7,a5,80005920 <sha256_transform+0x54>

    a = ctx->state[0];
    80005972:	05052b03          	lw	s6,80(a0)
    b = ctx->state[1];
    80005976:	05452a83          	lw	s5,84(a0)
    c = ctx->state[2];
    8000597a:	05852a03          	lw	s4,88(a0)
    d = ctx->state[3];
    8000597e:	05c52983          	lw	s3,92(a0)
    e = ctx->state[4];
    80005982:	06052903          	lw	s2,96(a0)
    f = ctx->state[5];
    80005986:	5164                	lw	s1,100(a0)
    g = ctx->state[6];
    80005988:	06852383          	lw	t2,104(a0)
    h = ctx->state[7];
    8000598c:	06c52283          	lw	t0,108(a0)

    for (i = 0; i < 64; ++i) {
    80005990:	00002317          	auipc	t1,0x2
    80005994:	06030313          	addi	t1,t1,96 # 800079f0 <k>
    80005998:	00002f97          	auipc	t6,0x2
    8000599c:	158f8f93          	addi	t6,t6,344 # 80007af0 <first.1>
    h = ctx->state[7];
    800059a0:	8b96                	mv	s7,t0
    g = ctx->state[6];
    800059a2:	8e9e                	mv	t4,t2
    f = ctx->state[5];
    800059a4:	8826                	mv	a6,s1
    e = ctx->state[4];
    800059a6:	86ca                	mv	a3,s2
    d = ctx->state[3];
    800059a8:	8f4e                	mv	t5,s3
    c = ctx->state[2];
    800059aa:	88d2                	mv	a7,s4
    b = ctx->state[1];
    800059ac:	85d6                	mv	a1,s5
    a = ctx->state[0];
    800059ae:	865a                	mv	a2,s6
    800059b0:	a039                	j	800059be <sha256_transform+0xf2>
    800059b2:	8ec2                	mv	t4,a6
    800059b4:	883a                	mv	a6,a4
        t1 = h + EP1(e) + CH(e, f, g) + k[i] + m[i];
        t2 = EP0(a) + MAJ(a, b, c);
        h = g;
        g = f;
        f = e;
        e = d + t1;
    800059b6:	86e2                	mv	a3,s8
    800059b8:	88ae                	mv	a7,a1
    800059ba:	85e6                	mv	a1,s9
        d = c;
        c = b;
        b = a;
        a = t1 + t2;
    800059bc:	863e                	mv	a2,a5
        t1 = h + EP1(e) + CH(e, f, g) + k[i] + m[i];
    800059be:	0066d79b          	srliw	a5,a3,0x6
    800059c2:	01a6971b          	slliw	a4,a3,0x1a
    800059c6:	8fd9                	or	a5,a5,a4
    800059c8:	00b6d71b          	srliw	a4,a3,0xb
    800059cc:	01569c1b          	slliw	s8,a3,0x15
    800059d0:	01876733          	or	a4,a4,s8
    800059d4:	8fb9                	xor	a5,a5,a4
    800059d6:	0076971b          	slliw	a4,a3,0x7
    800059da:	0196dc1b          	srliw	s8,a3,0x19
    800059de:	01876733          	or	a4,a4,s8
    800059e2:	8f3d                	xor	a4,a4,a5
    800059e4:	00032783          	lw	a5,0(t1)
    800059e8:	000e2c03          	lw	s8,0(t3)
    800059ec:	018787bb          	addw	a5,a5,s8
    800059f0:	9fb9                	addw	a5,a5,a4
    800059f2:	fff6c713          	not	a4,a3
    800059f6:	01d77733          	and	a4,a4,t4
    800059fa:	0106fc33          	and	s8,a3,a6
    800059fe:	01874733          	xor	a4,a4,s8
    80005a02:	9fb9                	addw	a5,a5,a4
    80005a04:	017787bb          	addw	a5,a5,s7
        t2 = EP0(a) + MAJ(a, b, c);
    80005a08:	0026571b          	srliw	a4,a2,0x2
    80005a0c:	01e61b9b          	slliw	s7,a2,0x1e
    80005a10:	01776733          	or	a4,a4,s7
    80005a14:	00d65b9b          	srliw	s7,a2,0xd
    80005a18:	01361c1b          	slliw	s8,a2,0x13
    80005a1c:	018bebb3          	or	s7,s7,s8
    80005a20:	01774733          	xor	a4,a4,s7
    80005a24:	00a61b9b          	slliw	s7,a2,0xa
    80005a28:	01665c1b          	srliw	s8,a2,0x16
    80005a2c:	018bebb3          	or	s7,s7,s8
    80005a30:	01774733          	xor	a4,a4,s7
    80005a34:	0115cbb3          	xor	s7,a1,a7
    80005a38:	01767bb3          	and	s7,a2,s7
    80005a3c:	0115fc33          	and	s8,a1,a7
    80005a40:	018bcbb3          	xor	s7,s7,s8
    80005a44:	0177073b          	addw	a4,a4,s7
        e = d + t1;
    80005a48:	2681                	sext.w	a3,a3
    80005a4a:	01e78c3b          	addw	s8,a5,t5
        a = t1 + t2;
    80005a4e:	2601                	sext.w	a2,a2
    80005a50:	9fb9                	addw	a5,a5,a4
    for (i = 0; i < 64; ++i) {
    80005a52:	0311                	addi	t1,t1,4
    80005a54:	0e11                	addi	t3,t3,4
    80005a56:	00060c9b          	sext.w	s9,a2
    80005a5a:	2581                	sext.w	a1,a1
    80005a5c:	00088f1b          	sext.w	t5,a7
    80005a60:	0006871b          	sext.w	a4,a3
    80005a64:	2801                	sext.w	a6,a6
    80005a66:	000e8b9b          	sext.w	s7,t4
    80005a6a:	f5f314e3          	bne	t1,t6,800059b2 <sha256_transform+0xe6>
    }

    ctx->state[0] += a;
    80005a6e:	00fb07bb          	addw	a5,s6,a5
    80005a72:	c93c                	sw	a5,80(a0)
    ctx->state[1] += b;
    80005a74:	00ca863b          	addw	a2,s5,a2
    80005a78:	c970                	sw	a2,84(a0)
    ctx->state[2] += c;
    80005a7a:	00ba05bb          	addw	a1,s4,a1
    80005a7e:	cd2c                	sw	a1,88(a0)
    ctx->state[3] += d;
    80005a80:	011988bb          	addw	a7,s3,a7
    80005a84:	05152e23          	sw	a7,92(a0)
    ctx->state[4] += e;
    80005a88:	0189093b          	addw	s2,s2,s8
    80005a8c:	07252023          	sw	s2,96(a0)
    ctx->state[5] += f;
    80005a90:	9ea5                	addw	a3,a3,s1
    80005a92:	d174                	sw	a3,100(a0)
    ctx->state[6] += g;
    80005a94:	0103883b          	addw	a6,t2,a6
    80005a98:	07052423          	sw	a6,104(a0)
    ctx->state[7] += h;
    80005a9c:	01d28ebb          	addw	t4,t0,t4
    80005aa0:	07d52623          	sw	t4,108(a0)
}
    80005aa4:	6436                	ld	s0,328(sp)
    80005aa6:	6496                	ld	s1,320(sp)
    80005aa8:	7972                	ld	s2,312(sp)
    80005aaa:	79d2                	ld	s3,304(sp)
    80005aac:	7a32                	ld	s4,296(sp)
    80005aae:	7a92                	ld	s5,288(sp)
    80005ab0:	6b72                	ld	s6,280(sp)
    80005ab2:	6bd2                	ld	s7,272(sp)
    80005ab4:	6c32                	ld	s8,264(sp)
    80005ab6:	6c92                	ld	s9,256(sp)
    80005ab8:	6171                	addi	sp,sp,336
    80005aba:	8082                	ret

0000000080005abc <sha256_init>:

void sha256_init(SHA256_CTX *ctx) {
    80005abc:	1141                	addi	sp,sp,-16
    80005abe:	e422                	sd	s0,8(sp)
    80005ac0:	0800                	addi	s0,sp,16
    ctx->datalen = 0;
    80005ac2:	04052023          	sw	zero,64(a0)
    ctx->bitlen = 0;
    80005ac6:	04053423          	sd	zero,72(a0)
    ctx->state[0] = 0x6a09e667;
    80005aca:	6a09e7b7          	lui	a5,0x6a09e
    80005ace:	66778793          	addi	a5,a5,1639 # 6a09e667 <_entry-0x15f61999>
    80005ad2:	c93c                	sw	a5,80(a0)
    ctx->state[1] = 0xbb67ae85;
    80005ad4:	bb67b7b7          	lui	a5,0xbb67b
    80005ad8:	e8578793          	addi	a5,a5,-379 # ffffffffbb67ae85 <end+0xffffffff3b659fd5>
    80005adc:	c97c                	sw	a5,84(a0)
    ctx->state[2] = 0x3c6ef372;
    80005ade:	3c6ef7b7          	lui	a5,0x3c6ef
    80005ae2:	37278793          	addi	a5,a5,882 # 3c6ef372 <_entry-0x43910c8e>
    80005ae6:	cd3c                	sw	a5,88(a0)
    ctx->state[3] = 0xa54ff53a;
    80005ae8:	a54ff7b7          	lui	a5,0xa54ff
    80005aec:	53a78793          	addi	a5,a5,1338 # ffffffffa54ff53a <end+0xffffffff254de68a>
    80005af0:	cd7c                	sw	a5,92(a0)
    ctx->state[4] = 0x510e527f;
    80005af2:	510e57b7          	lui	a5,0x510e5
    80005af6:	27f78793          	addi	a5,a5,639 # 510e527f <_entry-0x2ef1ad81>
    80005afa:	d13c                	sw	a5,96(a0)
    ctx->state[5] = 0x9b05688c;
    80005afc:	9b0577b7          	lui	a5,0x9b057
    80005b00:	88c78793          	addi	a5,a5,-1908 # ffffffff9b05688c <end+0xffffffff1b0359dc>
    80005b04:	d17c                	sw	a5,100(a0)
    ctx->state[6] = 0x1f83d9ab;
    80005b06:	1f83e7b7          	lui	a5,0x1f83e
    80005b0a:	9ab78793          	addi	a5,a5,-1621 # 1f83d9ab <_entry-0x607c2655>
    80005b0e:	d53c                	sw	a5,104(a0)
    ctx->state[7] = 0x5be0cd19;
    80005b10:	5be0d7b7          	lui	a5,0x5be0d
    80005b14:	d1978793          	addi	a5,a5,-743 # 5be0cd19 <_entry-0x241f32e7>
    80005b18:	d57c                	sw	a5,108(a0)
}
    80005b1a:	6422                	ld	s0,8(sp)
    80005b1c:	0141                	addi	sp,sp,16
    80005b1e:	8082                	ret

0000000080005b20 <sha256_update>:

void sha256_update(SHA256_CTX *ctx, uint8 data[], uint len) {
    for (uint i = 0; i < len; ++i) {
    80005b20:	ca2d                	beqz	a2,80005b92 <sha256_update+0x72>
void sha256_update(SHA256_CTX *ctx, uint8 data[], uint len) {
    80005b22:	7179                	addi	sp,sp,-48
    80005b24:	f406                	sd	ra,40(sp)
    80005b26:	f022                	sd	s0,32(sp)
    80005b28:	ec26                	sd	s1,24(sp)
    80005b2a:	e84a                	sd	s2,16(sp)
    80005b2c:	e44e                	sd	s3,8(sp)
    80005b2e:	e052                	sd	s4,0(sp)
    80005b30:	1800                	addi	s0,sp,48
    80005b32:	84aa                	mv	s1,a0
    80005b34:	892e                	mv	s2,a1
    80005b36:	0585                	addi	a1,a1,1
    80005b38:	367d                	addiw	a2,a2,-1
    80005b3a:	1602                	slli	a2,a2,0x20
    80005b3c:	9201                	srli	a2,a2,0x20
    80005b3e:	00c589b3          	add	s3,a1,a2
        ctx->data[ctx->datalen] = data[i];
        ctx->datalen++;
        if (ctx->datalen == 64) {
    80005b42:	04000a13          	li	s4,64
    80005b46:	a021                	j	80005b4e <sha256_update+0x2e>
    for (uint i = 0; i < len; ++i) {
    80005b48:	0905                	addi	s2,s2,1
    80005b4a:	03390c63          	beq	s2,s3,80005b82 <sha256_update+0x62>
        ctx->data[ctx->datalen] = data[i];
    80005b4e:	40bc                	lw	a5,64(s1)
    80005b50:	00094683          	lbu	a3,0(s2)
    80005b54:	02079713          	slli	a4,a5,0x20
    80005b58:	9301                	srli	a4,a4,0x20
    80005b5a:	9726                	add	a4,a4,s1
    80005b5c:	00d70023          	sb	a3,0(a4)
        ctx->datalen++;
    80005b60:	2785                	addiw	a5,a5,1
    80005b62:	0007871b          	sext.w	a4,a5
    80005b66:	c0bc                	sw	a5,64(s1)
        if (ctx->datalen == 64) {
    80005b68:	ff4710e3          	bne	a4,s4,80005b48 <sha256_update+0x28>
            sha256_transform(ctx, ctx->data);
    80005b6c:	85a6                	mv	a1,s1
    80005b6e:	8526                	mv	a0,s1
    80005b70:	d5dff0ef          	jal	ra,800058cc <sha256_transform>
            ctx->bitlen += 512;
    80005b74:	64bc                	ld	a5,72(s1)
    80005b76:	20078793          	addi	a5,a5,512
    80005b7a:	e4bc                	sd	a5,72(s1)
            ctx->datalen = 0;
    80005b7c:	0404a023          	sw	zero,64(s1)
    80005b80:	b7e1                	j	80005b48 <sha256_update+0x28>
        }
    }
}
    80005b82:	70a2                	ld	ra,40(sp)
    80005b84:	7402                	ld	s0,32(sp)
    80005b86:	64e2                	ld	s1,24(sp)
    80005b88:	6942                	ld	s2,16(sp)
    80005b8a:	69a2                	ld	s3,8(sp)
    80005b8c:	6a02                	ld	s4,0(sp)
    80005b8e:	6145                	addi	sp,sp,48
    80005b90:	8082                	ret
    80005b92:	8082                	ret

0000000080005b94 <sha256_final>:

void sha256_final(SHA256_CTX *ctx, uint8 hash[]) {
    80005b94:	1101                	addi	sp,sp,-32
    80005b96:	ec06                	sd	ra,24(sp)
    80005b98:	e822                	sd	s0,16(sp)
    80005b9a:	e426                	sd	s1,8(sp)
    80005b9c:	e04a                	sd	s2,0(sp)
    80005b9e:	1000                	addi	s0,sp,32
    80005ba0:	84aa                	mv	s1,a0
    80005ba2:	892e                	mv	s2,a1
    uint32 i = ctx->datalen;
    80005ba4:	4134                	lw	a3,64(a0)

    if (ctx->datalen < 56) {
    80005ba6:	03700793          	li	a5,55
    80005baa:	04d7e763          	bltu	a5,a3,80005bf8 <sha256_final+0x64>
        ctx->data[i++] = 0x80;
    80005bae:	0016871b          	addiw	a4,a3,1
    80005bb2:	0007061b          	sext.w	a2,a4
    80005bb6:	02069793          	slli	a5,a3,0x20
    80005bba:	9381                	srli	a5,a5,0x20
    80005bbc:	97aa                	add	a5,a5,a0
    80005bbe:	f8000593          	li	a1,-128
    80005bc2:	00b78023          	sb	a1,0(a5)
        while (i < 56)
    80005bc6:	03700793          	li	a5,55
    80005bca:	08c7e563          	bltu	a5,a2,80005c54 <sha256_final+0xc0>
    80005bce:	02071613          	slli	a2,a4,0x20
    80005bd2:	9201                	srli	a2,a2,0x20
    80005bd4:	00c507b3          	add	a5,a0,a2
    80005bd8:	00150713          	addi	a4,a0,1
    80005bdc:	9732                	add	a4,a4,a2
    80005bde:	03600613          	li	a2,54
    80005be2:	40d606bb          	subw	a3,a2,a3
    80005be6:	1682                	slli	a3,a3,0x20
    80005be8:	9281                	srli	a3,a3,0x20
    80005bea:	9736                	add	a4,a4,a3
            ctx->data[i++] = 0x00;
    80005bec:	00078023          	sb	zero,0(a5)
        while (i < 56)
    80005bf0:	0785                	addi	a5,a5,1
    80005bf2:	fee79de3          	bne	a5,a4,80005bec <sha256_final+0x58>
    80005bf6:	a8b9                	j	80005c54 <sha256_final+0xc0>
    } else {
        ctx->data[i++] = 0x80;
    80005bf8:	0016871b          	addiw	a4,a3,1
    80005bfc:	0007061b          	sext.w	a2,a4
    80005c00:	02069793          	slli	a5,a3,0x20
    80005c04:	9381                	srli	a5,a5,0x20
    80005c06:	97aa                	add	a5,a5,a0
    80005c08:	f8000593          	li	a1,-128
    80005c0c:	00b78023          	sb	a1,0(a5)
        while (i < 64)
    80005c10:	03f00793          	li	a5,63
    80005c14:	02c7e663          	bltu	a5,a2,80005c40 <sha256_final+0xac>
    80005c18:	02071613          	slli	a2,a4,0x20
    80005c1c:	9201                	srli	a2,a2,0x20
    80005c1e:	00c507b3          	add	a5,a0,a2
    80005c22:	00150713          	addi	a4,a0,1
    80005c26:	9732                	add	a4,a4,a2
    80005c28:	03e00613          	li	a2,62
    80005c2c:	40d606bb          	subw	a3,a2,a3
    80005c30:	1682                	slli	a3,a3,0x20
    80005c32:	9281                	srli	a3,a3,0x20
    80005c34:	9736                	add	a4,a4,a3
            ctx->data[i++] = 0x00;
    80005c36:	00078023          	sb	zero,0(a5)
        while (i < 64)
    80005c3a:	0785                	addi	a5,a5,1
    80005c3c:	fee79de3          	bne	a5,a4,80005c36 <sha256_final+0xa2>
        sha256_transform(ctx, ctx->data);
    80005c40:	85a6                	mv	a1,s1
    80005c42:	8526                	mv	a0,s1
    80005c44:	c89ff0ef          	jal	ra,800058cc <sha256_transform>
        memset(ctx->data, 0, 56);
    80005c48:	03800613          	li	a2,56
    80005c4c:	4581                	li	a1,0
    80005c4e:	8526                	mv	a0,s1
    80005c50:	82afb0ef          	jal	ra,80000c7a <memset>
    }

    ctx->bitlen += ctx->datalen * 8;
    80005c54:	40bc                	lw	a5,64(s1)
    80005c56:	0037979b          	slliw	a5,a5,0x3
    80005c5a:	1782                	slli	a5,a5,0x20
    80005c5c:	9381                	srli	a5,a5,0x20
    80005c5e:	64b8                	ld	a4,72(s1)
    80005c60:	97ba                	add	a5,a5,a4
    80005c62:	e4bc                	sd	a5,72(s1)
    ctx->data[63] = ctx->bitlen;
    80005c64:	02f48fa3          	sb	a5,63(s1)
    ctx->data[62] = ctx->bitlen >> 8;
    80005c68:	0087d713          	srli	a4,a5,0x8
    80005c6c:	02e48f23          	sb	a4,62(s1)
    ctx->data[61] = ctx->bitlen >> 16;
    80005c70:	0107d713          	srli	a4,a5,0x10
    80005c74:	02e48ea3          	sb	a4,61(s1)
    ctx->data[60] = ctx->bitlen >> 24;
    80005c78:	0187d713          	srli	a4,a5,0x18
    80005c7c:	02e48e23          	sb	a4,60(s1)
    ctx->data[59] = ctx->bitlen >> 32;
    80005c80:	0207d713          	srli	a4,a5,0x20
    80005c84:	02e48da3          	sb	a4,59(s1)
    ctx->data[58] = ctx->bitlen >> 40;
    80005c88:	0287d713          	srli	a4,a5,0x28
    80005c8c:	02e48d23          	sb	a4,58(s1)
    ctx->data[57] = ctx->bitlen >> 48;
    80005c90:	0307d713          	srli	a4,a5,0x30
    80005c94:	02e48ca3          	sb	a4,57(s1)
    ctx->data[56] = ctx->bitlen >> 56;
    80005c98:	93e1                	srli	a5,a5,0x38
    80005c9a:	02f48c23          	sb	a5,56(s1)
    sha256_transform(ctx, ctx->data);
    80005c9e:	85a6                	mv	a1,s1
    80005ca0:	8526                	mv	a0,s1
    80005ca2:	c2bff0ef          	jal	ra,800058cc <sha256_transform>

    for (i = 0; i < 4; ++i) {
    80005ca6:	85ca                	mv	a1,s2
    sha256_transform(ctx, ctx->data);
    80005ca8:	47e1                	li	a5,24
    for (i = 0; i < 4; ++i) {
    80005caa:	56e1                	li	a3,-8
        hash[i] = (ctx->state[0] >> (24 - i * 8)) & 0x000000ff;
    80005cac:	48b8                	lw	a4,80(s1)
    80005cae:	00f7573b          	srlw	a4,a4,a5
    80005cb2:	00e58023          	sb	a4,0(a1)
        hash[i + 4] = (ctx->state[1] >> (24 - i * 8)) & 0x000000ff;
    80005cb6:	48f8                	lw	a4,84(s1)
    80005cb8:	00f7573b          	srlw	a4,a4,a5
    80005cbc:	00e58223          	sb	a4,4(a1)
        hash[i + 8] = (ctx->state[2] >> (24 - i * 8)) & 0x000000ff;
    80005cc0:	4cb8                	lw	a4,88(s1)
    80005cc2:	00f7573b          	srlw	a4,a4,a5
    80005cc6:	00e58423          	sb	a4,8(a1)
        hash[i + 12] = (ctx->state[3] >> (24 - i * 8)) & 0x000000ff;
    80005cca:	4cf8                	lw	a4,92(s1)
    80005ccc:	00f7573b          	srlw	a4,a4,a5
    80005cd0:	00e58623          	sb	a4,12(a1)
        hash[i + 16] = (ctx->state[4] >> (24 - i * 8)) & 0x000000ff;
    80005cd4:	50b8                	lw	a4,96(s1)
    80005cd6:	00f7573b          	srlw	a4,a4,a5
    80005cda:	00e58823          	sb	a4,16(a1)
        hash[i + 20] = (ctx->state[5] >> (24 - i * 8)) & 0x000000ff;
    80005cde:	50f8                	lw	a4,100(s1)
    80005ce0:	00f7573b          	srlw	a4,a4,a5
    80005ce4:	00e58a23          	sb	a4,20(a1)
        hash[i + 24] = (ctx->state[6] >> (24 - i * 8)) & 0x000000ff;
    80005ce8:	54b8                	lw	a4,104(s1)
    80005cea:	00f7573b          	srlw	a4,a4,a5
    80005cee:	00e58c23          	sb	a4,24(a1)
        hash[i + 28] = (ctx->state[7] >> (24 - i * 8)) & 0x000000ff;
    80005cf2:	54f8                	lw	a4,108(s1)
    80005cf4:	00f7573b          	srlw	a4,a4,a5
    80005cf8:	00e58e23          	sb	a4,28(a1)
    for (i = 0; i < 4; ++i) {
    80005cfc:	37e1                	addiw	a5,a5,-8
    80005cfe:	0585                	addi	a1,a1,1
    80005d00:	fad796e3          	bne	a5,a3,80005cac <sha256_final+0x118>
    }
}
    80005d04:	60e2                	ld	ra,24(sp)
    80005d06:	6442                	ld	s0,16(sp)
    80005d08:	64a2                	ld	s1,8(sp)
    80005d0a:	6902                	ld	s2,0(sp)
    80005d0c:	6105                	addi	sp,sp,32
    80005d0e:	8082                	ret

0000000080005d10 <byte_to_hex>:

void byte_to_hex(uint8 byte, char* hex_str) {
    80005d10:	7179                	addi	sp,sp,-48
    80005d12:	f422                	sd	s0,40(sp)
    80005d14:	1800                	addi	s0,sp,48
    const char hex_chars[] = "0123456789abcdef";
    80005d16:	00002797          	auipc	a5,0x2
    80005d1a:	cc278793          	addi	a5,a5,-830 # 800079d8 <syscalls+0x440>
    80005d1e:	6398                	ld	a4,0(a5)
    80005d20:	fce43c23          	sd	a4,-40(s0)
    80005d24:	679c                	ld	a5,8(a5)
    80005d26:	fef43023          	sd	a5,-32(s0)
    hex_str[0] = hex_chars[(byte >> 4) & 0x0F];
    80005d2a:	00455793          	srli	a5,a0,0x4
    80005d2e:	ff040713          	addi	a4,s0,-16
    80005d32:	97ba                	add	a5,a5,a4
    80005d34:	fe87c783          	lbu	a5,-24(a5)
    80005d38:	00f58023          	sb	a5,0(a1)
    hex_str[1] = hex_chars[byte & 0x0F];
    80005d3c:	893d                	andi	a0,a0,15
    80005d3e:	953a                	add	a0,a0,a4
    80005d40:	fe854783          	lbu	a5,-24(a0)
    80005d44:	00f580a3          	sb	a5,1(a1)
}
    80005d48:	7422                	ld	s0,40(sp)
    80005d4a:	6145                	addi	sp,sp,48
    80005d4c:	8082                	ret
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
