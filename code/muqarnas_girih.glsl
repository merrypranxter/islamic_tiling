// muqarnas_girih.glsl
// Muqarnas — Islamic Stalactite Vaulting as 2D Geometric Projection
// Shadertoy-compatible fragment shader
//
// MUQARNAS (مقرنس) is the three-dimensional system of Islamic architecture
// where vaults, domes, and transitions are filled with a honeycomb of small
// projecting cells — "stalactites" carved from stone, stucco, or wood.
//
// Mathematically, a muqarnas is:
//   1. A collection of 3D "cells" — half-pyramids, half-cones, squinches
//   2. Each cell has a base (visible from below) and a top face connecting to
//      the cell above
//   3. The base shapes form a 2D tiling pattern — the muqarnas PLAN
//   4. The plan is the 2D Islamic geometric pattern; the height comes from
//      assigning each tile a "storey" (z-level)
//
// This shader renders the 2D muqarnas plan in two ways:
//   A. PLAN VIEW: the flat 2D projection — identical to the classic
//      octagonal and square tiling patterns used in historical muqarnas
//   B. ISOMETRIC VIEW: a pseudo-3D isometric projection of the stacked cells,
//      showing the characteristic "stalactite" profile of a muqarnas vault
//
// Historical reference:
//   The Alhambra's Hall of the Two Sisters muqarnas dome (c. 1352 CE) —
//   5,416 individual cells, rising 18m, organized in 16 tiers. The plan
//   uses 8-fold and 4-fold geometry throughout.
//
// This shader uses 8-fold geometry (the standard for most historical muqarnas)
// with a choice of plan-only (PLAN_MODE 1) or isometric (PLAN_MODE 0).

#define PLAN_MODE     0          // 0 = isometric pseudo-3D; 1 = plan only
#define NUM_TIERS     6          // number of muqarnas tiers (vertical levels)
#define SCALE         3.5
#define PI            3.14159265358979
#define SQRT2         1.41421356237310
#define SQRT3         1.73205080756888
// Isometric cell height: the 3D "unit" of each muqarnas storey
// In historical examples, storey height ≈ 0.5 × cell width
#define CELL_HEIGHT   0.5
// Shadow parameters for isometric view
#define SHADOW_STR    0.55       // shadow blend strength on south/bottom faces
#define AMBIENT       0.35       // ambient light level on unlit faces
// Vertical face threshold: fraction of CELL_HEIGHT used to detect the south-face band
// on the isometric projection.  0.4 means the south-face shadow zone spans ±40% of
// one storey height in screen-space — wide enough to be visible without bleeding into
// adjacent tiers.
#define V_FACE_THRESH 0.4

// Muqarnas palette: aged stone, gilded stucco, lapis blue, deep shadow
const vec3 C_TOP    = vec3(0.82, 0.75, 0.58);   // lit top face (stucco)
const vec3 C_SOUTH  = vec3(0.55, 0.48, 0.36);   // south/shadow face
const vec3 C_NORTH  = vec3(0.92, 0.86, 0.70);   // bright north face
const vec3 C_STAR   = vec3(0.10, 0.22, 0.58);   // star cell (lapis blue)
const vec3 C_GOLD   = vec3(0.85, 0.68, 0.12);   // gilded edge
const vec3 C_SHADOW = vec3(0.08, 0.07, 0.05);   // deep shadow gap
const vec3 C_BG     = vec3(0.04, 0.06, 0.22);   // background (looking up)

// ---- 2D muqarnas cell grid ----
// The plan of an 8-fold muqarnas uses a square-octagon tiling:
// alternating squares and octagons in a √2-based grid.
// Cell type at grid position (ix, iy):
//   ix+iy even → octagonal cell (the "hub")
//   ix+iy odd  → square cell (the "connector")

// Fold point into a square-octagon cell and return (local_pos, cell_type)
// cell_type: 0 = square, 1 = octagon
float cellType(vec2 p, float cell, out vec2 local) {
    float c2 = cell * 2.0;
    // Tile in 2×2-cell repeating unit
    vec2 q = mod(p, c2) - cell;      // q ∈ [-cell, cell]²
    vec2 a = abs(q);
    // Points closer to a corner are "square connector"; others are "octagon hub"
    float thresh = cell * (SQRT2 - 1.0);  // ≈ 0.414 × cell
    float isSq = step(max(a.x, a.y), thresh) < 0.5 ? 0.0 : 1.0;
    // Actually: octagon is large (centre of repeating unit); square is in corners
    // Re-tile: cells at integer positions alternating
    vec2 ii = floor(p / cell + 0.5);
    float ct = mod(ii.x + ii.y, 2.0);       // 0 = oct, 1 = square
    local = fract(p / cell + 0.5) - 0.5;    // local coords in [-0.5, 0.5]
    return ct;
}

// SDF for a regular octagon (inscribed in unit square, in local coords)
float octSDF(vec2 p, float r) {
    p = abs(p);
    float d = max(p.x, p.y);
    // Clip at 45° corners: distance to the diagonal line p.x+p.y = r*√2
    float diag = (p.x + p.y - r * SQRT2) * SQRT2_INV;
    return max(d - r, diag);
}
#define SQRT2_INV 0.70710678118655

// SDF for a square
float sqSDF(vec2 p, float r) {
    vec2 d = abs(p) - r;
    return max(d.x, d.y);
}

// The muqarnas "storey" index for a cell — determines its z-height.
// Cells closer to the outer ring of the dome are at lower tiers;
// cells at the centre (peak) are at the highest tier.
// Here we approximate: cells in the central octagon at tier = NUM_TIERS,
// decreasing by 1 for each ring outward.
float tierIndex(vec2 p, float cell) {
    float r = length(p);
    float tierR = cell * 1.8;  // radius increment per tier
    return clamp(float(NUM_TIERS) - floor(r / tierR), 0.0, float(NUM_TIERS));
}

// ---- Isometric projection helpers ----
// Convert 2D plan coords (px, py) + height z → isometric screen coords
vec2 isoProject(vec2 plan, float z) {
    // Standard isometric: x_iso = (px - py) * cos(30°), y_iso = (px + py) * sin(30°) + z
    return vec2((plan.x - plan.y) * 0.866, (plan.x + plan.y) * 0.5 + z);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

    // Slow rotation — vaults don't typically rotate, but we spin gently to show 8-fold
    float rot = iTime * 0.010;
    float cr = cos(rot), sr = sin(rot);

#if PLAN_MODE == 1
    // ---- PLAN VIEW: straight top-down ----
    vec2 p = SCALE * vec2(cr*uv.x - sr*uv.y, sr*uv.x + cr*uv.y);

    float cell = 1.0;
    vec2  local;
    float ct = cellType(p, cell, local);

    // Pick colour by cell type
    vec3 col = (ct < 0.5) ? C_STAR : C_TOP;

    // SDF of cell boundary
    float r    = 0.42;
    float dist = (ct < 0.5) ? sqSDF(local, r) : octSDF(local, r);

    // Interior shading
    col *= 0.7 + 0.3 * smoothstep(0.0, 0.2, -dist);

    // Gold edge lines
    float edge = 1.0 - smoothstep(0.02, 0.035, abs(dist));
    col = mix(col, C_GOLD, edge);

    // Gap between cells (dark grout)
    float gap = 1.0 - smoothstep(0.0, 0.03, dist);
    col = mix(col, C_SHADOW, gap * 0.8);

    // Tier shading (inner cells brighter = top of dome)
    float tier = tierIndex(p, cell);
    col *= 0.6 + 0.4 * (tier / float(NUM_TIERS));

    col *= 1.0 - dot(uv, uv) * 0.4;
    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);

#else
    // ---- ISOMETRIC PSEUDO-3D VIEW ----
    // Render each tier as a layer; front tiers occlude back tiers.
    // For each screen pixel, find which muqarnas cell face it hits.

    vec3 col = C_BG;

    // Isometric viewing direction
    // We scan the tiers from back (low) to front (high z) — painter's algorithm
    float cell = 0.7;

    for (int tier = 0; tier < NUM_TIERS; tier++) {
        float z = float(tier) * CELL_HEIGHT;
        float zTop = z + CELL_HEIGHT;

        // Inverse-project this tier's plan coordinates from screen UV
        // isoProject(plan, z) = UV → solve for plan:
        //   uv.x = (plan.x - plan.y) * 0.866
        //   uv.y = (plan.x + plan.y) * 0.5 + z
        // → plan.x = (uv.x / 0.866 + 2*(uv.y - z)) / 2
        //   plan.y = (2*(uv.y - z) - uv.x / 0.866) / 2

        vec2 p;
        float ux = uv.x * SCALE;
        float uy = (uv.y - z / SCALE) * SCALE;
        p.x = (ux / 0.866 + 2.0 * uy) * 0.5;
        p.y = (2.0 * uy - ux / 0.866) * 0.5;

        // Rotate plan
        p = vec2(cr*p.x - sr*p.y, sr*p.x + cr*p.y);

        vec2  local;
        float ct    = cellType(p, cell, local);
        float r     = 0.40;
        float dist  = (ct < 0.5) ? sqSDF(local, r * 0.8) : octSDF(local, r);

        // Only render this tier if the cell is at the right tier height
        float thisTier = tierIndex(p, cell);
        if (abs(thisTier - float(tier)) > 0.5) continue;

        // Top face
        if (dist < 0.0) {
            vec3 faceCol = (ct < 0.5) ? C_STAR : C_TOP;
            // Directional shading: brighter on top-left (north-west) face
            float bright = 0.8 + 0.2 * (float(tier) / float(NUM_TIERS));
            col = faceCol * bright;
        }

        // Gold edge
        float edge = 1.0 - smoothstep(0.01, 0.025, abs(dist));
        col = mix(col, C_GOLD, edge);

        // Vertical shadow face below each cell (south face)
        float vFaceY = uv.y * SCALE - (float(tier) * CELL_HEIGHT + CELL_HEIGHT * 0.5);
        if (abs(vFaceY) < CELL_HEIGHT * V_FACE_THRESH && dist > -0.02) {
            float southFade = smoothstep(-0.02, 0.0, dist);
            col = mix(col, C_SOUTH * float(tier+1) / float(NUM_TIERS), southFade * SHADOW_STR);
        }
    }

    col *= 1.0 - dot(uv, uv) * 0.38;
    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
#endif
}
