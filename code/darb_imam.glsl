// darb_imam.glsl
// Darb-i Imam Shrine Pattern — Isfahan, 1453 CE
// Quasicrystalline Girih Tiling Reconstruction
// Shadertoy-compatible fragment shader
//
// The Darb-i Imam shrine in Isfahan contains one of the earliest known
// quasicrystalline patterns in art — a self-similar girih tiling with
// local 10-fold symmetry identified by Lu & Steinhardt (Science, 2007).
//
// The pattern uses TWO levels of self-similar pentagrid, inflated by the
// golden ratio τ² ≈ 2.618. The large-scale grid defines thick girih tiles;
// the small-scale sub-grid provides the fine internal strapwork lines.
//
// Palette matches the historic tilework:
//   - Deep lapis lazuli blue field
//   - Turquoise faience glaze for medium tiles
//   - Buff/ivory carved stucco for small tiles
//   - Gold-lustre accents on rosette centres

#define SCALE       4.0
#define PI          3.14159265358979
#define PHI         1.61803398874989   // golden ratio τ
#define PHI2        2.61803398874989   // τ² (inflation factor)
#define LINE_W      0.032
#define FINE_W      0.018

// Historic palette
const vec3 C_LAPIS   = vec3(0.06, 0.14, 0.52);   // lapis lazuli
const vec3 C_TURQ    = vec3(0.08, 0.55, 0.60);   // turquoise
const vec3 C_IVORY   = vec3(0.92, 0.88, 0.76);   // stucco
const vec3 C_GOLD    = vec3(0.95, 0.80, 0.15);   // gilt
const vec3 C_SHADOW  = vec3(0.03, 0.06, 0.18);
const vec3 C_BG      = vec3(0.04, 0.10, 0.38);

// Pentagrid helper: signed distance to nearest line
float pgD(vec2 p, int k, float sp, float gamma) {
    float a = float(k) * PI / 5.0;
    vec2  n = vec2(cos(a), sin(a));
    return abs(fract(dot(p,n)/sp + gamma + 0.5) - 0.5) * sp;
}
float pgI(vec2 p, int k, float sp, float gamma) {
    float a = float(k) * PI / 5.0;
    vec2  n = vec2(cos(a), sin(a));
    return floor(dot(p,n)/sp + gamma + 0.5);
}

float minPG(vec2 p, float sp, float gOff) {
    float d = 1e9;
    for (int k = 0; k < 5; k++) {
        float g = float(k+1)/10.0 + gOff;
        d = min(d, pgD(p, k, sp, g));
    }
    return d;
}

float sumIdx(vec2 p, float sp, float gOff) {
    float s = 0.0;
    for (int k = 0; k < 5; k++) {
        float g = float(k+1)/10.0 + gOff;
        s += pgI(p, k, sp, g);
    }
    return s;
}

// Region classification boundaries (mod-10 pentagrid index-sum space):
//   DECA_LO/HI: the two antipodal decagon-centre classes (0 and 5)
//   Half-integer thresholds separate adjacent equivalence classes.
#define DECA_LO_MAX 0.5   // class 0 upper bound
#define DECA_HI_MIN 4.5   // class 5 lower bound
#define DECA_HI_MAX 5.5   // class 5 upper bound

// Region type: 0=large(lapis), 1=medium(turquoise), 2=small(ivory)
// Derived from the two-level index sums
int regionType(vec2 p, float sp) {
    float sCoarse = mod(sumIdx(p, sp,        0.0), 10.0);
    float sFine   = mod(sumIdx(p, sp/PHI2,   0.1), 10.0);
    
    // Coarse level: decagon centres → lapis
    if (sCoarse < DECA_LO_MAX || (sCoarse > DECA_HI_MIN && sCoarse < DECA_HI_MAX)) return 0;
    // Fine level: decagon centres → turquoise
    if (sFine   < DECA_LO_MAX || (sFine   > DECA_HI_MIN && sFine   < DECA_HI_MAX)) return 1;
    return 2; // ivory
}

// Rosette centre: bright spot at large-tile decagon centres
float rosetteDist(vec2 p, float sp) {
    // Local minima of the sum field correspond to decagon centres
    float s = 0.0;
    for (int k = 0; k < 5; k++) {
        float g = float(k+1)/10.0;
        float a = float(k) * PI / 5.0;
        vec2  n = vec2(cos(a), sin(a));
        float proj = dot(p,n)/sp + g;
        s += cos(proj * 2.0 * PI);  // continuous approximation
    }
    return -s;  // large negative = near decagon centre
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5*iResolution.xy) / iResolution.y;

    // Extremely slow drift, evoking eternal architecture
    float t   = iTime * 0.008;
    vec2  pan = vec2(cos(t)*0.3, sin(t*0.7)*0.3);
    vec2  p   = (uv + pan) * SCALE;

    float sp = 1.0;

    // --- Region colour ---
    int   rt  = regionType(p, sp);
    vec3  col = (rt == 0) ? C_LAPIS : (rt == 1) ? C_TURQ : C_IVORY;

    // Slight interior shading
    float dCoarse = minPG(p, sp, 0.0);
    float dFine   = minPG(p, sp/PHI2, 0.1);
    col *= 0.65 + 0.35 * smoothstep(0.0, 0.3, dCoarse);

    // --- Fine strapwork (small-scale sub-grid) ---
    float fineMask = 1.0 - smoothstep(FINE_W - 0.003, FINE_W + 0.003, dFine);
    // Sub-strapwork inherits parent tile colour tint + whitening
    vec3 fineCol = mix(col, C_IVORY, 0.5);
    col = mix(col, fineCol, fineMask * 0.8);

    // --- Coarse strapwork (main girih tile edges) ---
    float coarseMask = 1.0 - smoothstep(LINE_W - 0.004, LINE_W + 0.004, dCoarse);
    col = mix(col, C_GOLD * 0.85 + C_IVORY * 0.15, coarseMask);

    // --- Rosette glow (gold lustre at 10-fold rosette centres) ---
    float rField = rosetteDist(p, sp);
    float rGlow  = smoothstep(-4.5, -4.8, rField);
    col = mix(col, C_GOLD, rGlow * 0.6);

    // Soft vignette
    col *= 1.0 - dot(uv,uv) * 0.40;

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
