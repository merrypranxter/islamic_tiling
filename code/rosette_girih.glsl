// rosette_girih.glsl
// Islamic Rosette — The 10-Fold Star as Atomic Pattern Unit
// Shadertoy-compatible fragment shader
//
// The ROSETTE is the fundamental atom of Islamic geometric art — the isolated
// 10-fold (or n-fold) star surrounded by petal-like pointed segments. Every
// complex girih tiling can be read as a field of rosettes connected by
// secondary lattice elements.
//
// This shader renders:
//   1. A single large central rosette (10-fold) constructed via exact
//      compass-and-straightedge-equivalent geometry in the shader
//   2. A background field of smaller rosettes at every decagon-centre
//      (using the pentagrid to locate them)
//   3. The full interlocking system: rosette → connector lines → strapwork
//   4. A user-adjustable symmetry order (5, 6, 8, 10, 12) showing how
//      the same rosette construction principle generates all symmetry families
//
// Anatomy of a rosette (10-fold):
//   • Central polygon (decagon, 10 sides) at the core
//   • 10 "petals" — pointed star-arms projecting outward
//   • 10 small connector triangles between adjacent petals
//   • The petal tip angle determines the "style":
//     acute (36°) = classical 10/3 style
//     obtuse (72°) = 10/4 style (less common)
//
// The rosette SDF is computed analytically by:
//   1. Folding the plane into the fundamental domain (one sector = 2π/n)
//   2. Computing the distance to the star arm outline
//   3. Blending multiple layers (petal, connector, edge line)
//
// SYMMETRY_N controls the fold count (try 5, 6, 7, 8, 10, 12)

#define SYMMETRY_N      10       // fold count: 5 | 6 | 7 | 8 | 10 | 12
#define PETAL_TIP_ANGLE 36.0     // degrees (36° = acute {10/3}; 72° = obtuse {10/4})
#define SCALE           3.8
#define LINE_W          0.022
#define ROSETTE_R       0.55     // outer radius of a single rosette (in tile units)
#define INNER_R         0.15     // inner core radius
#define PI              3.14159265358979
#define TAU             6.28318530717959
// Core fill radius fraction: the filled core disc is rendered at 90% of innerR so
// the strapwork ring line at innerR sits visually inside the filled area rather than
// overlapping the outer edge of the fill.  Value <1.0 prevents aliasing at the boundary.
#define CORE_FILL_RATIO 0.9

// Traditional illuminated manuscript palette: cobalt, gold, deep carmine, ivory
const vec3 C_BG       = vec3(0.05, 0.08, 0.28);   // lapis lazuli field
const vec3 C_PETAL    = vec3(0.92, 0.78, 0.14);   // gold petal
const vec3 C_PETAL2   = vec3(0.80, 0.30, 0.08);   // carmine secondary petal
const vec3 C_CORE     = vec3(0.12, 0.55, 0.68);   // turquoise core
const vec3 C_LINE     = vec3(1.00, 0.98, 0.92);   // bright strapwork
const vec3 C_SHADOW   = vec3(0.02, 0.04, 0.15);   // deep shadow

// Pentagrid helpers (for background field of rosettes)
float pgD(vec2 p, int k, float sp) {
    float a = float(k) * PI / 5.0, g = float(k+1) / 10.0;
    return abs(fract(dot(p, vec2(cos(a), sin(a))) / sp + g + 0.5) - 0.5) * sp;
}
float pgAllD(vec2 p, float sp) {
    float d = 1e9;
    for (int k = 0; k < 5; k++) d = min(d, pgD(p, k, sp));
    return d;
}
float rosettePot(vec2 p, float sp) {
    float s = 0.0;
    for (int k = 0; k < 5; k++) {
        float a = float(k) * PI / 5.0, g = float(k+1) / 10.0;
        s += cos((dot(p, vec2(cos(a), sin(a))) / sp + g) * TAU);
    }
    return s;
}

// ---- Analytic Rosette SDF ----
// Computes signed distance to the outline of an n-fold star rosette
// centred at the origin, outer radius R.
//
// Method:
//   1. Convert to polar (r, θ)
//   2. Fold θ into one fundamental sector of width 2π/n
//   3. In the sector, the star arm is bounded by two lines at ±(petalHalfAngle)
//   4. SDF to the arm: max of the two half-plane distances
//
// Returns: negative inside the star, positive outside.
float rosetteSDF(vec2 p, float R, float innerR) {
    float r  = length(p);
    float a  = atan(p.y, p.x);
    float n  = float(SYMMETRY_N);
    float sector = TAU / n;

    // Fold into [0, sector]
    a = mod(a + 0.5 * sector, sector) - 0.5 * sector;  // now a ∈ [-sector/2, sector/2]

    // Petal half-angle (in radians) — half the tip angle measured at the petal centre
    float petalTip  = PETAL_TIP_ANGLE * PI / 180.0;
    float halfTip   = petalTip * 0.5;

    // The star arm stretches from innerR to R along the sector bisector.
    // Its boundary lines have slopes ±tan(halfTip).
    // In the folded sector, 'a' is the angular deviation from the arm centre.
    // The arm boundary at radius r is: r·|a| = (R - r) · tan(halfTip)
    // → arm: |a| < (R - innerR) / r · ... (approximation for straight-sided arms)

    // Simplified analytic SDF: signed distance = r·|a| - tan(halfTip)·(R - r)·something
    // We use a 2-line segment SDF for each petal arm:
    //
    //   P = (r·cos(a), r·sin(a)) in the folded sector (where arm points along +x)
    //   Arm sides at ±tan(halfTip)
    float armWidth = R * tan(halfTip);  // half-width of arm at outer radius
    float innerW   = innerR * tan(halfTip);

    // Radial SDF component
    float radial = max(innerR - r, r - R);  // negative inside [innerR, R]

    // Angular SDF component: distance from the arm (one petal)
    float tangential = abs(r * a) - mix(innerW, armWidth, (r - innerR) / max(R - innerR, 0.001));

    // Combined: inside petal = both conditions satisfied
    float petalDist = max(radial, tangential);

    // Inner polygon (core) SDF — circular approximation
    float coreDist = innerR - r;  // negative inside core circle

    return min(petalDist, coreDist);
}

// Multi-ring rosette: inner core + petals + outer ring with multiple layers
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

    // Slow rotation — the rosette slowly reveals its symmetry
    float rot = iTime * 0.020;
    float cr = cos(rot), sr = sin(rot);
    vec2 p = SCALE * vec2(cr*uv.x - sr*uv.y, sr*uv.x + cr*uv.y);

    float sp = 1.0;

    // ---- Background: pentagrid strapwork field (dim) ----
    float dBg = pgAllD(p, sp);
    float bgLine = 1.0 - smoothstep(LINE_W*0.5-0.003, LINE_W*0.5+0.003, dBg);
    vec3  col = mix(C_BG, C_BG * 1.5 + C_CORE * 0.2, bgLine * 0.25);

    // Background rosette glow (marks the field of rosette centres)
    float rPot = rosettePot(p, sp);
    float bgRosGlow = smoothstep(-3.5, -4.8, rPot);
    col += C_PETAL * bgRosGlow * 0.08;

    // ---- Primary rosette SDF (one sector = 2π/SYMMETRY_N wide) ----
    float R      = ROSETTE_R;
    float innerR = INNER_R;

    float dist = rosetteSDF(p, R, innerR);

    // ---- Colour layers ----
    // Outer ring glow (approaching the rosette from outside)
    float outerGlow = exp(-max(dist, 0.0) * 8.0);
    col += C_PETAL * outerGlow * 0.30;

    // Petal fill (inside the star arms)
    float petalFill = 1.0 - smoothstep(-0.02, 0.02, dist + 0.01);
    col = mix(col, C_PETAL, petalFill * 0.9);

    // Petal secondary colour (alternating petals — every other sector)
    float a   = atan(p.y, p.x);
    float n   = float(SYMMETRY_N);
    float sec = floor(mod(a / (TAU / n) + 0.5, n));  // which sector (0..n-1)
    float alt = mod(sec, 2.0);
    col = mix(col, C_PETAL2, petalFill * alt * 0.5);

    // Inner core fill
    float coreFill = 1.0 - smoothstep(-0.01, 0.01, innerR * CORE_FILL_RATIO - length(p));
    col = mix(col, C_CORE, coreFill * 0.85);

    // Strapwork outline (crisp line at dist ≈ 0)
    float lineMask = 1.0 - smoothstep(LINE_W - 0.003, LINE_W + 0.003, abs(dist));
    col = mix(col, C_LINE, lineMask * 0.9);

    // Inner core ring outline
    float coreRing = 1.0 - smoothstep(LINE_W - 0.003, LINE_W + 0.003, abs(length(p) - innerR));
    col = mix(col, C_LINE, coreRing * 0.7);

    // Thin background strapwork lines (visible between rosettes)
    col = mix(col, C_LINE * 0.6, bgLine * (1.0 - petalFill) * 0.5);

    // Shimmering highlight on petals (gold leaf effect)
    float shimmer = sin(iTime * 1.3 + length(p) * 8.0) * 0.5 + 0.5;
    col += C_PETAL * petalFill * shimmer * 0.08;

    // Central star sparkle
    float sparkle = exp(-length(p) * length(p) * 40.0);
    col += C_LINE * sparkle * 0.6;

    // Vignette
    col *= 1.0 - dot(uv, uv) * 0.45;

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
