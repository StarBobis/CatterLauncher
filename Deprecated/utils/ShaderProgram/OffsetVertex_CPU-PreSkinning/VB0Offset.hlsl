//copied from Slider Impact: https://github.com/SinsOfSeven/SliderImpact
//ShapeKey
struct vb0 {
    float3 position; 	// 12
    float3 normal; 		// 24
	float4 tangent;		// 40
};

RWStructuredBuffer<vb0> rw_buffer : register(u1);
StructuredBuffer<vb0> base : register(t0);
StructuredBuffer<vb0> key : register(t1);

Texture1D<float4> IniParams : register(t120);

[numthreads(1, 1, 1)]
void main(uint3 DTid : SV_DispatchThreadID)
{
    rw_buffer[DTid.x].position += key[DTid.x].position - base[DTid.x].position;
	rw_buffer[DTid.x].normal += key[DTid.x].normal - base[DTid.x].normal;
	rw_buffer[DTid.x].tangent += key[DTid.x].tangent - base[DTid.x].tangent;
}
