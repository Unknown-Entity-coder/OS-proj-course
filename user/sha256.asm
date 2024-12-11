
user/_sha256:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sha256_transform>:
    uint64 bitlen; // Total length of the processed data in bits --@Qamar
    uint32 state[8]; // Hash state --@Qamar
} SHA256_CTX;

// Function to perform the SHA-256 transformation --@Qamar
void sha256_transform(SHA256_CTX *ctx, uint8 data[]) {
   0:	714d                	addi	sp,sp,-336
   2:	e6a2                	sd	s0,328(sp)
   4:	e2a6                	sd	s1,320(sp)
   6:	fe4a                	sd	s2,312(sp)
   8:	fa4e                	sd	s3,304(sp)
   a:	f652                	sd	s4,296(sp)
   c:	f256                	sd	s5,288(sp)
   e:	ee5a                	sd	s6,280(sp)
  10:	ea5e                	sd	s7,272(sp)
  12:	e662                	sd	s8,264(sp)
  14:	e266                	sd	s9,256(sp)
  16:	0a80                	addi	s0,sp,336
    uint32 a, b, c, d, e, f, g, h, i, j, t1, t2, m[64]; 

    // Prepare the message schedule from the input data --@Qamar
    for (i = 0, j = 0; i < 16; ++i, j += 4)
  18:	eb040e13          	addi	t3,s0,-336
  1c:	ef040613          	addi	a2,s0,-272
void sha256_transform(SHA256_CTX *ctx, uint8 data[]) {
  20:	8772                	mv	a4,t3
        m[i] = (data[j] << 24) | (data[j + 1] << 16) | (data[j + 2] << 8) | (data[j + 3]);
  22:	0005c783          	lbu	a5,0(a1)
  26:	0187979b          	slliw	a5,a5,0x18
  2a:	0015c683          	lbu	a3,1(a1)
  2e:	0106969b          	slliw	a3,a3,0x10
  32:	8fd5                	or	a5,a5,a3
  34:	0035c683          	lbu	a3,3(a1)
  38:	8fd5                	or	a5,a5,a3
  3a:	0025c683          	lbu	a3,2(a1)
  3e:	0086969b          	slliw	a3,a3,0x8
  42:	8fd5                	or	a5,a5,a3
  44:	c31c                	sw	a5,0(a4)
    for (i = 0, j = 0; i < 16; ++i, j += 4)
  46:	0591                	addi	a1,a1,4
  48:	0711                	addi	a4,a4,4
  4a:	fcc71ce3          	bne	a4,a2,22 <sha256_transform+0x22>
    for (; i < 64; ++i)
  4e:	0c0e0893          	addi	a7,t3,192
    for (i = 0, j = 0; i < 16; ++i, j += 4)
  52:	87f2                	mv	a5,t3
        m[i] = SIG1(m[i - 2]) + m[i - 7] + SIG0(m[i - 15]) + m[i - 16];
  54:	5f8c                	lw	a1,56(a5)
  56:	43d0                	lw	a2,4(a5)
  58:	00f5971b          	slliw	a4,a1,0xf
  5c:	0115d69b          	srliw	a3,a1,0x11
  60:	8f55                	or	a4,a4,a3
  62:	00d5969b          	slliw	a3,a1,0xd
  66:	0135d81b          	srliw	a6,a1,0x13
  6a:	0106e6b3          	or	a3,a3,a6
  6e:	8f35                	xor	a4,a4,a3
  70:	00a5d69b          	srliw	a3,a1,0xa
  74:	8eb9                	xor	a3,a3,a4
  76:	53d8                	lw	a4,36(a5)
  78:	438c                	lw	a1,0(a5)
  7a:	9f2d                	addw	a4,a4,a1
  7c:	9f35                	addw	a4,a4,a3
  7e:	0076569b          	srliw	a3,a2,0x7
  82:	0196159b          	slliw	a1,a2,0x19
  86:	8ecd                	or	a3,a3,a1
  88:	00e6159b          	slliw	a1,a2,0xe
  8c:	0126581b          	srliw	a6,a2,0x12
  90:	0105e5b3          	or	a1,a1,a6
  94:	8ead                	xor	a3,a3,a1
  96:	0036561b          	srliw	a2,a2,0x3
  9a:	8eb1                	xor	a3,a3,a2
  9c:	9f35                	addw	a4,a4,a3
  9e:	c3b8                	sw	a4,64(a5)
    for (; i < 64; ++i)
  a0:	0791                	addi	a5,a5,4
  a2:	faf899e3          	bne	a7,a5,54 <sha256_transform+0x54>

    // Initialize working variables with the current hash state --@Qamar
    a = ctx->state[0];
  a6:	05052b03          	lw	s6,80(a0)
    b = ctx->state[1];
  aa:	05452a83          	lw	s5,84(a0)
    c = ctx->state[2];
  ae:	05852a03          	lw	s4,88(a0)
    d = ctx->state[3];
  b2:	05c52983          	lw	s3,92(a0)
    e = ctx->state[4];
  b6:	06052903          	lw	s2,96(a0)
    f = ctx->state[5];
  ba:	5164                	lw	s1,100(a0)
    g = ctx->state[6];
  bc:	06852383          	lw	t2,104(a0)
    h = ctx->state[7];
  c0:	06c52283          	lw	t0,108(a0)

    // Perform the main hash computation --@Qamar
    for (i = 0; i < 64; ++i) {
  c4:	00001317          	auipc	t1,0x1
  c8:	dfc30313          	addi	t1,t1,-516 # ec0 <k>
  cc:	00001f97          	auipc	t6,0x1
  d0:	ef4f8f93          	addi	t6,t6,-268 # fc0 <k+0x100>
    h = ctx->state[7];
  d4:	8b96                	mv	s7,t0
    g = ctx->state[6];
  d6:	8e9e                	mv	t4,t2
    f = ctx->state[5];
  d8:	8826                	mv	a6,s1
    e = ctx->state[4];
  da:	86ca                	mv	a3,s2
    d = ctx->state[3];
  dc:	8f4e                	mv	t5,s3
    c = ctx->state[2];
  de:	88d2                	mv	a7,s4
    b = ctx->state[1];
  e0:	85d6                	mv	a1,s5
    a = ctx->state[0];
  e2:	865a                	mv	a2,s6
  e4:	a039                	j	f2 <sha256_transform+0xf2>
  e6:	8ec2                	mv	t4,a6
  e8:	883a                	mv	a6,a4
        t1 = h + EP1(e) + CH(e, f, g) + k[i] + m[i];
        t2 = EP0(a) + MAJ(a, b, c);
        h = g;
        g = f;
        f = e;
        e = d + t1;
  ea:	86e2                	mv	a3,s8
  ec:	88ae                	mv	a7,a1
  ee:	85e6                	mv	a1,s9
        d = c;
        c = b;
        b = a;
        a = t1 + t2;
  f0:	863e                	mv	a2,a5
        t1 = h + EP1(e) + CH(e, f, g) + k[i] + m[i];
  f2:	0066d79b          	srliw	a5,a3,0x6
  f6:	01a6971b          	slliw	a4,a3,0x1a
  fa:	8fd9                	or	a5,a5,a4
  fc:	00b6d71b          	srliw	a4,a3,0xb
 100:	01569c1b          	slliw	s8,a3,0x15
 104:	01876733          	or	a4,a4,s8
 108:	8fb9                	xor	a5,a5,a4
 10a:	0076971b          	slliw	a4,a3,0x7
 10e:	0196dc1b          	srliw	s8,a3,0x19
 112:	01876733          	or	a4,a4,s8
 116:	8f3d                	xor	a4,a4,a5
 118:	00032783          	lw	a5,0(t1)
 11c:	000e2c03          	lw	s8,0(t3)
 120:	018787bb          	addw	a5,a5,s8
 124:	9fb9                	addw	a5,a5,a4
 126:	fff6c713          	not	a4,a3
 12a:	01d77733          	and	a4,a4,t4
 12e:	0106fc33          	and	s8,a3,a6
 132:	01874733          	xor	a4,a4,s8
 136:	9fb9                	addw	a5,a5,a4
 138:	017787bb          	addw	a5,a5,s7
        t2 = EP0(a) + MAJ(a, b, c);
 13c:	0026571b          	srliw	a4,a2,0x2
 140:	01e61b9b          	slliw	s7,a2,0x1e
 144:	01776733          	or	a4,a4,s7
 148:	00d65b9b          	srliw	s7,a2,0xd
 14c:	01361c1b          	slliw	s8,a2,0x13
 150:	018bebb3          	or	s7,s7,s8
 154:	01774733          	xor	a4,a4,s7
 158:	00a61b9b          	slliw	s7,a2,0xa
 15c:	01665c1b          	srliw	s8,a2,0x16
 160:	018bebb3          	or	s7,s7,s8
 164:	01774733          	xor	a4,a4,s7
 168:	0115cbb3          	xor	s7,a1,a7
 16c:	01767bb3          	and	s7,a2,s7
 170:	0115fc33          	and	s8,a1,a7
 174:	018bcbb3          	xor	s7,s7,s8
 178:	0177073b          	addw	a4,a4,s7
        e = d + t1;
 17c:	2681                	sext.w	a3,a3
 17e:	01e78c3b          	addw	s8,a5,t5
        a = t1 + t2;
 182:	2601                	sext.w	a2,a2
 184:	9fb9                	addw	a5,a5,a4
    for (i = 0; i < 64; ++i) {
 186:	0311                	addi	t1,t1,4
 188:	0e11                	addi	t3,t3,4
 18a:	00060c9b          	sext.w	s9,a2
 18e:	2581                	sext.w	a1,a1
 190:	00088f1b          	sext.w	t5,a7
 194:	0006871b          	sext.w	a4,a3
 198:	2801                	sext.w	a6,a6
 19a:	000e8b9b          	sext.w	s7,t4
 19e:	f5f314e3          	bne	t1,t6,e6 <sha256_transform+0xe6>
    }

    // Update the hash state with the results of this chunk --@Qamar
    ctx->state[0] += a;
 1a2:	00fb07bb          	addw	a5,s6,a5
 1a6:	c93c                	sw	a5,80(a0)
    ctx->state[1] += b;
 1a8:	00ca863b          	addw	a2,s5,a2
 1ac:	c970                	sw	a2,84(a0)
    ctx->state[2] += c;
 1ae:	00ba05bb          	addw	a1,s4,a1
 1b2:	cd2c                	sw	a1,88(a0)
    ctx->state[3] += d;
 1b4:	011988bb          	addw	a7,s3,a7
 1b8:	05152e23          	sw	a7,92(a0)
    ctx->state[4] += e;
 1bc:	0189093b          	addw	s2,s2,s8
 1c0:	07252023          	sw	s2,96(a0)
    ctx->state[5] += f;
 1c4:	9ea5                	addw	a3,a3,s1
 1c6:	d174                	sw	a3,100(a0)
    ctx->state[6] += g;
 1c8:	0103883b          	addw	a6,t2,a6
 1cc:	07052423          	sw	a6,104(a0)
    ctx->state[7] += h;
 1d0:	01d28ebb          	addw	t4,t0,t4
 1d4:	07d52623          	sw	t4,108(a0)
}
 1d8:	6436                	ld	s0,328(sp)
 1da:	6496                	ld	s1,320(sp)
 1dc:	7972                	ld	s2,312(sp)
 1de:	79d2                	ld	s3,304(sp)
 1e0:	7a32                	ld	s4,296(sp)
 1e2:	7a92                	ld	s5,288(sp)
 1e4:	6b72                	ld	s6,280(sp)
 1e6:	6bd2                	ld	s7,272(sp)
 1e8:	6c32                	ld	s8,264(sp)
 1ea:	6c92                	ld	s9,256(sp)
 1ec:	6171                	addi	sp,sp,336
 1ee:	8082                	ret

00000000000001f0 <sha256_init>:

// Function to initialize the SHA-256 context --@Qamar
void sha256_init(SHA256_CTX *ctx) {
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
    ctx->datalen = 0; // Initialize datalen to 0 --@Qamar
 1f6:	04052023          	sw	zero,64(a0)
    ctx->bitlen = 0; // Initialize bitlen to 0 --@Qamar
 1fa:	04053423          	sd	zero,72(a0)
    ctx->state[0] = 0x6a09e667; 
 1fe:	6a09e7b7          	lui	a5,0x6a09e
 202:	66778793          	addi	a5,a5,1639 # 6a09e667 <base+0x6a09d657>
 206:	c93c                	sw	a5,80(a0)
    ctx->state[1] = 0xbb67ae85; 
 208:	bb67b7b7          	lui	a5,0xbb67b
 20c:	e8578793          	addi	a5,a5,-379 # ffffffffbb67ae85 <base+0xffffffffbb679e75>
 210:	c97c                	sw	a5,84(a0)
    ctx->state[2] = 0x3c6ef372; 
 212:	3c6ef7b7          	lui	a5,0x3c6ef
 216:	37278793          	addi	a5,a5,882 # 3c6ef372 <base+0x3c6ee362>
 21a:	cd3c                	sw	a5,88(a0)
    ctx->state[3] = 0xa54ff53a;
 21c:	a54ff7b7          	lui	a5,0xa54ff
 220:	53a78793          	addi	a5,a5,1338 # ffffffffa54ff53a <base+0xffffffffa54fe52a>
 224:	cd7c                	sw	a5,92(a0)
    ctx->state[4] = 0x510e527f; 
 226:	510e57b7          	lui	a5,0x510e5
 22a:	27f78793          	addi	a5,a5,639 # 510e527f <base+0x510e426f>
 22e:	d13c                	sw	a5,96(a0)
    ctx->state[5] = 0x9b05688c; 
 230:	9b0577b7          	lui	a5,0x9b057
 234:	88c78793          	addi	a5,a5,-1908 # ffffffff9b05688c <base+0xffffffff9b05587c>
 238:	d17c                	sw	a5,100(a0)
    ctx->state[6] = 0x1f83d9ab; 
 23a:	1f83e7b7          	lui	a5,0x1f83e
 23e:	9ab78793          	addi	a5,a5,-1621 # 1f83d9ab <base+0x1f83c99b>
 242:	d53c                	sw	a5,104(a0)
    ctx->state[7] = 0x5be0cd19; 
 244:	5be0d7b7          	lui	a5,0x5be0d
 248:	d1978793          	addi	a5,a5,-743 # 5be0cd19 <base+0x5be0bd09>
 24c:	d57c                	sw	a5,108(a0)
}
 24e:	6422                	ld	s0,8(sp)
 250:	0141                	addi	sp,sp,16
 252:	8082                	ret

0000000000000254 <sha256_update>:

// Function to update the SHA-256 context with new data --@Qamar
void sha256_update(SHA256_CTX *ctx, uint8 data[], uint len) {
    for (uint i = 0; i < len; ++i) {
 254:	ca2d                	beqz	a2,2c6 <sha256_update+0x72>
void sha256_update(SHA256_CTX *ctx, uint8 data[], uint len) {
 256:	7179                	addi	sp,sp,-48
 258:	f406                	sd	ra,40(sp)
 25a:	f022                	sd	s0,32(sp)
 25c:	ec26                	sd	s1,24(sp)
 25e:	e84a                	sd	s2,16(sp)
 260:	e44e                	sd	s3,8(sp)
 262:	e052                	sd	s4,0(sp)
 264:	1800                	addi	s0,sp,48
 266:	84aa                	mv	s1,a0
 268:	892e                	mv	s2,a1
 26a:	0585                	addi	a1,a1,1
 26c:	367d                	addiw	a2,a2,-1
 26e:	1602                	slli	a2,a2,0x20
 270:	9201                	srli	a2,a2,0x20
 272:	00c589b3          	add	s3,a1,a2
        ctx->data[ctx->datalen] = data[i]; // Copy data to the context --@Qamar
        ctx->datalen++; // Increment datalen --@Qamar
        if (ctx->datalen == 64) { // If the data block is full --@Qamar
 276:	04000a13          	li	s4,64
 27a:	a021                	j	282 <sha256_update+0x2e>
    for (uint i = 0; i < len; ++i) {
 27c:	0905                	addi	s2,s2,1
 27e:	03390c63          	beq	s2,s3,2b6 <sha256_update+0x62>
        ctx->data[ctx->datalen] = data[i]; // Copy data to the context --@Qamar
 282:	40bc                	lw	a5,64(s1)
 284:	00094683          	lbu	a3,0(s2)
 288:	02079713          	slli	a4,a5,0x20
 28c:	9301                	srli	a4,a4,0x20
 28e:	9726                	add	a4,a4,s1
 290:	00d70023          	sb	a3,0(a4)
        ctx->datalen++; // Increment datalen --@Qamar
 294:	2785                	addiw	a5,a5,1
 296:	0007871b          	sext.w	a4,a5
 29a:	c0bc                	sw	a5,64(s1)
        if (ctx->datalen == 64) { // If the data block is full --@Qamar
 29c:	ff4710e3          	bne	a4,s4,27c <sha256_update+0x28>
            sha256_transform(ctx, ctx->data); // Transform the data --@Qamar
 2a0:	85a6                	mv	a1,s1
 2a2:	8526                	mv	a0,s1
 2a4:	d5dff0ef          	jal	ra,0 <sha256_transform>
            ctx->bitlen += 512; // Update bitlen --@Qamar
 2a8:	64bc                	ld	a5,72(s1)
 2aa:	20078793          	addi	a5,a5,512
 2ae:	e4bc                	sd	a5,72(s1)
            ctx->datalen = 0; // Reset datalen --@Qamar
 2b0:	0404a023          	sw	zero,64(s1)
 2b4:	b7e1                	j	27c <sha256_update+0x28>
        }
    }
}
 2b6:	70a2                	ld	ra,40(sp)
 2b8:	7402                	ld	s0,32(sp)
 2ba:	64e2                	ld	s1,24(sp)
 2bc:	6942                	ld	s2,16(sp)
 2be:	69a2                	ld	s3,8(sp)
 2c0:	6a02                	ld	s4,0(sp)
 2c2:	6145                	addi	sp,sp,48
 2c4:	8082                	ret
 2c6:	8082                	ret

00000000000002c8 <sha256_final>:

// Function to finalize the SHA-256 hash and produce the digest --@Qamar
void sha256_final(SHA256_CTX *ctx, uint8 hash[]) {
 2c8:	1101                	addi	sp,sp,-32
 2ca:	ec06                	sd	ra,24(sp)
 2cc:	e822                	sd	s0,16(sp)
 2ce:	e426                	sd	s1,8(sp)
 2d0:	e04a                	sd	s2,0(sp)
 2d2:	1000                	addi	s0,sp,32
 2d4:	84aa                	mv	s1,a0
 2d6:	892e                	mv	s2,a1
    uint32 i = ctx->datalen; // Get the current datalen --@Qamar
 2d8:	4134                	lw	a3,64(a0)

    // Pad the remaining data --@Qamar
    if (ctx->datalen < 56) {
 2da:	03700793          	li	a5,55
 2de:	04d7e763          	bltu	a5,a3,32c <sha256_final+0x64>
        ctx->data[i++] = 0x80; // Append a '1' bit --@Qamar
 2e2:	0016871b          	addiw	a4,a3,1
 2e6:	0007061b          	sext.w	a2,a4
 2ea:	02069793          	slli	a5,a3,0x20
 2ee:	9381                	srli	a5,a5,0x20
 2f0:	97aa                	add	a5,a5,a0
 2f2:	f8000593          	li	a1,-128
 2f6:	00b78023          	sb	a1,0(a5)
        while (i < 56) // Append '0' bits --@Qamar
 2fa:	03700793          	li	a5,55
 2fe:	08c7e563          	bltu	a5,a2,388 <sha256_final+0xc0>
 302:	02071613          	slli	a2,a4,0x20
 306:	9201                	srli	a2,a2,0x20
 308:	00c507b3          	add	a5,a0,a2
 30c:	00150713          	addi	a4,a0,1
 310:	9732                	add	a4,a4,a2
 312:	03600613          	li	a2,54
 316:	40d606bb          	subw	a3,a2,a3
 31a:	1682                	slli	a3,a3,0x20
 31c:	9281                	srli	a3,a3,0x20
 31e:	9736                	add	a4,a4,a3
            ctx->data[i++] = 0x00;
 320:	00078023          	sb	zero,0(a5)
        while (i < 56) // Append '0' bits --@Qamar
 324:	0785                	addi	a5,a5,1
 326:	fee79de3          	bne	a5,a4,320 <sha256_final+0x58>
 32a:	a8b9                	j	388 <sha256_final+0xc0>
    } else {
        ctx->data[i++] = 0x80; // Append a '1' bit --@Qamar
 32c:	0016871b          	addiw	a4,a3,1
 330:	0007061b          	sext.w	a2,a4
 334:	02069793          	slli	a5,a3,0x20
 338:	9381                	srli	a5,a5,0x20
 33a:	97aa                	add	a5,a5,a0
 33c:	f8000593          	li	a1,-128
 340:	00b78023          	sb	a1,0(a5)
        while (i < 64) // Append '0' bits --@Qamar
 344:	03f00793          	li	a5,63
 348:	02c7e663          	bltu	a5,a2,374 <sha256_final+0xac>
 34c:	02071613          	slli	a2,a4,0x20
 350:	9201                	srli	a2,a2,0x20
 352:	00c507b3          	add	a5,a0,a2
 356:	00150713          	addi	a4,a0,1
 35a:	9732                	add	a4,a4,a2
 35c:	03e00613          	li	a2,62
 360:	40d606bb          	subw	a3,a2,a3
 364:	1682                	slli	a3,a3,0x20
 366:	9281                	srli	a3,a3,0x20
 368:	9736                	add	a4,a4,a3
            ctx->data[i++] = 0x00;
 36a:	00078023          	sb	zero,0(a5)
        while (i < 64) // Append '0' bits --@Qamar
 36e:	0785                	addi	a5,a5,1
 370:	fee79de3          	bne	a5,a4,36a <sha256_final+0xa2>
        sha256_transform(ctx, ctx->data); // Transform the data --@Qamar
 374:	85a6                	mv	a1,s1
 376:	8526                	mv	a0,s1
 378:	c89ff0ef          	jal	ra,0 <sha256_transform>
        memset(ctx->data, 0, 56); // Clear the data block --@Qamar
 37c:	03800613          	li	a2,56
 380:	4581                	li	a1,0
 382:	8526                	mv	a0,s1
 384:	2f6000ef          	jal	ra,67a <memset>
    }

    // Append the total length of the data --@Qamar
    ctx->bitlen += ctx->datalen * 8; // Update bitlen --@Qamar
 388:	40bc                	lw	a5,64(s1)
 38a:	0037979b          	slliw	a5,a5,0x3
 38e:	1782                	slli	a5,a5,0x20
 390:	9381                	srli	a5,a5,0x20
 392:	64b8                	ld	a4,72(s1)
 394:	97ba                	add	a5,a5,a4
 396:	e4bc                	sd	a5,72(s1)
    ctx->data[63] = ctx->bitlen; // Append bitlen --@Qamar
 398:	02f48fa3          	sb	a5,63(s1)
    ctx->data[62] = ctx->bitlen >> 8; 
 39c:	0087d713          	srli	a4,a5,0x8
 3a0:	02e48f23          	sb	a4,62(s1)
    ctx->data[61] = ctx->bitlen >> 16; 
 3a4:	0107d713          	srli	a4,a5,0x10
 3a8:	02e48ea3          	sb	a4,61(s1)
    ctx->data[60] = ctx->bitlen >> 24; 
 3ac:	0187d713          	srli	a4,a5,0x18
 3b0:	02e48e23          	sb	a4,60(s1)
    ctx->data[59] = ctx->bitlen >> 32; 
 3b4:	0207d713          	srli	a4,a5,0x20
 3b8:	02e48da3          	sb	a4,59(s1)
    ctx->data[58] = ctx->bitlen >> 40; 
 3bc:	0287d713          	srli	a4,a5,0x28
 3c0:	02e48d23          	sb	a4,58(s1)
    ctx->data[57] = ctx->bitlen >> 48; 
 3c4:	0307d713          	srli	a4,a5,0x30
 3c8:	02e48ca3          	sb	a4,57(s1)
    ctx->data[56] = ctx->bitlen >> 56; 
 3cc:	93e1                	srli	a5,a5,0x38
 3ce:	02f48c23          	sb	a5,56(s1)
    sha256_transform(ctx, ctx->data); // Transform the data --@Qamar
 3d2:	85a6                	mv	a1,s1
 3d4:	8526                	mv	a0,s1
 3d6:	c2bff0ef          	jal	ra,0 <sha256_transform>

    // Produce the final hash value --@Qamar
    for (i = 0; i < 4; ++i) {
 3da:	85ca                	mv	a1,s2
    sha256_transform(ctx, ctx->data); // Transform the data --@Qamar
 3dc:	47e1                	li	a5,24
    for (i = 0; i < 4; ++i) {
 3de:	56e1                	li	a3,-8
        hash[i] = (ctx->state[0] >> (24 - i * 8)) & 0x000000ff;
 3e0:	48b8                	lw	a4,80(s1)
 3e2:	00f7573b          	srlw	a4,a4,a5
 3e6:	00e58023          	sb	a4,0(a1)
        hash[i + 4] = (ctx->state[1] >> (24 - i * 8)) & 0x000000ff;
 3ea:	48f8                	lw	a4,84(s1)
 3ec:	00f7573b          	srlw	a4,a4,a5
 3f0:	00e58223          	sb	a4,4(a1)
        hash[i + 8] = (ctx->state[2] >> (24 - i * 8)) & 0x000000ff;
 3f4:	4cb8                	lw	a4,88(s1)
 3f6:	00f7573b          	srlw	a4,a4,a5
 3fa:	00e58423          	sb	a4,8(a1)
        hash[i + 12] = (ctx->state[3] >> (24 - i * 8)) & 0x000000ff;
 3fe:	4cf8                	lw	a4,92(s1)
 400:	00f7573b          	srlw	a4,a4,a5
 404:	00e58623          	sb	a4,12(a1)
        hash[i + 16] = (ctx->state[4] >> (24 - i * 8)) & 0x000000ff;
 408:	50b8                	lw	a4,96(s1)
 40a:	00f7573b          	srlw	a4,a4,a5
 40e:	00e58823          	sb	a4,16(a1)
        hash[i + 20] = (ctx->state[5] >> (24 - i * 8)) & 0x000000ff;
 412:	50f8                	lw	a4,100(s1)
 414:	00f7573b          	srlw	a4,a4,a5
 418:	00e58a23          	sb	a4,20(a1)
        hash[i + 24] = (ctx->state[6] >> (24 - i * 8)) & 0x000000ff;
 41c:	54b8                	lw	a4,104(s1)
 41e:	00f7573b          	srlw	a4,a4,a5
 422:	00e58c23          	sb	a4,24(a1)
        hash[i + 28] = (ctx->state[7] >> (24 - i * 8)) & 0x000000ff;
 426:	54f8                	lw	a4,108(s1)
 428:	00f7573b          	srlw	a4,a4,a5
 42c:	00e58e23          	sb	a4,28(a1)
    for (i = 0; i < 4; ++i) {
 430:	37e1                	addiw	a5,a5,-8
 432:	0585                	addi	a1,a1,1
 434:	fad796e3          	bne	a5,a3,3e0 <sha256_final+0x118>
    }
}
 438:	60e2                	ld	ra,24(sp)
 43a:	6442                	ld	s0,16(sp)
 43c:	64a2                	ld	s1,8(sp)
 43e:	6902                	ld	s2,0(sp)
 440:	6105                	addi	sp,sp,32
 442:	8082                	ret

0000000000000444 <byte_to_hex>:

// Function to convert a byte to a hexadecimal string --@Qamar
void byte_to_hex(uint8 byte, char* hex_str) {
 444:	7179                	addi	sp,sp,-48
 446:	f422                	sd	s0,40(sp)
 448:	1800                	addi	s0,sp,48
    const char hex_chars[] = "0123456789abcdef"; // Hexadecimal characters --@Qamar
 44a:	00001797          	auipc	a5,0x1
 44e:	9d678793          	addi	a5,a5,-1578 # e20 <malloc+0xe2>
 452:	6398                	ld	a4,0(a5)
 454:	fce43c23          	sd	a4,-40(s0)
 458:	679c                	ld	a5,8(a5)
 45a:	fef43023          	sd	a5,-32(s0)
    hex_str[0] = hex_chars[(byte >> 4) & 0x0F]; // Convert high nibble to hex --@Qamar
 45e:	00455793          	srli	a5,a0,0x4
 462:	ff040713          	addi	a4,s0,-16
 466:	97ba                	add	a5,a5,a4
 468:	fe87c783          	lbu	a5,-24(a5)
 46c:	00f58023          	sb	a5,0(a1)
    hex_str[1] = hex_chars[byte & 0x0F]; // Convert low nibble to hex --@Qamar
 470:	893d                	andi	a0,a0,15
 472:	953a                	add	a0,a0,a4
 474:	fe854783          	lbu	a5,-24(a0)
 478:	00f580a3          	sb	a5,1(a1)
}
 47c:	7422                	ld	s0,40(sp)
 47e:	6145                	addi	sp,sp,48
 480:	8082                	ret

0000000000000482 <main>:



// the main function for the user space implementation --@Qamar

int main(int argc, char *argv[]) {
 482:	715d                	addi	sp,sp,-80
 484:	e486                	sd	ra,72(sp)
 486:	e0a2                	sd	s0,64(sp)
 488:	fc26                	sd	s1,56(sp)
 48a:	f84a                	sd	s2,48(sp)
 48c:	f44e                	sd	s3,40(sp)
 48e:	f052                	sd	s4,32(sp)
 490:	ec56                	sd	s5,24(sp)
 492:	0880                	addi	s0,sp,80
 494:	7379                	lui	t1,0xffffe
 496:	82030313          	addi	t1,t1,-2016 # ffffffffffffd820 <base+0xffffffffffffc810>
 49a:	911a                	add	sp,sp,t1
 49c:	8aae                	mv	s5,a1
    if (argc != 2) {
 49e:	4789                	li	a5,2
 4a0:	02f51563          	bne	a0,a5,4ca <main+0x48>
        printf("Usage: %s <filename>\n", argv[0]);
        exit(1);
    }

    int fd = open(argv[1], O_RDONLY);
 4a4:	4581                	li	a1,0
 4a6:	008ab503          	ld	a0,8(s5)
 4aa:	3f8000ef          	jal	ra,8a2 <open>
 4ae:	892a                	mv	s2,a0
    if (fd < 0) {
 4b0:	02054763          	bltz	a0,4de <main+0x5c>
    uint8 hash[32];
    char hex_output[65];
    int i = 0;


  while ((bytesRead = read(fd, buffer, sizeof(buffer))) > 0) {
 4b4:	79f9                	lui	s3,0xffffe
 4b6:	8f098493          	addi	s1,s3,-1808 # ffffffffffffd8f0 <base+0xffffffffffffc8e0>
 4ba:	fc040793          	addi	a5,s0,-64
 4be:	94be                	add	s1,s1,a5
 4c0:	6a09                	lui	s4,0x2
 4c2:	710a0a13          	addi	s4,s4,1808 # 2710 <base+0x1700>
    // Remove the last character. The last character is a txt file is always a /n and we need to remove it as it could ruin the hash --@Qamar
    if (bytesRead > 0) {
        buffer[bytesRead - 1] = '\0';  
 4c6:	99be                	add	s3,s3,a5
 4c8:	a081                	j	508 <main+0x86>
        printf("Usage: %s <filename>\n", argv[0]);
 4ca:	618c                	ld	a1,0(a1)
 4cc:	00001517          	auipc	a0,0x1
 4d0:	96c50513          	addi	a0,a0,-1684 # e38 <malloc+0xfa>
 4d4:	7b0000ef          	jal	ra,c84 <printf>
        exit(1);
 4d8:	4505                	li	a0,1
 4da:	388000ef          	jal	ra,862 <exit>
        printf("Error: cannot open file %s\n", argv[1]);
 4de:	008ab583          	ld	a1,8(s5)
 4e2:	00001517          	auipc	a0,0x1
 4e6:	96e50513          	addi	a0,a0,-1682 # e50 <malloc+0x112>
 4ea:	79a000ef          	jal	ra,c84 <printf>
        exit(1);
 4ee:	4505                	li	a0,1
 4f0:	372000ef          	jal	ra,862 <exit>
        buffer[bytesRead - 1] = '\0';  
 4f4:	fff5061b          	addiw	a2,a0,-1
 4f8:	00c987b3          	add	a5,s3,a2
 4fc:	8e078823          	sb	zero,-1808(a5)
    }

    // Print the buffer, excluding the last character --@Qamar
    write(1, buffer, bytesRead - 1);  
 500:	85a6                	mv	a1,s1
 502:	4505                	li	a0,1
 504:	37e000ef          	jal	ra,882 <write>
  while ((bytesRead = read(fd, buffer, sizeof(buffer))) > 0) {
 508:	8652                	mv	a2,s4
 50a:	85a6                	mv	a1,s1
 50c:	854a                	mv	a0,s2
 50e:	36c000ef          	jal	ra,87a <read>
 512:	fea041e3          	bgtz	a0,4f4 <main+0x72>
}
	 
    if (bytesRead < 0) {
 516:	0c054263          	bltz	a0,5da <main+0x158>
        printf("Error: reading file %s\n", argv[1]);
        close(fd);
        exit(1);
    }
    
    close(fd);
 51a:	854a                	mv	a0,s2
 51c:	36e000ef          	jal	ra,88a <close>
    
    
    int start_time = time();
 520:	3e2000ef          	jal	ra,902 <time>
 524:	8a2a                	mv	s4,a0
    
    // these are the actual hashing functions -- @Qamar
    sha256_init(&ctx);
 526:	74f9                	lui	s1,0xffffe
 528:	88048993          	addi	s3,s1,-1920 # ffffffffffffd880 <base+0xffffffffffffc870>
 52c:	fc040793          	addi	a5,s0,-64
 530:	99be                	add	s3,s3,a5
 532:	854e                	mv	a0,s3
 534:	cbdff0ef          	jal	ra,1f0 <sha256_init>
    sha256_update(&ctx,(uint8*) buffer, strlen(buffer));
 538:	8f048913          	addi	s2,s1,-1808
 53c:	fc040793          	addi	a5,s0,-64
 540:	993e                	add	s2,s2,a5
 542:	854a                	mv	a0,s2
 544:	10c000ef          	jal	ra,650 <strlen>
 548:	0005061b          	sext.w	a2,a0
 54c:	85ca                	mv	a1,s2
 54e:	854e                	mv	a0,s3
 550:	d05ff0ef          	jal	ra,254 <sha256_update>
    sha256_final(&ctx, hash);
 554:	86048913          	addi	s2,s1,-1952
 558:	fc040793          	addi	a5,s0,-64
 55c:	993e                	add	s2,s2,a5
 55e:	85ca                	mv	a1,s2
 560:	854e                	mv	a0,s3
 562:	d67ff0ef          	jal	ra,2c8 <sha256_final>
    
    int end_time = time();
 566:	39c000ef          	jal	ra,902 <time>
    
    int final_time = end_time - start_time;
 56a:	41450a3b          	subw	s4,a0,s4


// this for loop is for conveting the bytes to hex. Xv6 does not support hexadecimals so we have to output is as a string --@Qamar
    for (i = 0; i < 32; i++) {
 56e:	81848493          	addi	s1,s1,-2024
 572:	fc040793          	addi	a5,s0,-64
 576:	94be                	add	s1,s1,a5
 578:	04048993          	addi	s3,s1,64
        byte_to_hex(hash[i], &hex_output[i * 2]);
 57c:	85a6                	mv	a1,s1
 57e:	00094503          	lbu	a0,0(s2)
 582:	ec3ff0ef          	jal	ra,444 <byte_to_hex>
    for (i = 0; i < 32; i++) {
 586:	0905                	addi	s2,s2,1
 588:	0489                	addi	s1,s1,2
 58a:	ff3499e3          	bne	s1,s3,57c <main+0xfa>
    }
    hex_output[64] = '\0'; // Null-terminate the string
 58e:	75f9                	lui	a1,0xffffe
 590:	fc040793          	addi	a5,s0,-64
 594:	97ae                	add	a5,a5,a1
 596:	84078c23          	sb	zero,-1960(a5)

    printf("\nSHA-256 hash =  %s\n", hex_output);
 59a:	81858593          	addi	a1,a1,-2024 # ffffffffffffd818 <base+0xffffffffffffc808>
 59e:	fc040793          	addi	a5,s0,-64
 5a2:	95be                	add	a1,a1,a5
 5a4:	00001517          	auipc	a0,0x1
 5a8:	8e450513          	addi	a0,a0,-1820 # e88 <malloc+0x14a>
 5ac:	6d8000ef          	jal	ra,c84 <printf>
    printf("Computation in Ticks =  %d\n", final_time);
 5b0:	85d2                	mv	a1,s4
 5b2:	00001517          	auipc	a0,0x1
 5b6:	8ee50513          	addi	a0,a0,-1810 # ea0 <malloc+0x162>
 5ba:	6ca000ef          	jal	ra,c84 <printf>


    return 0;
}
 5be:	4501                	li	a0,0
 5c0:	6309                	lui	t1,0x2
 5c2:	7e030313          	addi	t1,t1,2016 # 27e0 <base+0x17d0>
 5c6:	911a                	add	sp,sp,t1
 5c8:	60a6                	ld	ra,72(sp)
 5ca:	6406                	ld	s0,64(sp)
 5cc:	74e2                	ld	s1,56(sp)
 5ce:	7942                	ld	s2,48(sp)
 5d0:	79a2                	ld	s3,40(sp)
 5d2:	7a02                	ld	s4,32(sp)
 5d4:	6ae2                	ld	s5,24(sp)
 5d6:	6161                	addi	sp,sp,80
 5d8:	8082                	ret
        printf("Error: reading file %s\n", argv[1]);
 5da:	008ab583          	ld	a1,8(s5)
 5de:	00001517          	auipc	a0,0x1
 5e2:	89250513          	addi	a0,a0,-1902 # e70 <malloc+0x132>
 5e6:	69e000ef          	jal	ra,c84 <printf>
        close(fd);
 5ea:	854a                	mv	a0,s2
 5ec:	29e000ef          	jal	ra,88a <close>
        exit(1);
 5f0:	4505                	li	a0,1
 5f2:	270000ef          	jal	ra,862 <exit>

00000000000005f6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 5f6:	1141                	addi	sp,sp,-16
 5f8:	e406                	sd	ra,8(sp)
 5fa:	e022                	sd	s0,0(sp)
 5fc:	0800                	addi	s0,sp,16
  extern int main();
  main();
 5fe:	e85ff0ef          	jal	ra,482 <main>
  exit(0);
 602:	4501                	li	a0,0
 604:	25e000ef          	jal	ra,862 <exit>

0000000000000608 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 608:	1141                	addi	sp,sp,-16
 60a:	e422                	sd	s0,8(sp)
 60c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 60e:	87aa                	mv	a5,a0
 610:	0585                	addi	a1,a1,1
 612:	0785                	addi	a5,a5,1
 614:	fff5c703          	lbu	a4,-1(a1)
 618:	fee78fa3          	sb	a4,-1(a5)
 61c:	fb75                	bnez	a4,610 <strcpy+0x8>
    ;
  return os;
}
 61e:	6422                	ld	s0,8(sp)
 620:	0141                	addi	sp,sp,16
 622:	8082                	ret

0000000000000624 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 624:	1141                	addi	sp,sp,-16
 626:	e422                	sd	s0,8(sp)
 628:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 62a:	00054783          	lbu	a5,0(a0)
 62e:	cb91                	beqz	a5,642 <strcmp+0x1e>
 630:	0005c703          	lbu	a4,0(a1)
 634:	00f71763          	bne	a4,a5,642 <strcmp+0x1e>
    p++, q++;
 638:	0505                	addi	a0,a0,1
 63a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 63c:	00054783          	lbu	a5,0(a0)
 640:	fbe5                	bnez	a5,630 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 642:	0005c503          	lbu	a0,0(a1)
}
 646:	40a7853b          	subw	a0,a5,a0
 64a:	6422                	ld	s0,8(sp)
 64c:	0141                	addi	sp,sp,16
 64e:	8082                	ret

0000000000000650 <strlen>:

uint
strlen(const char *s)
{
 650:	1141                	addi	sp,sp,-16
 652:	e422                	sd	s0,8(sp)
 654:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 656:	00054783          	lbu	a5,0(a0)
 65a:	cf91                	beqz	a5,676 <strlen+0x26>
 65c:	0505                	addi	a0,a0,1
 65e:	87aa                	mv	a5,a0
 660:	4685                	li	a3,1
 662:	9e89                	subw	a3,a3,a0
 664:	00f6853b          	addw	a0,a3,a5
 668:	0785                	addi	a5,a5,1
 66a:	fff7c703          	lbu	a4,-1(a5)
 66e:	fb7d                	bnez	a4,664 <strlen+0x14>
    ;
  return n;
}
 670:	6422                	ld	s0,8(sp)
 672:	0141                	addi	sp,sp,16
 674:	8082                	ret
  for(n = 0; s[n]; n++)
 676:	4501                	li	a0,0
 678:	bfe5                	j	670 <strlen+0x20>

000000000000067a <memset>:

void*
memset(void *dst, int c, uint n)
{
 67a:	1141                	addi	sp,sp,-16
 67c:	e422                	sd	s0,8(sp)
 67e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 680:	ca19                	beqz	a2,696 <memset+0x1c>
 682:	87aa                	mv	a5,a0
 684:	1602                	slli	a2,a2,0x20
 686:	9201                	srli	a2,a2,0x20
 688:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 68c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 690:	0785                	addi	a5,a5,1
 692:	fee79de3          	bne	a5,a4,68c <memset+0x12>
  }
  return dst;
}
 696:	6422                	ld	s0,8(sp)
 698:	0141                	addi	sp,sp,16
 69a:	8082                	ret

000000000000069c <strchr>:

char*
strchr(const char *s, char c)
{
 69c:	1141                	addi	sp,sp,-16
 69e:	e422                	sd	s0,8(sp)
 6a0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 6a2:	00054783          	lbu	a5,0(a0)
 6a6:	cb99                	beqz	a5,6bc <strchr+0x20>
    if(*s == c)
 6a8:	00f58763          	beq	a1,a5,6b6 <strchr+0x1a>
  for(; *s; s++)
 6ac:	0505                	addi	a0,a0,1
 6ae:	00054783          	lbu	a5,0(a0)
 6b2:	fbfd                	bnez	a5,6a8 <strchr+0xc>
      return (char*)s;
  return 0;
 6b4:	4501                	li	a0,0
}
 6b6:	6422                	ld	s0,8(sp)
 6b8:	0141                	addi	sp,sp,16
 6ba:	8082                	ret
  return 0;
 6bc:	4501                	li	a0,0
 6be:	bfe5                	j	6b6 <strchr+0x1a>

00000000000006c0 <gets>:

char*
gets(char *buf, int max)
{
 6c0:	711d                	addi	sp,sp,-96
 6c2:	ec86                	sd	ra,88(sp)
 6c4:	e8a2                	sd	s0,80(sp)
 6c6:	e4a6                	sd	s1,72(sp)
 6c8:	e0ca                	sd	s2,64(sp)
 6ca:	fc4e                	sd	s3,56(sp)
 6cc:	f852                	sd	s4,48(sp)
 6ce:	f456                	sd	s5,40(sp)
 6d0:	f05a                	sd	s6,32(sp)
 6d2:	ec5e                	sd	s7,24(sp)
 6d4:	1080                	addi	s0,sp,96
 6d6:	8baa                	mv	s7,a0
 6d8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6da:	892a                	mv	s2,a0
 6dc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 6de:	4aa9                	li	s5,10
 6e0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 6e2:	89a6                	mv	s3,s1
 6e4:	2485                	addiw	s1,s1,1
 6e6:	0344d663          	bge	s1,s4,712 <gets+0x52>
    cc = read(0, &c, 1);
 6ea:	4605                	li	a2,1
 6ec:	faf40593          	addi	a1,s0,-81
 6f0:	4501                	li	a0,0
 6f2:	188000ef          	jal	ra,87a <read>
    if(cc < 1)
 6f6:	00a05e63          	blez	a0,712 <gets+0x52>
    buf[i++] = c;
 6fa:	faf44783          	lbu	a5,-81(s0)
 6fe:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 702:	01578763          	beq	a5,s5,710 <gets+0x50>
 706:	0905                	addi	s2,s2,1
 708:	fd679de3          	bne	a5,s6,6e2 <gets+0x22>
  for(i=0; i+1 < max; ){
 70c:	89a6                	mv	s3,s1
 70e:	a011                	j	712 <gets+0x52>
 710:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 712:	99de                	add	s3,s3,s7
 714:	00098023          	sb	zero,0(s3)
  return buf;
}
 718:	855e                	mv	a0,s7
 71a:	60e6                	ld	ra,88(sp)
 71c:	6446                	ld	s0,80(sp)
 71e:	64a6                	ld	s1,72(sp)
 720:	6906                	ld	s2,64(sp)
 722:	79e2                	ld	s3,56(sp)
 724:	7a42                	ld	s4,48(sp)
 726:	7aa2                	ld	s5,40(sp)
 728:	7b02                	ld	s6,32(sp)
 72a:	6be2                	ld	s7,24(sp)
 72c:	6125                	addi	sp,sp,96
 72e:	8082                	ret

0000000000000730 <stat>:

int
stat(const char *n, struct stat *st)
{
 730:	1101                	addi	sp,sp,-32
 732:	ec06                	sd	ra,24(sp)
 734:	e822                	sd	s0,16(sp)
 736:	e426                	sd	s1,8(sp)
 738:	e04a                	sd	s2,0(sp)
 73a:	1000                	addi	s0,sp,32
 73c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 73e:	4581                	li	a1,0
 740:	162000ef          	jal	ra,8a2 <open>
  if(fd < 0)
 744:	02054163          	bltz	a0,766 <stat+0x36>
 748:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 74a:	85ca                	mv	a1,s2
 74c:	16e000ef          	jal	ra,8ba <fstat>
 750:	892a                	mv	s2,a0
  close(fd);
 752:	8526                	mv	a0,s1
 754:	136000ef          	jal	ra,88a <close>
  return r;
}
 758:	854a                	mv	a0,s2
 75a:	60e2                	ld	ra,24(sp)
 75c:	6442                	ld	s0,16(sp)
 75e:	64a2                	ld	s1,8(sp)
 760:	6902                	ld	s2,0(sp)
 762:	6105                	addi	sp,sp,32
 764:	8082                	ret
    return -1;
 766:	597d                	li	s2,-1
 768:	bfc5                	j	758 <stat+0x28>

000000000000076a <atoi>:

int
atoi(const char *s)
{
 76a:	1141                	addi	sp,sp,-16
 76c:	e422                	sd	s0,8(sp)
 76e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 770:	00054603          	lbu	a2,0(a0)
 774:	fd06079b          	addiw	a5,a2,-48
 778:	0ff7f793          	andi	a5,a5,255
 77c:	4725                	li	a4,9
 77e:	02f76963          	bltu	a4,a5,7b0 <atoi+0x46>
 782:	86aa                	mv	a3,a0
  n = 0;
 784:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 786:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 788:	0685                	addi	a3,a3,1
 78a:	0025179b          	slliw	a5,a0,0x2
 78e:	9fa9                	addw	a5,a5,a0
 790:	0017979b          	slliw	a5,a5,0x1
 794:	9fb1                	addw	a5,a5,a2
 796:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 79a:	0006c603          	lbu	a2,0(a3)
 79e:	fd06071b          	addiw	a4,a2,-48
 7a2:	0ff77713          	andi	a4,a4,255
 7a6:	fee5f1e3          	bgeu	a1,a4,788 <atoi+0x1e>
  return n;
}
 7aa:	6422                	ld	s0,8(sp)
 7ac:	0141                	addi	sp,sp,16
 7ae:	8082                	ret
  n = 0;
 7b0:	4501                	li	a0,0
 7b2:	bfe5                	j	7aa <atoi+0x40>

00000000000007b4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 7b4:	1141                	addi	sp,sp,-16
 7b6:	e422                	sd	s0,8(sp)
 7b8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 7ba:	02b57463          	bgeu	a0,a1,7e2 <memmove+0x2e>
    while(n-- > 0)
 7be:	00c05f63          	blez	a2,7dc <memmove+0x28>
 7c2:	1602                	slli	a2,a2,0x20
 7c4:	9201                	srli	a2,a2,0x20
 7c6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 7ca:	872a                	mv	a4,a0
      *dst++ = *src++;
 7cc:	0585                	addi	a1,a1,1
 7ce:	0705                	addi	a4,a4,1
 7d0:	fff5c683          	lbu	a3,-1(a1)
 7d4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 7d8:	fee79ae3          	bne	a5,a4,7cc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 7dc:	6422                	ld	s0,8(sp)
 7de:	0141                	addi	sp,sp,16
 7e0:	8082                	ret
    dst += n;
 7e2:	00c50733          	add	a4,a0,a2
    src += n;
 7e6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 7e8:	fec05ae3          	blez	a2,7dc <memmove+0x28>
 7ec:	fff6079b          	addiw	a5,a2,-1
 7f0:	1782                	slli	a5,a5,0x20
 7f2:	9381                	srli	a5,a5,0x20
 7f4:	fff7c793          	not	a5,a5
 7f8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 7fa:	15fd                	addi	a1,a1,-1
 7fc:	177d                	addi	a4,a4,-1
 7fe:	0005c683          	lbu	a3,0(a1)
 802:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 806:	fee79ae3          	bne	a5,a4,7fa <memmove+0x46>
 80a:	bfc9                	j	7dc <memmove+0x28>

000000000000080c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 80c:	1141                	addi	sp,sp,-16
 80e:	e422                	sd	s0,8(sp)
 810:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 812:	ca05                	beqz	a2,842 <memcmp+0x36>
 814:	fff6069b          	addiw	a3,a2,-1
 818:	1682                	slli	a3,a3,0x20
 81a:	9281                	srli	a3,a3,0x20
 81c:	0685                	addi	a3,a3,1
 81e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 820:	00054783          	lbu	a5,0(a0)
 824:	0005c703          	lbu	a4,0(a1)
 828:	00e79863          	bne	a5,a4,838 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 82c:	0505                	addi	a0,a0,1
    p2++;
 82e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 830:	fed518e3          	bne	a0,a3,820 <memcmp+0x14>
  }
  return 0;
 834:	4501                	li	a0,0
 836:	a019                	j	83c <memcmp+0x30>
      return *p1 - *p2;
 838:	40e7853b          	subw	a0,a5,a4
}
 83c:	6422                	ld	s0,8(sp)
 83e:	0141                	addi	sp,sp,16
 840:	8082                	ret
  return 0;
 842:	4501                	li	a0,0
 844:	bfe5                	j	83c <memcmp+0x30>

0000000000000846 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 846:	1141                	addi	sp,sp,-16
 848:	e406                	sd	ra,8(sp)
 84a:	e022                	sd	s0,0(sp)
 84c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 84e:	f67ff0ef          	jal	ra,7b4 <memmove>
}
 852:	60a2                	ld	ra,8(sp)
 854:	6402                	ld	s0,0(sp)
 856:	0141                	addi	sp,sp,16
 858:	8082                	ret

000000000000085a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 85a:	4885                	li	a7,1
 ecall
 85c:	00000073          	ecall
 ret
 860:	8082                	ret

0000000000000862 <exit>:
.global exit
exit:
 li a7, SYS_exit
 862:	4889                	li	a7,2
 ecall
 864:	00000073          	ecall
 ret
 868:	8082                	ret

000000000000086a <wait>:
.global wait
wait:
 li a7, SYS_wait
 86a:	488d                	li	a7,3
 ecall
 86c:	00000073          	ecall
 ret
 870:	8082                	ret

0000000000000872 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 872:	4891                	li	a7,4
 ecall
 874:	00000073          	ecall
 ret
 878:	8082                	ret

000000000000087a <read>:
.global read
read:
 li a7, SYS_read
 87a:	4895                	li	a7,5
 ecall
 87c:	00000073          	ecall
 ret
 880:	8082                	ret

0000000000000882 <write>:
.global write
write:
 li a7, SYS_write
 882:	48c1                	li	a7,16
 ecall
 884:	00000073          	ecall
 ret
 888:	8082                	ret

000000000000088a <close>:
.global close
close:
 li a7, SYS_close
 88a:	48d5                	li	a7,21
 ecall
 88c:	00000073          	ecall
 ret
 890:	8082                	ret

0000000000000892 <kill>:
.global kill
kill:
 li a7, SYS_kill
 892:	4899                	li	a7,6
 ecall
 894:	00000073          	ecall
 ret
 898:	8082                	ret

000000000000089a <exec>:
.global exec
exec:
 li a7, SYS_exec
 89a:	489d                	li	a7,7
 ecall
 89c:	00000073          	ecall
 ret
 8a0:	8082                	ret

00000000000008a2 <open>:
.global open
open:
 li a7, SYS_open
 8a2:	48bd                	li	a7,15
 ecall
 8a4:	00000073          	ecall
 ret
 8a8:	8082                	ret

00000000000008aa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 8aa:	48c5                	li	a7,17
 ecall
 8ac:	00000073          	ecall
 ret
 8b0:	8082                	ret

00000000000008b2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 8b2:	48c9                	li	a7,18
 ecall
 8b4:	00000073          	ecall
 ret
 8b8:	8082                	ret

00000000000008ba <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 8ba:	48a1                	li	a7,8
 ecall
 8bc:	00000073          	ecall
 ret
 8c0:	8082                	ret

00000000000008c2 <link>:
.global link
link:
 li a7, SYS_link
 8c2:	48cd                	li	a7,19
 ecall
 8c4:	00000073          	ecall
 ret
 8c8:	8082                	ret

00000000000008ca <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 8ca:	48d1                	li	a7,20
 ecall
 8cc:	00000073          	ecall
 ret
 8d0:	8082                	ret

00000000000008d2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 8d2:	48a5                	li	a7,9
 ecall
 8d4:	00000073          	ecall
 ret
 8d8:	8082                	ret

00000000000008da <dup>:
.global dup
dup:
 li a7, SYS_dup
 8da:	48a9                	li	a7,10
 ecall
 8dc:	00000073          	ecall
 ret
 8e0:	8082                	ret

00000000000008e2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 8e2:	48ad                	li	a7,11
 ecall
 8e4:	00000073          	ecall
 ret
 8e8:	8082                	ret

00000000000008ea <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 8ea:	48b1                	li	a7,12
 ecall
 8ec:	00000073          	ecall
 ret
 8f0:	8082                	ret

00000000000008f2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 8f2:	48b5                	li	a7,13
 ecall
 8f4:	00000073          	ecall
 ret
 8f8:	8082                	ret

00000000000008fa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 8fa:	48b9                	li	a7,14
 ecall
 8fc:	00000073          	ecall
 ret
 900:	8082                	ret

0000000000000902 <time>:
.global time
time:
 li a7, SYS_time
 902:	48d9                	li	a7,22
 ecall
 904:	00000073          	ecall
 ret
 908:	8082                	ret

000000000000090a <getmem>:
.global getmem
getmem:
 li a7, SYS_getmem
 90a:	48dd                	li	a7,23
 ecall
 90c:	00000073          	ecall
 ret
 910:	8082                	ret

0000000000000912 <get_sha256>:
.global get_sha256
get_sha256:
 li a7, SYS_get_sha256
 912:	48e1                	li	a7,24
 ecall
 914:	00000073          	ecall
 ret
 918:	8082                	ret

000000000000091a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 91a:	1101                	addi	sp,sp,-32
 91c:	ec06                	sd	ra,24(sp)
 91e:	e822                	sd	s0,16(sp)
 920:	1000                	addi	s0,sp,32
 922:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 926:	4605                	li	a2,1
 928:	fef40593          	addi	a1,s0,-17
 92c:	f57ff0ef          	jal	ra,882 <write>
}
 930:	60e2                	ld	ra,24(sp)
 932:	6442                	ld	s0,16(sp)
 934:	6105                	addi	sp,sp,32
 936:	8082                	ret

0000000000000938 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 938:	7139                	addi	sp,sp,-64
 93a:	fc06                	sd	ra,56(sp)
 93c:	f822                	sd	s0,48(sp)
 93e:	f426                	sd	s1,40(sp)
 940:	f04a                	sd	s2,32(sp)
 942:	ec4e                	sd	s3,24(sp)
 944:	0080                	addi	s0,sp,64
 946:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 948:	c299                	beqz	a3,94e <printint+0x16>
 94a:	0805c663          	bltz	a1,9d6 <printint+0x9e>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 94e:	2581                	sext.w	a1,a1
  neg = 0;
 950:	4881                	li	a7,0
 952:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 956:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 958:	2601                	sext.w	a2,a2
 95a:	00000517          	auipc	a0,0x0
 95e:	66e50513          	addi	a0,a0,1646 # fc8 <digits>
 962:	883a                	mv	a6,a4
 964:	2705                	addiw	a4,a4,1
 966:	02c5f7bb          	remuw	a5,a1,a2
 96a:	1782                	slli	a5,a5,0x20
 96c:	9381                	srli	a5,a5,0x20
 96e:	97aa                	add	a5,a5,a0
 970:	0007c783          	lbu	a5,0(a5)
 974:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 978:	0005879b          	sext.w	a5,a1
 97c:	02c5d5bb          	divuw	a1,a1,a2
 980:	0685                	addi	a3,a3,1
 982:	fec7f0e3          	bgeu	a5,a2,962 <printint+0x2a>
  if(neg)
 986:	00088b63          	beqz	a7,99c <printint+0x64>
    buf[i++] = '-';
 98a:	fd040793          	addi	a5,s0,-48
 98e:	973e                	add	a4,a4,a5
 990:	02d00793          	li	a5,45
 994:	fef70823          	sb	a5,-16(a4)
 998:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 99c:	02e05663          	blez	a4,9c8 <printint+0x90>
 9a0:	fc040793          	addi	a5,s0,-64
 9a4:	00e78933          	add	s2,a5,a4
 9a8:	fff78993          	addi	s3,a5,-1
 9ac:	99ba                	add	s3,s3,a4
 9ae:	377d                	addiw	a4,a4,-1
 9b0:	1702                	slli	a4,a4,0x20
 9b2:	9301                	srli	a4,a4,0x20
 9b4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 9b8:	fff94583          	lbu	a1,-1(s2)
 9bc:	8526                	mv	a0,s1
 9be:	f5dff0ef          	jal	ra,91a <putc>
  while(--i >= 0)
 9c2:	197d                	addi	s2,s2,-1
 9c4:	ff391ae3          	bne	s2,s3,9b8 <printint+0x80>
}
 9c8:	70e2                	ld	ra,56(sp)
 9ca:	7442                	ld	s0,48(sp)
 9cc:	74a2                	ld	s1,40(sp)
 9ce:	7902                	ld	s2,32(sp)
 9d0:	69e2                	ld	s3,24(sp)
 9d2:	6121                	addi	sp,sp,64
 9d4:	8082                	ret
    x = -xx;
 9d6:	40b005bb          	negw	a1,a1
    neg = 1;
 9da:	4885                	li	a7,1
    x = -xx;
 9dc:	bf9d                	j	952 <printint+0x1a>

00000000000009de <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 9de:	7119                	addi	sp,sp,-128
 9e0:	fc86                	sd	ra,120(sp)
 9e2:	f8a2                	sd	s0,112(sp)
 9e4:	f4a6                	sd	s1,104(sp)
 9e6:	f0ca                	sd	s2,96(sp)
 9e8:	ecce                	sd	s3,88(sp)
 9ea:	e8d2                	sd	s4,80(sp)
 9ec:	e4d6                	sd	s5,72(sp)
 9ee:	e0da                	sd	s6,64(sp)
 9f0:	fc5e                	sd	s7,56(sp)
 9f2:	f862                	sd	s8,48(sp)
 9f4:	f466                	sd	s9,40(sp)
 9f6:	f06a                	sd	s10,32(sp)
 9f8:	ec6e                	sd	s11,24(sp)
 9fa:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 9fc:	0005c903          	lbu	s2,0(a1)
 a00:	22090e63          	beqz	s2,c3c <vprintf+0x25e>
 a04:	8b2a                	mv	s6,a0
 a06:	8a2e                	mv	s4,a1
 a08:	8bb2                	mv	s7,a2
  state = 0;
 a0a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 a0c:	4481                	li	s1,0
 a0e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 a10:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 a14:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 a18:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 a1c:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a20:	00000c97          	auipc	s9,0x0
 a24:	5a8c8c93          	addi	s9,s9,1448 # fc8 <digits>
 a28:	a005                	j	a48 <vprintf+0x6a>
        putc(fd, c0);
 a2a:	85ca                	mv	a1,s2
 a2c:	855a                	mv	a0,s6
 a2e:	eedff0ef          	jal	ra,91a <putc>
 a32:	a019                	j	a38 <vprintf+0x5a>
    } else if(state == '%'){
 a34:	03598263          	beq	s3,s5,a58 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 a38:	2485                	addiw	s1,s1,1
 a3a:	8726                	mv	a4,s1
 a3c:	009a07b3          	add	a5,s4,s1
 a40:	0007c903          	lbu	s2,0(a5)
 a44:	1e090c63          	beqz	s2,c3c <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 a48:	0009079b          	sext.w	a5,s2
    if(state == 0){
 a4c:	fe0994e3          	bnez	s3,a34 <vprintf+0x56>
      if(c0 == '%'){
 a50:	fd579de3          	bne	a5,s5,a2a <vprintf+0x4c>
        state = '%';
 a54:	89be                	mv	s3,a5
 a56:	b7cd                	j	a38 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 a58:	cfa5                	beqz	a5,ad0 <vprintf+0xf2>
 a5a:	00ea06b3          	add	a3,s4,a4
 a5e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 a62:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 a64:	c681                	beqz	a3,a6c <vprintf+0x8e>
 a66:	9752                	add	a4,a4,s4
 a68:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 a6c:	03878a63          	beq	a5,s8,aa0 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 a70:	05a78463          	beq	a5,s10,ab8 <vprintf+0xda>
      } else if(c0 == 'u'){
 a74:	0db78763          	beq	a5,s11,b42 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 a78:	07800713          	li	a4,120
 a7c:	10e78963          	beq	a5,a4,b8e <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 a80:	07000713          	li	a4,112
 a84:	12e78e63          	beq	a5,a4,bc0 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 a88:	07300713          	li	a4,115
 a8c:	16e78b63          	beq	a5,a4,c02 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 a90:	05579063          	bne	a5,s5,ad0 <vprintf+0xf2>
        putc(fd, '%');
 a94:	85d6                	mv	a1,s5
 a96:	855a                	mv	a0,s6
 a98:	e83ff0ef          	jal	ra,91a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 a9c:	4981                	li	s3,0
 a9e:	bf69                	j	a38 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 aa0:	008b8913          	addi	s2,s7,8
 aa4:	4685                	li	a3,1
 aa6:	4629                	li	a2,10
 aa8:	000ba583          	lw	a1,0(s7)
 aac:	855a                	mv	a0,s6
 aae:	e8bff0ef          	jal	ra,938 <printint>
 ab2:	8bca                	mv	s7,s2
      state = 0;
 ab4:	4981                	li	s3,0
 ab6:	b749                	j	a38 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 ab8:	03868663          	beq	a3,s8,ae4 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 abc:	05a68163          	beq	a3,s10,afe <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 ac0:	09b68d63          	beq	a3,s11,b5a <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 ac4:	03a68f63          	beq	a3,s10,b02 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 ac8:	07800793          	li	a5,120
 acc:	0cf68d63          	beq	a3,a5,ba6 <vprintf+0x1c8>
        putc(fd, '%');
 ad0:	85d6                	mv	a1,s5
 ad2:	855a                	mv	a0,s6
 ad4:	e47ff0ef          	jal	ra,91a <putc>
        putc(fd, c0);
 ad8:	85ca                	mv	a1,s2
 ada:	855a                	mv	a0,s6
 adc:	e3fff0ef          	jal	ra,91a <putc>
      state = 0;
 ae0:	4981                	li	s3,0
 ae2:	bf99                	j	a38 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 ae4:	008b8913          	addi	s2,s7,8
 ae8:	4685                	li	a3,1
 aea:	4629                	li	a2,10
 aec:	000ba583          	lw	a1,0(s7)
 af0:	855a                	mv	a0,s6
 af2:	e47ff0ef          	jal	ra,938 <printint>
        i += 1;
 af6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 af8:	8bca                	mv	s7,s2
      state = 0;
 afa:	4981                	li	s3,0
        i += 1;
 afc:	bf35                	j	a38 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 afe:	03860563          	beq	a2,s8,b28 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 b02:	07b60963          	beq	a2,s11,b74 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 b06:	07800793          	li	a5,120
 b0a:	fcf613e3          	bne	a2,a5,ad0 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 b0e:	008b8913          	addi	s2,s7,8
 b12:	4681                	li	a3,0
 b14:	4641                	li	a2,16
 b16:	000ba583          	lw	a1,0(s7)
 b1a:	855a                	mv	a0,s6
 b1c:	e1dff0ef          	jal	ra,938 <printint>
        i += 2;
 b20:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 b22:	8bca                	mv	s7,s2
      state = 0;
 b24:	4981                	li	s3,0
        i += 2;
 b26:	bf09                	j	a38 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 b28:	008b8913          	addi	s2,s7,8
 b2c:	4685                	li	a3,1
 b2e:	4629                	li	a2,10
 b30:	000ba583          	lw	a1,0(s7)
 b34:	855a                	mv	a0,s6
 b36:	e03ff0ef          	jal	ra,938 <printint>
        i += 2;
 b3a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 b3c:	8bca                	mv	s7,s2
      state = 0;
 b3e:	4981                	li	s3,0
        i += 2;
 b40:	bde5                	j	a38 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 b42:	008b8913          	addi	s2,s7,8
 b46:	4681                	li	a3,0
 b48:	4629                	li	a2,10
 b4a:	000ba583          	lw	a1,0(s7)
 b4e:	855a                	mv	a0,s6
 b50:	de9ff0ef          	jal	ra,938 <printint>
 b54:	8bca                	mv	s7,s2
      state = 0;
 b56:	4981                	li	s3,0
 b58:	b5c5                	j	a38 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b5a:	008b8913          	addi	s2,s7,8
 b5e:	4681                	li	a3,0
 b60:	4629                	li	a2,10
 b62:	000ba583          	lw	a1,0(s7)
 b66:	855a                	mv	a0,s6
 b68:	dd1ff0ef          	jal	ra,938 <printint>
        i += 1;
 b6c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 b6e:	8bca                	mv	s7,s2
      state = 0;
 b70:	4981                	li	s3,0
        i += 1;
 b72:	b5d9                	j	a38 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b74:	008b8913          	addi	s2,s7,8
 b78:	4681                	li	a3,0
 b7a:	4629                	li	a2,10
 b7c:	000ba583          	lw	a1,0(s7)
 b80:	855a                	mv	a0,s6
 b82:	db7ff0ef          	jal	ra,938 <printint>
        i += 2;
 b86:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 b88:	8bca                	mv	s7,s2
      state = 0;
 b8a:	4981                	li	s3,0
        i += 2;
 b8c:	b575                	j	a38 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 b8e:	008b8913          	addi	s2,s7,8
 b92:	4681                	li	a3,0
 b94:	4641                	li	a2,16
 b96:	000ba583          	lw	a1,0(s7)
 b9a:	855a                	mv	a0,s6
 b9c:	d9dff0ef          	jal	ra,938 <printint>
 ba0:	8bca                	mv	s7,s2
      state = 0;
 ba2:	4981                	li	s3,0
 ba4:	bd51                	j	a38 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 ba6:	008b8913          	addi	s2,s7,8
 baa:	4681                	li	a3,0
 bac:	4641                	li	a2,16
 bae:	000ba583          	lw	a1,0(s7)
 bb2:	855a                	mv	a0,s6
 bb4:	d85ff0ef          	jal	ra,938 <printint>
        i += 1;
 bb8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 bba:	8bca                	mv	s7,s2
      state = 0;
 bbc:	4981                	li	s3,0
        i += 1;
 bbe:	bdad                	j	a38 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 bc0:	008b8793          	addi	a5,s7,8
 bc4:	f8f43423          	sd	a5,-120(s0)
 bc8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 bcc:	03000593          	li	a1,48
 bd0:	855a                	mv	a0,s6
 bd2:	d49ff0ef          	jal	ra,91a <putc>
  putc(fd, 'x');
 bd6:	07800593          	li	a1,120
 bda:	855a                	mv	a0,s6
 bdc:	d3fff0ef          	jal	ra,91a <putc>
 be0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 be2:	03c9d793          	srli	a5,s3,0x3c
 be6:	97e6                	add	a5,a5,s9
 be8:	0007c583          	lbu	a1,0(a5)
 bec:	855a                	mv	a0,s6
 bee:	d2dff0ef          	jal	ra,91a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 bf2:	0992                	slli	s3,s3,0x4
 bf4:	397d                	addiw	s2,s2,-1
 bf6:	fe0916e3          	bnez	s2,be2 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 bfa:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 bfe:	4981                	li	s3,0
 c00:	bd25                	j	a38 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 c02:	008b8993          	addi	s3,s7,8
 c06:	000bb903          	ld	s2,0(s7)
 c0a:	00090f63          	beqz	s2,c28 <vprintf+0x24a>
        for(; *s; s++)
 c0e:	00094583          	lbu	a1,0(s2)
 c12:	c195                	beqz	a1,c36 <vprintf+0x258>
          putc(fd, *s);
 c14:	855a                	mv	a0,s6
 c16:	d05ff0ef          	jal	ra,91a <putc>
        for(; *s; s++)
 c1a:	0905                	addi	s2,s2,1
 c1c:	00094583          	lbu	a1,0(s2)
 c20:	f9f5                	bnez	a1,c14 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 c22:	8bce                	mv	s7,s3
      state = 0;
 c24:	4981                	li	s3,0
 c26:	bd09                	j	a38 <vprintf+0x5a>
          s = "(null)";
 c28:	00000917          	auipc	s2,0x0
 c2c:	39890913          	addi	s2,s2,920 # fc0 <k+0x100>
        for(; *s; s++)
 c30:	02800593          	li	a1,40
 c34:	b7c5                	j	c14 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 c36:	8bce                	mv	s7,s3
      state = 0;
 c38:	4981                	li	s3,0
 c3a:	bbfd                	j	a38 <vprintf+0x5a>
    }
  }
}
 c3c:	70e6                	ld	ra,120(sp)
 c3e:	7446                	ld	s0,112(sp)
 c40:	74a6                	ld	s1,104(sp)
 c42:	7906                	ld	s2,96(sp)
 c44:	69e6                	ld	s3,88(sp)
 c46:	6a46                	ld	s4,80(sp)
 c48:	6aa6                	ld	s5,72(sp)
 c4a:	6b06                	ld	s6,64(sp)
 c4c:	7be2                	ld	s7,56(sp)
 c4e:	7c42                	ld	s8,48(sp)
 c50:	7ca2                	ld	s9,40(sp)
 c52:	7d02                	ld	s10,32(sp)
 c54:	6de2                	ld	s11,24(sp)
 c56:	6109                	addi	sp,sp,128
 c58:	8082                	ret

0000000000000c5a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c5a:	715d                	addi	sp,sp,-80
 c5c:	ec06                	sd	ra,24(sp)
 c5e:	e822                	sd	s0,16(sp)
 c60:	1000                	addi	s0,sp,32
 c62:	e010                	sd	a2,0(s0)
 c64:	e414                	sd	a3,8(s0)
 c66:	e818                	sd	a4,16(s0)
 c68:	ec1c                	sd	a5,24(s0)
 c6a:	03043023          	sd	a6,32(s0)
 c6e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c72:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c76:	8622                	mv	a2,s0
 c78:	d67ff0ef          	jal	ra,9de <vprintf>
}
 c7c:	60e2                	ld	ra,24(sp)
 c7e:	6442                	ld	s0,16(sp)
 c80:	6161                	addi	sp,sp,80
 c82:	8082                	ret

0000000000000c84 <printf>:

void
printf(const char *fmt, ...)
{
 c84:	711d                	addi	sp,sp,-96
 c86:	ec06                	sd	ra,24(sp)
 c88:	e822                	sd	s0,16(sp)
 c8a:	1000                	addi	s0,sp,32
 c8c:	e40c                	sd	a1,8(s0)
 c8e:	e810                	sd	a2,16(s0)
 c90:	ec14                	sd	a3,24(s0)
 c92:	f018                	sd	a4,32(s0)
 c94:	f41c                	sd	a5,40(s0)
 c96:	03043823          	sd	a6,48(s0)
 c9a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c9e:	00840613          	addi	a2,s0,8
 ca2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ca6:	85aa                	mv	a1,a0
 ca8:	4505                	li	a0,1
 caa:	d35ff0ef          	jal	ra,9de <vprintf>
}
 cae:	60e2                	ld	ra,24(sp)
 cb0:	6442                	ld	s0,16(sp)
 cb2:	6125                	addi	sp,sp,96
 cb4:	8082                	ret

0000000000000cb6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 cb6:	1141                	addi	sp,sp,-16
 cb8:	e422                	sd	s0,8(sp)
 cba:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 cbc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cc0:	00000797          	auipc	a5,0x0
 cc4:	3407b783          	ld	a5,832(a5) # 1000 <freep>
 cc8:	a805                	j	cf8 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 cca:	4618                	lw	a4,8(a2)
 ccc:	9db9                	addw	a1,a1,a4
 cce:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 cd2:	6398                	ld	a4,0(a5)
 cd4:	6318                	ld	a4,0(a4)
 cd6:	fee53823          	sd	a4,-16(a0)
 cda:	a091                	j	d1e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 cdc:	ff852703          	lw	a4,-8(a0)
 ce0:	9e39                	addw	a2,a2,a4
 ce2:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 ce4:	ff053703          	ld	a4,-16(a0)
 ce8:	e398                	sd	a4,0(a5)
 cea:	a099                	j	d30 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cec:	6398                	ld	a4,0(a5)
 cee:	00e7e463          	bltu	a5,a4,cf6 <free+0x40>
 cf2:	00e6ea63          	bltu	a3,a4,d06 <free+0x50>
{
 cf6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cf8:	fed7fae3          	bgeu	a5,a3,cec <free+0x36>
 cfc:	6398                	ld	a4,0(a5)
 cfe:	00e6e463          	bltu	a3,a4,d06 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d02:	fee7eae3          	bltu	a5,a4,cf6 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 d06:	ff852583          	lw	a1,-8(a0)
 d0a:	6390                	ld	a2,0(a5)
 d0c:	02059713          	slli	a4,a1,0x20
 d10:	9301                	srli	a4,a4,0x20
 d12:	0712                	slli	a4,a4,0x4
 d14:	9736                	add	a4,a4,a3
 d16:	fae60ae3          	beq	a2,a4,cca <free+0x14>
    bp->s.ptr = p->s.ptr;
 d1a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d1e:	4790                	lw	a2,8(a5)
 d20:	02061713          	slli	a4,a2,0x20
 d24:	9301                	srli	a4,a4,0x20
 d26:	0712                	slli	a4,a4,0x4
 d28:	973e                	add	a4,a4,a5
 d2a:	fae689e3          	beq	a3,a4,cdc <free+0x26>
  } else
    p->s.ptr = bp;
 d2e:	e394                	sd	a3,0(a5)
  freep = p;
 d30:	00000717          	auipc	a4,0x0
 d34:	2cf73823          	sd	a5,720(a4) # 1000 <freep>
}
 d38:	6422                	ld	s0,8(sp)
 d3a:	0141                	addi	sp,sp,16
 d3c:	8082                	ret

0000000000000d3e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d3e:	7139                	addi	sp,sp,-64
 d40:	fc06                	sd	ra,56(sp)
 d42:	f822                	sd	s0,48(sp)
 d44:	f426                	sd	s1,40(sp)
 d46:	f04a                	sd	s2,32(sp)
 d48:	ec4e                	sd	s3,24(sp)
 d4a:	e852                	sd	s4,16(sp)
 d4c:	e456                	sd	s5,8(sp)
 d4e:	e05a                	sd	s6,0(sp)
 d50:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d52:	02051493          	slli	s1,a0,0x20
 d56:	9081                	srli	s1,s1,0x20
 d58:	04bd                	addi	s1,s1,15
 d5a:	8091                	srli	s1,s1,0x4
 d5c:	0014899b          	addiw	s3,s1,1
 d60:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 d62:	00000517          	auipc	a0,0x0
 d66:	29e53503          	ld	a0,670(a0) # 1000 <freep>
 d6a:	c515                	beqz	a0,d96 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d6c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d6e:	4798                	lw	a4,8(a5)
 d70:	02977f63          	bgeu	a4,s1,dae <malloc+0x70>
 d74:	8a4e                	mv	s4,s3
 d76:	0009871b          	sext.w	a4,s3
 d7a:	6685                	lui	a3,0x1
 d7c:	00d77363          	bgeu	a4,a3,d82 <malloc+0x44>
 d80:	6a05                	lui	s4,0x1
 d82:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 d86:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d8a:	00000917          	auipc	s2,0x0
 d8e:	27690913          	addi	s2,s2,630 # 1000 <freep>
  if(p == (char*)-1)
 d92:	5afd                	li	s5,-1
 d94:	a0bd                	j	e02 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
 d96:	00000797          	auipc	a5,0x0
 d9a:	27a78793          	addi	a5,a5,634 # 1010 <base>
 d9e:	00000717          	auipc	a4,0x0
 da2:	26f73123          	sd	a5,610(a4) # 1000 <freep>
 da6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 da8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 dac:	b7e1                	j	d74 <malloc+0x36>
      if(p->s.size == nunits)
 dae:	02e48b63          	beq	s1,a4,de4 <malloc+0xa6>
        p->s.size -= nunits;
 db2:	4137073b          	subw	a4,a4,s3
 db6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 db8:	1702                	slli	a4,a4,0x20
 dba:	9301                	srli	a4,a4,0x20
 dbc:	0712                	slli	a4,a4,0x4
 dbe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 dc0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 dc4:	00000717          	auipc	a4,0x0
 dc8:	22a73e23          	sd	a0,572(a4) # 1000 <freep>
      return (void*)(p + 1);
 dcc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 dd0:	70e2                	ld	ra,56(sp)
 dd2:	7442                	ld	s0,48(sp)
 dd4:	74a2                	ld	s1,40(sp)
 dd6:	7902                	ld	s2,32(sp)
 dd8:	69e2                	ld	s3,24(sp)
 dda:	6a42                	ld	s4,16(sp)
 ddc:	6aa2                	ld	s5,8(sp)
 dde:	6b02                	ld	s6,0(sp)
 de0:	6121                	addi	sp,sp,64
 de2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 de4:	6398                	ld	a4,0(a5)
 de6:	e118                	sd	a4,0(a0)
 de8:	bff1                	j	dc4 <malloc+0x86>
  hp->s.size = nu;
 dea:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 dee:	0541                	addi	a0,a0,16
 df0:	ec7ff0ef          	jal	ra,cb6 <free>
  return freep;
 df4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 df8:	dd61                	beqz	a0,dd0 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dfa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 dfc:	4798                	lw	a4,8(a5)
 dfe:	fa9778e3          	bgeu	a4,s1,dae <malloc+0x70>
    if(p == freep)
 e02:	00093703          	ld	a4,0(s2)
 e06:	853e                	mv	a0,a5
 e08:	fef719e3          	bne	a4,a5,dfa <malloc+0xbc>
  p = sbrk(nu * sizeof(Header));
 e0c:	8552                	mv	a0,s4
 e0e:	addff0ef          	jal	ra,8ea <sbrk>
  if(p == (char*)-1)
 e12:	fd551ce3          	bne	a0,s5,dea <malloc+0xac>
        return 0;
 e16:	4501                	li	a0,0
 e18:	bf65                	j	dd0 <malloc+0x92>
