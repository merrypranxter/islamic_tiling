// dodecagonal_girih.glsl
// Twelve-Fold Islamic Star Patterns — Dodecagonal Geometry
// Shadertoy-compatible fragment shader
//
// The 12-fold ({12/n}) star is the most harmonically rich symmetry in Islamic
// art — it is both fourfold AND sixfold simultaneously (since 12 = 4×3 = 6×2),
// making it the supreme synthesis of the √2 and √3 proportional systems.
//
// The dodecagram {12/5} (connecting every 5th vertex) appears throughout:
//   • The Shrine of Shah Nematollah Vali, Mahan, Iran (c. 1436–1601 CE)
//   • The Friday Mosque (Masjid-i Jum'a), Isfahan
//   • Moroccan zellige tile compositions at the highest level of complexity
//   • Ottoman Iznik tilework of the 16th–17th centuries
//
// Geometry:
//   A regular 12-gon has interior angles of 150°. All angles are multiples of
//   30° = 360°/12. The two proportions √2 and √3 BOTH appear in the same
//   construction:
//     • 12-gon contains embedded squares (4-fold) with √2 diagonals
//     • 12-gon contains embedded hexagons (6-fold) with √3 diagonals
//     • Combined: √6 = √2·√3 also appears in the internal geometry
//
// Construction method (this shader):
//   A "twelvegrid" of 6 families of parallel lines at k·30° intervals (k=0..5).
//   Unlike the pentagrid (5 families → aperiodic), the hexagrid (6 families) CAN
//   produce periodic patterns (when spacings are commensurate) — but with irrational
//   phase offsets, it produces a 12-fold quasiperiodic pattern.
//
// Two modes via TWELV_MODE:
//   0 = standard 12-fold periodic (clean, most historically common)
//   1 = quasiperiodic 12-fold (spacings in ratio 1:√3, producing an aperiodic tiling)
//
// Palette: Shah Nematollah — deep indigo, white stucco, saffron, black.

#define TWELV_MODE    0       // 0 = periodic; 1 = quasiperiodic
#define SCALE         4.2
#define LINE_W        0.030
#define PI            3.14159265358979
#define TAU           6.28318530717959
#define SQRT3         1.73205080756888
#define NUM_FAM       6

// Shah Nematollah / Moroccan zellige palette
const vec3 C_BG     = vec3(0.06, 0.05, 0.20);   // deep indigo
const vec3 C_A      = vec3(0.88, 0.82, 0.70);   // pale stucco
const vec3 C_B      = vec3(0.08, 0.15, 0.55);   // royal blue
const vec3 C_C      = vec3(0.72, 0.14, 0.08);   // deep carmine
const vec3 C_D      = vec3(0.85, 0.68, 0.08);   // saffron gold
const vec3 C_LINE   = vec3(1.00, 0.98, 0.88);   // bright strapwork

// ---- Sixgrid (6 families of lines at k·30°) ----
// Same structure as the pentagrid but with 6 families.
// This produces the dual hexagonal / dodecagonal tiling.
float sgDist(vec2 p, int k, float sp) {
    float a     = float(k) * PI / float(NUM_FAM);  // k * 30°
    float gamma = float(k + 1) / float(NUM_FAM * 2);
    vec2  n     = vec2(cos(a), sin(a));
    return abs(fract(dot(p, n) / sp + gamma + 0.5) - 0.5) * sp;
}
float sgIdx(vec2 p, int k, float sp) {
    float a     = float(k) * PI / float(NUM_FAM);
    float gamma = float(k + 1) / float(NUM_FAM * 2);
    vec2  n     = vec2(cos(a), sin(a));
    return floor(dot(p, n) / sp + gamma + 0.5);
}
float sgAllDist(vec2 p, float sp) {
    float d = 1e9;
    for (int k = 0; k < NUM_FAM; k++) d = min(d, sgDist(p, k, sp));
    return d;
}
float sgIdxSum(vec2 p, float sp) {
    float s = 0.0;
    for (int k = 0; k < NUM_FAM; k++) s += sgIdx(p, k, sp);
    return s;
}

// 4-colouring from the index sum modulo 4
// This produces four tile colours matching the 4 tile types in the 12-fold dual
float regionClass(vec2 p, float sp) {
    return mod(sgIdxSum(p, sp), 4.0);
}

vec3 tileColor(float rc) {
    if (rc < 0.5) return C_A;
    if (rc < 1.5) return C_B;
    if (rc < 2.5) return C_C;
    return C_D;
}

// Fine sub-grid for internal decoration
// For 12-fold: the decoration sub-grid is scaled by √3 (the hexagonal sublattice)
float sgFineDist(vec2 p, float sp) {
    return sgAllDist(p, sp / SQRT3);
}

// Continuous rosette potential (cosine sum over 6 families)
float rosettePot12(vec2 p, float sp) {
    float s = 0.0;
    for (int k = 0; k < NUM_FAM; k++) {
        float a = float(k) * PI / float(NUM_FAM);
        float g = float(k + 1) / float(NUM_FAM * 2);
        vec2  n = vec2(cos(a), sin(a));
        s += cos((dot(p, n) / sp + g) * TAU);
    }
    return s;  // range ≈ [-6, +6]; deep minima at 12-fold centres (≈ -6)
}

// ---- Quasiperiodic mode: second interleaved grid at √3 spacing ----
// The combination of spacings 1 and √3 in the same family direction
// breaks periodicity, creating a 12-fold quasicrystalline structure.
float qpAllDist(vec2 p, float sp) {
    float d = 1e9;
    for (int k = 0; k < NUM_FAM; k++) {
        // Two grids per family: sp and sp/√3
        d = min(d, sgDist(p, k, sp));
        d = min(d, sgDist(p, k, sp / SQRT3));
    }
    return d;
}
float qpIdxSum(vec2 p, float sp) {
    float s = 0.0;
    for (int k = 0; k < NUM_FAM; k++) {
        s += sgIdx(p, k, sp);
        s += sgIdx(p, k, sp / SQRT3);
    }
    return s;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

    // Slow rotation — 12-fold has lots of sub-symmetries to reveal
    float rot = iTime * 0.014;
    float cr = cos(rot), sr = sin(rot);
    vec2 p = SCALE * vec2(cr*uv.x - sr*uv.y, sr*uv.x + cr*uv.y);

    float sp = 1.0;
    vec3  col;
    float dMain;

#if TWELV_MODE == 1
    // ---- Quasiperiodic 12-fold ----
    float rc   = mod(qpIdxSum(p, sp), 4.0);
    col   = tileColor(rc);
    dMain = qpAllDist(p, sp);

#else
    // ---- Periodic 12-fold (most historically common) ----
    float rc  = regionClass(p, sp);
    col  = tileColor(rc);
    dMain = sgAllDist(p, sp);
#endif

    // Interior shading
    col *= 0.65 + 0.35 * smoothstep(0.0, 0.28, dMain);

    // Fine decoration sub-grid (hexagonal sub-pattern)
    float dFine    = sgFineDist(p, sp);
    float fineMask = 1.0 - smoothstep(LINE_W*0.4-0.003, LINE_W*0.4+0.003, dFine);
    col = mix(col, col * 0.35 + C_LINE * 0.65, fineMask * 0.45);

    // Glow around main lines
    float glow = 0.009 / (dMain * dMain + 0.001);
    col += C_D * clamp(glow * 0.012, 0.0, 0.5);

    // Main strapwork lines
    float lineMask = 1.0 - smoothstep(LINE_W - 0.004, LINE_W + 0.004, dMain);
    col = mix(col, C_LINE, lineMask);

    // 12-fold rosette centres: gold glow
    float rPot = rosettePot12(p, sp);
    float coreGlow = smoothstep(-4.2, -5.8, rPot);
    col += C_D * coreGlow * 0.35;
    float coreStar = smoothstep(-5.5, -6.0, rPot);
    col = mix(col, C_LINE * 0.85 + C_D * 0.15, coreStar * 0.6);

    // Diffraction "star spike" at 12-fold centres (6 spikes, 30° apart)
    if (coreStar > 0.02) {
        for (int s2 = 0; s2 < 6; s2++) {
            float sa = float(s2) * PI / 6.0;
            vec2  n  = vec2(cos(sa), sin(sa));
            float sd = abs(dot(fract(p / sp + 0.5) - 0.5, n));
            float fl = exp(-sd * sd * 900.0) * coreStar * 0.4;
            col += C_D * fl;
        }
    }

    // Vignette
    col *= 1.0 - dot(uv, uv) * 0.42;

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
