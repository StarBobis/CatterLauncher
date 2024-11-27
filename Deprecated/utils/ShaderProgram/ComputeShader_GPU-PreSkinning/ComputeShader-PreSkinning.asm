cs_5_0
dcl_globalFlags refactoringAllowed
dcl_constantbuffer CB0[1], immediateIndexed
dcl_resource_raw t0
dcl_resource_raw t1
dcl_resource_structured t2, 64
dcl_uav_raw u0
dcl_input vThreadID.x
dcl_temps 15
dcl_thread_group 64, 1, 1
uge r0.x, vThreadID.x, cb0[0].x
if_nz r0.x
  ret
endif
imul null, r0.x, vThreadID.x, l(40)
ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r1.xyz, r0.x, t0.xyzx
imad r0.yz, vThreadID.xxxx, l(0, 40, 40, 0), l(0, 12, 24, 0)
ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r2.xyz, r0.y, t0.xyzx
ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r3.xyzw, r0.z, t0.xyzw
ishl r0.w, vThreadID.x, l(5)
ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r4.xyzw, r0.w, t1.xyzw
imad r0.w, vThreadID.x, l(32), l(16)
ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r5.xyzw, r0.w, t1.xyzw
ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r6.xyz, r5.x, l(0), t2.xyzx
ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r7.xyz, r5.x, l(16), t2.xyzx
ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r8.xyz, r5.x, l(32), t2.xyzx
ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r9.xyw, r5.x, l(48), t2.xyxz
mov r10.x, r6.x
mov r10.y, r7.x
mov r10.z, r8.x
mov r10.w, r9.x
mov r11.x, r6.y
mov r11.y, r7.y
mov r11.z, r8.y
mov r11.w, r9.y
mov r9.x, r6.z
mov r9.y, r7.z
mov r9.z, r8.z
ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r6.xyz, r5.y, l(0), t2.xyzx
ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r7.xyz, r5.y, l(16), t2.xyzx
ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r8.xyz, r5.y, l(32), t2.xyzx
ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r12.xyw, r5.y, l(48), t2.xyxz
mov r13.x, r6.x
mov r13.y, r7.x
mov r13.z, r8.x
mov r13.w, r12.x
mul r13.xyzw, r4.yyyy, r13.xyzw
mov r14.x, r6.y
mov r14.y, r7.y
mov r14.z, r8.y
mov r14.w, r12.y
mul r14.xyzw, r4.yyyy, r14.xyzw
mov r12.x, r6.z
mov r12.y, r7.z
mov r12.z, r8.z
mul r6.xyzw, r4.yyyy, r12.xyzw
mad r7.xyzw, r10.xyzw, r4.xxxx, r13.xyzw
mad r8.xyzw, r11.xyzw, r4.xxxx, r14.xyzw
mad r6.xyzw, r9.xyzw, r4.xxxx, r6.xyzw
ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r9.xyz, r5.z, l(0), t2.xyzx
ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r10.xyz, r5.z, l(16), t2.xyzx
ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r11.xyz, r5.z, l(32), t2.xyzx
ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r12.xyw, r5.z, l(48), t2.xyxz
mov r13.x, r9.x
mov r13.y, r10.x
mov r13.z, r11.x
mov r13.w, r12.x
mov r14.x, r9.y
mov r14.y, r10.y
mov r14.z, r11.y
mov r14.w, r12.y
mov r12.x, r9.z
mov r12.y, r10.z
mov r12.z, r11.z
mad r7.xyzw, r13.xyzw, r4.zzzz, r7.xyzw
mad r8.xyzw, r14.xyzw, r4.zzzz, r8.xyzw
mad r6.xyzw, r12.xyzw, r4.zzzz, r6.xyzw
ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r4.xyz, r5.w, l(0), t2.xyzx
ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r5.xyz, r5.w, l(16), t2.xyzx
ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r9.xyz, r5.w, l(32), t2.xyzx
ld_structured_indexable(structured_buffer, stride=64)(mixed,mixed,mixed,mixed) r10.xyw, r5.w, l(48), t2.xyxz
mov r11.x, r4.x
mov r11.y, r5.x
mov r11.z, r9.x
mov r11.w, r10.x
mov r12.x, r4.y
mov r12.y, r5.y
mov r12.z, r9.y
mov r12.w, r10.y
mov r10.x, r4.z
mov r10.y, r5.z
mov r10.z, r9.z
mad r5.xyzw, r11.xyzw, r4.wwww, r7.xyzw
mad r7.xyzw, r12.xyzw, r4.wwww, r8.xyzw
mad r4.xyzw, r10.xyzw, r4.wwww, r6.xyzw
mov r1.w, l(1.000000)
dp4 r6.x, r5.xyzw, r1.xyzw
dp4 r6.y, r7.xyzw, r1.xyzw
dp4 r6.z, r4.xyzw, r1.xyzw
dp3 r1.x, r5.xyzx, r2.xyzx
dp3 r1.y, r7.xyzx, r2.xyzx
dp3 r1.z, r4.xyzx, r2.xyzx
dp3 r2.x, r5.xyzx, r3.xyzx
dp3 r2.y, r7.xyzx, r3.xyzx
dp3 r2.z, r4.xyzx, r3.xyzx
store_raw u0.xyz, r0.x, r6.xyzx
store_raw u0.xyz, r0.y, r1.xyzx
mov r2.w, r3.w
store_raw u0.xyzw, r0.z, r2.xyzw
ret
