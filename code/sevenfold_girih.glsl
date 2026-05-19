// sevenfold_girih.glsl
// Seven-Fold Islamic Geometry — Heptagrid Quasiperiodic Tiling
// Shadertoy-compatible fragment shader
//
// 7-fold symmetry is the rarest in historical Islamic art — the interior angle
// of a regular heptagon (900°/7 ≈ 128.57°) is irrational with respect to 360°,
// so no regular heptagonal tiling of the plane exists. Instead, a heptagrid
// (7 families of parallel lines, each family at angle k·π/7 for k=0..6) produces
// a quasiperiodic pattern with LOCAL 7-fold and 14-fold symmetry, analogous to
// the pentagrid's 5-fold/10-fold symmetry.
//
// Mathematical properties:
//   • 7 line families at angles 0°, 25.7°, 51.4°, 77.1°, 102.9°, 128.6°, 154.3°
//   • Index sum modulo 7 → tile class (7 tile types in the dual)
//   • No known historical Islamic examples — this represents what medieval
//     artisans could have created had they extended the system further
//   • The dual tiling contains thin and thick rhombi with angles that are
//     multiples of 180°/7 ≈ 25.71°
//
// Colour palette: purple-gold — the exotic "alien" quality of 7-fold, combined
// with traditional Islamic gold leaf, evoking forbidden geometry.

#define SCALE           4.5
#define LINE_W          0.032
#define GLOW_W          0.10
#define NUM_FAM         7
#define PI              3.14159265358979
#define TAU             6.28318530717959
// Glow rendering
#define GLOW_SCALE      0.010
#define GLOW_CAP        0.65

// Heptagrid phase offsets γ_k: shifted by (k+1)/(2·NUM_FAM) to avoid singularity
// at the origin (same convention as the pentagrid in basic_girih.glsl)
#define GAMMA_DENOM     14.0   // = 2 * NUM_FAM

// Colour palette
const vec3 C_BG     = vec3(0.06, 0.04, 0.18);   // deep violet-black
const vec3 C_TILE_A = vec3(0.15, 0.05, 0.40);   // dark purple tile
const vec3 C_TILE_B = vec3(0.30, 0.08, 0.55);   // brighter purple tile
const vec3 C_LINE   = vec3(0.95, 0.82, 0.12);   // 24-karat gold
const vec3 C_GLOW   = vec3(0.55, 0.35, 0.08);   // amber glow
const vec3 C_ACCENT = vec3(0.80, 0.25, 0.60);   // magenta accent (7-fold "forbidden" hue)

// Heptagrid signed-distance to the nearest line in family k
// Family k: normals at angle k·π/7; lines spaced 'sp' apart with phase γ_k
float hgDist(vec2 p, int k, float sp) {
    float a     = float(k) * PI / float(NUM_FAM);
    float gamma = float(k + 1) / GAMMA_DENOM;
    vec2  n     = vec2(cos(a), sin(a));
    float proj  = dot(p, n) / sp + gamma;
    return abs(fract(proj + 0.5) - 0.5) * sp;
}

// Heptagrid index for family k (which stripe of parallel lines the point is in)
float hgIdx(vec2 p, int k, float sp) {
    float a     = float(k) * PI / float(NUM_FAM);
    float gamma = float(k + 1) / GAMMA_DENOM;
    vec2  n     = vec2(cos(a), sin(a));
    return floor(dot(p, n) / sp + gamma + 0.5);
}

// Minimum distance across all 7 families
float allDist(vec2 p, float sp) {
    float d = 1e9;
    for (int k = 0; k < NUM_FAM; k++) d = min(d, hgDist(p, k, sp));
    return d;
}

// Sum of all 7 indices — determines tile class in the dual
float idxSum(vec2 p, float sp) {
    float s = 0.0;
    for (int k = 0; k < NUM_FAM; k++) s += hgIdx(p, k, sp);
    return s;
}

// Region parity (two-colouring): sum mod 2 for a gold/purple tile alternation
float regionParity(vec2 p, float sp) {
    return mod(idxSum(p, sp), 2.0);
}

// Fine sub-grid: same heptagrid scaled down by the heptagonal "inflation ratio"
// For 7-fold, the self-similar scaling factor is 2·cos(π/7) ≈ 1.8019
// (smallest positive root of x³ − x² − 2x + 1 = 0, related to the cosines of π/7)
#define HEPT_INF  1.80193773580484  // 2·cos(π/7)

float fineDist(vec2 p, float sp) {
    return allDist(p, sp / HEPT_INF);
}

// Rosette potential: continuous sum of cosines → deep minima at 7-fold centres
float rosettePot(vec2 p, float sp) {
    float s = 0.0;
    for (int k = 0; k < NUM_FAM; k++) {
        float a     = float(k) * PI / float(NUM_FAM);
        float gamma = float(k + 1) / GAMMA_DENOM;
        vec2  n     = vec2(cos(a), sin(a));
        s += cos((dot(p, n) / sp + gamma) * TAU);
    }
    return s;  // range approximately [-7, +7]; minima ≈ -7 at tile centres
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

    // Slow rotation — evoking the "forbidden" 7-fold symmetry slowly turning
    float rot = iTime * 0.012;
    float cr = cos(rot), sr = sin(rot);
    vec2 p = SCALE * vec2(cr*uv.x - sr*uv.y, sr*uv.x + cr*uv.y);

    float sp = 1.0;

    // ---- Background: two-tone purple tiles ----
    float par = regionParity(p, sp);
    vec3  col = mix(C_TILE_A, C_TILE_B, par * 0.5);

    // Subtle shading by distance to nearest line (interior darkening)
    float dMain = allDist(p, sp);
    col *= 0.6 + 0.4 * smoothstep(0.0, 0.3, dMain);

    // ---- Fine sub-grid decoration lines (heptagrid at inflation-reduced scale) ----
    float dFine    = fineDist(p, sp);
    float fineMask = 1.0 - smoothstep(LINE_W * 0.4 - 0.003, LINE_W * 0.4 + 0.003, dFine);
    // Fine lines are gold-tinted but dimmer than main lines
    col = mix(col, C_LINE * 0.55 + col * 0.45, fineMask * 0.55);

    // ---- Glow halo around main lines ----
    float glow = GLOW_W / (dMain * dMain + 0.001);
    glow = clamp(glow * GLOW_SCALE, 0.0, GLOW_CAP);
    col += C_GLOW * glow;

    // ---- Main gold strapwork lines ----
    float lineMask = 1.0 - smoothstep(LINE_W - 0.004, LINE_W + 0.004, dMain);
    col = mix(col, C_LINE, lineMask);

    // ---- Rosette centres: accent glow at 7-fold focal points ----
    float rPot = rosettePot(p, sp);
    // rPot ≈ -7 at tile-family intersection centres (14-fold points)
    float centreGlow = smoothstep(-5.5, -6.8, rPot);
    col += C_ACCENT * centreGlow * 0.45;
    // Bright core at deepest minima
    float coreMask = smoothstep(-6.5, -7.0, rPot);
    col = mix(col, C_LINE * 0.9 + C_ACCENT * 0.1, coreMask * 0.7);

    // ---- Pulsing accent on fine lines (7-beat rhythm) ----
    float pulse = 0.5 + 0.5 * sin(iTime * 0.7 * TAU / 7.0);
    col += C_ACCENT * fineMask * pulse * 0.12;

    // Vignette
    col *= 1.0 - dot(uv, uv) * 0.48;

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
