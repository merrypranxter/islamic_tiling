// strapwork.glsl
// Islamic Strapwork — Interlaced Woven Bands with Over/Under Weaving
// Shadertoy-compatible fragment shader
//
// Strapwork is the three-dimensional illusion of woven ribbons crossing
// over and under each other. The "alternating rule" means: as you follow
// any single ribbon, it passes alternately over then under each ribbon it
// crosses. This shader implements:
//   1. 5-family pentagrid to locate line positions and crossings
//   2. Per-strand index parity to determine over/under at each crossing
//   3. Shadow/highlight: over-strand is bright, under-strand is darkened
//   4. The ribbon has a finite width with bevelled edges
//
// Shadow rendering constants
// SHADOW_OPACITY: fraction of COL_SHADOW blended onto background below an over-strand
// SHADOW_FRINGE_OPACITY: maximum shadow blend at crossing edge
// OVER_THRESHOLD: bias added to ou before step() to sharpen the over/under decision
#define SHADOW_OPACITY       0.4
#define SHADOW_FRINGE_OPACITY 0.5
#define OVER_THRESHOLD       0.1

#define SCALE            3.5
#define BAND_W           0.10      // half-width of each band ribbon
#define BAND_EDGE        0.02      // bevel/anti-alias edge width
#define SHADOW_D         0.015     // shadow offset at crossing
#define PI               3.14159265358979
// Parity threshold: mod(mA+mB, 2) < PARITY_THRESHOLD → family A is "over"
// Value of 0.5 gives a clean 50/50 split between over and under strands
#define PARITY_THRESHOLD 0.5

const vec3 COL_GOLD   = vec3(0.95, 0.78, 0.10);
const vec3 COL_BLUE   = vec3(0.08, 0.18, 0.55);
const vec3 COL_SHADOW = vec3(0.02, 0.04, 0.12);
const vec3 COL_BG     = vec3(0.06, 0.09, 0.25);
const vec3 COL_HILITE = vec3(1.00, 0.95, 0.70);

// Pentagrid utilities -------------------------------------------------------
float pgAngle(int k) { return float(k) * PI / 5.0; }
float pgGamma(int k) { return float(k + 1) / 10.0; }

// Projection of p onto family-k normal, in units of spacing
float pgProj(vec2 p, int k, float sp) {
    float a = pgAngle(k);
    return dot(p, vec2(cos(a), sin(a))) / sp + pgGamma(k);
}

// Strand index for family k (which ribbon strand)
float strandIdx(vec2 p, int k, float sp) {
    return floor(pgProj(p, k, sp) + 0.5);
}

// Distance from p to the centreline of the nearest ribbon in family k
float strandDist(vec2 p, int k, float sp) {
    return abs(fract(pgProj(p, k, sp) + 0.5) - 0.5) * sp;
}

// Which family's ribbon is closest to p, and which strand index
int   closestFamily(vec2 p, float sp) {
    float dmin = 1e9; int best = 0;
    for (int k = 0; k < 5; k++) {
        float d = strandDist(p, k, sp);
        if (d < dmin) { dmin = d; best = k; }
    }
    return best;
}

// At a crossing between family A (strand mA) and family B (strand mB),
// the over/under parity is determined by (mA + mB) mod 2.
// Returns +1.0 if family A is OVER family B at this point, -1.0 if under.
float overUnder(vec2 p, int famA, float sp) {
    // Find the second-closest family (the one we're crossing)
    float d1 = strandDist(p, famA, sp);
    float d2min = 1e9; int famB = -1;
    for (int k = 0; k < 5; k++) {
        if (k == famA) continue;
        float d = strandDist(p, k, sp);
        if (d < d2min) { d2min = d; famB = k; }
    }
    if (famB < 0) return 1.0;
    float mA = strandIdx(p, famA, sp);
    float mB = strandIdx(p, famB, sp);
    return (mod(mA + mB, 2.0) < PARITY_THRESHOLD) ? 1.0 : -1.0;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    float rot = iTime * 0.015;
    float cr = cos(rot), sr = sin(rot);
    vec2 p = SCALE * vec2(cr*uv.x - sr*uv.y, sr*uv.x + cr*uv.y);

    float sp = 1.0;

    vec3  col     = COL_BG;
    float minDist = 1e9;
    int   minFam  = 0;

    // Find which ribbon (if any) we are on
    for (int k = 0; k < 5; k++) {
        float d = strandDist(p, k, sp);
        if (d < minDist) { minDist = d; minFam = k; }
    }

    // Are we inside a ribbon?
    float inside = 1.0 - smoothstep(BAND_W - BAND_EDGE, BAND_W + BAND_EDGE, minDist);

    if (inside > 0.001) {
        // Ribbon colour alternates gold/blue by family index parity
        float fParity = mod(float(minFam), 2.0);
        vec3  bandCol = mix(COL_BLUE, COL_GOLD, fParity);

        // Over/under determination
        float ou = overUnder(p, minFam, sp);

        // Highlight on top surface, shadow beneath
        float highlight = ou > 0.0 ? 0.35 : 0.0;
        float shadow    = ou < 0.0 ? 0.55 : 0.0;

        // Edge bevel: brighter at the ribbon edges (physical weave highlight)
        float edgeT = smoothstep(BAND_W - BAND_EDGE, BAND_W, minDist);
        bandCol = mix(bandCol, bandCol * 0.5, shadow);
        bandCol = mix(bandCol, COL_HILITE, highlight * (1.0 - edgeT) * 0.4);
        bandCol = mix(bandCol, bandCol * 0.6, edgeT * 0.4);

        // Drop shadow: darken background near ribbon edge when under
        float shadowFringe = smoothstep(BAND_W + BAND_EDGE,
                                        BAND_W + BAND_EDGE + SHADOW_D, minDist);
        col = mix(col, COL_SHADOW * SHADOW_FRINGE_OPACITY,
                  (1.0 - shadowFringe) * SHADOW_OPACITY * step(0.0, ou - OVER_THRESHOLD));

        col = mix(col, bandCol, inside);
    }

    // Vignette
    col *= 1.0 - dot(uv,uv) * 0.5;

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
