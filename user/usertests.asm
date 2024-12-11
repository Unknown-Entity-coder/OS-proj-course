
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
       e:	00007797          	auipc	a5,0x7
      12:	37278793          	addi	a5,a5,882 # 7380 <malloc+0x246c>
      16:	638c                	ld	a1,0(a5)
      18:	6790                	ld	a2,8(a5)
      1a:	6b94                	ld	a3,16(a5)
      1c:	6f98                	ld	a4,24(a5)
      1e:	739c                	ld	a5,32(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      34:	fa840493          	addi	s1,s0,-88
      38:	fd040993          	addi	s3,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3c:	0004b903          	ld	s2,0(s1)
      40:	20100593          	li	a1,513
      44:	854a                	mv	a0,s2
      46:	233040ef          	jal	ra,4a78 <open>
    if(fd >= 0){
      4a:	00055c63          	bgez	a0,62 <copyinstr1+0x62>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      4e:	04a1                	addi	s1,s1,8
      50:	ff3496e3          	bne	s1,s3,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      54:	60e6                	ld	ra,88(sp)
      56:	6446                	ld	s0,80(sp)
      58:	64a6                	ld	s1,72(sp)
      5a:	6906                	ld	s2,64(sp)
      5c:	79e2                	ld	s3,56(sp)
      5e:	6125                	addi	sp,sp,96
      60:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      62:	862a                	mv	a2,a0
      64:	85ca                	mv	a1,s2
      66:	00005517          	auipc	a0,0x5
      6a:	faa50513          	addi	a0,a0,-86 # 5010 <malloc+0xfc>
      6e:	5ed040ef          	jal	ra,4e5a <printf>
      exit(1);
      72:	4505                	li	a0,1
      74:	1c5040ef          	jal	ra,4a38 <exit>

0000000000000078 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      78:	00009797          	auipc	a5,0x9
      7c:	4f078793          	addi	a5,a5,1264 # 9568 <uninit>
      80:	0000c697          	auipc	a3,0xc
      84:	bf868693          	addi	a3,a3,-1032 # bc78 <buf>
    if(uninit[i] != '\0'){
      88:	0007c703          	lbu	a4,0(a5)
      8c:	e709                	bnez	a4,96 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      8e:	0785                	addi	a5,a5,1
      90:	fed79ce3          	bne	a5,a3,88 <bsstest+0x10>
      94:	8082                	ret
{
      96:	1141                	addi	sp,sp,-16
      98:	e406                	sd	ra,8(sp)
      9a:	e022                	sd	s0,0(sp)
      9c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      9e:	85aa                	mv	a1,a0
      a0:	00005517          	auipc	a0,0x5
      a4:	f9050513          	addi	a0,a0,-112 # 5030 <malloc+0x11c>
      a8:	5b3040ef          	jal	ra,4e5a <printf>
      exit(1);
      ac:	4505                	li	a0,1
      ae:	18b040ef          	jal	ra,4a38 <exit>

00000000000000b2 <opentest>:
{
      b2:	1101                	addi	sp,sp,-32
      b4:	ec06                	sd	ra,24(sp)
      b6:	e822                	sd	s0,16(sp)
      b8:	e426                	sd	s1,8(sp)
      ba:	1000                	addi	s0,sp,32
      bc:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      be:	4581                	li	a1,0
      c0:	00005517          	auipc	a0,0x5
      c4:	f8850513          	addi	a0,a0,-120 # 5048 <malloc+0x134>
      c8:	1b1040ef          	jal	ra,4a78 <open>
  if(fd < 0){
      cc:	02054263          	bltz	a0,f0 <opentest+0x3e>
  close(fd);
      d0:	191040ef          	jal	ra,4a60 <close>
  fd = open("doesnotexist", 0);
      d4:	4581                	li	a1,0
      d6:	00005517          	auipc	a0,0x5
      da:	f9250513          	addi	a0,a0,-110 # 5068 <malloc+0x154>
      de:	19b040ef          	jal	ra,4a78 <open>
  if(fd >= 0){
      e2:	02055163          	bgez	a0,104 <opentest+0x52>
}
      e6:	60e2                	ld	ra,24(sp)
      e8:	6442                	ld	s0,16(sp)
      ea:	64a2                	ld	s1,8(sp)
      ec:	6105                	addi	sp,sp,32
      ee:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f0:	85a6                	mv	a1,s1
      f2:	00005517          	auipc	a0,0x5
      f6:	f5e50513          	addi	a0,a0,-162 # 5050 <malloc+0x13c>
      fa:	561040ef          	jal	ra,4e5a <printf>
    exit(1);
      fe:	4505                	li	a0,1
     100:	139040ef          	jal	ra,4a38 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     104:	85a6                	mv	a1,s1
     106:	00005517          	auipc	a0,0x5
     10a:	f7250513          	addi	a0,a0,-142 # 5078 <malloc+0x164>
     10e:	54d040ef          	jal	ra,4e5a <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	125040ef          	jal	ra,4a38 <exit>

0000000000000118 <truncate2>:
{
     118:	7179                	addi	sp,sp,-48
     11a:	f406                	sd	ra,40(sp)
     11c:	f022                	sd	s0,32(sp)
     11e:	ec26                	sd	s1,24(sp)
     120:	e84a                	sd	s2,16(sp)
     122:	e44e                	sd	s3,8(sp)
     124:	1800                	addi	s0,sp,48
     126:	89aa                	mv	s3,a0
  unlink("truncfile");
     128:	00005517          	auipc	a0,0x5
     12c:	f7850513          	addi	a0,a0,-136 # 50a0 <malloc+0x18c>
     130:	159040ef          	jal	ra,4a88 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     134:	60100593          	li	a1,1537
     138:	00005517          	auipc	a0,0x5
     13c:	f6850513          	addi	a0,a0,-152 # 50a0 <malloc+0x18c>
     140:	139040ef          	jal	ra,4a78 <open>
     144:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     146:	4611                	li	a2,4
     148:	00005597          	auipc	a1,0x5
     14c:	f6858593          	addi	a1,a1,-152 # 50b0 <malloc+0x19c>
     150:	109040ef          	jal	ra,4a58 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     154:	40100593          	li	a1,1025
     158:	00005517          	auipc	a0,0x5
     15c:	f4850513          	addi	a0,a0,-184 # 50a0 <malloc+0x18c>
     160:	119040ef          	jal	ra,4a78 <open>
     164:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     166:	4605                	li	a2,1
     168:	00005597          	auipc	a1,0x5
     16c:	f5058593          	addi	a1,a1,-176 # 50b8 <malloc+0x1a4>
     170:	8526                	mv	a0,s1
     172:	0e7040ef          	jal	ra,4a58 <write>
  if(n != -1){
     176:	57fd                	li	a5,-1
     178:	02f51563          	bne	a0,a5,1a2 <truncate2+0x8a>
  unlink("truncfile");
     17c:	00005517          	auipc	a0,0x5
     180:	f2450513          	addi	a0,a0,-220 # 50a0 <malloc+0x18c>
     184:	105040ef          	jal	ra,4a88 <unlink>
  close(fd1);
     188:	8526                	mv	a0,s1
     18a:	0d7040ef          	jal	ra,4a60 <close>
  close(fd2);
     18e:	854a                	mv	a0,s2
     190:	0d1040ef          	jal	ra,4a60 <close>
}
     194:	70a2                	ld	ra,40(sp)
     196:	7402                	ld	s0,32(sp)
     198:	64e2                	ld	s1,24(sp)
     19a:	6942                	ld	s2,16(sp)
     19c:	69a2                	ld	s3,8(sp)
     19e:	6145                	addi	sp,sp,48
     1a0:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a2:	862a                	mv	a2,a0
     1a4:	85ce                	mv	a1,s3
     1a6:	00005517          	auipc	a0,0x5
     1aa:	f1a50513          	addi	a0,a0,-230 # 50c0 <malloc+0x1ac>
     1ae:	4ad040ef          	jal	ra,4e5a <printf>
    exit(1);
     1b2:	4505                	li	a0,1
     1b4:	085040ef          	jal	ra,4a38 <exit>

00000000000001b8 <createtest>:
{
     1b8:	7179                	addi	sp,sp,-48
     1ba:	f406                	sd	ra,40(sp)
     1bc:	f022                	sd	s0,32(sp)
     1be:	ec26                	sd	s1,24(sp)
     1c0:	e84a                	sd	s2,16(sp)
     1c2:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1c4:	06100793          	li	a5,97
     1c8:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1cc:	fc040d23          	sb	zero,-38(s0)
     1d0:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     1d4:	06400913          	li	s2,100
    name[1] = '0' + i;
     1d8:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     1dc:	20200593          	li	a1,514
     1e0:	fd840513          	addi	a0,s0,-40
     1e4:	095040ef          	jal	ra,4a78 <open>
    close(fd);
     1e8:	079040ef          	jal	ra,4a60 <close>
  for(i = 0; i < N; i++){
     1ec:	2485                	addiw	s1,s1,1
     1ee:	0ff4f493          	andi	s1,s1,255
     1f2:	ff2493e3          	bne	s1,s2,1d8 <createtest+0x20>
  name[0] = 'a';
     1f6:	06100793          	li	a5,97
     1fa:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1fe:	fc040d23          	sb	zero,-38(s0)
     202:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     206:	06400913          	li	s2,100
    name[1] = '0' + i;
     20a:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     20e:	fd840513          	addi	a0,s0,-40
     212:	077040ef          	jal	ra,4a88 <unlink>
  for(i = 0; i < N; i++){
     216:	2485                	addiw	s1,s1,1
     218:	0ff4f493          	andi	s1,s1,255
     21c:	ff2497e3          	bne	s1,s2,20a <createtest+0x52>
}
     220:	70a2                	ld	ra,40(sp)
     222:	7402                	ld	s0,32(sp)
     224:	64e2                	ld	s1,24(sp)
     226:	6942                	ld	s2,16(sp)
     228:	6145                	addi	sp,sp,48
     22a:	8082                	ret

000000000000022c <bigwrite>:
{
     22c:	715d                	addi	sp,sp,-80
     22e:	e486                	sd	ra,72(sp)
     230:	e0a2                	sd	s0,64(sp)
     232:	fc26                	sd	s1,56(sp)
     234:	f84a                	sd	s2,48(sp)
     236:	f44e                	sd	s3,40(sp)
     238:	f052                	sd	s4,32(sp)
     23a:	ec56                	sd	s5,24(sp)
     23c:	e85a                	sd	s6,16(sp)
     23e:	e45e                	sd	s7,8(sp)
     240:	0880                	addi	s0,sp,80
     242:	8baa                	mv	s7,a0
  unlink("bigwrite");
     244:	00005517          	auipc	a0,0x5
     248:	ea450513          	addi	a0,a0,-348 # 50e8 <malloc+0x1d4>
     24c:	03d040ef          	jal	ra,4a88 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     250:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     254:	00005a97          	auipc	s5,0x5
     258:	e94a8a93          	addi	s5,s5,-364 # 50e8 <malloc+0x1d4>
      int cc = write(fd, buf, sz);
     25c:	0000ca17          	auipc	s4,0xc
     260:	a1ca0a13          	addi	s4,s4,-1508 # bc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     264:	6b0d                	lui	s6,0x3
     266:	1c9b0b13          	addi	s6,s6,457 # 31c9 <rmdot+0x4f>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26a:	20200593          	li	a1,514
     26e:	8556                	mv	a0,s5
     270:	009040ef          	jal	ra,4a78 <open>
     274:	892a                	mv	s2,a0
    if(fd < 0){
     276:	04054563          	bltz	a0,2c0 <bigwrite+0x94>
      int cc = write(fd, buf, sz);
     27a:	8626                	mv	a2,s1
     27c:	85d2                	mv	a1,s4
     27e:	7da040ef          	jal	ra,4a58 <write>
     282:	89aa                	mv	s3,a0
      if(cc != sz){
     284:	04a49a63          	bne	s1,a0,2d8 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     288:	8626                	mv	a2,s1
     28a:	85d2                	mv	a1,s4
     28c:	854a                	mv	a0,s2
     28e:	7ca040ef          	jal	ra,4a58 <write>
      if(cc != sz){
     292:	04951163          	bne	a0,s1,2d4 <bigwrite+0xa8>
    close(fd);
     296:	854a                	mv	a0,s2
     298:	7c8040ef          	jal	ra,4a60 <close>
    unlink("bigwrite");
     29c:	8556                	mv	a0,s5
     29e:	7ea040ef          	jal	ra,4a88 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a2:	1d74849b          	addiw	s1,s1,471
     2a6:	fd6492e3          	bne	s1,s6,26a <bigwrite+0x3e>
}
     2aa:	60a6                	ld	ra,72(sp)
     2ac:	6406                	ld	s0,64(sp)
     2ae:	74e2                	ld	s1,56(sp)
     2b0:	7942                	ld	s2,48(sp)
     2b2:	79a2                	ld	s3,40(sp)
     2b4:	7a02                	ld	s4,32(sp)
     2b6:	6ae2                	ld	s5,24(sp)
     2b8:	6b42                	ld	s6,16(sp)
     2ba:	6ba2                	ld	s7,8(sp)
     2bc:	6161                	addi	sp,sp,80
     2be:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2c0:	85de                	mv	a1,s7
     2c2:	00005517          	auipc	a0,0x5
     2c6:	e3650513          	addi	a0,a0,-458 # 50f8 <malloc+0x1e4>
     2ca:	391040ef          	jal	ra,4e5a <printf>
      exit(1);
     2ce:	4505                	li	a0,1
     2d0:	768040ef          	jal	ra,4a38 <exit>
     2d4:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     2d6:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2d8:	86ce                	mv	a3,s3
     2da:	8626                	mv	a2,s1
     2dc:	85de                	mv	a1,s7
     2de:	00005517          	auipc	a0,0x5
     2e2:	e3a50513          	addi	a0,a0,-454 # 5118 <malloc+0x204>
     2e6:	375040ef          	jal	ra,4e5a <printf>
        exit(1);
     2ea:	4505                	li	a0,1
     2ec:	74c040ef          	jal	ra,4a38 <exit>

00000000000002f0 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     2f0:	7179                	addi	sp,sp,-48
     2f2:	f406                	sd	ra,40(sp)
     2f4:	f022                	sd	s0,32(sp)
     2f6:	ec26                	sd	s1,24(sp)
     2f8:	e84a                	sd	s2,16(sp)
     2fa:	e44e                	sd	s3,8(sp)
     2fc:	e052                	sd	s4,0(sp)
     2fe:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     300:	00005517          	auipc	a0,0x5
     304:	e3050513          	addi	a0,a0,-464 # 5130 <malloc+0x21c>
     308:	780040ef          	jal	ra,4a88 <unlink>
     30c:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     310:	00005997          	auipc	s3,0x5
     314:	e2098993          	addi	s3,s3,-480 # 5130 <malloc+0x21c>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     318:	5a7d                	li	s4,-1
     31a:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     31e:	20100593          	li	a1,513
     322:	854e                	mv	a0,s3
     324:	754040ef          	jal	ra,4a78 <open>
     328:	84aa                	mv	s1,a0
    if(fd < 0){
     32a:	04054d63          	bltz	a0,384 <badwrite+0x94>
    write(fd, (char*)0xffffffffffL, 1);
     32e:	4605                	li	a2,1
     330:	85d2                	mv	a1,s4
     332:	726040ef          	jal	ra,4a58 <write>
    close(fd);
     336:	8526                	mv	a0,s1
     338:	728040ef          	jal	ra,4a60 <close>
    unlink("junk");
     33c:	854e                	mv	a0,s3
     33e:	74a040ef          	jal	ra,4a88 <unlink>
  for(int i = 0; i < assumed_free; i++){
     342:	397d                	addiw	s2,s2,-1
     344:	fc091de3          	bnez	s2,31e <badwrite+0x2e>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     348:	20100593          	li	a1,513
     34c:	00005517          	auipc	a0,0x5
     350:	de450513          	addi	a0,a0,-540 # 5130 <malloc+0x21c>
     354:	724040ef          	jal	ra,4a78 <open>
     358:	84aa                	mv	s1,a0
  if(fd < 0){
     35a:	02054e63          	bltz	a0,396 <badwrite+0xa6>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     35e:	4605                	li	a2,1
     360:	00005597          	auipc	a1,0x5
     364:	d5858593          	addi	a1,a1,-680 # 50b8 <malloc+0x1a4>
     368:	6f0040ef          	jal	ra,4a58 <write>
     36c:	4785                	li	a5,1
     36e:	02f50d63          	beq	a0,a5,3a8 <badwrite+0xb8>
    printf("write failed\n");
     372:	00005517          	auipc	a0,0x5
     376:	dde50513          	addi	a0,a0,-546 # 5150 <malloc+0x23c>
     37a:	2e1040ef          	jal	ra,4e5a <printf>
    exit(1);
     37e:	4505                	li	a0,1
     380:	6b8040ef          	jal	ra,4a38 <exit>
      printf("open junk failed\n");
     384:	00005517          	auipc	a0,0x5
     388:	db450513          	addi	a0,a0,-588 # 5138 <malloc+0x224>
     38c:	2cf040ef          	jal	ra,4e5a <printf>
      exit(1);
     390:	4505                	li	a0,1
     392:	6a6040ef          	jal	ra,4a38 <exit>
    printf("open junk failed\n");
     396:	00005517          	auipc	a0,0x5
     39a:	da250513          	addi	a0,a0,-606 # 5138 <malloc+0x224>
     39e:	2bd040ef          	jal	ra,4e5a <printf>
    exit(1);
     3a2:	4505                	li	a0,1
     3a4:	694040ef          	jal	ra,4a38 <exit>
  }
  close(fd);
     3a8:	8526                	mv	a0,s1
     3aa:	6b6040ef          	jal	ra,4a60 <close>
  unlink("junk");
     3ae:	00005517          	auipc	a0,0x5
     3b2:	d8250513          	addi	a0,a0,-638 # 5130 <malloc+0x21c>
     3b6:	6d2040ef          	jal	ra,4a88 <unlink>

  exit(0);
     3ba:	4501                	li	a0,0
     3bc:	67c040ef          	jal	ra,4a38 <exit>

00000000000003c0 <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3c0:	715d                	addi	sp,sp,-80
     3c2:	e486                	sd	ra,72(sp)
     3c4:	e0a2                	sd	s0,64(sp)
     3c6:	fc26                	sd	s1,56(sp)
     3c8:	f84a                	sd	s2,48(sp)
     3ca:	f44e                	sd	s3,40(sp)
     3cc:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     3ce:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3d0:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     3d4:	40000993          	li	s3,1024
    name[0] = 'z';
     3d8:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     3dc:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     3e0:	41f4d79b          	sraiw	a5,s1,0x1f
     3e4:	01b7d71b          	srliw	a4,a5,0x1b
     3e8:	009707bb          	addw	a5,a4,s1
     3ec:	4057d69b          	sraiw	a3,a5,0x5
     3f0:	0306869b          	addiw	a3,a3,48
     3f4:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     3f8:	8bfd                	andi	a5,a5,31
     3fa:	9f99                	subw	a5,a5,a4
     3fc:	0307879b          	addiw	a5,a5,48
     400:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     404:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     408:	fb040513          	addi	a0,s0,-80
     40c:	67c040ef          	jal	ra,4a88 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     410:	60200593          	li	a1,1538
     414:	fb040513          	addi	a0,s0,-80
     418:	660040ef          	jal	ra,4a78 <open>
    if(fd < 0){
     41c:	00054763          	bltz	a0,42a <outofinodes+0x6a>
      // failure is eventually expected.
      break;
    }
    close(fd);
     420:	640040ef          	jal	ra,4a60 <close>
  for(int i = 0; i < nzz; i++){
     424:	2485                	addiw	s1,s1,1
     426:	fb3499e3          	bne	s1,s3,3d8 <outofinodes+0x18>
     42a:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     42c:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     430:	40000993          	li	s3,1024
    name[0] = 'z';
     434:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     438:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     43c:	41f4d79b          	sraiw	a5,s1,0x1f
     440:	01b7d71b          	srliw	a4,a5,0x1b
     444:	009707bb          	addw	a5,a4,s1
     448:	4057d69b          	sraiw	a3,a5,0x5
     44c:	0306869b          	addiw	a3,a3,48
     450:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     454:	8bfd                	andi	a5,a5,31
     456:	9f99                	subw	a5,a5,a4
     458:	0307879b          	addiw	a5,a5,48
     45c:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     460:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     464:	fb040513          	addi	a0,s0,-80
     468:	620040ef          	jal	ra,4a88 <unlink>
  for(int i = 0; i < nzz; i++){
     46c:	2485                	addiw	s1,s1,1
     46e:	fd3493e3          	bne	s1,s3,434 <outofinodes+0x74>
  }
}
     472:	60a6                	ld	ra,72(sp)
     474:	6406                	ld	s0,64(sp)
     476:	74e2                	ld	s1,56(sp)
     478:	7942                	ld	s2,48(sp)
     47a:	79a2                	ld	s3,40(sp)
     47c:	6161                	addi	sp,sp,80
     47e:	8082                	ret

0000000000000480 <copyin>:
{
     480:	7159                	addi	sp,sp,-112
     482:	f486                	sd	ra,104(sp)
     484:	f0a2                	sd	s0,96(sp)
     486:	eca6                	sd	s1,88(sp)
     488:	e8ca                	sd	s2,80(sp)
     48a:	e4ce                	sd	s3,72(sp)
     48c:	e0d2                	sd	s4,64(sp)
     48e:	fc56                	sd	s5,56(sp)
     490:	1880                	addi	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     492:	00007797          	auipc	a5,0x7
     496:	eee78793          	addi	a5,a5,-274 # 7380 <malloc+0x246c>
     49a:	638c                	ld	a1,0(a5)
     49c:	6790                	ld	a2,8(a5)
     49e:	6b94                	ld	a3,16(a5)
     4a0:	6f98                	ld	a4,24(a5)
     4a2:	739c                	ld	a5,32(a5)
     4a4:	f8b43c23          	sd	a1,-104(s0)
     4a8:	fac43023          	sd	a2,-96(s0)
     4ac:	fad43423          	sd	a3,-88(s0)
     4b0:	fae43823          	sd	a4,-80(s0)
     4b4:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     4b8:	f9840913          	addi	s2,s0,-104
     4bc:	fc040a93          	addi	s5,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4c0:	00005a17          	auipc	s4,0x5
     4c4:	ca0a0a13          	addi	s4,s4,-864 # 5160 <malloc+0x24c>
    uint64 addr = addrs[ai];
     4c8:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4cc:	20100593          	li	a1,513
     4d0:	8552                	mv	a0,s4
     4d2:	5a6040ef          	jal	ra,4a78 <open>
     4d6:	84aa                	mv	s1,a0
    if(fd < 0){
     4d8:	06054763          	bltz	a0,546 <copyin+0xc6>
    int n = write(fd, (void*)addr, 8192);
     4dc:	6609                	lui	a2,0x2
     4de:	85ce                	mv	a1,s3
     4e0:	578040ef          	jal	ra,4a58 <write>
    if(n >= 0){
     4e4:	06055a63          	bgez	a0,558 <copyin+0xd8>
    close(fd);
     4e8:	8526                	mv	a0,s1
     4ea:	576040ef          	jal	ra,4a60 <close>
    unlink("copyin1");
     4ee:	8552                	mv	a0,s4
     4f0:	598040ef          	jal	ra,4a88 <unlink>
    n = write(1, (char*)addr, 8192);
     4f4:	6609                	lui	a2,0x2
     4f6:	85ce                	mv	a1,s3
     4f8:	4505                	li	a0,1
     4fa:	55e040ef          	jal	ra,4a58 <write>
    if(n > 0){
     4fe:	06a04863          	bgtz	a0,56e <copyin+0xee>
    if(pipe(fds) < 0){
     502:	f9040513          	addi	a0,s0,-112
     506:	542040ef          	jal	ra,4a48 <pipe>
     50a:	06054d63          	bltz	a0,584 <copyin+0x104>
    n = write(fds[1], (char*)addr, 8192);
     50e:	6609                	lui	a2,0x2
     510:	85ce                	mv	a1,s3
     512:	f9442503          	lw	a0,-108(s0)
     516:	542040ef          	jal	ra,4a58 <write>
    if(n > 0){
     51a:	06a04e63          	bgtz	a0,596 <copyin+0x116>
    close(fds[0]);
     51e:	f9042503          	lw	a0,-112(s0)
     522:	53e040ef          	jal	ra,4a60 <close>
    close(fds[1]);
     526:	f9442503          	lw	a0,-108(s0)
     52a:	536040ef          	jal	ra,4a60 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     52e:	0921                	addi	s2,s2,8
     530:	f9591ce3          	bne	s2,s5,4c8 <copyin+0x48>
}
     534:	70a6                	ld	ra,104(sp)
     536:	7406                	ld	s0,96(sp)
     538:	64e6                	ld	s1,88(sp)
     53a:	6946                	ld	s2,80(sp)
     53c:	69a6                	ld	s3,72(sp)
     53e:	6a06                	ld	s4,64(sp)
     540:	7ae2                	ld	s5,56(sp)
     542:	6165                	addi	sp,sp,112
     544:	8082                	ret
      printf("open(copyin1) failed\n");
     546:	00005517          	auipc	a0,0x5
     54a:	c2250513          	addi	a0,a0,-990 # 5168 <malloc+0x254>
     54e:	10d040ef          	jal	ra,4e5a <printf>
      exit(1);
     552:	4505                	li	a0,1
     554:	4e4040ef          	jal	ra,4a38 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     558:	862a                	mv	a2,a0
     55a:	85ce                	mv	a1,s3
     55c:	00005517          	auipc	a0,0x5
     560:	c2450513          	addi	a0,a0,-988 # 5180 <malloc+0x26c>
     564:	0f7040ef          	jal	ra,4e5a <printf>
      exit(1);
     568:	4505                	li	a0,1
     56a:	4ce040ef          	jal	ra,4a38 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     56e:	862a                	mv	a2,a0
     570:	85ce                	mv	a1,s3
     572:	00005517          	auipc	a0,0x5
     576:	c3e50513          	addi	a0,a0,-962 # 51b0 <malloc+0x29c>
     57a:	0e1040ef          	jal	ra,4e5a <printf>
      exit(1);
     57e:	4505                	li	a0,1
     580:	4b8040ef          	jal	ra,4a38 <exit>
      printf("pipe() failed\n");
     584:	00005517          	auipc	a0,0x5
     588:	c5c50513          	addi	a0,a0,-932 # 51e0 <malloc+0x2cc>
     58c:	0cf040ef          	jal	ra,4e5a <printf>
      exit(1);
     590:	4505                	li	a0,1
     592:	4a6040ef          	jal	ra,4a38 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     596:	862a                	mv	a2,a0
     598:	85ce                	mv	a1,s3
     59a:	00005517          	auipc	a0,0x5
     59e:	c5650513          	addi	a0,a0,-938 # 51f0 <malloc+0x2dc>
     5a2:	0b9040ef          	jal	ra,4e5a <printf>
      exit(1);
     5a6:	4505                	li	a0,1
     5a8:	490040ef          	jal	ra,4a38 <exit>

00000000000005ac <copyout>:
{
     5ac:	7119                	addi	sp,sp,-128
     5ae:	fc86                	sd	ra,120(sp)
     5b0:	f8a2                	sd	s0,112(sp)
     5b2:	f4a6                	sd	s1,104(sp)
     5b4:	f0ca                	sd	s2,96(sp)
     5b6:	ecce                	sd	s3,88(sp)
     5b8:	e8d2                	sd	s4,80(sp)
     5ba:	e4d6                	sd	s5,72(sp)
     5bc:	e0da                	sd	s6,64(sp)
     5be:	0100                	addi	s0,sp,128
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     5c0:	00007797          	auipc	a5,0x7
     5c4:	dc078793          	addi	a5,a5,-576 # 7380 <malloc+0x246c>
     5c8:	7788                	ld	a0,40(a5)
     5ca:	7b8c                	ld	a1,48(a5)
     5cc:	7f90                	ld	a2,56(a5)
     5ce:	63b4                	ld	a3,64(a5)
     5d0:	67b8                	ld	a4,72(a5)
     5d2:	6bbc                	ld	a5,80(a5)
     5d4:	f8a43823          	sd	a0,-112(s0)
     5d8:	f8b43c23          	sd	a1,-104(s0)
     5dc:	fac43023          	sd	a2,-96(s0)
     5e0:	fad43423          	sd	a3,-88(s0)
     5e4:	fae43823          	sd	a4,-80(s0)
     5e8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     5ec:	f9040913          	addi	s2,s0,-112
     5f0:	fc040b13          	addi	s6,s0,-64
    int fd = open("README", 0);
     5f4:	00005a17          	auipc	s4,0x5
     5f8:	c2ca0a13          	addi	s4,s4,-980 # 5220 <malloc+0x30c>
    n = write(fds[1], "x", 1);
     5fc:	00005a97          	auipc	s5,0x5
     600:	abca8a93          	addi	s5,s5,-1348 # 50b8 <malloc+0x1a4>
    uint64 addr = addrs[ai];
     604:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     608:	4581                	li	a1,0
     60a:	8552                	mv	a0,s4
     60c:	46c040ef          	jal	ra,4a78 <open>
     610:	84aa                	mv	s1,a0
    if(fd < 0){
     612:	06054763          	bltz	a0,680 <copyout+0xd4>
    int n = read(fd, (void*)addr, 8192);
     616:	6609                	lui	a2,0x2
     618:	85ce                	mv	a1,s3
     61a:	436040ef          	jal	ra,4a50 <read>
    if(n > 0){
     61e:	06a04a63          	bgtz	a0,692 <copyout+0xe6>
    close(fd);
     622:	8526                	mv	a0,s1
     624:	43c040ef          	jal	ra,4a60 <close>
    if(pipe(fds) < 0){
     628:	f8840513          	addi	a0,s0,-120
     62c:	41c040ef          	jal	ra,4a48 <pipe>
     630:	06054c63          	bltz	a0,6a8 <copyout+0xfc>
    n = write(fds[1], "x", 1);
     634:	4605                	li	a2,1
     636:	85d6                	mv	a1,s5
     638:	f8c42503          	lw	a0,-116(s0)
     63c:	41c040ef          	jal	ra,4a58 <write>
    if(n != 1){
     640:	4785                	li	a5,1
     642:	06f51c63          	bne	a0,a5,6ba <copyout+0x10e>
    n = read(fds[0], (void*)addr, 8192);
     646:	6609                	lui	a2,0x2
     648:	85ce                	mv	a1,s3
     64a:	f8842503          	lw	a0,-120(s0)
     64e:	402040ef          	jal	ra,4a50 <read>
    if(n > 0){
     652:	06a04d63          	bgtz	a0,6cc <copyout+0x120>
    close(fds[0]);
     656:	f8842503          	lw	a0,-120(s0)
     65a:	406040ef          	jal	ra,4a60 <close>
    close(fds[1]);
     65e:	f8c42503          	lw	a0,-116(s0)
     662:	3fe040ef          	jal	ra,4a60 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     666:	0921                	addi	s2,s2,8
     668:	f9691ee3          	bne	s2,s6,604 <copyout+0x58>
}
     66c:	70e6                	ld	ra,120(sp)
     66e:	7446                	ld	s0,112(sp)
     670:	74a6                	ld	s1,104(sp)
     672:	7906                	ld	s2,96(sp)
     674:	69e6                	ld	s3,88(sp)
     676:	6a46                	ld	s4,80(sp)
     678:	6aa6                	ld	s5,72(sp)
     67a:	6b06                	ld	s6,64(sp)
     67c:	6109                	addi	sp,sp,128
     67e:	8082                	ret
      printf("open(README) failed\n");
     680:	00005517          	auipc	a0,0x5
     684:	ba850513          	addi	a0,a0,-1112 # 5228 <malloc+0x314>
     688:	7d2040ef          	jal	ra,4e5a <printf>
      exit(1);
     68c:	4505                	li	a0,1
     68e:	3aa040ef          	jal	ra,4a38 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     692:	862a                	mv	a2,a0
     694:	85ce                	mv	a1,s3
     696:	00005517          	auipc	a0,0x5
     69a:	baa50513          	addi	a0,a0,-1110 # 5240 <malloc+0x32c>
     69e:	7bc040ef          	jal	ra,4e5a <printf>
      exit(1);
     6a2:	4505                	li	a0,1
     6a4:	394040ef          	jal	ra,4a38 <exit>
      printf("pipe() failed\n");
     6a8:	00005517          	auipc	a0,0x5
     6ac:	b3850513          	addi	a0,a0,-1224 # 51e0 <malloc+0x2cc>
     6b0:	7aa040ef          	jal	ra,4e5a <printf>
      exit(1);
     6b4:	4505                	li	a0,1
     6b6:	382040ef          	jal	ra,4a38 <exit>
      printf("pipe write failed\n");
     6ba:	00005517          	auipc	a0,0x5
     6be:	bb650513          	addi	a0,a0,-1098 # 5270 <malloc+0x35c>
     6c2:	798040ef          	jal	ra,4e5a <printf>
      exit(1);
     6c6:	4505                	li	a0,1
     6c8:	370040ef          	jal	ra,4a38 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6cc:	862a                	mv	a2,a0
     6ce:	85ce                	mv	a1,s3
     6d0:	00005517          	auipc	a0,0x5
     6d4:	bb850513          	addi	a0,a0,-1096 # 5288 <malloc+0x374>
     6d8:	782040ef          	jal	ra,4e5a <printf>
      exit(1);
     6dc:	4505                	li	a0,1
     6de:	35a040ef          	jal	ra,4a38 <exit>

00000000000006e2 <truncate1>:
{
     6e2:	711d                	addi	sp,sp,-96
     6e4:	ec86                	sd	ra,88(sp)
     6e6:	e8a2                	sd	s0,80(sp)
     6e8:	e4a6                	sd	s1,72(sp)
     6ea:	e0ca                	sd	s2,64(sp)
     6ec:	fc4e                	sd	s3,56(sp)
     6ee:	f852                	sd	s4,48(sp)
     6f0:	f456                	sd	s5,40(sp)
     6f2:	1080                	addi	s0,sp,96
     6f4:	8aaa                	mv	s5,a0
  unlink("truncfile");
     6f6:	00005517          	auipc	a0,0x5
     6fa:	9aa50513          	addi	a0,a0,-1622 # 50a0 <malloc+0x18c>
     6fe:	38a040ef          	jal	ra,4a88 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     702:	60100593          	li	a1,1537
     706:	00005517          	auipc	a0,0x5
     70a:	99a50513          	addi	a0,a0,-1638 # 50a0 <malloc+0x18c>
     70e:	36a040ef          	jal	ra,4a78 <open>
     712:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     714:	4611                	li	a2,4
     716:	00005597          	auipc	a1,0x5
     71a:	99a58593          	addi	a1,a1,-1638 # 50b0 <malloc+0x19c>
     71e:	33a040ef          	jal	ra,4a58 <write>
  close(fd1);
     722:	8526                	mv	a0,s1
     724:	33c040ef          	jal	ra,4a60 <close>
  int fd2 = open("truncfile", O_RDONLY);
     728:	4581                	li	a1,0
     72a:	00005517          	auipc	a0,0x5
     72e:	97650513          	addi	a0,a0,-1674 # 50a0 <malloc+0x18c>
     732:	346040ef          	jal	ra,4a78 <open>
     736:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     738:	02000613          	li	a2,32
     73c:	fa040593          	addi	a1,s0,-96
     740:	310040ef          	jal	ra,4a50 <read>
  if(n != 4){
     744:	4791                	li	a5,4
     746:	0af51863          	bne	a0,a5,7f6 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     74a:	40100593          	li	a1,1025
     74e:	00005517          	auipc	a0,0x5
     752:	95250513          	addi	a0,a0,-1710 # 50a0 <malloc+0x18c>
     756:	322040ef          	jal	ra,4a78 <open>
     75a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     75c:	4581                	li	a1,0
     75e:	00005517          	auipc	a0,0x5
     762:	94250513          	addi	a0,a0,-1726 # 50a0 <malloc+0x18c>
     766:	312040ef          	jal	ra,4a78 <open>
     76a:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     76c:	02000613          	li	a2,32
     770:	fa040593          	addi	a1,s0,-96
     774:	2dc040ef          	jal	ra,4a50 <read>
     778:	8a2a                	mv	s4,a0
  if(n != 0){
     77a:	e949                	bnez	a0,80c <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     77c:	02000613          	li	a2,32
     780:	fa040593          	addi	a1,s0,-96
     784:	8526                	mv	a0,s1
     786:	2ca040ef          	jal	ra,4a50 <read>
     78a:	8a2a                	mv	s4,a0
  if(n != 0){
     78c:	e155                	bnez	a0,830 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     78e:	4619                	li	a2,6
     790:	00005597          	auipc	a1,0x5
     794:	b8858593          	addi	a1,a1,-1144 # 5318 <malloc+0x404>
     798:	854e                	mv	a0,s3
     79a:	2be040ef          	jal	ra,4a58 <write>
  n = read(fd3, buf, sizeof(buf));
     79e:	02000613          	li	a2,32
     7a2:	fa040593          	addi	a1,s0,-96
     7a6:	854a                	mv	a0,s2
     7a8:	2a8040ef          	jal	ra,4a50 <read>
  if(n != 6){
     7ac:	4799                	li	a5,6
     7ae:	0af51363          	bne	a0,a5,854 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     7b2:	02000613          	li	a2,32
     7b6:	fa040593          	addi	a1,s0,-96
     7ba:	8526                	mv	a0,s1
     7bc:	294040ef          	jal	ra,4a50 <read>
  if(n != 2){
     7c0:	4789                	li	a5,2
     7c2:	0af51463          	bne	a0,a5,86a <truncate1+0x188>
  unlink("truncfile");
     7c6:	00005517          	auipc	a0,0x5
     7ca:	8da50513          	addi	a0,a0,-1830 # 50a0 <malloc+0x18c>
     7ce:	2ba040ef          	jal	ra,4a88 <unlink>
  close(fd1);
     7d2:	854e                	mv	a0,s3
     7d4:	28c040ef          	jal	ra,4a60 <close>
  close(fd2);
     7d8:	8526                	mv	a0,s1
     7da:	286040ef          	jal	ra,4a60 <close>
  close(fd3);
     7de:	854a                	mv	a0,s2
     7e0:	280040ef          	jal	ra,4a60 <close>
}
     7e4:	60e6                	ld	ra,88(sp)
     7e6:	6446                	ld	s0,80(sp)
     7e8:	64a6                	ld	s1,72(sp)
     7ea:	6906                	ld	s2,64(sp)
     7ec:	79e2                	ld	s3,56(sp)
     7ee:	7a42                	ld	s4,48(sp)
     7f0:	7aa2                	ld	s5,40(sp)
     7f2:	6125                	addi	sp,sp,96
     7f4:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     7f6:	862a                	mv	a2,a0
     7f8:	85d6                	mv	a1,s5
     7fa:	00005517          	auipc	a0,0x5
     7fe:	abe50513          	addi	a0,a0,-1346 # 52b8 <malloc+0x3a4>
     802:	658040ef          	jal	ra,4e5a <printf>
    exit(1);
     806:	4505                	li	a0,1
     808:	230040ef          	jal	ra,4a38 <exit>
    printf("aaa fd3=%d\n", fd3);
     80c:	85ca                	mv	a1,s2
     80e:	00005517          	auipc	a0,0x5
     812:	aca50513          	addi	a0,a0,-1334 # 52d8 <malloc+0x3c4>
     816:	644040ef          	jal	ra,4e5a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     81a:	8652                	mv	a2,s4
     81c:	85d6                	mv	a1,s5
     81e:	00005517          	auipc	a0,0x5
     822:	aca50513          	addi	a0,a0,-1334 # 52e8 <malloc+0x3d4>
     826:	634040ef          	jal	ra,4e5a <printf>
    exit(1);
     82a:	4505                	li	a0,1
     82c:	20c040ef          	jal	ra,4a38 <exit>
    printf("bbb fd2=%d\n", fd2);
     830:	85a6                	mv	a1,s1
     832:	00005517          	auipc	a0,0x5
     836:	ad650513          	addi	a0,a0,-1322 # 5308 <malloc+0x3f4>
     83a:	620040ef          	jal	ra,4e5a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     83e:	8652                	mv	a2,s4
     840:	85d6                	mv	a1,s5
     842:	00005517          	auipc	a0,0x5
     846:	aa650513          	addi	a0,a0,-1370 # 52e8 <malloc+0x3d4>
     84a:	610040ef          	jal	ra,4e5a <printf>
    exit(1);
     84e:	4505                	li	a0,1
     850:	1e8040ef          	jal	ra,4a38 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     854:	862a                	mv	a2,a0
     856:	85d6                	mv	a1,s5
     858:	00005517          	auipc	a0,0x5
     85c:	ac850513          	addi	a0,a0,-1336 # 5320 <malloc+0x40c>
     860:	5fa040ef          	jal	ra,4e5a <printf>
    exit(1);
     864:	4505                	li	a0,1
     866:	1d2040ef          	jal	ra,4a38 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     86a:	862a                	mv	a2,a0
     86c:	85d6                	mv	a1,s5
     86e:	00005517          	auipc	a0,0x5
     872:	ad250513          	addi	a0,a0,-1326 # 5340 <malloc+0x42c>
     876:	5e4040ef          	jal	ra,4e5a <printf>
    exit(1);
     87a:	4505                	li	a0,1
     87c:	1bc040ef          	jal	ra,4a38 <exit>

0000000000000880 <writetest>:
{
     880:	7139                	addi	sp,sp,-64
     882:	fc06                	sd	ra,56(sp)
     884:	f822                	sd	s0,48(sp)
     886:	f426                	sd	s1,40(sp)
     888:	f04a                	sd	s2,32(sp)
     88a:	ec4e                	sd	s3,24(sp)
     88c:	e852                	sd	s4,16(sp)
     88e:	e456                	sd	s5,8(sp)
     890:	e05a                	sd	s6,0(sp)
     892:	0080                	addi	s0,sp,64
     894:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     896:	20200593          	li	a1,514
     89a:	00005517          	auipc	a0,0x5
     89e:	ac650513          	addi	a0,a0,-1338 # 5360 <malloc+0x44c>
     8a2:	1d6040ef          	jal	ra,4a78 <open>
  if(fd < 0){
     8a6:	08054f63          	bltz	a0,944 <writetest+0xc4>
     8aa:	892a                	mv	s2,a0
     8ac:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8ae:	00005997          	auipc	s3,0x5
     8b2:	ada98993          	addi	s3,s3,-1318 # 5388 <malloc+0x474>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8b6:	00005a97          	auipc	s5,0x5
     8ba:	b0aa8a93          	addi	s5,s5,-1270 # 53c0 <malloc+0x4ac>
  for(i = 0; i < N; i++){
     8be:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8c2:	4629                	li	a2,10
     8c4:	85ce                	mv	a1,s3
     8c6:	854a                	mv	a0,s2
     8c8:	190040ef          	jal	ra,4a58 <write>
     8cc:	47a9                	li	a5,10
     8ce:	08f51563          	bne	a0,a5,958 <writetest+0xd8>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8d2:	4629                	li	a2,10
     8d4:	85d6                	mv	a1,s5
     8d6:	854a                	mv	a0,s2
     8d8:	180040ef          	jal	ra,4a58 <write>
     8dc:	47a9                	li	a5,10
     8de:	08f51863          	bne	a0,a5,96e <writetest+0xee>
  for(i = 0; i < N; i++){
     8e2:	2485                	addiw	s1,s1,1
     8e4:	fd449fe3          	bne	s1,s4,8c2 <writetest+0x42>
  close(fd);
     8e8:	854a                	mv	a0,s2
     8ea:	176040ef          	jal	ra,4a60 <close>
  fd = open("small", O_RDONLY);
     8ee:	4581                	li	a1,0
     8f0:	00005517          	auipc	a0,0x5
     8f4:	a7050513          	addi	a0,a0,-1424 # 5360 <malloc+0x44c>
     8f8:	180040ef          	jal	ra,4a78 <open>
     8fc:	84aa                	mv	s1,a0
  if(fd < 0){
     8fe:	08054363          	bltz	a0,984 <writetest+0x104>
  i = read(fd, buf, N*SZ*2);
     902:	7d000613          	li	a2,2000
     906:	0000b597          	auipc	a1,0xb
     90a:	37258593          	addi	a1,a1,882 # bc78 <buf>
     90e:	142040ef          	jal	ra,4a50 <read>
  if(i != N*SZ*2){
     912:	7d000793          	li	a5,2000
     916:	08f51163          	bne	a0,a5,998 <writetest+0x118>
  close(fd);
     91a:	8526                	mv	a0,s1
     91c:	144040ef          	jal	ra,4a60 <close>
  if(unlink("small") < 0){
     920:	00005517          	auipc	a0,0x5
     924:	a4050513          	addi	a0,a0,-1472 # 5360 <malloc+0x44c>
     928:	160040ef          	jal	ra,4a88 <unlink>
     92c:	08054063          	bltz	a0,9ac <writetest+0x12c>
}
     930:	70e2                	ld	ra,56(sp)
     932:	7442                	ld	s0,48(sp)
     934:	74a2                	ld	s1,40(sp)
     936:	7902                	ld	s2,32(sp)
     938:	69e2                	ld	s3,24(sp)
     93a:	6a42                	ld	s4,16(sp)
     93c:	6aa2                	ld	s5,8(sp)
     93e:	6b02                	ld	s6,0(sp)
     940:	6121                	addi	sp,sp,64
     942:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     944:	85da                	mv	a1,s6
     946:	00005517          	auipc	a0,0x5
     94a:	a2250513          	addi	a0,a0,-1502 # 5368 <malloc+0x454>
     94e:	50c040ef          	jal	ra,4e5a <printf>
    exit(1);
     952:	4505                	li	a0,1
     954:	0e4040ef          	jal	ra,4a38 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     958:	8626                	mv	a2,s1
     95a:	85da                	mv	a1,s6
     95c:	00005517          	auipc	a0,0x5
     960:	a3c50513          	addi	a0,a0,-1476 # 5398 <malloc+0x484>
     964:	4f6040ef          	jal	ra,4e5a <printf>
      exit(1);
     968:	4505                	li	a0,1
     96a:	0ce040ef          	jal	ra,4a38 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     96e:	8626                	mv	a2,s1
     970:	85da                	mv	a1,s6
     972:	00005517          	auipc	a0,0x5
     976:	a5e50513          	addi	a0,a0,-1442 # 53d0 <malloc+0x4bc>
     97a:	4e0040ef          	jal	ra,4e5a <printf>
      exit(1);
     97e:	4505                	li	a0,1
     980:	0b8040ef          	jal	ra,4a38 <exit>
    printf("%s: error: open small failed!\n", s);
     984:	85da                	mv	a1,s6
     986:	00005517          	auipc	a0,0x5
     98a:	a7250513          	addi	a0,a0,-1422 # 53f8 <malloc+0x4e4>
     98e:	4cc040ef          	jal	ra,4e5a <printf>
    exit(1);
     992:	4505                	li	a0,1
     994:	0a4040ef          	jal	ra,4a38 <exit>
    printf("%s: read failed\n", s);
     998:	85da                	mv	a1,s6
     99a:	00005517          	auipc	a0,0x5
     99e:	a7e50513          	addi	a0,a0,-1410 # 5418 <malloc+0x504>
     9a2:	4b8040ef          	jal	ra,4e5a <printf>
    exit(1);
     9a6:	4505                	li	a0,1
     9a8:	090040ef          	jal	ra,4a38 <exit>
    printf("%s: unlink small failed\n", s);
     9ac:	85da                	mv	a1,s6
     9ae:	00005517          	auipc	a0,0x5
     9b2:	a8250513          	addi	a0,a0,-1406 # 5430 <malloc+0x51c>
     9b6:	4a4040ef          	jal	ra,4e5a <printf>
    exit(1);
     9ba:	4505                	li	a0,1
     9bc:	07c040ef          	jal	ra,4a38 <exit>

00000000000009c0 <writebig>:
{
     9c0:	7139                	addi	sp,sp,-64
     9c2:	fc06                	sd	ra,56(sp)
     9c4:	f822                	sd	s0,48(sp)
     9c6:	f426                	sd	s1,40(sp)
     9c8:	f04a                	sd	s2,32(sp)
     9ca:	ec4e                	sd	s3,24(sp)
     9cc:	e852                	sd	s4,16(sp)
     9ce:	e456                	sd	s5,8(sp)
     9d0:	0080                	addi	s0,sp,64
     9d2:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9d4:	20200593          	li	a1,514
     9d8:	00005517          	auipc	a0,0x5
     9dc:	a7850513          	addi	a0,a0,-1416 # 5450 <malloc+0x53c>
     9e0:	098040ef          	jal	ra,4a78 <open>
     9e4:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e6:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e8:	0000b917          	auipc	s2,0xb
     9ec:	29090913          	addi	s2,s2,656 # bc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     9f0:	10c00a13          	li	s4,268
  if(fd < 0){
     9f4:	06054463          	bltz	a0,a5c <writebig+0x9c>
    ((int*)buf)[0] = i;
     9f8:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9fc:	40000613          	li	a2,1024
     a00:	85ca                	mv	a1,s2
     a02:	854e                	mv	a0,s3
     a04:	054040ef          	jal	ra,4a58 <write>
     a08:	40000793          	li	a5,1024
     a0c:	06f51263          	bne	a0,a5,a70 <writebig+0xb0>
  for(i = 0; i < MAXFILE; i++){
     a10:	2485                	addiw	s1,s1,1
     a12:	ff4493e3          	bne	s1,s4,9f8 <writebig+0x38>
  close(fd);
     a16:	854e                	mv	a0,s3
     a18:	048040ef          	jal	ra,4a60 <close>
  fd = open("big", O_RDONLY);
     a1c:	4581                	li	a1,0
     a1e:	00005517          	auipc	a0,0x5
     a22:	a3250513          	addi	a0,a0,-1486 # 5450 <malloc+0x53c>
     a26:	052040ef          	jal	ra,4a78 <open>
     a2a:	89aa                	mv	s3,a0
  n = 0;
     a2c:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a2e:	0000b917          	auipc	s2,0xb
     a32:	24a90913          	addi	s2,s2,586 # bc78 <buf>
  if(fd < 0){
     a36:	04054863          	bltz	a0,a86 <writebig+0xc6>
    i = read(fd, buf, BSIZE);
     a3a:	40000613          	li	a2,1024
     a3e:	85ca                	mv	a1,s2
     a40:	854e                	mv	a0,s3
     a42:	00e040ef          	jal	ra,4a50 <read>
    if(i == 0){
     a46:	c931                	beqz	a0,a9a <writebig+0xda>
    } else if(i != BSIZE){
     a48:	40000793          	li	a5,1024
     a4c:	08f51a63          	bne	a0,a5,ae0 <writebig+0x120>
    if(((int*)buf)[0] != n){
     a50:	00092683          	lw	a3,0(s2)
     a54:	0a969163          	bne	a3,s1,af6 <writebig+0x136>
    n++;
     a58:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a5a:	b7c5                	j	a3a <writebig+0x7a>
    printf("%s: error: creat big failed!\n", s);
     a5c:	85d6                	mv	a1,s5
     a5e:	00005517          	auipc	a0,0x5
     a62:	9fa50513          	addi	a0,a0,-1542 # 5458 <malloc+0x544>
     a66:	3f4040ef          	jal	ra,4e5a <printf>
    exit(1);
     a6a:	4505                	li	a0,1
     a6c:	7cd030ef          	jal	ra,4a38 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     a70:	8626                	mv	a2,s1
     a72:	85d6                	mv	a1,s5
     a74:	00005517          	auipc	a0,0x5
     a78:	a0450513          	addi	a0,a0,-1532 # 5478 <malloc+0x564>
     a7c:	3de040ef          	jal	ra,4e5a <printf>
      exit(1);
     a80:	4505                	li	a0,1
     a82:	7b7030ef          	jal	ra,4a38 <exit>
    printf("%s: error: open big failed!\n", s);
     a86:	85d6                	mv	a1,s5
     a88:	00005517          	auipc	a0,0x5
     a8c:	a1850513          	addi	a0,a0,-1512 # 54a0 <malloc+0x58c>
     a90:	3ca040ef          	jal	ra,4e5a <printf>
    exit(1);
     a94:	4505                	li	a0,1
     a96:	7a3030ef          	jal	ra,4a38 <exit>
      if(n != MAXFILE){
     a9a:	10c00793          	li	a5,268
     a9e:	02f49663          	bne	s1,a5,aca <writebig+0x10a>
  close(fd);
     aa2:	854e                	mv	a0,s3
     aa4:	7bd030ef          	jal	ra,4a60 <close>
  if(unlink("big") < 0){
     aa8:	00005517          	auipc	a0,0x5
     aac:	9a850513          	addi	a0,a0,-1624 # 5450 <malloc+0x53c>
     ab0:	7d9030ef          	jal	ra,4a88 <unlink>
     ab4:	04054c63          	bltz	a0,b0c <writebig+0x14c>
}
     ab8:	70e2                	ld	ra,56(sp)
     aba:	7442                	ld	s0,48(sp)
     abc:	74a2                	ld	s1,40(sp)
     abe:	7902                	ld	s2,32(sp)
     ac0:	69e2                	ld	s3,24(sp)
     ac2:	6a42                	ld	s4,16(sp)
     ac4:	6aa2                	ld	s5,8(sp)
     ac6:	6121                	addi	sp,sp,64
     ac8:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     aca:	8626                	mv	a2,s1
     acc:	85d6                	mv	a1,s5
     ace:	00005517          	auipc	a0,0x5
     ad2:	9f250513          	addi	a0,a0,-1550 # 54c0 <malloc+0x5ac>
     ad6:	384040ef          	jal	ra,4e5a <printf>
        exit(1);
     ada:	4505                	li	a0,1
     adc:	75d030ef          	jal	ra,4a38 <exit>
      printf("%s: read failed %d\n", s, i);
     ae0:	862a                	mv	a2,a0
     ae2:	85d6                	mv	a1,s5
     ae4:	00005517          	auipc	a0,0x5
     ae8:	a0450513          	addi	a0,a0,-1532 # 54e8 <malloc+0x5d4>
     aec:	36e040ef          	jal	ra,4e5a <printf>
      exit(1);
     af0:	4505                	li	a0,1
     af2:	747030ef          	jal	ra,4a38 <exit>
      printf("%s: read content of block %d is %d\n", s,
     af6:	8626                	mv	a2,s1
     af8:	85d6                	mv	a1,s5
     afa:	00005517          	auipc	a0,0x5
     afe:	a0650513          	addi	a0,a0,-1530 # 5500 <malloc+0x5ec>
     b02:	358040ef          	jal	ra,4e5a <printf>
      exit(1);
     b06:	4505                	li	a0,1
     b08:	731030ef          	jal	ra,4a38 <exit>
    printf("%s: unlink big failed\n", s);
     b0c:	85d6                	mv	a1,s5
     b0e:	00005517          	auipc	a0,0x5
     b12:	a1a50513          	addi	a0,a0,-1510 # 5528 <malloc+0x614>
     b16:	344040ef          	jal	ra,4e5a <printf>
    exit(1);
     b1a:	4505                	li	a0,1
     b1c:	71d030ef          	jal	ra,4a38 <exit>

0000000000000b20 <unlinkread>:
{
     b20:	7179                	addi	sp,sp,-48
     b22:	f406                	sd	ra,40(sp)
     b24:	f022                	sd	s0,32(sp)
     b26:	ec26                	sd	s1,24(sp)
     b28:	e84a                	sd	s2,16(sp)
     b2a:	e44e                	sd	s3,8(sp)
     b2c:	1800                	addi	s0,sp,48
     b2e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b30:	20200593          	li	a1,514
     b34:	00005517          	auipc	a0,0x5
     b38:	a0c50513          	addi	a0,a0,-1524 # 5540 <malloc+0x62c>
     b3c:	73d030ef          	jal	ra,4a78 <open>
  if(fd < 0){
     b40:	0a054f63          	bltz	a0,bfe <unlinkread+0xde>
     b44:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b46:	4615                	li	a2,5
     b48:	00005597          	auipc	a1,0x5
     b4c:	a2858593          	addi	a1,a1,-1496 # 5570 <malloc+0x65c>
     b50:	709030ef          	jal	ra,4a58 <write>
  close(fd);
     b54:	8526                	mv	a0,s1
     b56:	70b030ef          	jal	ra,4a60 <close>
  fd = open("unlinkread", O_RDWR);
     b5a:	4589                	li	a1,2
     b5c:	00005517          	auipc	a0,0x5
     b60:	9e450513          	addi	a0,a0,-1564 # 5540 <malloc+0x62c>
     b64:	715030ef          	jal	ra,4a78 <open>
     b68:	84aa                	mv	s1,a0
  if(fd < 0){
     b6a:	0a054463          	bltz	a0,c12 <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     b6e:	00005517          	auipc	a0,0x5
     b72:	9d250513          	addi	a0,a0,-1582 # 5540 <malloc+0x62c>
     b76:	713030ef          	jal	ra,4a88 <unlink>
     b7a:	e555                	bnez	a0,c26 <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     b7c:	20200593          	li	a1,514
     b80:	00005517          	auipc	a0,0x5
     b84:	9c050513          	addi	a0,a0,-1600 # 5540 <malloc+0x62c>
     b88:	6f1030ef          	jal	ra,4a78 <open>
     b8c:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     b8e:	460d                	li	a2,3
     b90:	00005597          	auipc	a1,0x5
     b94:	a2858593          	addi	a1,a1,-1496 # 55b8 <malloc+0x6a4>
     b98:	6c1030ef          	jal	ra,4a58 <write>
  close(fd1);
     b9c:	854a                	mv	a0,s2
     b9e:	6c3030ef          	jal	ra,4a60 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     ba2:	660d                	lui	a2,0x3
     ba4:	0000b597          	auipc	a1,0xb
     ba8:	0d458593          	addi	a1,a1,212 # bc78 <buf>
     bac:	8526                	mv	a0,s1
     bae:	6a3030ef          	jal	ra,4a50 <read>
     bb2:	4795                	li	a5,5
     bb4:	08f51363          	bne	a0,a5,c3a <unlinkread+0x11a>
  if(buf[0] != 'h'){
     bb8:	0000b717          	auipc	a4,0xb
     bbc:	0c074703          	lbu	a4,192(a4) # bc78 <buf>
     bc0:	06800793          	li	a5,104
     bc4:	08f71563          	bne	a4,a5,c4e <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     bc8:	4629                	li	a2,10
     bca:	0000b597          	auipc	a1,0xb
     bce:	0ae58593          	addi	a1,a1,174 # bc78 <buf>
     bd2:	8526                	mv	a0,s1
     bd4:	685030ef          	jal	ra,4a58 <write>
     bd8:	47a9                	li	a5,10
     bda:	08f51463          	bne	a0,a5,c62 <unlinkread+0x142>
  close(fd);
     bde:	8526                	mv	a0,s1
     be0:	681030ef          	jal	ra,4a60 <close>
  unlink("unlinkread");
     be4:	00005517          	auipc	a0,0x5
     be8:	95c50513          	addi	a0,a0,-1700 # 5540 <malloc+0x62c>
     bec:	69d030ef          	jal	ra,4a88 <unlink>
}
     bf0:	70a2                	ld	ra,40(sp)
     bf2:	7402                	ld	s0,32(sp)
     bf4:	64e2                	ld	s1,24(sp)
     bf6:	6942                	ld	s2,16(sp)
     bf8:	69a2                	ld	s3,8(sp)
     bfa:	6145                	addi	sp,sp,48
     bfc:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     bfe:	85ce                	mv	a1,s3
     c00:	00005517          	auipc	a0,0x5
     c04:	95050513          	addi	a0,a0,-1712 # 5550 <malloc+0x63c>
     c08:	252040ef          	jal	ra,4e5a <printf>
    exit(1);
     c0c:	4505                	li	a0,1
     c0e:	62b030ef          	jal	ra,4a38 <exit>
    printf("%s: open unlinkread failed\n", s);
     c12:	85ce                	mv	a1,s3
     c14:	00005517          	auipc	a0,0x5
     c18:	96450513          	addi	a0,a0,-1692 # 5578 <malloc+0x664>
     c1c:	23e040ef          	jal	ra,4e5a <printf>
    exit(1);
     c20:	4505                	li	a0,1
     c22:	617030ef          	jal	ra,4a38 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c26:	85ce                	mv	a1,s3
     c28:	00005517          	auipc	a0,0x5
     c2c:	97050513          	addi	a0,a0,-1680 # 5598 <malloc+0x684>
     c30:	22a040ef          	jal	ra,4e5a <printf>
    exit(1);
     c34:	4505                	li	a0,1
     c36:	603030ef          	jal	ra,4a38 <exit>
    printf("%s: unlinkread read failed", s);
     c3a:	85ce                	mv	a1,s3
     c3c:	00005517          	auipc	a0,0x5
     c40:	98450513          	addi	a0,a0,-1660 # 55c0 <malloc+0x6ac>
     c44:	216040ef          	jal	ra,4e5a <printf>
    exit(1);
     c48:	4505                	li	a0,1
     c4a:	5ef030ef          	jal	ra,4a38 <exit>
    printf("%s: unlinkread wrong data\n", s);
     c4e:	85ce                	mv	a1,s3
     c50:	00005517          	auipc	a0,0x5
     c54:	99050513          	addi	a0,a0,-1648 # 55e0 <malloc+0x6cc>
     c58:	202040ef          	jal	ra,4e5a <printf>
    exit(1);
     c5c:	4505                	li	a0,1
     c5e:	5db030ef          	jal	ra,4a38 <exit>
    printf("%s: unlinkread write failed\n", s);
     c62:	85ce                	mv	a1,s3
     c64:	00005517          	auipc	a0,0x5
     c68:	99c50513          	addi	a0,a0,-1636 # 5600 <malloc+0x6ec>
     c6c:	1ee040ef          	jal	ra,4e5a <printf>
    exit(1);
     c70:	4505                	li	a0,1
     c72:	5c7030ef          	jal	ra,4a38 <exit>

0000000000000c76 <linktest>:
{
     c76:	1101                	addi	sp,sp,-32
     c78:	ec06                	sd	ra,24(sp)
     c7a:	e822                	sd	s0,16(sp)
     c7c:	e426                	sd	s1,8(sp)
     c7e:	e04a                	sd	s2,0(sp)
     c80:	1000                	addi	s0,sp,32
     c82:	892a                	mv	s2,a0
  unlink("lf1");
     c84:	00005517          	auipc	a0,0x5
     c88:	99c50513          	addi	a0,a0,-1636 # 5620 <malloc+0x70c>
     c8c:	5fd030ef          	jal	ra,4a88 <unlink>
  unlink("lf2");
     c90:	00005517          	auipc	a0,0x5
     c94:	99850513          	addi	a0,a0,-1640 # 5628 <malloc+0x714>
     c98:	5f1030ef          	jal	ra,4a88 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     c9c:	20200593          	li	a1,514
     ca0:	00005517          	auipc	a0,0x5
     ca4:	98050513          	addi	a0,a0,-1664 # 5620 <malloc+0x70c>
     ca8:	5d1030ef          	jal	ra,4a78 <open>
  if(fd < 0){
     cac:	0c054f63          	bltz	a0,d8a <linktest+0x114>
     cb0:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     cb2:	4615                	li	a2,5
     cb4:	00005597          	auipc	a1,0x5
     cb8:	8bc58593          	addi	a1,a1,-1860 # 5570 <malloc+0x65c>
     cbc:	59d030ef          	jal	ra,4a58 <write>
     cc0:	4795                	li	a5,5
     cc2:	0cf51e63          	bne	a0,a5,d9e <linktest+0x128>
  close(fd);
     cc6:	8526                	mv	a0,s1
     cc8:	599030ef          	jal	ra,4a60 <close>
  if(link("lf1", "lf2") < 0){
     ccc:	00005597          	auipc	a1,0x5
     cd0:	95c58593          	addi	a1,a1,-1700 # 5628 <malloc+0x714>
     cd4:	00005517          	auipc	a0,0x5
     cd8:	94c50513          	addi	a0,a0,-1716 # 5620 <malloc+0x70c>
     cdc:	5bd030ef          	jal	ra,4a98 <link>
     ce0:	0c054963          	bltz	a0,db2 <linktest+0x13c>
  unlink("lf1");
     ce4:	00005517          	auipc	a0,0x5
     ce8:	93c50513          	addi	a0,a0,-1732 # 5620 <malloc+0x70c>
     cec:	59d030ef          	jal	ra,4a88 <unlink>
  if(open("lf1", 0) >= 0){
     cf0:	4581                	li	a1,0
     cf2:	00005517          	auipc	a0,0x5
     cf6:	92e50513          	addi	a0,a0,-1746 # 5620 <malloc+0x70c>
     cfa:	57f030ef          	jal	ra,4a78 <open>
     cfe:	0c055463          	bgez	a0,dc6 <linktest+0x150>
  fd = open("lf2", 0);
     d02:	4581                	li	a1,0
     d04:	00005517          	auipc	a0,0x5
     d08:	92450513          	addi	a0,a0,-1756 # 5628 <malloc+0x714>
     d0c:	56d030ef          	jal	ra,4a78 <open>
     d10:	84aa                	mv	s1,a0
  if(fd < 0){
     d12:	0c054463          	bltz	a0,dda <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d16:	660d                	lui	a2,0x3
     d18:	0000b597          	auipc	a1,0xb
     d1c:	f6058593          	addi	a1,a1,-160 # bc78 <buf>
     d20:	531030ef          	jal	ra,4a50 <read>
     d24:	4795                	li	a5,5
     d26:	0cf51463          	bne	a0,a5,dee <linktest+0x178>
  close(fd);
     d2a:	8526                	mv	a0,s1
     d2c:	535030ef          	jal	ra,4a60 <close>
  if(link("lf2", "lf2") >= 0){
     d30:	00005597          	auipc	a1,0x5
     d34:	8f858593          	addi	a1,a1,-1800 # 5628 <malloc+0x714>
     d38:	852e                	mv	a0,a1
     d3a:	55f030ef          	jal	ra,4a98 <link>
     d3e:	0c055263          	bgez	a0,e02 <linktest+0x18c>
  unlink("lf2");
     d42:	00005517          	auipc	a0,0x5
     d46:	8e650513          	addi	a0,a0,-1818 # 5628 <malloc+0x714>
     d4a:	53f030ef          	jal	ra,4a88 <unlink>
  if(link("lf2", "lf1") >= 0){
     d4e:	00005597          	auipc	a1,0x5
     d52:	8d258593          	addi	a1,a1,-1838 # 5620 <malloc+0x70c>
     d56:	00005517          	auipc	a0,0x5
     d5a:	8d250513          	addi	a0,a0,-1838 # 5628 <malloc+0x714>
     d5e:	53b030ef          	jal	ra,4a98 <link>
     d62:	0a055a63          	bgez	a0,e16 <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     d66:	00005597          	auipc	a1,0x5
     d6a:	8ba58593          	addi	a1,a1,-1862 # 5620 <malloc+0x70c>
     d6e:	00005517          	auipc	a0,0x5
     d72:	9c250513          	addi	a0,a0,-1598 # 5730 <malloc+0x81c>
     d76:	523030ef          	jal	ra,4a98 <link>
     d7a:	0a055863          	bgez	a0,e2a <linktest+0x1b4>
}
     d7e:	60e2                	ld	ra,24(sp)
     d80:	6442                	ld	s0,16(sp)
     d82:	64a2                	ld	s1,8(sp)
     d84:	6902                	ld	s2,0(sp)
     d86:	6105                	addi	sp,sp,32
     d88:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     d8a:	85ca                	mv	a1,s2
     d8c:	00005517          	auipc	a0,0x5
     d90:	8a450513          	addi	a0,a0,-1884 # 5630 <malloc+0x71c>
     d94:	0c6040ef          	jal	ra,4e5a <printf>
    exit(1);
     d98:	4505                	li	a0,1
     d9a:	49f030ef          	jal	ra,4a38 <exit>
    printf("%s: write lf1 failed\n", s);
     d9e:	85ca                	mv	a1,s2
     da0:	00005517          	auipc	a0,0x5
     da4:	8a850513          	addi	a0,a0,-1880 # 5648 <malloc+0x734>
     da8:	0b2040ef          	jal	ra,4e5a <printf>
    exit(1);
     dac:	4505                	li	a0,1
     dae:	48b030ef          	jal	ra,4a38 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     db2:	85ca                	mv	a1,s2
     db4:	00005517          	auipc	a0,0x5
     db8:	8ac50513          	addi	a0,a0,-1876 # 5660 <malloc+0x74c>
     dbc:	09e040ef          	jal	ra,4e5a <printf>
    exit(1);
     dc0:	4505                	li	a0,1
     dc2:	477030ef          	jal	ra,4a38 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     dc6:	85ca                	mv	a1,s2
     dc8:	00005517          	auipc	a0,0x5
     dcc:	8b850513          	addi	a0,a0,-1864 # 5680 <malloc+0x76c>
     dd0:	08a040ef          	jal	ra,4e5a <printf>
    exit(1);
     dd4:	4505                	li	a0,1
     dd6:	463030ef          	jal	ra,4a38 <exit>
    printf("%s: open lf2 failed\n", s);
     dda:	85ca                	mv	a1,s2
     ddc:	00005517          	auipc	a0,0x5
     de0:	8d450513          	addi	a0,a0,-1836 # 56b0 <malloc+0x79c>
     de4:	076040ef          	jal	ra,4e5a <printf>
    exit(1);
     de8:	4505                	li	a0,1
     dea:	44f030ef          	jal	ra,4a38 <exit>
    printf("%s: read lf2 failed\n", s);
     dee:	85ca                	mv	a1,s2
     df0:	00005517          	auipc	a0,0x5
     df4:	8d850513          	addi	a0,a0,-1832 # 56c8 <malloc+0x7b4>
     df8:	062040ef          	jal	ra,4e5a <printf>
    exit(1);
     dfc:	4505                	li	a0,1
     dfe:	43b030ef          	jal	ra,4a38 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e02:	85ca                	mv	a1,s2
     e04:	00005517          	auipc	a0,0x5
     e08:	8dc50513          	addi	a0,a0,-1828 # 56e0 <malloc+0x7cc>
     e0c:	04e040ef          	jal	ra,4e5a <printf>
    exit(1);
     e10:	4505                	li	a0,1
     e12:	427030ef          	jal	ra,4a38 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e16:	85ca                	mv	a1,s2
     e18:	00005517          	auipc	a0,0x5
     e1c:	8f050513          	addi	a0,a0,-1808 # 5708 <malloc+0x7f4>
     e20:	03a040ef          	jal	ra,4e5a <printf>
    exit(1);
     e24:	4505                	li	a0,1
     e26:	413030ef          	jal	ra,4a38 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e2a:	85ca                	mv	a1,s2
     e2c:	00005517          	auipc	a0,0x5
     e30:	90c50513          	addi	a0,a0,-1780 # 5738 <malloc+0x824>
     e34:	026040ef          	jal	ra,4e5a <printf>
    exit(1);
     e38:	4505                	li	a0,1
     e3a:	3ff030ef          	jal	ra,4a38 <exit>

0000000000000e3e <validatetest>:
{
     e3e:	7139                	addi	sp,sp,-64
     e40:	fc06                	sd	ra,56(sp)
     e42:	f822                	sd	s0,48(sp)
     e44:	f426                	sd	s1,40(sp)
     e46:	f04a                	sd	s2,32(sp)
     e48:	ec4e                	sd	s3,24(sp)
     e4a:	e852                	sd	s4,16(sp)
     e4c:	e456                	sd	s5,8(sp)
     e4e:	e05a                	sd	s6,0(sp)
     e50:	0080                	addi	s0,sp,64
     e52:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e54:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     e56:	00005997          	auipc	s3,0x5
     e5a:	90298993          	addi	s3,s3,-1790 # 5758 <malloc+0x844>
     e5e:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e60:	6a85                	lui	s5,0x1
     e62:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     e66:	85a6                	mv	a1,s1
     e68:	854e                	mv	a0,s3
     e6a:	42f030ef          	jal	ra,4a98 <link>
     e6e:	01251f63          	bne	a0,s2,e8c <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e72:	94d6                	add	s1,s1,s5
     e74:	ff4499e3          	bne	s1,s4,e66 <validatetest+0x28>
}
     e78:	70e2                	ld	ra,56(sp)
     e7a:	7442                	ld	s0,48(sp)
     e7c:	74a2                	ld	s1,40(sp)
     e7e:	7902                	ld	s2,32(sp)
     e80:	69e2                	ld	s3,24(sp)
     e82:	6a42                	ld	s4,16(sp)
     e84:	6aa2                	ld	s5,8(sp)
     e86:	6b02                	ld	s6,0(sp)
     e88:	6121                	addi	sp,sp,64
     e8a:	8082                	ret
      printf("%s: link should not succeed\n", s);
     e8c:	85da                	mv	a1,s6
     e8e:	00005517          	auipc	a0,0x5
     e92:	8da50513          	addi	a0,a0,-1830 # 5768 <malloc+0x854>
     e96:	7c5030ef          	jal	ra,4e5a <printf>
      exit(1);
     e9a:	4505                	li	a0,1
     e9c:	39d030ef          	jal	ra,4a38 <exit>

0000000000000ea0 <bigdir>:
{
     ea0:	715d                	addi	sp,sp,-80
     ea2:	e486                	sd	ra,72(sp)
     ea4:	e0a2                	sd	s0,64(sp)
     ea6:	fc26                	sd	s1,56(sp)
     ea8:	f84a                	sd	s2,48(sp)
     eaa:	f44e                	sd	s3,40(sp)
     eac:	f052                	sd	s4,32(sp)
     eae:	ec56                	sd	s5,24(sp)
     eb0:	e85a                	sd	s6,16(sp)
     eb2:	0880                	addi	s0,sp,80
     eb4:	89aa                	mv	s3,a0
  unlink("bd");
     eb6:	00005517          	auipc	a0,0x5
     eba:	8d250513          	addi	a0,a0,-1838 # 5788 <malloc+0x874>
     ebe:	3cb030ef          	jal	ra,4a88 <unlink>
  fd = open("bd", O_CREATE);
     ec2:	20000593          	li	a1,512
     ec6:	00005517          	auipc	a0,0x5
     eca:	8c250513          	addi	a0,a0,-1854 # 5788 <malloc+0x874>
     ece:	3ab030ef          	jal	ra,4a78 <open>
  if(fd < 0){
     ed2:	0c054163          	bltz	a0,f94 <bigdir+0xf4>
  close(fd);
     ed6:	38b030ef          	jal	ra,4a60 <close>
  for(i = 0; i < N; i++){
     eda:	4901                	li	s2,0
    name[0] = 'x';
     edc:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     ee0:	00005a17          	auipc	s4,0x5
     ee4:	8a8a0a13          	addi	s4,s4,-1880 # 5788 <malloc+0x874>
  for(i = 0; i < N; i++){
     ee8:	1f400b13          	li	s6,500
    name[0] = 'x';
     eec:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     ef0:	41f9579b          	sraiw	a5,s2,0x1f
     ef4:	01a7d71b          	srliw	a4,a5,0x1a
     ef8:	012707bb          	addw	a5,a4,s2
     efc:	4067d69b          	sraiw	a3,a5,0x6
     f00:	0306869b          	addiw	a3,a3,48
     f04:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f08:	03f7f793          	andi	a5,a5,63
     f0c:	9f99                	subw	a5,a5,a4
     f0e:	0307879b          	addiw	a5,a5,48
     f12:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f16:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     f1a:	fb040593          	addi	a1,s0,-80
     f1e:	8552                	mv	a0,s4
     f20:	379030ef          	jal	ra,4a98 <link>
     f24:	84aa                	mv	s1,a0
     f26:	e149                	bnez	a0,fa8 <bigdir+0x108>
  for(i = 0; i < N; i++){
     f28:	2905                	addiw	s2,s2,1
     f2a:	fd6911e3          	bne	s2,s6,eec <bigdir+0x4c>
  unlink("bd");
     f2e:	00005517          	auipc	a0,0x5
     f32:	85a50513          	addi	a0,a0,-1958 # 5788 <malloc+0x874>
     f36:	353030ef          	jal	ra,4a88 <unlink>
    name[0] = 'x';
     f3a:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
     f3e:	1f400a13          	li	s4,500
    name[0] = 'x';
     f42:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
     f46:	41f4d79b          	sraiw	a5,s1,0x1f
     f4a:	01a7d71b          	srliw	a4,a5,0x1a
     f4e:	009707bb          	addw	a5,a4,s1
     f52:	4067d69b          	sraiw	a3,a5,0x6
     f56:	0306869b          	addiw	a3,a3,48
     f5a:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f5e:	03f7f793          	andi	a5,a5,63
     f62:	9f99                	subw	a5,a5,a4
     f64:	0307879b          	addiw	a5,a5,48
     f68:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f6c:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
     f70:	fb040513          	addi	a0,s0,-80
     f74:	315030ef          	jal	ra,4a88 <unlink>
     f78:	e529                	bnez	a0,fc2 <bigdir+0x122>
  for(i = 0; i < N; i++){
     f7a:	2485                	addiw	s1,s1,1
     f7c:	fd4493e3          	bne	s1,s4,f42 <bigdir+0xa2>
}
     f80:	60a6                	ld	ra,72(sp)
     f82:	6406                	ld	s0,64(sp)
     f84:	74e2                	ld	s1,56(sp)
     f86:	7942                	ld	s2,48(sp)
     f88:	79a2                	ld	s3,40(sp)
     f8a:	7a02                	ld	s4,32(sp)
     f8c:	6ae2                	ld	s5,24(sp)
     f8e:	6b42                	ld	s6,16(sp)
     f90:	6161                	addi	sp,sp,80
     f92:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     f94:	85ce                	mv	a1,s3
     f96:	00004517          	auipc	a0,0x4
     f9a:	7fa50513          	addi	a0,a0,2042 # 5790 <malloc+0x87c>
     f9e:	6bd030ef          	jal	ra,4e5a <printf>
    exit(1);
     fa2:	4505                	li	a0,1
     fa4:	295030ef          	jal	ra,4a38 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
     fa8:	fb040693          	addi	a3,s0,-80
     fac:	864a                	mv	a2,s2
     fae:	85ce                	mv	a1,s3
     fb0:	00005517          	auipc	a0,0x5
     fb4:	80050513          	addi	a0,a0,-2048 # 57b0 <malloc+0x89c>
     fb8:	6a3030ef          	jal	ra,4e5a <printf>
      exit(1);
     fbc:	4505                	li	a0,1
     fbe:	27b030ef          	jal	ra,4a38 <exit>
      printf("%s: bigdir unlink failed", s);
     fc2:	85ce                	mv	a1,s3
     fc4:	00005517          	auipc	a0,0x5
     fc8:	81450513          	addi	a0,a0,-2028 # 57d8 <malloc+0x8c4>
     fcc:	68f030ef          	jal	ra,4e5a <printf>
      exit(1);
     fd0:	4505                	li	a0,1
     fd2:	267030ef          	jal	ra,4a38 <exit>

0000000000000fd6 <pgbug>:
{
     fd6:	7179                	addi	sp,sp,-48
     fd8:	f406                	sd	ra,40(sp)
     fda:	f022                	sd	s0,32(sp)
     fdc:	ec26                	sd	s1,24(sp)
     fde:	1800                	addi	s0,sp,48
  argv[0] = 0;
     fe0:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
     fe4:	00007497          	auipc	s1,0x7
     fe8:	01c48493          	addi	s1,s1,28 # 8000 <big>
     fec:	fd840593          	addi	a1,s0,-40
     ff0:	6088                	ld	a0,0(s1)
     ff2:	27f030ef          	jal	ra,4a70 <exec>
  pipe(big);
     ff6:	6088                	ld	a0,0(s1)
     ff8:	251030ef          	jal	ra,4a48 <pipe>
  exit(0);
     ffc:	4501                	li	a0,0
     ffe:	23b030ef          	jal	ra,4a38 <exit>

0000000000001002 <badarg>:
{
    1002:	7139                	addi	sp,sp,-64
    1004:	fc06                	sd	ra,56(sp)
    1006:	f822                	sd	s0,48(sp)
    1008:	f426                	sd	s1,40(sp)
    100a:	f04a                	sd	s2,32(sp)
    100c:	ec4e                	sd	s3,24(sp)
    100e:	0080                	addi	s0,sp,64
    1010:	64b1                	lui	s1,0xc
    1012:	35048493          	addi	s1,s1,848 # c350 <buf+0x6d8>
    argv[0] = (char*)0xffffffff;
    1016:	597d                	li	s2,-1
    1018:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    101c:	00004997          	auipc	s3,0x4
    1020:	02c98993          	addi	s3,s3,44 # 5048 <malloc+0x134>
    argv[0] = (char*)0xffffffff;
    1024:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1028:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    102c:	fc040593          	addi	a1,s0,-64
    1030:	854e                	mv	a0,s3
    1032:	23f030ef          	jal	ra,4a70 <exec>
  for(int i = 0; i < 50000; i++){
    1036:	34fd                	addiw	s1,s1,-1
    1038:	f4f5                	bnez	s1,1024 <badarg+0x22>
  exit(0);
    103a:	4501                	li	a0,0
    103c:	1fd030ef          	jal	ra,4a38 <exit>

0000000000001040 <copyinstr2>:
{
    1040:	7155                	addi	sp,sp,-208
    1042:	e586                	sd	ra,200(sp)
    1044:	e1a2                	sd	s0,192(sp)
    1046:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1048:	f6840793          	addi	a5,s0,-152
    104c:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    1050:	07800713          	li	a4,120
    1054:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    1058:	0785                	addi	a5,a5,1
    105a:	fed79de3          	bne	a5,a3,1054 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    105e:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1062:	f6840513          	addi	a0,s0,-152
    1066:	223030ef          	jal	ra,4a88 <unlink>
  if(ret != -1){
    106a:	57fd                	li	a5,-1
    106c:	0cf51263          	bne	a0,a5,1130 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    1070:	20100593          	li	a1,513
    1074:	f6840513          	addi	a0,s0,-152
    1078:	201030ef          	jal	ra,4a78 <open>
  if(fd != -1){
    107c:	57fd                	li	a5,-1
    107e:	0cf51563          	bne	a0,a5,1148 <copyinstr2+0x108>
  ret = link(b, b);
    1082:	f6840593          	addi	a1,s0,-152
    1086:	852e                	mv	a0,a1
    1088:	211030ef          	jal	ra,4a98 <link>
  if(ret != -1){
    108c:	57fd                	li	a5,-1
    108e:	0cf51963          	bne	a0,a5,1160 <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    1092:	00006797          	auipc	a5,0x6
    1096:	89678793          	addi	a5,a5,-1898 # 6928 <malloc+0x1a14>
    109a:	f4f43c23          	sd	a5,-168(s0)
    109e:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    10a2:	f5840593          	addi	a1,s0,-168
    10a6:	f6840513          	addi	a0,s0,-152
    10aa:	1c7030ef          	jal	ra,4a70 <exec>
  if(ret != -1){
    10ae:	57fd                	li	a5,-1
    10b0:	0cf51563          	bne	a0,a5,117a <copyinstr2+0x13a>
  int pid = fork();
    10b4:	17d030ef          	jal	ra,4a30 <fork>
  if(pid < 0){
    10b8:	0c054d63          	bltz	a0,1192 <copyinstr2+0x152>
  if(pid == 0){
    10bc:	0e051863          	bnez	a0,11ac <copyinstr2+0x16c>
    10c0:	00007797          	auipc	a5,0x7
    10c4:	4a078793          	addi	a5,a5,1184 # 8560 <big.0>
    10c8:	00008697          	auipc	a3,0x8
    10cc:	49868693          	addi	a3,a3,1176 # 9560 <big.0+0x1000>
      big[i] = 'x';
    10d0:	07800713          	li	a4,120
    10d4:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    10d8:	0785                	addi	a5,a5,1
    10da:	fed79de3          	bne	a5,a3,10d4 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    10de:	00008797          	auipc	a5,0x8
    10e2:	48078123          	sb	zero,1154(a5) # 9560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    10e6:	00006797          	auipc	a5,0x6
    10ea:	29a78793          	addi	a5,a5,666 # 7380 <malloc+0x246c>
    10ee:	6fb0                	ld	a2,88(a5)
    10f0:	73b4                	ld	a3,96(a5)
    10f2:	77b8                	ld	a4,104(a5)
    10f4:	7bbc                	ld	a5,112(a5)
    10f6:	f2c43823          	sd	a2,-208(s0)
    10fa:	f2d43c23          	sd	a3,-200(s0)
    10fe:	f4e43023          	sd	a4,-192(s0)
    1102:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1106:	f3040593          	addi	a1,s0,-208
    110a:	00004517          	auipc	a0,0x4
    110e:	f3e50513          	addi	a0,a0,-194 # 5048 <malloc+0x134>
    1112:	15f030ef          	jal	ra,4a70 <exec>
    if(ret != -1){
    1116:	57fd                	li	a5,-1
    1118:	08f50663          	beq	a0,a5,11a4 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    111c:	55fd                	li	a1,-1
    111e:	00004517          	auipc	a0,0x4
    1122:	76250513          	addi	a0,a0,1890 # 5880 <malloc+0x96c>
    1126:	535030ef          	jal	ra,4e5a <printf>
      exit(1);
    112a:	4505                	li	a0,1
    112c:	10d030ef          	jal	ra,4a38 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1130:	862a                	mv	a2,a0
    1132:	f6840593          	addi	a1,s0,-152
    1136:	00004517          	auipc	a0,0x4
    113a:	6c250513          	addi	a0,a0,1730 # 57f8 <malloc+0x8e4>
    113e:	51d030ef          	jal	ra,4e5a <printf>
    exit(1);
    1142:	4505                	li	a0,1
    1144:	0f5030ef          	jal	ra,4a38 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1148:	862a                	mv	a2,a0
    114a:	f6840593          	addi	a1,s0,-152
    114e:	00004517          	auipc	a0,0x4
    1152:	6ca50513          	addi	a0,a0,1738 # 5818 <malloc+0x904>
    1156:	505030ef          	jal	ra,4e5a <printf>
    exit(1);
    115a:	4505                	li	a0,1
    115c:	0dd030ef          	jal	ra,4a38 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1160:	86aa                	mv	a3,a0
    1162:	f6840613          	addi	a2,s0,-152
    1166:	85b2                	mv	a1,a2
    1168:	00004517          	auipc	a0,0x4
    116c:	6d050513          	addi	a0,a0,1744 # 5838 <malloc+0x924>
    1170:	4eb030ef          	jal	ra,4e5a <printf>
    exit(1);
    1174:	4505                	li	a0,1
    1176:	0c3030ef          	jal	ra,4a38 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    117a:	567d                	li	a2,-1
    117c:	f6840593          	addi	a1,s0,-152
    1180:	00004517          	auipc	a0,0x4
    1184:	6e050513          	addi	a0,a0,1760 # 5860 <malloc+0x94c>
    1188:	4d3030ef          	jal	ra,4e5a <printf>
    exit(1);
    118c:	4505                	li	a0,1
    118e:	0ab030ef          	jal	ra,4a38 <exit>
    printf("fork failed\n");
    1192:	00006517          	auipc	a0,0x6
    1196:	c9650513          	addi	a0,a0,-874 # 6e28 <malloc+0x1f14>
    119a:	4c1030ef          	jal	ra,4e5a <printf>
    exit(1);
    119e:	4505                	li	a0,1
    11a0:	099030ef          	jal	ra,4a38 <exit>
    exit(747); // OK
    11a4:	2eb00513          	li	a0,747
    11a8:	091030ef          	jal	ra,4a38 <exit>
  int st = 0;
    11ac:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    11b0:	f5440513          	addi	a0,s0,-172
    11b4:	08d030ef          	jal	ra,4a40 <wait>
  if(st != 747){
    11b8:	f5442703          	lw	a4,-172(s0)
    11bc:	2eb00793          	li	a5,747
    11c0:	00f71663          	bne	a4,a5,11cc <copyinstr2+0x18c>
}
    11c4:	60ae                	ld	ra,200(sp)
    11c6:	640e                	ld	s0,192(sp)
    11c8:	6169                	addi	sp,sp,208
    11ca:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    11cc:	00004517          	auipc	a0,0x4
    11d0:	6dc50513          	addi	a0,a0,1756 # 58a8 <malloc+0x994>
    11d4:	487030ef          	jal	ra,4e5a <printf>
    exit(1);
    11d8:	4505                	li	a0,1
    11da:	05f030ef          	jal	ra,4a38 <exit>

00000000000011de <truncate3>:
{
    11de:	7159                	addi	sp,sp,-112
    11e0:	f486                	sd	ra,104(sp)
    11e2:	f0a2                	sd	s0,96(sp)
    11e4:	eca6                	sd	s1,88(sp)
    11e6:	e8ca                	sd	s2,80(sp)
    11e8:	e4ce                	sd	s3,72(sp)
    11ea:	e0d2                	sd	s4,64(sp)
    11ec:	fc56                	sd	s5,56(sp)
    11ee:	1880                	addi	s0,sp,112
    11f0:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    11f2:	60100593          	li	a1,1537
    11f6:	00004517          	auipc	a0,0x4
    11fa:	eaa50513          	addi	a0,a0,-342 # 50a0 <malloc+0x18c>
    11fe:	07b030ef          	jal	ra,4a78 <open>
    1202:	05f030ef          	jal	ra,4a60 <close>
  pid = fork();
    1206:	02b030ef          	jal	ra,4a30 <fork>
  if(pid < 0){
    120a:	06054263          	bltz	a0,126e <truncate3+0x90>
  if(pid == 0){
    120e:	ed59                	bnez	a0,12ac <truncate3+0xce>
    1210:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    1214:	00004a17          	auipc	s4,0x4
    1218:	e8ca0a13          	addi	s4,s4,-372 # 50a0 <malloc+0x18c>
      int n = write(fd, "1234567890", 10);
    121c:	00004a97          	auipc	s5,0x4
    1220:	6eca8a93          	addi	s5,s5,1772 # 5908 <malloc+0x9f4>
      int fd = open("truncfile", O_WRONLY);
    1224:	4585                	li	a1,1
    1226:	8552                	mv	a0,s4
    1228:	051030ef          	jal	ra,4a78 <open>
    122c:	84aa                	mv	s1,a0
      if(fd < 0){
    122e:	04054a63          	bltz	a0,1282 <truncate3+0xa4>
      int n = write(fd, "1234567890", 10);
    1232:	4629                	li	a2,10
    1234:	85d6                	mv	a1,s5
    1236:	023030ef          	jal	ra,4a58 <write>
      if(n != 10){
    123a:	47a9                	li	a5,10
    123c:	04f51d63          	bne	a0,a5,1296 <truncate3+0xb8>
      close(fd);
    1240:	8526                	mv	a0,s1
    1242:	01f030ef          	jal	ra,4a60 <close>
      fd = open("truncfile", O_RDONLY);
    1246:	4581                	li	a1,0
    1248:	8552                	mv	a0,s4
    124a:	02f030ef          	jal	ra,4a78 <open>
    124e:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1250:	02000613          	li	a2,32
    1254:	f9840593          	addi	a1,s0,-104
    1258:	7f8030ef          	jal	ra,4a50 <read>
      close(fd);
    125c:	8526                	mv	a0,s1
    125e:	003030ef          	jal	ra,4a60 <close>
    for(int i = 0; i < 100; i++){
    1262:	39fd                	addiw	s3,s3,-1
    1264:	fc0990e3          	bnez	s3,1224 <truncate3+0x46>
    exit(0);
    1268:	4501                	li	a0,0
    126a:	7ce030ef          	jal	ra,4a38 <exit>
    printf("%s: fork failed\n", s);
    126e:	85ca                	mv	a1,s2
    1270:	00004517          	auipc	a0,0x4
    1274:	66850513          	addi	a0,a0,1640 # 58d8 <malloc+0x9c4>
    1278:	3e3030ef          	jal	ra,4e5a <printf>
    exit(1);
    127c:	4505                	li	a0,1
    127e:	7ba030ef          	jal	ra,4a38 <exit>
        printf("%s: open failed\n", s);
    1282:	85ca                	mv	a1,s2
    1284:	00004517          	auipc	a0,0x4
    1288:	66c50513          	addi	a0,a0,1644 # 58f0 <malloc+0x9dc>
    128c:	3cf030ef          	jal	ra,4e5a <printf>
        exit(1);
    1290:	4505                	li	a0,1
    1292:	7a6030ef          	jal	ra,4a38 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1296:	862a                	mv	a2,a0
    1298:	85ca                	mv	a1,s2
    129a:	00004517          	auipc	a0,0x4
    129e:	67e50513          	addi	a0,a0,1662 # 5918 <malloc+0xa04>
    12a2:	3b9030ef          	jal	ra,4e5a <printf>
        exit(1);
    12a6:	4505                	li	a0,1
    12a8:	790030ef          	jal	ra,4a38 <exit>
    12ac:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12b0:	00004a17          	auipc	s4,0x4
    12b4:	df0a0a13          	addi	s4,s4,-528 # 50a0 <malloc+0x18c>
    int n = write(fd, "xxx", 3);
    12b8:	00004a97          	auipc	s5,0x4
    12bc:	680a8a93          	addi	s5,s5,1664 # 5938 <malloc+0xa24>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12c0:	60100593          	li	a1,1537
    12c4:	8552                	mv	a0,s4
    12c6:	7b2030ef          	jal	ra,4a78 <open>
    12ca:	84aa                	mv	s1,a0
    if(fd < 0){
    12cc:	02054d63          	bltz	a0,1306 <truncate3+0x128>
    int n = write(fd, "xxx", 3);
    12d0:	460d                	li	a2,3
    12d2:	85d6                	mv	a1,s5
    12d4:	784030ef          	jal	ra,4a58 <write>
    if(n != 3){
    12d8:	478d                	li	a5,3
    12da:	04f51063          	bne	a0,a5,131a <truncate3+0x13c>
    close(fd);
    12de:	8526                	mv	a0,s1
    12e0:	780030ef          	jal	ra,4a60 <close>
  for(int i = 0; i < 150; i++){
    12e4:	39fd                	addiw	s3,s3,-1
    12e6:	fc099de3          	bnez	s3,12c0 <truncate3+0xe2>
  wait(&xstatus);
    12ea:	fbc40513          	addi	a0,s0,-68
    12ee:	752030ef          	jal	ra,4a40 <wait>
  unlink("truncfile");
    12f2:	00004517          	auipc	a0,0x4
    12f6:	dae50513          	addi	a0,a0,-594 # 50a0 <malloc+0x18c>
    12fa:	78e030ef          	jal	ra,4a88 <unlink>
  exit(xstatus);
    12fe:	fbc42503          	lw	a0,-68(s0)
    1302:	736030ef          	jal	ra,4a38 <exit>
      printf("%s: open failed\n", s);
    1306:	85ca                	mv	a1,s2
    1308:	00004517          	auipc	a0,0x4
    130c:	5e850513          	addi	a0,a0,1512 # 58f0 <malloc+0x9dc>
    1310:	34b030ef          	jal	ra,4e5a <printf>
      exit(1);
    1314:	4505                	li	a0,1
    1316:	722030ef          	jal	ra,4a38 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    131a:	862a                	mv	a2,a0
    131c:	85ca                	mv	a1,s2
    131e:	00004517          	auipc	a0,0x4
    1322:	62250513          	addi	a0,a0,1570 # 5940 <malloc+0xa2c>
    1326:	335030ef          	jal	ra,4e5a <printf>
      exit(1);
    132a:	4505                	li	a0,1
    132c:	70c030ef          	jal	ra,4a38 <exit>

0000000000001330 <exectest>:
{
    1330:	715d                	addi	sp,sp,-80
    1332:	e486                	sd	ra,72(sp)
    1334:	e0a2                	sd	s0,64(sp)
    1336:	fc26                	sd	s1,56(sp)
    1338:	f84a                	sd	s2,48(sp)
    133a:	0880                	addi	s0,sp,80
    133c:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    133e:	00004797          	auipc	a5,0x4
    1342:	d0a78793          	addi	a5,a5,-758 # 5048 <malloc+0x134>
    1346:	fcf43023          	sd	a5,-64(s0)
    134a:	00004797          	auipc	a5,0x4
    134e:	61678793          	addi	a5,a5,1558 # 5960 <malloc+0xa4c>
    1352:	fcf43423          	sd	a5,-56(s0)
    1356:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    135a:	00004517          	auipc	a0,0x4
    135e:	60e50513          	addi	a0,a0,1550 # 5968 <malloc+0xa54>
    1362:	726030ef          	jal	ra,4a88 <unlink>
  pid = fork();
    1366:	6ca030ef          	jal	ra,4a30 <fork>
  if(pid < 0) {
    136a:	02054e63          	bltz	a0,13a6 <exectest+0x76>
    136e:	84aa                	mv	s1,a0
  if(pid == 0) {
    1370:	e92d                	bnez	a0,13e2 <exectest+0xb2>
    close(1);
    1372:	4505                	li	a0,1
    1374:	6ec030ef          	jal	ra,4a60 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1378:	20100593          	li	a1,513
    137c:	00004517          	auipc	a0,0x4
    1380:	5ec50513          	addi	a0,a0,1516 # 5968 <malloc+0xa54>
    1384:	6f4030ef          	jal	ra,4a78 <open>
    if(fd < 0) {
    1388:	02054963          	bltz	a0,13ba <exectest+0x8a>
    if(fd != 1) {
    138c:	4785                	li	a5,1
    138e:	04f50063          	beq	a0,a5,13ce <exectest+0x9e>
      printf("%s: wrong fd\n", s);
    1392:	85ca                	mv	a1,s2
    1394:	00004517          	auipc	a0,0x4
    1398:	5f450513          	addi	a0,a0,1524 # 5988 <malloc+0xa74>
    139c:	2bf030ef          	jal	ra,4e5a <printf>
      exit(1);
    13a0:	4505                	li	a0,1
    13a2:	696030ef          	jal	ra,4a38 <exit>
     printf("%s: fork failed\n", s);
    13a6:	85ca                	mv	a1,s2
    13a8:	00004517          	auipc	a0,0x4
    13ac:	53050513          	addi	a0,a0,1328 # 58d8 <malloc+0x9c4>
    13b0:	2ab030ef          	jal	ra,4e5a <printf>
     exit(1);
    13b4:	4505                	li	a0,1
    13b6:	682030ef          	jal	ra,4a38 <exit>
      printf("%s: create failed\n", s);
    13ba:	85ca                	mv	a1,s2
    13bc:	00004517          	auipc	a0,0x4
    13c0:	5b450513          	addi	a0,a0,1460 # 5970 <malloc+0xa5c>
    13c4:	297030ef          	jal	ra,4e5a <printf>
      exit(1);
    13c8:	4505                	li	a0,1
    13ca:	66e030ef          	jal	ra,4a38 <exit>
    if(exec("echo", echoargv) < 0){
    13ce:	fc040593          	addi	a1,s0,-64
    13d2:	00004517          	auipc	a0,0x4
    13d6:	c7650513          	addi	a0,a0,-906 # 5048 <malloc+0x134>
    13da:	696030ef          	jal	ra,4a70 <exec>
    13de:	00054d63          	bltz	a0,13f8 <exectest+0xc8>
  if (wait(&xstatus) != pid) {
    13e2:	fdc40513          	addi	a0,s0,-36
    13e6:	65a030ef          	jal	ra,4a40 <wait>
    13ea:	02951163          	bne	a0,s1,140c <exectest+0xdc>
  if(xstatus != 0)
    13ee:	fdc42503          	lw	a0,-36(s0)
    13f2:	c50d                	beqz	a0,141c <exectest+0xec>
    exit(xstatus);
    13f4:	644030ef          	jal	ra,4a38 <exit>
      printf("%s: exec echo failed\n", s);
    13f8:	85ca                	mv	a1,s2
    13fa:	00004517          	auipc	a0,0x4
    13fe:	59e50513          	addi	a0,a0,1438 # 5998 <malloc+0xa84>
    1402:	259030ef          	jal	ra,4e5a <printf>
      exit(1);
    1406:	4505                	li	a0,1
    1408:	630030ef          	jal	ra,4a38 <exit>
    printf("%s: wait failed!\n", s);
    140c:	85ca                	mv	a1,s2
    140e:	00004517          	auipc	a0,0x4
    1412:	5a250513          	addi	a0,a0,1442 # 59b0 <malloc+0xa9c>
    1416:	245030ef          	jal	ra,4e5a <printf>
    141a:	bfd1                	j	13ee <exectest+0xbe>
  fd = open("echo-ok", O_RDONLY);
    141c:	4581                	li	a1,0
    141e:	00004517          	auipc	a0,0x4
    1422:	54a50513          	addi	a0,a0,1354 # 5968 <malloc+0xa54>
    1426:	652030ef          	jal	ra,4a78 <open>
  if(fd < 0) {
    142a:	02054463          	bltz	a0,1452 <exectest+0x122>
  if (read(fd, buf, 2) != 2) {
    142e:	4609                	li	a2,2
    1430:	fb840593          	addi	a1,s0,-72
    1434:	61c030ef          	jal	ra,4a50 <read>
    1438:	4789                	li	a5,2
    143a:	02f50663          	beq	a0,a5,1466 <exectest+0x136>
    printf("%s: read failed\n", s);
    143e:	85ca                	mv	a1,s2
    1440:	00004517          	auipc	a0,0x4
    1444:	fd850513          	addi	a0,a0,-40 # 5418 <malloc+0x504>
    1448:	213030ef          	jal	ra,4e5a <printf>
    exit(1);
    144c:	4505                	li	a0,1
    144e:	5ea030ef          	jal	ra,4a38 <exit>
    printf("%s: open failed\n", s);
    1452:	85ca                	mv	a1,s2
    1454:	00004517          	auipc	a0,0x4
    1458:	49c50513          	addi	a0,a0,1180 # 58f0 <malloc+0x9dc>
    145c:	1ff030ef          	jal	ra,4e5a <printf>
    exit(1);
    1460:	4505                	li	a0,1
    1462:	5d6030ef          	jal	ra,4a38 <exit>
  unlink("echo-ok");
    1466:	00004517          	auipc	a0,0x4
    146a:	50250513          	addi	a0,a0,1282 # 5968 <malloc+0xa54>
    146e:	61a030ef          	jal	ra,4a88 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1472:	fb844703          	lbu	a4,-72(s0)
    1476:	04f00793          	li	a5,79
    147a:	00f71863          	bne	a4,a5,148a <exectest+0x15a>
    147e:	fb944703          	lbu	a4,-71(s0)
    1482:	04b00793          	li	a5,75
    1486:	00f70c63          	beq	a4,a5,149e <exectest+0x16e>
    printf("%s: wrong output\n", s);
    148a:	85ca                	mv	a1,s2
    148c:	00004517          	auipc	a0,0x4
    1490:	53c50513          	addi	a0,a0,1340 # 59c8 <malloc+0xab4>
    1494:	1c7030ef          	jal	ra,4e5a <printf>
    exit(1);
    1498:	4505                	li	a0,1
    149a:	59e030ef          	jal	ra,4a38 <exit>
    exit(0);
    149e:	4501                	li	a0,0
    14a0:	598030ef          	jal	ra,4a38 <exit>

00000000000014a4 <pipe1>:
{
    14a4:	711d                	addi	sp,sp,-96
    14a6:	ec86                	sd	ra,88(sp)
    14a8:	e8a2                	sd	s0,80(sp)
    14aa:	e4a6                	sd	s1,72(sp)
    14ac:	e0ca                	sd	s2,64(sp)
    14ae:	fc4e                	sd	s3,56(sp)
    14b0:	f852                	sd	s4,48(sp)
    14b2:	f456                	sd	s5,40(sp)
    14b4:	f05a                	sd	s6,32(sp)
    14b6:	ec5e                	sd	s7,24(sp)
    14b8:	1080                	addi	s0,sp,96
    14ba:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    14bc:	fa840513          	addi	a0,s0,-88
    14c0:	588030ef          	jal	ra,4a48 <pipe>
    14c4:	e535                	bnez	a0,1530 <pipe1+0x8c>
    14c6:	84aa                	mv	s1,a0
  pid = fork();
    14c8:	568030ef          	jal	ra,4a30 <fork>
    14cc:	8a2a                	mv	s4,a0
  if(pid == 0){
    14ce:	c93d                	beqz	a0,1544 <pipe1+0xa0>
  } else if(pid > 0){
    14d0:	14a05163          	blez	a0,1612 <pipe1+0x16e>
    close(fds[1]);
    14d4:	fac42503          	lw	a0,-84(s0)
    14d8:	588030ef          	jal	ra,4a60 <close>
    total = 0;
    14dc:	8a26                	mv	s4,s1
    cc = 1;
    14de:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    14e0:	0000aa97          	auipc	s5,0xa
    14e4:	798a8a93          	addi	s5,s5,1944 # bc78 <buf>
      if(cc > sizeof(buf))
    14e8:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    14ea:	864e                	mv	a2,s3
    14ec:	85d6                	mv	a1,s5
    14ee:	fa842503          	lw	a0,-88(s0)
    14f2:	55e030ef          	jal	ra,4a50 <read>
    14f6:	0ea05263          	blez	a0,15da <pipe1+0x136>
      for(i = 0; i < n; i++){
    14fa:	0000a717          	auipc	a4,0xa
    14fe:	77e70713          	addi	a4,a4,1918 # bc78 <buf>
    1502:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1506:	00074683          	lbu	a3,0(a4)
    150a:	0ff4f793          	andi	a5,s1,255
    150e:	2485                	addiw	s1,s1,1
    1510:	0af69363          	bne	a3,a5,15b6 <pipe1+0x112>
      for(i = 0; i < n; i++){
    1514:	0705                	addi	a4,a4,1
    1516:	fec498e3          	bne	s1,a2,1506 <pipe1+0x62>
      total += n;
    151a:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    151e:	0019979b          	slliw	a5,s3,0x1
    1522:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    1526:	013b7363          	bgeu	s6,s3,152c <pipe1+0x88>
        cc = sizeof(buf);
    152a:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    152c:	84b2                	mv	s1,a2
    152e:	bf75                	j	14ea <pipe1+0x46>
    printf("%s: pipe() failed\n", s);
    1530:	85ca                	mv	a1,s2
    1532:	00004517          	auipc	a0,0x4
    1536:	4ae50513          	addi	a0,a0,1198 # 59e0 <malloc+0xacc>
    153a:	121030ef          	jal	ra,4e5a <printf>
    exit(1);
    153e:	4505                	li	a0,1
    1540:	4f8030ef          	jal	ra,4a38 <exit>
    close(fds[0]);
    1544:	fa842503          	lw	a0,-88(s0)
    1548:	518030ef          	jal	ra,4a60 <close>
    for(n = 0; n < N; n++){
    154c:	0000ab17          	auipc	s6,0xa
    1550:	72cb0b13          	addi	s6,s6,1836 # bc78 <buf>
    1554:	416004bb          	negw	s1,s6
    1558:	0ff4f493          	andi	s1,s1,255
    155c:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1560:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1562:	6a85                	lui	s5,0x1
    1564:	42da8a93          	addi	s5,s5,1069 # 142d <exectest+0xfd>
{
    1568:	87da                	mv	a5,s6
        buf[i] = seq++;
    156a:	0097873b          	addw	a4,a5,s1
    156e:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1572:	0785                	addi	a5,a5,1
    1574:	fef99be3          	bne	s3,a5,156a <pipe1+0xc6>
        buf[i] = seq++;
    1578:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    157c:	40900613          	li	a2,1033
    1580:	85de                	mv	a1,s7
    1582:	fac42503          	lw	a0,-84(s0)
    1586:	4d2030ef          	jal	ra,4a58 <write>
    158a:	40900793          	li	a5,1033
    158e:	00f51a63          	bne	a0,a5,15a2 <pipe1+0xfe>
    for(n = 0; n < N; n++){
    1592:	24a5                	addiw	s1,s1,9
    1594:	0ff4f493          	andi	s1,s1,255
    1598:	fd5a18e3          	bne	s4,s5,1568 <pipe1+0xc4>
    exit(0);
    159c:	4501                	li	a0,0
    159e:	49a030ef          	jal	ra,4a38 <exit>
        printf("%s: pipe1 oops 1\n", s);
    15a2:	85ca                	mv	a1,s2
    15a4:	00004517          	auipc	a0,0x4
    15a8:	45450513          	addi	a0,a0,1108 # 59f8 <malloc+0xae4>
    15ac:	0af030ef          	jal	ra,4e5a <printf>
        exit(1);
    15b0:	4505                	li	a0,1
    15b2:	486030ef          	jal	ra,4a38 <exit>
          printf("%s: pipe1 oops 2\n", s);
    15b6:	85ca                	mv	a1,s2
    15b8:	00004517          	auipc	a0,0x4
    15bc:	45850513          	addi	a0,a0,1112 # 5a10 <malloc+0xafc>
    15c0:	09b030ef          	jal	ra,4e5a <printf>
}
    15c4:	60e6                	ld	ra,88(sp)
    15c6:	6446                	ld	s0,80(sp)
    15c8:	64a6                	ld	s1,72(sp)
    15ca:	6906                	ld	s2,64(sp)
    15cc:	79e2                	ld	s3,56(sp)
    15ce:	7a42                	ld	s4,48(sp)
    15d0:	7aa2                	ld	s5,40(sp)
    15d2:	7b02                	ld	s6,32(sp)
    15d4:	6be2                	ld	s7,24(sp)
    15d6:	6125                	addi	sp,sp,96
    15d8:	8082                	ret
    if(total != N * SZ){
    15da:	6785                	lui	a5,0x1
    15dc:	42d78793          	addi	a5,a5,1069 # 142d <exectest+0xfd>
    15e0:	00fa0d63          	beq	s4,a5,15fa <pipe1+0x156>
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    15e4:	8652                	mv	a2,s4
    15e6:	85ca                	mv	a1,s2
    15e8:	00004517          	auipc	a0,0x4
    15ec:	44050513          	addi	a0,a0,1088 # 5a28 <malloc+0xb14>
    15f0:	06b030ef          	jal	ra,4e5a <printf>
      exit(1);
    15f4:	4505                	li	a0,1
    15f6:	442030ef          	jal	ra,4a38 <exit>
    close(fds[0]);
    15fa:	fa842503          	lw	a0,-88(s0)
    15fe:	462030ef          	jal	ra,4a60 <close>
    wait(&xstatus);
    1602:	fa440513          	addi	a0,s0,-92
    1606:	43a030ef          	jal	ra,4a40 <wait>
    exit(xstatus);
    160a:	fa442503          	lw	a0,-92(s0)
    160e:	42a030ef          	jal	ra,4a38 <exit>
    printf("%s: fork() failed\n", s);
    1612:	85ca                	mv	a1,s2
    1614:	00004517          	auipc	a0,0x4
    1618:	43450513          	addi	a0,a0,1076 # 5a48 <malloc+0xb34>
    161c:	03f030ef          	jal	ra,4e5a <printf>
    exit(1);
    1620:	4505                	li	a0,1
    1622:	416030ef          	jal	ra,4a38 <exit>

0000000000001626 <exitwait>:
{
    1626:	7139                	addi	sp,sp,-64
    1628:	fc06                	sd	ra,56(sp)
    162a:	f822                	sd	s0,48(sp)
    162c:	f426                	sd	s1,40(sp)
    162e:	f04a                	sd	s2,32(sp)
    1630:	ec4e                	sd	s3,24(sp)
    1632:	e852                	sd	s4,16(sp)
    1634:	0080                	addi	s0,sp,64
    1636:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1638:	4901                	li	s2,0
    163a:	06400993          	li	s3,100
    pid = fork();
    163e:	3f2030ef          	jal	ra,4a30 <fork>
    1642:	84aa                	mv	s1,a0
    if(pid < 0){
    1644:	02054863          	bltz	a0,1674 <exitwait+0x4e>
    if(pid){
    1648:	c525                	beqz	a0,16b0 <exitwait+0x8a>
      if(wait(&xstate) != pid){
    164a:	fcc40513          	addi	a0,s0,-52
    164e:	3f2030ef          	jal	ra,4a40 <wait>
    1652:	02951b63          	bne	a0,s1,1688 <exitwait+0x62>
      if(i != xstate) {
    1656:	fcc42783          	lw	a5,-52(s0)
    165a:	05279163          	bne	a5,s2,169c <exitwait+0x76>
  for(i = 0; i < 100; i++){
    165e:	2905                	addiw	s2,s2,1
    1660:	fd391fe3          	bne	s2,s3,163e <exitwait+0x18>
}
    1664:	70e2                	ld	ra,56(sp)
    1666:	7442                	ld	s0,48(sp)
    1668:	74a2                	ld	s1,40(sp)
    166a:	7902                	ld	s2,32(sp)
    166c:	69e2                	ld	s3,24(sp)
    166e:	6a42                	ld	s4,16(sp)
    1670:	6121                	addi	sp,sp,64
    1672:	8082                	ret
      printf("%s: fork failed\n", s);
    1674:	85d2                	mv	a1,s4
    1676:	00004517          	auipc	a0,0x4
    167a:	26250513          	addi	a0,a0,610 # 58d8 <malloc+0x9c4>
    167e:	7dc030ef          	jal	ra,4e5a <printf>
      exit(1);
    1682:	4505                	li	a0,1
    1684:	3b4030ef          	jal	ra,4a38 <exit>
        printf("%s: wait wrong pid\n", s);
    1688:	85d2                	mv	a1,s4
    168a:	00004517          	auipc	a0,0x4
    168e:	3d650513          	addi	a0,a0,982 # 5a60 <malloc+0xb4c>
    1692:	7c8030ef          	jal	ra,4e5a <printf>
        exit(1);
    1696:	4505                	li	a0,1
    1698:	3a0030ef          	jal	ra,4a38 <exit>
        printf("%s: wait wrong exit status\n", s);
    169c:	85d2                	mv	a1,s4
    169e:	00004517          	auipc	a0,0x4
    16a2:	3da50513          	addi	a0,a0,986 # 5a78 <malloc+0xb64>
    16a6:	7b4030ef          	jal	ra,4e5a <printf>
        exit(1);
    16aa:	4505                	li	a0,1
    16ac:	38c030ef          	jal	ra,4a38 <exit>
      exit(i);
    16b0:	854a                	mv	a0,s2
    16b2:	386030ef          	jal	ra,4a38 <exit>

00000000000016b6 <twochildren>:
{
    16b6:	1101                	addi	sp,sp,-32
    16b8:	ec06                	sd	ra,24(sp)
    16ba:	e822                	sd	s0,16(sp)
    16bc:	e426                	sd	s1,8(sp)
    16be:	e04a                	sd	s2,0(sp)
    16c0:	1000                	addi	s0,sp,32
    16c2:	892a                	mv	s2,a0
    16c4:	3e800493          	li	s1,1000
    int pid1 = fork();
    16c8:	368030ef          	jal	ra,4a30 <fork>
    if(pid1 < 0){
    16cc:	02054663          	bltz	a0,16f8 <twochildren+0x42>
    if(pid1 == 0){
    16d0:	cd15                	beqz	a0,170c <twochildren+0x56>
      int pid2 = fork();
    16d2:	35e030ef          	jal	ra,4a30 <fork>
      if(pid2 < 0){
    16d6:	02054d63          	bltz	a0,1710 <twochildren+0x5a>
      if(pid2 == 0){
    16da:	c529                	beqz	a0,1724 <twochildren+0x6e>
        wait(0);
    16dc:	4501                	li	a0,0
    16de:	362030ef          	jal	ra,4a40 <wait>
        wait(0);
    16e2:	4501                	li	a0,0
    16e4:	35c030ef          	jal	ra,4a40 <wait>
  for(int i = 0; i < 1000; i++){
    16e8:	34fd                	addiw	s1,s1,-1
    16ea:	fcf9                	bnez	s1,16c8 <twochildren+0x12>
}
    16ec:	60e2                	ld	ra,24(sp)
    16ee:	6442                	ld	s0,16(sp)
    16f0:	64a2                	ld	s1,8(sp)
    16f2:	6902                	ld	s2,0(sp)
    16f4:	6105                	addi	sp,sp,32
    16f6:	8082                	ret
      printf("%s: fork failed\n", s);
    16f8:	85ca                	mv	a1,s2
    16fa:	00004517          	auipc	a0,0x4
    16fe:	1de50513          	addi	a0,a0,478 # 58d8 <malloc+0x9c4>
    1702:	758030ef          	jal	ra,4e5a <printf>
      exit(1);
    1706:	4505                	li	a0,1
    1708:	330030ef          	jal	ra,4a38 <exit>
      exit(0);
    170c:	32c030ef          	jal	ra,4a38 <exit>
        printf("%s: fork failed\n", s);
    1710:	85ca                	mv	a1,s2
    1712:	00004517          	auipc	a0,0x4
    1716:	1c650513          	addi	a0,a0,454 # 58d8 <malloc+0x9c4>
    171a:	740030ef          	jal	ra,4e5a <printf>
        exit(1);
    171e:	4505                	li	a0,1
    1720:	318030ef          	jal	ra,4a38 <exit>
        exit(0);
    1724:	314030ef          	jal	ra,4a38 <exit>

0000000000001728 <forkfork>:
{
    1728:	7179                	addi	sp,sp,-48
    172a:	f406                	sd	ra,40(sp)
    172c:	f022                	sd	s0,32(sp)
    172e:	ec26                	sd	s1,24(sp)
    1730:	1800                	addi	s0,sp,48
    1732:	84aa                	mv	s1,a0
    int pid = fork();
    1734:	2fc030ef          	jal	ra,4a30 <fork>
    if(pid < 0){
    1738:	02054b63          	bltz	a0,176e <forkfork+0x46>
    if(pid == 0){
    173c:	c139                	beqz	a0,1782 <forkfork+0x5a>
    int pid = fork();
    173e:	2f2030ef          	jal	ra,4a30 <fork>
    if(pid < 0){
    1742:	02054663          	bltz	a0,176e <forkfork+0x46>
    if(pid == 0){
    1746:	cd15                	beqz	a0,1782 <forkfork+0x5a>
    wait(&xstatus);
    1748:	fdc40513          	addi	a0,s0,-36
    174c:	2f4030ef          	jal	ra,4a40 <wait>
    if(xstatus != 0) {
    1750:	fdc42783          	lw	a5,-36(s0)
    1754:	ebb9                	bnez	a5,17aa <forkfork+0x82>
    wait(&xstatus);
    1756:	fdc40513          	addi	a0,s0,-36
    175a:	2e6030ef          	jal	ra,4a40 <wait>
    if(xstatus != 0) {
    175e:	fdc42783          	lw	a5,-36(s0)
    1762:	e7a1                	bnez	a5,17aa <forkfork+0x82>
}
    1764:	70a2                	ld	ra,40(sp)
    1766:	7402                	ld	s0,32(sp)
    1768:	64e2                	ld	s1,24(sp)
    176a:	6145                	addi	sp,sp,48
    176c:	8082                	ret
      printf("%s: fork failed", s);
    176e:	85a6                	mv	a1,s1
    1770:	00004517          	auipc	a0,0x4
    1774:	32850513          	addi	a0,a0,808 # 5a98 <malloc+0xb84>
    1778:	6e2030ef          	jal	ra,4e5a <printf>
      exit(1);
    177c:	4505                	li	a0,1
    177e:	2ba030ef          	jal	ra,4a38 <exit>
{
    1782:	0c800493          	li	s1,200
        int pid1 = fork();
    1786:	2aa030ef          	jal	ra,4a30 <fork>
        if(pid1 < 0){
    178a:	00054b63          	bltz	a0,17a0 <forkfork+0x78>
        if(pid1 == 0){
    178e:	cd01                	beqz	a0,17a6 <forkfork+0x7e>
        wait(0);
    1790:	4501                	li	a0,0
    1792:	2ae030ef          	jal	ra,4a40 <wait>
      for(int j = 0; j < 200; j++){
    1796:	34fd                	addiw	s1,s1,-1
    1798:	f4fd                	bnez	s1,1786 <forkfork+0x5e>
      exit(0);
    179a:	4501                	li	a0,0
    179c:	29c030ef          	jal	ra,4a38 <exit>
          exit(1);
    17a0:	4505                	li	a0,1
    17a2:	296030ef          	jal	ra,4a38 <exit>
          exit(0);
    17a6:	292030ef          	jal	ra,4a38 <exit>
      printf("%s: fork in child failed", s);
    17aa:	85a6                	mv	a1,s1
    17ac:	00004517          	auipc	a0,0x4
    17b0:	2fc50513          	addi	a0,a0,764 # 5aa8 <malloc+0xb94>
    17b4:	6a6030ef          	jal	ra,4e5a <printf>
      exit(1);
    17b8:	4505                	li	a0,1
    17ba:	27e030ef          	jal	ra,4a38 <exit>

00000000000017be <reparent2>:
{
    17be:	1101                	addi	sp,sp,-32
    17c0:	ec06                	sd	ra,24(sp)
    17c2:	e822                	sd	s0,16(sp)
    17c4:	e426                	sd	s1,8(sp)
    17c6:	1000                	addi	s0,sp,32
    17c8:	32000493          	li	s1,800
    int pid1 = fork();
    17cc:	264030ef          	jal	ra,4a30 <fork>
    if(pid1 < 0){
    17d0:	00054b63          	bltz	a0,17e6 <reparent2+0x28>
    if(pid1 == 0){
    17d4:	c115                	beqz	a0,17f8 <reparent2+0x3a>
    wait(0);
    17d6:	4501                	li	a0,0
    17d8:	268030ef          	jal	ra,4a40 <wait>
  for(int i = 0; i < 800; i++){
    17dc:	34fd                	addiw	s1,s1,-1
    17de:	f4fd                	bnez	s1,17cc <reparent2+0xe>
  exit(0);
    17e0:	4501                	li	a0,0
    17e2:	256030ef          	jal	ra,4a38 <exit>
      printf("fork failed\n");
    17e6:	00005517          	auipc	a0,0x5
    17ea:	64250513          	addi	a0,a0,1602 # 6e28 <malloc+0x1f14>
    17ee:	66c030ef          	jal	ra,4e5a <printf>
      exit(1);
    17f2:	4505                	li	a0,1
    17f4:	244030ef          	jal	ra,4a38 <exit>
      fork();
    17f8:	238030ef          	jal	ra,4a30 <fork>
      fork();
    17fc:	234030ef          	jal	ra,4a30 <fork>
      exit(0);
    1800:	4501                	li	a0,0
    1802:	236030ef          	jal	ra,4a38 <exit>

0000000000001806 <createdelete>:
{
    1806:	7175                	addi	sp,sp,-144
    1808:	e506                	sd	ra,136(sp)
    180a:	e122                	sd	s0,128(sp)
    180c:	fca6                	sd	s1,120(sp)
    180e:	f8ca                	sd	s2,112(sp)
    1810:	f4ce                	sd	s3,104(sp)
    1812:	f0d2                	sd	s4,96(sp)
    1814:	ecd6                	sd	s5,88(sp)
    1816:	e8da                	sd	s6,80(sp)
    1818:	e4de                	sd	s7,72(sp)
    181a:	e0e2                	sd	s8,64(sp)
    181c:	fc66                	sd	s9,56(sp)
    181e:	0900                	addi	s0,sp,144
    1820:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1822:	4901                	li	s2,0
    1824:	4991                	li	s3,4
    pid = fork();
    1826:	20a030ef          	jal	ra,4a30 <fork>
    182a:	84aa                	mv	s1,a0
    if(pid < 0){
    182c:	02054d63          	bltz	a0,1866 <createdelete+0x60>
    if(pid == 0){
    1830:	c529                	beqz	a0,187a <createdelete+0x74>
  for(pi = 0; pi < NCHILD; pi++){
    1832:	2905                	addiw	s2,s2,1
    1834:	ff3919e3          	bne	s2,s3,1826 <createdelete+0x20>
    1838:	4491                	li	s1,4
    wait(&xstatus);
    183a:	f7c40513          	addi	a0,s0,-132
    183e:	202030ef          	jal	ra,4a40 <wait>
    if(xstatus != 0)
    1842:	f7c42903          	lw	s2,-132(s0)
    1846:	0a091e63          	bnez	s2,1902 <createdelete+0xfc>
  for(pi = 0; pi < NCHILD; pi++){
    184a:	34fd                	addiw	s1,s1,-1
    184c:	f4fd                	bnez	s1,183a <createdelete+0x34>
  name[0] = name[1] = name[2] = 0;
    184e:	f8040123          	sb	zero,-126(s0)
    1852:	03000993          	li	s3,48
    1856:	5a7d                	li	s4,-1
    1858:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    185c:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    185e:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1860:	07400a93          	li	s5,116
    1864:	a20d                	j	1986 <createdelete+0x180>
      printf("%s: fork failed\n", s);
    1866:	85e6                	mv	a1,s9
    1868:	00004517          	auipc	a0,0x4
    186c:	07050513          	addi	a0,a0,112 # 58d8 <malloc+0x9c4>
    1870:	5ea030ef          	jal	ra,4e5a <printf>
      exit(1);
    1874:	4505                	li	a0,1
    1876:	1c2030ef          	jal	ra,4a38 <exit>
      name[0] = 'p' + pi;
    187a:	0709091b          	addiw	s2,s2,112
    187e:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1882:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1886:	4951                	li	s2,20
    1888:	a831                	j	18a4 <createdelete+0x9e>
          printf("%s: create failed\n", s);
    188a:	85e6                	mv	a1,s9
    188c:	00004517          	auipc	a0,0x4
    1890:	0e450513          	addi	a0,a0,228 # 5970 <malloc+0xa5c>
    1894:	5c6030ef          	jal	ra,4e5a <printf>
          exit(1);
    1898:	4505                	li	a0,1
    189a:	19e030ef          	jal	ra,4a38 <exit>
      for(i = 0; i < N; i++){
    189e:	2485                	addiw	s1,s1,1
    18a0:	05248e63          	beq	s1,s2,18fc <createdelete+0xf6>
        name[1] = '0' + i;
    18a4:	0304879b          	addiw	a5,s1,48
    18a8:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    18ac:	20200593          	li	a1,514
    18b0:	f8040513          	addi	a0,s0,-128
    18b4:	1c4030ef          	jal	ra,4a78 <open>
        if(fd < 0){
    18b8:	fc0549e3          	bltz	a0,188a <createdelete+0x84>
        close(fd);
    18bc:	1a4030ef          	jal	ra,4a60 <close>
        if(i > 0 && (i % 2 ) == 0){
    18c0:	fc905fe3          	blez	s1,189e <createdelete+0x98>
    18c4:	0014f793          	andi	a5,s1,1
    18c8:	fbf9                	bnez	a5,189e <createdelete+0x98>
          name[1] = '0' + (i / 2);
    18ca:	01f4d79b          	srliw	a5,s1,0x1f
    18ce:	9fa5                	addw	a5,a5,s1
    18d0:	4017d79b          	sraiw	a5,a5,0x1
    18d4:	0307879b          	addiw	a5,a5,48
    18d8:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    18dc:	f8040513          	addi	a0,s0,-128
    18e0:	1a8030ef          	jal	ra,4a88 <unlink>
    18e4:	fa055de3          	bgez	a0,189e <createdelete+0x98>
            printf("%s: unlink failed\n", s);
    18e8:	85e6                	mv	a1,s9
    18ea:	00004517          	auipc	a0,0x4
    18ee:	1de50513          	addi	a0,a0,478 # 5ac8 <malloc+0xbb4>
    18f2:	568030ef          	jal	ra,4e5a <printf>
            exit(1);
    18f6:	4505                	li	a0,1
    18f8:	140030ef          	jal	ra,4a38 <exit>
      exit(0);
    18fc:	4501                	li	a0,0
    18fe:	13a030ef          	jal	ra,4a38 <exit>
      exit(1);
    1902:	4505                	li	a0,1
    1904:	134030ef          	jal	ra,4a38 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1908:	f8040613          	addi	a2,s0,-128
    190c:	85e6                	mv	a1,s9
    190e:	00004517          	auipc	a0,0x4
    1912:	1d250513          	addi	a0,a0,466 # 5ae0 <malloc+0xbcc>
    1916:	544030ef          	jal	ra,4e5a <printf>
        exit(1);
    191a:	4505                	li	a0,1
    191c:	11c030ef          	jal	ra,4a38 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1920:	034b7d63          	bgeu	s6,s4,195a <createdelete+0x154>
      if(fd >= 0)
    1924:	02055863          	bgez	a0,1954 <createdelete+0x14e>
    for(pi = 0; pi < NCHILD; pi++){
    1928:	2485                	addiw	s1,s1,1
    192a:	0ff4f493          	andi	s1,s1,255
    192e:	05548463          	beq	s1,s5,1976 <createdelete+0x170>
      name[0] = 'p' + pi;
    1932:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1936:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    193a:	4581                	li	a1,0
    193c:	f8040513          	addi	a0,s0,-128
    1940:	138030ef          	jal	ra,4a78 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1944:	00090463          	beqz	s2,194c <createdelete+0x146>
    1948:	fd2bdce3          	bge	s7,s2,1920 <createdelete+0x11a>
    194c:	fa054ee3          	bltz	a0,1908 <createdelete+0x102>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1950:	014b7763          	bgeu	s6,s4,195e <createdelete+0x158>
        close(fd);
    1954:	10c030ef          	jal	ra,4a60 <close>
    1958:	bfc1                	j	1928 <createdelete+0x122>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    195a:	fc0547e3          	bltz	a0,1928 <createdelete+0x122>
        printf("%s: oops createdelete %s did exist\n", s, name);
    195e:	f8040613          	addi	a2,s0,-128
    1962:	85e6                	mv	a1,s9
    1964:	00004517          	auipc	a0,0x4
    1968:	1a450513          	addi	a0,a0,420 # 5b08 <malloc+0xbf4>
    196c:	4ee030ef          	jal	ra,4e5a <printf>
        exit(1);
    1970:	4505                	li	a0,1
    1972:	0c6030ef          	jal	ra,4a38 <exit>
  for(i = 0; i < N; i++){
    1976:	2905                	addiw	s2,s2,1
    1978:	2a05                	addiw	s4,s4,1
    197a:	2985                	addiw	s3,s3,1
    197c:	0ff9f993          	andi	s3,s3,255
    1980:	47d1                	li	a5,20
    1982:	02f90863          	beq	s2,a5,19b2 <createdelete+0x1ac>
    for(pi = 0; pi < NCHILD; pi++){
    1986:	84e2                	mv	s1,s8
    1988:	b76d                	j	1932 <createdelete+0x12c>
  for(i = 0; i < N; i++){
    198a:	2905                	addiw	s2,s2,1
    198c:	0ff97913          	andi	s2,s2,255
    1990:	03490a63          	beq	s2,s4,19c4 <createdelete+0x1be>
  name[0] = name[1] = name[2] = 0;
    1994:	84d6                	mv	s1,s5
      name[0] = 'p' + pi;
    1996:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    199a:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    199e:	f8040513          	addi	a0,s0,-128
    19a2:	0e6030ef          	jal	ra,4a88 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    19a6:	2485                	addiw	s1,s1,1
    19a8:	0ff4f493          	andi	s1,s1,255
    19ac:	ff3495e3          	bne	s1,s3,1996 <createdelete+0x190>
    19b0:	bfe9                	j	198a <createdelete+0x184>
    19b2:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    19b6:	07000a93          	li	s5,112
    for(pi = 0; pi < NCHILD; pi++){
    19ba:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    19be:	04400a13          	li	s4,68
    19c2:	bfc9                	j	1994 <createdelete+0x18e>
}
    19c4:	60aa                	ld	ra,136(sp)
    19c6:	640a                	ld	s0,128(sp)
    19c8:	74e6                	ld	s1,120(sp)
    19ca:	7946                	ld	s2,112(sp)
    19cc:	79a6                	ld	s3,104(sp)
    19ce:	7a06                	ld	s4,96(sp)
    19d0:	6ae6                	ld	s5,88(sp)
    19d2:	6b46                	ld	s6,80(sp)
    19d4:	6ba6                	ld	s7,72(sp)
    19d6:	6c06                	ld	s8,64(sp)
    19d8:	7ce2                	ld	s9,56(sp)
    19da:	6149                	addi	sp,sp,144
    19dc:	8082                	ret

00000000000019de <linkunlink>:
{
    19de:	711d                	addi	sp,sp,-96
    19e0:	ec86                	sd	ra,88(sp)
    19e2:	e8a2                	sd	s0,80(sp)
    19e4:	e4a6                	sd	s1,72(sp)
    19e6:	e0ca                	sd	s2,64(sp)
    19e8:	fc4e                	sd	s3,56(sp)
    19ea:	f852                	sd	s4,48(sp)
    19ec:	f456                	sd	s5,40(sp)
    19ee:	f05a                	sd	s6,32(sp)
    19f0:	ec5e                	sd	s7,24(sp)
    19f2:	e862                	sd	s8,16(sp)
    19f4:	e466                	sd	s9,8(sp)
    19f6:	1080                	addi	s0,sp,96
    19f8:	84aa                	mv	s1,a0
  unlink("x");
    19fa:	00003517          	auipc	a0,0x3
    19fe:	6be50513          	addi	a0,a0,1726 # 50b8 <malloc+0x1a4>
    1a02:	086030ef          	jal	ra,4a88 <unlink>
  pid = fork();
    1a06:	02a030ef          	jal	ra,4a30 <fork>
  if(pid < 0){
    1a0a:	02054b63          	bltz	a0,1a40 <linkunlink+0x62>
    1a0e:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1a10:	4c85                	li	s9,1
    1a12:	e119                	bnez	a0,1a18 <linkunlink+0x3a>
    1a14:	06100c93          	li	s9,97
    1a18:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1a1c:	41c659b7          	lui	s3,0x41c65
    1a20:	e6d9899b          	addiw	s3,s3,-403
    1a24:	690d                	lui	s2,0x3
    1a26:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1a2a:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1a2c:	4b05                	li	s6,1
      unlink("x");
    1a2e:	00003a97          	auipc	s5,0x3
    1a32:	68aa8a93          	addi	s5,s5,1674 # 50b8 <malloc+0x1a4>
      link("cat", "x");
    1a36:	00004b97          	auipc	s7,0x4
    1a3a:	0fab8b93          	addi	s7,s7,250 # 5b30 <malloc+0xc1c>
    1a3e:	a025                	j	1a66 <linkunlink+0x88>
    printf("%s: fork failed\n", s);
    1a40:	85a6                	mv	a1,s1
    1a42:	00004517          	auipc	a0,0x4
    1a46:	e9650513          	addi	a0,a0,-362 # 58d8 <malloc+0x9c4>
    1a4a:	410030ef          	jal	ra,4e5a <printf>
    exit(1);
    1a4e:	4505                	li	a0,1
    1a50:	7e9020ef          	jal	ra,4a38 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1a54:	20200593          	li	a1,514
    1a58:	8556                	mv	a0,s5
    1a5a:	01e030ef          	jal	ra,4a78 <open>
    1a5e:	002030ef          	jal	ra,4a60 <close>
  for(i = 0; i < 100; i++){
    1a62:	34fd                	addiw	s1,s1,-1
    1a64:	c48d                	beqz	s1,1a8e <linkunlink+0xb0>
    x = x * 1103515245 + 12345;
    1a66:	033c87bb          	mulw	a5,s9,s3
    1a6a:	012787bb          	addw	a5,a5,s2
    1a6e:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1a72:	0347f7bb          	remuw	a5,a5,s4
    1a76:	dff9                	beqz	a5,1a54 <linkunlink+0x76>
    } else if((x % 3) == 1){
    1a78:	01678663          	beq	a5,s6,1a84 <linkunlink+0xa6>
      unlink("x");
    1a7c:	8556                	mv	a0,s5
    1a7e:	00a030ef          	jal	ra,4a88 <unlink>
    1a82:	b7c5                	j	1a62 <linkunlink+0x84>
      link("cat", "x");
    1a84:	85d6                	mv	a1,s5
    1a86:	855e                	mv	a0,s7
    1a88:	010030ef          	jal	ra,4a98 <link>
    1a8c:	bfd9                	j	1a62 <linkunlink+0x84>
  if(pid)
    1a8e:	020c0263          	beqz	s8,1ab2 <linkunlink+0xd4>
    wait(0);
    1a92:	4501                	li	a0,0
    1a94:	7ad020ef          	jal	ra,4a40 <wait>
}
    1a98:	60e6                	ld	ra,88(sp)
    1a9a:	6446                	ld	s0,80(sp)
    1a9c:	64a6                	ld	s1,72(sp)
    1a9e:	6906                	ld	s2,64(sp)
    1aa0:	79e2                	ld	s3,56(sp)
    1aa2:	7a42                	ld	s4,48(sp)
    1aa4:	7aa2                	ld	s5,40(sp)
    1aa6:	7b02                	ld	s6,32(sp)
    1aa8:	6be2                	ld	s7,24(sp)
    1aaa:	6c42                	ld	s8,16(sp)
    1aac:	6ca2                	ld	s9,8(sp)
    1aae:	6125                	addi	sp,sp,96
    1ab0:	8082                	ret
    exit(0);
    1ab2:	4501                	li	a0,0
    1ab4:	785020ef          	jal	ra,4a38 <exit>

0000000000001ab8 <forktest>:
{
    1ab8:	7179                	addi	sp,sp,-48
    1aba:	f406                	sd	ra,40(sp)
    1abc:	f022                	sd	s0,32(sp)
    1abe:	ec26                	sd	s1,24(sp)
    1ac0:	e84a                	sd	s2,16(sp)
    1ac2:	e44e                	sd	s3,8(sp)
    1ac4:	1800                	addi	s0,sp,48
    1ac6:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1ac8:	4481                	li	s1,0
    1aca:	3e800913          	li	s2,1000
    pid = fork();
    1ace:	763020ef          	jal	ra,4a30 <fork>
    if(pid < 0)
    1ad2:	02054263          	bltz	a0,1af6 <forktest+0x3e>
    if(pid == 0)
    1ad6:	cd11                	beqz	a0,1af2 <forktest+0x3a>
  for(n=0; n<N; n++){
    1ad8:	2485                	addiw	s1,s1,1
    1ada:	ff249ae3          	bne	s1,s2,1ace <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1ade:	85ce                	mv	a1,s3
    1ae0:	00004517          	auipc	a0,0x4
    1ae4:	07050513          	addi	a0,a0,112 # 5b50 <malloc+0xc3c>
    1ae8:	372030ef          	jal	ra,4e5a <printf>
    exit(1);
    1aec:	4505                	li	a0,1
    1aee:	74b020ef          	jal	ra,4a38 <exit>
      exit(0);
    1af2:	747020ef          	jal	ra,4a38 <exit>
  if (n == 0) {
    1af6:	c89d                	beqz	s1,1b2c <forktest+0x74>
  if(n == N){
    1af8:	3e800793          	li	a5,1000
    1afc:	fef481e3          	beq	s1,a5,1ade <forktest+0x26>
  for(; n > 0; n--){
    1b00:	00905963          	blez	s1,1b12 <forktest+0x5a>
    if(wait(0) < 0){
    1b04:	4501                	li	a0,0
    1b06:	73b020ef          	jal	ra,4a40 <wait>
    1b0a:	02054b63          	bltz	a0,1b40 <forktest+0x88>
  for(; n > 0; n--){
    1b0e:	34fd                	addiw	s1,s1,-1
    1b10:	f8f5                	bnez	s1,1b04 <forktest+0x4c>
  if(wait(0) != -1){
    1b12:	4501                	li	a0,0
    1b14:	72d020ef          	jal	ra,4a40 <wait>
    1b18:	57fd                	li	a5,-1
    1b1a:	02f51d63          	bne	a0,a5,1b54 <forktest+0x9c>
}
    1b1e:	70a2                	ld	ra,40(sp)
    1b20:	7402                	ld	s0,32(sp)
    1b22:	64e2                	ld	s1,24(sp)
    1b24:	6942                	ld	s2,16(sp)
    1b26:	69a2                	ld	s3,8(sp)
    1b28:	6145                	addi	sp,sp,48
    1b2a:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1b2c:	85ce                	mv	a1,s3
    1b2e:	00004517          	auipc	a0,0x4
    1b32:	00a50513          	addi	a0,a0,10 # 5b38 <malloc+0xc24>
    1b36:	324030ef          	jal	ra,4e5a <printf>
    exit(1);
    1b3a:	4505                	li	a0,1
    1b3c:	6fd020ef          	jal	ra,4a38 <exit>
      printf("%s: wait stopped early\n", s);
    1b40:	85ce                	mv	a1,s3
    1b42:	00004517          	auipc	a0,0x4
    1b46:	03650513          	addi	a0,a0,54 # 5b78 <malloc+0xc64>
    1b4a:	310030ef          	jal	ra,4e5a <printf>
      exit(1);
    1b4e:	4505                	li	a0,1
    1b50:	6e9020ef          	jal	ra,4a38 <exit>
    printf("%s: wait got too many\n", s);
    1b54:	85ce                	mv	a1,s3
    1b56:	00004517          	auipc	a0,0x4
    1b5a:	03a50513          	addi	a0,a0,58 # 5b90 <malloc+0xc7c>
    1b5e:	2fc030ef          	jal	ra,4e5a <printf>
    exit(1);
    1b62:	4505                	li	a0,1
    1b64:	6d5020ef          	jal	ra,4a38 <exit>

0000000000001b68 <kernmem>:
{
    1b68:	715d                	addi	sp,sp,-80
    1b6a:	e486                	sd	ra,72(sp)
    1b6c:	e0a2                	sd	s0,64(sp)
    1b6e:	fc26                	sd	s1,56(sp)
    1b70:	f84a                	sd	s2,48(sp)
    1b72:	f44e                	sd	s3,40(sp)
    1b74:	f052                	sd	s4,32(sp)
    1b76:	ec56                	sd	s5,24(sp)
    1b78:	0880                	addi	s0,sp,80
    1b7a:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1b7c:	4485                	li	s1,1
    1b7e:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1b80:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1b82:	69b1                	lui	s3,0xc
    1b84:	35098993          	addi	s3,s3,848 # c350 <buf+0x6d8>
    1b88:	1003d937          	lui	s2,0x1003d
    1b8c:	090e                	slli	s2,s2,0x3
    1b8e:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002e808>
    pid = fork();
    1b92:	69f020ef          	jal	ra,4a30 <fork>
    if(pid < 0){
    1b96:	02054763          	bltz	a0,1bc4 <kernmem+0x5c>
    if(pid == 0){
    1b9a:	cd1d                	beqz	a0,1bd8 <kernmem+0x70>
    wait(&xstatus);
    1b9c:	fbc40513          	addi	a0,s0,-68
    1ba0:	6a1020ef          	jal	ra,4a40 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1ba4:	fbc42783          	lw	a5,-68(s0)
    1ba8:	05579563          	bne	a5,s5,1bf2 <kernmem+0x8a>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1bac:	94ce                	add	s1,s1,s3
    1bae:	ff2492e3          	bne	s1,s2,1b92 <kernmem+0x2a>
}
    1bb2:	60a6                	ld	ra,72(sp)
    1bb4:	6406                	ld	s0,64(sp)
    1bb6:	74e2                	ld	s1,56(sp)
    1bb8:	7942                	ld	s2,48(sp)
    1bba:	79a2                	ld	s3,40(sp)
    1bbc:	7a02                	ld	s4,32(sp)
    1bbe:	6ae2                	ld	s5,24(sp)
    1bc0:	6161                	addi	sp,sp,80
    1bc2:	8082                	ret
      printf("%s: fork failed\n", s);
    1bc4:	85d2                	mv	a1,s4
    1bc6:	00004517          	auipc	a0,0x4
    1bca:	d1250513          	addi	a0,a0,-750 # 58d8 <malloc+0x9c4>
    1bce:	28c030ef          	jal	ra,4e5a <printf>
      exit(1);
    1bd2:	4505                	li	a0,1
    1bd4:	665020ef          	jal	ra,4a38 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1bd8:	0004c683          	lbu	a3,0(s1)
    1bdc:	8626                	mv	a2,s1
    1bde:	85d2                	mv	a1,s4
    1be0:	00004517          	auipc	a0,0x4
    1be4:	fc850513          	addi	a0,a0,-56 # 5ba8 <malloc+0xc94>
    1be8:	272030ef          	jal	ra,4e5a <printf>
      exit(1);
    1bec:	4505                	li	a0,1
    1bee:	64b020ef          	jal	ra,4a38 <exit>
      exit(1);
    1bf2:	4505                	li	a0,1
    1bf4:	645020ef          	jal	ra,4a38 <exit>

0000000000001bf8 <MAXVAplus>:
{
    1bf8:	7179                	addi	sp,sp,-48
    1bfa:	f406                	sd	ra,40(sp)
    1bfc:	f022                	sd	s0,32(sp)
    1bfe:	ec26                	sd	s1,24(sp)
    1c00:	e84a                	sd	s2,16(sp)
    1c02:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    1c04:	4785                	li	a5,1
    1c06:	179a                	slli	a5,a5,0x26
    1c08:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    1c0c:	fd843783          	ld	a5,-40(s0)
    1c10:	cb85                	beqz	a5,1c40 <MAXVAplus+0x48>
    1c12:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    1c14:	54fd                	li	s1,-1
    pid = fork();
    1c16:	61b020ef          	jal	ra,4a30 <fork>
    if(pid < 0){
    1c1a:	02054963          	bltz	a0,1c4c <MAXVAplus+0x54>
    if(pid == 0){
    1c1e:	c129                	beqz	a0,1c60 <MAXVAplus+0x68>
    wait(&xstatus);
    1c20:	fd440513          	addi	a0,s0,-44
    1c24:	61d020ef          	jal	ra,4a40 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1c28:	fd442783          	lw	a5,-44(s0)
    1c2c:	04979c63          	bne	a5,s1,1c84 <MAXVAplus+0x8c>
  for( ; a != 0; a <<= 1){
    1c30:	fd843783          	ld	a5,-40(s0)
    1c34:	0786                	slli	a5,a5,0x1
    1c36:	fcf43c23          	sd	a5,-40(s0)
    1c3a:	fd843783          	ld	a5,-40(s0)
    1c3e:	ffe1                	bnez	a5,1c16 <MAXVAplus+0x1e>
}
    1c40:	70a2                	ld	ra,40(sp)
    1c42:	7402                	ld	s0,32(sp)
    1c44:	64e2                	ld	s1,24(sp)
    1c46:	6942                	ld	s2,16(sp)
    1c48:	6145                	addi	sp,sp,48
    1c4a:	8082                	ret
      printf("%s: fork failed\n", s);
    1c4c:	85ca                	mv	a1,s2
    1c4e:	00004517          	auipc	a0,0x4
    1c52:	c8a50513          	addi	a0,a0,-886 # 58d8 <malloc+0x9c4>
    1c56:	204030ef          	jal	ra,4e5a <printf>
      exit(1);
    1c5a:	4505                	li	a0,1
    1c5c:	5dd020ef          	jal	ra,4a38 <exit>
      *(char*)a = 99;
    1c60:	fd843783          	ld	a5,-40(s0)
    1c64:	06300713          	li	a4,99
    1c68:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1c6c:	fd843603          	ld	a2,-40(s0)
    1c70:	85ca                	mv	a1,s2
    1c72:	00004517          	auipc	a0,0x4
    1c76:	f5650513          	addi	a0,a0,-170 # 5bc8 <malloc+0xcb4>
    1c7a:	1e0030ef          	jal	ra,4e5a <printf>
      exit(1);
    1c7e:	4505                	li	a0,1
    1c80:	5b9020ef          	jal	ra,4a38 <exit>
      exit(1);
    1c84:	4505                	li	a0,1
    1c86:	5b3020ef          	jal	ra,4a38 <exit>

0000000000001c8a <stacktest>:
{
    1c8a:	7179                	addi	sp,sp,-48
    1c8c:	f406                	sd	ra,40(sp)
    1c8e:	f022                	sd	s0,32(sp)
    1c90:	ec26                	sd	s1,24(sp)
    1c92:	1800                	addi	s0,sp,48
    1c94:	84aa                	mv	s1,a0
  pid = fork();
    1c96:	59b020ef          	jal	ra,4a30 <fork>
  if(pid == 0) {
    1c9a:	cd11                	beqz	a0,1cb6 <stacktest+0x2c>
  } else if(pid < 0){
    1c9c:	02054c63          	bltz	a0,1cd4 <stacktest+0x4a>
  wait(&xstatus);
    1ca0:	fdc40513          	addi	a0,s0,-36
    1ca4:	59d020ef          	jal	ra,4a40 <wait>
  if(xstatus == -1)  // kernel killed child?
    1ca8:	fdc42503          	lw	a0,-36(s0)
    1cac:	57fd                	li	a5,-1
    1cae:	02f50d63          	beq	a0,a5,1ce8 <stacktest+0x5e>
    exit(xstatus);
    1cb2:	587020ef          	jal	ra,4a38 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    1cb6:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1cb8:	77fd                	lui	a5,0xfffff
    1cba:	97ba                	add	a5,a5,a4
    1cbc:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xffffffffffff0388>
    1cc0:	85a6                	mv	a1,s1
    1cc2:	00004517          	auipc	a0,0x4
    1cc6:	f1e50513          	addi	a0,a0,-226 # 5be0 <malloc+0xccc>
    1cca:	190030ef          	jal	ra,4e5a <printf>
    exit(1);
    1cce:	4505                	li	a0,1
    1cd0:	569020ef          	jal	ra,4a38 <exit>
    printf("%s: fork failed\n", s);
    1cd4:	85a6                	mv	a1,s1
    1cd6:	00004517          	auipc	a0,0x4
    1cda:	c0250513          	addi	a0,a0,-1022 # 58d8 <malloc+0x9c4>
    1cde:	17c030ef          	jal	ra,4e5a <printf>
    exit(1);
    1ce2:	4505                	li	a0,1
    1ce4:	555020ef          	jal	ra,4a38 <exit>
    exit(0);
    1ce8:	4501                	li	a0,0
    1cea:	54f020ef          	jal	ra,4a38 <exit>

0000000000001cee <nowrite>:
{
    1cee:	7159                	addi	sp,sp,-112
    1cf0:	f486                	sd	ra,104(sp)
    1cf2:	f0a2                	sd	s0,96(sp)
    1cf4:	eca6                	sd	s1,88(sp)
    1cf6:	e8ca                	sd	s2,80(sp)
    1cf8:	e4ce                	sd	s3,72(sp)
    1cfa:	1880                	addi	s0,sp,112
    1cfc:	89aa                	mv	s3,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1cfe:	00005797          	auipc	a5,0x5
    1d02:	68278793          	addi	a5,a5,1666 # 7380 <malloc+0x246c>
    1d06:	7788                	ld	a0,40(a5)
    1d08:	7b8c                	ld	a1,48(a5)
    1d0a:	7f90                	ld	a2,56(a5)
    1d0c:	63b4                	ld	a3,64(a5)
    1d0e:	67b8                	ld	a4,72(a5)
    1d10:	6bbc                	ld	a5,80(a5)
    1d12:	f8a43c23          	sd	a0,-104(s0)
    1d16:	fab43023          	sd	a1,-96(s0)
    1d1a:	fac43423          	sd	a2,-88(s0)
    1d1e:	fad43823          	sd	a3,-80(s0)
    1d22:	fae43c23          	sd	a4,-72(s0)
    1d26:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d2a:	4481                	li	s1,0
    1d2c:	4919                	li	s2,6
    pid = fork();
    1d2e:	503020ef          	jal	ra,4a30 <fork>
    if(pid == 0) {
    1d32:	c105                	beqz	a0,1d52 <nowrite+0x64>
    } else if(pid < 0){
    1d34:	04054163          	bltz	a0,1d76 <nowrite+0x88>
    wait(&xstatus);
    1d38:	fcc40513          	addi	a0,s0,-52
    1d3c:	505020ef          	jal	ra,4a40 <wait>
    if(xstatus == 0){
    1d40:	fcc42783          	lw	a5,-52(s0)
    1d44:	c3b9                	beqz	a5,1d8a <nowrite+0x9c>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d46:	2485                	addiw	s1,s1,1
    1d48:	ff2493e3          	bne	s1,s2,1d2e <nowrite+0x40>
  exit(0);
    1d4c:	4501                	li	a0,0
    1d4e:	4eb020ef          	jal	ra,4a38 <exit>
      volatile int *addr = (int *) addrs[ai];
    1d52:	048e                	slli	s1,s1,0x3
    1d54:	fd040793          	addi	a5,s0,-48
    1d58:	94be                	add	s1,s1,a5
    1d5a:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1d5e:	47a9                	li	a5,10
    1d60:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1d62:	85ce                	mv	a1,s3
    1d64:	00004517          	auipc	a0,0x4
    1d68:	ea450513          	addi	a0,a0,-348 # 5c08 <malloc+0xcf4>
    1d6c:	0ee030ef          	jal	ra,4e5a <printf>
      exit(0);
    1d70:	4501                	li	a0,0
    1d72:	4c7020ef          	jal	ra,4a38 <exit>
      printf("%s: fork failed\n", s);
    1d76:	85ce                	mv	a1,s3
    1d78:	00004517          	auipc	a0,0x4
    1d7c:	b6050513          	addi	a0,a0,-1184 # 58d8 <malloc+0x9c4>
    1d80:	0da030ef          	jal	ra,4e5a <printf>
      exit(1);
    1d84:	4505                	li	a0,1
    1d86:	4b3020ef          	jal	ra,4a38 <exit>
      exit(1);
    1d8a:	4505                	li	a0,1
    1d8c:	4ad020ef          	jal	ra,4a38 <exit>

0000000000001d90 <manywrites>:
{
    1d90:	711d                	addi	sp,sp,-96
    1d92:	ec86                	sd	ra,88(sp)
    1d94:	e8a2                	sd	s0,80(sp)
    1d96:	e4a6                	sd	s1,72(sp)
    1d98:	e0ca                	sd	s2,64(sp)
    1d9a:	fc4e                	sd	s3,56(sp)
    1d9c:	f852                	sd	s4,48(sp)
    1d9e:	f456                	sd	s5,40(sp)
    1da0:	f05a                	sd	s6,32(sp)
    1da2:	ec5e                	sd	s7,24(sp)
    1da4:	1080                	addi	s0,sp,96
    1da6:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1da8:	4981                	li	s3,0
    1daa:	4911                	li	s2,4
    int pid = fork();
    1dac:	485020ef          	jal	ra,4a30 <fork>
    1db0:	84aa                	mv	s1,a0
    if(pid < 0){
    1db2:	02054563          	bltz	a0,1ddc <manywrites+0x4c>
    if(pid == 0){
    1db6:	cd05                	beqz	a0,1dee <manywrites+0x5e>
  for(int ci = 0; ci < nchildren; ci++){
    1db8:	2985                	addiw	s3,s3,1
    1dba:	ff2999e3          	bne	s3,s2,1dac <manywrites+0x1c>
    1dbe:	4491                	li	s1,4
    int st = 0;
    1dc0:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1dc4:	fa840513          	addi	a0,s0,-88
    1dc8:	479020ef          	jal	ra,4a40 <wait>
    if(st != 0)
    1dcc:	fa842503          	lw	a0,-88(s0)
    1dd0:	e169                	bnez	a0,1e92 <manywrites+0x102>
  for(int ci = 0; ci < nchildren; ci++){
    1dd2:	34fd                	addiw	s1,s1,-1
    1dd4:	f4f5                	bnez	s1,1dc0 <manywrites+0x30>
  exit(0);
    1dd6:	4501                	li	a0,0
    1dd8:	461020ef          	jal	ra,4a38 <exit>
      printf("fork failed\n");
    1ddc:	00005517          	auipc	a0,0x5
    1de0:	04c50513          	addi	a0,a0,76 # 6e28 <malloc+0x1f14>
    1de4:	076030ef          	jal	ra,4e5a <printf>
      exit(1);
    1de8:	4505                	li	a0,1
    1dea:	44f020ef          	jal	ra,4a38 <exit>
      name[0] = 'b';
    1dee:	06200793          	li	a5,98
    1df2:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1df6:	0619879b          	addiw	a5,s3,97
    1dfa:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1dfe:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1e02:	fa840513          	addi	a0,s0,-88
    1e06:	483020ef          	jal	ra,4a88 <unlink>
    1e0a:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1e0c:	0000ab17          	auipc	s6,0xa
    1e10:	e6cb0b13          	addi	s6,s6,-404 # bc78 <buf>
        for(int i = 0; i < ci+1; i++){
    1e14:	8a26                	mv	s4,s1
    1e16:	0209c863          	bltz	s3,1e46 <manywrites+0xb6>
          int fd = open(name, O_CREATE | O_RDWR);
    1e1a:	20200593          	li	a1,514
    1e1e:	fa840513          	addi	a0,s0,-88
    1e22:	457020ef          	jal	ra,4a78 <open>
    1e26:	892a                	mv	s2,a0
          if(fd < 0){
    1e28:	02054d63          	bltz	a0,1e62 <manywrites+0xd2>
          int cc = write(fd, buf, sz);
    1e2c:	660d                	lui	a2,0x3
    1e2e:	85da                	mv	a1,s6
    1e30:	429020ef          	jal	ra,4a58 <write>
          if(cc != sz){
    1e34:	678d                	lui	a5,0x3
    1e36:	04f51263          	bne	a0,a5,1e7a <manywrites+0xea>
          close(fd);
    1e3a:	854a                	mv	a0,s2
    1e3c:	425020ef          	jal	ra,4a60 <close>
        for(int i = 0; i < ci+1; i++){
    1e40:	2a05                	addiw	s4,s4,1
    1e42:	fd49dce3          	bge	s3,s4,1e1a <manywrites+0x8a>
        unlink(name);
    1e46:	fa840513          	addi	a0,s0,-88
    1e4a:	43f020ef          	jal	ra,4a88 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1e4e:	3bfd                	addiw	s7,s7,-1
    1e50:	fc0b92e3          	bnez	s7,1e14 <manywrites+0x84>
      unlink(name);
    1e54:	fa840513          	addi	a0,s0,-88
    1e58:	431020ef          	jal	ra,4a88 <unlink>
      exit(0);
    1e5c:	4501                	li	a0,0
    1e5e:	3db020ef          	jal	ra,4a38 <exit>
            printf("%s: cannot create %s\n", s, name);
    1e62:	fa840613          	addi	a2,s0,-88
    1e66:	85d6                	mv	a1,s5
    1e68:	00004517          	auipc	a0,0x4
    1e6c:	dc050513          	addi	a0,a0,-576 # 5c28 <malloc+0xd14>
    1e70:	7eb020ef          	jal	ra,4e5a <printf>
            exit(1);
    1e74:	4505                	li	a0,1
    1e76:	3c3020ef          	jal	ra,4a38 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1e7a:	86aa                	mv	a3,a0
    1e7c:	660d                	lui	a2,0x3
    1e7e:	85d6                	mv	a1,s5
    1e80:	00003517          	auipc	a0,0x3
    1e84:	29850513          	addi	a0,a0,664 # 5118 <malloc+0x204>
    1e88:	7d3020ef          	jal	ra,4e5a <printf>
            exit(1);
    1e8c:	4505                	li	a0,1
    1e8e:	3ab020ef          	jal	ra,4a38 <exit>
      exit(st);
    1e92:	3a7020ef          	jal	ra,4a38 <exit>

0000000000001e96 <copyinstr3>:
{
    1e96:	7179                	addi	sp,sp,-48
    1e98:	f406                	sd	ra,40(sp)
    1e9a:	f022                	sd	s0,32(sp)
    1e9c:	ec26                	sd	s1,24(sp)
    1e9e:	1800                	addi	s0,sp,48
  sbrk(8192);
    1ea0:	6509                	lui	a0,0x2
    1ea2:	41f020ef          	jal	ra,4ac0 <sbrk>
  uint64 top = (uint64) sbrk(0);
    1ea6:	4501                	li	a0,0
    1ea8:	419020ef          	jal	ra,4ac0 <sbrk>
  if((top % PGSIZE) != 0){
    1eac:	03451793          	slli	a5,a0,0x34
    1eb0:	e7bd                	bnez	a5,1f1e <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1eb2:	4501                	li	a0,0
    1eb4:	40d020ef          	jal	ra,4ac0 <sbrk>
  if(top % PGSIZE){
    1eb8:	03451793          	slli	a5,a0,0x34
    1ebc:	ebad                	bnez	a5,1f2e <copyinstr3+0x98>
  char *b = (char *) (top - 1);
    1ebe:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0x65>
  *b = 'x';
    1ec2:	07800793          	li	a5,120
    1ec6:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1eca:	8526                	mv	a0,s1
    1ecc:	3bd020ef          	jal	ra,4a88 <unlink>
  if(ret != -1){
    1ed0:	57fd                	li	a5,-1
    1ed2:	06f51763          	bne	a0,a5,1f40 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1ed6:	20100593          	li	a1,513
    1eda:	8526                	mv	a0,s1
    1edc:	39d020ef          	jal	ra,4a78 <open>
  if(fd != -1){
    1ee0:	57fd                	li	a5,-1
    1ee2:	06f51a63          	bne	a0,a5,1f56 <copyinstr3+0xc0>
  ret = link(b, b);
    1ee6:	85a6                	mv	a1,s1
    1ee8:	8526                	mv	a0,s1
    1eea:	3af020ef          	jal	ra,4a98 <link>
  if(ret != -1){
    1eee:	57fd                	li	a5,-1
    1ef0:	06f51e63          	bne	a0,a5,1f6c <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    1ef4:	00005797          	auipc	a5,0x5
    1ef8:	a3478793          	addi	a5,a5,-1484 # 6928 <malloc+0x1a14>
    1efc:	fcf43823          	sd	a5,-48(s0)
    1f00:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1f04:	fd040593          	addi	a1,s0,-48
    1f08:	8526                	mv	a0,s1
    1f0a:	367020ef          	jal	ra,4a70 <exec>
  if(ret != -1){
    1f0e:	57fd                	li	a5,-1
    1f10:	06f51a63          	bne	a0,a5,1f84 <copyinstr3+0xee>
}
    1f14:	70a2                	ld	ra,40(sp)
    1f16:	7402                	ld	s0,32(sp)
    1f18:	64e2                	ld	s1,24(sp)
    1f1a:	6145                	addi	sp,sp,48
    1f1c:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1f1e:	0347d513          	srli	a0,a5,0x34
    1f22:	6785                	lui	a5,0x1
    1f24:	40a7853b          	subw	a0,a5,a0
    1f28:	399020ef          	jal	ra,4ac0 <sbrk>
    1f2c:	b759                	j	1eb2 <copyinstr3+0x1c>
    printf("oops\n");
    1f2e:	00004517          	auipc	a0,0x4
    1f32:	d1250513          	addi	a0,a0,-750 # 5c40 <malloc+0xd2c>
    1f36:	725020ef          	jal	ra,4e5a <printf>
    exit(1);
    1f3a:	4505                	li	a0,1
    1f3c:	2fd020ef          	jal	ra,4a38 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1f40:	862a                	mv	a2,a0
    1f42:	85a6                	mv	a1,s1
    1f44:	00004517          	auipc	a0,0x4
    1f48:	8b450513          	addi	a0,a0,-1868 # 57f8 <malloc+0x8e4>
    1f4c:	70f020ef          	jal	ra,4e5a <printf>
    exit(1);
    1f50:	4505                	li	a0,1
    1f52:	2e7020ef          	jal	ra,4a38 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1f56:	862a                	mv	a2,a0
    1f58:	85a6                	mv	a1,s1
    1f5a:	00004517          	auipc	a0,0x4
    1f5e:	8be50513          	addi	a0,a0,-1858 # 5818 <malloc+0x904>
    1f62:	6f9020ef          	jal	ra,4e5a <printf>
    exit(1);
    1f66:	4505                	li	a0,1
    1f68:	2d1020ef          	jal	ra,4a38 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1f6c:	86aa                	mv	a3,a0
    1f6e:	8626                	mv	a2,s1
    1f70:	85a6                	mv	a1,s1
    1f72:	00004517          	auipc	a0,0x4
    1f76:	8c650513          	addi	a0,a0,-1850 # 5838 <malloc+0x924>
    1f7a:	6e1020ef          	jal	ra,4e5a <printf>
    exit(1);
    1f7e:	4505                	li	a0,1
    1f80:	2b9020ef          	jal	ra,4a38 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1f84:	567d                	li	a2,-1
    1f86:	85a6                	mv	a1,s1
    1f88:	00004517          	auipc	a0,0x4
    1f8c:	8d850513          	addi	a0,a0,-1832 # 5860 <malloc+0x94c>
    1f90:	6cb020ef          	jal	ra,4e5a <printf>
    exit(1);
    1f94:	4505                	li	a0,1
    1f96:	2a3020ef          	jal	ra,4a38 <exit>

0000000000001f9a <rwsbrk>:
{
    1f9a:	1101                	addi	sp,sp,-32
    1f9c:	ec06                	sd	ra,24(sp)
    1f9e:	e822                	sd	s0,16(sp)
    1fa0:	e426                	sd	s1,8(sp)
    1fa2:	e04a                	sd	s2,0(sp)
    1fa4:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    1fa6:	6509                	lui	a0,0x2
    1fa8:	319020ef          	jal	ra,4ac0 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    1fac:	57fd                	li	a5,-1
    1fae:	04f50963          	beq	a0,a5,2000 <rwsbrk+0x66>
    1fb2:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    1fb4:	7579                	lui	a0,0xffffe
    1fb6:	30b020ef          	jal	ra,4ac0 <sbrk>
    1fba:	57fd                	li	a5,-1
    1fbc:	04f50b63          	beq	a0,a5,2012 <rwsbrk+0x78>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    1fc0:	20100593          	li	a1,513
    1fc4:	00004517          	auipc	a0,0x4
    1fc8:	cbc50513          	addi	a0,a0,-836 # 5c80 <malloc+0xd6c>
    1fcc:	2ad020ef          	jal	ra,4a78 <open>
    1fd0:	892a                	mv	s2,a0
  if(fd < 0){
    1fd2:	04054963          	bltz	a0,2024 <rwsbrk+0x8a>
  n = write(fd, (void*)(a+4096), 1024);
    1fd6:	6505                	lui	a0,0x1
    1fd8:	94aa                	add	s1,s1,a0
    1fda:	40000613          	li	a2,1024
    1fde:	85a6                	mv	a1,s1
    1fe0:	854a                	mv	a0,s2
    1fe2:	277020ef          	jal	ra,4a58 <write>
    1fe6:	862a                	mv	a2,a0
  if(n >= 0){
    1fe8:	04054763          	bltz	a0,2036 <rwsbrk+0x9c>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+4096, n);
    1fec:	85a6                	mv	a1,s1
    1fee:	00004517          	auipc	a0,0x4
    1ff2:	cb250513          	addi	a0,a0,-846 # 5ca0 <malloc+0xd8c>
    1ff6:	665020ef          	jal	ra,4e5a <printf>
    exit(1);
    1ffa:	4505                	li	a0,1
    1ffc:	23d020ef          	jal	ra,4a38 <exit>
    printf("sbrk(rwsbrk) failed\n");
    2000:	00004517          	auipc	a0,0x4
    2004:	c4850513          	addi	a0,a0,-952 # 5c48 <malloc+0xd34>
    2008:	653020ef          	jal	ra,4e5a <printf>
    exit(1);
    200c:	4505                	li	a0,1
    200e:	22b020ef          	jal	ra,4a38 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    2012:	00004517          	auipc	a0,0x4
    2016:	c4e50513          	addi	a0,a0,-946 # 5c60 <malloc+0xd4c>
    201a:	641020ef          	jal	ra,4e5a <printf>
    exit(1);
    201e:	4505                	li	a0,1
    2020:	219020ef          	jal	ra,4a38 <exit>
    printf("open(rwsbrk) failed\n");
    2024:	00004517          	auipc	a0,0x4
    2028:	c6450513          	addi	a0,a0,-924 # 5c88 <malloc+0xd74>
    202c:	62f020ef          	jal	ra,4e5a <printf>
    exit(1);
    2030:	4505                	li	a0,1
    2032:	207020ef          	jal	ra,4a38 <exit>
  close(fd);
    2036:	854a                	mv	a0,s2
    2038:	229020ef          	jal	ra,4a60 <close>
  unlink("rwsbrk");
    203c:	00004517          	auipc	a0,0x4
    2040:	c4450513          	addi	a0,a0,-956 # 5c80 <malloc+0xd6c>
    2044:	245020ef          	jal	ra,4a88 <unlink>
  fd = open("README", O_RDONLY);
    2048:	4581                	li	a1,0
    204a:	00003517          	auipc	a0,0x3
    204e:	1d650513          	addi	a0,a0,470 # 5220 <malloc+0x30c>
    2052:	227020ef          	jal	ra,4a78 <open>
    2056:	892a                	mv	s2,a0
  if(fd < 0){
    2058:	02054363          	bltz	a0,207e <rwsbrk+0xe4>
  n = read(fd, (void*)(a+4096), 10);
    205c:	4629                	li	a2,10
    205e:	85a6                	mv	a1,s1
    2060:	1f1020ef          	jal	ra,4a50 <read>
    2064:	862a                	mv	a2,a0
  if(n >= 0){
    2066:	02054563          	bltz	a0,2090 <rwsbrk+0xf6>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+4096, n);
    206a:	85a6                	mv	a1,s1
    206c:	00004517          	auipc	a0,0x4
    2070:	c6450513          	addi	a0,a0,-924 # 5cd0 <malloc+0xdbc>
    2074:	5e7020ef          	jal	ra,4e5a <printf>
    exit(1);
    2078:	4505                	li	a0,1
    207a:	1bf020ef          	jal	ra,4a38 <exit>
    printf("open(rwsbrk) failed\n");
    207e:	00004517          	auipc	a0,0x4
    2082:	c0a50513          	addi	a0,a0,-1014 # 5c88 <malloc+0xd74>
    2086:	5d5020ef          	jal	ra,4e5a <printf>
    exit(1);
    208a:	4505                	li	a0,1
    208c:	1ad020ef          	jal	ra,4a38 <exit>
  close(fd);
    2090:	854a                	mv	a0,s2
    2092:	1cf020ef          	jal	ra,4a60 <close>
  exit(0);
    2096:	4501                	li	a0,0
    2098:	1a1020ef          	jal	ra,4a38 <exit>

000000000000209c <sbrkbasic>:
{
    209c:	7139                	addi	sp,sp,-64
    209e:	fc06                	sd	ra,56(sp)
    20a0:	f822                	sd	s0,48(sp)
    20a2:	f426                	sd	s1,40(sp)
    20a4:	f04a                	sd	s2,32(sp)
    20a6:	ec4e                	sd	s3,24(sp)
    20a8:	e852                	sd	s4,16(sp)
    20aa:	0080                	addi	s0,sp,64
    20ac:	8a2a                	mv	s4,a0
  pid = fork();
    20ae:	183020ef          	jal	ra,4a30 <fork>
  if(pid < 0){
    20b2:	02054863          	bltz	a0,20e2 <sbrkbasic+0x46>
  if(pid == 0){
    20b6:	e131                	bnez	a0,20fa <sbrkbasic+0x5e>
    a = sbrk(TOOMUCH);
    20b8:	40000537          	lui	a0,0x40000
    20bc:	205020ef          	jal	ra,4ac0 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    20c0:	57fd                	li	a5,-1
    20c2:	02f50963          	beq	a0,a5,20f4 <sbrkbasic+0x58>
    for(b = a; b < a+TOOMUCH; b += 4096){
    20c6:	400007b7          	lui	a5,0x40000
    20ca:	97aa                	add	a5,a5,a0
      *b = 99;
    20cc:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    20d0:	6705                	lui	a4,0x1
      *b = 99;
    20d2:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff1388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    20d6:	953a                	add	a0,a0,a4
    20d8:	fef51de3          	bne	a0,a5,20d2 <sbrkbasic+0x36>
    exit(1);
    20dc:	4505                	li	a0,1
    20de:	15b020ef          	jal	ra,4a38 <exit>
    printf("fork failed in sbrkbasic\n");
    20e2:	00004517          	auipc	a0,0x4
    20e6:	c1650513          	addi	a0,a0,-1002 # 5cf8 <malloc+0xde4>
    20ea:	571020ef          	jal	ra,4e5a <printf>
    exit(1);
    20ee:	4505                	li	a0,1
    20f0:	149020ef          	jal	ra,4a38 <exit>
      exit(0);
    20f4:	4501                	li	a0,0
    20f6:	143020ef          	jal	ra,4a38 <exit>
  wait(&xstatus);
    20fa:	fcc40513          	addi	a0,s0,-52
    20fe:	143020ef          	jal	ra,4a40 <wait>
  if(xstatus == 1){
    2102:	fcc42703          	lw	a4,-52(s0)
    2106:	4785                	li	a5,1
    2108:	00f70b63          	beq	a4,a5,211e <sbrkbasic+0x82>
  a = sbrk(0);
    210c:	4501                	li	a0,0
    210e:	1b3020ef          	jal	ra,4ac0 <sbrk>
    2112:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2114:	4901                	li	s2,0
    2116:	6985                	lui	s3,0x1
    2118:	38898993          	addi	s3,s3,904 # 1388 <exectest+0x58>
    211c:	a821                	j	2134 <sbrkbasic+0x98>
    printf("%s: too much memory allocated!\n", s);
    211e:	85d2                	mv	a1,s4
    2120:	00004517          	auipc	a0,0x4
    2124:	bf850513          	addi	a0,a0,-1032 # 5d18 <malloc+0xe04>
    2128:	533020ef          	jal	ra,4e5a <printf>
    exit(1);
    212c:	4505                	li	a0,1
    212e:	10b020ef          	jal	ra,4a38 <exit>
    a = b + 1;
    2132:	84be                	mv	s1,a5
    b = sbrk(1);
    2134:	4505                	li	a0,1
    2136:	18b020ef          	jal	ra,4ac0 <sbrk>
    if(b != a){
    213a:	04951263          	bne	a0,s1,217e <sbrkbasic+0xe2>
    *b = 1;
    213e:	4785                	li	a5,1
    2140:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2144:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2148:	2905                	addiw	s2,s2,1
    214a:	ff3914e3          	bne	s2,s3,2132 <sbrkbasic+0x96>
  pid = fork();
    214e:	0e3020ef          	jal	ra,4a30 <fork>
    2152:	892a                	mv	s2,a0
  if(pid < 0){
    2154:	04054263          	bltz	a0,2198 <sbrkbasic+0xfc>
  c = sbrk(1);
    2158:	4505                	li	a0,1
    215a:	167020ef          	jal	ra,4ac0 <sbrk>
  c = sbrk(1);
    215e:	4505                	li	a0,1
    2160:	161020ef          	jal	ra,4ac0 <sbrk>
  if(c != a + 1){
    2164:	0489                	addi	s1,s1,2
    2166:	04a48363          	beq	s1,a0,21ac <sbrkbasic+0x110>
    printf("%s: sbrk test failed post-fork\n", s);
    216a:	85d2                	mv	a1,s4
    216c:	00004517          	auipc	a0,0x4
    2170:	c0c50513          	addi	a0,a0,-1012 # 5d78 <malloc+0xe64>
    2174:	4e7020ef          	jal	ra,4e5a <printf>
    exit(1);
    2178:	4505                	li	a0,1
    217a:	0bf020ef          	jal	ra,4a38 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    217e:	872a                	mv	a4,a0
    2180:	86a6                	mv	a3,s1
    2182:	864a                	mv	a2,s2
    2184:	85d2                	mv	a1,s4
    2186:	00004517          	auipc	a0,0x4
    218a:	bb250513          	addi	a0,a0,-1102 # 5d38 <malloc+0xe24>
    218e:	4cd020ef          	jal	ra,4e5a <printf>
      exit(1);
    2192:	4505                	li	a0,1
    2194:	0a5020ef          	jal	ra,4a38 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2198:	85d2                	mv	a1,s4
    219a:	00004517          	auipc	a0,0x4
    219e:	bbe50513          	addi	a0,a0,-1090 # 5d58 <malloc+0xe44>
    21a2:	4b9020ef          	jal	ra,4e5a <printf>
    exit(1);
    21a6:	4505                	li	a0,1
    21a8:	091020ef          	jal	ra,4a38 <exit>
  if(pid == 0)
    21ac:	00091563          	bnez	s2,21b6 <sbrkbasic+0x11a>
    exit(0);
    21b0:	4501                	li	a0,0
    21b2:	087020ef          	jal	ra,4a38 <exit>
  wait(&xstatus);
    21b6:	fcc40513          	addi	a0,s0,-52
    21ba:	087020ef          	jal	ra,4a40 <wait>
  exit(xstatus);
    21be:	fcc42503          	lw	a0,-52(s0)
    21c2:	077020ef          	jal	ra,4a38 <exit>

00000000000021c6 <sbrkmuch>:
{
    21c6:	7179                	addi	sp,sp,-48
    21c8:	f406                	sd	ra,40(sp)
    21ca:	f022                	sd	s0,32(sp)
    21cc:	ec26                	sd	s1,24(sp)
    21ce:	e84a                	sd	s2,16(sp)
    21d0:	e44e                	sd	s3,8(sp)
    21d2:	e052                	sd	s4,0(sp)
    21d4:	1800                	addi	s0,sp,48
    21d6:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    21d8:	4501                	li	a0,0
    21da:	0e7020ef          	jal	ra,4ac0 <sbrk>
    21de:	892a                	mv	s2,a0
  a = sbrk(0);
    21e0:	4501                	li	a0,0
    21e2:	0df020ef          	jal	ra,4ac0 <sbrk>
    21e6:	84aa                	mv	s1,a0
  p = sbrk(amt);
    21e8:	06400537          	lui	a0,0x6400
    21ec:	9d05                	subw	a0,a0,s1
    21ee:	0d3020ef          	jal	ra,4ac0 <sbrk>
  if (p != a) {
    21f2:	0aa49463          	bne	s1,a0,229a <sbrkmuch+0xd4>
  char *eee = sbrk(0);
    21f6:	4501                	li	a0,0
    21f8:	0c9020ef          	jal	ra,4ac0 <sbrk>
    21fc:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    21fe:	00a4f963          	bgeu	s1,a0,2210 <sbrkmuch+0x4a>
    *pp = 1;
    2202:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2204:	6705                	lui	a4,0x1
    *pp = 1;
    2206:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    220a:	94ba                	add	s1,s1,a4
    220c:	fef4ede3          	bltu	s1,a5,2206 <sbrkmuch+0x40>
  *lastaddr = 99;
    2210:	064007b7          	lui	a5,0x6400
    2214:	06300713          	li	a4,99
    2218:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f1387>
  a = sbrk(0);
    221c:	4501                	li	a0,0
    221e:	0a3020ef          	jal	ra,4ac0 <sbrk>
    2222:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2224:	757d                	lui	a0,0xfffff
    2226:	09b020ef          	jal	ra,4ac0 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    222a:	57fd                	li	a5,-1
    222c:	08f50163          	beq	a0,a5,22ae <sbrkmuch+0xe8>
  c = sbrk(0);
    2230:	4501                	li	a0,0
    2232:	08f020ef          	jal	ra,4ac0 <sbrk>
  if(c != a - PGSIZE){
    2236:	77fd                	lui	a5,0xfffff
    2238:	97a6                	add	a5,a5,s1
    223a:	08f51463          	bne	a0,a5,22c2 <sbrkmuch+0xfc>
  a = sbrk(0);
    223e:	4501                	li	a0,0
    2240:	081020ef          	jal	ra,4ac0 <sbrk>
    2244:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2246:	6505                	lui	a0,0x1
    2248:	079020ef          	jal	ra,4ac0 <sbrk>
    224c:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    224e:	08a49663          	bne	s1,a0,22da <sbrkmuch+0x114>
    2252:	4501                	li	a0,0
    2254:	06d020ef          	jal	ra,4ac0 <sbrk>
    2258:	6785                	lui	a5,0x1
    225a:	97a6                	add	a5,a5,s1
    225c:	06f51f63          	bne	a0,a5,22da <sbrkmuch+0x114>
  if(*lastaddr == 99){
    2260:	064007b7          	lui	a5,0x6400
    2264:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f1387>
    2268:	06300793          	li	a5,99
    226c:	08f70363          	beq	a4,a5,22f2 <sbrkmuch+0x12c>
  a = sbrk(0);
    2270:	4501                	li	a0,0
    2272:	04f020ef          	jal	ra,4ac0 <sbrk>
    2276:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2278:	4501                	li	a0,0
    227a:	047020ef          	jal	ra,4ac0 <sbrk>
    227e:	40a9053b          	subw	a0,s2,a0
    2282:	03f020ef          	jal	ra,4ac0 <sbrk>
  if(c != a){
    2286:	08a49063          	bne	s1,a0,2306 <sbrkmuch+0x140>
}
    228a:	70a2                	ld	ra,40(sp)
    228c:	7402                	ld	s0,32(sp)
    228e:	64e2                	ld	s1,24(sp)
    2290:	6942                	ld	s2,16(sp)
    2292:	69a2                	ld	s3,8(sp)
    2294:	6a02                	ld	s4,0(sp)
    2296:	6145                	addi	sp,sp,48
    2298:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    229a:	85ce                	mv	a1,s3
    229c:	00004517          	auipc	a0,0x4
    22a0:	afc50513          	addi	a0,a0,-1284 # 5d98 <malloc+0xe84>
    22a4:	3b7020ef          	jal	ra,4e5a <printf>
    exit(1);
    22a8:	4505                	li	a0,1
    22aa:	78e020ef          	jal	ra,4a38 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    22ae:	85ce                	mv	a1,s3
    22b0:	00004517          	auipc	a0,0x4
    22b4:	b3050513          	addi	a0,a0,-1232 # 5de0 <malloc+0xecc>
    22b8:	3a3020ef          	jal	ra,4e5a <printf>
    exit(1);
    22bc:	4505                	li	a0,1
    22be:	77a020ef          	jal	ra,4a38 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    22c2:	86aa                	mv	a3,a0
    22c4:	8626                	mv	a2,s1
    22c6:	85ce                	mv	a1,s3
    22c8:	00004517          	auipc	a0,0x4
    22cc:	b3850513          	addi	a0,a0,-1224 # 5e00 <malloc+0xeec>
    22d0:	38b020ef          	jal	ra,4e5a <printf>
    exit(1);
    22d4:	4505                	li	a0,1
    22d6:	762020ef          	jal	ra,4a38 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    22da:	86d2                	mv	a3,s4
    22dc:	8626                	mv	a2,s1
    22de:	85ce                	mv	a1,s3
    22e0:	00004517          	auipc	a0,0x4
    22e4:	b6050513          	addi	a0,a0,-1184 # 5e40 <malloc+0xf2c>
    22e8:	373020ef          	jal	ra,4e5a <printf>
    exit(1);
    22ec:	4505                	li	a0,1
    22ee:	74a020ef          	jal	ra,4a38 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    22f2:	85ce                	mv	a1,s3
    22f4:	00004517          	auipc	a0,0x4
    22f8:	b7c50513          	addi	a0,a0,-1156 # 5e70 <malloc+0xf5c>
    22fc:	35f020ef          	jal	ra,4e5a <printf>
    exit(1);
    2300:	4505                	li	a0,1
    2302:	736020ef          	jal	ra,4a38 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    2306:	86aa                	mv	a3,a0
    2308:	8626                	mv	a2,s1
    230a:	85ce                	mv	a1,s3
    230c:	00004517          	auipc	a0,0x4
    2310:	b9c50513          	addi	a0,a0,-1124 # 5ea8 <malloc+0xf94>
    2314:	347020ef          	jal	ra,4e5a <printf>
    exit(1);
    2318:	4505                	li	a0,1
    231a:	71e020ef          	jal	ra,4a38 <exit>

000000000000231e <sbrkarg>:
{
    231e:	7179                	addi	sp,sp,-48
    2320:	f406                	sd	ra,40(sp)
    2322:	f022                	sd	s0,32(sp)
    2324:	ec26                	sd	s1,24(sp)
    2326:	e84a                	sd	s2,16(sp)
    2328:	e44e                	sd	s3,8(sp)
    232a:	1800                	addi	s0,sp,48
    232c:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    232e:	6505                	lui	a0,0x1
    2330:	790020ef          	jal	ra,4ac0 <sbrk>
    2334:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2336:	20100593          	li	a1,513
    233a:	00004517          	auipc	a0,0x4
    233e:	b9650513          	addi	a0,a0,-1130 # 5ed0 <malloc+0xfbc>
    2342:	736020ef          	jal	ra,4a78 <open>
    2346:	84aa                	mv	s1,a0
  unlink("sbrk");
    2348:	00004517          	auipc	a0,0x4
    234c:	b8850513          	addi	a0,a0,-1144 # 5ed0 <malloc+0xfbc>
    2350:	738020ef          	jal	ra,4a88 <unlink>
  if(fd < 0)  {
    2354:	0204c963          	bltz	s1,2386 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2358:	6605                	lui	a2,0x1
    235a:	85ca                	mv	a1,s2
    235c:	8526                	mv	a0,s1
    235e:	6fa020ef          	jal	ra,4a58 <write>
    2362:	02054c63          	bltz	a0,239a <sbrkarg+0x7c>
  close(fd);
    2366:	8526                	mv	a0,s1
    2368:	6f8020ef          	jal	ra,4a60 <close>
  a = sbrk(PGSIZE);
    236c:	6505                	lui	a0,0x1
    236e:	752020ef          	jal	ra,4ac0 <sbrk>
  if(pipe((int *) a) != 0){
    2372:	6d6020ef          	jal	ra,4a48 <pipe>
    2376:	ed05                	bnez	a0,23ae <sbrkarg+0x90>
}
    2378:	70a2                	ld	ra,40(sp)
    237a:	7402                	ld	s0,32(sp)
    237c:	64e2                	ld	s1,24(sp)
    237e:	6942                	ld	s2,16(sp)
    2380:	69a2                	ld	s3,8(sp)
    2382:	6145                	addi	sp,sp,48
    2384:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2386:	85ce                	mv	a1,s3
    2388:	00004517          	auipc	a0,0x4
    238c:	b5050513          	addi	a0,a0,-1200 # 5ed8 <malloc+0xfc4>
    2390:	2cb020ef          	jal	ra,4e5a <printf>
    exit(1);
    2394:	4505                	li	a0,1
    2396:	6a2020ef          	jal	ra,4a38 <exit>
    printf("%s: write sbrk failed\n", s);
    239a:	85ce                	mv	a1,s3
    239c:	00004517          	auipc	a0,0x4
    23a0:	b5450513          	addi	a0,a0,-1196 # 5ef0 <malloc+0xfdc>
    23a4:	2b7020ef          	jal	ra,4e5a <printf>
    exit(1);
    23a8:	4505                	li	a0,1
    23aa:	68e020ef          	jal	ra,4a38 <exit>
    printf("%s: pipe() failed\n", s);
    23ae:	85ce                	mv	a1,s3
    23b0:	00003517          	auipc	a0,0x3
    23b4:	63050513          	addi	a0,a0,1584 # 59e0 <malloc+0xacc>
    23b8:	2a3020ef          	jal	ra,4e5a <printf>
    exit(1);
    23bc:	4505                	li	a0,1
    23be:	67a020ef          	jal	ra,4a38 <exit>

00000000000023c2 <argptest>:
{
    23c2:	1101                	addi	sp,sp,-32
    23c4:	ec06                	sd	ra,24(sp)
    23c6:	e822                	sd	s0,16(sp)
    23c8:	e426                	sd	s1,8(sp)
    23ca:	e04a                	sd	s2,0(sp)
    23cc:	1000                	addi	s0,sp,32
    23ce:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    23d0:	4581                	li	a1,0
    23d2:	00004517          	auipc	a0,0x4
    23d6:	b3650513          	addi	a0,a0,-1226 # 5f08 <malloc+0xff4>
    23da:	69e020ef          	jal	ra,4a78 <open>
  if (fd < 0) {
    23de:	02054563          	bltz	a0,2408 <argptest+0x46>
    23e2:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    23e4:	4501                	li	a0,0
    23e6:	6da020ef          	jal	ra,4ac0 <sbrk>
    23ea:	567d                	li	a2,-1
    23ec:	fff50593          	addi	a1,a0,-1
    23f0:	8526                	mv	a0,s1
    23f2:	65e020ef          	jal	ra,4a50 <read>
  close(fd);
    23f6:	8526                	mv	a0,s1
    23f8:	668020ef          	jal	ra,4a60 <close>
}
    23fc:	60e2                	ld	ra,24(sp)
    23fe:	6442                	ld	s0,16(sp)
    2400:	64a2                	ld	s1,8(sp)
    2402:	6902                	ld	s2,0(sp)
    2404:	6105                	addi	sp,sp,32
    2406:	8082                	ret
    printf("%s: open failed\n", s);
    2408:	85ca                	mv	a1,s2
    240a:	00003517          	auipc	a0,0x3
    240e:	4e650513          	addi	a0,a0,1254 # 58f0 <malloc+0x9dc>
    2412:	249020ef          	jal	ra,4e5a <printf>
    exit(1);
    2416:	4505                	li	a0,1
    2418:	620020ef          	jal	ra,4a38 <exit>

000000000000241c <sbrkbugs>:
{
    241c:	1141                	addi	sp,sp,-16
    241e:	e406                	sd	ra,8(sp)
    2420:	e022                	sd	s0,0(sp)
    2422:	0800                	addi	s0,sp,16
  int pid = fork();
    2424:	60c020ef          	jal	ra,4a30 <fork>
  if(pid < 0){
    2428:	00054c63          	bltz	a0,2440 <sbrkbugs+0x24>
  if(pid == 0){
    242c:	e11d                	bnez	a0,2452 <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    242e:	692020ef          	jal	ra,4ac0 <sbrk>
    sbrk(-sz);
    2432:	40a0053b          	negw	a0,a0
    2436:	68a020ef          	jal	ra,4ac0 <sbrk>
    exit(0);
    243a:	4501                	li	a0,0
    243c:	5fc020ef          	jal	ra,4a38 <exit>
    printf("fork failed\n");
    2440:	00005517          	auipc	a0,0x5
    2444:	9e850513          	addi	a0,a0,-1560 # 6e28 <malloc+0x1f14>
    2448:	213020ef          	jal	ra,4e5a <printf>
    exit(1);
    244c:	4505                	li	a0,1
    244e:	5ea020ef          	jal	ra,4a38 <exit>
  wait(0);
    2452:	4501                	li	a0,0
    2454:	5ec020ef          	jal	ra,4a40 <wait>
  pid = fork();
    2458:	5d8020ef          	jal	ra,4a30 <fork>
  if(pid < 0){
    245c:	00054f63          	bltz	a0,247a <sbrkbugs+0x5e>
  if(pid == 0){
    2460:	e515                	bnez	a0,248c <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    2462:	65e020ef          	jal	ra,4ac0 <sbrk>
    sbrk(-(sz - 3500));
    2466:	6785                	lui	a5,0x1
    2468:	dac7879b          	addiw	a5,a5,-596
    246c:	40a7853b          	subw	a0,a5,a0
    2470:	650020ef          	jal	ra,4ac0 <sbrk>
    exit(0);
    2474:	4501                	li	a0,0
    2476:	5c2020ef          	jal	ra,4a38 <exit>
    printf("fork failed\n");
    247a:	00005517          	auipc	a0,0x5
    247e:	9ae50513          	addi	a0,a0,-1618 # 6e28 <malloc+0x1f14>
    2482:	1d9020ef          	jal	ra,4e5a <printf>
    exit(1);
    2486:	4505                	li	a0,1
    2488:	5b0020ef          	jal	ra,4a38 <exit>
  wait(0);
    248c:	4501                	li	a0,0
    248e:	5b2020ef          	jal	ra,4a40 <wait>
  pid = fork();
    2492:	59e020ef          	jal	ra,4a30 <fork>
  if(pid < 0){
    2496:	02054263          	bltz	a0,24ba <sbrkbugs+0x9e>
  if(pid == 0){
    249a:	e90d                	bnez	a0,24cc <sbrkbugs+0xb0>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    249c:	624020ef          	jal	ra,4ac0 <sbrk>
    24a0:	67ad                	lui	a5,0xb
    24a2:	8007879b          	addiw	a5,a5,-2048
    24a6:	40a7853b          	subw	a0,a5,a0
    24aa:	616020ef          	jal	ra,4ac0 <sbrk>
    sbrk(-10);
    24ae:	5559                	li	a0,-10
    24b0:	610020ef          	jal	ra,4ac0 <sbrk>
    exit(0);
    24b4:	4501                	li	a0,0
    24b6:	582020ef          	jal	ra,4a38 <exit>
    printf("fork failed\n");
    24ba:	00005517          	auipc	a0,0x5
    24be:	96e50513          	addi	a0,a0,-1682 # 6e28 <malloc+0x1f14>
    24c2:	199020ef          	jal	ra,4e5a <printf>
    exit(1);
    24c6:	4505                	li	a0,1
    24c8:	570020ef          	jal	ra,4a38 <exit>
  wait(0);
    24cc:	4501                	li	a0,0
    24ce:	572020ef          	jal	ra,4a40 <wait>
  exit(0);
    24d2:	4501                	li	a0,0
    24d4:	564020ef          	jal	ra,4a38 <exit>

00000000000024d8 <sbrklast>:
{
    24d8:	7179                	addi	sp,sp,-48
    24da:	f406                	sd	ra,40(sp)
    24dc:	f022                	sd	s0,32(sp)
    24de:	ec26                	sd	s1,24(sp)
    24e0:	e84a                	sd	s2,16(sp)
    24e2:	e44e                	sd	s3,8(sp)
    24e4:	e052                	sd	s4,0(sp)
    24e6:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    24e8:	4501                	li	a0,0
    24ea:	5d6020ef          	jal	ra,4ac0 <sbrk>
  if((top % 4096) != 0)
    24ee:	03451793          	slli	a5,a0,0x34
    24f2:	ebad                	bnez	a5,2564 <sbrklast+0x8c>
  sbrk(4096);
    24f4:	6505                	lui	a0,0x1
    24f6:	5ca020ef          	jal	ra,4ac0 <sbrk>
  sbrk(10);
    24fa:	4529                	li	a0,10
    24fc:	5c4020ef          	jal	ra,4ac0 <sbrk>
  sbrk(-20);
    2500:	5531                	li	a0,-20
    2502:	5be020ef          	jal	ra,4ac0 <sbrk>
  top = (uint64) sbrk(0);
    2506:	4501                	li	a0,0
    2508:	5b8020ef          	jal	ra,4ac0 <sbrk>
    250c:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    250e:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x120>
  p[0] = 'x';
    2512:	07800a13          	li	s4,120
    2516:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    251a:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    251e:	20200593          	li	a1,514
    2522:	854a                	mv	a0,s2
    2524:	554020ef          	jal	ra,4a78 <open>
    2528:	89aa                	mv	s3,a0
  write(fd, p, 1);
    252a:	4605                	li	a2,1
    252c:	85ca                	mv	a1,s2
    252e:	52a020ef          	jal	ra,4a58 <write>
  close(fd);
    2532:	854e                	mv	a0,s3
    2534:	52c020ef          	jal	ra,4a60 <close>
  fd = open(p, O_RDWR);
    2538:	4589                	li	a1,2
    253a:	854a                	mv	a0,s2
    253c:	53c020ef          	jal	ra,4a78 <open>
  p[0] = '\0';
    2540:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2544:	4605                	li	a2,1
    2546:	85ca                	mv	a1,s2
    2548:	508020ef          	jal	ra,4a50 <read>
  if(p[0] != 'x')
    254c:	fc04c783          	lbu	a5,-64(s1)
    2550:	03479263          	bne	a5,s4,2574 <sbrklast+0x9c>
}
    2554:	70a2                	ld	ra,40(sp)
    2556:	7402                	ld	s0,32(sp)
    2558:	64e2                	ld	s1,24(sp)
    255a:	6942                	ld	s2,16(sp)
    255c:	69a2                	ld	s3,8(sp)
    255e:	6a02                	ld	s4,0(sp)
    2560:	6145                	addi	sp,sp,48
    2562:	8082                	ret
    sbrk(4096 - (top % 4096));
    2564:	0347d513          	srli	a0,a5,0x34
    2568:	6785                	lui	a5,0x1
    256a:	40a7853b          	subw	a0,a5,a0
    256e:	552020ef          	jal	ra,4ac0 <sbrk>
    2572:	b749                	j	24f4 <sbrklast+0x1c>
    exit(1);
    2574:	4505                	li	a0,1
    2576:	4c2020ef          	jal	ra,4a38 <exit>

000000000000257a <sbrk8000>:
{
    257a:	1141                	addi	sp,sp,-16
    257c:	e406                	sd	ra,8(sp)
    257e:	e022                	sd	s0,0(sp)
    2580:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2582:	80000537          	lui	a0,0x80000
    2586:	0511                	addi	a0,a0,4
    2588:	538020ef          	jal	ra,4ac0 <sbrk>
  volatile char *top = sbrk(0);
    258c:	4501                	li	a0,0
    258e:	532020ef          	jal	ra,4ac0 <sbrk>
  *(top-1) = *(top-1) + 1;
    2592:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <base+0xffffffff7fff1387>
    2596:	0785                	addi	a5,a5,1
    2598:	0ff7f793          	andi	a5,a5,255
    259c:	fef50fa3          	sb	a5,-1(a0)
}
    25a0:	60a2                	ld	ra,8(sp)
    25a2:	6402                	ld	s0,0(sp)
    25a4:	0141                	addi	sp,sp,16
    25a6:	8082                	ret

00000000000025a8 <execout>:
{
    25a8:	715d                	addi	sp,sp,-80
    25aa:	e486                	sd	ra,72(sp)
    25ac:	e0a2                	sd	s0,64(sp)
    25ae:	fc26                	sd	s1,56(sp)
    25b0:	f84a                	sd	s2,48(sp)
    25b2:	f44e                	sd	s3,40(sp)
    25b4:	f052                	sd	s4,32(sp)
    25b6:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    25b8:	4901                	li	s2,0
    25ba:	49bd                	li	s3,15
    int pid = fork();
    25bc:	474020ef          	jal	ra,4a30 <fork>
    25c0:	84aa                	mv	s1,a0
    if(pid < 0){
    25c2:	00054c63          	bltz	a0,25da <execout+0x32>
    } else if(pid == 0){
    25c6:	c11d                	beqz	a0,25ec <execout+0x44>
      wait((int*)0);
    25c8:	4501                	li	a0,0
    25ca:	476020ef          	jal	ra,4a40 <wait>
  for(int avail = 0; avail < 15; avail++){
    25ce:	2905                	addiw	s2,s2,1
    25d0:	ff3916e3          	bne	s2,s3,25bc <execout+0x14>
  exit(0);
    25d4:	4501                	li	a0,0
    25d6:	462020ef          	jal	ra,4a38 <exit>
      printf("fork failed\n");
    25da:	00005517          	auipc	a0,0x5
    25de:	84e50513          	addi	a0,a0,-1970 # 6e28 <malloc+0x1f14>
    25e2:	079020ef          	jal	ra,4e5a <printf>
      exit(1);
    25e6:	4505                	li	a0,1
    25e8:	450020ef          	jal	ra,4a38 <exit>
        if(a == 0xffffffffffffffffLL)
    25ec:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    25ee:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    25f0:	6505                	lui	a0,0x1
    25f2:	4ce020ef          	jal	ra,4ac0 <sbrk>
        if(a == 0xffffffffffffffffLL)
    25f6:	01350763          	beq	a0,s3,2604 <execout+0x5c>
        *(char*)(a + 4096 - 1) = 1;
    25fa:	6785                	lui	a5,0x1
    25fc:	953e                	add	a0,a0,a5
    25fe:	ff450fa3          	sb	s4,-1(a0) # fff <pgbug+0x29>
      while(1){
    2602:	b7fd                	j	25f0 <execout+0x48>
      for(int i = 0; i < avail; i++)
    2604:	01205863          	blez	s2,2614 <execout+0x6c>
        sbrk(-4096);
    2608:	757d                	lui	a0,0xfffff
    260a:	4b6020ef          	jal	ra,4ac0 <sbrk>
      for(int i = 0; i < avail; i++)
    260e:	2485                	addiw	s1,s1,1
    2610:	ff249ce3          	bne	s1,s2,2608 <execout+0x60>
      close(1);
    2614:	4505                	li	a0,1
    2616:	44a020ef          	jal	ra,4a60 <close>
      char *args[] = { "echo", "x", 0 };
    261a:	00003517          	auipc	a0,0x3
    261e:	a2e50513          	addi	a0,a0,-1490 # 5048 <malloc+0x134>
    2622:	faa43c23          	sd	a0,-72(s0)
    2626:	00003797          	auipc	a5,0x3
    262a:	a9278793          	addi	a5,a5,-1390 # 50b8 <malloc+0x1a4>
    262e:	fcf43023          	sd	a5,-64(s0)
    2632:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2636:	fb840593          	addi	a1,s0,-72
    263a:	436020ef          	jal	ra,4a70 <exec>
      exit(0);
    263e:	4501                	li	a0,0
    2640:	3f8020ef          	jal	ra,4a38 <exit>

0000000000002644 <fourteen>:
{
    2644:	1101                	addi	sp,sp,-32
    2646:	ec06                	sd	ra,24(sp)
    2648:	e822                	sd	s0,16(sp)
    264a:	e426                	sd	s1,8(sp)
    264c:	1000                	addi	s0,sp,32
    264e:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2650:	00004517          	auipc	a0,0x4
    2654:	a9050513          	addi	a0,a0,-1392 # 60e0 <malloc+0x11cc>
    2658:	448020ef          	jal	ra,4aa0 <mkdir>
    265c:	e555                	bnez	a0,2708 <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    265e:	00004517          	auipc	a0,0x4
    2662:	8da50513          	addi	a0,a0,-1830 # 5f38 <malloc+0x1024>
    2666:	43a020ef          	jal	ra,4aa0 <mkdir>
    266a:	e94d                	bnez	a0,271c <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    266c:	20000593          	li	a1,512
    2670:	00004517          	auipc	a0,0x4
    2674:	92050513          	addi	a0,a0,-1760 # 5f90 <malloc+0x107c>
    2678:	400020ef          	jal	ra,4a78 <open>
  if(fd < 0){
    267c:	0a054a63          	bltz	a0,2730 <fourteen+0xec>
  close(fd);
    2680:	3e0020ef          	jal	ra,4a60 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2684:	4581                	li	a1,0
    2686:	00004517          	auipc	a0,0x4
    268a:	98250513          	addi	a0,a0,-1662 # 6008 <malloc+0x10f4>
    268e:	3ea020ef          	jal	ra,4a78 <open>
  if(fd < 0){
    2692:	0a054963          	bltz	a0,2744 <fourteen+0x100>
  close(fd);
    2696:	3ca020ef          	jal	ra,4a60 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    269a:	00004517          	auipc	a0,0x4
    269e:	9de50513          	addi	a0,a0,-1570 # 6078 <malloc+0x1164>
    26a2:	3fe020ef          	jal	ra,4aa0 <mkdir>
    26a6:	c94d                	beqz	a0,2758 <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    26a8:	00004517          	auipc	a0,0x4
    26ac:	a2850513          	addi	a0,a0,-1496 # 60d0 <malloc+0x11bc>
    26b0:	3f0020ef          	jal	ra,4aa0 <mkdir>
    26b4:	cd45                	beqz	a0,276c <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    26b6:	00004517          	auipc	a0,0x4
    26ba:	a1a50513          	addi	a0,a0,-1510 # 60d0 <malloc+0x11bc>
    26be:	3ca020ef          	jal	ra,4a88 <unlink>
  unlink("12345678901234/12345678901234");
    26c2:	00004517          	auipc	a0,0x4
    26c6:	9b650513          	addi	a0,a0,-1610 # 6078 <malloc+0x1164>
    26ca:	3be020ef          	jal	ra,4a88 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    26ce:	00004517          	auipc	a0,0x4
    26d2:	93a50513          	addi	a0,a0,-1734 # 6008 <malloc+0x10f4>
    26d6:	3b2020ef          	jal	ra,4a88 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    26da:	00004517          	auipc	a0,0x4
    26de:	8b650513          	addi	a0,a0,-1866 # 5f90 <malloc+0x107c>
    26e2:	3a6020ef          	jal	ra,4a88 <unlink>
  unlink("12345678901234/123456789012345");
    26e6:	00004517          	auipc	a0,0x4
    26ea:	85250513          	addi	a0,a0,-1966 # 5f38 <malloc+0x1024>
    26ee:	39a020ef          	jal	ra,4a88 <unlink>
  unlink("12345678901234");
    26f2:	00004517          	auipc	a0,0x4
    26f6:	9ee50513          	addi	a0,a0,-1554 # 60e0 <malloc+0x11cc>
    26fa:	38e020ef          	jal	ra,4a88 <unlink>
}
    26fe:	60e2                	ld	ra,24(sp)
    2700:	6442                	ld	s0,16(sp)
    2702:	64a2                	ld	s1,8(sp)
    2704:	6105                	addi	sp,sp,32
    2706:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2708:	85a6                	mv	a1,s1
    270a:	00004517          	auipc	a0,0x4
    270e:	80650513          	addi	a0,a0,-2042 # 5f10 <malloc+0xffc>
    2712:	748020ef          	jal	ra,4e5a <printf>
    exit(1);
    2716:	4505                	li	a0,1
    2718:	320020ef          	jal	ra,4a38 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    271c:	85a6                	mv	a1,s1
    271e:	00004517          	auipc	a0,0x4
    2722:	83a50513          	addi	a0,a0,-1990 # 5f58 <malloc+0x1044>
    2726:	734020ef          	jal	ra,4e5a <printf>
    exit(1);
    272a:	4505                	li	a0,1
    272c:	30c020ef          	jal	ra,4a38 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2730:	85a6                	mv	a1,s1
    2732:	00004517          	auipc	a0,0x4
    2736:	88e50513          	addi	a0,a0,-1906 # 5fc0 <malloc+0x10ac>
    273a:	720020ef          	jal	ra,4e5a <printf>
    exit(1);
    273e:	4505                	li	a0,1
    2740:	2f8020ef          	jal	ra,4a38 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2744:	85a6                	mv	a1,s1
    2746:	00004517          	auipc	a0,0x4
    274a:	8f250513          	addi	a0,a0,-1806 # 6038 <malloc+0x1124>
    274e:	70c020ef          	jal	ra,4e5a <printf>
    exit(1);
    2752:	4505                	li	a0,1
    2754:	2e4020ef          	jal	ra,4a38 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2758:	85a6                	mv	a1,s1
    275a:	00004517          	auipc	a0,0x4
    275e:	93e50513          	addi	a0,a0,-1730 # 6098 <malloc+0x1184>
    2762:	6f8020ef          	jal	ra,4e5a <printf>
    exit(1);
    2766:	4505                	li	a0,1
    2768:	2d0020ef          	jal	ra,4a38 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    276c:	85a6                	mv	a1,s1
    276e:	00004517          	auipc	a0,0x4
    2772:	98250513          	addi	a0,a0,-1662 # 60f0 <malloc+0x11dc>
    2776:	6e4020ef          	jal	ra,4e5a <printf>
    exit(1);
    277a:	4505                	li	a0,1
    277c:	2bc020ef          	jal	ra,4a38 <exit>

0000000000002780 <diskfull>:
{
    2780:	b8010113          	addi	sp,sp,-1152
    2784:	46113c23          	sd	ra,1144(sp)
    2788:	46813823          	sd	s0,1136(sp)
    278c:	46913423          	sd	s1,1128(sp)
    2790:	47213023          	sd	s2,1120(sp)
    2794:	45313c23          	sd	s3,1112(sp)
    2798:	45413823          	sd	s4,1104(sp)
    279c:	45513423          	sd	s5,1096(sp)
    27a0:	45613023          	sd	s6,1088(sp)
    27a4:	43713c23          	sd	s7,1080(sp)
    27a8:	43813823          	sd	s8,1072(sp)
    27ac:	43913423          	sd	s9,1064(sp)
    27b0:	48010413          	addi	s0,sp,1152
    27b4:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    27b6:	00004517          	auipc	a0,0x4
    27ba:	97250513          	addi	a0,a0,-1678 # 6128 <malloc+0x1214>
    27be:	2ca020ef          	jal	ra,4a88 <unlink>
    27c2:	03000993          	li	s3,48
    name[0] = 'b';
    27c6:	06200b13          	li	s6,98
    name[1] = 'i';
    27ca:	06900a93          	li	s5,105
    name[2] = 'g';
    27ce:	06700a13          	li	s4,103
    27d2:	10c00b93          	li	s7,268
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    27d6:	07f00c13          	li	s8,127
    27da:	aab9                	j	2938 <diskfull+0x1b8>
      printf("%s: could not create file %s\n", s, name);
    27dc:	b8040613          	addi	a2,s0,-1152
    27e0:	85e6                	mv	a1,s9
    27e2:	00004517          	auipc	a0,0x4
    27e6:	95650513          	addi	a0,a0,-1706 # 6138 <malloc+0x1224>
    27ea:	670020ef          	jal	ra,4e5a <printf>
      break;
    27ee:	a039                	j	27fc <diskfull+0x7c>
        close(fd);
    27f0:	854a                	mv	a0,s2
    27f2:	26e020ef          	jal	ra,4a60 <close>
    close(fd);
    27f6:	854a                	mv	a0,s2
    27f8:	268020ef          	jal	ra,4a60 <close>
  for(int i = 0; i < nzz; i++){
    27fc:	4481                	li	s1,0
    name[0] = 'z';
    27fe:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    2802:	08000993          	li	s3,128
    name[0] = 'z';
    2806:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    280a:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    280e:	41f4d79b          	sraiw	a5,s1,0x1f
    2812:	01b7d71b          	srliw	a4,a5,0x1b
    2816:	009707bb          	addw	a5,a4,s1
    281a:	4057d69b          	sraiw	a3,a5,0x5
    281e:	0306869b          	addiw	a3,a3,48
    2822:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    2826:	8bfd                	andi	a5,a5,31
    2828:	9f99                	subw	a5,a5,a4
    282a:	0307879b          	addiw	a5,a5,48
    282e:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    2832:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    2836:	ba040513          	addi	a0,s0,-1120
    283a:	24e020ef          	jal	ra,4a88 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    283e:	60200593          	li	a1,1538
    2842:	ba040513          	addi	a0,s0,-1120
    2846:	232020ef          	jal	ra,4a78 <open>
    if(fd < 0)
    284a:	00054763          	bltz	a0,2858 <diskfull+0xd8>
    close(fd);
    284e:	212020ef          	jal	ra,4a60 <close>
  for(int i = 0; i < nzz; i++){
    2852:	2485                	addiw	s1,s1,1
    2854:	fb3499e3          	bne	s1,s3,2806 <diskfull+0x86>
  if(mkdir("diskfulldir") == 0)
    2858:	00004517          	auipc	a0,0x4
    285c:	8d050513          	addi	a0,a0,-1840 # 6128 <malloc+0x1214>
    2860:	240020ef          	jal	ra,4aa0 <mkdir>
    2864:	12050063          	beqz	a0,2984 <diskfull+0x204>
  unlink("diskfulldir");
    2868:	00004517          	auipc	a0,0x4
    286c:	8c050513          	addi	a0,a0,-1856 # 6128 <malloc+0x1214>
    2870:	218020ef          	jal	ra,4a88 <unlink>
  for(int i = 0; i < nzz; i++){
    2874:	4481                	li	s1,0
    name[0] = 'z';
    2876:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    287a:	08000993          	li	s3,128
    name[0] = 'z';
    287e:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    2882:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    2886:	41f4d79b          	sraiw	a5,s1,0x1f
    288a:	01b7d71b          	srliw	a4,a5,0x1b
    288e:	009707bb          	addw	a5,a4,s1
    2892:	4057d69b          	sraiw	a3,a5,0x5
    2896:	0306869b          	addiw	a3,a3,48
    289a:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    289e:	8bfd                	andi	a5,a5,31
    28a0:	9f99                	subw	a5,a5,a4
    28a2:	0307879b          	addiw	a5,a5,48
    28a6:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    28aa:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    28ae:	ba040513          	addi	a0,s0,-1120
    28b2:	1d6020ef          	jal	ra,4a88 <unlink>
  for(int i = 0; i < nzz; i++){
    28b6:	2485                	addiw	s1,s1,1
    28b8:	fd3493e3          	bne	s1,s3,287e <diskfull+0xfe>
    28bc:	03000493          	li	s1,48
    name[0] = 'b';
    28c0:	06200a93          	li	s5,98
    name[1] = 'i';
    28c4:	06900a13          	li	s4,105
    name[2] = 'g';
    28c8:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    28cc:	07f00913          	li	s2,127
    name[0] = 'b';
    28d0:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    28d4:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    28d8:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    28dc:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    28e0:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    28e4:	ba040513          	addi	a0,s0,-1120
    28e8:	1a0020ef          	jal	ra,4a88 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    28ec:	2485                	addiw	s1,s1,1
    28ee:	0ff4f493          	andi	s1,s1,255
    28f2:	fd249fe3          	bne	s1,s2,28d0 <diskfull+0x150>
}
    28f6:	47813083          	ld	ra,1144(sp)
    28fa:	47013403          	ld	s0,1136(sp)
    28fe:	46813483          	ld	s1,1128(sp)
    2902:	46013903          	ld	s2,1120(sp)
    2906:	45813983          	ld	s3,1112(sp)
    290a:	45013a03          	ld	s4,1104(sp)
    290e:	44813a83          	ld	s5,1096(sp)
    2912:	44013b03          	ld	s6,1088(sp)
    2916:	43813b83          	ld	s7,1080(sp)
    291a:	43013c03          	ld	s8,1072(sp)
    291e:	42813c83          	ld	s9,1064(sp)
    2922:	48010113          	addi	sp,sp,1152
    2926:	8082                	ret
    close(fd);
    2928:	854a                	mv	a0,s2
    292a:	136020ef          	jal	ra,4a60 <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    292e:	2985                	addiw	s3,s3,1
    2930:	0ff9f993          	andi	s3,s3,255
    2934:	ed8984e3          	beq	s3,s8,27fc <diskfull+0x7c>
    name[0] = 'b';
    2938:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    293c:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    2940:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    2944:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    2948:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    294c:	b8040513          	addi	a0,s0,-1152
    2950:	138020ef          	jal	ra,4a88 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2954:	60200593          	li	a1,1538
    2958:	b8040513          	addi	a0,s0,-1152
    295c:	11c020ef          	jal	ra,4a78 <open>
    2960:	892a                	mv	s2,a0
    if(fd < 0){
    2962:	e6054de3          	bltz	a0,27dc <diskfull+0x5c>
    2966:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    2968:	40000613          	li	a2,1024
    296c:	ba040593          	addi	a1,s0,-1120
    2970:	854a                	mv	a0,s2
    2972:	0e6020ef          	jal	ra,4a58 <write>
    2976:	40000793          	li	a5,1024
    297a:	e6f51be3          	bne	a0,a5,27f0 <diskfull+0x70>
    for(int i = 0; i < MAXFILE; i++){
    297e:	34fd                	addiw	s1,s1,-1
    2980:	f4e5                	bnez	s1,2968 <diskfull+0x1e8>
    2982:	b75d                	j	2928 <diskfull+0x1a8>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2984:	85e6                	mv	a1,s9
    2986:	00003517          	auipc	a0,0x3
    298a:	7d250513          	addi	a0,a0,2002 # 6158 <malloc+0x1244>
    298e:	4cc020ef          	jal	ra,4e5a <printf>
    2992:	bdd9                	j	2868 <diskfull+0xe8>

0000000000002994 <iputtest>:
{
    2994:	1101                	addi	sp,sp,-32
    2996:	ec06                	sd	ra,24(sp)
    2998:	e822                	sd	s0,16(sp)
    299a:	e426                	sd	s1,8(sp)
    299c:	1000                	addi	s0,sp,32
    299e:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    29a0:	00003517          	auipc	a0,0x3
    29a4:	7e850513          	addi	a0,a0,2024 # 6188 <malloc+0x1274>
    29a8:	0f8020ef          	jal	ra,4aa0 <mkdir>
    29ac:	02054f63          	bltz	a0,29ea <iputtest+0x56>
  if(chdir("iputdir") < 0){
    29b0:	00003517          	auipc	a0,0x3
    29b4:	7d850513          	addi	a0,a0,2008 # 6188 <malloc+0x1274>
    29b8:	0f0020ef          	jal	ra,4aa8 <chdir>
    29bc:	04054163          	bltz	a0,29fe <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    29c0:	00004517          	auipc	a0,0x4
    29c4:	80850513          	addi	a0,a0,-2040 # 61c8 <malloc+0x12b4>
    29c8:	0c0020ef          	jal	ra,4a88 <unlink>
    29cc:	04054363          	bltz	a0,2a12 <iputtest+0x7e>
  if(chdir("/") < 0){
    29d0:	00004517          	auipc	a0,0x4
    29d4:	82850513          	addi	a0,a0,-2008 # 61f8 <malloc+0x12e4>
    29d8:	0d0020ef          	jal	ra,4aa8 <chdir>
    29dc:	04054563          	bltz	a0,2a26 <iputtest+0x92>
}
    29e0:	60e2                	ld	ra,24(sp)
    29e2:	6442                	ld	s0,16(sp)
    29e4:	64a2                	ld	s1,8(sp)
    29e6:	6105                	addi	sp,sp,32
    29e8:	8082                	ret
    printf("%s: mkdir failed\n", s);
    29ea:	85a6                	mv	a1,s1
    29ec:	00003517          	auipc	a0,0x3
    29f0:	7a450513          	addi	a0,a0,1956 # 6190 <malloc+0x127c>
    29f4:	466020ef          	jal	ra,4e5a <printf>
    exit(1);
    29f8:	4505                	li	a0,1
    29fa:	03e020ef          	jal	ra,4a38 <exit>
    printf("%s: chdir iputdir failed\n", s);
    29fe:	85a6                	mv	a1,s1
    2a00:	00003517          	auipc	a0,0x3
    2a04:	7a850513          	addi	a0,a0,1960 # 61a8 <malloc+0x1294>
    2a08:	452020ef          	jal	ra,4e5a <printf>
    exit(1);
    2a0c:	4505                	li	a0,1
    2a0e:	02a020ef          	jal	ra,4a38 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2a12:	85a6                	mv	a1,s1
    2a14:	00003517          	auipc	a0,0x3
    2a18:	7c450513          	addi	a0,a0,1988 # 61d8 <malloc+0x12c4>
    2a1c:	43e020ef          	jal	ra,4e5a <printf>
    exit(1);
    2a20:	4505                	li	a0,1
    2a22:	016020ef          	jal	ra,4a38 <exit>
    printf("%s: chdir / failed\n", s);
    2a26:	85a6                	mv	a1,s1
    2a28:	00003517          	auipc	a0,0x3
    2a2c:	7d850513          	addi	a0,a0,2008 # 6200 <malloc+0x12ec>
    2a30:	42a020ef          	jal	ra,4e5a <printf>
    exit(1);
    2a34:	4505                	li	a0,1
    2a36:	002020ef          	jal	ra,4a38 <exit>

0000000000002a3a <exitiputtest>:
{
    2a3a:	7179                	addi	sp,sp,-48
    2a3c:	f406                	sd	ra,40(sp)
    2a3e:	f022                	sd	s0,32(sp)
    2a40:	ec26                	sd	s1,24(sp)
    2a42:	1800                	addi	s0,sp,48
    2a44:	84aa                	mv	s1,a0
  pid = fork();
    2a46:	7eb010ef          	jal	ra,4a30 <fork>
  if(pid < 0){
    2a4a:	02054e63          	bltz	a0,2a86 <exitiputtest+0x4c>
  if(pid == 0){
    2a4e:	e541                	bnez	a0,2ad6 <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2a50:	00003517          	auipc	a0,0x3
    2a54:	73850513          	addi	a0,a0,1848 # 6188 <malloc+0x1274>
    2a58:	048020ef          	jal	ra,4aa0 <mkdir>
    2a5c:	02054f63          	bltz	a0,2a9a <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2a60:	00003517          	auipc	a0,0x3
    2a64:	72850513          	addi	a0,a0,1832 # 6188 <malloc+0x1274>
    2a68:	040020ef          	jal	ra,4aa8 <chdir>
    2a6c:	04054163          	bltz	a0,2aae <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2a70:	00003517          	auipc	a0,0x3
    2a74:	75850513          	addi	a0,a0,1880 # 61c8 <malloc+0x12b4>
    2a78:	010020ef          	jal	ra,4a88 <unlink>
    2a7c:	04054363          	bltz	a0,2ac2 <exitiputtest+0x88>
    exit(0);
    2a80:	4501                	li	a0,0
    2a82:	7b7010ef          	jal	ra,4a38 <exit>
    printf("%s: fork failed\n", s);
    2a86:	85a6                	mv	a1,s1
    2a88:	00003517          	auipc	a0,0x3
    2a8c:	e5050513          	addi	a0,a0,-432 # 58d8 <malloc+0x9c4>
    2a90:	3ca020ef          	jal	ra,4e5a <printf>
    exit(1);
    2a94:	4505                	li	a0,1
    2a96:	7a3010ef          	jal	ra,4a38 <exit>
      printf("%s: mkdir failed\n", s);
    2a9a:	85a6                	mv	a1,s1
    2a9c:	00003517          	auipc	a0,0x3
    2aa0:	6f450513          	addi	a0,a0,1780 # 6190 <malloc+0x127c>
    2aa4:	3b6020ef          	jal	ra,4e5a <printf>
      exit(1);
    2aa8:	4505                	li	a0,1
    2aaa:	78f010ef          	jal	ra,4a38 <exit>
      printf("%s: child chdir failed\n", s);
    2aae:	85a6                	mv	a1,s1
    2ab0:	00003517          	auipc	a0,0x3
    2ab4:	76850513          	addi	a0,a0,1896 # 6218 <malloc+0x1304>
    2ab8:	3a2020ef          	jal	ra,4e5a <printf>
      exit(1);
    2abc:	4505                	li	a0,1
    2abe:	77b010ef          	jal	ra,4a38 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2ac2:	85a6                	mv	a1,s1
    2ac4:	00003517          	auipc	a0,0x3
    2ac8:	71450513          	addi	a0,a0,1812 # 61d8 <malloc+0x12c4>
    2acc:	38e020ef          	jal	ra,4e5a <printf>
      exit(1);
    2ad0:	4505                	li	a0,1
    2ad2:	767010ef          	jal	ra,4a38 <exit>
  wait(&xstatus);
    2ad6:	fdc40513          	addi	a0,s0,-36
    2ada:	767010ef          	jal	ra,4a40 <wait>
  exit(xstatus);
    2ade:	fdc42503          	lw	a0,-36(s0)
    2ae2:	757010ef          	jal	ra,4a38 <exit>

0000000000002ae6 <dirtest>:
{
    2ae6:	1101                	addi	sp,sp,-32
    2ae8:	ec06                	sd	ra,24(sp)
    2aea:	e822                	sd	s0,16(sp)
    2aec:	e426                	sd	s1,8(sp)
    2aee:	1000                	addi	s0,sp,32
    2af0:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2af2:	00003517          	auipc	a0,0x3
    2af6:	73e50513          	addi	a0,a0,1854 # 6230 <malloc+0x131c>
    2afa:	7a7010ef          	jal	ra,4aa0 <mkdir>
    2afe:	02054f63          	bltz	a0,2b3c <dirtest+0x56>
  if(chdir("dir0") < 0){
    2b02:	00003517          	auipc	a0,0x3
    2b06:	72e50513          	addi	a0,a0,1838 # 6230 <malloc+0x131c>
    2b0a:	79f010ef          	jal	ra,4aa8 <chdir>
    2b0e:	04054163          	bltz	a0,2b50 <dirtest+0x6a>
  if(chdir("..") < 0){
    2b12:	00003517          	auipc	a0,0x3
    2b16:	73e50513          	addi	a0,a0,1854 # 6250 <malloc+0x133c>
    2b1a:	78f010ef          	jal	ra,4aa8 <chdir>
    2b1e:	04054363          	bltz	a0,2b64 <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2b22:	00003517          	auipc	a0,0x3
    2b26:	70e50513          	addi	a0,a0,1806 # 6230 <malloc+0x131c>
    2b2a:	75f010ef          	jal	ra,4a88 <unlink>
    2b2e:	04054563          	bltz	a0,2b78 <dirtest+0x92>
}
    2b32:	60e2                	ld	ra,24(sp)
    2b34:	6442                	ld	s0,16(sp)
    2b36:	64a2                	ld	s1,8(sp)
    2b38:	6105                	addi	sp,sp,32
    2b3a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b3c:	85a6                	mv	a1,s1
    2b3e:	00003517          	auipc	a0,0x3
    2b42:	65250513          	addi	a0,a0,1618 # 6190 <malloc+0x127c>
    2b46:	314020ef          	jal	ra,4e5a <printf>
    exit(1);
    2b4a:	4505                	li	a0,1
    2b4c:	6ed010ef          	jal	ra,4a38 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2b50:	85a6                	mv	a1,s1
    2b52:	00003517          	auipc	a0,0x3
    2b56:	6e650513          	addi	a0,a0,1766 # 6238 <malloc+0x1324>
    2b5a:	300020ef          	jal	ra,4e5a <printf>
    exit(1);
    2b5e:	4505                	li	a0,1
    2b60:	6d9010ef          	jal	ra,4a38 <exit>
    printf("%s: chdir .. failed\n", s);
    2b64:	85a6                	mv	a1,s1
    2b66:	00003517          	auipc	a0,0x3
    2b6a:	6f250513          	addi	a0,a0,1778 # 6258 <malloc+0x1344>
    2b6e:	2ec020ef          	jal	ra,4e5a <printf>
    exit(1);
    2b72:	4505                	li	a0,1
    2b74:	6c5010ef          	jal	ra,4a38 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2b78:	85a6                	mv	a1,s1
    2b7a:	00003517          	auipc	a0,0x3
    2b7e:	6f650513          	addi	a0,a0,1782 # 6270 <malloc+0x135c>
    2b82:	2d8020ef          	jal	ra,4e5a <printf>
    exit(1);
    2b86:	4505                	li	a0,1
    2b88:	6b1010ef          	jal	ra,4a38 <exit>

0000000000002b8c <subdir>:
{
    2b8c:	1101                	addi	sp,sp,-32
    2b8e:	ec06                	sd	ra,24(sp)
    2b90:	e822                	sd	s0,16(sp)
    2b92:	e426                	sd	s1,8(sp)
    2b94:	e04a                	sd	s2,0(sp)
    2b96:	1000                	addi	s0,sp,32
    2b98:	892a                	mv	s2,a0
  unlink("ff");
    2b9a:	00004517          	auipc	a0,0x4
    2b9e:	81e50513          	addi	a0,a0,-2018 # 63b8 <malloc+0x14a4>
    2ba2:	6e7010ef          	jal	ra,4a88 <unlink>
  if(mkdir("dd") != 0){
    2ba6:	00003517          	auipc	a0,0x3
    2baa:	6e250513          	addi	a0,a0,1762 # 6288 <malloc+0x1374>
    2bae:	6f3010ef          	jal	ra,4aa0 <mkdir>
    2bb2:	2e051263          	bnez	a0,2e96 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2bb6:	20200593          	li	a1,514
    2bba:	00003517          	auipc	a0,0x3
    2bbe:	6ee50513          	addi	a0,a0,1774 # 62a8 <malloc+0x1394>
    2bc2:	6b7010ef          	jal	ra,4a78 <open>
    2bc6:	84aa                	mv	s1,a0
  if(fd < 0){
    2bc8:	2e054163          	bltz	a0,2eaa <subdir+0x31e>
  write(fd, "ff", 2);
    2bcc:	4609                	li	a2,2
    2bce:	00003597          	auipc	a1,0x3
    2bd2:	7ea58593          	addi	a1,a1,2026 # 63b8 <malloc+0x14a4>
    2bd6:	683010ef          	jal	ra,4a58 <write>
  close(fd);
    2bda:	8526                	mv	a0,s1
    2bdc:	685010ef          	jal	ra,4a60 <close>
  if(unlink("dd") >= 0){
    2be0:	00003517          	auipc	a0,0x3
    2be4:	6a850513          	addi	a0,a0,1704 # 6288 <malloc+0x1374>
    2be8:	6a1010ef          	jal	ra,4a88 <unlink>
    2bec:	2c055963          	bgez	a0,2ebe <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2bf0:	00003517          	auipc	a0,0x3
    2bf4:	71050513          	addi	a0,a0,1808 # 6300 <malloc+0x13ec>
    2bf8:	6a9010ef          	jal	ra,4aa0 <mkdir>
    2bfc:	2c051b63          	bnez	a0,2ed2 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2c00:	20200593          	li	a1,514
    2c04:	00003517          	auipc	a0,0x3
    2c08:	72450513          	addi	a0,a0,1828 # 6328 <malloc+0x1414>
    2c0c:	66d010ef          	jal	ra,4a78 <open>
    2c10:	84aa                	mv	s1,a0
  if(fd < 0){
    2c12:	2c054a63          	bltz	a0,2ee6 <subdir+0x35a>
  write(fd, "FF", 2);
    2c16:	4609                	li	a2,2
    2c18:	00003597          	auipc	a1,0x3
    2c1c:	74058593          	addi	a1,a1,1856 # 6358 <malloc+0x1444>
    2c20:	639010ef          	jal	ra,4a58 <write>
  close(fd);
    2c24:	8526                	mv	a0,s1
    2c26:	63b010ef          	jal	ra,4a60 <close>
  fd = open("dd/dd/../ff", 0);
    2c2a:	4581                	li	a1,0
    2c2c:	00003517          	auipc	a0,0x3
    2c30:	73450513          	addi	a0,a0,1844 # 6360 <malloc+0x144c>
    2c34:	645010ef          	jal	ra,4a78 <open>
    2c38:	84aa                	mv	s1,a0
  if(fd < 0){
    2c3a:	2c054063          	bltz	a0,2efa <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c3e:	660d                	lui	a2,0x3
    2c40:	00009597          	auipc	a1,0x9
    2c44:	03858593          	addi	a1,a1,56 # bc78 <buf>
    2c48:	609010ef          	jal	ra,4a50 <read>
  if(cc != 2 || buf[0] != 'f'){
    2c4c:	4789                	li	a5,2
    2c4e:	2cf51063          	bne	a0,a5,2f0e <subdir+0x382>
    2c52:	00009717          	auipc	a4,0x9
    2c56:	02674703          	lbu	a4,38(a4) # bc78 <buf>
    2c5a:	06600793          	li	a5,102
    2c5e:	2af71863          	bne	a4,a5,2f0e <subdir+0x382>
  close(fd);
    2c62:	8526                	mv	a0,s1
    2c64:	5fd010ef          	jal	ra,4a60 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2c68:	00003597          	auipc	a1,0x3
    2c6c:	74858593          	addi	a1,a1,1864 # 63b0 <malloc+0x149c>
    2c70:	00003517          	auipc	a0,0x3
    2c74:	6b850513          	addi	a0,a0,1720 # 6328 <malloc+0x1414>
    2c78:	621010ef          	jal	ra,4a98 <link>
    2c7c:	2a051363          	bnez	a0,2f22 <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2c80:	00003517          	auipc	a0,0x3
    2c84:	6a850513          	addi	a0,a0,1704 # 6328 <malloc+0x1414>
    2c88:	601010ef          	jal	ra,4a88 <unlink>
    2c8c:	2a051563          	bnez	a0,2f36 <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2c90:	4581                	li	a1,0
    2c92:	00003517          	auipc	a0,0x3
    2c96:	69650513          	addi	a0,a0,1686 # 6328 <malloc+0x1414>
    2c9a:	5df010ef          	jal	ra,4a78 <open>
    2c9e:	2a055663          	bgez	a0,2f4a <subdir+0x3be>
  if(chdir("dd") != 0){
    2ca2:	00003517          	auipc	a0,0x3
    2ca6:	5e650513          	addi	a0,a0,1510 # 6288 <malloc+0x1374>
    2caa:	5ff010ef          	jal	ra,4aa8 <chdir>
    2cae:	2a051863          	bnez	a0,2f5e <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2cb2:	00003517          	auipc	a0,0x3
    2cb6:	79650513          	addi	a0,a0,1942 # 6448 <malloc+0x1534>
    2cba:	5ef010ef          	jal	ra,4aa8 <chdir>
    2cbe:	2a051a63          	bnez	a0,2f72 <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2cc2:	00003517          	auipc	a0,0x3
    2cc6:	7b650513          	addi	a0,a0,1974 # 6478 <malloc+0x1564>
    2cca:	5df010ef          	jal	ra,4aa8 <chdir>
    2cce:	2a051c63          	bnez	a0,2f86 <subdir+0x3fa>
  if(chdir("./..") != 0){
    2cd2:	00003517          	auipc	a0,0x3
    2cd6:	7de50513          	addi	a0,a0,2014 # 64b0 <malloc+0x159c>
    2cda:	5cf010ef          	jal	ra,4aa8 <chdir>
    2cde:	2a051e63          	bnez	a0,2f9a <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2ce2:	4581                	li	a1,0
    2ce4:	00003517          	auipc	a0,0x3
    2ce8:	6cc50513          	addi	a0,a0,1740 # 63b0 <malloc+0x149c>
    2cec:	58d010ef          	jal	ra,4a78 <open>
    2cf0:	84aa                	mv	s1,a0
  if(fd < 0){
    2cf2:	2a054e63          	bltz	a0,2fae <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2cf6:	660d                	lui	a2,0x3
    2cf8:	00009597          	auipc	a1,0x9
    2cfc:	f8058593          	addi	a1,a1,-128 # bc78 <buf>
    2d00:	551010ef          	jal	ra,4a50 <read>
    2d04:	4789                	li	a5,2
    2d06:	2af51e63          	bne	a0,a5,2fc2 <subdir+0x436>
  close(fd);
    2d0a:	8526                	mv	a0,s1
    2d0c:	555010ef          	jal	ra,4a60 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2d10:	4581                	li	a1,0
    2d12:	00003517          	auipc	a0,0x3
    2d16:	61650513          	addi	a0,a0,1558 # 6328 <malloc+0x1414>
    2d1a:	55f010ef          	jal	ra,4a78 <open>
    2d1e:	2a055c63          	bgez	a0,2fd6 <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2d22:	20200593          	li	a1,514
    2d26:	00004517          	auipc	a0,0x4
    2d2a:	81a50513          	addi	a0,a0,-2022 # 6540 <malloc+0x162c>
    2d2e:	54b010ef          	jal	ra,4a78 <open>
    2d32:	2a055c63          	bgez	a0,2fea <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2d36:	20200593          	li	a1,514
    2d3a:	00004517          	auipc	a0,0x4
    2d3e:	83650513          	addi	a0,a0,-1994 # 6570 <malloc+0x165c>
    2d42:	537010ef          	jal	ra,4a78 <open>
    2d46:	2a055c63          	bgez	a0,2ffe <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2d4a:	20000593          	li	a1,512
    2d4e:	00003517          	auipc	a0,0x3
    2d52:	53a50513          	addi	a0,a0,1338 # 6288 <malloc+0x1374>
    2d56:	523010ef          	jal	ra,4a78 <open>
    2d5a:	2a055c63          	bgez	a0,3012 <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2d5e:	4589                	li	a1,2
    2d60:	00003517          	auipc	a0,0x3
    2d64:	52850513          	addi	a0,a0,1320 # 6288 <malloc+0x1374>
    2d68:	511010ef          	jal	ra,4a78 <open>
    2d6c:	2a055d63          	bgez	a0,3026 <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2d70:	4585                	li	a1,1
    2d72:	00003517          	auipc	a0,0x3
    2d76:	51650513          	addi	a0,a0,1302 # 6288 <malloc+0x1374>
    2d7a:	4ff010ef          	jal	ra,4a78 <open>
    2d7e:	2a055e63          	bgez	a0,303a <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2d82:	00004597          	auipc	a1,0x4
    2d86:	87e58593          	addi	a1,a1,-1922 # 6600 <malloc+0x16ec>
    2d8a:	00003517          	auipc	a0,0x3
    2d8e:	7b650513          	addi	a0,a0,1974 # 6540 <malloc+0x162c>
    2d92:	507010ef          	jal	ra,4a98 <link>
    2d96:	2a050c63          	beqz	a0,304e <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2d9a:	00004597          	auipc	a1,0x4
    2d9e:	86658593          	addi	a1,a1,-1946 # 6600 <malloc+0x16ec>
    2da2:	00003517          	auipc	a0,0x3
    2da6:	7ce50513          	addi	a0,a0,1998 # 6570 <malloc+0x165c>
    2daa:	4ef010ef          	jal	ra,4a98 <link>
    2dae:	2a050a63          	beqz	a0,3062 <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2db2:	00003597          	auipc	a1,0x3
    2db6:	5fe58593          	addi	a1,a1,1534 # 63b0 <malloc+0x149c>
    2dba:	00003517          	auipc	a0,0x3
    2dbe:	4ee50513          	addi	a0,a0,1262 # 62a8 <malloc+0x1394>
    2dc2:	4d7010ef          	jal	ra,4a98 <link>
    2dc6:	2a050863          	beqz	a0,3076 <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2dca:	00003517          	auipc	a0,0x3
    2dce:	77650513          	addi	a0,a0,1910 # 6540 <malloc+0x162c>
    2dd2:	4cf010ef          	jal	ra,4aa0 <mkdir>
    2dd6:	2a050a63          	beqz	a0,308a <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2dda:	00003517          	auipc	a0,0x3
    2dde:	79650513          	addi	a0,a0,1942 # 6570 <malloc+0x165c>
    2de2:	4bf010ef          	jal	ra,4aa0 <mkdir>
    2de6:	2a050c63          	beqz	a0,309e <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2dea:	00003517          	auipc	a0,0x3
    2dee:	5c650513          	addi	a0,a0,1478 # 63b0 <malloc+0x149c>
    2df2:	4af010ef          	jal	ra,4aa0 <mkdir>
    2df6:	2a050e63          	beqz	a0,30b2 <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2dfa:	00003517          	auipc	a0,0x3
    2dfe:	77650513          	addi	a0,a0,1910 # 6570 <malloc+0x165c>
    2e02:	487010ef          	jal	ra,4a88 <unlink>
    2e06:	2c050063          	beqz	a0,30c6 <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2e0a:	00003517          	auipc	a0,0x3
    2e0e:	73650513          	addi	a0,a0,1846 # 6540 <malloc+0x162c>
    2e12:	477010ef          	jal	ra,4a88 <unlink>
    2e16:	2c050263          	beqz	a0,30da <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2e1a:	00003517          	auipc	a0,0x3
    2e1e:	48e50513          	addi	a0,a0,1166 # 62a8 <malloc+0x1394>
    2e22:	487010ef          	jal	ra,4aa8 <chdir>
    2e26:	2c050463          	beqz	a0,30ee <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2e2a:	00004517          	auipc	a0,0x4
    2e2e:	92650513          	addi	a0,a0,-1754 # 6750 <malloc+0x183c>
    2e32:	477010ef          	jal	ra,4aa8 <chdir>
    2e36:	2c050663          	beqz	a0,3102 <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2e3a:	00003517          	auipc	a0,0x3
    2e3e:	57650513          	addi	a0,a0,1398 # 63b0 <malloc+0x149c>
    2e42:	447010ef          	jal	ra,4a88 <unlink>
    2e46:	2c051863          	bnez	a0,3116 <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2e4a:	00003517          	auipc	a0,0x3
    2e4e:	45e50513          	addi	a0,a0,1118 # 62a8 <malloc+0x1394>
    2e52:	437010ef          	jal	ra,4a88 <unlink>
    2e56:	2c051a63          	bnez	a0,312a <subdir+0x59e>
  if(unlink("dd") == 0){
    2e5a:	00003517          	auipc	a0,0x3
    2e5e:	42e50513          	addi	a0,a0,1070 # 6288 <malloc+0x1374>
    2e62:	427010ef          	jal	ra,4a88 <unlink>
    2e66:	2c050c63          	beqz	a0,313e <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2e6a:	00004517          	auipc	a0,0x4
    2e6e:	95650513          	addi	a0,a0,-1706 # 67c0 <malloc+0x18ac>
    2e72:	417010ef          	jal	ra,4a88 <unlink>
    2e76:	2c054e63          	bltz	a0,3152 <subdir+0x5c6>
  if(unlink("dd") < 0){
    2e7a:	00003517          	auipc	a0,0x3
    2e7e:	40e50513          	addi	a0,a0,1038 # 6288 <malloc+0x1374>
    2e82:	407010ef          	jal	ra,4a88 <unlink>
    2e86:	2e054063          	bltz	a0,3166 <subdir+0x5da>
}
    2e8a:	60e2                	ld	ra,24(sp)
    2e8c:	6442                	ld	s0,16(sp)
    2e8e:	64a2                	ld	s1,8(sp)
    2e90:	6902                	ld	s2,0(sp)
    2e92:	6105                	addi	sp,sp,32
    2e94:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2e96:	85ca                	mv	a1,s2
    2e98:	00003517          	auipc	a0,0x3
    2e9c:	3f850513          	addi	a0,a0,1016 # 6290 <malloc+0x137c>
    2ea0:	7bb010ef          	jal	ra,4e5a <printf>
    exit(1);
    2ea4:	4505                	li	a0,1
    2ea6:	393010ef          	jal	ra,4a38 <exit>
    printf("%s: create dd/ff failed\n", s);
    2eaa:	85ca                	mv	a1,s2
    2eac:	00003517          	auipc	a0,0x3
    2eb0:	40450513          	addi	a0,a0,1028 # 62b0 <malloc+0x139c>
    2eb4:	7a7010ef          	jal	ra,4e5a <printf>
    exit(1);
    2eb8:	4505                	li	a0,1
    2eba:	37f010ef          	jal	ra,4a38 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2ebe:	85ca                	mv	a1,s2
    2ec0:	00003517          	auipc	a0,0x3
    2ec4:	41050513          	addi	a0,a0,1040 # 62d0 <malloc+0x13bc>
    2ec8:	793010ef          	jal	ra,4e5a <printf>
    exit(1);
    2ecc:	4505                	li	a0,1
    2ece:	36b010ef          	jal	ra,4a38 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2ed2:	85ca                	mv	a1,s2
    2ed4:	00003517          	auipc	a0,0x3
    2ed8:	43450513          	addi	a0,a0,1076 # 6308 <malloc+0x13f4>
    2edc:	77f010ef          	jal	ra,4e5a <printf>
    exit(1);
    2ee0:	4505                	li	a0,1
    2ee2:	357010ef          	jal	ra,4a38 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2ee6:	85ca                	mv	a1,s2
    2ee8:	00003517          	auipc	a0,0x3
    2eec:	45050513          	addi	a0,a0,1104 # 6338 <malloc+0x1424>
    2ef0:	76b010ef          	jal	ra,4e5a <printf>
    exit(1);
    2ef4:	4505                	li	a0,1
    2ef6:	343010ef          	jal	ra,4a38 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2efa:	85ca                	mv	a1,s2
    2efc:	00003517          	auipc	a0,0x3
    2f00:	47450513          	addi	a0,a0,1140 # 6370 <malloc+0x145c>
    2f04:	757010ef          	jal	ra,4e5a <printf>
    exit(1);
    2f08:	4505                	li	a0,1
    2f0a:	32f010ef          	jal	ra,4a38 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2f0e:	85ca                	mv	a1,s2
    2f10:	00003517          	auipc	a0,0x3
    2f14:	48050513          	addi	a0,a0,1152 # 6390 <malloc+0x147c>
    2f18:	743010ef          	jal	ra,4e5a <printf>
    exit(1);
    2f1c:	4505                	li	a0,1
    2f1e:	31b010ef          	jal	ra,4a38 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f22:	85ca                	mv	a1,s2
    2f24:	00003517          	auipc	a0,0x3
    2f28:	49c50513          	addi	a0,a0,1180 # 63c0 <malloc+0x14ac>
    2f2c:	72f010ef          	jal	ra,4e5a <printf>
    exit(1);
    2f30:	4505                	li	a0,1
    2f32:	307010ef          	jal	ra,4a38 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f36:	85ca                	mv	a1,s2
    2f38:	00003517          	auipc	a0,0x3
    2f3c:	4b050513          	addi	a0,a0,1200 # 63e8 <malloc+0x14d4>
    2f40:	71b010ef          	jal	ra,4e5a <printf>
    exit(1);
    2f44:	4505                	li	a0,1
    2f46:	2f3010ef          	jal	ra,4a38 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2f4a:	85ca                	mv	a1,s2
    2f4c:	00003517          	auipc	a0,0x3
    2f50:	4bc50513          	addi	a0,a0,1212 # 6408 <malloc+0x14f4>
    2f54:	707010ef          	jal	ra,4e5a <printf>
    exit(1);
    2f58:	4505                	li	a0,1
    2f5a:	2df010ef          	jal	ra,4a38 <exit>
    printf("%s: chdir dd failed\n", s);
    2f5e:	85ca                	mv	a1,s2
    2f60:	00003517          	auipc	a0,0x3
    2f64:	4d050513          	addi	a0,a0,1232 # 6430 <malloc+0x151c>
    2f68:	6f3010ef          	jal	ra,4e5a <printf>
    exit(1);
    2f6c:	4505                	li	a0,1
    2f6e:	2cb010ef          	jal	ra,4a38 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2f72:	85ca                	mv	a1,s2
    2f74:	00003517          	auipc	a0,0x3
    2f78:	4e450513          	addi	a0,a0,1252 # 6458 <malloc+0x1544>
    2f7c:	6df010ef          	jal	ra,4e5a <printf>
    exit(1);
    2f80:	4505                	li	a0,1
    2f82:	2b7010ef          	jal	ra,4a38 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2f86:	85ca                	mv	a1,s2
    2f88:	00003517          	auipc	a0,0x3
    2f8c:	50050513          	addi	a0,a0,1280 # 6488 <malloc+0x1574>
    2f90:	6cb010ef          	jal	ra,4e5a <printf>
    exit(1);
    2f94:	4505                	li	a0,1
    2f96:	2a3010ef          	jal	ra,4a38 <exit>
    printf("%s: chdir ./.. failed\n", s);
    2f9a:	85ca                	mv	a1,s2
    2f9c:	00003517          	auipc	a0,0x3
    2fa0:	51c50513          	addi	a0,a0,1308 # 64b8 <malloc+0x15a4>
    2fa4:	6b7010ef          	jal	ra,4e5a <printf>
    exit(1);
    2fa8:	4505                	li	a0,1
    2faa:	28f010ef          	jal	ra,4a38 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2fae:	85ca                	mv	a1,s2
    2fb0:	00003517          	auipc	a0,0x3
    2fb4:	52050513          	addi	a0,a0,1312 # 64d0 <malloc+0x15bc>
    2fb8:	6a3010ef          	jal	ra,4e5a <printf>
    exit(1);
    2fbc:	4505                	li	a0,1
    2fbe:	27b010ef          	jal	ra,4a38 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2fc2:	85ca                	mv	a1,s2
    2fc4:	00003517          	auipc	a0,0x3
    2fc8:	52c50513          	addi	a0,a0,1324 # 64f0 <malloc+0x15dc>
    2fcc:	68f010ef          	jal	ra,4e5a <printf>
    exit(1);
    2fd0:	4505                	li	a0,1
    2fd2:	267010ef          	jal	ra,4a38 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2fd6:	85ca                	mv	a1,s2
    2fd8:	00003517          	auipc	a0,0x3
    2fdc:	53850513          	addi	a0,a0,1336 # 6510 <malloc+0x15fc>
    2fe0:	67b010ef          	jal	ra,4e5a <printf>
    exit(1);
    2fe4:	4505                	li	a0,1
    2fe6:	253010ef          	jal	ra,4a38 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2fea:	85ca                	mv	a1,s2
    2fec:	00003517          	auipc	a0,0x3
    2ff0:	56450513          	addi	a0,a0,1380 # 6550 <malloc+0x163c>
    2ff4:	667010ef          	jal	ra,4e5a <printf>
    exit(1);
    2ff8:	4505                	li	a0,1
    2ffa:	23f010ef          	jal	ra,4a38 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2ffe:	85ca                	mv	a1,s2
    3000:	00003517          	auipc	a0,0x3
    3004:	58050513          	addi	a0,a0,1408 # 6580 <malloc+0x166c>
    3008:	653010ef          	jal	ra,4e5a <printf>
    exit(1);
    300c:	4505                	li	a0,1
    300e:	22b010ef          	jal	ra,4a38 <exit>
    printf("%s: create dd succeeded!\n", s);
    3012:	85ca                	mv	a1,s2
    3014:	00003517          	auipc	a0,0x3
    3018:	58c50513          	addi	a0,a0,1420 # 65a0 <malloc+0x168c>
    301c:	63f010ef          	jal	ra,4e5a <printf>
    exit(1);
    3020:	4505                	li	a0,1
    3022:	217010ef          	jal	ra,4a38 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3026:	85ca                	mv	a1,s2
    3028:	00003517          	auipc	a0,0x3
    302c:	59850513          	addi	a0,a0,1432 # 65c0 <malloc+0x16ac>
    3030:	62b010ef          	jal	ra,4e5a <printf>
    exit(1);
    3034:	4505                	li	a0,1
    3036:	203010ef          	jal	ra,4a38 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    303a:	85ca                	mv	a1,s2
    303c:	00003517          	auipc	a0,0x3
    3040:	5a450513          	addi	a0,a0,1444 # 65e0 <malloc+0x16cc>
    3044:	617010ef          	jal	ra,4e5a <printf>
    exit(1);
    3048:	4505                	li	a0,1
    304a:	1ef010ef          	jal	ra,4a38 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    304e:	85ca                	mv	a1,s2
    3050:	00003517          	auipc	a0,0x3
    3054:	5c050513          	addi	a0,a0,1472 # 6610 <malloc+0x16fc>
    3058:	603010ef          	jal	ra,4e5a <printf>
    exit(1);
    305c:	4505                	li	a0,1
    305e:	1db010ef          	jal	ra,4a38 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3062:	85ca                	mv	a1,s2
    3064:	00003517          	auipc	a0,0x3
    3068:	5d450513          	addi	a0,a0,1492 # 6638 <malloc+0x1724>
    306c:	5ef010ef          	jal	ra,4e5a <printf>
    exit(1);
    3070:	4505                	li	a0,1
    3072:	1c7010ef          	jal	ra,4a38 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3076:	85ca                	mv	a1,s2
    3078:	00003517          	auipc	a0,0x3
    307c:	5e850513          	addi	a0,a0,1512 # 6660 <malloc+0x174c>
    3080:	5db010ef          	jal	ra,4e5a <printf>
    exit(1);
    3084:	4505                	li	a0,1
    3086:	1b3010ef          	jal	ra,4a38 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    308a:	85ca                	mv	a1,s2
    308c:	00003517          	auipc	a0,0x3
    3090:	5fc50513          	addi	a0,a0,1532 # 6688 <malloc+0x1774>
    3094:	5c7010ef          	jal	ra,4e5a <printf>
    exit(1);
    3098:	4505                	li	a0,1
    309a:	19f010ef          	jal	ra,4a38 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    309e:	85ca                	mv	a1,s2
    30a0:	00003517          	auipc	a0,0x3
    30a4:	60850513          	addi	a0,a0,1544 # 66a8 <malloc+0x1794>
    30a8:	5b3010ef          	jal	ra,4e5a <printf>
    exit(1);
    30ac:	4505                	li	a0,1
    30ae:	18b010ef          	jal	ra,4a38 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    30b2:	85ca                	mv	a1,s2
    30b4:	00003517          	auipc	a0,0x3
    30b8:	61450513          	addi	a0,a0,1556 # 66c8 <malloc+0x17b4>
    30bc:	59f010ef          	jal	ra,4e5a <printf>
    exit(1);
    30c0:	4505                	li	a0,1
    30c2:	177010ef          	jal	ra,4a38 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30c6:	85ca                	mv	a1,s2
    30c8:	00003517          	auipc	a0,0x3
    30cc:	62850513          	addi	a0,a0,1576 # 66f0 <malloc+0x17dc>
    30d0:	58b010ef          	jal	ra,4e5a <printf>
    exit(1);
    30d4:	4505                	li	a0,1
    30d6:	163010ef          	jal	ra,4a38 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    30da:	85ca                	mv	a1,s2
    30dc:	00003517          	auipc	a0,0x3
    30e0:	63450513          	addi	a0,a0,1588 # 6710 <malloc+0x17fc>
    30e4:	577010ef          	jal	ra,4e5a <printf>
    exit(1);
    30e8:	4505                	li	a0,1
    30ea:	14f010ef          	jal	ra,4a38 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    30ee:	85ca                	mv	a1,s2
    30f0:	00003517          	auipc	a0,0x3
    30f4:	64050513          	addi	a0,a0,1600 # 6730 <malloc+0x181c>
    30f8:	563010ef          	jal	ra,4e5a <printf>
    exit(1);
    30fc:	4505                	li	a0,1
    30fe:	13b010ef          	jal	ra,4a38 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3102:	85ca                	mv	a1,s2
    3104:	00003517          	auipc	a0,0x3
    3108:	65450513          	addi	a0,a0,1620 # 6758 <malloc+0x1844>
    310c:	54f010ef          	jal	ra,4e5a <printf>
    exit(1);
    3110:	4505                	li	a0,1
    3112:	127010ef          	jal	ra,4a38 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3116:	85ca                	mv	a1,s2
    3118:	00003517          	auipc	a0,0x3
    311c:	2d050513          	addi	a0,a0,720 # 63e8 <malloc+0x14d4>
    3120:	53b010ef          	jal	ra,4e5a <printf>
    exit(1);
    3124:	4505                	li	a0,1
    3126:	113010ef          	jal	ra,4a38 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    312a:	85ca                	mv	a1,s2
    312c:	00003517          	auipc	a0,0x3
    3130:	64c50513          	addi	a0,a0,1612 # 6778 <malloc+0x1864>
    3134:	527010ef          	jal	ra,4e5a <printf>
    exit(1);
    3138:	4505                	li	a0,1
    313a:	0ff010ef          	jal	ra,4a38 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    313e:	85ca                	mv	a1,s2
    3140:	00003517          	auipc	a0,0x3
    3144:	65850513          	addi	a0,a0,1624 # 6798 <malloc+0x1884>
    3148:	513010ef          	jal	ra,4e5a <printf>
    exit(1);
    314c:	4505                	li	a0,1
    314e:	0eb010ef          	jal	ra,4a38 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3152:	85ca                	mv	a1,s2
    3154:	00003517          	auipc	a0,0x3
    3158:	67450513          	addi	a0,a0,1652 # 67c8 <malloc+0x18b4>
    315c:	4ff010ef          	jal	ra,4e5a <printf>
    exit(1);
    3160:	4505                	li	a0,1
    3162:	0d7010ef          	jal	ra,4a38 <exit>
    printf("%s: unlink dd failed\n", s);
    3166:	85ca                	mv	a1,s2
    3168:	00003517          	auipc	a0,0x3
    316c:	68050513          	addi	a0,a0,1664 # 67e8 <malloc+0x18d4>
    3170:	4eb010ef          	jal	ra,4e5a <printf>
    exit(1);
    3174:	4505                	li	a0,1
    3176:	0c3010ef          	jal	ra,4a38 <exit>

000000000000317a <rmdot>:
{
    317a:	1101                	addi	sp,sp,-32
    317c:	ec06                	sd	ra,24(sp)
    317e:	e822                	sd	s0,16(sp)
    3180:	e426                	sd	s1,8(sp)
    3182:	1000                	addi	s0,sp,32
    3184:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3186:	00003517          	auipc	a0,0x3
    318a:	67a50513          	addi	a0,a0,1658 # 6800 <malloc+0x18ec>
    318e:	113010ef          	jal	ra,4aa0 <mkdir>
    3192:	e53d                	bnez	a0,3200 <rmdot+0x86>
  if(chdir("dots") != 0){
    3194:	00003517          	auipc	a0,0x3
    3198:	66c50513          	addi	a0,a0,1644 # 6800 <malloc+0x18ec>
    319c:	10d010ef          	jal	ra,4aa8 <chdir>
    31a0:	e935                	bnez	a0,3214 <rmdot+0x9a>
  if(unlink(".") == 0){
    31a2:	00002517          	auipc	a0,0x2
    31a6:	58e50513          	addi	a0,a0,1422 # 5730 <malloc+0x81c>
    31aa:	0df010ef          	jal	ra,4a88 <unlink>
    31ae:	cd2d                	beqz	a0,3228 <rmdot+0xae>
  if(unlink("..") == 0){
    31b0:	00003517          	auipc	a0,0x3
    31b4:	0a050513          	addi	a0,a0,160 # 6250 <malloc+0x133c>
    31b8:	0d1010ef          	jal	ra,4a88 <unlink>
    31bc:	c141                	beqz	a0,323c <rmdot+0xc2>
  if(chdir("/") != 0){
    31be:	00003517          	auipc	a0,0x3
    31c2:	03a50513          	addi	a0,a0,58 # 61f8 <malloc+0x12e4>
    31c6:	0e3010ef          	jal	ra,4aa8 <chdir>
    31ca:	e159                	bnez	a0,3250 <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    31cc:	00003517          	auipc	a0,0x3
    31d0:	69c50513          	addi	a0,a0,1692 # 6868 <malloc+0x1954>
    31d4:	0b5010ef          	jal	ra,4a88 <unlink>
    31d8:	c551                	beqz	a0,3264 <rmdot+0xea>
  if(unlink("dots/..") == 0){
    31da:	00003517          	auipc	a0,0x3
    31de:	6b650513          	addi	a0,a0,1718 # 6890 <malloc+0x197c>
    31e2:	0a7010ef          	jal	ra,4a88 <unlink>
    31e6:	c949                	beqz	a0,3278 <rmdot+0xfe>
  if(unlink("dots") != 0){
    31e8:	00003517          	auipc	a0,0x3
    31ec:	61850513          	addi	a0,a0,1560 # 6800 <malloc+0x18ec>
    31f0:	099010ef          	jal	ra,4a88 <unlink>
    31f4:	ed41                	bnez	a0,328c <rmdot+0x112>
}
    31f6:	60e2                	ld	ra,24(sp)
    31f8:	6442                	ld	s0,16(sp)
    31fa:	64a2                	ld	s1,8(sp)
    31fc:	6105                	addi	sp,sp,32
    31fe:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3200:	85a6                	mv	a1,s1
    3202:	00003517          	auipc	a0,0x3
    3206:	60650513          	addi	a0,a0,1542 # 6808 <malloc+0x18f4>
    320a:	451010ef          	jal	ra,4e5a <printf>
    exit(1);
    320e:	4505                	li	a0,1
    3210:	029010ef          	jal	ra,4a38 <exit>
    printf("%s: chdir dots failed\n", s);
    3214:	85a6                	mv	a1,s1
    3216:	00003517          	auipc	a0,0x3
    321a:	60a50513          	addi	a0,a0,1546 # 6820 <malloc+0x190c>
    321e:	43d010ef          	jal	ra,4e5a <printf>
    exit(1);
    3222:	4505                	li	a0,1
    3224:	015010ef          	jal	ra,4a38 <exit>
    printf("%s: rm . worked!\n", s);
    3228:	85a6                	mv	a1,s1
    322a:	00003517          	auipc	a0,0x3
    322e:	60e50513          	addi	a0,a0,1550 # 6838 <malloc+0x1924>
    3232:	429010ef          	jal	ra,4e5a <printf>
    exit(1);
    3236:	4505                	li	a0,1
    3238:	001010ef          	jal	ra,4a38 <exit>
    printf("%s: rm .. worked!\n", s);
    323c:	85a6                	mv	a1,s1
    323e:	00003517          	auipc	a0,0x3
    3242:	61250513          	addi	a0,a0,1554 # 6850 <malloc+0x193c>
    3246:	415010ef          	jal	ra,4e5a <printf>
    exit(1);
    324a:	4505                	li	a0,1
    324c:	7ec010ef          	jal	ra,4a38 <exit>
    printf("%s: chdir / failed\n", s);
    3250:	85a6                	mv	a1,s1
    3252:	00003517          	auipc	a0,0x3
    3256:	fae50513          	addi	a0,a0,-82 # 6200 <malloc+0x12ec>
    325a:	401010ef          	jal	ra,4e5a <printf>
    exit(1);
    325e:	4505                	li	a0,1
    3260:	7d8010ef          	jal	ra,4a38 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3264:	85a6                	mv	a1,s1
    3266:	00003517          	auipc	a0,0x3
    326a:	60a50513          	addi	a0,a0,1546 # 6870 <malloc+0x195c>
    326e:	3ed010ef          	jal	ra,4e5a <printf>
    exit(1);
    3272:	4505                	li	a0,1
    3274:	7c4010ef          	jal	ra,4a38 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3278:	85a6                	mv	a1,s1
    327a:	00003517          	auipc	a0,0x3
    327e:	61e50513          	addi	a0,a0,1566 # 6898 <malloc+0x1984>
    3282:	3d9010ef          	jal	ra,4e5a <printf>
    exit(1);
    3286:	4505                	li	a0,1
    3288:	7b0010ef          	jal	ra,4a38 <exit>
    printf("%s: unlink dots failed!\n", s);
    328c:	85a6                	mv	a1,s1
    328e:	00003517          	auipc	a0,0x3
    3292:	62a50513          	addi	a0,a0,1578 # 68b8 <malloc+0x19a4>
    3296:	3c5010ef          	jal	ra,4e5a <printf>
    exit(1);
    329a:	4505                	li	a0,1
    329c:	79c010ef          	jal	ra,4a38 <exit>

00000000000032a0 <dirfile>:
{
    32a0:	1101                	addi	sp,sp,-32
    32a2:	ec06                	sd	ra,24(sp)
    32a4:	e822                	sd	s0,16(sp)
    32a6:	e426                	sd	s1,8(sp)
    32a8:	e04a                	sd	s2,0(sp)
    32aa:	1000                	addi	s0,sp,32
    32ac:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    32ae:	20000593          	li	a1,512
    32b2:	00003517          	auipc	a0,0x3
    32b6:	62650513          	addi	a0,a0,1574 # 68d8 <malloc+0x19c4>
    32ba:	7be010ef          	jal	ra,4a78 <open>
  if(fd < 0){
    32be:	0c054563          	bltz	a0,3388 <dirfile+0xe8>
  close(fd);
    32c2:	79e010ef          	jal	ra,4a60 <close>
  if(chdir("dirfile") == 0){
    32c6:	00003517          	auipc	a0,0x3
    32ca:	61250513          	addi	a0,a0,1554 # 68d8 <malloc+0x19c4>
    32ce:	7da010ef          	jal	ra,4aa8 <chdir>
    32d2:	c569                	beqz	a0,339c <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    32d4:	4581                	li	a1,0
    32d6:	00003517          	auipc	a0,0x3
    32da:	64a50513          	addi	a0,a0,1610 # 6920 <malloc+0x1a0c>
    32de:	79a010ef          	jal	ra,4a78 <open>
  if(fd >= 0){
    32e2:	0c055763          	bgez	a0,33b0 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    32e6:	20000593          	li	a1,512
    32ea:	00003517          	auipc	a0,0x3
    32ee:	63650513          	addi	a0,a0,1590 # 6920 <malloc+0x1a0c>
    32f2:	786010ef          	jal	ra,4a78 <open>
  if(fd >= 0){
    32f6:	0c055763          	bgez	a0,33c4 <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    32fa:	00003517          	auipc	a0,0x3
    32fe:	62650513          	addi	a0,a0,1574 # 6920 <malloc+0x1a0c>
    3302:	79e010ef          	jal	ra,4aa0 <mkdir>
    3306:	0c050963          	beqz	a0,33d8 <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    330a:	00003517          	auipc	a0,0x3
    330e:	61650513          	addi	a0,a0,1558 # 6920 <malloc+0x1a0c>
    3312:	776010ef          	jal	ra,4a88 <unlink>
    3316:	0c050b63          	beqz	a0,33ec <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    331a:	00003597          	auipc	a1,0x3
    331e:	60658593          	addi	a1,a1,1542 # 6920 <malloc+0x1a0c>
    3322:	00002517          	auipc	a0,0x2
    3326:	efe50513          	addi	a0,a0,-258 # 5220 <malloc+0x30c>
    332a:	76e010ef          	jal	ra,4a98 <link>
    332e:	0c050963          	beqz	a0,3400 <dirfile+0x160>
  if(unlink("dirfile") != 0){
    3332:	00003517          	auipc	a0,0x3
    3336:	5a650513          	addi	a0,a0,1446 # 68d8 <malloc+0x19c4>
    333a:	74e010ef          	jal	ra,4a88 <unlink>
    333e:	0c051b63          	bnez	a0,3414 <dirfile+0x174>
  fd = open(".", O_RDWR);
    3342:	4589                	li	a1,2
    3344:	00002517          	auipc	a0,0x2
    3348:	3ec50513          	addi	a0,a0,1004 # 5730 <malloc+0x81c>
    334c:	72c010ef          	jal	ra,4a78 <open>
  if(fd >= 0){
    3350:	0c055c63          	bgez	a0,3428 <dirfile+0x188>
  fd = open(".", 0);
    3354:	4581                	li	a1,0
    3356:	00002517          	auipc	a0,0x2
    335a:	3da50513          	addi	a0,a0,986 # 5730 <malloc+0x81c>
    335e:	71a010ef          	jal	ra,4a78 <open>
    3362:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3364:	4605                	li	a2,1
    3366:	00002597          	auipc	a1,0x2
    336a:	d5258593          	addi	a1,a1,-686 # 50b8 <malloc+0x1a4>
    336e:	6ea010ef          	jal	ra,4a58 <write>
    3372:	0ca04563          	bgtz	a0,343c <dirfile+0x19c>
  close(fd);
    3376:	8526                	mv	a0,s1
    3378:	6e8010ef          	jal	ra,4a60 <close>
}
    337c:	60e2                	ld	ra,24(sp)
    337e:	6442                	ld	s0,16(sp)
    3380:	64a2                	ld	s1,8(sp)
    3382:	6902                	ld	s2,0(sp)
    3384:	6105                	addi	sp,sp,32
    3386:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3388:	85ca                	mv	a1,s2
    338a:	00003517          	auipc	a0,0x3
    338e:	55650513          	addi	a0,a0,1366 # 68e0 <malloc+0x19cc>
    3392:	2c9010ef          	jal	ra,4e5a <printf>
    exit(1);
    3396:	4505                	li	a0,1
    3398:	6a0010ef          	jal	ra,4a38 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    339c:	85ca                	mv	a1,s2
    339e:	00003517          	auipc	a0,0x3
    33a2:	56250513          	addi	a0,a0,1378 # 6900 <malloc+0x19ec>
    33a6:	2b5010ef          	jal	ra,4e5a <printf>
    exit(1);
    33aa:	4505                	li	a0,1
    33ac:	68c010ef          	jal	ra,4a38 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33b0:	85ca                	mv	a1,s2
    33b2:	00003517          	auipc	a0,0x3
    33b6:	57e50513          	addi	a0,a0,1406 # 6930 <malloc+0x1a1c>
    33ba:	2a1010ef          	jal	ra,4e5a <printf>
    exit(1);
    33be:	4505                	li	a0,1
    33c0:	678010ef          	jal	ra,4a38 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33c4:	85ca                	mv	a1,s2
    33c6:	00003517          	auipc	a0,0x3
    33ca:	56a50513          	addi	a0,a0,1386 # 6930 <malloc+0x1a1c>
    33ce:	28d010ef          	jal	ra,4e5a <printf>
    exit(1);
    33d2:	4505                	li	a0,1
    33d4:	664010ef          	jal	ra,4a38 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    33d8:	85ca                	mv	a1,s2
    33da:	00003517          	auipc	a0,0x3
    33de:	57e50513          	addi	a0,a0,1406 # 6958 <malloc+0x1a44>
    33e2:	279010ef          	jal	ra,4e5a <printf>
    exit(1);
    33e6:	4505                	li	a0,1
    33e8:	650010ef          	jal	ra,4a38 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    33ec:	85ca                	mv	a1,s2
    33ee:	00003517          	auipc	a0,0x3
    33f2:	59250513          	addi	a0,a0,1426 # 6980 <malloc+0x1a6c>
    33f6:	265010ef          	jal	ra,4e5a <printf>
    exit(1);
    33fa:	4505                	li	a0,1
    33fc:	63c010ef          	jal	ra,4a38 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3400:	85ca                	mv	a1,s2
    3402:	00003517          	auipc	a0,0x3
    3406:	5a650513          	addi	a0,a0,1446 # 69a8 <malloc+0x1a94>
    340a:	251010ef          	jal	ra,4e5a <printf>
    exit(1);
    340e:	4505                	li	a0,1
    3410:	628010ef          	jal	ra,4a38 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3414:	85ca                	mv	a1,s2
    3416:	00003517          	auipc	a0,0x3
    341a:	5ba50513          	addi	a0,a0,1466 # 69d0 <malloc+0x1abc>
    341e:	23d010ef          	jal	ra,4e5a <printf>
    exit(1);
    3422:	4505                	li	a0,1
    3424:	614010ef          	jal	ra,4a38 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3428:	85ca                	mv	a1,s2
    342a:	00003517          	auipc	a0,0x3
    342e:	5c650513          	addi	a0,a0,1478 # 69f0 <malloc+0x1adc>
    3432:	229010ef          	jal	ra,4e5a <printf>
    exit(1);
    3436:	4505                	li	a0,1
    3438:	600010ef          	jal	ra,4a38 <exit>
    printf("%s: write . succeeded!\n", s);
    343c:	85ca                	mv	a1,s2
    343e:	00003517          	auipc	a0,0x3
    3442:	5da50513          	addi	a0,a0,1498 # 6a18 <malloc+0x1b04>
    3446:	215010ef          	jal	ra,4e5a <printf>
    exit(1);
    344a:	4505                	li	a0,1
    344c:	5ec010ef          	jal	ra,4a38 <exit>

0000000000003450 <iref>:
{
    3450:	7139                	addi	sp,sp,-64
    3452:	fc06                	sd	ra,56(sp)
    3454:	f822                	sd	s0,48(sp)
    3456:	f426                	sd	s1,40(sp)
    3458:	f04a                	sd	s2,32(sp)
    345a:	ec4e                	sd	s3,24(sp)
    345c:	e852                	sd	s4,16(sp)
    345e:	e456                	sd	s5,8(sp)
    3460:	e05a                	sd	s6,0(sp)
    3462:	0080                	addi	s0,sp,64
    3464:	8b2a                	mv	s6,a0
    3466:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    346a:	00003a17          	auipc	s4,0x3
    346e:	5c6a0a13          	addi	s4,s4,1478 # 6a30 <malloc+0x1b1c>
    mkdir("");
    3472:	00003497          	auipc	s1,0x3
    3476:	0c648493          	addi	s1,s1,198 # 6538 <malloc+0x1624>
    link("README", "");
    347a:	00002a97          	auipc	s5,0x2
    347e:	da6a8a93          	addi	s5,s5,-602 # 5220 <malloc+0x30c>
    fd = open("xx", O_CREATE);
    3482:	00003997          	auipc	s3,0x3
    3486:	4a698993          	addi	s3,s3,1190 # 6928 <malloc+0x1a14>
    348a:	a835                	j	34c6 <iref+0x76>
      printf("%s: mkdir irefd failed\n", s);
    348c:	85da                	mv	a1,s6
    348e:	00003517          	auipc	a0,0x3
    3492:	5aa50513          	addi	a0,a0,1450 # 6a38 <malloc+0x1b24>
    3496:	1c5010ef          	jal	ra,4e5a <printf>
      exit(1);
    349a:	4505                	li	a0,1
    349c:	59c010ef          	jal	ra,4a38 <exit>
      printf("%s: chdir irefd failed\n", s);
    34a0:	85da                	mv	a1,s6
    34a2:	00003517          	auipc	a0,0x3
    34a6:	5ae50513          	addi	a0,a0,1454 # 6a50 <malloc+0x1b3c>
    34aa:	1b1010ef          	jal	ra,4e5a <printf>
      exit(1);
    34ae:	4505                	li	a0,1
    34b0:	588010ef          	jal	ra,4a38 <exit>
      close(fd);
    34b4:	5ac010ef          	jal	ra,4a60 <close>
    34b8:	a82d                	j	34f2 <iref+0xa2>
    unlink("xx");
    34ba:	854e                	mv	a0,s3
    34bc:	5cc010ef          	jal	ra,4a88 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    34c0:	397d                	addiw	s2,s2,-1
    34c2:	04090263          	beqz	s2,3506 <iref+0xb6>
    if(mkdir("irefd") != 0){
    34c6:	8552                	mv	a0,s4
    34c8:	5d8010ef          	jal	ra,4aa0 <mkdir>
    34cc:	f161                	bnez	a0,348c <iref+0x3c>
    if(chdir("irefd") != 0){
    34ce:	8552                	mv	a0,s4
    34d0:	5d8010ef          	jal	ra,4aa8 <chdir>
    34d4:	f571                	bnez	a0,34a0 <iref+0x50>
    mkdir("");
    34d6:	8526                	mv	a0,s1
    34d8:	5c8010ef          	jal	ra,4aa0 <mkdir>
    link("README", "");
    34dc:	85a6                	mv	a1,s1
    34de:	8556                	mv	a0,s5
    34e0:	5b8010ef          	jal	ra,4a98 <link>
    fd = open("", O_CREATE);
    34e4:	20000593          	li	a1,512
    34e8:	8526                	mv	a0,s1
    34ea:	58e010ef          	jal	ra,4a78 <open>
    if(fd >= 0)
    34ee:	fc0553e3          	bgez	a0,34b4 <iref+0x64>
    fd = open("xx", O_CREATE);
    34f2:	20000593          	li	a1,512
    34f6:	854e                	mv	a0,s3
    34f8:	580010ef          	jal	ra,4a78 <open>
    if(fd >= 0)
    34fc:	fa054fe3          	bltz	a0,34ba <iref+0x6a>
      close(fd);
    3500:	560010ef          	jal	ra,4a60 <close>
    3504:	bf5d                	j	34ba <iref+0x6a>
    3506:	03300493          	li	s1,51
    chdir("..");
    350a:	00003997          	auipc	s3,0x3
    350e:	d4698993          	addi	s3,s3,-698 # 6250 <malloc+0x133c>
    unlink("irefd");
    3512:	00003917          	auipc	s2,0x3
    3516:	51e90913          	addi	s2,s2,1310 # 6a30 <malloc+0x1b1c>
    chdir("..");
    351a:	854e                	mv	a0,s3
    351c:	58c010ef          	jal	ra,4aa8 <chdir>
    unlink("irefd");
    3520:	854a                	mv	a0,s2
    3522:	566010ef          	jal	ra,4a88 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3526:	34fd                	addiw	s1,s1,-1
    3528:	f8ed                	bnez	s1,351a <iref+0xca>
  chdir("/");
    352a:	00003517          	auipc	a0,0x3
    352e:	cce50513          	addi	a0,a0,-818 # 61f8 <malloc+0x12e4>
    3532:	576010ef          	jal	ra,4aa8 <chdir>
}
    3536:	70e2                	ld	ra,56(sp)
    3538:	7442                	ld	s0,48(sp)
    353a:	74a2                	ld	s1,40(sp)
    353c:	7902                	ld	s2,32(sp)
    353e:	69e2                	ld	s3,24(sp)
    3540:	6a42                	ld	s4,16(sp)
    3542:	6aa2                	ld	s5,8(sp)
    3544:	6b02                	ld	s6,0(sp)
    3546:	6121                	addi	sp,sp,64
    3548:	8082                	ret

000000000000354a <openiputtest>:
{
    354a:	7179                	addi	sp,sp,-48
    354c:	f406                	sd	ra,40(sp)
    354e:	f022                	sd	s0,32(sp)
    3550:	ec26                	sd	s1,24(sp)
    3552:	1800                	addi	s0,sp,48
    3554:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3556:	00003517          	auipc	a0,0x3
    355a:	51250513          	addi	a0,a0,1298 # 6a68 <malloc+0x1b54>
    355e:	542010ef          	jal	ra,4aa0 <mkdir>
    3562:	02054a63          	bltz	a0,3596 <openiputtest+0x4c>
  pid = fork();
    3566:	4ca010ef          	jal	ra,4a30 <fork>
  if(pid < 0){
    356a:	04054063          	bltz	a0,35aa <openiputtest+0x60>
  if(pid == 0){
    356e:	e939                	bnez	a0,35c4 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    3570:	4589                	li	a1,2
    3572:	00003517          	auipc	a0,0x3
    3576:	4f650513          	addi	a0,a0,1270 # 6a68 <malloc+0x1b54>
    357a:	4fe010ef          	jal	ra,4a78 <open>
    if(fd >= 0){
    357e:	04054063          	bltz	a0,35be <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    3582:	85a6                	mv	a1,s1
    3584:	00003517          	auipc	a0,0x3
    3588:	50450513          	addi	a0,a0,1284 # 6a88 <malloc+0x1b74>
    358c:	0cf010ef          	jal	ra,4e5a <printf>
      exit(1);
    3590:	4505                	li	a0,1
    3592:	4a6010ef          	jal	ra,4a38 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3596:	85a6                	mv	a1,s1
    3598:	00003517          	auipc	a0,0x3
    359c:	4d850513          	addi	a0,a0,1240 # 6a70 <malloc+0x1b5c>
    35a0:	0bb010ef          	jal	ra,4e5a <printf>
    exit(1);
    35a4:	4505                	li	a0,1
    35a6:	492010ef          	jal	ra,4a38 <exit>
    printf("%s: fork failed\n", s);
    35aa:	85a6                	mv	a1,s1
    35ac:	00002517          	auipc	a0,0x2
    35b0:	32c50513          	addi	a0,a0,812 # 58d8 <malloc+0x9c4>
    35b4:	0a7010ef          	jal	ra,4e5a <printf>
    exit(1);
    35b8:	4505                	li	a0,1
    35ba:	47e010ef          	jal	ra,4a38 <exit>
    exit(0);
    35be:	4501                	li	a0,0
    35c0:	478010ef          	jal	ra,4a38 <exit>
  sleep(1);
    35c4:	4505                	li	a0,1
    35c6:	502010ef          	jal	ra,4ac8 <sleep>
  if(unlink("oidir") != 0){
    35ca:	00003517          	auipc	a0,0x3
    35ce:	49e50513          	addi	a0,a0,1182 # 6a68 <malloc+0x1b54>
    35d2:	4b6010ef          	jal	ra,4a88 <unlink>
    35d6:	c919                	beqz	a0,35ec <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    35d8:	85a6                	mv	a1,s1
    35da:	00002517          	auipc	a0,0x2
    35de:	4ee50513          	addi	a0,a0,1262 # 5ac8 <malloc+0xbb4>
    35e2:	079010ef          	jal	ra,4e5a <printf>
    exit(1);
    35e6:	4505                	li	a0,1
    35e8:	450010ef          	jal	ra,4a38 <exit>
  wait(&xstatus);
    35ec:	fdc40513          	addi	a0,s0,-36
    35f0:	450010ef          	jal	ra,4a40 <wait>
  exit(xstatus);
    35f4:	fdc42503          	lw	a0,-36(s0)
    35f8:	440010ef          	jal	ra,4a38 <exit>

00000000000035fc <forkforkfork>:
{
    35fc:	1101                	addi	sp,sp,-32
    35fe:	ec06                	sd	ra,24(sp)
    3600:	e822                	sd	s0,16(sp)
    3602:	e426                	sd	s1,8(sp)
    3604:	1000                	addi	s0,sp,32
    3606:	84aa                	mv	s1,a0
  unlink("stopforking");
    3608:	00003517          	auipc	a0,0x3
    360c:	4a850513          	addi	a0,a0,1192 # 6ab0 <malloc+0x1b9c>
    3610:	478010ef          	jal	ra,4a88 <unlink>
  int pid = fork();
    3614:	41c010ef          	jal	ra,4a30 <fork>
  if(pid < 0){
    3618:	02054b63          	bltz	a0,364e <forkforkfork+0x52>
  if(pid == 0){
    361c:	c139                	beqz	a0,3662 <forkforkfork+0x66>
  sleep(20); // two seconds
    361e:	4551                	li	a0,20
    3620:	4a8010ef          	jal	ra,4ac8 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3624:	20200593          	li	a1,514
    3628:	00003517          	auipc	a0,0x3
    362c:	48850513          	addi	a0,a0,1160 # 6ab0 <malloc+0x1b9c>
    3630:	448010ef          	jal	ra,4a78 <open>
    3634:	42c010ef          	jal	ra,4a60 <close>
  wait(0);
    3638:	4501                	li	a0,0
    363a:	406010ef          	jal	ra,4a40 <wait>
  sleep(10); // one second
    363e:	4529                	li	a0,10
    3640:	488010ef          	jal	ra,4ac8 <sleep>
}
    3644:	60e2                	ld	ra,24(sp)
    3646:	6442                	ld	s0,16(sp)
    3648:	64a2                	ld	s1,8(sp)
    364a:	6105                	addi	sp,sp,32
    364c:	8082                	ret
    printf("%s: fork failed", s);
    364e:	85a6                	mv	a1,s1
    3650:	00002517          	auipc	a0,0x2
    3654:	44850513          	addi	a0,a0,1096 # 5a98 <malloc+0xb84>
    3658:	003010ef          	jal	ra,4e5a <printf>
    exit(1);
    365c:	4505                	li	a0,1
    365e:	3da010ef          	jal	ra,4a38 <exit>
      int fd = open("stopforking", 0);
    3662:	00003497          	auipc	s1,0x3
    3666:	44e48493          	addi	s1,s1,1102 # 6ab0 <malloc+0x1b9c>
    366a:	4581                	li	a1,0
    366c:	8526                	mv	a0,s1
    366e:	40a010ef          	jal	ra,4a78 <open>
      if(fd >= 0){
    3672:	00055e63          	bgez	a0,368e <forkforkfork+0x92>
      if(fork() < 0){
    3676:	3ba010ef          	jal	ra,4a30 <fork>
    367a:	fe0558e3          	bgez	a0,366a <forkforkfork+0x6e>
        close(open("stopforking", O_CREATE|O_RDWR));
    367e:	20200593          	li	a1,514
    3682:	8526                	mv	a0,s1
    3684:	3f4010ef          	jal	ra,4a78 <open>
    3688:	3d8010ef          	jal	ra,4a60 <close>
    368c:	bff9                	j	366a <forkforkfork+0x6e>
        exit(0);
    368e:	4501                	li	a0,0
    3690:	3a8010ef          	jal	ra,4a38 <exit>

0000000000003694 <killstatus>:
{
    3694:	7139                	addi	sp,sp,-64
    3696:	fc06                	sd	ra,56(sp)
    3698:	f822                	sd	s0,48(sp)
    369a:	f426                	sd	s1,40(sp)
    369c:	f04a                	sd	s2,32(sp)
    369e:	ec4e                	sd	s3,24(sp)
    36a0:	e852                	sd	s4,16(sp)
    36a2:	0080                	addi	s0,sp,64
    36a4:	8a2a                	mv	s4,a0
    36a6:	06400913          	li	s2,100
    if(xst != -1) {
    36aa:	59fd                	li	s3,-1
    int pid1 = fork();
    36ac:	384010ef          	jal	ra,4a30 <fork>
    36b0:	84aa                	mv	s1,a0
    if(pid1 < 0){
    36b2:	02054763          	bltz	a0,36e0 <killstatus+0x4c>
    if(pid1 == 0){
    36b6:	cd1d                	beqz	a0,36f4 <killstatus+0x60>
    sleep(1);
    36b8:	4505                	li	a0,1
    36ba:	40e010ef          	jal	ra,4ac8 <sleep>
    kill(pid1);
    36be:	8526                	mv	a0,s1
    36c0:	3a8010ef          	jal	ra,4a68 <kill>
    wait(&xst);
    36c4:	fcc40513          	addi	a0,s0,-52
    36c8:	378010ef          	jal	ra,4a40 <wait>
    if(xst != -1) {
    36cc:	fcc42783          	lw	a5,-52(s0)
    36d0:	03379563          	bne	a5,s3,36fa <killstatus+0x66>
  for(int i = 0; i < 100; i++){
    36d4:	397d                	addiw	s2,s2,-1
    36d6:	fc091be3          	bnez	s2,36ac <killstatus+0x18>
  exit(0);
    36da:	4501                	li	a0,0
    36dc:	35c010ef          	jal	ra,4a38 <exit>
      printf("%s: fork failed\n", s);
    36e0:	85d2                	mv	a1,s4
    36e2:	00002517          	auipc	a0,0x2
    36e6:	1f650513          	addi	a0,a0,502 # 58d8 <malloc+0x9c4>
    36ea:	770010ef          	jal	ra,4e5a <printf>
      exit(1);
    36ee:	4505                	li	a0,1
    36f0:	348010ef          	jal	ra,4a38 <exit>
        getpid();
    36f4:	3c4010ef          	jal	ra,4ab8 <getpid>
      while(1) {
    36f8:	bff5                	j	36f4 <killstatus+0x60>
       printf("%s: status should be -1\n", s);
    36fa:	85d2                	mv	a1,s4
    36fc:	00003517          	auipc	a0,0x3
    3700:	3c450513          	addi	a0,a0,964 # 6ac0 <malloc+0x1bac>
    3704:	756010ef          	jal	ra,4e5a <printf>
       exit(1);
    3708:	4505                	li	a0,1
    370a:	32e010ef          	jal	ra,4a38 <exit>

000000000000370e <preempt>:
{
    370e:	7139                	addi	sp,sp,-64
    3710:	fc06                	sd	ra,56(sp)
    3712:	f822                	sd	s0,48(sp)
    3714:	f426                	sd	s1,40(sp)
    3716:	f04a                	sd	s2,32(sp)
    3718:	ec4e                	sd	s3,24(sp)
    371a:	e852                	sd	s4,16(sp)
    371c:	0080                	addi	s0,sp,64
    371e:	892a                	mv	s2,a0
  pid1 = fork();
    3720:	310010ef          	jal	ra,4a30 <fork>
  if(pid1 < 0) {
    3724:	00054563          	bltz	a0,372e <preempt+0x20>
    3728:	84aa                	mv	s1,a0
  if(pid1 == 0)
    372a:	ed01                	bnez	a0,3742 <preempt+0x34>
    for(;;)
    372c:	a001                	j	372c <preempt+0x1e>
    printf("%s: fork failed", s);
    372e:	85ca                	mv	a1,s2
    3730:	00002517          	auipc	a0,0x2
    3734:	36850513          	addi	a0,a0,872 # 5a98 <malloc+0xb84>
    3738:	722010ef          	jal	ra,4e5a <printf>
    exit(1);
    373c:	4505                	li	a0,1
    373e:	2fa010ef          	jal	ra,4a38 <exit>
  pid2 = fork();
    3742:	2ee010ef          	jal	ra,4a30 <fork>
    3746:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3748:	00054463          	bltz	a0,3750 <preempt+0x42>
  if(pid2 == 0)
    374c:	ed01                	bnez	a0,3764 <preempt+0x56>
    for(;;)
    374e:	a001                	j	374e <preempt+0x40>
    printf("%s: fork failed\n", s);
    3750:	85ca                	mv	a1,s2
    3752:	00002517          	auipc	a0,0x2
    3756:	18650513          	addi	a0,a0,390 # 58d8 <malloc+0x9c4>
    375a:	700010ef          	jal	ra,4e5a <printf>
    exit(1);
    375e:	4505                	li	a0,1
    3760:	2d8010ef          	jal	ra,4a38 <exit>
  pipe(pfds);
    3764:	fc840513          	addi	a0,s0,-56
    3768:	2e0010ef          	jal	ra,4a48 <pipe>
  pid3 = fork();
    376c:	2c4010ef          	jal	ra,4a30 <fork>
    3770:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    3772:	02054863          	bltz	a0,37a2 <preempt+0x94>
  if(pid3 == 0){
    3776:	e921                	bnez	a0,37c6 <preempt+0xb8>
    close(pfds[0]);
    3778:	fc842503          	lw	a0,-56(s0)
    377c:	2e4010ef          	jal	ra,4a60 <close>
    if(write(pfds[1], "x", 1) != 1)
    3780:	4605                	li	a2,1
    3782:	00002597          	auipc	a1,0x2
    3786:	93658593          	addi	a1,a1,-1738 # 50b8 <malloc+0x1a4>
    378a:	fcc42503          	lw	a0,-52(s0)
    378e:	2ca010ef          	jal	ra,4a58 <write>
    3792:	4785                	li	a5,1
    3794:	02f51163          	bne	a0,a5,37b6 <preempt+0xa8>
    close(pfds[1]);
    3798:	fcc42503          	lw	a0,-52(s0)
    379c:	2c4010ef          	jal	ra,4a60 <close>
    for(;;)
    37a0:	a001                	j	37a0 <preempt+0x92>
     printf("%s: fork failed\n", s);
    37a2:	85ca                	mv	a1,s2
    37a4:	00002517          	auipc	a0,0x2
    37a8:	13450513          	addi	a0,a0,308 # 58d8 <malloc+0x9c4>
    37ac:	6ae010ef          	jal	ra,4e5a <printf>
     exit(1);
    37b0:	4505                	li	a0,1
    37b2:	286010ef          	jal	ra,4a38 <exit>
      printf("%s: preempt write error", s);
    37b6:	85ca                	mv	a1,s2
    37b8:	00003517          	auipc	a0,0x3
    37bc:	32850513          	addi	a0,a0,808 # 6ae0 <malloc+0x1bcc>
    37c0:	69a010ef          	jal	ra,4e5a <printf>
    37c4:	bfd1                	j	3798 <preempt+0x8a>
  close(pfds[1]);
    37c6:	fcc42503          	lw	a0,-52(s0)
    37ca:	296010ef          	jal	ra,4a60 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    37ce:	660d                	lui	a2,0x3
    37d0:	00008597          	auipc	a1,0x8
    37d4:	4a858593          	addi	a1,a1,1192 # bc78 <buf>
    37d8:	fc842503          	lw	a0,-56(s0)
    37dc:	274010ef          	jal	ra,4a50 <read>
    37e0:	4785                	li	a5,1
    37e2:	02f50163          	beq	a0,a5,3804 <preempt+0xf6>
    printf("%s: preempt read error", s);
    37e6:	85ca                	mv	a1,s2
    37e8:	00003517          	auipc	a0,0x3
    37ec:	31050513          	addi	a0,a0,784 # 6af8 <malloc+0x1be4>
    37f0:	66a010ef          	jal	ra,4e5a <printf>
}
    37f4:	70e2                	ld	ra,56(sp)
    37f6:	7442                	ld	s0,48(sp)
    37f8:	74a2                	ld	s1,40(sp)
    37fa:	7902                	ld	s2,32(sp)
    37fc:	69e2                	ld	s3,24(sp)
    37fe:	6a42                	ld	s4,16(sp)
    3800:	6121                	addi	sp,sp,64
    3802:	8082                	ret
  close(pfds[0]);
    3804:	fc842503          	lw	a0,-56(s0)
    3808:	258010ef          	jal	ra,4a60 <close>
  printf("kill... ");
    380c:	00003517          	auipc	a0,0x3
    3810:	30450513          	addi	a0,a0,772 # 6b10 <malloc+0x1bfc>
    3814:	646010ef          	jal	ra,4e5a <printf>
  kill(pid1);
    3818:	8526                	mv	a0,s1
    381a:	24e010ef          	jal	ra,4a68 <kill>
  kill(pid2);
    381e:	854e                	mv	a0,s3
    3820:	248010ef          	jal	ra,4a68 <kill>
  kill(pid3);
    3824:	8552                	mv	a0,s4
    3826:	242010ef          	jal	ra,4a68 <kill>
  printf("wait... ");
    382a:	00003517          	auipc	a0,0x3
    382e:	2f650513          	addi	a0,a0,758 # 6b20 <malloc+0x1c0c>
    3832:	628010ef          	jal	ra,4e5a <printf>
  wait(0);
    3836:	4501                	li	a0,0
    3838:	208010ef          	jal	ra,4a40 <wait>
  wait(0);
    383c:	4501                	li	a0,0
    383e:	202010ef          	jal	ra,4a40 <wait>
  wait(0);
    3842:	4501                	li	a0,0
    3844:	1fc010ef          	jal	ra,4a40 <wait>
    3848:	b775                	j	37f4 <preempt+0xe6>

000000000000384a <reparent>:
{
    384a:	7179                	addi	sp,sp,-48
    384c:	f406                	sd	ra,40(sp)
    384e:	f022                	sd	s0,32(sp)
    3850:	ec26                	sd	s1,24(sp)
    3852:	e84a                	sd	s2,16(sp)
    3854:	e44e                	sd	s3,8(sp)
    3856:	e052                	sd	s4,0(sp)
    3858:	1800                	addi	s0,sp,48
    385a:	89aa                	mv	s3,a0
  int master_pid = getpid();
    385c:	25c010ef          	jal	ra,4ab8 <getpid>
    3860:	8a2a                	mv	s4,a0
    3862:	0c800913          	li	s2,200
    int pid = fork();
    3866:	1ca010ef          	jal	ra,4a30 <fork>
    386a:	84aa                	mv	s1,a0
    if(pid < 0){
    386c:	00054e63          	bltz	a0,3888 <reparent+0x3e>
    if(pid){
    3870:	c121                	beqz	a0,38b0 <reparent+0x66>
      if(wait(0) != pid){
    3872:	4501                	li	a0,0
    3874:	1cc010ef          	jal	ra,4a40 <wait>
    3878:	02951263          	bne	a0,s1,389c <reparent+0x52>
  for(int i = 0; i < 200; i++){
    387c:	397d                	addiw	s2,s2,-1
    387e:	fe0914e3          	bnez	s2,3866 <reparent+0x1c>
  exit(0);
    3882:	4501                	li	a0,0
    3884:	1b4010ef          	jal	ra,4a38 <exit>
      printf("%s: fork failed\n", s);
    3888:	85ce                	mv	a1,s3
    388a:	00002517          	auipc	a0,0x2
    388e:	04e50513          	addi	a0,a0,78 # 58d8 <malloc+0x9c4>
    3892:	5c8010ef          	jal	ra,4e5a <printf>
      exit(1);
    3896:	4505                	li	a0,1
    3898:	1a0010ef          	jal	ra,4a38 <exit>
        printf("%s: wait wrong pid\n", s);
    389c:	85ce                	mv	a1,s3
    389e:	00002517          	auipc	a0,0x2
    38a2:	1c250513          	addi	a0,a0,450 # 5a60 <malloc+0xb4c>
    38a6:	5b4010ef          	jal	ra,4e5a <printf>
        exit(1);
    38aa:	4505                	li	a0,1
    38ac:	18c010ef          	jal	ra,4a38 <exit>
      int pid2 = fork();
    38b0:	180010ef          	jal	ra,4a30 <fork>
      if(pid2 < 0){
    38b4:	00054563          	bltz	a0,38be <reparent+0x74>
      exit(0);
    38b8:	4501                	li	a0,0
    38ba:	17e010ef          	jal	ra,4a38 <exit>
        kill(master_pid);
    38be:	8552                	mv	a0,s4
    38c0:	1a8010ef          	jal	ra,4a68 <kill>
        exit(1);
    38c4:	4505                	li	a0,1
    38c6:	172010ef          	jal	ra,4a38 <exit>

00000000000038ca <sbrkfail>:
{
    38ca:	7119                	addi	sp,sp,-128
    38cc:	fc86                	sd	ra,120(sp)
    38ce:	f8a2                	sd	s0,112(sp)
    38d0:	f4a6                	sd	s1,104(sp)
    38d2:	f0ca                	sd	s2,96(sp)
    38d4:	ecce                	sd	s3,88(sp)
    38d6:	e8d2                	sd	s4,80(sp)
    38d8:	e4d6                	sd	s5,72(sp)
    38da:	0100                	addi	s0,sp,128
    38dc:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    38de:	fb040513          	addi	a0,s0,-80
    38e2:	166010ef          	jal	ra,4a48 <pipe>
    38e6:	e901                	bnez	a0,38f6 <sbrkfail+0x2c>
    38e8:	f8040493          	addi	s1,s0,-128
    38ec:	fa840993          	addi	s3,s0,-88
    38f0:	8926                	mv	s2,s1
    if(pids[i] != -1)
    38f2:	5a7d                	li	s4,-1
    38f4:	a0a1                	j	393c <sbrkfail+0x72>
    printf("%s: pipe() failed\n", s);
    38f6:	85d6                	mv	a1,s5
    38f8:	00002517          	auipc	a0,0x2
    38fc:	0e850513          	addi	a0,a0,232 # 59e0 <malloc+0xacc>
    3900:	55a010ef          	jal	ra,4e5a <printf>
    exit(1);
    3904:	4505                	li	a0,1
    3906:	132010ef          	jal	ra,4a38 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    390a:	1b6010ef          	jal	ra,4ac0 <sbrk>
    390e:	064007b7          	lui	a5,0x6400
    3912:	40a7853b          	subw	a0,a5,a0
    3916:	1aa010ef          	jal	ra,4ac0 <sbrk>
      write(fds[1], "x", 1);
    391a:	4605                	li	a2,1
    391c:	00001597          	auipc	a1,0x1
    3920:	79c58593          	addi	a1,a1,1948 # 50b8 <malloc+0x1a4>
    3924:	fb442503          	lw	a0,-76(s0)
    3928:	130010ef          	jal	ra,4a58 <write>
      for(;;) sleep(1000);
    392c:	3e800513          	li	a0,1000
    3930:	198010ef          	jal	ra,4ac8 <sleep>
    3934:	bfe5                	j	392c <sbrkfail+0x62>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3936:	0911                	addi	s2,s2,4
    3938:	03390163          	beq	s2,s3,395a <sbrkfail+0x90>
    if((pids[i] = fork()) == 0){
    393c:	0f4010ef          	jal	ra,4a30 <fork>
    3940:	00a92023          	sw	a0,0(s2)
    3944:	d179                	beqz	a0,390a <sbrkfail+0x40>
    if(pids[i] != -1)
    3946:	ff4508e3          	beq	a0,s4,3936 <sbrkfail+0x6c>
      read(fds[0], &scratch, 1);
    394a:	4605                	li	a2,1
    394c:	faf40593          	addi	a1,s0,-81
    3950:	fb042503          	lw	a0,-80(s0)
    3954:	0fc010ef          	jal	ra,4a50 <read>
    3958:	bff9                	j	3936 <sbrkfail+0x6c>
  c = sbrk(PGSIZE);
    395a:	6505                	lui	a0,0x1
    395c:	164010ef          	jal	ra,4ac0 <sbrk>
    3960:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    3962:	597d                	li	s2,-1
    3964:	a021                	j	396c <sbrkfail+0xa2>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3966:	0491                	addi	s1,s1,4
    3968:	01348b63          	beq	s1,s3,397e <sbrkfail+0xb4>
    if(pids[i] == -1)
    396c:	4088                	lw	a0,0(s1)
    396e:	ff250ce3          	beq	a0,s2,3966 <sbrkfail+0x9c>
    kill(pids[i]);
    3972:	0f6010ef          	jal	ra,4a68 <kill>
    wait(0);
    3976:	4501                	li	a0,0
    3978:	0c8010ef          	jal	ra,4a40 <wait>
    397c:	b7ed                	j	3966 <sbrkfail+0x9c>
  if(c == (char*)0xffffffffffffffffL){
    397e:	57fd                	li	a5,-1
    3980:	02fa0d63          	beq	s4,a5,39ba <sbrkfail+0xf0>
  pid = fork();
    3984:	0ac010ef          	jal	ra,4a30 <fork>
    3988:	84aa                	mv	s1,a0
  if(pid < 0){
    398a:	04054263          	bltz	a0,39ce <sbrkfail+0x104>
  if(pid == 0){
    398e:	c931                	beqz	a0,39e2 <sbrkfail+0x118>
  wait(&xstatus);
    3990:	fbc40513          	addi	a0,s0,-68
    3994:	0ac010ef          	jal	ra,4a40 <wait>
  if(xstatus != -1 && xstatus != 2)
    3998:	fbc42783          	lw	a5,-68(s0)
    399c:	577d                	li	a4,-1
    399e:	00e78563          	beq	a5,a4,39a8 <sbrkfail+0xde>
    39a2:	4709                	li	a4,2
    39a4:	06e79d63          	bne	a5,a4,3a1e <sbrkfail+0x154>
}
    39a8:	70e6                	ld	ra,120(sp)
    39aa:	7446                	ld	s0,112(sp)
    39ac:	74a6                	ld	s1,104(sp)
    39ae:	7906                	ld	s2,96(sp)
    39b0:	69e6                	ld	s3,88(sp)
    39b2:	6a46                	ld	s4,80(sp)
    39b4:	6aa6                	ld	s5,72(sp)
    39b6:	6109                	addi	sp,sp,128
    39b8:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    39ba:	85d6                	mv	a1,s5
    39bc:	00003517          	auipc	a0,0x3
    39c0:	17450513          	addi	a0,a0,372 # 6b30 <malloc+0x1c1c>
    39c4:	496010ef          	jal	ra,4e5a <printf>
    exit(1);
    39c8:	4505                	li	a0,1
    39ca:	06e010ef          	jal	ra,4a38 <exit>
    printf("%s: fork failed\n", s);
    39ce:	85d6                	mv	a1,s5
    39d0:	00002517          	auipc	a0,0x2
    39d4:	f0850513          	addi	a0,a0,-248 # 58d8 <malloc+0x9c4>
    39d8:	482010ef          	jal	ra,4e5a <printf>
    exit(1);
    39dc:	4505                	li	a0,1
    39de:	05a010ef          	jal	ra,4a38 <exit>
    a = sbrk(0);
    39e2:	4501                	li	a0,0
    39e4:	0dc010ef          	jal	ra,4ac0 <sbrk>
    39e8:	892a                	mv	s2,a0
    sbrk(10*BIG);
    39ea:	3e800537          	lui	a0,0x3e800
    39ee:	0d2010ef          	jal	ra,4ac0 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    39f2:	87ca                	mv	a5,s2
    39f4:	3e800737          	lui	a4,0x3e800
    39f8:	993a                	add	s2,s2,a4
    39fa:	6705                	lui	a4,0x1
      n += *(a+i);
    39fc:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f1388>
    3a00:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3a02:	97ba                	add	a5,a5,a4
    3a04:	ff279ce3          	bne	a5,s2,39fc <sbrkfail+0x132>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    3a08:	8626                	mv	a2,s1
    3a0a:	85d6                	mv	a1,s5
    3a0c:	00003517          	auipc	a0,0x3
    3a10:	14450513          	addi	a0,a0,324 # 6b50 <malloc+0x1c3c>
    3a14:	446010ef          	jal	ra,4e5a <printf>
    exit(1);
    3a18:	4505                	li	a0,1
    3a1a:	01e010ef          	jal	ra,4a38 <exit>
    exit(1);
    3a1e:	4505                	li	a0,1
    3a20:	018010ef          	jal	ra,4a38 <exit>

0000000000003a24 <mem>:
{
    3a24:	7139                	addi	sp,sp,-64
    3a26:	fc06                	sd	ra,56(sp)
    3a28:	f822                	sd	s0,48(sp)
    3a2a:	f426                	sd	s1,40(sp)
    3a2c:	f04a                	sd	s2,32(sp)
    3a2e:	ec4e                	sd	s3,24(sp)
    3a30:	0080                	addi	s0,sp,64
    3a32:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3a34:	7fd000ef          	jal	ra,4a30 <fork>
    m1 = 0;
    3a38:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3a3a:	6909                	lui	s2,0x2
    3a3c:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0xcd>
  if((pid = fork()) == 0){
    3a40:	cd11                	beqz	a0,3a5c <mem+0x38>
    wait(&xstatus);
    3a42:	fcc40513          	addi	a0,s0,-52
    3a46:	7fb000ef          	jal	ra,4a40 <wait>
    if(xstatus == -1){
    3a4a:	fcc42503          	lw	a0,-52(s0)
    3a4e:	57fd                	li	a5,-1
    3a50:	04f50363          	beq	a0,a5,3a96 <mem+0x72>
    exit(xstatus);
    3a54:	7e5000ef          	jal	ra,4a38 <exit>
      *(char**)m2 = m1;
    3a58:	e104                	sd	s1,0(a0)
      m1 = m2;
    3a5a:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3a5c:	854a                	mv	a0,s2
    3a5e:	4b6010ef          	jal	ra,4f14 <malloc>
    3a62:	f97d                	bnez	a0,3a58 <mem+0x34>
    while(m1){
    3a64:	c491                	beqz	s1,3a70 <mem+0x4c>
      m2 = *(char**)m1;
    3a66:	8526                	mv	a0,s1
    3a68:	6084                	ld	s1,0(s1)
      free(m1);
    3a6a:	422010ef          	jal	ra,4e8c <free>
    while(m1){
    3a6e:	fce5                	bnez	s1,3a66 <mem+0x42>
    m1 = malloc(1024*20);
    3a70:	6515                	lui	a0,0x5
    3a72:	4a2010ef          	jal	ra,4f14 <malloc>
    if(m1 == 0){
    3a76:	c511                	beqz	a0,3a82 <mem+0x5e>
    free(m1);
    3a78:	414010ef          	jal	ra,4e8c <free>
    exit(0);
    3a7c:	4501                	li	a0,0
    3a7e:	7bb000ef          	jal	ra,4a38 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3a82:	85ce                	mv	a1,s3
    3a84:	00003517          	auipc	a0,0x3
    3a88:	0fc50513          	addi	a0,a0,252 # 6b80 <malloc+0x1c6c>
    3a8c:	3ce010ef          	jal	ra,4e5a <printf>
      exit(1);
    3a90:	4505                	li	a0,1
    3a92:	7a7000ef          	jal	ra,4a38 <exit>
      exit(0);
    3a96:	4501                	li	a0,0
    3a98:	7a1000ef          	jal	ra,4a38 <exit>

0000000000003a9c <sharedfd>:
{
    3a9c:	7159                	addi	sp,sp,-112
    3a9e:	f486                	sd	ra,104(sp)
    3aa0:	f0a2                	sd	s0,96(sp)
    3aa2:	eca6                	sd	s1,88(sp)
    3aa4:	e8ca                	sd	s2,80(sp)
    3aa6:	e4ce                	sd	s3,72(sp)
    3aa8:	e0d2                	sd	s4,64(sp)
    3aaa:	fc56                	sd	s5,56(sp)
    3aac:	f85a                	sd	s6,48(sp)
    3aae:	f45e                	sd	s7,40(sp)
    3ab0:	1880                	addi	s0,sp,112
    3ab2:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    3ab4:	00003517          	auipc	a0,0x3
    3ab8:	0ec50513          	addi	a0,a0,236 # 6ba0 <malloc+0x1c8c>
    3abc:	7cd000ef          	jal	ra,4a88 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3ac0:	20200593          	li	a1,514
    3ac4:	00003517          	auipc	a0,0x3
    3ac8:	0dc50513          	addi	a0,a0,220 # 6ba0 <malloc+0x1c8c>
    3acc:	7ad000ef          	jal	ra,4a78 <open>
  if(fd < 0){
    3ad0:	04054263          	bltz	a0,3b14 <sharedfd+0x78>
    3ad4:	892a                	mv	s2,a0
  pid = fork();
    3ad6:	75b000ef          	jal	ra,4a30 <fork>
    3ada:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3adc:	06300593          	li	a1,99
    3ae0:	c119                	beqz	a0,3ae6 <sharedfd+0x4a>
    3ae2:	07000593          	li	a1,112
    3ae6:	4629                	li	a2,10
    3ae8:	fa040513          	addi	a0,s0,-96
    3aec:	565000ef          	jal	ra,4850 <memset>
    3af0:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3af4:	4629                	li	a2,10
    3af6:	fa040593          	addi	a1,s0,-96
    3afa:	854a                	mv	a0,s2
    3afc:	75d000ef          	jal	ra,4a58 <write>
    3b00:	47a9                	li	a5,10
    3b02:	02f51363          	bne	a0,a5,3b28 <sharedfd+0x8c>
  for(i = 0; i < N; i++){
    3b06:	34fd                	addiw	s1,s1,-1
    3b08:	f4f5                	bnez	s1,3af4 <sharedfd+0x58>
  if(pid == 0) {
    3b0a:	02099963          	bnez	s3,3b3c <sharedfd+0xa0>
    exit(0);
    3b0e:	4501                	li	a0,0
    3b10:	729000ef          	jal	ra,4a38 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    3b14:	85d2                	mv	a1,s4
    3b16:	00003517          	auipc	a0,0x3
    3b1a:	09a50513          	addi	a0,a0,154 # 6bb0 <malloc+0x1c9c>
    3b1e:	33c010ef          	jal	ra,4e5a <printf>
    exit(1);
    3b22:	4505                	li	a0,1
    3b24:	715000ef          	jal	ra,4a38 <exit>
      printf("%s: write sharedfd failed\n", s);
    3b28:	85d2                	mv	a1,s4
    3b2a:	00003517          	auipc	a0,0x3
    3b2e:	0ae50513          	addi	a0,a0,174 # 6bd8 <malloc+0x1cc4>
    3b32:	328010ef          	jal	ra,4e5a <printf>
      exit(1);
    3b36:	4505                	li	a0,1
    3b38:	701000ef          	jal	ra,4a38 <exit>
    wait(&xstatus);
    3b3c:	f9c40513          	addi	a0,s0,-100
    3b40:	701000ef          	jal	ra,4a40 <wait>
    if(xstatus != 0)
    3b44:	f9c42983          	lw	s3,-100(s0)
    3b48:	00098563          	beqz	s3,3b52 <sharedfd+0xb6>
      exit(xstatus);
    3b4c:	854e                	mv	a0,s3
    3b4e:	6eb000ef          	jal	ra,4a38 <exit>
  close(fd);
    3b52:	854a                	mv	a0,s2
    3b54:	70d000ef          	jal	ra,4a60 <close>
  fd = open("sharedfd", 0);
    3b58:	4581                	li	a1,0
    3b5a:	00003517          	auipc	a0,0x3
    3b5e:	04650513          	addi	a0,a0,70 # 6ba0 <malloc+0x1c8c>
    3b62:	717000ef          	jal	ra,4a78 <open>
    3b66:	8baa                	mv	s7,a0
  nc = np = 0;
    3b68:	8ace                	mv	s5,s3
  if(fd < 0){
    3b6a:	02054363          	bltz	a0,3b90 <sharedfd+0xf4>
    3b6e:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    3b72:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3b76:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3b7a:	4629                	li	a2,10
    3b7c:	fa040593          	addi	a1,s0,-96
    3b80:	855e                	mv	a0,s7
    3b82:	6cf000ef          	jal	ra,4a50 <read>
    3b86:	02a05b63          	blez	a0,3bbc <sharedfd+0x120>
    3b8a:	fa040793          	addi	a5,s0,-96
    3b8e:	a839                	j	3bac <sharedfd+0x110>
    printf("%s: cannot open sharedfd for reading\n", s);
    3b90:	85d2                	mv	a1,s4
    3b92:	00003517          	auipc	a0,0x3
    3b96:	06650513          	addi	a0,a0,102 # 6bf8 <malloc+0x1ce4>
    3b9a:	2c0010ef          	jal	ra,4e5a <printf>
    exit(1);
    3b9e:	4505                	li	a0,1
    3ba0:	699000ef          	jal	ra,4a38 <exit>
        nc++;
    3ba4:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    3ba6:	0785                	addi	a5,a5,1
    3ba8:	fd2789e3          	beq	a5,s2,3b7a <sharedfd+0xde>
      if(buf[i] == 'c')
    3bac:	0007c703          	lbu	a4,0(a5)
    3bb0:	fe970ae3          	beq	a4,s1,3ba4 <sharedfd+0x108>
      if(buf[i] == 'p')
    3bb4:	ff6719e3          	bne	a4,s6,3ba6 <sharedfd+0x10a>
        np++;
    3bb8:	2a85                	addiw	s5,s5,1
    3bba:	b7f5                	j	3ba6 <sharedfd+0x10a>
  close(fd);
    3bbc:	855e                	mv	a0,s7
    3bbe:	6a3000ef          	jal	ra,4a60 <close>
  unlink("sharedfd");
    3bc2:	00003517          	auipc	a0,0x3
    3bc6:	fde50513          	addi	a0,a0,-34 # 6ba0 <malloc+0x1c8c>
    3bca:	6bf000ef          	jal	ra,4a88 <unlink>
  if(nc == N*SZ && np == N*SZ){
    3bce:	6789                	lui	a5,0x2
    3bd0:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0xcc>
    3bd4:	00f99763          	bne	s3,a5,3be2 <sharedfd+0x146>
    3bd8:	6789                	lui	a5,0x2
    3bda:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0xcc>
    3bde:	00fa8c63          	beq	s5,a5,3bf6 <sharedfd+0x15a>
    printf("%s: nc/np test fails\n", s);
    3be2:	85d2                	mv	a1,s4
    3be4:	00003517          	auipc	a0,0x3
    3be8:	03c50513          	addi	a0,a0,60 # 6c20 <malloc+0x1d0c>
    3bec:	26e010ef          	jal	ra,4e5a <printf>
    exit(1);
    3bf0:	4505                	li	a0,1
    3bf2:	647000ef          	jal	ra,4a38 <exit>
    exit(0);
    3bf6:	4501                	li	a0,0
    3bf8:	641000ef          	jal	ra,4a38 <exit>

0000000000003bfc <fourfiles>:
{
    3bfc:	7171                	addi	sp,sp,-176
    3bfe:	f506                	sd	ra,168(sp)
    3c00:	f122                	sd	s0,160(sp)
    3c02:	ed26                	sd	s1,152(sp)
    3c04:	e94a                	sd	s2,144(sp)
    3c06:	e54e                	sd	s3,136(sp)
    3c08:	e152                	sd	s4,128(sp)
    3c0a:	fcd6                	sd	s5,120(sp)
    3c0c:	f8da                	sd	s6,112(sp)
    3c0e:	f4de                	sd	s7,104(sp)
    3c10:	f0e2                	sd	s8,96(sp)
    3c12:	ece6                	sd	s9,88(sp)
    3c14:	e8ea                	sd	s10,80(sp)
    3c16:	e4ee                	sd	s11,72(sp)
    3c18:	1900                	addi	s0,sp,176
    3c1a:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    3c1e:	00001797          	auipc	a5,0x1
    3c22:	3d278793          	addi	a5,a5,978 # 4ff0 <malloc+0xdc>
    3c26:	f6f43823          	sd	a5,-144(s0)
    3c2a:	00001797          	auipc	a5,0x1
    3c2e:	3ce78793          	addi	a5,a5,974 # 4ff8 <malloc+0xe4>
    3c32:	f6f43c23          	sd	a5,-136(s0)
    3c36:	00001797          	auipc	a5,0x1
    3c3a:	3ca78793          	addi	a5,a5,970 # 5000 <malloc+0xec>
    3c3e:	f8f43023          	sd	a5,-128(s0)
    3c42:	00001797          	auipc	a5,0x1
    3c46:	3c678793          	addi	a5,a5,966 # 5008 <malloc+0xf4>
    3c4a:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3c4e:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3c52:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    3c54:	4481                	li	s1,0
    3c56:	4a11                	li	s4,4
    fname = names[pi];
    3c58:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3c5c:	854e                	mv	a0,s3
    3c5e:	62b000ef          	jal	ra,4a88 <unlink>
    pid = fork();
    3c62:	5cf000ef          	jal	ra,4a30 <fork>
    if(pid < 0){
    3c66:	04054263          	bltz	a0,3caa <fourfiles+0xae>
    if(pid == 0){
    3c6a:	c939                	beqz	a0,3cc0 <fourfiles+0xc4>
  for(pi = 0; pi < NCHILD; pi++){
    3c6c:	2485                	addiw	s1,s1,1
    3c6e:	0921                	addi	s2,s2,8
    3c70:	ff4494e3          	bne	s1,s4,3c58 <fourfiles+0x5c>
    3c74:	4491                	li	s1,4
    wait(&xstatus);
    3c76:	f6c40513          	addi	a0,s0,-148
    3c7a:	5c7000ef          	jal	ra,4a40 <wait>
    if(xstatus != 0)
    3c7e:	f6c42b03          	lw	s6,-148(s0)
    3c82:	0a0b1a63          	bnez	s6,3d36 <fourfiles+0x13a>
  for(pi = 0; pi < NCHILD; pi++){
    3c86:	34fd                	addiw	s1,s1,-1
    3c88:	f4fd                	bnez	s1,3c76 <fourfiles+0x7a>
    3c8a:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3c8e:	00008a17          	auipc	s4,0x8
    3c92:	feaa0a13          	addi	s4,s4,-22 # bc78 <buf>
    3c96:	00008a97          	auipc	s5,0x8
    3c9a:	fe3a8a93          	addi	s5,s5,-29 # bc79 <buf+0x1>
    if(total != N*SZ){
    3c9e:	6d85                	lui	s11,0x1
    3ca0:	770d8d93          	addi	s11,s11,1904 # 1770 <forkfork+0x48>
  for(i = 0; i < NCHILD; i++){
    3ca4:	03400d13          	li	s10,52
    3ca8:	a8dd                	j	3d9e <fourfiles+0x1a2>
      printf("%s: fork failed\n", s);
    3caa:	f5843583          	ld	a1,-168(s0)
    3cae:	00002517          	auipc	a0,0x2
    3cb2:	c2a50513          	addi	a0,a0,-982 # 58d8 <malloc+0x9c4>
    3cb6:	1a4010ef          	jal	ra,4e5a <printf>
      exit(1);
    3cba:	4505                	li	a0,1
    3cbc:	57d000ef          	jal	ra,4a38 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3cc0:	20200593          	li	a1,514
    3cc4:	854e                	mv	a0,s3
    3cc6:	5b3000ef          	jal	ra,4a78 <open>
    3cca:	892a                	mv	s2,a0
      if(fd < 0){
    3ccc:	04054163          	bltz	a0,3d0e <fourfiles+0x112>
      memset(buf, '0'+pi, SZ);
    3cd0:	1f400613          	li	a2,500
    3cd4:	0304859b          	addiw	a1,s1,48
    3cd8:	00008517          	auipc	a0,0x8
    3cdc:	fa050513          	addi	a0,a0,-96 # bc78 <buf>
    3ce0:	371000ef          	jal	ra,4850 <memset>
    3ce4:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3ce6:	00008997          	auipc	s3,0x8
    3cea:	f9298993          	addi	s3,s3,-110 # bc78 <buf>
    3cee:	1f400613          	li	a2,500
    3cf2:	85ce                	mv	a1,s3
    3cf4:	854a                	mv	a0,s2
    3cf6:	563000ef          	jal	ra,4a58 <write>
    3cfa:	85aa                	mv	a1,a0
    3cfc:	1f400793          	li	a5,500
    3d00:	02f51263          	bne	a0,a5,3d24 <fourfiles+0x128>
      for(i = 0; i < N; i++){
    3d04:	34fd                	addiw	s1,s1,-1
    3d06:	f4e5                	bnez	s1,3cee <fourfiles+0xf2>
      exit(0);
    3d08:	4501                	li	a0,0
    3d0a:	52f000ef          	jal	ra,4a38 <exit>
        printf("%s: create failed\n", s);
    3d0e:	f5843583          	ld	a1,-168(s0)
    3d12:	00002517          	auipc	a0,0x2
    3d16:	c5e50513          	addi	a0,a0,-930 # 5970 <malloc+0xa5c>
    3d1a:	140010ef          	jal	ra,4e5a <printf>
        exit(1);
    3d1e:	4505                	li	a0,1
    3d20:	519000ef          	jal	ra,4a38 <exit>
          printf("write failed %d\n", n);
    3d24:	00003517          	auipc	a0,0x3
    3d28:	f1450513          	addi	a0,a0,-236 # 6c38 <malloc+0x1d24>
    3d2c:	12e010ef          	jal	ra,4e5a <printf>
          exit(1);
    3d30:	4505                	li	a0,1
    3d32:	507000ef          	jal	ra,4a38 <exit>
      exit(xstatus);
    3d36:	855a                	mv	a0,s6
    3d38:	501000ef          	jal	ra,4a38 <exit>
          printf("%s: wrong char\n", s);
    3d3c:	f5843583          	ld	a1,-168(s0)
    3d40:	00003517          	auipc	a0,0x3
    3d44:	f1050513          	addi	a0,a0,-240 # 6c50 <malloc+0x1d3c>
    3d48:	112010ef          	jal	ra,4e5a <printf>
          exit(1);
    3d4c:	4505                	li	a0,1
    3d4e:	4eb000ef          	jal	ra,4a38 <exit>
      total += n;
    3d52:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3d56:	660d                	lui	a2,0x3
    3d58:	85d2                	mv	a1,s4
    3d5a:	854e                	mv	a0,s3
    3d5c:	4f5000ef          	jal	ra,4a50 <read>
    3d60:	02a05363          	blez	a0,3d86 <fourfiles+0x18a>
    3d64:	00008797          	auipc	a5,0x8
    3d68:	f1478793          	addi	a5,a5,-236 # bc78 <buf>
    3d6c:	fff5069b          	addiw	a3,a0,-1
    3d70:	1682                	slli	a3,a3,0x20
    3d72:	9281                	srli	a3,a3,0x20
    3d74:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    3d76:	0007c703          	lbu	a4,0(a5)
    3d7a:	fc9711e3          	bne	a4,s1,3d3c <fourfiles+0x140>
      for(j = 0; j < n; j++){
    3d7e:	0785                	addi	a5,a5,1
    3d80:	fed79be3          	bne	a5,a3,3d76 <fourfiles+0x17a>
    3d84:	b7f9                	j	3d52 <fourfiles+0x156>
    close(fd);
    3d86:	854e                	mv	a0,s3
    3d88:	4d9000ef          	jal	ra,4a60 <close>
    if(total != N*SZ){
    3d8c:	03b91463          	bne	s2,s11,3db4 <fourfiles+0x1b8>
    unlink(fname);
    3d90:	8566                	mv	a0,s9
    3d92:	4f7000ef          	jal	ra,4a88 <unlink>
  for(i = 0; i < NCHILD; i++){
    3d96:	0c21                	addi	s8,s8,8
    3d98:	2b85                	addiw	s7,s7,1
    3d9a:	03ab8763          	beq	s7,s10,3dc8 <fourfiles+0x1cc>
    fname = names[i];
    3d9e:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    3da2:	4581                	li	a1,0
    3da4:	8566                	mv	a0,s9
    3da6:	4d3000ef          	jal	ra,4a78 <open>
    3daa:	89aa                	mv	s3,a0
    total = 0;
    3dac:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    3dae:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3db2:	b755                	j	3d56 <fourfiles+0x15a>
      printf("wrong length %d\n", total);
    3db4:	85ca                	mv	a1,s2
    3db6:	00003517          	auipc	a0,0x3
    3dba:	eaa50513          	addi	a0,a0,-342 # 6c60 <malloc+0x1d4c>
    3dbe:	09c010ef          	jal	ra,4e5a <printf>
      exit(1);
    3dc2:	4505                	li	a0,1
    3dc4:	475000ef          	jal	ra,4a38 <exit>
}
    3dc8:	70aa                	ld	ra,168(sp)
    3dca:	740a                	ld	s0,160(sp)
    3dcc:	64ea                	ld	s1,152(sp)
    3dce:	694a                	ld	s2,144(sp)
    3dd0:	69aa                	ld	s3,136(sp)
    3dd2:	6a0a                	ld	s4,128(sp)
    3dd4:	7ae6                	ld	s5,120(sp)
    3dd6:	7b46                	ld	s6,112(sp)
    3dd8:	7ba6                	ld	s7,104(sp)
    3dda:	7c06                	ld	s8,96(sp)
    3ddc:	6ce6                	ld	s9,88(sp)
    3dde:	6d46                	ld	s10,80(sp)
    3de0:	6da6                	ld	s11,72(sp)
    3de2:	614d                	addi	sp,sp,176
    3de4:	8082                	ret

0000000000003de6 <concreate>:
{
    3de6:	7135                	addi	sp,sp,-160
    3de8:	ed06                	sd	ra,152(sp)
    3dea:	e922                	sd	s0,144(sp)
    3dec:	e526                	sd	s1,136(sp)
    3dee:	e14a                	sd	s2,128(sp)
    3df0:	fcce                	sd	s3,120(sp)
    3df2:	f8d2                	sd	s4,112(sp)
    3df4:	f4d6                	sd	s5,104(sp)
    3df6:	f0da                	sd	s6,96(sp)
    3df8:	ecde                	sd	s7,88(sp)
    3dfa:	1100                	addi	s0,sp,160
    3dfc:	89aa                	mv	s3,a0
  file[0] = 'C';
    3dfe:	04300793          	li	a5,67
    3e02:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    3e06:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    3e0a:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    3e0c:	4b0d                	li	s6,3
    3e0e:	4a85                	li	s5,1
      link("C0", file);
    3e10:	00003b97          	auipc	s7,0x3
    3e14:	e68b8b93          	addi	s7,s7,-408 # 6c78 <malloc+0x1d64>
  for(i = 0; i < N; i++){
    3e18:	02800a13          	li	s4,40
    3e1c:	a415                	j	4040 <concreate+0x25a>
      link("C0", file);
    3e1e:	fa840593          	addi	a1,s0,-88
    3e22:	855e                	mv	a0,s7
    3e24:	475000ef          	jal	ra,4a98 <link>
    if(pid == 0) {
    3e28:	a409                	j	402a <concreate+0x244>
    } else if(pid == 0 && (i % 5) == 1){
    3e2a:	4795                	li	a5,5
    3e2c:	02f9693b          	remw	s2,s2,a5
    3e30:	4785                	li	a5,1
    3e32:	02f90563          	beq	s2,a5,3e5c <concreate+0x76>
      fd = open(file, O_CREATE | O_RDWR);
    3e36:	20200593          	li	a1,514
    3e3a:	fa840513          	addi	a0,s0,-88
    3e3e:	43b000ef          	jal	ra,4a78 <open>
      if(fd < 0){
    3e42:	1c055f63          	bgez	a0,4020 <concreate+0x23a>
        printf("concreate create %s failed\n", file);
    3e46:	fa840593          	addi	a1,s0,-88
    3e4a:	00003517          	auipc	a0,0x3
    3e4e:	e3650513          	addi	a0,a0,-458 # 6c80 <malloc+0x1d6c>
    3e52:	008010ef          	jal	ra,4e5a <printf>
        exit(1);
    3e56:	4505                	li	a0,1
    3e58:	3e1000ef          	jal	ra,4a38 <exit>
      link("C0", file);
    3e5c:	fa840593          	addi	a1,s0,-88
    3e60:	00003517          	auipc	a0,0x3
    3e64:	e1850513          	addi	a0,a0,-488 # 6c78 <malloc+0x1d64>
    3e68:	431000ef          	jal	ra,4a98 <link>
      exit(0);
    3e6c:	4501                	li	a0,0
    3e6e:	3cb000ef          	jal	ra,4a38 <exit>
        exit(1);
    3e72:	4505                	li	a0,1
    3e74:	3c5000ef          	jal	ra,4a38 <exit>
  memset(fa, 0, sizeof(fa));
    3e78:	02800613          	li	a2,40
    3e7c:	4581                	li	a1,0
    3e7e:	f8040513          	addi	a0,s0,-128
    3e82:	1cf000ef          	jal	ra,4850 <memset>
  fd = open(".", 0);
    3e86:	4581                	li	a1,0
    3e88:	00002517          	auipc	a0,0x2
    3e8c:	8a850513          	addi	a0,a0,-1880 # 5730 <malloc+0x81c>
    3e90:	3e9000ef          	jal	ra,4a78 <open>
    3e94:	892a                	mv	s2,a0
  n = 0;
    3e96:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3e98:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    3e9c:	02700b13          	li	s6,39
      fa[i] = 1;
    3ea0:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    3ea2:	4641                	li	a2,16
    3ea4:	f7040593          	addi	a1,s0,-144
    3ea8:	854a                	mv	a0,s2
    3eaa:	3a7000ef          	jal	ra,4a50 <read>
    3eae:	06a05963          	blez	a0,3f20 <concreate+0x13a>
    if(de.inum == 0)
    3eb2:	f7045783          	lhu	a5,-144(s0)
    3eb6:	d7f5                	beqz	a5,3ea2 <concreate+0xbc>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3eb8:	f7244783          	lbu	a5,-142(s0)
    3ebc:	ff4793e3          	bne	a5,s4,3ea2 <concreate+0xbc>
    3ec0:	f7444783          	lbu	a5,-140(s0)
    3ec4:	fff9                	bnez	a5,3ea2 <concreate+0xbc>
      i = de.name[1] - '0';
    3ec6:	f7344783          	lbu	a5,-141(s0)
    3eca:	fd07879b          	addiw	a5,a5,-48
    3ece:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    3ed2:	00eb6f63          	bltu	s6,a4,3ef0 <concreate+0x10a>
      if(fa[i]){
    3ed6:	fb040793          	addi	a5,s0,-80
    3eda:	97ba                	add	a5,a5,a4
    3edc:	fd07c783          	lbu	a5,-48(a5)
    3ee0:	e785                	bnez	a5,3f08 <concreate+0x122>
      fa[i] = 1;
    3ee2:	fb040793          	addi	a5,s0,-80
    3ee6:	973e                	add	a4,a4,a5
    3ee8:	fd770823          	sb	s7,-48(a4) # fd0 <bigdir+0x130>
      n++;
    3eec:	2a85                	addiw	s5,s5,1
    3eee:	bf55                	j	3ea2 <concreate+0xbc>
        printf("%s: concreate weird file %s\n", s, de.name);
    3ef0:	f7240613          	addi	a2,s0,-142
    3ef4:	85ce                	mv	a1,s3
    3ef6:	00003517          	auipc	a0,0x3
    3efa:	daa50513          	addi	a0,a0,-598 # 6ca0 <malloc+0x1d8c>
    3efe:	75d000ef          	jal	ra,4e5a <printf>
        exit(1);
    3f02:	4505                	li	a0,1
    3f04:	335000ef          	jal	ra,4a38 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    3f08:	f7240613          	addi	a2,s0,-142
    3f0c:	85ce                	mv	a1,s3
    3f0e:	00003517          	auipc	a0,0x3
    3f12:	db250513          	addi	a0,a0,-590 # 6cc0 <malloc+0x1dac>
    3f16:	745000ef          	jal	ra,4e5a <printf>
        exit(1);
    3f1a:	4505                	li	a0,1
    3f1c:	31d000ef          	jal	ra,4a38 <exit>
  close(fd);
    3f20:	854a                	mv	a0,s2
    3f22:	33f000ef          	jal	ra,4a60 <close>
  if(n != N){
    3f26:	02800793          	li	a5,40
    3f2a:	00fa9763          	bne	s5,a5,3f38 <concreate+0x152>
    if(((i % 3) == 0 && pid == 0) ||
    3f2e:	4a8d                	li	s5,3
    3f30:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    3f32:	02800a13          	li	s4,40
    3f36:	a079                	j	3fc4 <concreate+0x1de>
    printf("%s: concreate not enough files in directory listing\n", s);
    3f38:	85ce                	mv	a1,s3
    3f3a:	00003517          	auipc	a0,0x3
    3f3e:	dae50513          	addi	a0,a0,-594 # 6ce8 <malloc+0x1dd4>
    3f42:	719000ef          	jal	ra,4e5a <printf>
    exit(1);
    3f46:	4505                	li	a0,1
    3f48:	2f1000ef          	jal	ra,4a38 <exit>
      printf("%s: fork failed\n", s);
    3f4c:	85ce                	mv	a1,s3
    3f4e:	00002517          	auipc	a0,0x2
    3f52:	98a50513          	addi	a0,a0,-1654 # 58d8 <malloc+0x9c4>
    3f56:	705000ef          	jal	ra,4e5a <printf>
      exit(1);
    3f5a:	4505                	li	a0,1
    3f5c:	2dd000ef          	jal	ra,4a38 <exit>
      close(open(file, 0));
    3f60:	4581                	li	a1,0
    3f62:	fa840513          	addi	a0,s0,-88
    3f66:	313000ef          	jal	ra,4a78 <open>
    3f6a:	2f7000ef          	jal	ra,4a60 <close>
      close(open(file, 0));
    3f6e:	4581                	li	a1,0
    3f70:	fa840513          	addi	a0,s0,-88
    3f74:	305000ef          	jal	ra,4a78 <open>
    3f78:	2e9000ef          	jal	ra,4a60 <close>
      close(open(file, 0));
    3f7c:	4581                	li	a1,0
    3f7e:	fa840513          	addi	a0,s0,-88
    3f82:	2f7000ef          	jal	ra,4a78 <open>
    3f86:	2db000ef          	jal	ra,4a60 <close>
      close(open(file, 0));
    3f8a:	4581                	li	a1,0
    3f8c:	fa840513          	addi	a0,s0,-88
    3f90:	2e9000ef          	jal	ra,4a78 <open>
    3f94:	2cd000ef          	jal	ra,4a60 <close>
      close(open(file, 0));
    3f98:	4581                	li	a1,0
    3f9a:	fa840513          	addi	a0,s0,-88
    3f9e:	2db000ef          	jal	ra,4a78 <open>
    3fa2:	2bf000ef          	jal	ra,4a60 <close>
      close(open(file, 0));
    3fa6:	4581                	li	a1,0
    3fa8:	fa840513          	addi	a0,s0,-88
    3fac:	2cd000ef          	jal	ra,4a78 <open>
    3fb0:	2b1000ef          	jal	ra,4a60 <close>
    if(pid == 0)
    3fb4:	06090363          	beqz	s2,401a <concreate+0x234>
      wait(0);
    3fb8:	4501                	li	a0,0
    3fba:	287000ef          	jal	ra,4a40 <wait>
  for(i = 0; i < N; i++){
    3fbe:	2485                	addiw	s1,s1,1
    3fc0:	0b448963          	beq	s1,s4,4072 <concreate+0x28c>
    file[1] = '0' + i;
    3fc4:	0304879b          	addiw	a5,s1,48
    3fc8:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    3fcc:	265000ef          	jal	ra,4a30 <fork>
    3fd0:	892a                	mv	s2,a0
    if(pid < 0){
    3fd2:	f6054de3          	bltz	a0,3f4c <concreate+0x166>
    if(((i % 3) == 0 && pid == 0) ||
    3fd6:	0354e73b          	remw	a4,s1,s5
    3fda:	00a767b3          	or	a5,a4,a0
    3fde:	2781                	sext.w	a5,a5
    3fe0:	d3c1                	beqz	a5,3f60 <concreate+0x17a>
    3fe2:	01671363          	bne	a4,s6,3fe8 <concreate+0x202>
       ((i % 3) == 1 && pid != 0)){
    3fe6:	fd2d                	bnez	a0,3f60 <concreate+0x17a>
      unlink(file);
    3fe8:	fa840513          	addi	a0,s0,-88
    3fec:	29d000ef          	jal	ra,4a88 <unlink>
      unlink(file);
    3ff0:	fa840513          	addi	a0,s0,-88
    3ff4:	295000ef          	jal	ra,4a88 <unlink>
      unlink(file);
    3ff8:	fa840513          	addi	a0,s0,-88
    3ffc:	28d000ef          	jal	ra,4a88 <unlink>
      unlink(file);
    4000:	fa840513          	addi	a0,s0,-88
    4004:	285000ef          	jal	ra,4a88 <unlink>
      unlink(file);
    4008:	fa840513          	addi	a0,s0,-88
    400c:	27d000ef          	jal	ra,4a88 <unlink>
      unlink(file);
    4010:	fa840513          	addi	a0,s0,-88
    4014:	275000ef          	jal	ra,4a88 <unlink>
    4018:	bf71                	j	3fb4 <concreate+0x1ce>
      exit(0);
    401a:	4501                	li	a0,0
    401c:	21d000ef          	jal	ra,4a38 <exit>
      close(fd);
    4020:	241000ef          	jal	ra,4a60 <close>
    if(pid == 0) {
    4024:	b5a1                	j	3e6c <concreate+0x86>
      close(fd);
    4026:	23b000ef          	jal	ra,4a60 <close>
      wait(&xstatus);
    402a:	f6c40513          	addi	a0,s0,-148
    402e:	213000ef          	jal	ra,4a40 <wait>
      if(xstatus != 0)
    4032:	f6c42483          	lw	s1,-148(s0)
    4036:	e2049ee3          	bnez	s1,3e72 <concreate+0x8c>
  for(i = 0; i < N; i++){
    403a:	2905                	addiw	s2,s2,1
    403c:	e3490ee3          	beq	s2,s4,3e78 <concreate+0x92>
    file[1] = '0' + i;
    4040:	0309079b          	addiw	a5,s2,48
    4044:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4048:	fa840513          	addi	a0,s0,-88
    404c:	23d000ef          	jal	ra,4a88 <unlink>
    pid = fork();
    4050:	1e1000ef          	jal	ra,4a30 <fork>
    if(pid && (i % 3) == 1){
    4054:	dc050be3          	beqz	a0,3e2a <concreate+0x44>
    4058:	036967bb          	remw	a5,s2,s6
    405c:	dd5781e3          	beq	a5,s5,3e1e <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4060:	20200593          	li	a1,514
    4064:	fa840513          	addi	a0,s0,-88
    4068:	211000ef          	jal	ra,4a78 <open>
      if(fd < 0){
    406c:	fa055de3          	bgez	a0,4026 <concreate+0x240>
    4070:	bbd9                	j	3e46 <concreate+0x60>
}
    4072:	60ea                	ld	ra,152(sp)
    4074:	644a                	ld	s0,144(sp)
    4076:	64aa                	ld	s1,136(sp)
    4078:	690a                	ld	s2,128(sp)
    407a:	79e6                	ld	s3,120(sp)
    407c:	7a46                	ld	s4,112(sp)
    407e:	7aa6                	ld	s5,104(sp)
    4080:	7b06                	ld	s6,96(sp)
    4082:	6be6                	ld	s7,88(sp)
    4084:	610d                	addi	sp,sp,160
    4086:	8082                	ret

0000000000004088 <bigfile>:
{
    4088:	7139                	addi	sp,sp,-64
    408a:	fc06                	sd	ra,56(sp)
    408c:	f822                	sd	s0,48(sp)
    408e:	f426                	sd	s1,40(sp)
    4090:	f04a                	sd	s2,32(sp)
    4092:	ec4e                	sd	s3,24(sp)
    4094:	e852                	sd	s4,16(sp)
    4096:	e456                	sd	s5,8(sp)
    4098:	0080                	addi	s0,sp,64
    409a:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    409c:	00003517          	auipc	a0,0x3
    40a0:	c8450513          	addi	a0,a0,-892 # 6d20 <malloc+0x1e0c>
    40a4:	1e5000ef          	jal	ra,4a88 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    40a8:	20200593          	li	a1,514
    40ac:	00003517          	auipc	a0,0x3
    40b0:	c7450513          	addi	a0,a0,-908 # 6d20 <malloc+0x1e0c>
    40b4:	1c5000ef          	jal	ra,4a78 <open>
    40b8:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    40ba:	4481                	li	s1,0
    memset(buf, i, SZ);
    40bc:	00008917          	auipc	s2,0x8
    40c0:	bbc90913          	addi	s2,s2,-1092 # bc78 <buf>
  for(i = 0; i < N; i++){
    40c4:	4a51                	li	s4,20
  if(fd < 0){
    40c6:	08054663          	bltz	a0,4152 <bigfile+0xca>
    memset(buf, i, SZ);
    40ca:	25800613          	li	a2,600
    40ce:	85a6                	mv	a1,s1
    40d0:	854a                	mv	a0,s2
    40d2:	77e000ef          	jal	ra,4850 <memset>
    if(write(fd, buf, SZ) != SZ){
    40d6:	25800613          	li	a2,600
    40da:	85ca                	mv	a1,s2
    40dc:	854e                	mv	a0,s3
    40de:	17b000ef          	jal	ra,4a58 <write>
    40e2:	25800793          	li	a5,600
    40e6:	08f51063          	bne	a0,a5,4166 <bigfile+0xde>
  for(i = 0; i < N; i++){
    40ea:	2485                	addiw	s1,s1,1
    40ec:	fd449fe3          	bne	s1,s4,40ca <bigfile+0x42>
  close(fd);
    40f0:	854e                	mv	a0,s3
    40f2:	16f000ef          	jal	ra,4a60 <close>
  fd = open("bigfile.dat", 0);
    40f6:	4581                	li	a1,0
    40f8:	00003517          	auipc	a0,0x3
    40fc:	c2850513          	addi	a0,a0,-984 # 6d20 <malloc+0x1e0c>
    4100:	179000ef          	jal	ra,4a78 <open>
    4104:	8a2a                	mv	s4,a0
  total = 0;
    4106:	4981                	li	s3,0
  for(i = 0; ; i++){
    4108:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    410a:	00008917          	auipc	s2,0x8
    410e:	b6e90913          	addi	s2,s2,-1170 # bc78 <buf>
  if(fd < 0){
    4112:	06054463          	bltz	a0,417a <bigfile+0xf2>
    cc = read(fd, buf, SZ/2);
    4116:	12c00613          	li	a2,300
    411a:	85ca                	mv	a1,s2
    411c:	8552                	mv	a0,s4
    411e:	133000ef          	jal	ra,4a50 <read>
    if(cc < 0){
    4122:	06054663          	bltz	a0,418e <bigfile+0x106>
    if(cc == 0)
    4126:	c155                	beqz	a0,41ca <bigfile+0x142>
    if(cc != SZ/2){
    4128:	12c00793          	li	a5,300
    412c:	06f51b63          	bne	a0,a5,41a2 <bigfile+0x11a>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4130:	01f4d79b          	srliw	a5,s1,0x1f
    4134:	9fa5                	addw	a5,a5,s1
    4136:	4017d79b          	sraiw	a5,a5,0x1
    413a:	00094703          	lbu	a4,0(s2)
    413e:	06f71c63          	bne	a4,a5,41b6 <bigfile+0x12e>
    4142:	12b94703          	lbu	a4,299(s2)
    4146:	06f71863          	bne	a4,a5,41b6 <bigfile+0x12e>
    total += cc;
    414a:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    414e:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4150:	b7d9                	j	4116 <bigfile+0x8e>
    printf("%s: cannot create bigfile", s);
    4152:	85d6                	mv	a1,s5
    4154:	00003517          	auipc	a0,0x3
    4158:	bdc50513          	addi	a0,a0,-1060 # 6d30 <malloc+0x1e1c>
    415c:	4ff000ef          	jal	ra,4e5a <printf>
    exit(1);
    4160:	4505                	li	a0,1
    4162:	0d7000ef          	jal	ra,4a38 <exit>
      printf("%s: write bigfile failed\n", s);
    4166:	85d6                	mv	a1,s5
    4168:	00003517          	auipc	a0,0x3
    416c:	be850513          	addi	a0,a0,-1048 # 6d50 <malloc+0x1e3c>
    4170:	4eb000ef          	jal	ra,4e5a <printf>
      exit(1);
    4174:	4505                	li	a0,1
    4176:	0c3000ef          	jal	ra,4a38 <exit>
    printf("%s: cannot open bigfile\n", s);
    417a:	85d6                	mv	a1,s5
    417c:	00003517          	auipc	a0,0x3
    4180:	bf450513          	addi	a0,a0,-1036 # 6d70 <malloc+0x1e5c>
    4184:	4d7000ef          	jal	ra,4e5a <printf>
    exit(1);
    4188:	4505                	li	a0,1
    418a:	0af000ef          	jal	ra,4a38 <exit>
      printf("%s: read bigfile failed\n", s);
    418e:	85d6                	mv	a1,s5
    4190:	00003517          	auipc	a0,0x3
    4194:	c0050513          	addi	a0,a0,-1024 # 6d90 <malloc+0x1e7c>
    4198:	4c3000ef          	jal	ra,4e5a <printf>
      exit(1);
    419c:	4505                	li	a0,1
    419e:	09b000ef          	jal	ra,4a38 <exit>
      printf("%s: short read bigfile\n", s);
    41a2:	85d6                	mv	a1,s5
    41a4:	00003517          	auipc	a0,0x3
    41a8:	c0c50513          	addi	a0,a0,-1012 # 6db0 <malloc+0x1e9c>
    41ac:	4af000ef          	jal	ra,4e5a <printf>
      exit(1);
    41b0:	4505                	li	a0,1
    41b2:	087000ef          	jal	ra,4a38 <exit>
      printf("%s: read bigfile wrong data\n", s);
    41b6:	85d6                	mv	a1,s5
    41b8:	00003517          	auipc	a0,0x3
    41bc:	c1050513          	addi	a0,a0,-1008 # 6dc8 <malloc+0x1eb4>
    41c0:	49b000ef          	jal	ra,4e5a <printf>
      exit(1);
    41c4:	4505                	li	a0,1
    41c6:	073000ef          	jal	ra,4a38 <exit>
  close(fd);
    41ca:	8552                	mv	a0,s4
    41cc:	095000ef          	jal	ra,4a60 <close>
  if(total != N*SZ){
    41d0:	678d                	lui	a5,0x3
    41d2:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x354>
    41d6:	02f99163          	bne	s3,a5,41f8 <bigfile+0x170>
  unlink("bigfile.dat");
    41da:	00003517          	auipc	a0,0x3
    41de:	b4650513          	addi	a0,a0,-1210 # 6d20 <malloc+0x1e0c>
    41e2:	0a7000ef          	jal	ra,4a88 <unlink>
}
    41e6:	70e2                	ld	ra,56(sp)
    41e8:	7442                	ld	s0,48(sp)
    41ea:	74a2                	ld	s1,40(sp)
    41ec:	7902                	ld	s2,32(sp)
    41ee:	69e2                	ld	s3,24(sp)
    41f0:	6a42                	ld	s4,16(sp)
    41f2:	6aa2                	ld	s5,8(sp)
    41f4:	6121                	addi	sp,sp,64
    41f6:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    41f8:	85d6                	mv	a1,s5
    41fa:	00003517          	auipc	a0,0x3
    41fe:	bee50513          	addi	a0,a0,-1042 # 6de8 <malloc+0x1ed4>
    4202:	459000ef          	jal	ra,4e5a <printf>
    exit(1);
    4206:	4505                	li	a0,1
    4208:	031000ef          	jal	ra,4a38 <exit>

000000000000420c <bigargtest>:
{
    420c:	7121                	addi	sp,sp,-448
    420e:	ff06                	sd	ra,440(sp)
    4210:	fb22                	sd	s0,432(sp)
    4212:	f726                	sd	s1,424(sp)
    4214:	0380                	addi	s0,sp,448
    4216:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    4218:	00003517          	auipc	a0,0x3
    421c:	bf050513          	addi	a0,a0,-1040 # 6e08 <malloc+0x1ef4>
    4220:	069000ef          	jal	ra,4a88 <unlink>
  pid = fork();
    4224:	00d000ef          	jal	ra,4a30 <fork>
  if(pid == 0){
    4228:	c915                	beqz	a0,425c <bigargtest+0x50>
  } else if(pid < 0){
    422a:	08054a63          	bltz	a0,42be <bigargtest+0xb2>
  wait(&xstatus);
    422e:	fdc40513          	addi	a0,s0,-36
    4232:	00f000ef          	jal	ra,4a40 <wait>
  if(xstatus != 0)
    4236:	fdc42503          	lw	a0,-36(s0)
    423a:	ed41                	bnez	a0,42d2 <bigargtest+0xc6>
  fd = open("bigarg-ok", 0);
    423c:	4581                	li	a1,0
    423e:	00003517          	auipc	a0,0x3
    4242:	bca50513          	addi	a0,a0,-1078 # 6e08 <malloc+0x1ef4>
    4246:	033000ef          	jal	ra,4a78 <open>
  if(fd < 0){
    424a:	08054663          	bltz	a0,42d6 <bigargtest+0xca>
  close(fd);
    424e:	013000ef          	jal	ra,4a60 <close>
}
    4252:	70fa                	ld	ra,440(sp)
    4254:	745a                	ld	s0,432(sp)
    4256:	74ba                	ld	s1,424(sp)
    4258:	6139                	addi	sp,sp,448
    425a:	8082                	ret
    memset(big, ' ', sizeof(big));
    425c:	19000613          	li	a2,400
    4260:	02000593          	li	a1,32
    4264:	e4840513          	addi	a0,s0,-440
    4268:	5e8000ef          	jal	ra,4850 <memset>
    big[sizeof(big)-1] = '\0';
    426c:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    4270:	00004797          	auipc	a5,0x4
    4274:	1f078793          	addi	a5,a5,496 # 8460 <args.1>
    4278:	00004697          	auipc	a3,0x4
    427c:	2e068693          	addi	a3,a3,736 # 8558 <args.1+0xf8>
      args[i] = big;
    4280:	e4840713          	addi	a4,s0,-440
    4284:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    4286:	07a1                	addi	a5,a5,8
    4288:	fed79ee3          	bne	a5,a3,4284 <bigargtest+0x78>
    args[MAXARG-1] = 0;
    428c:	00004597          	auipc	a1,0x4
    4290:	1d458593          	addi	a1,a1,468 # 8460 <args.1>
    4294:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    4298:	00001517          	auipc	a0,0x1
    429c:	db050513          	addi	a0,a0,-592 # 5048 <malloc+0x134>
    42a0:	7d0000ef          	jal	ra,4a70 <exec>
    fd = open("bigarg-ok", O_CREATE);
    42a4:	20000593          	li	a1,512
    42a8:	00003517          	auipc	a0,0x3
    42ac:	b6050513          	addi	a0,a0,-1184 # 6e08 <malloc+0x1ef4>
    42b0:	7c8000ef          	jal	ra,4a78 <open>
    close(fd);
    42b4:	7ac000ef          	jal	ra,4a60 <close>
    exit(0);
    42b8:	4501                	li	a0,0
    42ba:	77e000ef          	jal	ra,4a38 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    42be:	85a6                	mv	a1,s1
    42c0:	00003517          	auipc	a0,0x3
    42c4:	b5850513          	addi	a0,a0,-1192 # 6e18 <malloc+0x1f04>
    42c8:	393000ef          	jal	ra,4e5a <printf>
    exit(1);
    42cc:	4505                	li	a0,1
    42ce:	76a000ef          	jal	ra,4a38 <exit>
    exit(xstatus);
    42d2:	766000ef          	jal	ra,4a38 <exit>
    printf("%s: bigarg test failed!\n", s);
    42d6:	85a6                	mv	a1,s1
    42d8:	00003517          	auipc	a0,0x3
    42dc:	b6050513          	addi	a0,a0,-1184 # 6e38 <malloc+0x1f24>
    42e0:	37b000ef          	jal	ra,4e5a <printf>
    exit(1);
    42e4:	4505                	li	a0,1
    42e6:	752000ef          	jal	ra,4a38 <exit>

00000000000042ea <fsfull>:
{
    42ea:	7171                	addi	sp,sp,-176
    42ec:	f506                	sd	ra,168(sp)
    42ee:	f122                	sd	s0,160(sp)
    42f0:	ed26                	sd	s1,152(sp)
    42f2:	e94a                	sd	s2,144(sp)
    42f4:	e54e                	sd	s3,136(sp)
    42f6:	e152                	sd	s4,128(sp)
    42f8:	fcd6                	sd	s5,120(sp)
    42fa:	f8da                	sd	s6,112(sp)
    42fc:	f4de                	sd	s7,104(sp)
    42fe:	f0e2                	sd	s8,96(sp)
    4300:	ece6                	sd	s9,88(sp)
    4302:	e8ea                	sd	s10,80(sp)
    4304:	e4ee                	sd	s11,72(sp)
    4306:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4308:	00003517          	auipc	a0,0x3
    430c:	b5050513          	addi	a0,a0,-1200 # 6e58 <malloc+0x1f44>
    4310:	34b000ef          	jal	ra,4e5a <printf>
  for(nfiles = 0; ; nfiles++){
    4314:	4481                	li	s1,0
    name[0] = 'f';
    4316:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    431a:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    431e:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4322:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4324:	00003c97          	auipc	s9,0x3
    4328:	b44c8c93          	addi	s9,s9,-1212 # 6e68 <malloc+0x1f54>
    int total = 0;
    432c:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    432e:	00008a17          	auipc	s4,0x8
    4332:	94aa0a13          	addi	s4,s4,-1718 # bc78 <buf>
    name[0] = 'f';
    4336:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    433a:	0384c7bb          	divw	a5,s1,s8
    433e:	0307879b          	addiw	a5,a5,48
    4342:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4346:	0384e7bb          	remw	a5,s1,s8
    434a:	0377c7bb          	divw	a5,a5,s7
    434e:	0307879b          	addiw	a5,a5,48
    4352:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4356:	0374e7bb          	remw	a5,s1,s7
    435a:	0367c7bb          	divw	a5,a5,s6
    435e:	0307879b          	addiw	a5,a5,48
    4362:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4366:	0364e7bb          	remw	a5,s1,s6
    436a:	0307879b          	addiw	a5,a5,48
    436e:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4372:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4376:	f5040593          	addi	a1,s0,-176
    437a:	8566                	mv	a0,s9
    437c:	2df000ef          	jal	ra,4e5a <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4380:	20200593          	li	a1,514
    4384:	f5040513          	addi	a0,s0,-176
    4388:	6f0000ef          	jal	ra,4a78 <open>
    438c:	892a                	mv	s2,a0
    if(fd < 0){
    438e:	0a055063          	bgez	a0,442e <fsfull+0x144>
      printf("open %s failed\n", name);
    4392:	f5040593          	addi	a1,s0,-176
    4396:	00003517          	auipc	a0,0x3
    439a:	ae250513          	addi	a0,a0,-1310 # 6e78 <malloc+0x1f64>
    439e:	2bd000ef          	jal	ra,4e5a <printf>
  while(nfiles >= 0){
    43a2:	0604c163          	bltz	s1,4404 <fsfull+0x11a>
    name[0] = 'f';
    43a6:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    43aa:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    43ae:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    43b2:	4929                	li	s2,10
  while(nfiles >= 0){
    43b4:	5afd                	li	s5,-1
    name[0] = 'f';
    43b6:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    43ba:	0344c7bb          	divw	a5,s1,s4
    43be:	0307879b          	addiw	a5,a5,48
    43c2:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    43c6:	0344e7bb          	remw	a5,s1,s4
    43ca:	0337c7bb          	divw	a5,a5,s3
    43ce:	0307879b          	addiw	a5,a5,48
    43d2:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    43d6:	0334e7bb          	remw	a5,s1,s3
    43da:	0327c7bb          	divw	a5,a5,s2
    43de:	0307879b          	addiw	a5,a5,48
    43e2:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    43e6:	0324e7bb          	remw	a5,s1,s2
    43ea:	0307879b          	addiw	a5,a5,48
    43ee:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    43f2:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    43f6:	f5040513          	addi	a0,s0,-176
    43fa:	68e000ef          	jal	ra,4a88 <unlink>
    nfiles--;
    43fe:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4400:	fb549be3          	bne	s1,s5,43b6 <fsfull+0xcc>
  printf("fsfull test finished\n");
    4404:	00003517          	auipc	a0,0x3
    4408:	a9450513          	addi	a0,a0,-1388 # 6e98 <malloc+0x1f84>
    440c:	24f000ef          	jal	ra,4e5a <printf>
}
    4410:	70aa                	ld	ra,168(sp)
    4412:	740a                	ld	s0,160(sp)
    4414:	64ea                	ld	s1,152(sp)
    4416:	694a                	ld	s2,144(sp)
    4418:	69aa                	ld	s3,136(sp)
    441a:	6a0a                	ld	s4,128(sp)
    441c:	7ae6                	ld	s5,120(sp)
    441e:	7b46                	ld	s6,112(sp)
    4420:	7ba6                	ld	s7,104(sp)
    4422:	7c06                	ld	s8,96(sp)
    4424:	6ce6                	ld	s9,88(sp)
    4426:	6d46                	ld	s10,80(sp)
    4428:	6da6                	ld	s11,72(sp)
    442a:	614d                	addi	sp,sp,176
    442c:	8082                	ret
    int total = 0;
    442e:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4430:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4434:	40000613          	li	a2,1024
    4438:	85d2                	mv	a1,s4
    443a:	854a                	mv	a0,s2
    443c:	61c000ef          	jal	ra,4a58 <write>
      if(cc < BSIZE)
    4440:	00aad563          	bge	s5,a0,444a <fsfull+0x160>
      total += cc;
    4444:	00a989bb          	addw	s3,s3,a0
    while(1){
    4448:	b7f5                	j	4434 <fsfull+0x14a>
    printf("wrote %d bytes\n", total);
    444a:	85ce                	mv	a1,s3
    444c:	00003517          	auipc	a0,0x3
    4450:	a3c50513          	addi	a0,a0,-1476 # 6e88 <malloc+0x1f74>
    4454:	207000ef          	jal	ra,4e5a <printf>
    close(fd);
    4458:	854a                	mv	a0,s2
    445a:	606000ef          	jal	ra,4a60 <close>
    if(total == 0)
    445e:	f40982e3          	beqz	s3,43a2 <fsfull+0xb8>
  for(nfiles = 0; ; nfiles++){
    4462:	2485                	addiw	s1,s1,1
    4464:	bdc9                	j	4336 <fsfull+0x4c>

0000000000004466 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4466:	7179                	addi	sp,sp,-48
    4468:	f406                	sd	ra,40(sp)
    446a:	f022                	sd	s0,32(sp)
    446c:	ec26                	sd	s1,24(sp)
    446e:	e84a                	sd	s2,16(sp)
    4470:	1800                	addi	s0,sp,48
    4472:	84aa                	mv	s1,a0
    4474:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4476:	00003517          	auipc	a0,0x3
    447a:	a3a50513          	addi	a0,a0,-1478 # 6eb0 <malloc+0x1f9c>
    447e:	1dd000ef          	jal	ra,4e5a <printf>
  if((pid = fork()) < 0) {
    4482:	5ae000ef          	jal	ra,4a30 <fork>
    4486:	02054a63          	bltz	a0,44ba <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    448a:	c129                	beqz	a0,44cc <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    448c:	fdc40513          	addi	a0,s0,-36
    4490:	5b0000ef          	jal	ra,4a40 <wait>
    if(xstatus != 0) 
    4494:	fdc42783          	lw	a5,-36(s0)
    4498:	cf9d                	beqz	a5,44d6 <run+0x70>
      printf("FAILED\n");
    449a:	00003517          	auipc	a0,0x3
    449e:	a3e50513          	addi	a0,a0,-1474 # 6ed8 <malloc+0x1fc4>
    44a2:	1b9000ef          	jal	ra,4e5a <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    44a6:	fdc42503          	lw	a0,-36(s0)
  }
}
    44aa:	00153513          	seqz	a0,a0
    44ae:	70a2                	ld	ra,40(sp)
    44b0:	7402                	ld	s0,32(sp)
    44b2:	64e2                	ld	s1,24(sp)
    44b4:	6942                	ld	s2,16(sp)
    44b6:	6145                	addi	sp,sp,48
    44b8:	8082                	ret
    printf("runtest: fork error\n");
    44ba:	00003517          	auipc	a0,0x3
    44be:	a0650513          	addi	a0,a0,-1530 # 6ec0 <malloc+0x1fac>
    44c2:	199000ef          	jal	ra,4e5a <printf>
    exit(1);
    44c6:	4505                	li	a0,1
    44c8:	570000ef          	jal	ra,4a38 <exit>
    f(s);
    44cc:	854a                	mv	a0,s2
    44ce:	9482                	jalr	s1
    exit(0);
    44d0:	4501                	li	a0,0
    44d2:	566000ef          	jal	ra,4a38 <exit>
      printf("OK\n");
    44d6:	00003517          	auipc	a0,0x3
    44da:	a0a50513          	addi	a0,a0,-1526 # 6ee0 <malloc+0x1fcc>
    44de:	17d000ef          	jal	ra,4e5a <printf>
    44e2:	b7d1                	j	44a6 <run+0x40>

00000000000044e4 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    44e4:	7139                	addi	sp,sp,-64
    44e6:	fc06                	sd	ra,56(sp)
    44e8:	f822                	sd	s0,48(sp)
    44ea:	f426                	sd	s1,40(sp)
    44ec:	f04a                	sd	s2,32(sp)
    44ee:	ec4e                	sd	s3,24(sp)
    44f0:	e852                	sd	s4,16(sp)
    44f2:	e456                	sd	s5,8(sp)
    44f4:	0080                	addi	s0,sp,64
  for (struct test *t = tests; t->s != 0; t++) {
    44f6:	00853903          	ld	s2,8(a0)
    44fa:	04090c63          	beqz	s2,4552 <runtests+0x6e>
    44fe:	84aa                	mv	s1,a0
    4500:	89ae                	mv	s3,a1
    4502:	8a32                	mv	s4,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    4504:	4a89                	li	s5,2
    4506:	a031                	j	4512 <runtests+0x2e>
  for (struct test *t = tests; t->s != 0; t++) {
    4508:	04c1                	addi	s1,s1,16
    450a:	0084b903          	ld	s2,8(s1)
    450e:	02090863          	beqz	s2,453e <runtests+0x5a>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    4512:	00098763          	beqz	s3,4520 <runtests+0x3c>
    4516:	85ce                	mv	a1,s3
    4518:	854a                	mv	a0,s2
    451a:	2e0000ef          	jal	ra,47fa <strcmp>
    451e:	f56d                	bnez	a0,4508 <runtests+0x24>
      if(!run(t->f, t->s)){
    4520:	85ca                	mv	a1,s2
    4522:	6088                	ld	a0,0(s1)
    4524:	f43ff0ef          	jal	ra,4466 <run>
    4528:	f165                	bnez	a0,4508 <runtests+0x24>
        if(continuous != 2){
    452a:	fd5a0fe3          	beq	s4,s5,4508 <runtests+0x24>
          printf("SOME TESTS FAILED\n");
    452e:	00003517          	auipc	a0,0x3
    4532:	9ba50513          	addi	a0,a0,-1606 # 6ee8 <malloc+0x1fd4>
    4536:	125000ef          	jal	ra,4e5a <printf>
          return 1;
    453a:	4505                	li	a0,1
    453c:	a011                	j	4540 <runtests+0x5c>
        }
      }
    }
  }
  return 0;
    453e:	4501                	li	a0,0
}
    4540:	70e2                	ld	ra,56(sp)
    4542:	7442                	ld	s0,48(sp)
    4544:	74a2                	ld	s1,40(sp)
    4546:	7902                	ld	s2,32(sp)
    4548:	69e2                	ld	s3,24(sp)
    454a:	6a42                	ld	s4,16(sp)
    454c:	6aa2                	ld	s5,8(sp)
    454e:	6121                	addi	sp,sp,64
    4550:	8082                	ret
  return 0;
    4552:	4501                	li	a0,0
    4554:	b7f5                	j	4540 <runtests+0x5c>

0000000000004556 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    4556:	7139                	addi	sp,sp,-64
    4558:	fc06                	sd	ra,56(sp)
    455a:	f822                	sd	s0,48(sp)
    455c:	f426                	sd	s1,40(sp)
    455e:	f04a                	sd	s2,32(sp)
    4560:	ec4e                	sd	s3,24(sp)
    4562:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    4564:	fc840513          	addi	a0,s0,-56
    4568:	4e0000ef          	jal	ra,4a48 <pipe>
    456c:	04054b63          	bltz	a0,45c2 <countfree+0x6c>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    4570:	4c0000ef          	jal	ra,4a30 <fork>

  if(pid < 0){
    4574:	06054063          	bltz	a0,45d4 <countfree+0x7e>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4578:	e935                	bnez	a0,45ec <countfree+0x96>
    close(fds[0]);
    457a:	fc842503          	lw	a0,-56(s0)
    457e:	4e2000ef          	jal	ra,4a60 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    4582:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4584:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    4586:	00001997          	auipc	s3,0x1
    458a:	b3298993          	addi	s3,s3,-1230 # 50b8 <malloc+0x1a4>
      uint64 a = (uint64) sbrk(4096);
    458e:	6505                	lui	a0,0x1
    4590:	530000ef          	jal	ra,4ac0 <sbrk>
      if(a == 0xffffffffffffffff){
    4594:	05250963          	beq	a0,s2,45e6 <countfree+0x90>
      *(char *)(a + 4096 - 1) = 1;
    4598:	6785                	lui	a5,0x1
    459a:	953e                	add	a0,a0,a5
    459c:	fe950fa3          	sb	s1,-1(a0) # fff <pgbug+0x29>
      if(write(fds[1], "x", 1) != 1){
    45a0:	8626                	mv	a2,s1
    45a2:	85ce                	mv	a1,s3
    45a4:	fcc42503          	lw	a0,-52(s0)
    45a8:	4b0000ef          	jal	ra,4a58 <write>
    45ac:	fe9501e3          	beq	a0,s1,458e <countfree+0x38>
        printf("write() failed in countfree()\n");
    45b0:	00003517          	auipc	a0,0x3
    45b4:	99050513          	addi	a0,a0,-1648 # 6f40 <malloc+0x202c>
    45b8:	0a3000ef          	jal	ra,4e5a <printf>
        exit(1);
    45bc:	4505                	li	a0,1
    45be:	47a000ef          	jal	ra,4a38 <exit>
    printf("pipe() failed in countfree()\n");
    45c2:	00003517          	auipc	a0,0x3
    45c6:	93e50513          	addi	a0,a0,-1730 # 6f00 <malloc+0x1fec>
    45ca:	091000ef          	jal	ra,4e5a <printf>
    exit(1);
    45ce:	4505                	li	a0,1
    45d0:	468000ef          	jal	ra,4a38 <exit>
    printf("fork failed in countfree()\n");
    45d4:	00003517          	auipc	a0,0x3
    45d8:	94c50513          	addi	a0,a0,-1716 # 6f20 <malloc+0x200c>
    45dc:	07f000ef          	jal	ra,4e5a <printf>
    exit(1);
    45e0:	4505                	li	a0,1
    45e2:	456000ef          	jal	ra,4a38 <exit>
      }
    }

    exit(0);
    45e6:	4501                	li	a0,0
    45e8:	450000ef          	jal	ra,4a38 <exit>
  }

  close(fds[1]);
    45ec:	fcc42503          	lw	a0,-52(s0)
    45f0:	470000ef          	jal	ra,4a60 <close>

  int n = 0;
    45f4:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    45f6:	4605                	li	a2,1
    45f8:	fc740593          	addi	a1,s0,-57
    45fc:	fc842503          	lw	a0,-56(s0)
    4600:	450000ef          	jal	ra,4a50 <read>
    if(cc < 0){
    4604:	00054563          	bltz	a0,460e <countfree+0xb8>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    4608:	cd01                	beqz	a0,4620 <countfree+0xca>
      break;
    n += 1;
    460a:	2485                	addiw	s1,s1,1
  while(1){
    460c:	b7ed                	j	45f6 <countfree+0xa0>
      printf("read() failed in countfree()\n");
    460e:	00003517          	auipc	a0,0x3
    4612:	95250513          	addi	a0,a0,-1710 # 6f60 <malloc+0x204c>
    4616:	045000ef          	jal	ra,4e5a <printf>
      exit(1);
    461a:	4505                	li	a0,1
    461c:	41c000ef          	jal	ra,4a38 <exit>
  }

  close(fds[0]);
    4620:	fc842503          	lw	a0,-56(s0)
    4624:	43c000ef          	jal	ra,4a60 <close>
  wait((int*)0);
    4628:	4501                	li	a0,0
    462a:	416000ef          	jal	ra,4a40 <wait>
  
  return n;
}
    462e:	8526                	mv	a0,s1
    4630:	70e2                	ld	ra,56(sp)
    4632:	7442                	ld	s0,48(sp)
    4634:	74a2                	ld	s1,40(sp)
    4636:	7902                	ld	s2,32(sp)
    4638:	69e2                	ld	s3,24(sp)
    463a:	6121                	addi	sp,sp,64
    463c:	8082                	ret

000000000000463e <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    463e:	711d                	addi	sp,sp,-96
    4640:	ec86                	sd	ra,88(sp)
    4642:	e8a2                	sd	s0,80(sp)
    4644:	e4a6                	sd	s1,72(sp)
    4646:	e0ca                	sd	s2,64(sp)
    4648:	fc4e                	sd	s3,56(sp)
    464a:	f852                	sd	s4,48(sp)
    464c:	f456                	sd	s5,40(sp)
    464e:	f05a                	sd	s6,32(sp)
    4650:	ec5e                	sd	s7,24(sp)
    4652:	e862                	sd	s8,16(sp)
    4654:	e466                	sd	s9,8(sp)
    4656:	e06a                	sd	s10,0(sp)
    4658:	1080                	addi	s0,sp,96
    465a:	8a2a                	mv	s4,a0
    465c:	892e                	mv	s2,a1
    465e:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    4660:	00003b97          	auipc	s7,0x3
    4664:	920b8b93          	addi	s7,s7,-1760 # 6f80 <malloc+0x206c>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    4668:	00004b17          	auipc	s6,0x4
    466c:	9a8b0b13          	addi	s6,s6,-1624 # 8010 <quicktests>
      if(continuous != 2) {
    4670:	4a89                	li	s5,2
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4672:	00003c97          	auipc	s9,0x3
    4676:	946c8c93          	addi	s9,s9,-1722 # 6fb8 <malloc+0x20a4>
      if (runtests(slowtests, justone, continuous)) {
    467a:	00004c17          	auipc	s8,0x4
    467e:	d66c0c13          	addi	s8,s8,-666 # 83e0 <slowtests>
        printf("usertests slow tests starting\n");
    4682:	00003d17          	auipc	s10,0x3
    4686:	916d0d13          	addi	s10,s10,-1770 # 6f98 <malloc+0x2084>
    468a:	a819                	j	46a0 <drivetests+0x62>
    468c:	856a                	mv	a0,s10
    468e:	7cc000ef          	jal	ra,4e5a <printf>
    4692:	a80d                	j	46c4 <drivetests+0x86>
    if((free1 = countfree()) < free0) {
    4694:	ec3ff0ef          	jal	ra,4556 <countfree>
    4698:	04954863          	blt	a0,s1,46e8 <drivetests+0xaa>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    469c:	06090363          	beqz	s2,4702 <drivetests+0xc4>
    printf("usertests starting\n");
    46a0:	855e                	mv	a0,s7
    46a2:	7b8000ef          	jal	ra,4e5a <printf>
    int free0 = countfree();
    46a6:	eb1ff0ef          	jal	ra,4556 <countfree>
    46aa:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    46ac:	864a                	mv	a2,s2
    46ae:	85ce                	mv	a1,s3
    46b0:	855a                	mv	a0,s6
    46b2:	e33ff0ef          	jal	ra,44e4 <runtests>
    46b6:	c119                	beqz	a0,46bc <drivetests+0x7e>
      if(continuous != 2) {
    46b8:	05591163          	bne	s2,s5,46fa <drivetests+0xbc>
    if(!quick) {
    46bc:	fc0a1ce3          	bnez	s4,4694 <drivetests+0x56>
      if (justone == 0)
    46c0:	fc0986e3          	beqz	s3,468c <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
    46c4:	864a                	mv	a2,s2
    46c6:	85ce                	mv	a1,s3
    46c8:	8562                	mv	a0,s8
    46ca:	e1bff0ef          	jal	ra,44e4 <runtests>
    46ce:	d179                	beqz	a0,4694 <drivetests+0x56>
        if(continuous != 2) {
    46d0:	03591763          	bne	s2,s5,46fe <drivetests+0xc0>
    if((free1 = countfree()) < free0) {
    46d4:	e83ff0ef          	jal	ra,4556 <countfree>
    46d8:	fc9552e3          	bge	a0,s1,469c <drivetests+0x5e>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    46dc:	8626                	mv	a2,s1
    46de:	85aa                	mv	a1,a0
    46e0:	8566                	mv	a0,s9
    46e2:	778000ef          	jal	ra,4e5a <printf>
      if(continuous != 2) {
    46e6:	bf6d                	j	46a0 <drivetests+0x62>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    46e8:	8626                	mv	a2,s1
    46ea:	85aa                	mv	a1,a0
    46ec:	8566                	mv	a0,s9
    46ee:	76c000ef          	jal	ra,4e5a <printf>
      if(continuous != 2) {
    46f2:	fb5907e3          	beq	s2,s5,46a0 <drivetests+0x62>
        return 1;
    46f6:	4505                	li	a0,1
    46f8:	a031                	j	4704 <drivetests+0xc6>
        return 1;
    46fa:	4505                	li	a0,1
    46fc:	a021                	j	4704 <drivetests+0xc6>
          return 1;
    46fe:	4505                	li	a0,1
    4700:	a011                	j	4704 <drivetests+0xc6>
  return 0;
    4702:	854a                	mv	a0,s2
}
    4704:	60e6                	ld	ra,88(sp)
    4706:	6446                	ld	s0,80(sp)
    4708:	64a6                	ld	s1,72(sp)
    470a:	6906                	ld	s2,64(sp)
    470c:	79e2                	ld	s3,56(sp)
    470e:	7a42                	ld	s4,48(sp)
    4710:	7aa2                	ld	s5,40(sp)
    4712:	7b02                	ld	s6,32(sp)
    4714:	6be2                	ld	s7,24(sp)
    4716:	6c42                	ld	s8,16(sp)
    4718:	6ca2                	ld	s9,8(sp)
    471a:	6d02                	ld	s10,0(sp)
    471c:	6125                	addi	sp,sp,96
    471e:	8082                	ret

0000000000004720 <main>:

int
main(int argc, char *argv[])
{
    4720:	1101                	addi	sp,sp,-32
    4722:	ec06                	sd	ra,24(sp)
    4724:	e822                	sd	s0,16(sp)
    4726:	e426                	sd	s1,8(sp)
    4728:	e04a                	sd	s2,0(sp)
    472a:	1000                	addi	s0,sp,32
    472c:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    472e:	4789                	li	a5,2
    4730:	02f50063          	beq	a0,a5,4750 <main+0x30>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4734:	4785                	li	a5,1
    4736:	06a7c063          	blt	a5,a0,4796 <main+0x76>
  char *justone = 0;
    473a:	4901                	li	s2,0
  int quick = 0;
    473c:	4501                	li	a0,0
  int continuous = 0;
    473e:	4481                	li	s1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    4740:	864a                	mv	a2,s2
    4742:	85a6                	mv	a1,s1
    4744:	efbff0ef          	jal	ra,463e <drivetests>
    4748:	c92d                	beqz	a0,47ba <main+0x9a>
    exit(1);
    474a:	4505                	li	a0,1
    474c:	2ec000ef          	jal	ra,4a38 <exit>
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4750:	0085b903          	ld	s2,8(a1)
    4754:	00003597          	auipc	a1,0x3
    4758:	89458593          	addi	a1,a1,-1900 # 6fe8 <malloc+0x20d4>
    475c:	854a                	mv	a0,s2
    475e:	09c000ef          	jal	ra,47fa <strcmp>
    4762:	c139                	beqz	a0,47a8 <main+0x88>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4764:	00003597          	auipc	a1,0x3
    4768:	88c58593          	addi	a1,a1,-1908 # 6ff0 <malloc+0x20dc>
    476c:	854a                	mv	a0,s2
    476e:	08c000ef          	jal	ra,47fa <strcmp>
    4772:	cd1d                	beqz	a0,47b0 <main+0x90>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4774:	00003597          	auipc	a1,0x3
    4778:	88458593          	addi	a1,a1,-1916 # 6ff8 <malloc+0x20e4>
    477c:	854a                	mv	a0,s2
    477e:	07c000ef          	jal	ra,47fa <strcmp>
    4782:	c915                	beqz	a0,47b6 <main+0x96>
  } else if(argc == 2 && argv[1][0] != '-'){
    4784:	00094703          	lbu	a4,0(s2)
    4788:	02d00793          	li	a5,45
    478c:	00f70563          	beq	a4,a5,4796 <main+0x76>
  int quick = 0;
    4790:	4501                	li	a0,0
  int continuous = 0;
    4792:	4481                	li	s1,0
    4794:	b775                	j	4740 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    4796:	00003517          	auipc	a0,0x3
    479a:	86a50513          	addi	a0,a0,-1942 # 7000 <malloc+0x20ec>
    479e:	6bc000ef          	jal	ra,4e5a <printf>
    exit(1);
    47a2:	4505                	li	a0,1
    47a4:	294000ef          	jal	ra,4a38 <exit>
  int continuous = 0;
    47a8:	84aa                	mv	s1,a0
  char *justone = 0;
    47aa:	4901                	li	s2,0
    quick = 1;
    47ac:	4505                	li	a0,1
    47ae:	bf49                	j	4740 <main+0x20>
  char *justone = 0;
    47b0:	4901                	li	s2,0
    continuous = 1;
    47b2:	4485                	li	s1,1
    47b4:	b771                	j	4740 <main+0x20>
  char *justone = 0;
    47b6:	4901                	li	s2,0
    47b8:	b761                	j	4740 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    47ba:	00003517          	auipc	a0,0x3
    47be:	87650513          	addi	a0,a0,-1930 # 7030 <malloc+0x211c>
    47c2:	698000ef          	jal	ra,4e5a <printf>
  exit(0);
    47c6:	4501                	li	a0,0
    47c8:	270000ef          	jal	ra,4a38 <exit>

00000000000047cc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    47cc:	1141                	addi	sp,sp,-16
    47ce:	e406                	sd	ra,8(sp)
    47d0:	e022                	sd	s0,0(sp)
    47d2:	0800                	addi	s0,sp,16
  extern int main();
  main();
    47d4:	f4dff0ef          	jal	ra,4720 <main>
  exit(0);
    47d8:	4501                	li	a0,0
    47da:	25e000ef          	jal	ra,4a38 <exit>

00000000000047de <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    47de:	1141                	addi	sp,sp,-16
    47e0:	e422                	sd	s0,8(sp)
    47e2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    47e4:	87aa                	mv	a5,a0
    47e6:	0585                	addi	a1,a1,1
    47e8:	0785                	addi	a5,a5,1
    47ea:	fff5c703          	lbu	a4,-1(a1)
    47ee:	fee78fa3          	sb	a4,-1(a5) # fff <pgbug+0x29>
    47f2:	fb75                	bnez	a4,47e6 <strcpy+0x8>
    ;
  return os;
}
    47f4:	6422                	ld	s0,8(sp)
    47f6:	0141                	addi	sp,sp,16
    47f8:	8082                	ret

00000000000047fa <strcmp>:

int
strcmp(const char *p, const char *q)
{
    47fa:	1141                	addi	sp,sp,-16
    47fc:	e422                	sd	s0,8(sp)
    47fe:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    4800:	00054783          	lbu	a5,0(a0)
    4804:	cb91                	beqz	a5,4818 <strcmp+0x1e>
    4806:	0005c703          	lbu	a4,0(a1)
    480a:	00f71763          	bne	a4,a5,4818 <strcmp+0x1e>
    p++, q++;
    480e:	0505                	addi	a0,a0,1
    4810:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    4812:	00054783          	lbu	a5,0(a0)
    4816:	fbe5                	bnez	a5,4806 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    4818:	0005c503          	lbu	a0,0(a1)
}
    481c:	40a7853b          	subw	a0,a5,a0
    4820:	6422                	ld	s0,8(sp)
    4822:	0141                	addi	sp,sp,16
    4824:	8082                	ret

0000000000004826 <strlen>:

uint
strlen(const char *s)
{
    4826:	1141                	addi	sp,sp,-16
    4828:	e422                	sd	s0,8(sp)
    482a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    482c:	00054783          	lbu	a5,0(a0)
    4830:	cf91                	beqz	a5,484c <strlen+0x26>
    4832:	0505                	addi	a0,a0,1
    4834:	87aa                	mv	a5,a0
    4836:	4685                	li	a3,1
    4838:	9e89                	subw	a3,a3,a0
    483a:	00f6853b          	addw	a0,a3,a5
    483e:	0785                	addi	a5,a5,1
    4840:	fff7c703          	lbu	a4,-1(a5)
    4844:	fb7d                	bnez	a4,483a <strlen+0x14>
    ;
  return n;
}
    4846:	6422                	ld	s0,8(sp)
    4848:	0141                	addi	sp,sp,16
    484a:	8082                	ret
  for(n = 0; s[n]; n++)
    484c:	4501                	li	a0,0
    484e:	bfe5                	j	4846 <strlen+0x20>

0000000000004850 <memset>:

void*
memset(void *dst, int c, uint n)
{
    4850:	1141                	addi	sp,sp,-16
    4852:	e422                	sd	s0,8(sp)
    4854:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    4856:	ca19                	beqz	a2,486c <memset+0x1c>
    4858:	87aa                	mv	a5,a0
    485a:	1602                	slli	a2,a2,0x20
    485c:	9201                	srli	a2,a2,0x20
    485e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    4862:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4866:	0785                	addi	a5,a5,1
    4868:	fee79de3          	bne	a5,a4,4862 <memset+0x12>
  }
  return dst;
}
    486c:	6422                	ld	s0,8(sp)
    486e:	0141                	addi	sp,sp,16
    4870:	8082                	ret

0000000000004872 <strchr>:

char*
strchr(const char *s, char c)
{
    4872:	1141                	addi	sp,sp,-16
    4874:	e422                	sd	s0,8(sp)
    4876:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4878:	00054783          	lbu	a5,0(a0)
    487c:	cb99                	beqz	a5,4892 <strchr+0x20>
    if(*s == c)
    487e:	00f58763          	beq	a1,a5,488c <strchr+0x1a>
  for(; *s; s++)
    4882:	0505                	addi	a0,a0,1
    4884:	00054783          	lbu	a5,0(a0)
    4888:	fbfd                	bnez	a5,487e <strchr+0xc>
      return (char*)s;
  return 0;
    488a:	4501                	li	a0,0
}
    488c:	6422                	ld	s0,8(sp)
    488e:	0141                	addi	sp,sp,16
    4890:	8082                	ret
  return 0;
    4892:	4501                	li	a0,0
    4894:	bfe5                	j	488c <strchr+0x1a>

0000000000004896 <gets>:

char*
gets(char *buf, int max)
{
    4896:	711d                	addi	sp,sp,-96
    4898:	ec86                	sd	ra,88(sp)
    489a:	e8a2                	sd	s0,80(sp)
    489c:	e4a6                	sd	s1,72(sp)
    489e:	e0ca                	sd	s2,64(sp)
    48a0:	fc4e                	sd	s3,56(sp)
    48a2:	f852                	sd	s4,48(sp)
    48a4:	f456                	sd	s5,40(sp)
    48a6:	f05a                	sd	s6,32(sp)
    48a8:	ec5e                	sd	s7,24(sp)
    48aa:	1080                	addi	s0,sp,96
    48ac:	8baa                	mv	s7,a0
    48ae:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    48b0:	892a                	mv	s2,a0
    48b2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    48b4:	4aa9                	li	s5,10
    48b6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    48b8:	89a6                	mv	s3,s1
    48ba:	2485                	addiw	s1,s1,1
    48bc:	0344d663          	bge	s1,s4,48e8 <gets+0x52>
    cc = read(0, &c, 1);
    48c0:	4605                	li	a2,1
    48c2:	faf40593          	addi	a1,s0,-81
    48c6:	4501                	li	a0,0
    48c8:	188000ef          	jal	ra,4a50 <read>
    if(cc < 1)
    48cc:	00a05e63          	blez	a0,48e8 <gets+0x52>
    buf[i++] = c;
    48d0:	faf44783          	lbu	a5,-81(s0)
    48d4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    48d8:	01578763          	beq	a5,s5,48e6 <gets+0x50>
    48dc:	0905                	addi	s2,s2,1
    48de:	fd679de3          	bne	a5,s6,48b8 <gets+0x22>
  for(i=0; i+1 < max; ){
    48e2:	89a6                	mv	s3,s1
    48e4:	a011                	j	48e8 <gets+0x52>
    48e6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    48e8:	99de                	add	s3,s3,s7
    48ea:	00098023          	sb	zero,0(s3)
  return buf;
}
    48ee:	855e                	mv	a0,s7
    48f0:	60e6                	ld	ra,88(sp)
    48f2:	6446                	ld	s0,80(sp)
    48f4:	64a6                	ld	s1,72(sp)
    48f6:	6906                	ld	s2,64(sp)
    48f8:	79e2                	ld	s3,56(sp)
    48fa:	7a42                	ld	s4,48(sp)
    48fc:	7aa2                	ld	s5,40(sp)
    48fe:	7b02                	ld	s6,32(sp)
    4900:	6be2                	ld	s7,24(sp)
    4902:	6125                	addi	sp,sp,96
    4904:	8082                	ret

0000000000004906 <stat>:

int
stat(const char *n, struct stat *st)
{
    4906:	1101                	addi	sp,sp,-32
    4908:	ec06                	sd	ra,24(sp)
    490a:	e822                	sd	s0,16(sp)
    490c:	e426                	sd	s1,8(sp)
    490e:	e04a                	sd	s2,0(sp)
    4910:	1000                	addi	s0,sp,32
    4912:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4914:	4581                	li	a1,0
    4916:	162000ef          	jal	ra,4a78 <open>
  if(fd < 0)
    491a:	02054163          	bltz	a0,493c <stat+0x36>
    491e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4920:	85ca                	mv	a1,s2
    4922:	16e000ef          	jal	ra,4a90 <fstat>
    4926:	892a                	mv	s2,a0
  close(fd);
    4928:	8526                	mv	a0,s1
    492a:	136000ef          	jal	ra,4a60 <close>
  return r;
}
    492e:	854a                	mv	a0,s2
    4930:	60e2                	ld	ra,24(sp)
    4932:	6442                	ld	s0,16(sp)
    4934:	64a2                	ld	s1,8(sp)
    4936:	6902                	ld	s2,0(sp)
    4938:	6105                	addi	sp,sp,32
    493a:	8082                	ret
    return -1;
    493c:	597d                	li	s2,-1
    493e:	bfc5                	j	492e <stat+0x28>

0000000000004940 <atoi>:

int
atoi(const char *s)
{
    4940:	1141                	addi	sp,sp,-16
    4942:	e422                	sd	s0,8(sp)
    4944:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4946:	00054603          	lbu	a2,0(a0)
    494a:	fd06079b          	addiw	a5,a2,-48
    494e:	0ff7f793          	andi	a5,a5,255
    4952:	4725                	li	a4,9
    4954:	02f76963          	bltu	a4,a5,4986 <atoi+0x46>
    4958:	86aa                	mv	a3,a0
  n = 0;
    495a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    495c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    495e:	0685                	addi	a3,a3,1
    4960:	0025179b          	slliw	a5,a0,0x2
    4964:	9fa9                	addw	a5,a5,a0
    4966:	0017979b          	slliw	a5,a5,0x1
    496a:	9fb1                	addw	a5,a5,a2
    496c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    4970:	0006c603          	lbu	a2,0(a3)
    4974:	fd06071b          	addiw	a4,a2,-48
    4978:	0ff77713          	andi	a4,a4,255
    497c:	fee5f1e3          	bgeu	a1,a4,495e <atoi+0x1e>
  return n;
}
    4980:	6422                	ld	s0,8(sp)
    4982:	0141                	addi	sp,sp,16
    4984:	8082                	ret
  n = 0;
    4986:	4501                	li	a0,0
    4988:	bfe5                	j	4980 <atoi+0x40>

000000000000498a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    498a:	1141                	addi	sp,sp,-16
    498c:	e422                	sd	s0,8(sp)
    498e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4990:	02b57463          	bgeu	a0,a1,49b8 <memmove+0x2e>
    while(n-- > 0)
    4994:	00c05f63          	blez	a2,49b2 <memmove+0x28>
    4998:	1602                	slli	a2,a2,0x20
    499a:	9201                	srli	a2,a2,0x20
    499c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    49a0:	872a                	mv	a4,a0
      *dst++ = *src++;
    49a2:	0585                	addi	a1,a1,1
    49a4:	0705                	addi	a4,a4,1
    49a6:	fff5c683          	lbu	a3,-1(a1)
    49aa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    49ae:	fee79ae3          	bne	a5,a4,49a2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    49b2:	6422                	ld	s0,8(sp)
    49b4:	0141                	addi	sp,sp,16
    49b6:	8082                	ret
    dst += n;
    49b8:	00c50733          	add	a4,a0,a2
    src += n;
    49bc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    49be:	fec05ae3          	blez	a2,49b2 <memmove+0x28>
    49c2:	fff6079b          	addiw	a5,a2,-1
    49c6:	1782                	slli	a5,a5,0x20
    49c8:	9381                	srli	a5,a5,0x20
    49ca:	fff7c793          	not	a5,a5
    49ce:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    49d0:	15fd                	addi	a1,a1,-1
    49d2:	177d                	addi	a4,a4,-1
    49d4:	0005c683          	lbu	a3,0(a1)
    49d8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    49dc:	fee79ae3          	bne	a5,a4,49d0 <memmove+0x46>
    49e0:	bfc9                	j	49b2 <memmove+0x28>

00000000000049e2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    49e2:	1141                	addi	sp,sp,-16
    49e4:	e422                	sd	s0,8(sp)
    49e6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    49e8:	ca05                	beqz	a2,4a18 <memcmp+0x36>
    49ea:	fff6069b          	addiw	a3,a2,-1
    49ee:	1682                	slli	a3,a3,0x20
    49f0:	9281                	srli	a3,a3,0x20
    49f2:	0685                	addi	a3,a3,1
    49f4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    49f6:	00054783          	lbu	a5,0(a0)
    49fa:	0005c703          	lbu	a4,0(a1)
    49fe:	00e79863          	bne	a5,a4,4a0e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    4a02:	0505                	addi	a0,a0,1
    p2++;
    4a04:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4a06:	fed518e3          	bne	a0,a3,49f6 <memcmp+0x14>
  }
  return 0;
    4a0a:	4501                	li	a0,0
    4a0c:	a019                	j	4a12 <memcmp+0x30>
      return *p1 - *p2;
    4a0e:	40e7853b          	subw	a0,a5,a4
}
    4a12:	6422                	ld	s0,8(sp)
    4a14:	0141                	addi	sp,sp,16
    4a16:	8082                	ret
  return 0;
    4a18:	4501                	li	a0,0
    4a1a:	bfe5                	j	4a12 <memcmp+0x30>

0000000000004a1c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4a1c:	1141                	addi	sp,sp,-16
    4a1e:	e406                	sd	ra,8(sp)
    4a20:	e022                	sd	s0,0(sp)
    4a22:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4a24:	f67ff0ef          	jal	ra,498a <memmove>
}
    4a28:	60a2                	ld	ra,8(sp)
    4a2a:	6402                	ld	s0,0(sp)
    4a2c:	0141                	addi	sp,sp,16
    4a2e:	8082                	ret

0000000000004a30 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4a30:	4885                	li	a7,1
 ecall
    4a32:	00000073          	ecall
 ret
    4a36:	8082                	ret

0000000000004a38 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4a38:	4889                	li	a7,2
 ecall
    4a3a:	00000073          	ecall
 ret
    4a3e:	8082                	ret

0000000000004a40 <wait>:
.global wait
wait:
 li a7, SYS_wait
    4a40:	488d                	li	a7,3
 ecall
    4a42:	00000073          	ecall
 ret
    4a46:	8082                	ret

0000000000004a48 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4a48:	4891                	li	a7,4
 ecall
    4a4a:	00000073          	ecall
 ret
    4a4e:	8082                	ret

0000000000004a50 <read>:
.global read
read:
 li a7, SYS_read
    4a50:	4895                	li	a7,5
 ecall
    4a52:	00000073          	ecall
 ret
    4a56:	8082                	ret

0000000000004a58 <write>:
.global write
write:
 li a7, SYS_write
    4a58:	48c1                	li	a7,16
 ecall
    4a5a:	00000073          	ecall
 ret
    4a5e:	8082                	ret

0000000000004a60 <close>:
.global close
close:
 li a7, SYS_close
    4a60:	48d5                	li	a7,21
 ecall
    4a62:	00000073          	ecall
 ret
    4a66:	8082                	ret

0000000000004a68 <kill>:
.global kill
kill:
 li a7, SYS_kill
    4a68:	4899                	li	a7,6
 ecall
    4a6a:	00000073          	ecall
 ret
    4a6e:	8082                	ret

0000000000004a70 <exec>:
.global exec
exec:
 li a7, SYS_exec
    4a70:	489d                	li	a7,7
 ecall
    4a72:	00000073          	ecall
 ret
    4a76:	8082                	ret

0000000000004a78 <open>:
.global open
open:
 li a7, SYS_open
    4a78:	48bd                	li	a7,15
 ecall
    4a7a:	00000073          	ecall
 ret
    4a7e:	8082                	ret

0000000000004a80 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4a80:	48c5                	li	a7,17
 ecall
    4a82:	00000073          	ecall
 ret
    4a86:	8082                	ret

0000000000004a88 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4a88:	48c9                	li	a7,18
 ecall
    4a8a:	00000073          	ecall
 ret
    4a8e:	8082                	ret

0000000000004a90 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4a90:	48a1                	li	a7,8
 ecall
    4a92:	00000073          	ecall
 ret
    4a96:	8082                	ret

0000000000004a98 <link>:
.global link
link:
 li a7, SYS_link
    4a98:	48cd                	li	a7,19
 ecall
    4a9a:	00000073          	ecall
 ret
    4a9e:	8082                	ret

0000000000004aa0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4aa0:	48d1                	li	a7,20
 ecall
    4aa2:	00000073          	ecall
 ret
    4aa6:	8082                	ret

0000000000004aa8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4aa8:	48a5                	li	a7,9
 ecall
    4aaa:	00000073          	ecall
 ret
    4aae:	8082                	ret

0000000000004ab0 <dup>:
.global dup
dup:
 li a7, SYS_dup
    4ab0:	48a9                	li	a7,10
 ecall
    4ab2:	00000073          	ecall
 ret
    4ab6:	8082                	ret

0000000000004ab8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4ab8:	48ad                	li	a7,11
 ecall
    4aba:	00000073          	ecall
 ret
    4abe:	8082                	ret

0000000000004ac0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    4ac0:	48b1                	li	a7,12
 ecall
    4ac2:	00000073          	ecall
 ret
    4ac6:	8082                	ret

0000000000004ac8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    4ac8:	48b5                	li	a7,13
 ecall
    4aca:	00000073          	ecall
 ret
    4ace:	8082                	ret

0000000000004ad0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4ad0:	48b9                	li	a7,14
 ecall
    4ad2:	00000073          	ecall
 ret
    4ad6:	8082                	ret

0000000000004ad8 <time>:
.global time
time:
 li a7, SYS_time
    4ad8:	48d9                	li	a7,22
 ecall
    4ada:	00000073          	ecall
 ret
    4ade:	8082                	ret

0000000000004ae0 <getmem>:
.global getmem
getmem:
 li a7, SYS_getmem
    4ae0:	48dd                	li	a7,23
 ecall
    4ae2:	00000073          	ecall
 ret
    4ae6:	8082                	ret

0000000000004ae8 <get_sha256>:
.global get_sha256
get_sha256:
 li a7, SYS_get_sha256
    4ae8:	48e1                	li	a7,24
 ecall
    4aea:	00000073          	ecall
 ret
    4aee:	8082                	ret

0000000000004af0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4af0:	1101                	addi	sp,sp,-32
    4af2:	ec06                	sd	ra,24(sp)
    4af4:	e822                	sd	s0,16(sp)
    4af6:	1000                	addi	s0,sp,32
    4af8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4afc:	4605                	li	a2,1
    4afe:	fef40593          	addi	a1,s0,-17
    4b02:	f57ff0ef          	jal	ra,4a58 <write>
}
    4b06:	60e2                	ld	ra,24(sp)
    4b08:	6442                	ld	s0,16(sp)
    4b0a:	6105                	addi	sp,sp,32
    4b0c:	8082                	ret

0000000000004b0e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    4b0e:	7139                	addi	sp,sp,-64
    4b10:	fc06                	sd	ra,56(sp)
    4b12:	f822                	sd	s0,48(sp)
    4b14:	f426                	sd	s1,40(sp)
    4b16:	f04a                	sd	s2,32(sp)
    4b18:	ec4e                	sd	s3,24(sp)
    4b1a:	0080                	addi	s0,sp,64
    4b1c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4b1e:	c299                	beqz	a3,4b24 <printint+0x16>
    4b20:	0805c663          	bltz	a1,4bac <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    4b24:	2581                	sext.w	a1,a1
  neg = 0;
    4b26:	4881                	li	a7,0
    4b28:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    4b2c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    4b2e:	2601                	sext.w	a2,a2
    4b30:	00003517          	auipc	a0,0x3
    4b34:	8d050513          	addi	a0,a0,-1840 # 7400 <digits>
    4b38:	883a                	mv	a6,a4
    4b3a:	2705                	addiw	a4,a4,1
    4b3c:	02c5f7bb          	remuw	a5,a1,a2
    4b40:	1782                	slli	a5,a5,0x20
    4b42:	9381                	srli	a5,a5,0x20
    4b44:	97aa                	add	a5,a5,a0
    4b46:	0007c783          	lbu	a5,0(a5)
    4b4a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    4b4e:	0005879b          	sext.w	a5,a1
    4b52:	02c5d5bb          	divuw	a1,a1,a2
    4b56:	0685                	addi	a3,a3,1
    4b58:	fec7f0e3          	bgeu	a5,a2,4b38 <printint+0x2a>
  if(neg)
    4b5c:	00088b63          	beqz	a7,4b72 <printint+0x64>
    buf[i++] = '-';
    4b60:	fd040793          	addi	a5,s0,-48
    4b64:	973e                	add	a4,a4,a5
    4b66:	02d00793          	li	a5,45
    4b6a:	fef70823          	sb	a5,-16(a4)
    4b6e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    4b72:	02e05663          	blez	a4,4b9e <printint+0x90>
    4b76:	fc040793          	addi	a5,s0,-64
    4b7a:	00e78933          	add	s2,a5,a4
    4b7e:	fff78993          	addi	s3,a5,-1
    4b82:	99ba                	add	s3,s3,a4
    4b84:	377d                	addiw	a4,a4,-1
    4b86:	1702                	slli	a4,a4,0x20
    4b88:	9301                	srli	a4,a4,0x20
    4b8a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    4b8e:	fff94583          	lbu	a1,-1(s2)
    4b92:	8526                	mv	a0,s1
    4b94:	f5dff0ef          	jal	ra,4af0 <putc>
  while(--i >= 0)
    4b98:	197d                	addi	s2,s2,-1
    4b9a:	ff391ae3          	bne	s2,s3,4b8e <printint+0x80>
}
    4b9e:	70e2                	ld	ra,56(sp)
    4ba0:	7442                	ld	s0,48(sp)
    4ba2:	74a2                	ld	s1,40(sp)
    4ba4:	7902                	ld	s2,32(sp)
    4ba6:	69e2                	ld	s3,24(sp)
    4ba8:	6121                	addi	sp,sp,64
    4baa:	8082                	ret
    x = -xx;
    4bac:	40b005bb          	negw	a1,a1
    neg = 1;
    4bb0:	4885                	li	a7,1
    x = -xx;
    4bb2:	bf9d                	j	4b28 <printint+0x1a>

0000000000004bb4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    4bb4:	7119                	addi	sp,sp,-128
    4bb6:	fc86                	sd	ra,120(sp)
    4bb8:	f8a2                	sd	s0,112(sp)
    4bba:	f4a6                	sd	s1,104(sp)
    4bbc:	f0ca                	sd	s2,96(sp)
    4bbe:	ecce                	sd	s3,88(sp)
    4bc0:	e8d2                	sd	s4,80(sp)
    4bc2:	e4d6                	sd	s5,72(sp)
    4bc4:	e0da                	sd	s6,64(sp)
    4bc6:	fc5e                	sd	s7,56(sp)
    4bc8:	f862                	sd	s8,48(sp)
    4bca:	f466                	sd	s9,40(sp)
    4bcc:	f06a                	sd	s10,32(sp)
    4bce:	ec6e                	sd	s11,24(sp)
    4bd0:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    4bd2:	0005c903          	lbu	s2,0(a1)
    4bd6:	22090e63          	beqz	s2,4e12 <vprintf+0x25e>
    4bda:	8b2a                	mv	s6,a0
    4bdc:	8a2e                	mv	s4,a1
    4bde:	8bb2                	mv	s7,a2
  state = 0;
    4be0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    4be2:	4481                	li	s1,0
    4be4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    4be6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    4bea:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    4bee:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    4bf2:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4bf6:	00003c97          	auipc	s9,0x3
    4bfa:	80ac8c93          	addi	s9,s9,-2038 # 7400 <digits>
    4bfe:	a005                	j	4c1e <vprintf+0x6a>
        putc(fd, c0);
    4c00:	85ca                	mv	a1,s2
    4c02:	855a                	mv	a0,s6
    4c04:	eedff0ef          	jal	ra,4af0 <putc>
    4c08:	a019                	j	4c0e <vprintf+0x5a>
    } else if(state == '%'){
    4c0a:	03598263          	beq	s3,s5,4c2e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    4c0e:	2485                	addiw	s1,s1,1
    4c10:	8726                	mv	a4,s1
    4c12:	009a07b3          	add	a5,s4,s1
    4c16:	0007c903          	lbu	s2,0(a5)
    4c1a:	1e090c63          	beqz	s2,4e12 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
    4c1e:	0009079b          	sext.w	a5,s2
    if(state == 0){
    4c22:	fe0994e3          	bnez	s3,4c0a <vprintf+0x56>
      if(c0 == '%'){
    4c26:	fd579de3          	bne	a5,s5,4c00 <vprintf+0x4c>
        state = '%';
    4c2a:	89be                	mv	s3,a5
    4c2c:	b7cd                	j	4c0e <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
    4c2e:	cfa5                	beqz	a5,4ca6 <vprintf+0xf2>
    4c30:	00ea06b3          	add	a3,s4,a4
    4c34:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    4c38:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    4c3a:	c681                	beqz	a3,4c42 <vprintf+0x8e>
    4c3c:	9752                	add	a4,a4,s4
    4c3e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    4c42:	03878a63          	beq	a5,s8,4c76 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
    4c46:	05a78463          	beq	a5,s10,4c8e <vprintf+0xda>
      } else if(c0 == 'u'){
    4c4a:	0db78763          	beq	a5,s11,4d18 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    4c4e:	07800713          	li	a4,120
    4c52:	10e78963          	beq	a5,a4,4d64 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    4c56:	07000713          	li	a4,112
    4c5a:	12e78e63          	beq	a5,a4,4d96 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    4c5e:	07300713          	li	a4,115
    4c62:	16e78b63          	beq	a5,a4,4dd8 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    4c66:	05579063          	bne	a5,s5,4ca6 <vprintf+0xf2>
        putc(fd, '%');
    4c6a:	85d6                	mv	a1,s5
    4c6c:	855a                	mv	a0,s6
    4c6e:	e83ff0ef          	jal	ra,4af0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    4c72:	4981                	li	s3,0
    4c74:	bf69                	j	4c0e <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
    4c76:	008b8913          	addi	s2,s7,8
    4c7a:	4685                	li	a3,1
    4c7c:	4629                	li	a2,10
    4c7e:	000ba583          	lw	a1,0(s7)
    4c82:	855a                	mv	a0,s6
    4c84:	e8bff0ef          	jal	ra,4b0e <printint>
    4c88:	8bca                	mv	s7,s2
      state = 0;
    4c8a:	4981                	li	s3,0
    4c8c:	b749                	j	4c0e <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
    4c8e:	03868663          	beq	a3,s8,4cba <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4c92:	05a68163          	beq	a3,s10,4cd4 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
    4c96:	09b68d63          	beq	a3,s11,4d30 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    4c9a:	03a68f63          	beq	a3,s10,4cd8 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
    4c9e:	07800793          	li	a5,120
    4ca2:	0cf68d63          	beq	a3,a5,4d7c <vprintf+0x1c8>
        putc(fd, '%');
    4ca6:	85d6                	mv	a1,s5
    4ca8:	855a                	mv	a0,s6
    4caa:	e47ff0ef          	jal	ra,4af0 <putc>
        putc(fd, c0);
    4cae:	85ca                	mv	a1,s2
    4cb0:	855a                	mv	a0,s6
    4cb2:	e3fff0ef          	jal	ra,4af0 <putc>
      state = 0;
    4cb6:	4981                	li	s3,0
    4cb8:	bf99                	j	4c0e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4cba:	008b8913          	addi	s2,s7,8
    4cbe:	4685                	li	a3,1
    4cc0:	4629                	li	a2,10
    4cc2:	000ba583          	lw	a1,0(s7)
    4cc6:	855a                	mv	a0,s6
    4cc8:	e47ff0ef          	jal	ra,4b0e <printint>
        i += 1;
    4ccc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    4cce:	8bca                	mv	s7,s2
      state = 0;
    4cd0:	4981                	li	s3,0
        i += 1;
    4cd2:	bf35                	j	4c0e <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4cd4:	03860563          	beq	a2,s8,4cfe <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    4cd8:	07b60963          	beq	a2,s11,4d4a <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    4cdc:	07800793          	li	a5,120
    4ce0:	fcf613e3          	bne	a2,a5,4ca6 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4ce4:	008b8913          	addi	s2,s7,8
    4ce8:	4681                	li	a3,0
    4cea:	4641                	li	a2,16
    4cec:	000ba583          	lw	a1,0(s7)
    4cf0:	855a                	mv	a0,s6
    4cf2:	e1dff0ef          	jal	ra,4b0e <printint>
        i += 2;
    4cf6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    4cf8:	8bca                	mv	s7,s2
      state = 0;
    4cfa:	4981                	li	s3,0
        i += 2;
    4cfc:	bf09                	j	4c0e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4cfe:	008b8913          	addi	s2,s7,8
    4d02:	4685                	li	a3,1
    4d04:	4629                	li	a2,10
    4d06:	000ba583          	lw	a1,0(s7)
    4d0a:	855a                	mv	a0,s6
    4d0c:	e03ff0ef          	jal	ra,4b0e <printint>
        i += 2;
    4d10:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    4d12:	8bca                	mv	s7,s2
      state = 0;
    4d14:	4981                	li	s3,0
        i += 2;
    4d16:	bde5                	j	4c0e <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
    4d18:	008b8913          	addi	s2,s7,8
    4d1c:	4681                	li	a3,0
    4d1e:	4629                	li	a2,10
    4d20:	000ba583          	lw	a1,0(s7)
    4d24:	855a                	mv	a0,s6
    4d26:	de9ff0ef          	jal	ra,4b0e <printint>
    4d2a:	8bca                	mv	s7,s2
      state = 0;
    4d2c:	4981                	li	s3,0
    4d2e:	b5c5                	j	4c0e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d30:	008b8913          	addi	s2,s7,8
    4d34:	4681                	li	a3,0
    4d36:	4629                	li	a2,10
    4d38:	000ba583          	lw	a1,0(s7)
    4d3c:	855a                	mv	a0,s6
    4d3e:	dd1ff0ef          	jal	ra,4b0e <printint>
        i += 1;
    4d42:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d44:	8bca                	mv	s7,s2
      state = 0;
    4d46:	4981                	li	s3,0
        i += 1;
    4d48:	b5d9                	j	4c0e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d4a:	008b8913          	addi	s2,s7,8
    4d4e:	4681                	li	a3,0
    4d50:	4629                	li	a2,10
    4d52:	000ba583          	lw	a1,0(s7)
    4d56:	855a                	mv	a0,s6
    4d58:	db7ff0ef          	jal	ra,4b0e <printint>
        i += 2;
    4d5c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d5e:	8bca                	mv	s7,s2
      state = 0;
    4d60:	4981                	li	s3,0
        i += 2;
    4d62:	b575                	j	4c0e <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
    4d64:	008b8913          	addi	s2,s7,8
    4d68:	4681                	li	a3,0
    4d6a:	4641                	li	a2,16
    4d6c:	000ba583          	lw	a1,0(s7)
    4d70:	855a                	mv	a0,s6
    4d72:	d9dff0ef          	jal	ra,4b0e <printint>
    4d76:	8bca                	mv	s7,s2
      state = 0;
    4d78:	4981                	li	s3,0
    4d7a:	bd51                	j	4c0e <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4d7c:	008b8913          	addi	s2,s7,8
    4d80:	4681                	li	a3,0
    4d82:	4641                	li	a2,16
    4d84:	000ba583          	lw	a1,0(s7)
    4d88:	855a                	mv	a0,s6
    4d8a:	d85ff0ef          	jal	ra,4b0e <printint>
        i += 1;
    4d8e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    4d90:	8bca                	mv	s7,s2
      state = 0;
    4d92:	4981                	li	s3,0
        i += 1;
    4d94:	bdad                	j	4c0e <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
    4d96:	008b8793          	addi	a5,s7,8
    4d9a:	f8f43423          	sd	a5,-120(s0)
    4d9e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    4da2:	03000593          	li	a1,48
    4da6:	855a                	mv	a0,s6
    4da8:	d49ff0ef          	jal	ra,4af0 <putc>
  putc(fd, 'x');
    4dac:	07800593          	li	a1,120
    4db0:	855a                	mv	a0,s6
    4db2:	d3fff0ef          	jal	ra,4af0 <putc>
    4db6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4db8:	03c9d793          	srli	a5,s3,0x3c
    4dbc:	97e6                	add	a5,a5,s9
    4dbe:	0007c583          	lbu	a1,0(a5)
    4dc2:	855a                	mv	a0,s6
    4dc4:	d2dff0ef          	jal	ra,4af0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    4dc8:	0992                	slli	s3,s3,0x4
    4dca:	397d                	addiw	s2,s2,-1
    4dcc:	fe0916e3          	bnez	s2,4db8 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
    4dd0:	f8843b83          	ld	s7,-120(s0)
      state = 0;
    4dd4:	4981                	li	s3,0
    4dd6:	bd25                	j	4c0e <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
    4dd8:	008b8993          	addi	s3,s7,8
    4ddc:	000bb903          	ld	s2,0(s7)
    4de0:	00090f63          	beqz	s2,4dfe <vprintf+0x24a>
        for(; *s; s++)
    4de4:	00094583          	lbu	a1,0(s2)
    4de8:	c195                	beqz	a1,4e0c <vprintf+0x258>
          putc(fd, *s);
    4dea:	855a                	mv	a0,s6
    4dec:	d05ff0ef          	jal	ra,4af0 <putc>
        for(; *s; s++)
    4df0:	0905                	addi	s2,s2,1
    4df2:	00094583          	lbu	a1,0(s2)
    4df6:	f9f5                	bnez	a1,4dea <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
    4df8:	8bce                	mv	s7,s3
      state = 0;
    4dfa:	4981                	li	s3,0
    4dfc:	bd09                	j	4c0e <vprintf+0x5a>
          s = "(null)";
    4dfe:	00002917          	auipc	s2,0x2
    4e02:	5fa90913          	addi	s2,s2,1530 # 73f8 <malloc+0x24e4>
        for(; *s; s++)
    4e06:	02800593          	li	a1,40
    4e0a:	b7c5                	j	4dea <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
    4e0c:	8bce                	mv	s7,s3
      state = 0;
    4e0e:	4981                	li	s3,0
    4e10:	bbfd                	j	4c0e <vprintf+0x5a>
    }
  }
}
    4e12:	70e6                	ld	ra,120(sp)
    4e14:	7446                	ld	s0,112(sp)
    4e16:	74a6                	ld	s1,104(sp)
    4e18:	7906                	ld	s2,96(sp)
    4e1a:	69e6                	ld	s3,88(sp)
    4e1c:	6a46                	ld	s4,80(sp)
    4e1e:	6aa6                	ld	s5,72(sp)
    4e20:	6b06                	ld	s6,64(sp)
    4e22:	7be2                	ld	s7,56(sp)
    4e24:	7c42                	ld	s8,48(sp)
    4e26:	7ca2                	ld	s9,40(sp)
    4e28:	7d02                	ld	s10,32(sp)
    4e2a:	6de2                	ld	s11,24(sp)
    4e2c:	6109                	addi	sp,sp,128
    4e2e:	8082                	ret

0000000000004e30 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    4e30:	715d                	addi	sp,sp,-80
    4e32:	ec06                	sd	ra,24(sp)
    4e34:	e822                	sd	s0,16(sp)
    4e36:	1000                	addi	s0,sp,32
    4e38:	e010                	sd	a2,0(s0)
    4e3a:	e414                	sd	a3,8(s0)
    4e3c:	e818                	sd	a4,16(s0)
    4e3e:	ec1c                	sd	a5,24(s0)
    4e40:	03043023          	sd	a6,32(s0)
    4e44:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    4e48:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    4e4c:	8622                	mv	a2,s0
    4e4e:	d67ff0ef          	jal	ra,4bb4 <vprintf>
}
    4e52:	60e2                	ld	ra,24(sp)
    4e54:	6442                	ld	s0,16(sp)
    4e56:	6161                	addi	sp,sp,80
    4e58:	8082                	ret

0000000000004e5a <printf>:

void
printf(const char *fmt, ...)
{
    4e5a:	711d                	addi	sp,sp,-96
    4e5c:	ec06                	sd	ra,24(sp)
    4e5e:	e822                	sd	s0,16(sp)
    4e60:	1000                	addi	s0,sp,32
    4e62:	e40c                	sd	a1,8(s0)
    4e64:	e810                	sd	a2,16(s0)
    4e66:	ec14                	sd	a3,24(s0)
    4e68:	f018                	sd	a4,32(s0)
    4e6a:	f41c                	sd	a5,40(s0)
    4e6c:	03043823          	sd	a6,48(s0)
    4e70:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    4e74:	00840613          	addi	a2,s0,8
    4e78:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    4e7c:	85aa                	mv	a1,a0
    4e7e:	4505                	li	a0,1
    4e80:	d35ff0ef          	jal	ra,4bb4 <vprintf>
}
    4e84:	60e2                	ld	ra,24(sp)
    4e86:	6442                	ld	s0,16(sp)
    4e88:	6125                	addi	sp,sp,96
    4e8a:	8082                	ret

0000000000004e8c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4e8c:	1141                	addi	sp,sp,-16
    4e8e:	e422                	sd	s0,8(sp)
    4e90:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4e92:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4e96:	00003797          	auipc	a5,0x3
    4e9a:	5ba7b783          	ld	a5,1466(a5) # 8450 <freep>
    4e9e:	a805                	j	4ece <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    4ea0:	4618                	lw	a4,8(a2)
    4ea2:	9db9                	addw	a1,a1,a4
    4ea4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    4ea8:	6398                	ld	a4,0(a5)
    4eaa:	6318                	ld	a4,0(a4)
    4eac:	fee53823          	sd	a4,-16(a0)
    4eb0:	a091                	j	4ef4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    4eb2:	ff852703          	lw	a4,-8(a0)
    4eb6:	9e39                	addw	a2,a2,a4
    4eb8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    4eba:	ff053703          	ld	a4,-16(a0)
    4ebe:	e398                	sd	a4,0(a5)
    4ec0:	a099                	j	4f06 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4ec2:	6398                	ld	a4,0(a5)
    4ec4:	00e7e463          	bltu	a5,a4,4ecc <free+0x40>
    4ec8:	00e6ea63          	bltu	a3,a4,4edc <free+0x50>
{
    4ecc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4ece:	fed7fae3          	bgeu	a5,a3,4ec2 <free+0x36>
    4ed2:	6398                	ld	a4,0(a5)
    4ed4:	00e6e463          	bltu	a3,a4,4edc <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4ed8:	fee7eae3          	bltu	a5,a4,4ecc <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    4edc:	ff852583          	lw	a1,-8(a0)
    4ee0:	6390                	ld	a2,0(a5)
    4ee2:	02059713          	slli	a4,a1,0x20
    4ee6:	9301                	srli	a4,a4,0x20
    4ee8:	0712                	slli	a4,a4,0x4
    4eea:	9736                	add	a4,a4,a3
    4eec:	fae60ae3          	beq	a2,a4,4ea0 <free+0x14>
    bp->s.ptr = p->s.ptr;
    4ef0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    4ef4:	4790                	lw	a2,8(a5)
    4ef6:	02061713          	slli	a4,a2,0x20
    4efa:	9301                	srli	a4,a4,0x20
    4efc:	0712                	slli	a4,a4,0x4
    4efe:	973e                	add	a4,a4,a5
    4f00:	fae689e3          	beq	a3,a4,4eb2 <free+0x26>
  } else
    p->s.ptr = bp;
    4f04:	e394                	sd	a3,0(a5)
  freep = p;
    4f06:	00003717          	auipc	a4,0x3
    4f0a:	54f73523          	sd	a5,1354(a4) # 8450 <freep>
}
    4f0e:	6422                	ld	s0,8(sp)
    4f10:	0141                	addi	sp,sp,16
    4f12:	8082                	ret

0000000000004f14 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    4f14:	7139                	addi	sp,sp,-64
    4f16:	fc06                	sd	ra,56(sp)
    4f18:	f822                	sd	s0,48(sp)
    4f1a:	f426                	sd	s1,40(sp)
    4f1c:	f04a                	sd	s2,32(sp)
    4f1e:	ec4e                	sd	s3,24(sp)
    4f20:	e852                	sd	s4,16(sp)
    4f22:	e456                	sd	s5,8(sp)
    4f24:	e05a                	sd	s6,0(sp)
    4f26:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4f28:	02051493          	slli	s1,a0,0x20
    4f2c:	9081                	srli	s1,s1,0x20
    4f2e:	04bd                	addi	s1,s1,15
    4f30:	8091                	srli	s1,s1,0x4
    4f32:	0014899b          	addiw	s3,s1,1
    4f36:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    4f38:	00003517          	auipc	a0,0x3
    4f3c:	51853503          	ld	a0,1304(a0) # 8450 <freep>
    4f40:	c515                	beqz	a0,4f6c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4f42:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4f44:	4798                	lw	a4,8(a5)
    4f46:	02977f63          	bgeu	a4,s1,4f84 <malloc+0x70>
    4f4a:	8a4e                	mv	s4,s3
    4f4c:	0009871b          	sext.w	a4,s3
    4f50:	6685                	lui	a3,0x1
    4f52:	00d77363          	bgeu	a4,a3,4f58 <malloc+0x44>
    4f56:	6a05                	lui	s4,0x1
    4f58:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    4f5c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    4f60:	00003917          	auipc	s2,0x3
    4f64:	4f090913          	addi	s2,s2,1264 # 8450 <freep>
  if(p == (char*)-1)
    4f68:	5afd                	li	s5,-1
    4f6a:	a0bd                	j	4fd8 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    4f6c:	0000a797          	auipc	a5,0xa
    4f70:	d0c78793          	addi	a5,a5,-756 # ec78 <base>
    4f74:	00003717          	auipc	a4,0x3
    4f78:	4cf73e23          	sd	a5,1244(a4) # 8450 <freep>
    4f7c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    4f7e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    4f82:	b7e1                	j	4f4a <malloc+0x36>
      if(p->s.size == nunits)
    4f84:	02e48b63          	beq	s1,a4,4fba <malloc+0xa6>
        p->s.size -= nunits;
    4f88:	4137073b          	subw	a4,a4,s3
    4f8c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    4f8e:	1702                	slli	a4,a4,0x20
    4f90:	9301                	srli	a4,a4,0x20
    4f92:	0712                	slli	a4,a4,0x4
    4f94:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    4f96:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    4f9a:	00003717          	auipc	a4,0x3
    4f9e:	4aa73b23          	sd	a0,1206(a4) # 8450 <freep>
      return (void*)(p + 1);
    4fa2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    4fa6:	70e2                	ld	ra,56(sp)
    4fa8:	7442                	ld	s0,48(sp)
    4faa:	74a2                	ld	s1,40(sp)
    4fac:	7902                	ld	s2,32(sp)
    4fae:	69e2                	ld	s3,24(sp)
    4fb0:	6a42                	ld	s4,16(sp)
    4fb2:	6aa2                	ld	s5,8(sp)
    4fb4:	6b02                	ld	s6,0(sp)
    4fb6:	6121                	addi	sp,sp,64
    4fb8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    4fba:	6398                	ld	a4,0(a5)
    4fbc:	e118                	sd	a4,0(a0)
    4fbe:	bff1                	j	4f9a <malloc+0x86>
  hp->s.size = nu;
    4fc0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    4fc4:	0541                	addi	a0,a0,16
    4fc6:	ec7ff0ef          	jal	ra,4e8c <free>
  return freep;
    4fca:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    4fce:	dd61                	beqz	a0,4fa6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4fd0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4fd2:	4798                	lw	a4,8(a5)
    4fd4:	fa9778e3          	bgeu	a4,s1,4f84 <malloc+0x70>
    if(p == freep)
    4fd8:	00093703          	ld	a4,0(s2)
    4fdc:	853e                	mv	a0,a5
    4fde:	fef719e3          	bne	a4,a5,4fd0 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
    4fe2:	8552                	mv	a0,s4
    4fe4:	addff0ef          	jal	ra,4ac0 <sbrk>
  if(p == (char*)-1)
    4fe8:	fd551ce3          	bne	a0,s5,4fc0 <malloc+0xac>
        return 0;
    4fec:	4501                	li	a0,0
    4fee:	bf65                	j	4fa6 <malloc+0x92>
