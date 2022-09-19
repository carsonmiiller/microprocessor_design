lbi r0, 0
lbi r1, 1
lbi r2, -1
lbi r3, 10
lbi r4, -10
lbi r5, 100
lbi r6 -100
add r0, r0, r1
add r1, r1, r2
add r2, r2, r3
add r3, r3, r4
add r4, r4, r5
add r5, r5, r6
slt r0, r0, r6
sco r1, r1, r6
beqz r2, 2
nop
nop
nop
nop
nop
halt
