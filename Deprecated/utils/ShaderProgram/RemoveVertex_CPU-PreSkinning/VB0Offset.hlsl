//Made by NicoMico.
//If we can add offset to a point, then we can hide a point by offset.

//Originally learned from SliderImpact:
//https://github.com/SinsOfSeven/SliderImpact
struct vb0 {
    float3 position;
    float3 normal;
	float4 tangent;
};

RWStructuredBuffer<vb0> rw_buffer : register(u1);
StructuredBuffer<vb0> base : register(t0);
StructuredBuffer<vb0> key : register(t1);

[numthreads(1, 1, 1)]
void main(uint3 DTid : SV_DispatchThreadID)
{
    float3 difference = key[DTid.x].position - base[DTid.x].position;

    if (difference.x < 0.1 && difference.y < 0.1  && difference.z < 0.1 ) {
        rw_buffer[DTid.x].position += 0;
        rw_buffer[DTid.x].normal += 0;
	    rw_buffer[DTid.x].tangent += 0;
    }else{
       rw_buffer[DTid.x].position = 0;
       rw_buffer[DTid.x].normal = 0;
       rw_buffer[DTid.x].tangent = 0;
    }
}
