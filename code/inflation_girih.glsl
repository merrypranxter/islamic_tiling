// inflation_girih.glsl
// Self-Similar Inflation — Watching the Quasicrystal Unfold
// Shadertoy-compatible fragment shader
//
// The defining mathematical property of the girih tiling is self-similarity:
// inflation by the golden ratio squared (φ² ≈ 2.618) maps the tiling to itself.
// This means: if you zoom out by factor φ², you see the same pattern again.
//
// This shader makes that self-similarity VISIBLE as an animation:
//
//   PHASE 1 (0–4s): Show the coarse tiling (large tiles, scale 1)
//   PHASE 2 (4–8s): Animate DEFLATION — each large tile dissolves into the
//                   corresponding arrangement of small tiles (scale 1/φ²)
//   PHASE 3 (8–12s): Show the fine tiling (small tiles, fully revealed)
//   PHASE 4 (12–16s): Animate INFLATION — small tiles recombine into large
//   Loop.
//
// The two levels are rendered simultaneously with transparency:
//   • Coarse level: drawn in lapis blue / gold (historic Darb-i Imam colours)
//   • Fine level: drawn in turquoise / ivory (smaller, more delicate)
//   • The transition region smoothly cross-fades between the two levels
//
// Both levels use the same pentagrid construction; the fine level is simply
// the pentagrid scaled by 1/φ² (exactly the Darb-i Imam two-level hierarchy).
//
// Inflation/deflation constants:
//   PHI_SQ: the inflation scale factor φ² = (3+√5)/2 ≈ 2.6180
//   PHASE_DUR: duration of each animation phase in seconds
//   TRANS_W: width of the cross-fade transition in animation time units

#define PHI         1.61803398874989
#define PHI2        2.61803398874989   // φ²
#define SCALE       4.0
#define LINE_W      0.030
#define FINE_W      0.018
#define PI          3.14159265358979
#define PHASE_DUR   4.0               // seconds per phase
#define TRANS_W     0.3               // fade transition fraction (0..1)
// Rosette field thresholds for the two levels:
//   COARSE_GLOW: outer edge of coarse-level rosette glow
//   FINE_GLOW: outer edge of fine-level rosette glow
#define COARSE_GLOW  -4.3
#define FINE_GLOW    -4.3

// Level colours
const vec3 C_BG_COARSE   = vec3(0.06, 0.12, 0.50);  // lapis blue (large tiles)
const vec3 C_LINE_COARSE = vec3(0.92, 0.78, 0.14);  // gold
const vec3 C_GLOW_COARSE = vec3(0.55, 0.40, 0.08);  // amber
const vec3 C_GOLD_ACC    = vec3(1.00, 0.90, 0.50);  // gilt accent

const vec3 C_BG_FINE     = vec3(0.08, 0.50, 0.58);  // turquoise (small tiles)
const vec3 C_LINE_FINE   = vec3(0.95, 0.92, 0.80);  // ivory
const vec3 C_GLOW_FINE   = vec3(0.35, 0.25, 0.06);  // warm amber

const vec3 C_BG          = vec3(0.04, 0.08, 0.28);  // field background

// ---- Pentagrid helpers ----
float pgD(vec2 p, int k, float sp) {
    float a = float(k) * PI / 5.0, g = float(k+1) / 10.0;
    return abs(fract(dot(p, vec2(cos(a), sin(a))) / sp + g + 0.5) - 0.5) * sp;
}
float pgI(vec2 p, int k, float sp) {
    float a = float(k) * PI / 5.0, g = float(k+1) / 10.0;
    return floor(dot(p, vec2(cos(a), sin(a))) / sp + g + 0.5);
}
float allD(vec2 p, float sp) {
    float d = 1e9;
    for (int k = 0; k < 5; k++) d = min(d, pgD(p, k, sp));
    return d;
}
float sumI(vec2 p, float sp) {
    float s = 0.0;
    for (int k = 0; k < 5; k++) s += pgI(p, k, sp);
    return s;
}
float rosettePot(vec2 p, float sp) {
    float s = 0.0;
    for (int k = 0; k < 5; k++) {
        float a = float(k) * PI / 5.0, g = float(k+1) / 10.0;
        s += cos((dot(p, vec2(cos(a), sin(a))) / sp + g) * 2.0 * PI);
    }
    return s;
}

// Render one level of the tiling at spacing 'sp'
// Returns (colour, alpha) — alpha encodes "activity" of this level
vec4 renderLevel(vec2 p, float sp, vec3 bgCol, vec3 lineCol, vec3 glowCol,
                 float lw, float alpha) {
    float parity = mod(sumI(p, sp), 2.0);
    vec3  col    = mix(bgCol, bgCol * 1.5, parity * 0.4);

    float d = allD(p, sp);

    // Glow
    float glow = 0.007 / (d * d + 0.001);
    col += glowCol * clamp(glow * 0.012, 0.0, 0.55);

    // Lines
    float lm = 1.0 - smoothstep(lw - 0.004, lw + 0.004, d);
    col = mix(col, lineCol, lm);

    // Rosette accent
    float rPot = rosettePot(p, sp);
    float rGlow = smoothstep(COARSE_GLOW, -5.0, rPot);
    col += glowCol * 0.8 * rGlow * 0.5;

    return vec4(col, alpha);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

    // Slow pan during the animation to reveal more of the tiling
    vec2 pan = vec2(cos(iTime * 0.03) * 0.2, sin(iTime * 0.025) * 0.2);
    vec2 p   = (uv + pan) * SCALE;

    // ---- Animation timeline ----
    // 4-phase cycle: coarse → deflate → fine → inflate → coarse ...
    float t      = mod(iTime, PHASE_DUR * 4.0);   // 0..16s
    float phase  = t / PHASE_DUR;                  // 0..4 continuous
    float phaseI = floor(phase);                   // integer phase 0..3
    float phaseF = fract(phase);                   // fraction within phase

    // Cross-fade weight for each level during transitions
    // Phase 0: coarse fully visible, fine hidden
    // Phase 1: cross-fade from coarse to fine (deflation)
    // Phase 2: fine fully visible, coarse hidden
    // Phase 3: cross-fade from fine to coarse (inflation)

    float coarseAlpha, fineAlpha;
    float transF = smoothstep(0.0, TRANS_W, phaseF) * (1.0 - smoothstep(1.0-TRANS_W, 1.0, phaseF));

    if (phaseI < 0.5) {
        // Phase 0: coarse
        coarseAlpha = 1.0; fineAlpha = 0.0;
    } else if (phaseI < 1.5) {
        // Phase 1: deflation — coarse fades, fine grows
        float fade = smoothstep(0.0, 1.0, phaseF);
        coarseAlpha = 1.0 - fade;
        fineAlpha   = fade;
    } else if (phaseI < 2.5) {
        // Phase 2: fine
        coarseAlpha = 0.0; fineAlpha = 1.0;
    } else {
        // Phase 3: inflation — fine fades, coarse grows
        float fade = smoothstep(0.0, 1.0, phaseF);
        coarseAlpha = fade;
        fineAlpha   = 1.0 - fade;
    }

    vec3 col = C_BG;

    // ---- Render coarse level (large tiles, spacing sp=1) ----
    if (coarseAlpha > 0.001) {
        vec4 coarse = renderLevel(p, 1.0, C_BG_COARSE, C_LINE_COARSE, C_GLOW_COARSE,
                                  LINE_W, coarseAlpha);
        col = mix(col, coarse.rgb, coarseAlpha);
    }

    // ---- Render fine level (small tiles, spacing sp=1/φ²) ----
    if (fineAlpha > 0.001) {
        vec4 fine = renderLevel(p, 1.0 / PHI2, C_BG_FINE, C_LINE_FINE, C_GLOW_FINE,
                                FINE_W, fineAlpha);
        col = mix(col, fine.rgb, fineAlpha);
    }

    // ---- "Inflation arrows" during transition phases: visualize the mapping ----
    // During Phase 1/3, draw faint guide lines showing which large tiles
    // map to which small tiles (the φ² inflation boundary lines)
    float isTransPhase = max(
        (phaseI > 0.5 && phaseI < 1.5) ? transF : 0.0,
        (phaseI > 2.5)                  ? transF : 0.0
    );
    if (isTransPhase > 0.001) {
        // Inflation boundaries: the large-tile edges visible through the fine-tile overlay
        float dInflation = allD(p, 1.0);
        float inflLine   = 1.0 - smoothstep(LINE_W*2.0-0.005, LINE_W*2.0+0.005, dInflation);
        col += C_GOLD_ACC * inflLine * isTransPhase * 0.5;
    }

    // Vignette
    col *= 1.0 - dot(uv, uv) * 0.42;

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
