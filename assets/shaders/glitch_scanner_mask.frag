// assets/shaders/glitch_scanner_mask.frag
// Pulsing oval scanner mask with mint glow and subtle glitch jitter
// Uniform order (Flutter sets by index):
// 0: iTime (seconds)
// 1: iCenterX (px)
// 2: iCenterY (px)
// 3: iRadiusX (px)
// 4: iRadiusY (px)
// 5: iGlow (0..1)
// 6: iNoise (0..1)
// 7: iWidth (px)
// 8: iHeight (px)

uniform float iTime;
uniform float iCenterX;
uniform float iCenterY;
uniform float iRadiusX;
uniform float iRadiusY;
uniform float iGlow;
uniform float iNoise;
uniform float iWidth;
uniform float iHeight;

vec2 res() { return vec2(iWidth, iHeight); }

// Hash and noise helpers
float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

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

// Signed distance to an axis-aligned ellipse
float sdEllipse(vec2 p, vec2 r) {
  p = abs(p);
  if (p.x > r.x || p.y > r.y) {
    // Outside ellipse, approximate distance to boundary
    vec2 k = p / r;
    float len = length(k);
    return (len - 1.0) * min(r.x, r.y);
  }
  // Inside; negative distance proportional to how far inside
  float k = 1.0 - (p.x * p.x) / (r.x * r.x) - (p.y * p.y) / (r.y * r.y);
  return -k * min(r.x, r.y) * 0.5;
}

// Soft mint glow palette
vec3 mintCore() { return vec3(0.894, 1.0, 0.941); }   // #e4fff0
vec3 mintEdge() { return vec3(0.031, 0.953, 0.941); } // #08F3F0

half4 main(vec2 fragCoord) {
  vec2 R = res();
  vec2 uv = fragCoord / R;

  // Center and radii
  vec2 center = vec2(iCenterX, iCenterY);
  vec2 radii = vec2(iRadiusX, iRadiusY);

  // Breathing pulse
  float breath = 0.5 + 0.5 * sin(iTime * 2.6);
  float pulse = mix(0.92, 1.06, breath);
  vec2 pr = radii * pulse;

  // Glitch jitter near edges
  float tNoise = noise(vec2(uv * 6.0 + iTime * 0.4));
  float edgeJitter = (tNoise - 0.5) * 2.0 * iNoise; // -iNoise..iNoise

  // Distance field (ellipse)
  float d = sdEllipse(fragCoord - center, pr);
  d += edgeJitter * 1.5; // apply subtle jitter to the boundary

  // Soft mask: inside ellipse = 1, outside fades to 0 with glow falloff
  float edgeWidth = 2.5 + 8.0 * (1.0 - iGlow);
  float mask = smoothstep(edgeWidth, 0.0, d);

  // Glow ring along the edge
  float glowBand = smoothstep(0.0, edgeWidth * 1.2, abs(d));
  glowBand = 1.0 - glowBand;
  glowBand = pow(glowBand, 1.8);
  glowBand *= (0.35 + 0.65 * iGlow);

  // Chromatic edge tint
  float edge = smoothstep(1.6 * edgeWidth, 0.0, abs(d));
  vec3 col = mix(mintEdge(), mintCore(), 0.6) * glowBand * (0.6 + 0.4 * breath);
  col += vec3(0.0, 0.05, 0.06) * edge * 0.15; // subtle teal shadow

  // Add micro scanline flicker to the ring
  float sl = 0.07 * sin((fragCoord.y) * 0.35 + iTime * 9.0);
  col += vec3(sl) * glowBand * 0.25;

  // Compose: alpha is the mask; RGB carries the glow (pre-multiplied usage recommended)
  return half4(col, mask);
}


