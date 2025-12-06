#version 460 core

// Flutter sends these uniforms automatically
out vec4 fragColor;
in vec2 fragCoord;

// We will pass these custom uniforms from Flutter
uniform float iTime;          // App runtime in seconds
uniform vec2 iResolution;     // Screen resolution
uniform float iLight;         // Ambient light sensor value (0.0 to 1.0)
uniform float iHeartRate;     // User's normalized heart rate (e.g., (bpm - 60) / 40)

// --- Helper Functions ---
// 2D random function
float random (vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise function
float noise (vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion for complex patterns
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 0.0;
    
    for (int i = 0; i < 6; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Hexagonal grid pattern for quantum field
float hexGrid(vec2 st) {
    vec2 s = vec2(1.0, 1.732);
    vec2 a = mod(st, s) - s * 0.5;
    vec2 b = mod(st + s * 0.5, s) - s * 0.5;
    return min(length(a), length(b));
}

void main() {
    vec2 uv = fragCoord.xy / iResolution.xy;
    
    // --- Background Layer: The Deep Quantum Field ---
    // Evolving noise pattern that responds to time and biometrics
    float deepNoise = fbm(uv * 3.0 + iTime * 0.05 * (1.0 + iHeartRate));
    vec3 deepColor = vec3(0.008, 0.012, 0.015) + deepNoise * 0.03;
    
    // --- Subspace Layer: Neural Network Pathways ---
    // Flowing lines that pulse with heart rate
    vec2 flowUV = uv + sin(uv.yx * 8.0 + iTime * 2.0) * 0.1;
    float neuralFlow = fbm(flowUV * 4.0 - iTime * 0.3);
    float heartPulse = (sin(iTime * 6.28 * (0.8 + iHeartRate * 1.5)) + 1.0) * 0.5;
    vec3 neuralColor = vec3(0.02, 0.06, 0.04) * neuralFlow * heartPulse;
    
    // --- Midground Layer: The Cyber-Fog ---
    // Moves slowly, influenced by ambient light
    float fogPattern = noise(uv * 2.5 - iTime * 0.08 * (1.0 + iLight * 0.5));
    vec3 fogColor = vec3(0.04, 0.08, 0.07) * fogPattern * (0.5 + iLight * 0.5);

    // --- Quantum Grid: Hexagonal lattice structure ---
    float hexPattern = hexGrid(uv * 60.0);
    float gridMask = smoothstep(0.02, 0.01, hexPattern);
    vec3 gridColor = vec3(0.2, 0.6, 0.5) * gridMask * 0.15 * (0.5 + iLight * 0.5);
    
    // --- Foreground Layer: The Mint Glow Pulse ---
    // Quantum dots that appear and pulse with biometric data
    vec2 gridUV = fract(uv * 120.0 + sin(iTime * 0.5) * 0.1);
    float dot = (1.0 - distance(gridUV, vec2(0.5))) * 8.0;
    
    // Make dots appear and disappear based on quantum probability
    vec2 cellID = floor(uv * 120.0);
    float cellNoise = random(cellID + floor(iTime * 1.5));
    float quantumProbability = sin(iTime * 3.14 + cellNoise * 6.28) * 0.5 + 0.5;
    
    // Multi-layered pulse effect driven by heart rate and ambient conditions
    float biorhythm = (sin(iTime * 12.56 * (0.9 + iHeartRate * 2.1)) + 1.0) * 0.5;
    float ambientMod = (sin(iTime * 4.18 * (1.0 + iLight)) + 1.0) * 0.5;
    float complexPulse = biorhythm * ambientMod * quantumProbability;
    
    float finalDot = smoothstep(0.85, 1.0, dot) * smoothstep(0.6, 0.7, cellNoise) * complexPulse;

    // Color spectrum based on biometric intensity
    vec3 mintBase = vec3(0.3, 1.0, 0.7);
    vec3 bioColor = mix(mintBase, vec3(0.7, 0.3, 1.0), iHeartRate);
    vec3 mintGlow = bioColor * finalDot * (1.2 + iHeartRate * 0.8);

    // --- Data Stream Layer: Information flows ---
    float streamTime = iTime * 0.2;
    vec2 streamUV = uv * vec2(20.0, 8.0) + vec2(streamTime, sin(streamTime) * 0.5);
    float dataStream = smoothstep(0.95, 1.0, noise(streamUV));
    vec3 streamColor = vec3(0.1, 0.8, 0.6) * dataStream * 0.3 * iLight;
    
    // --- Resonance Field: Biometric harmony visualization ---
    float resonanceField = sin(length(uv - 0.5) * 30.0 - iTime * 8.0 * (1.0 + iHeartRate));
    resonanceField = pow(abs(resonanceField), 3.0) * 0.1;
    vec3 resonanceColor = vec3(0.8, 0.4, 1.0) * resonanceField * iHeartRate;
    
    // --- Composite the Layers ---
    vec3 finalColor = deepColor + neuralColor + fogColor + gridColor + mintGlow + streamColor + resonanceColor;

    // Adaptive brightness based on ambient light to prevent eye strain
    float adaptiveBrightness = mix(0.4, 1.0, iLight);
    finalColor *= adaptiveBrightness;
    
    // Bio-responsive color temperature
    float colorTemp = mix(0.9, 1.1, iHeartRate);
    finalColor.r *= colorTemp;
    finalColor.b *= (2.0 - colorTemp);
    
    // Subtle vignette for depth
    float vignette = 1.0 - length(uv - 0.5) * 0.8;
    finalColor *= vignette;
    
    // Ensure alpha is always 1.0 for proper compositing
    fragColor = vec4(finalColor, 1.0);
}

