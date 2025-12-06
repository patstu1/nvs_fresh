#version 460
precision highp float;
layout(location=0) uniform float uW;          // setFloat(0)
layout(location=1) uniform float uH;          // setFloat(1)
layout(location=2) uniform float uBeam;       // setFloat(2) 0..1
layout(location=3) uniform float uGlitch;     // setFloat(3) 0..1
out vec4 fragColor;

float n(vec2 p){ return fract(sin(dot(p, vec2(12.9898,78.233)))*43758.5453); }

void main(){
  vec2 uv = gl_FragCoord.xy / vec2(uW,uH);

  // mint beam centered at y = uBeam
  float d = abs(uv.y - uBeam);
  float beam = exp(-pow(d*40.0, 2.0)); // tight gaussian
  vec3 beamCol = vec3(0.3,1.0,0.8) * beam * 0.85;

  // subtle scanline
  float scan = 0.85 + 0.15 * sin((uv.y + uBeam) * 120.0);

  // glitch offset near beam
  float g = smoothstep(0.0, 0.12, 1.0 - d*8.0) * uGlitch;
  float split = (n(uv*vec2(420.0,17.0)) - 0.5) * 0.01 * g;

  // background tint
  vec3 bg = vec3(0.0);
  vec3 col = bg * scan;
  col += beamCol;

  fragColor = vec4(col, clamp(beam*1.2, 0.0, 1.0)); // alpha drives wordmark reveal mask (used visually)
}


