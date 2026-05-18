// basic_girih.glsl
// Islamic Girih Tiling — 10-fold Star Pattern via Pentagrid
// Shadertoy-compatible fragment shader
//
// The pentagrid method: 5 families of parallel lines at k*36° each
// produce a quasiperiodic tiling dual to the Penrose rhombus tiling.
// This recreates the decagonal star patterns found in 13th–15th century
// Islamic architecture (Alhambra, Topkapi, Darb-i Imam shrine).
//
// References:
//  Lu & Steinhardt, "Decagonal and Quasi-Crystalline Tilings in Medieval
//  Islamic Architecture", Science 2007.

#define SCALE       3.5        // zoom level (tile size)
#define LINE_WIDTH  0.03       // strapwork line half-width (0..0.5)
#define GLOW_WIDTH  0.12       // soft glow radius around lines
#define NUM_FAMILY  5          // number of line families (5 = decagonal)
#define PI          3.14159265358979

// --- Color palette ---
const vec3 COL_BG    = vec3(0.05, 0.10, 0.30);   // deep lapis lazuli blue
const vec3 COL_LINE  = vec3(1.00, 0.84, 0.00);   // 24-karat gold
const vec3 COL_GLOW  = vec3(0.60, 0.45, 0.10);   // amber glow

// Smooth minimum for blending SDFs
float smin(float a, float b, float k) {
    float h = clamp(0.5 + 0.5*(b-a)/k, 0.0, 1.0);
    return mix(b, a, h) - k*h*(1.0-h);
}

// Signed distance to the nearest line in family k.
// Family k: lines perpendicular to n_k = (cos(k*PI/NUM), sin(k*PI/NUM))
// spaced 'spacing' apart with optional phase offset γ.
float pentagridDist(vec2 p, int k, float spacing, float gamma) {
    float angle = float(k) * PI / float(NUM_FAMILY);
    vec2  n     = vec2(cos(angle), sin(angle));
    float proj  = dot(p, n) / spacing + gamma;
    // Distance to nearest integer: abs(fract(x+0.5)-0.5)
    float t     = abs(fract(proj + 0.5) - 0.5);
    return t * spacing;  // actual distance in world space
}

// Pentagrid "index" — which line stripe a point sits in for family k
// (used later for region coloring)
float pentagridIndex(vec2 p, int k, float spacing, float gamma) {
    float angle = float(k) * PI / float(NUM_FAMILY);
    vec2  n     = vec2(cos(angle), sin(angle));
    return floor(dot(p, n) / spacing + gamma + 0.5);
}

// Combined distance to the nearest line across ALL families
float allLinesDist(vec2 p, float spacing) {
    float d = 1e9;
    for (int k = 0; k < NUM_FAMILY; k++) {
        // Slight phase offsets γ_k inspired by de Bruijn's original paper
        // γ = (k+1)/(2*NUM) keeps the pattern non-singular at origin
        float gamma = float(k + 1) / float(2 * NUM_FAMILY);
        float dk = pentagridDist(p, k, spacing, gamma);
        d = min(d, dk);
    }
    return d;
}

// Region parity: sum of all pentagrid indices mod 2
// Creates a two-colouring of the tiles (gold vs dark blue)
float regionParity(vec2 p, float spacing) {
    float sum = 0.0;
    for (int k = 0; k < NUM_FAMILY; k++) {
        float gamma = float(k + 1) / float(2 * NUM_FAMILY);
        sum += pentagridIndex(p, k, spacing, gamma);
    }
    return mod(sum, 2.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalise to aspect-corrected [-1,1] space
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    
    // Slow drift over time for visual interest
    vec2 pan = vec2(cos(iTime * 0.04), sin(iTime * 0.03)) * 0.5;
    vec2 p   = (uv + pan) * SCALE;

    float spacing = 1.0;  // canonical inter-line spacing

    // --- Background tile colouring (two-tone) ---
    float parity = regionParity(p, spacing);
    vec3  col    = mix(COL_BG, COL_BG * 1.6, parity * 0.4);

    // --- Distance to nearest strapwork line ---
    float d = allLinesDist(p, spacing);

    // Glow halo (additive, falls off as 1/d²)
    float glow = GLOW_WIDTH / (d * d + 0.001);
    glow = clamp(glow * 0.012, 0.0, 0.7);
    col += COL_GLOW * glow;

    // Hard line on top of glow
    float lineMask = 1.0 - smoothstep(LINE_WIDTH - 0.005, LINE_WIDTH + 0.005, d);
    col = mix(col, COL_LINE, lineMask);

    // Subtle vignette
    float vig = 1.0 - dot(uv, uv) * 0.5;
    col *= vig;

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
