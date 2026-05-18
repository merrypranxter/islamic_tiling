// biological_girih.glsl
// Biological Girih — Sacred Geometry as Living Tissue
// Shadertoy-compatible fragment shader
//
// The girih tiling is recast as microscopic tissue:
//   • Tiles → cells with semi-transparent cytoplasm (soft interior fill)
//   • Strapwork lines → cell walls / fasciae (thick, semi-opaque)
//   • Rosette centres (10-fold foci) → cell nuclei with chromatin texture
//   • Pentagrid at ×τ scale → vascular / mycelial network inside walls
//   • Slow peristaltic breathing: cell areas pulse with period ~3s
//   • Colours: organic — pale amber cytoplasm, dark olive cell walls,
//              deep crimson nuclei, cream fasciae
//
// Nucleus detection thresholds (pentagrid cosine field ∈ [-5, +5]):
//   NUC_OUTER: outer boundary of nucleus detection (softer halo)
//   NUC_INNER: inner core (full nucleus opacity)
//   NUC_RING_CENTRE: potential value at the membrane ring midline (≈ -4.7)
//   NUC_RING_WIDTH: half-width of the membrane ring in potential-field units
#define NUC_OUTER       -4.5
#define NUC_INNER       -4.9
#define NUC_RING_CENTRE  4.7
#define NUC_RING_WIDTH   0.25

#define SCALE              4.0
#define WALL_W             0.045    // cell wall half-width
#define VASC_W             0.018    // vascular network half-width
#define NUC_R              0.12     // nucleus radius (tile units)
// CHROMATIN_THRESHOLD: noise value above which chromatin granules are rendered.
// 0.55 means ~45% of nucleus area shows chromatin flecks, matching real cell images.
#define CHROMATIN_THRESHOLD 0.55
#define PULSE_HZ    0.30     // breathing frequency (Hz)
#define PI          3.14159265358979
#define PHI         1.61803398874989

// Organic palette
const vec3 C_CYTO   = vec3(0.88, 0.82, 0.62);  // amber cytoplasm
const vec3 C_WALL   = vec3(0.22, 0.28, 0.14);  // dark olive cell wall
const vec3 C_VASC   = vec3(0.60, 0.40, 0.18);  // amber/brown vasculature
const vec3 C_NUC    = vec3(0.45, 0.12, 0.12);  // dark crimson nucleus
const vec3 C_CHROM  = vec3(0.62, 0.08, 0.18);  // chromatin (brighter red)
const vec3 C_BG     = vec3(0.12, 0.10, 0.06);  // dark background
const vec3 C_FLUID  = vec3(0.50, 0.55, 0.35);  // extracellular fluid tint

// ---- Pentagrid ----
float pgD(vec2 p, int k, float sp) {
    float a=float(k)*PI/5.0, g=float(k+1)/10.0;
    return abs(fract(dot(p,vec2(cos(a),sin(a)))/sp+g+0.5)-0.5)*sp;
}
float pgI(vec2 p, int k, float sp) {
    float a=float(k)*PI/5.0, g=float(k+1)/10.0;
    return floor(dot(p,vec2(cos(a),sin(a)))/sp+g+0.5);
}
float allD(vec2 p, float sp) {
    float d=1e9; for(int k=0;k<5;k++) d=min(d,pgD(p,k,sp)); return d;
}
float sumI(vec2 p, float sp) {
    float s=0.0; for(int k=0;k<5;k++) s+=pgI(p,k,sp); return s;
}

// Continuous field for rosette/nucleus centres
float rosettePot(vec2 p, float sp) {
    float s=0.0;
    for(int k=0;k<5;k++){
        float a=float(k)*PI/5.0, g=float(k+1)/10.0;
        s+=cos((dot(p,vec2(cos(a),sin(a)))/sp+g)*2.0*PI);
    }
    return s;
}

// Simple 2D noise for organic texture
float hash12(vec2 p) { return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5); }
float noise2(vec2 p) {
    vec2 i=floor(p), f=fract(p);
    f = f*f*(3.0-2.0*f);
    return mix(mix(hash12(i),hash12(i+vec2(1,0)),f.x),
               mix(hash12(i+vec2(0,1)),hash12(i+vec2(1,1)),f.x), f.y);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5*iResolution.xy) / iResolution.y;

    // Very slow drift (cytoplasmic streaming)
    vec2 drift = vec2(cos(iTime*0.04)*0.15, sin(iTime*0.03)*0.15);
    vec2 p     = (uv + drift) * SCALE;

    float sp = 1.0;

    // Cellular breathing: pulse affects effective tile size
    float breath = 1.0 + 0.025*sin(iTime * PULSE_HZ * 2.0*PI);
    p *= breath;

    // ---- Base: extracellular fluid ----
    vec3 col = C_BG;

    // ---- Cell interior: cytoplasm ----
    float dWall  = allD(p, sp);
    float inside = smoothstep(WALL_W + 0.02, WALL_W - 0.02, dWall);
    // Organic texture in cytoplasm
    float cytTex = noise2(p * 3.5 + iTime*0.05) * 0.15;
    vec3  cyto   = C_CYTO * (0.85 + cytTex);
    col = mix(col, cyto, inside);

    // Tile-type tinting (region parity gives two cytoplasm tones)
    float par = mod(sumI(p, sp), 2.0);
    col = mix(col, col * mix(1.0, 1.15, par) + C_FLUID*0.08, inside*0.4);

    // ---- Vascular / mycelial network (fine sub-grid) ----
    float dVasc = allD(p, sp/PHI);
    float vascMask = 1.0 - smoothstep(VASC_W-0.003, VASC_W+0.003, dVasc);
    // Only visible inside cells
    vascMask *= inside * 0.7;
    col = mix(col, C_VASC, vascMask);

    // ---- Cell nucleus at rosette centres ----
    float rPot   = rosettePot(p, sp);
    float nucMask= smoothstep(NUC_OUTER, NUC_INNER, rPot);  // near decagon centres
    // Nucleus interior
    col = mix(col, C_NUC, nucMask * inside);
    // Chromatin: brighter specks within nucleus (noise-textured)
    float chromTex = noise2(p * 8.0 + iTime*0.1);
    float chromMask = nucMask * inside * step(CHROMATIN_THRESHOLD, chromTex);
    col = mix(col, C_CHROM, chromMask * 0.8);
    // Nucleus membrane ring
    float nucRing = abs(rPot + NUC_RING_CENTRE) < NUC_RING_WIDTH ? 1.0 : 0.0;
    col = mix(col, C_NUC * 0.6, nucRing * inside * 0.5);

    // ---- Cell wall (main strapwork) ----
    float wallMask = 1.0 - smoothstep(WALL_W-0.005, WALL_W+0.005, dWall);
    // Cell wall colour shifts slightly by breathing phase (pulsing membrane)
    float memPulse = 0.5 + 0.5*sin(iTime*PULSE_HZ*2.0*PI + length(p)*0.5);
    vec3  wallCol  = mix(C_WALL, C_WALL * 1.3, memPulse * 0.3);
    col = mix(col, wallCol, wallMask);

    // Soft outer glow of wall (extracellular matrix)
    float ecm = smoothstep(WALL_W+0.06, WALL_W, dWall) * (1.0-wallMask);
    col += C_FLUID * ecm * 0.15;

    // ---- Vignette ----
    col *= 1.0 - dot(uv,uv) * 0.50;

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
