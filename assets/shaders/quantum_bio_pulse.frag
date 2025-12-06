// Flutter runtime fragment shader (Impeller). Uniforms are provided by index.
precision mediump float;

// Uniform order must match Dart setFloat indices:
// 0: time, 1: width, 2: height, 3: heart, 4: arousal, 5: stress,
// 6..8: base rgb, 9..11: pulse rgb, 12: intensity
uniform float uTime;
uniform float uWidth;
uniform float uHeight;
uniform float uHeartRate;
uniform float uArousal;
uniform float uStress;
uniform float uBaseR;
uniform float uBaseG;
uniform float uBaseB;
uniform float uPulseR;
uniform float uPulseG;
uniform float uPulseB;
uniform float uIntensity;

vec2 res() { return vec2(uWidth, uHeight); }

float qnoise(vec2 st) { return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123); }

float bioPulse(float t, float bpm) {
  float interval = 60.0 / max(bpm, 60.0);
  float phase = mod(t, interval) / interval;
  float mainP = smoothstep(0.0, 0.08, phase) * smoothstep(0.28, 0.08, phase);
  float echoP = smoothstep(0.33, 0.43, phase) * smoothstep(0.63, 0.43, phase) * 0.6;
  return mainP + echoP;
}

vec2 distort(vec2 uv, float t, float arousal, float stress) {
  float k = 0.02 + arousal * 0.03 + stress * 0.02;
  vec2 off = vec2(
    sin(t * 2.0 + uv.y * 10.0) * k,
    cos(t * 1.5 + uv.x * 8.0) * k
  );
  return uv + off;
}

vec3 mixBio(vec3 base, vec3 pulse, float arousal, float stress) {
  vec3 stressCol = mix(base, vec3(1.0, 0.2, 0.3), stress * 0.4);
  return mix(stressCol, pulse, arousal);
}

half4 main(vec2 fragCoord) {
  vec2 uv = fragCoord / res();
  vec3 base = vec3(uBaseR, uBaseG, uBaseB);
  vec3 pulseCol = vec3(uPulseR, uPulseG, uPulseB);
  float t = uTime;
  float ar = uArousal;
  float st = uStress;
  float intensity = uIntensity;

  vec2 uv2 = distort(uv, t, ar, st);
  vec2 center = vec2(0.5, 0.5);
  float d = length(uv2 - center);

  float p = bioPulse(t, uHeartRate);
  float field = qnoise(uv2 * 20.0 + t) * 0.1;
  float fieldI = 1.0 - d + field;

  vec3 col = mixBio(base, pulseCol, ar, st);
  float pI = p * intensity * (1.0 + ar * 0.5);
  col *= (1.0 + pI);

  float alpha = fieldI * intensity * (0.7 + ar * 0.3);
  alpha *= smoothstep(1.0, 0.0, d);

  float sparkle = step(0.985, qnoise(uv2 * 100.0 + t * 5.0));
  col += sparkle * st * vec3(1.0, 1.0, 0.8) * 0.45;

  return half4(col, alpha);
}

