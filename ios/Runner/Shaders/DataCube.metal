#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float3 color;
};

vertex VertexOut vertex_shader(uint vertexID [[vertex_id]]) {
    // Placeholder for real vertex data
    float4 position = float4(0.0, 0.0, 0.0, 1.0);
    // This is where we will do our 3D transformations.
    
    VertexOut out;
    out.position = position;
    out.color = float3(0.65, 1.0, 0.91); // Ultra Light Neon Mint
    return out;
}

fragment float4 fragment_shader(VertexOut in [[stage_in]]) {
    // This is where we will do our lighting and texture mapping.
    return float4(in.color, 1.0);
}