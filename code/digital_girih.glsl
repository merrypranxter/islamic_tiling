// digital_girih.glsl
// Digital Girih — Sacred Geometry vs Digital Entropy
// Shadertoy-compatible fragment shader
//
// A perfect Islamic girih pattern is corrupted by digital degradation:
//   • CRT scanlines with per-line intensity variation
//   • Horizontal glitch displacement (random per-row, pulsed by iTime)
//   • Chromatic aberration (RGB channel separation, strongest at edges)
//   • Pixel corruption zones (random blocks of wrong colour)
//   • Bit-depth quantisation artefacts in shadow regions
//   • The sacred geometry "fights back" — corruption fades near rosette centres
//
// The tension between order and entropy mirrors the Islamic philosophical
// concept of the created world maintaining coherence through divine will.

#define SCALE       4.0
#define LINE_W      0.033
#define GLITCH_INT  0.6      // glitch intensity envelope peak
#define SCAN_FREQ   0.5      // scanline density (0.5 = every other pixel)
#define CA_STRENGTH 0.008    // chromatic aberration max offset
// BIT_DEPTH: simulated colour depth for quantisation artefacts in shadow regions.
// 16 levels per channel ≈ a 4-bit display, producing visible banding in dark areas.
#define BIT_DEPTH   16.0
#define PI          3.14159265358979

const vec3 C_BG   = vec3(0.04, 0.09, 0.28);
const vec3 C_TILE = vec3(0.08, 0.18, 0.52);
const vec3 C_LINE = vec3(1.00, 0.84, 0.12);
const vec3 C_GLITCH = vec3(0.80, 0.10, 0.40);

// ---- Hash utilities ----
float hash11(float n) { return fract(sin(n)*43758.5453); }
float hash12(vec2  p) { return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453); }

// ---- Pentagrid ----
float pgD(vec2 p, int k, float sp) {
    float a = float(k)*PI/5.0, g = float(k+1)/10.0;
    return abs(fract(dot(p,vec2(cos(a),sin(a)))/sp+g+0.5)-0.5)*sp;
}
float pgI(vec2 p, int k, float sp) {
    float a = float(k)*PI/5.0, g = float(k+1)/10.0;
    return floor(dot(p,vec2(cos(a),sin(a)))/sp+g+0.5);
}
float allD(vec2 p, float sp) {
    float d=1e9; for(int k=0;k<5;k++) d=min(d,pgD(p,k,sp)); return d;
}
float sumI(vec2 p, float sp) {
    float s=0.0; for(int k=0;k<5;k++) s+=pgI(p,k,sp); return s;
}
float rosettePot(vec2 p, float sp) {
    float s=0.0;
    for(int k=0;k<5;k++){
        float a=float(k)*PI/5.0, g=float(k+1)/10.0;
        s+=cos((dot(p,vec2(cos(a),sin(a)))/sp+g)*2.0*PI);
    }
    return s;
}

// ---- Sample the "clean" girih pattern at a given UV ----
vec3 sampleGirih(vec2 uv) {
    vec2 p = uv * SCALE;
    float sp = 1.0;
    float par = mod(sumI(p,sp), 2.0);
    vec3  col = mix(C_BG, C_TILE, par * 0.5);
    float d   = allD(p, sp);
    float glow= 0.006/(d*d+0.001);
    col += C_LINE * 0.3 * clamp(glow, 0.0, 1.0);
    float lm = 1.0-smoothstep(LINE_W-0.004, LINE_W+0.004, d);
    return mix(col, C_LINE, lm);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv0 = (fragCoord - 0.5*iResolution.xy) / iResolution.y;
    vec2 uv  = uv0;

    // ---- Glitch timing: sporadic bursts ----
    float glitchClock = floor(iTime * 3.0);
    float glitchBurst = step(0.7, hash11(glitchClock));  // ~30% duty cycle
    float glitchAmp   = glitchBurst * GLITCH_INT;

    // Per-scanline horizontal displacement
    float rowId  = floor(fragCoord.y / 2.0);  // 2-pixel rows
    float rowRnd = hash11(rowId + glitchClock * 137.3);
    float rowOff = (rowRnd > 0.92) ?                      // only ~8% of rows glitch
                   (rowRnd - 0.92) / 0.08 * glitchAmp * 0.06 : 0.0;
    uv.x += rowOff;

    // Pixel corruption blocks
    vec2  blockId  = floor(fragCoord / 16.0);
    float blockRnd = hash12(blockId + floor(iTime * 2.0));
    bool  corrupted = blockRnd > 0.96 && glitchBurst > 0.5;

    // ---- Chromatic aberration ----
    float caScale = length(uv0) * CA_STRENGTH * (1.0 + glitchAmp);
    vec2  caOff   = normalize(uv0 + 0.001) * caScale;

    vec3 colR = sampleGirih(uv + caOff);
    vec3 colG = sampleGirih(uv);
    vec3 colB = sampleGirih(uv - caOff);
    vec3 col  = vec3(colR.r, colG.g, colB.b);

    // ---- Pixel corruption override ----
    if (corrupted) {
        float t = hash12(blockId * 3.7 + fragCoord / iResolution.xy);
        col = mix(col, vec3(t, 1.0-t, hash11(t*13.3)), 0.85);
    }

    // ---- Scanlines ----
    float scan = 0.5 + 0.5*sin(fragCoord.y * PI * SCAN_FREQ * 2.0);
    col *= 0.85 + 0.15 * scan;

    // ---- Digital noise floor ----
    float noise = (hash12(fragCoord + iTime*100.0) - 0.5) * 0.035;
    col += noise;

    // ---- Bit-depth quantisation in dark areas ----
    float luma = dot(col, vec3(0.299, 0.587, 0.114));
    vec3  quantised = floor(col * BIT_DEPTH) / BIT_DEPTH;
    col = mix(col, quantised, smoothstep(0.25, 0.0, luma));

    // ---- Rosette centres resist corruption (order fighting chaos) ----
    vec2 p0 = uv0 * SCALE;
    float rPot = rosettePot(p0, 1.0);
    float orderField = smoothstep(-3.0, -4.8, rPot);
    // Blend back clean signal near rosette centres
    vec3 cleanCol = sampleGirih(uv0);
    col = mix(col, cleanCol, orderField * 0.7);

    // Vignette
    col *= 1.0 - dot(uv0,uv0) * 0.45;

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
