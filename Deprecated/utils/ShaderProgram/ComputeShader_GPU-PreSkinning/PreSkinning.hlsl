//Developed by NicoMico.
//Original HLSL design learned from SliderImpact made by SinsOfSeven and Cybertron.
//Pointlist的未摆过姿态的顶点信息

//Still under development, will you join dev? I don't have that much time translate HLSL.
//use bone matrix to calculate animation so we can compress 1GB animation mod to 5MB.
struct Position {
    float3 POSITION;
    float3 NORMAL;
    float4 TANGENT;
};
StructuredBuffer<Position> PositionBuf : register(t0);

//顶点的权重值
struct Blend {
    float4 BLENDWEIGHTS;
    float4 BLENDINDICES;
};
StructuredBuffer<Blend> BlendBuf : register(t1);

//这里是骨骼变换矩阵
StructuredBuffer<float4> PoseBuf : register(t2);

//输出用的UAV
RWStructuredBuffer<Position> u0 : register(u0);

//输入参数
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);
#define VGCOUNT IniParams[140].x
#define FRAME IniParams[141].x

//使用低效率的1,1,1而不是64,1,1来避免额外的控制顶点数变量引入
//TODO 等基础测试通过之后要升级为通过变量控制的64,1,1来减少FPS下降
//https://www.gamedevs.org/uploads/skinned-mesh-and-character-animation-with-directx9.pdf
[numthreads(1, 1, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
    float3 POSITION = PositionBuf[vThreadID.x].POSITION;
    float3 NORMAL = PositionBuf[vThreadID.x].NORMAL;
    float4 TANGENT = PositionBuf[vThreadID.x].TANGENT;
    float4 BLENDWEIGHTS = BlendBuf[vThreadID.x].BLENDWEIGHTS;
    float4 BLENDINDICES = BlendBuf[vThreadID.x].BLENDINDICES;

    float3 ResultPOSITION = float3(0,0,0);
    float3 ResultNORMAL = float3(0,0,0);
    float4 ResultTANGENT = float4(0,0,0,0);

    // Process each blend weight
    for (int i = 0; i < 4; ++i) {
        uint index = BLENDINDICES[i];
        float weight = BLENDWEIGHTS[i];
        //因为weight的四个值加起来必须是1，所以实现了加权平均，weight就是那个权重
        // 变换矩阵加载
        float4x4 boneMatrix = PoseBuf[index + VGCOUNT * FRAME];
        // POSITION
        float4 positionHomo = float4(POSITION, 1.0);
        ResultPOSITION += weight * mul(boneMatrix, positionHomo).xyz;
        // NORMAL
        float3 normalTransformed = mul((float3x3)boneMatrix, NORMAL);
        ResultNORMAL += weight * normalTransformed;
        //TANGENT
        float3 tangentTransformed = mul((float3x3)boneMatrix, TANGENT.xyz);
        ResultTANGENT += weight * tangentTransformed;
    }

    u0[vThreadID.x * 3 + 0] = float4(ResultPOSITION, 1.0);
    u0[vThreadID.x * 3 + 1] = float4(ResultNORMAL, 0.0);
    u0[vThreadID.x * 3 + 2] = float4(ResultTANGENT, TANGENT.w);
}
