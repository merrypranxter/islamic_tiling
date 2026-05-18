// girih_tiles.glsl
// Five Girih Tiles — Aperiodic Quasiperiodic Tiling
// Shadertoy-compatible fragment shader
//
// The five girih tiles (decagon, pentagon, elongated hexagon/barrel,
// bow-tie, rhombus) are the decorative vocabulary of medieval Islamic
// geometric art. They are equivalent to a decorated Penrose P3 tiling.
//
// This shader uses the Penrose rhombus tiling (fat τ² : thin 1 ratio,
// τ = golden ratio ≈ 1.618) generated iteratively via the "index sum"
// classification from the pentagrid, then maps each region to a girih
// tile type and renders its internal decoration lines.
//
// Tile colours follow historical pigment choices:
//   Decagon  (10) → lapis blue    (most prestigious, rarest)
//   Pentagon  (5) → terracotta    (fired clay)
//   Barrel    (6) → turquoise     (faience glaze)
//   Bow-tie   (6) → ivory/cream   (carved stucco)
//   Rhombus   (4) → saffron gold  (gilded)

#define SCALE      4.0
#define LINE_W     0.035
#define PI         3.14159265358979
#define TAU        6.28318530717959
#define PHI        1.61803398874989   // golden ratio τ

// Girih tile palette
const vec3 C_DECA = vec3(0.10, 0.20, 0.60);  // lapis blue
const vec3 C_PENT = vec3(0.72, 0.28, 0.14);  // terracotta
const vec3 C_BARR = vec3(0.12, 0.60, 0.65);  // turquoise
const vec3 C_BWTI = vec3(0.93, 0.90, 0.78);  // ivory
const vec3 C_RHOM = vec3(0.85, 0.72, 0.12);  // saffron
const vec3 C_LINE = vec3(1.00, 1.00, 1.00);  // white decoration lines
const vec3 C_BG   = vec3(0.04, 0.08, 0.20);

// Pentagrid helpers (same as basic_girih)
float pgDist(vec2 p, int k, float sp) {
    float a = float(k) * PI / 5.0;
    float g = float(k + 1) / 10.0;
    vec2  n = vec2(cos(a), sin(a));
    return abs(fract(dot(p,n)/sp + g + 0.5) - 0.5) * sp;
}
float pgIdx(vec2 p, int k, float sp) {
    float a = float(k) * PI / 5.0;
    float g = float(k + 1) / 10.0;
    vec2  n = vec2(cos(a), sin(a));
    return floor(dot(p,n)/sp + g + 0.5);
}

// Sum of pentagrid indices (determines tile type via mod-10 class)
// In the Penrose dual:
//   sum mod 10 ∈ {0,5}    → decagon vertex  (10 lines meet)
//   sum mod 10 ∈ {1,4,6,9}→ pentagon vertex (5-fold)
//   sum mod 10 ∈ {2,3,7,8}→ rhombus region  (fat or thin)
float pgSum(vec2 p, float sp) {
    float s = 0.0;
    for (int k = 0; k < 5; k++) s += pgIdx(p, k, sp);
    return s;
}

// Minimum distance to all 5 line families
float allDist(vec2 p, float sp) {
    float d = 1e9;
    for (int k = 0; k < 5; k++) d = min(d, pgDist(p, k, sp));
    return d;
}

// --- Tile type from index sum modulo 10 ---
// The mod-10 classes partition the dual pentagrid into tile types.
// Boundaries are at half-integers between the 10 equivalence classes:
//   class 0 and 5 → decagon (the two antipodal 10-fold centres)
//   class 1,4,6,9 → pentagon/bowtie
//   class 2,3,7,8 → barrel/rhombus
// TILE_EPS (0.5) is the half-integer threshold separating adjacent classes.
// Additional class boundaries (all half-integers between mod-10 classes):
#define TILE_EPS       0.5   // classes 0/1 boundary
#define TILE_B25       2.5   // classes 1/2 boundary
#define TILE_B35       3.5   // classes 2/3 boundary
#define TILE_B45       4.5   // classes 3/4 boundary
#define TILE_B55       5.5   // classes 5/6 boundary  (antipodal to 0.5)
#define TILE_B65       6.5   // classes 6/7 boundary
#define TILE_B75       7.5   // classes 7/8 boundary
int tileType(vec2 p, float sp) {
    float s = mod(pgSum(p, sp), 10.0);
    if (s < TILE_EPS || (s > TILE_B45 && s < TILE_B55))   return 0; // decagon
    if (s < TILE_B25  || (s > TILE_B75))                  return 1; // pentagon
    if (s < TILE_B35  || (s > TILE_B65 && s < TILE_B75))  return 2; // barrel
    if (s < TILE_B45  || (s > TILE_B55 && s < TILE_B65))  return 3; // bowtie
    return 4;                                                         // rhombus
}

vec3 tileColor(int t) {
    if (t == 0) return C_DECA;
    if (t == 1) return C_PENT;
    if (t == 2) return C_BARR;
    if (t == 3) return C_BWTI;
    return C_RHOM;
}

// Decoration line inside a tile: direction-specific angle bands
// The internal strapwork makes an angle of 54° (3π/10) with each edge.
float decorLine(vec2 p, float sp) {
    float d = 1e9;
    // Decoration lines run parallel to the pentagrid at half-spacing offsets
    for (int k = 0; k < 5; k++) {
        float a  = float(k) * PI / 5.0;
        float g  = float(k + 1) / 10.0;
        vec2  n  = vec2(cos(a), sin(a));
        float pr = dot(p, n) / sp + g;
        // Half-integer positions give the interior decoration lines
        float t1 = abs(fract(pr) - 0.5);
        d = min(d, t1 * sp);
    }
    return d;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    // Slow rotation
    float rot = iTime * 0.02;
    float cr = cos(rot), sr = sin(rot);
    vec2 p = SCALE * vec2(cr*uv.x - sr*uv.y, sr*uv.x + cr*uv.y);

    float sp = 1.0;

    // Determine tile type and base colour
    int   tt  = tileType(p, sp);
    vec3  col = tileColor(tt);

    // Edge lines (strapwork proper)
    float dEdge  = allDist(p, sp);
    float dDecor = decorLine(p, sp);

    // Slightly darken tile interior away from edges
    col *= 0.75 + 0.25 * smoothstep(0.0, 0.25, dEdge);

    // Decoration / internal strapwork lines (thinner, slightly transparent)
    float decorMask = 1.0 - smoothstep(LINE_W*0.5 - 0.003, LINE_W*0.5 + 0.003, dDecor);
    col = mix(col, col * 0.3 + C_LINE * 0.7, decorMask * 0.6);

    // Main edge lines
    float edgeMask = 1.0 - smoothstep(LINE_W - 0.004, LINE_W + 0.004, dEdge);
    col = mix(col, C_LINE, edgeMask);

    // Vignette
    col *= 1.0 - dot(uv,uv) * 0.45;

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
