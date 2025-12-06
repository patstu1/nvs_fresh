// assets/shaders/glitch_scanner.frag
// Flutter runtime fragment shader (SkSL-style)
// Uniform order matters. We'll pass them from Dart in this exact order:
//
// 0: iTime (seconds)
// 1: iBeamY (0..1 normalized vertical position of the beam center)
// 2: iGlow (0..1 beam intensity multiplier)
// 3: iNoise (0..1 global noise amount)
// 4: iWidth (canvas width in px)
// 5: iHeight (canvas height in px)

uniform float iTime;
uniform float iBeamY;
uniform float iGlow;
uniform float iNoise;
uniform float iWidth;
uniform float iHeight;

vec2 res() { return vec2(iWidth, iHeight); }

// Simple pseudo-random
float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123); }

// 2D noise
float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  float a = hash(i);
  float b = hash(i + vec2(1.0, 0.0));
  float c = hash(i + vec2(0.0, 1.0));
  float d = hash(i + vec2(1.0, 1.0));
  vec2 u = f * f * (3.0 - 2.0 * f);
  return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Soft beam falloff
float beamMask(float y, float beamY, float thickness) {
  float d = abs(y - beamY);
  return exp(-pow(d / thickness, 1.6));
}

half4 main(vec2 fragCoord) {
  vec2 uv = fragCoord / res();
  vec3 base = vec3(0.01, 0.06, 0.06);      // deep teal background

  // Scanlines
  float sl = 0.06 * sin((uv.y * iHeight) * 0.08 + iTime * 5.0);
  float sl2 = 0.03 * sin((uv.y * iHeight) * 0.5 + iTime * 12.0);

  // Glitch jitter
  float n = noise(vec2(uv.x * 3.0, uv.y * 180.0 + iTime * 1.7));
  float j = (n - 0.5) * 0.006 * (0.2 + iNoise * 1.0);

  // Chromatic aberration offset near beam
  float beamYpx = iBeamY * iHeight;
  float bMask = beamMask(fragCoord.y, beamYpx, 22.0) * (0.35 + iGlow * 0.9);

  // Hue: neon mint core with cyan edges
  vec3 mint = vec3(0.47, 1.0, 0.83);
  vec3 cyan = vec3(0.2, 0.9, 1.0);

  // Vertical gradient vignette
  float vign = smoothstep(0.0, 0.25, uv.y) * (1.0 - smoothstep(0.75, 1.0, uv.y));
  vec3 col = base + sl + sl2 + vign * 0.02;

  // Add beam core
  col += mix(cyan, mint, 0.6) * bMask * 1.2;

  // Add dispersion “ghosts”
  float g1 = beamMask(fragCoord.y + 2.5, beamYpx, 34.0);
  float g2 = beamMask(fragCoord.y - 2.5, beamYpx, 34.0);
  col.r += g1 * 0.18;
  col.b += g2 * 0.18;

  // Horizontal streaks along the beam
  float streakNoise = noise(vec2(uv.x * 8.0 + iTime * 0.2, iBeamY * 12.0));
  col += vec3(0.15, 0.25, 0.22) * bMask * streakNoise;

  // Micro glitch offsets (x jitter)
  col += vec3(0.05) * (hash(vec2(uv.y * 150.0, floor(iTime * 60.0))) - 0.5) * iNoise;

  // Clamp
  col = clamp(col, 0.0, 1.0);

  return half4(col, 1.0);
}


