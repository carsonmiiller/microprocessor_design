lbi r0, 0
lbi r1, 1
add r0, r0, r1
lbi r2, -1
add r1, r1, r2
lbi r3, 10
add r2, r2, r3
beqz r2, 2
nop
nop
nop
nop
nop
halt
