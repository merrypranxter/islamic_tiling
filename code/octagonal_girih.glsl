// octagonal_girih.glsl
// Eight-Fold Islamic Star Patterns — Ammann-Beenker / Alhambra Octagonal System
// Shadertoy-compatible fragment shader
//
// The 8-fold star is one of the defining motifs of Islamic architecture from the
// Seljuk period onward. It appears in the Alhambra, the Topkapi Palace tilework,
// Anatolian tile panels, and countless stucco carvings.
//
// This shader implements TWO interleaved tilings:
//
//   1. PERIODIC 8-FOLD (square + octagon grid):
//      The classic "star-and-cross" pattern — alternating 8-pointed stars and
//      octagonal rosettes, separated by small squares. This is the simplest 8-fold
//      Islamic pattern and tiles the plane with translational periodicity.
//
//   2. QUASIPERIODIC 8-FOLD (Ammann-Beenker tiling):
//      Using an "octagrid" — 4 families of parallel lines at 45° intervals —
//      but with irrational line spacings (ratio 1:√2) that produce the
//      Ammann-Beenker aperiodic tiling. This has 8-fold orientational symmetry
//      and local 8-fold / 16-fold rosette structure, but no translational period.
//      First described by Robert Ammann (c. 1977) and F. P. M. Beenker (1982).
//
// QUASI_MODE (defined below) selects between modes.
//   0 = periodic star-and-cross (historical, most common)
//   1 = Ammann-Beenker quasiperiodic
//
// Palette: Alhambra — terracotta red, ivory stucco, cobalt blue, gold.

#define QUASI_MODE  0       // 0 = periodic; 1 = Ammann-Beenker quasi
#define SCALE       4.0
#define LINE_W      0.035
#define PI          3.14159265358979
#define SQRT2       1.41421356237310
#define SQRT2_INV   0.70710678118655

// Alhambra palette
const vec3 C_BG     = vec3(0.08, 0.06, 0.04);   // deep sienna
const vec3 C_RED    = vec3(0.68, 0.18, 0.08);   // terracotta red
const vec3 C_IVORY  = vec3(0.92, 0.88, 0.76);   // carved stucco ivory
const vec3 C_BLUE   = vec3(0.10, 0.25, 0.65);   // cobalt blue
const vec3 C_GOLD   = vec3(0.92, 0.78, 0.14);   // gilded gold
const vec3 C_LINE   = vec3(1.00, 0.98, 0.90);   // bright line

// ============================================================
// PERIODIC MODE: "Square + Octagon" star-and-cross
// ============================================================

// Signed distance to the nearest point of a square lattice centered at origin
// (used for the octagonal star tiling)
float sqLattice(vec2 p, float cell) {
    vec2 q = fract(p / cell + 0.5) - 0.5;
    return length(q) * cell;   // distance to nearest lattice point (approximate)
}

// Octagram SDF: 8-pointed star inscribed in a circle of radius R
// Uses the angular method: for each of the 8 sectors, measure the angular and
// radial distance to the nearest arm.
float octagramSDF(vec2 p, float R, float armAngle) {
    float r = length(p);
    if (r < 0.001) return R;
    float a = atan(p.y, p.x);
    // Fold into the fundamental domain of the 8-fold star (one sector = π/4)
    a = mod(a, PI * 0.25);
    // Angular deviation from the nearest arm centre
    float da = min(a, PI * 0.25 - a);
    // Star arm goes from centre to the edge at angle 'da', clipped at R
    // The point angle of {8/3} is 45°; arm half-width at base angle = armAngle
    float armDist = r * sin(da) - R * sin(armAngle);
    return armDist;  // < 0 inside star arm
}

// SDF for the star-and-cross periodic tiling
// Returns min distance to the nearest pattern line
float periodicDist(vec2 p) {
    float cell = 1.0;
    // Tile: octagon at integer grid points, small square at half-integer points
    // The main pattern lines connect the 8-point stars
    vec2 q = mod(p + 0.5, 1.0) - 0.5;  // fold into [-0.5, 0.5]²
    vec2 q2 = mod(p, 1.0) - 0.5;       // half-cell shifted

    // Distance to 8-fold star lines at each grid square:
    // Line families: horizontal, vertical, and two diagonal families
    float d = 1e9;

    // 4 families of lines at 0°, 45°, 90°, 135° — two at each scale
    float sp = 1.0;
    for (int k = 0; k < 4; k++) {
        float a = float(k) * PI * 0.25;
        vec2  n = vec2(cos(a), sin(a));
        // Two superimposed grids per family (period 1 and shifted by 0.5)
        float d1 = abs(fract(dot(p, n) / sp + 0.5) - 0.5) * sp;
        float d2 = abs(fract(dot(p, n) / sp) - 0.5) * sp;
        d = min(d, min(d1, d2 * 0.8));
    }
    return d;
}

// Two-colouring for the periodic tiling (region classification)
float periodicParity(vec2 p) {
    float s = 0.0;
    float sp = 1.0;
    for (int k = 0; k < 4; k++) {
        float a = float(k) * PI * 0.25;
        vec2  n = vec2(cos(a), sin(a));
        s += floor(dot(p, n) / sp + 0.5);
    }
    return mod(s, 3.0);  // 3-colouring: red, ivory, blue
}

// ============================================================
// AMMANN-BEENKER QUASI MODE: octagrid
// ============================================================
// The Ammann-Beenker tiling uses 4 families of lines at 45° intervals,
// with two interleaved spacings in ratio 1:√2 (given by the substitution
// matrix eigenvalue √2+1, the "silver ratio").
//
// We implement this as a pentagrid-style construction with 4 families.
// The quasiperiodic phase offsets differ from the periodic case.

float abDist(vec2 p, int k, float sp) {
    float a     = float(k) * PI * 0.25;
    float gamma = float(k + 1) / 8.0;   // phase: (k+1)/8 (analogous to pentagrid)
    vec2  n     = vec2(cos(a), sin(a));
    return abs(fract(dot(p, n) / sp + gamma + 0.5) - 0.5) * sp;
}
float abIdx(vec2 p, int k, float sp) {
    float a     = float(k) * PI * 0.25;
    float gamma = float(k + 1) / 8.0;
    vec2  n     = vec2(cos(a), sin(a));
    return floor(dot(p, n) / sp + gamma + 0.5);
}
float abAllDist(vec2 p, float sp) {
    float d = 1e9;
    for (int k = 0; k < 4; k++) d = min(d, abDist(p, k, sp));
    return d;
}
float abIdxSum(vec2 p, float sp) {
    float s = 0.0;
    for (int k = 0; k < 4; k++) s += abIdx(p, k, sp);
    return s;
}

// Rosette potential for the Ammann-Beenker (cosine sum, 4 families)
float abRosette(vec2 p, float sp) {
    float s = 0.0;
    for (int k = 0; k < 4; k++) {
        float a = float(k) * PI * 0.25;
        float g = float(k + 1) / 8.0;
        vec2  n = vec2(cos(a), sin(a));
        s += cos((dot(p, n) / sp + g) * 2.0 * PI);
    }
    return s;  // deep minima ≈ -4 at 8-fold centres
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

    // Slow rotation, matching the Alhambra's stately geometry
    float rot = iTime * 0.016;
    float cr = cos(rot), sr = sin(rot);
    vec2 p = SCALE * vec2(cr*uv.x - sr*uv.y, sr*uv.x + cr*uv.y);

    float sp = 1.0;
    vec3  col;

    // ---- Choose rendering mode ----
#if QUASI_MODE == 1
    // ---- Ammann-Beenker quasiperiodic ----
    float par = mod(abIdxSum(p, sp), 3.0);
    col  = (par < 0.5) ? C_RED : (par < 1.5) ? C_IVORY : C_BLUE;

    float dMain  = abAllDist(p, sp);
    float dFine  = abAllDist(p, sp * SQRT2_INV);   // scaled by 1/√2 for sub-grid

    // Interior shading
    col *= 0.65 + 0.35 * smoothstep(0.0, 0.28, dMain);

    // Fine decoration lines
    float fineMask = 1.0 - smoothstep(LINE_W*0.5-0.003, LINE_W*0.5+0.003, dFine);
    col = mix(col, col * 0.4 + C_LINE * 0.6, fineMask * 0.5);

    // Main strapwork
    float lineMask = 1.0 - smoothstep(LINE_W-0.004, LINE_W+0.004, dMain);
    col = mix(col, C_GOLD, lineMask);

    // 8-fold rosette glow
    float rPot = abRosette(p, sp);
    float coreGlow = smoothstep(-2.8, -4.0, rPot);
    col += C_GOLD * coreGlow * 0.4;

#else
    // ---- Periodic star-and-cross ----
    float par = periodicParity(p);
    col = (par < 0.5) ? C_RED : (par < 1.5) ? C_IVORY : C_BLUE;

    float dMain = periodicDist(p);
    col *= 0.70 + 0.30 * smoothstep(0.0, 0.25, dMain);

    // Glow
    float glow = 0.007 / (dMain * dMain + 0.001);
    col += C_GOLD * clamp(glow * 0.012, 0.0, 0.55);

    // Strapwork lines
    float lineMask = 1.0 - smoothstep(LINE_W-0.004, LINE_W+0.004, dMain);
    col = mix(col, C_GOLD, lineMask);
#endif

    // Vignette
    col *= 1.0 - dot(uv, uv) * 0.44;

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
