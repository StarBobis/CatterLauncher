//Made by NicoMico, 2024.11.17.
//Used in Unity ComputeShader-GPU-PreSkinning.
//Special thanks to SinsOfSeven, SpectrumQT (I learned a lot of HLSL syntax and usage from their github).

//cs-t0 Position数据
Buffer<float4> t0 : register(t0);

//cs-t1 Blend数据
Buffer<float4> t1 : register(t1);

//Nico: 这里步长为64，但是3Dmigoto翻译过来结构变为16，说明结构为xyz，有4个分量，每个长度是16
//也就是说，这里定义的其实是每个单位为16，用的时候就能以.val[偏移]的方式访问到，如下：
//    r7.x = t2[r5.x].val[16/4];
//    r7.y = t2[r5.x].val[16/4+1];
//    r7.z = t2[r5.x].val[16/4+2];
//这里之所以不读取最后一位，是因为最后一位是恒定的常量，
//可以从cs-t2的buf文件中看到，前三个数最后一位默认为0，最后一个数的最后一位默认为1
//这里要注意val是访问结构体中的元素，如果是load则是精确访问缓冲区中的元素
//所以t0和t1要用load，t2这里3Dmigoto既然原始翻译成val和结构体，那就继续用val

//cs-t2 骨骼变换矩阵
struct t2_t {
  float val[16];
};
StructuredBuffer<t2_t> t2 : register(t2);

//用于读取顶点数的cs-cb0
cbuffer cb0 : register(b0)
{
  float4 cb0[1];
}

//cs-u0 输出用的UAV  
//Nico: 注意,这里保险起见还是使用索引存储
//因为Store方法在VSCode中语法提示报错，不确定是否能用，所以还是用索引方式存储
RWBuffer<float4> u0 : register(u0);

// 3Dmigoto declarations
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);


[numthreads(64, 1, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
    float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14;
    //顶点数大于cs-cb0[0]的int类型顶点数时，结束执行
    r0.x = cmp((uint)vThreadID.x >= asuint(cb0[0].x));
    if (r0.x != 0) {
        return;
    }
    //r0.x 为当前执行的次数 * 40 得到的是顶点数偏移，
    //比如顶点数为0第一次处理时，偏移为0，第二次偏移为40，正好读取下一个POSITION数据
    r0.x = (int)vThreadID.x * 40;

    //读取POSITION数据到r1.xyz
    r1.xyz = t0.Load(r0.x).xyz;
    //ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r1.xyz, r0.x, t0.xyzx

    //设置r0.yz偏移为12, 24，分别对应NORMAL 和 TANGENT的读取偏移
    //可以看到下面正好使用了r0.y读取xyz的NORMAL，使用r0.z读取xyzw的TANGENT
    r0.yz = mad((int2)vThreadID.xx, int2(40,40), int2(12,24));

    //读取NORMAL数据到r2.xyz
    r2.xyz = t0.Load(r0.y).xyz;
    //ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r2.xyz, r0.y, t0.xyzx

    //读取TANGENT数据到r3.xyzw
    r3.xyzw = t0.Load(r0.z).xyzw;
    //ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r3.xyzw, r0.z, t0.xyzw

    //r0.w设为BLENDWEIGHTS的读取偏移
    r0.w = (uint)vThreadID.x << 5;

    //读取BLENDWEIGHTS数据
    r4.xyzw = t1.Load(r0.w).xyzw;
    //ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r4.xyzw, r0.w, t1.xyzw

    //r0.w设为BLENDINDICES的读取偏移
    r0.w = mad((int)vThreadID.x, 32, 16);

    //读取BLENDINDICES数据
    r5.xyzw = t1.Load(r0.w).xyzw;
    //ld_raw_indexable(raw_buffer)(mixed,mixed,mixed,mixed) r5.xyzw, r0.w, t1.xyzw

    //开始计算经过骨骼变换矩阵变换后的POSITION,NORMAL,TANGENT对应数据
    //分别读取BLENDINDICES的x,y,z,w四个权重索引对应的权重值，然后
    //Nico: 下面这一长串可以简化的，暂时懒得简化了。

    //读取权重值
    r6.x = t2[r5.x].val[0/4];//0
    r6.y = t2[r5.x].val[0/4+1];//1
    r6.z = t2[r5.x].val[0/4+2];//2
    r7.x = t2[r5.x].val[16/4];//4
    r7.y = t2[r5.x].val[16/4+1];//5
    r7.z = t2[r5.x].val[16/4+2];//6
    r8.x = t2[r5.x].val[32/4]; //8
    r8.y = t2[r5.x].val[32/4+1];//9
    r8.z = t2[r5.x].val[32/4+2];//10
    r9.x = t2[r5.x].val[48/4]; //12
    r9.y = t2[r5.x].val[48/4+1]; //13
    r9.w = t2[r5.x].val[48/4+2];//14

    //取消临时变量占用，格式变换
    r10.x = r6.x;
    r10.y = r7.x;
    r10.z = r8.x;
    r10.w = r9.x;
    r11.x = r6.y;
    r11.y = r7.y;
    r11.z = r8.y;
    r11.w = r9.y;
    r9.x = r6.z;
    r9.y = r7.z;
    r9.z = r8.z;

    //读取权重值
    r6.x = t2[r5.y].val[0/4];
    r6.y = t2[r5.y].val[0/4+1];
    r6.z = t2[r5.y].val[0/4+2];
    r7.x = t2[r5.y].val[16/4];
    r7.y = t2[r5.y].val[16/4+1];
    r7.z = t2[r5.y].val[16/4+2];
    r8.x = t2[r5.y].val[32/4];
    r8.y = t2[r5.y].val[32/4+1];
    r8.z = t2[r5.y].val[32/4+2];
    r12.x = t2[r5.y].val[48/4];
    r12.y = t2[r5.y].val[48/4+1];
    r12.w = t2[r5.y].val[48/4+2];

    //取消临时变量占用，格式变换
    r13.x = r6.x;
    r13.y = r7.x;
    r13.z = r8.x;
    r13.w = r12.x;
    r13.xyzw = r13.xyzw * r4.yyyy;
    r14.x = r6.y;
    r14.y = r7.y;
    r14.z = r8.y;
    r14.w = r12.y;
    r14.xyzw = r14.xyzw * r4.yyyy;
    r12.x = r6.z;
    r12.y = r7.z;
    r12.z = r8.z;
    r6.xyzw = r12.xyzw * r4.yyyy;
    r7.xyzw = r10.xyzw * r4.xxxx + r13.xyzw;
    r8.xyzw = r11.xyzw * r4.xxxx + r14.xyzw;
    r6.xyzw = r9.xyzw * r4.xxxx + r6.xyzw;

    //读取权重值
    r9.x = t2[r5.z].val[0/4];
    r9.y = t2[r5.z].val[0/4+1];
    r9.z = t2[r5.z].val[0/4+2];
    r10.x = t2[r5.z].val[16/4];
    r10.y = t2[r5.z].val[16/4+1];
    r10.z = t2[r5.z].val[16/4+2];
    r11.x = t2[r5.z].val[32/4];
    r11.y = t2[r5.z].val[32/4+1];
    r11.z = t2[r5.z].val[32/4+2];
    r12.x = t2[r5.z].val[48/4];
    r12.y = t2[r5.z].val[48/4+1];
    r12.w = t2[r5.z].val[48/4+2];

    //取消临时变量占用，格式变换
    r13.x = r9.x;
    r13.y = r10.x;
    r13.z = r11.x;
    r13.w = r12.x;
    r14.x = r9.y;
    r14.y = r10.y;
    r14.z = r11.y;
    r14.w = r12.y;
    r12.x = r9.z;
    r12.y = r10.z;
    r12.z = r11.z;
    r7.xyzw = r13.xyzw * r4.zzzz + r7.xyzw;
    r8.xyzw = r14.xyzw * r4.zzzz + r8.xyzw;
    r6.xyzw = r12.xyzw * r4.zzzz + r6.xyzw;

    //读取权重值
    r4.x = t2[r5.w].val[0/4];
    r4.y = t2[r5.w].val[0/4+1];
    r4.z = t2[r5.w].val[0/4+2];
    r5.x = t2[r5.w].val[16/4];
    r5.y = t2[r5.w].val[16/4+1];
    r5.z = t2[r5.w].val[16/4+2];
    r9.x = t2[r5.w].val[32/4];
    r9.y = t2[r5.w].val[32/4+1];
    r9.z = t2[r5.w].val[32/4+2];
    r10.x = t2[r5.w].val[48/4];
    r10.y = t2[r5.w].val[48/4+1];
    r10.w = t2[r5.w].val[48/4+2];

    //取消临时变量占用，格式变换
    r11.x = r4.x;
    r11.y = r5.x;
    r11.z = r9.x;
    r11.w = r10.x;
    r12.x = r4.y;
    r12.y = r5.y;
    r12.z = r9.y;
    r12.w = r10.y;
    r10.x = r4.z;
    r10.y = r5.z;
    r10.z = r9.z;
    r5.xyzw = r11.xyzw * r4.wwww + r7.xyzw;
    r7.xyzw = r12.xyzw * r4.wwww + r8.xyzw;
    r4.xyzw = r10.xyzw * r4.wwww + r6.xyzw;
    r1.w = 1;
    
    //POSITION
    r6.x = dot(r5.xyzw, r1.xyzw);
    r6.y = dot(r7.xyzw, r1.xyzw);
    r6.z = dot(r4.xyzw, r1.xyzw);
    //NORMAL
    r1.x = dot(r5.xyz, r2.xyz);
    r1.y = dot(r7.xyz, r2.xyz);
    r1.z = dot(r4.xyz, r2.xyz);
    //TANGENT
    r2.x = dot(r5.xyz, r3.xyz);
    r2.y = dot(r7.xyz, r3.xyz);
    r2.z = dot(r4.xyz, r3.xyz);

    //存储POSITION数据r6.xyzx到u0.xyz，偏移为r0.x
    u0[r0.x].xyz = r6.xyz;
    //store_raw u0.xyz, r0.x, r6.xyzx

    //存储NORMAL数据r1.xyzx到u0.xyz，偏移为r0.y
    u0[r0.y].xyz = r1.xyz;
    //store_raw u0.xyz, r0.y, r1.xyzx

    //这一步是把输入时候的TANGENT的w分量复制过来，用于不做修改直接输出，因为TANGENT.w分量是固定的
    r2.w = r3.w;

    //存储TANGENT数据r2.xyzw到u0.xyzw，偏移为r0.z
    u0[r0.z].xyzw = r2.xyzw;
    //store_raw u0.xyzw, r0.z, r2.xyzw
  return;
}
