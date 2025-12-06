// Simple GLSL fragment shader for CRT glitch effect
precision mediump float;
uniform float u_time;
uniform vec2 u_resolution;

void main() {
  vec2 uv = gl_FragCoord.xy / u_resolution.xy;
  uv.x += sin(uv.y * 30.0 + u_time * 5.0) * 0.01;
  vec3 color = vec3(0.0, 1.0, 0.8);
  color *= step(0.5, fract(uv.y * 40.0 + u_time * 3.0)); // scanlines
  gl_FragColor = vec4(color, 1.0);
}