
user/_getmemory:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "kernel/fs.h"
#include "kernel/param.h"
#include "kernel/riscv.h"

int main(){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
int x = getmem();
   8:	330000ef          	jal	ra,338 <getmem>
   c:	85aa                	mv	a1,a0
printf("The memory in megabytes is = %d\n ", x);
   e:	00001517          	auipc	a0,0x1
  12:	84250513          	addi	a0,a0,-1982 # 850 <malloc+0xe4>
  16:	69c000ef          	jal	ra,6b2 <printf>
}
  1a:	4501                	li	a0,0
  1c:	60a2                	ld	ra,8(sp)
  1e:	6402                	ld	s0,0(sp)
  20:	0141                	addi	sp,sp,16
  22:	8082                	ret

0000000000000024 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  24:	1141                	addi	sp,sp,-16
  26:	e406                	sd	ra,8(sp)
  28:	e022                	sd	s0,0(sp)
  2a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  2c:	fd5ff0ef          	jal	ra,0 <main>
  exit(0);
  30:	4501                	li	a0,0
  32:	25e000ef          	jal	ra,290 <exit>

0000000000000036 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  36:	1141                	addi	sp,sp,-16
  38:	e422                	sd	s0,8(sp)
  3a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  3c:	87aa                	mv	a5,a0
  3e:	0585                	addi	a1,a1,1
  40:	0785                	addi	a5,a5,1
  42:	fff5c703          	lbu	a4,-1(a1)
  46:	fee78fa3          	sb	a4,-1(a5)
  4a:	fb75                	bnez	a4,3e <strcpy+0x8>
    ;
  return os;
}
  4c:	6422                	ld	s0,8(sp)
  4e:	0141                	addi	sp,sp,16
  50:	8082                	ret

0000000000000052 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  52:	1141                	addi	sp,sp,-16
  54:	e422                	sd	s0,8(sp)
  56:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  58:	00054783          	lbu	a5,0(a0)
  5c:	cb91                	beqz	a5,70 <strcmp+0x1e>
  5e:	0005c703          	lbu	a4,0(a1)
  62:	00f71763          	bne	a4,a5,70 <strcmp+0x1e>
    p++, q++;
  66:	0505                	addi	a0,a0,1
  68:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  6a:	00054783          	lbu	a5,0(a0)
  6e:	fbe5                	bnez	a5,5e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  70:	0005c503          	lbu	a0,0(a1)
}
  74:	40a7853b          	subw	a0,a5,a0
  78:	6422                	ld	s0,8(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strlen>:

uint
strlen(const char *s)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e422                	sd	s0,8(sp)
  82:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  84:	00054783          	lbu	a5,0(a0)
  88:	cf91                	beqz	a5,a4 <strlen+0x26>
  8a:	0505                	addi	a0,a0,1
  8c:	87aa                	mv	a5,a0
  8e:	4685                	li	a3,1
  90:	9e89                	subw	a3,a3,a0
  92:	00f6853b          	addw	a0,a3,a5
  96:	0785                	addi	a5,a5,1
  98:	fff7c703          	lbu	a4,-1(a5)
  9c:	fb7d                	bnez	a4,92 <strlen+0x14>
    ;
  return n;
}
  9e:	6422                	ld	s0,8(sp)
  a0:	0141                	addi	sp,sp,16
  a2:	8082                	ret
  for(n = 0; s[n]; n++)
  a4:	4501                	li	a0,0
  a6:	bfe5                	j	9e <strlen+0x20>

00000000000000a8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ae:	ca19                	beqz	a2,c4 <memset+0x1c>
  b0:	87aa                	mv	a5,a0
  b2:	1602                	slli	a2,a2,0x20
  b4:	9201                	srli	a2,a2,0x20
  b6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ba:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  be:	0785                	addi	a5,a5,1
  c0:	fee79de3          	bne	a5,a4,ba <memset+0x12>
  }
  return dst;
}
  c4:	6422                	ld	s0,8(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strchr>:

char*
strchr(const char *s, char c)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e422                	sd	s0,8(sp)
  ce:	0800                	addi	s0,sp,16
  for(; *s; s++)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cb99                	beqz	a5,ea <strchr+0x20>
    if(*s == c)
  d6:	00f58763          	beq	a1,a5,e4 <strchr+0x1a>
  for(; *s; s++)
  da:	0505                	addi	a0,a0,1
  dc:	00054783          	lbu	a5,0(a0)
  e0:	fbfd                	bnez	a5,d6 <strchr+0xc>
      return (char*)s;
  return 0;
  e2:	4501                	li	a0,0
}
  e4:	6422                	ld	s0,8(sp)
  e6:	0141                	addi	sp,sp,16
  e8:	8082                	ret
  return 0;
  ea:	4501                	li	a0,0
  ec:	bfe5                	j	e4 <strchr+0x1a>

00000000000000ee <gets>:

char*
gets(char *buf, int max)
{
  ee:	711d                	addi	sp,sp,-96
  f0:	ec86                	sd	ra,88(sp)
  f2:	e8a2                	sd	s0,80(sp)
  f4:	e4a6                	sd	s1,72(sp)
  f6:	e0ca                	sd	s2,64(sp)
  f8:	fc4e                	sd	s3,56(sp)
  fa:	f852                	sd	s4,48(sp)
  fc:	f456                	sd	s5,40(sp)
  fe:	f05a                	sd	s6,32(sp)
 100:	ec5e                	sd	s7,24(sp)
 102:	1080                	addi	s0,sp,96
 104:	8baa                	mv	s7,a0
 106:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 108:	892a                	mv	s2,a0
 10a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 10c:	4aa9                	li	s5,10
 10e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 110:	89a6                	mv	s3,s1
 112:	2485                	addiw	s1,s1,1
 114:	0344d663          	bge	s1,s4,140 <gets+0x52>
    cc = read(0, &c, 1);
 118:	4605                	li	a2,1
 11a:	faf40593          	addi	a1,s0,-81
 11e:	4501                	li	a0,0
 120:	188000ef          	jal	ra,2a8 <read>
    if(cc < 1)
 124:	00a05e63          	blez	a0,140 <gets+0x52>
    buf[i++] = c;
 128:	faf44783          	lbu	a5,-81(s0)
 12c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 130:	01578763          	beq	a5,s5,13e <gets+0x50>
 134:	0905                	addi	s2,s2,1
 136:	fd679de3          	bne	a5,s6,110 <gets+0x22>
  for(i=0; i+1 < max; ){
 13a:	89a6                	mv	s3,s1
 13c:	a011                	j	140 <gets+0x52>
 13e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 140:	99de                	add	s3,s3,s7
 142:	00098023          	sb	zero,0(s3)
  return buf;
}
 146:	855e                	mv	a0,s7
 148:	60e6                	ld	ra,88(sp)
 14a:	6446                	ld	s0,80(sp)
 14c:	64a6                	ld	s1,72(sp)
 14e:	6906                	ld	s2,64(sp)
 150:	79e2                	ld	s3,56(sp)
 152:	7a42                	ld	s4,48(sp)
 154:	7aa2                	ld	s5,40(sp)
 156:	7b02                	ld	s6,32(sp)
 158:	6be2                	ld	s7,24(sp)
 15a:	6125                	addi	sp,sp,96
 15c:	8082                	ret

000000000000015e <stat>:

int
stat(const char *n, struct stat *st)
{
 15e:	1101                	addi	sp,sp,-32
 160:	ec06                	sd	ra,24(sp)
 162:	e822                	sd	s0,16(sp)
 164:	e426                	sd	s1,8(sp)
 166:	e04a                	sd	s2,0(sp)
 168:	1000                	addi	s0,sp,32
 16a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 16c:	4581                	li	a1,0
 16e:	162000ef          	jal	ra,2d0 <open>
  if(fd < 0)
 172:	02054163          	bltz	a0,194 <stat+0x36>
 176:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 178:	85ca                	mv	a1,s2
 17a:	16e000ef          	jal	ra,2e8 <fstat>
 17e:	892a                	mv	s2,a0
  close(fd);
 180:	8526                	mv	a0,s1
 182:	136000ef          	jal	ra,2b8 <close>
  return r;
}
 186:	854a                	mv	a0,s2
 188:	60e2                	ld	ra,24(sp)
 18a:	6442                	ld	s0,16(sp)
 18c:	64a2                	ld	s1,8(sp)
 18e:	6902                	ld	s2,0(sp)
 190:	6105                	addi	sp,sp,32
 192:	8082                	ret
    return -1;
 194:	597d                	li	s2,-1
 196:	bfc5                	j	186 <stat+0x28>

0000000000000198 <atoi>:

int
atoi(const char *s)
{
 198:	1141                	addi	sp,sp,-16
 19a:	e422                	sd	s0,8(sp)
 19c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 19e:	00054603          	lbu	a2,0(a0)
 1a2:	fd06079b          	addiw	a5,a2,-48
 1a6:	0ff7f793          	andi	a5,a5,255
 1aa:	4725                	li	a4,9
 1ac:	02f76963          	bltu	a4,a5,1de <atoi+0x46>
 1b0:	86aa                	mv	a3,a0
  n = 0;
 1b2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1b4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1b6:	0685                	addi	a3,a3,1
 1b8:	0025179b          	slliw	a5,a0,0x2
 1bc:	9fa9                	addw	a5,a5,a0
 1be:	0017979b          	slliw	a5,a5,0x1
 1c2:	9fb1                	addw	a5,a5,a2
 1c4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1c8:	0006c603          	lbu	a2,0(a3)
 1cc:	fd06071b          	addiw	a4,a2,-48
 1d0:	0ff77713          	andi	a4,a4,255
 1d4:	fee5f1e3          	bgeu	a1,a4,1b6 <atoi+0x1e>
  return n;
}
 1d8:	6422                	ld	s0,8(sp)
 1da:	0141                	addi	sp,sp,16
 1dc:	8082                	ret
  n = 0;
 1de:	4501                	li	a0,0
 1e0:	bfe5                	j	1d8 <atoi+0x40>

00000000000001e2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e2:	1141                	addi	sp,sp,-16
 1e4:	e422                	sd	s0,8(sp)
 1e6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1e8:	02b57463          	bgeu	a0,a1,210 <memmove+0x2e>
    while(n-- > 0)
 1ec:	00c05f63          	blez	a2,20a <memmove+0x28>
 1f0:	1602                	slli	a2,a2,0x20
 1f2:	9201                	srli	a2,a2,0x20
 1f4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1f8:	872a                	mv	a4,a0
      *dst++ = *src++;
 1fa:	0585                	addi	a1,a1,1
 1fc:	0705                	addi	a4,a4,1
 1fe:	fff5c683          	lbu	a3,-1(a1)
 202:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 206:	fee79ae3          	bne	a5,a4,1fa <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 20a:	6422                	ld	s0,8(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret
    dst += n;
 210:	00c50733          	add	a4,a0,a2
    src += n;
 214:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 216:	fec05ae3          	blez	a2,20a <memmove+0x28>
 21a:	fff6079b          	addiw	a5,a2,-1
 21e:	1782                	slli	a5,a5,0x20
 220:	9381                	srli	a5,a5,0x20
 222:	fff7c793          	not	a5,a5
 226:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 228:	15fd                	addi	a1,a1,-1
 22a:	177d                	addi	a4,a4,-1
 22c:	0005c683          	lbu	a3,0(a1)
 230:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 234:	fee79ae3          	bne	a5,a4,228 <memmove+0x46>
 238:	bfc9                	j	20a <memmove+0x28>

000000000000023a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e422                	sd	s0,8(sp)
 23e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 240:	ca05                	beqz	a2,270 <memcmp+0x36>
 242:	fff6069b          	addiw	a3,a2,-1
 246:	1682                	slli	a3,a3,0x20
 248:	9281                	srli	a3,a3,0x20
 24a:	0685                	addi	a3,a3,1
 24c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 24e:	00054783          	lbu	a5,0(a0)
 252:	0005c703          	lbu	a4,0(a1)
 256:	00e79863          	bne	a5,a4,266 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 25a:	0505                	addi	a0,a0,1
    p2++;
 25c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 25e:	fed518e3          	bne	a0,a3,24e <memcmp+0x14>
  }
  return 0;
 262:	4501                	li	a0,0
 264:	a019                	j	26a <memcmp+0x30>
      return *p1 - *p2;
 266:	40e7853b          	subw	a0,a5,a4
}
 26a:	6422                	ld	s0,8(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret
  return 0;
 270:	4501                	li	a0,0
 272:	bfe5                	j	26a <memcmp+0x30>

0000000000000274 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 274:	1141                	addi	sp,sp,-16
 276:	e406                	sd	ra,8(sp)
 278:	e022                	sd	s0,0(sp)
 27a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 27c:	f67ff0ef          	jal	ra,1e2 <memmove>
}
 280:	60a2                	ld	ra,8(sp)
 282:	6402                	ld	s0,0(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret

0000000000000288 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 288:	4885                	li	a7,1
 ecall
 28a:	00000073          	ecall
 ret
 28e:	8082                	ret

0000000000000290 <exit>:
.global exit
exit:
 li a7, SYS_exit
 290:	4889                	li	a7,2
 ecall
 292:	00000073          	ecall
 ret
 296:	8082                	ret

0000000000000298 <wait>:
.global wait
wait:
 li a7, SYS_wait
 298:	488d                	li	a7,3
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2a0:	4891                	li	a7,4
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <read>:
.global read
read:
 li a7, SYS_read
 2a8:	4895                	li	a7,5
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <write>:
.global write
write:
 li a7, SYS_write
 2b0:	48c1                	li	a7,16
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <close>:
.global close
close:
 li a7, SYS_close
 2b8:	48d5                	li	a7,21
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2c0:	4899                	li	a7,6
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2c8:	489d                	li	a7,7
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <open>:
.global open
open:
 li a7, SYS_open
 2d0:	48bd                	li	a7,15
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2d8:	48c5                	li	a7,17
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2e0:	48c9                	li	a7,18
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2e8:	48a1                	li	a7,8
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <link>:
.global link
link:
 li a7, SYS_link
 2f0:	48cd                	li	a7,19
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2f8:	48d1                	li	a7,20
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 300:	48a5                	li	a7,9
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <dup>:
.global dup
dup:
 li a7, SYS_dup
 308:	48a9                	li	a7,10
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 310:	48ad                	li	a7,11
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 318:	48b1                	li	a7,12
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 320:	48b5                	li	a7,13
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 328:	48b9                	li	a7,14
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <time>:
.global time
time:
 li a7, SYS_time
 330:	48d9                	li	a7,22
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <getmem>:
.global getmem
getmem:
 li a7, SYS_getmem
 338:	48dd                	li	a7,23
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <get_sha256>:
.global get_sha256
get_sha256:
 li a7, SYS_get_sha256
 340:	48e1                	li	a7,24
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 348:	1101                	addi	sp,sp,-32
 34a:	ec06                	sd	ra,24(sp)
 34c:	e822                	sd	s0,16(sp)
 34e:	1000                	addi	s0,sp,32
 350:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 354:	4605                	li	a2,1
 356:	fef40593          	addi	a1,s0,-17
 35a:	f57ff0ef          	jal	ra,2b0 <write>
}
 35e:	60e2                	ld	ra,24(sp)
 360:	6442                	ld	s0,16(sp)
 362:	6105                	addi	sp,sp,32
 364:	8082                	ret

0000000000000366 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 366:	7139                	addi	sp,sp,-64
 368:	fc06                	sd	ra,56(sp)
 36a:	f822                	sd	s0,48(sp)
 36c:	f426                	sd	s1,40(sp)
 36e:	f04a                	sd	s2,32(sp)
 370:	ec4e                	sd	s3,24(sp)
 372:	0080                	addi	s0,sp,64
 374:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 376:	c299                	beqz	a3,37c <printint+0x16>
 378:	0805c663          	bltz	a1,404 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 37c:	2581                	sext.w	a1,a1
  neg = 0;
 37e:	4881                	li	a7,0
 380:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 384:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 386:	2601                	sext.w	a2,a2
 388:	00000517          	auipc	a0,0x0
 38c:	4f850513          	addi	a0,a0,1272 # 880 <digits>
 390:	883a                	mv	a6,a4
 392:	2705                	addiw	a4,a4,1
 394:	02c5f7bb          	remuw	a5,a1,a2
 398:	1782                	slli	a5,a5,0x20
 39a:	9381                	srli	a5,a5,0x20
 39c:	97aa                	add	a5,a5,a0
 39e:	0007c783          	lbu	a5,0(a5)
 3a2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3a6:	0005879b          	sext.w	a5,a1
 3aa:	02c5d5bb          	divuw	a1,a1,a2
 3ae:	0685                	addi	a3,a3,1
 3b0:	fec7f0e3          	bgeu	a5,a2,390 <printint+0x2a>
  if(neg)
 3b4:	00088b63          	beqz	a7,3ca <printint+0x64>
    buf[i++] = '-';
 3b8:	fd040793          	addi	a5,s0,-48
 3bc:	973e                	add	a4,a4,a5
 3be:	02d00793          	li	a5,45
 3c2:	fef70823          	sb	a5,-16(a4)
 3c6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3ca:	02e05663          	blez	a4,3f6 <printint+0x90>
 3ce:	fc040793          	addi	a5,s0,-64
 3d2:	00e78933          	add	s2,a5,a4
 3d6:	fff78993          	addi	s3,a5,-1
 3da:	99ba                	add	s3,s3,a4
 3dc:	377d                	addiw	a4,a4,-1
 3de:	1702                	slli	a4,a4,0x20
 3e0:	9301                	srli	a4,a4,0x20
 3e2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3e6:	fff94583          	lbu	a1,-1(s2)
 3ea:	8526                	mv	a0,s1
 3ec:	f5dff0ef          	jal	ra,348 <putc>
  while(--i >= 0)
 3f0:	197d                	addi	s2,s2,-1
 3f2:	ff391ae3          	bne	s2,s3,3e6 <printint+0x80>
}
 3f6:	70e2                	ld	ra,56(sp)
 3f8:	7442                	ld	s0,48(sp)
 3fa:	74a2                	ld	s1,40(sp)
 3fc:	7902                	ld	s2,32(sp)
 3fe:	69e2                	ld	s3,24(sp)
 400:	6121                	addi	sp,sp,64
 402:	8082                	ret
    x = -xx;
 404:	40b005bb          	negw	a1,a1
    neg = 1;
 408:	4885                	li	a7,1
    x = -xx;
 40a:	bf9d                	j	380 <printint+0x1a>

000000000000040c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 40c:	7119                	addi	sp,sp,-128
 40e:	fc86                	sd	ra,120(sp)
 410:	f8a2                	sd	s0,112(sp)
 412:	f4a6                	sd	s1,104(sp)
 414:	f0ca                	sd	s2,96(sp)
 416:	ecce                	sd	s3,88(sp)
 418:	e8d2                	sd	s4,80(sp)
 41a:	e4d6                	sd	s5,72(sp)
 41c:	e0da                	sd	s6,64(sp)
 41e:	fc5e                	sd	s7,56(sp)
 420:	f862                	sd	s8,48(sp)
 422:	f466                	sd	s9,40(sp)
 424:	f06a                	sd	s10,32(sp)
 426:	ec6e                	sd	s11,24(sp)
 428:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 42a:	0005c903          	lbu	s2,0(a1)
 42e:	22090e63          	beqz	s2,66a <vprintf+0x25e>
 432:	8b2a                	mv	s6,a0
 434:	8a2e                	mv	s4,a1
 436:	8bb2                	mv	s7,a2
  state = 0;
 438:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 43a:	4481                	li	s1,0
 43c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 43e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 442:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 446:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 44a:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 44e:	00000c97          	auipc	s9,0x0
 452:	432c8c93          	addi	s9,s9,1074 # 880 <digits>
 456:	a005                	j	476 <vprintf+0x6a>
        putc(fd, c0);
 458:	85ca                	mv	a1,s2
 45a:	855a                	mv	a0,s6
 45c:	eedff0ef          	jal	ra,348 <putc>
 460:	a019                	j	466 <vprintf+0x5a>
    } else if(state == '%'){
 462:	03598263          	beq	s3,s5,486 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 466:	2485                	addiw	s1,s1,1
 468:	8726                	mv	a4,s1
 46a:	009a07b3          	add	a5,s4,s1
 46e:	0007c903          	lbu	s2,0(a5)
 472:	1e090c63          	beqz	s2,66a <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 476:	0009079b          	sext.w	a5,s2
    if(state == 0){
 47a:	fe0994e3          	bnez	s3,462 <vprintf+0x56>
      if(c0 == '%'){
 47e:	fd579de3          	bne	a5,s5,458 <vprintf+0x4c>
        state = '%';
 482:	89be                	mv	s3,a5
 484:	b7cd                	j	466 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 486:	cfa5                	beqz	a5,4fe <vprintf+0xf2>
 488:	00ea06b3          	add	a3,s4,a4
 48c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 490:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 492:	c681                	beqz	a3,49a <vprintf+0x8e>
 494:	9752                	add	a4,a4,s4
 496:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 49a:	03878a63          	beq	a5,s8,4ce <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 49e:	05a78463          	beq	a5,s10,4e6 <vprintf+0xda>
      } else if(c0 == 'u'){
 4a2:	0db78763          	beq	a5,s11,570 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4a6:	07800713          	li	a4,120
 4aa:	10e78963          	beq	a5,a4,5bc <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4ae:	07000713          	li	a4,112
 4b2:	12e78e63          	beq	a5,a4,5ee <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4b6:	07300713          	li	a4,115
 4ba:	16e78b63          	beq	a5,a4,630 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4be:	05579063          	bne	a5,s5,4fe <vprintf+0xf2>
        putc(fd, '%');
 4c2:	85d6                	mv	a1,s5
 4c4:	855a                	mv	a0,s6
 4c6:	e83ff0ef          	jal	ra,348 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4ca:	4981                	li	s3,0
 4cc:	bf69                	j	466 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 4ce:	008b8913          	addi	s2,s7,8
 4d2:	4685                	li	a3,1
 4d4:	4629                	li	a2,10
 4d6:	000ba583          	lw	a1,0(s7)
 4da:	855a                	mv	a0,s6
 4dc:	e8bff0ef          	jal	ra,366 <printint>
 4e0:	8bca                	mv	s7,s2
      state = 0;
 4e2:	4981                	li	s3,0
 4e4:	b749                	j	466 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 4e6:	03868663          	beq	a3,s8,512 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4ea:	05a68163          	beq	a3,s10,52c <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 4ee:	09b68d63          	beq	a3,s11,588 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 4f2:	03a68f63          	beq	a3,s10,530 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 4f6:	07800793          	li	a5,120
 4fa:	0cf68d63          	beq	a3,a5,5d4 <vprintf+0x1c8>
        putc(fd, '%');
 4fe:	85d6                	mv	a1,s5
 500:	855a                	mv	a0,s6
 502:	e47ff0ef          	jal	ra,348 <putc>
        putc(fd, c0);
 506:	85ca                	mv	a1,s2
 508:	855a                	mv	a0,s6
 50a:	e3fff0ef          	jal	ra,348 <putc>
      state = 0;
 50e:	4981                	li	s3,0
 510:	bf99                	j	466 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 512:	008b8913          	addi	s2,s7,8
 516:	4685                	li	a3,1
 518:	4629                	li	a2,10
 51a:	000ba583          	lw	a1,0(s7)
 51e:	855a                	mv	a0,s6
 520:	e47ff0ef          	jal	ra,366 <printint>
        i += 1;
 524:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 526:	8bca                	mv	s7,s2
      state = 0;
 528:	4981                	li	s3,0
        i += 1;
 52a:	bf35                	j	466 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 52c:	03860563          	beq	a2,s8,556 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 530:	07b60963          	beq	a2,s11,5a2 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 534:	07800793          	li	a5,120
 538:	fcf613e3          	bne	a2,a5,4fe <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 53c:	008b8913          	addi	s2,s7,8
 540:	4681                	li	a3,0
 542:	4641                	li	a2,16
 544:	000ba583          	lw	a1,0(s7)
 548:	855a                	mv	a0,s6
 54a:	e1dff0ef          	jal	ra,366 <printint>
        i += 2;
 54e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 550:	8bca                	mv	s7,s2
      state = 0;
 552:	4981                	li	s3,0
        i += 2;
 554:	bf09                	j	466 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 556:	008b8913          	addi	s2,s7,8
 55a:	4685                	li	a3,1
 55c:	4629                	li	a2,10
 55e:	000ba583          	lw	a1,0(s7)
 562:	855a                	mv	a0,s6
 564:	e03ff0ef          	jal	ra,366 <printint>
        i += 2;
 568:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 56a:	8bca                	mv	s7,s2
      state = 0;
 56c:	4981                	li	s3,0
        i += 2;
 56e:	bde5                	j	466 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 570:	008b8913          	addi	s2,s7,8
 574:	4681                	li	a3,0
 576:	4629                	li	a2,10
 578:	000ba583          	lw	a1,0(s7)
 57c:	855a                	mv	a0,s6
 57e:	de9ff0ef          	jal	ra,366 <printint>
 582:	8bca                	mv	s7,s2
      state = 0;
 584:	4981                	li	s3,0
 586:	b5c5                	j	466 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 588:	008b8913          	addi	s2,s7,8
 58c:	4681                	li	a3,0
 58e:	4629                	li	a2,10
 590:	000ba583          	lw	a1,0(s7)
 594:	855a                	mv	a0,s6
 596:	dd1ff0ef          	jal	ra,366 <printint>
        i += 1;
 59a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 59c:	8bca                	mv	s7,s2
      state = 0;
 59e:	4981                	li	s3,0
        i += 1;
 5a0:	b5d9                	j	466 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a2:	008b8913          	addi	s2,s7,8
 5a6:	4681                	li	a3,0
 5a8:	4629                	li	a2,10
 5aa:	000ba583          	lw	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	db7ff0ef          	jal	ra,366 <printint>
        i += 2;
 5b4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b6:	8bca                	mv	s7,s2
      state = 0;
 5b8:	4981                	li	s3,0
        i += 2;
 5ba:	b575                	j	466 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 5bc:	008b8913          	addi	s2,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4641                	li	a2,16
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	d9dff0ef          	jal	ra,366 <printint>
 5ce:	8bca                	mv	s7,s2
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	bd51                	j	466 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d4:	008b8913          	addi	s2,s7,8
 5d8:	4681                	li	a3,0
 5da:	4641                	li	a2,16
 5dc:	000ba583          	lw	a1,0(s7)
 5e0:	855a                	mv	a0,s6
 5e2:	d85ff0ef          	jal	ra,366 <printint>
        i += 1;
 5e6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e8:	8bca                	mv	s7,s2
      state = 0;
 5ea:	4981                	li	s3,0
        i += 1;
 5ec:	bdad                	j	466 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 5ee:	008b8793          	addi	a5,s7,8
 5f2:	f8f43423          	sd	a5,-120(s0)
 5f6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5fa:	03000593          	li	a1,48
 5fe:	855a                	mv	a0,s6
 600:	d49ff0ef          	jal	ra,348 <putc>
  putc(fd, 'x');
 604:	07800593          	li	a1,120
 608:	855a                	mv	a0,s6
 60a:	d3fff0ef          	jal	ra,348 <putc>
 60e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 610:	03c9d793          	srli	a5,s3,0x3c
 614:	97e6                	add	a5,a5,s9
 616:	0007c583          	lbu	a1,0(a5)
 61a:	855a                	mv	a0,s6
 61c:	d2dff0ef          	jal	ra,348 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 620:	0992                	slli	s3,s3,0x4
 622:	397d                	addiw	s2,s2,-1
 624:	fe0916e3          	bnez	s2,610 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 628:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 62c:	4981                	li	s3,0
 62e:	bd25                	j	466 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 630:	008b8993          	addi	s3,s7,8
 634:	000bb903          	ld	s2,0(s7)
 638:	00090f63          	beqz	s2,656 <vprintf+0x24a>
        for(; *s; s++)
 63c:	00094583          	lbu	a1,0(s2)
 640:	c195                	beqz	a1,664 <vprintf+0x258>
          putc(fd, *s);
 642:	855a                	mv	a0,s6
 644:	d05ff0ef          	jal	ra,348 <putc>
        for(; *s; s++)
 648:	0905                	addi	s2,s2,1
 64a:	00094583          	lbu	a1,0(s2)
 64e:	f9f5                	bnez	a1,642 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 650:	8bce                	mv	s7,s3
      state = 0;
 652:	4981                	li	s3,0
 654:	bd09                	j	466 <vprintf+0x5a>
          s = "(null)";
 656:	00000917          	auipc	s2,0x0
 65a:	22290913          	addi	s2,s2,546 # 878 <malloc+0x10c>
        for(; *s; s++)
 65e:	02800593          	li	a1,40
 662:	b7c5                	j	642 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 664:	8bce                	mv	s7,s3
      state = 0;
 666:	4981                	li	s3,0
 668:	bbfd                	j	466 <vprintf+0x5a>
    }
  }
}
 66a:	70e6                	ld	ra,120(sp)
 66c:	7446                	ld	s0,112(sp)
 66e:	74a6                	ld	s1,104(sp)
 670:	7906                	ld	s2,96(sp)
 672:	69e6                	ld	s3,88(sp)
 674:	6a46                	ld	s4,80(sp)
 676:	6aa6                	ld	s5,72(sp)
 678:	6b06                	ld	s6,64(sp)
 67a:	7be2                	ld	s7,56(sp)
 67c:	7c42                	ld	s8,48(sp)
 67e:	7ca2                	ld	s9,40(sp)
 680:	7d02                	ld	s10,32(sp)
 682:	6de2                	ld	s11,24(sp)
 684:	6109                	addi	sp,sp,128
 686:	8082                	ret

0000000000000688 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 688:	715d                	addi	sp,sp,-80
 68a:	ec06                	sd	ra,24(sp)
 68c:	e822                	sd	s0,16(sp)
 68e:	1000                	addi	s0,sp,32
 690:	e010                	sd	a2,0(s0)
 692:	e414                	sd	a3,8(s0)
 694:	e818                	sd	a4,16(s0)
 696:	ec1c                	sd	a5,24(s0)
 698:	03043023          	sd	a6,32(s0)
 69c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6a0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6a4:	8622                	mv	a2,s0
 6a6:	d67ff0ef          	jal	ra,40c <vprintf>
}
 6aa:	60e2                	ld	ra,24(sp)
 6ac:	6442                	ld	s0,16(sp)
 6ae:	6161                	addi	sp,sp,80
 6b0:	8082                	ret

00000000000006b2 <printf>:

void
printf(const char *fmt, ...)
{
 6b2:	711d                	addi	sp,sp,-96
 6b4:	ec06                	sd	ra,24(sp)
 6b6:	e822                	sd	s0,16(sp)
 6b8:	1000                	addi	s0,sp,32
 6ba:	e40c                	sd	a1,8(s0)
 6bc:	e810                	sd	a2,16(s0)
 6be:	ec14                	sd	a3,24(s0)
 6c0:	f018                	sd	a4,32(s0)
 6c2:	f41c                	sd	a5,40(s0)
 6c4:	03043823          	sd	a6,48(s0)
 6c8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6cc:	00840613          	addi	a2,s0,8
 6d0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6d4:	85aa                	mv	a1,a0
 6d6:	4505                	li	a0,1
 6d8:	d35ff0ef          	jal	ra,40c <vprintf>
}
 6dc:	60e2                	ld	ra,24(sp)
 6de:	6442                	ld	s0,16(sp)
 6e0:	6125                	addi	sp,sp,96
 6e2:	8082                	ret

00000000000006e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e4:	1141                	addi	sp,sp,-16
 6e6:	e422                	sd	s0,8(sp)
 6e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ee:	00001797          	auipc	a5,0x1
 6f2:	9127b783          	ld	a5,-1774(a5) # 1000 <freep>
 6f6:	a805                	j	726 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6f8:	4618                	lw	a4,8(a2)
 6fa:	9db9                	addw	a1,a1,a4
 6fc:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 700:	6398                	ld	a4,0(a5)
 702:	6318                	ld	a4,0(a4)
 704:	fee53823          	sd	a4,-16(a0)
 708:	a091                	j	74c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 70a:	ff852703          	lw	a4,-8(a0)
 70e:	9e39                	addw	a2,a2,a4
 710:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 712:	ff053703          	ld	a4,-16(a0)
 716:	e398                	sd	a4,0(a5)
 718:	a099                	j	75e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71a:	6398                	ld	a4,0(a5)
 71c:	00e7e463          	bltu	a5,a4,724 <free+0x40>
 720:	00e6ea63          	bltu	a3,a4,734 <free+0x50>
{
 724:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 726:	fed7fae3          	bgeu	a5,a3,71a <free+0x36>
 72a:	6398                	ld	a4,0(a5)
 72c:	00e6e463          	bltu	a3,a4,734 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 730:	fee7eae3          	bltu	a5,a4,724 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 734:	ff852583          	lw	a1,-8(a0)
 738:	6390                	ld	a2,0(a5)
 73a:	02059713          	slli	a4,a1,0x20
 73e:	9301                	srli	a4,a4,0x20
 740:	0712                	slli	a4,a4,0x4
 742:	9736                	add	a4,a4,a3
 744:	fae60ae3          	beq	a2,a4,6f8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 748:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 74c:	4790                	lw	a2,8(a5)
 74e:	02061713          	slli	a4,a2,0x20
 752:	9301                	srli	a4,a4,0x20
 754:	0712                	slli	a4,a4,0x4
 756:	973e                	add	a4,a4,a5
 758:	fae689e3          	beq	a3,a4,70a <free+0x26>
  } else
    p->s.ptr = bp;
 75c:	e394                	sd	a3,0(a5)
  freep = p;
 75e:	00001717          	auipc	a4,0x1
 762:	8af73123          	sd	a5,-1886(a4) # 1000 <freep>
}
 766:	6422                	ld	s0,8(sp)
 768:	0141                	addi	sp,sp,16
 76a:	8082                	ret

000000000000076c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 76c:	7139                	addi	sp,sp,-64
 76e:	fc06                	sd	ra,56(sp)
 770:	f822                	sd	s0,48(sp)
 772:	f426                	sd	s1,40(sp)
 774:	f04a                	sd	s2,32(sp)
 776:	ec4e                	sd	s3,24(sp)
 778:	e852                	sd	s4,16(sp)
 77a:	e456                	sd	s5,8(sp)
 77c:	e05a                	sd	s6,0(sp)
 77e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 780:	02051493          	slli	s1,a0,0x20
 784:	9081                	srli	s1,s1,0x20
 786:	04bd                	addi	s1,s1,15
 788:	8091                	srli	s1,s1,0x4
 78a:	0014899b          	addiw	s3,s1,1
 78e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 790:	00001517          	auipc	a0,0x1
 794:	87053503          	ld	a0,-1936(a0) # 1000 <freep>
 798:	c515                	beqz	a0,7c4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 79c:	4798                	lw	a4,8(a5)
 79e:	02977f63          	bgeu	a4,s1,7dc <malloc+0x70>
 7a2:	8a4e                	mv	s4,s3
 7a4:	0009871b          	sext.w	a4,s3
 7a8:	6685                	lui	a3,0x1
 7aa:	00d77363          	bgeu	a4,a3,7b0 <malloc+0x44>
 7ae:	6a05                	lui	s4,0x1
 7b0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7b4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b8:	00001917          	auipc	s2,0x1
 7bc:	84890913          	addi	s2,s2,-1976 # 1000 <freep>
  if(p == (char*)-1)
 7c0:	5afd                	li	s5,-1
 7c2:	a0bd                	j	830 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 7c4:	00001797          	auipc	a5,0x1
 7c8:	84c78793          	addi	a5,a5,-1972 # 1010 <base>
 7cc:	00001717          	auipc	a4,0x1
 7d0:	82f73a23          	sd	a5,-1996(a4) # 1000 <freep>
 7d4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7d6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7da:	b7e1                	j	7a2 <malloc+0x36>
      if(p->s.size == nunits)
 7dc:	02e48b63          	beq	s1,a4,812 <malloc+0xa6>
        p->s.size -= nunits;
 7e0:	4137073b          	subw	a4,a4,s3
 7e4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7e6:	1702                	slli	a4,a4,0x20
 7e8:	9301                	srli	a4,a4,0x20
 7ea:	0712                	slli	a4,a4,0x4
 7ec:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7ee:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7f2:	00001717          	auipc	a4,0x1
 7f6:	80a73723          	sd	a0,-2034(a4) # 1000 <freep>
      return (void*)(p + 1);
 7fa:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7fe:	70e2                	ld	ra,56(sp)
 800:	7442                	ld	s0,48(sp)
 802:	74a2                	ld	s1,40(sp)
 804:	7902                	ld	s2,32(sp)
 806:	69e2                	ld	s3,24(sp)
 808:	6a42                	ld	s4,16(sp)
 80a:	6aa2                	ld	s5,8(sp)
 80c:	6b02                	ld	s6,0(sp)
 80e:	6121                	addi	sp,sp,64
 810:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 812:	6398                	ld	a4,0(a5)
 814:	e118                	sd	a4,0(a0)
 816:	bff1                	j	7f2 <malloc+0x86>
  hp->s.size = nu;
 818:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 81c:	0541                	addi	a0,a0,16
 81e:	ec7ff0ef          	jal	ra,6e4 <free>
  return freep;
 822:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 826:	dd61                	beqz	a0,7fe <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 828:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82a:	4798                	lw	a4,8(a5)
 82c:	fa9778e3          	bgeu	a4,s1,7dc <malloc+0x70>
    if(p == freep)
 830:	00093703          	ld	a4,0(s2)
 834:	853e                	mv	a0,a5
 836:	fef719e3          	bne	a4,a5,828 <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 83a:	8552                	mv	a0,s4
 83c:	addff0ef          	jal	ra,318 <sbrk>
  if(p == (char*)-1)
 840:	fd551ce3          	bne	a0,s5,818 <malloc+0xac>
        return 0;
 844:	4501                	li	a0,0
 846:	bf65                	j	7fe <malloc+0x92>
