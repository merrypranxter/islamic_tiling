// animated_girih.glsl
// Animated Islamic Girih — Growth from Seed + Rotation + Breathing
// Shadertoy-compatible fragment shader
//
// The pattern "grows" outward from the centre like a crystal nucleating:
// tiles appear in order of their distance from the origin, each fading in
// with a soft front. After the growth completes, the tiling slowly rotates
// and the strapwork lines gently breathe (pulsing width).
//
// Animation timeline (iTime):
//   0 – 8s  : growth phase — tiles appear, front moves at GROW_SPEED
//   8 – ∞   : full pattern rotates at ROT_SPEED, lines breathe at PULSE_HZ

#define SCALE       4.0
#define LINE_W_BASE 0.035
#define PULSE_AMP   0.018    // breathing amplitude
#define PULSE_HZ    0.8      // breathing cycles per second
#define GROW_SPEED  1.2      // tile radii unveiled per second
#define ROT_SPEED   0.018    // radians per second after growth
#define PI          3.14159265358979

const vec3 C_BG   = vec3(0.04, 0.09, 0.28);
const vec3 C_TILE = vec3(0.08, 0.20, 0.55);
const vec3 C_TILE2= vec3(0.12, 0.55, 0.60);
const vec3 C_LINE = vec3(1.00, 0.84, 0.10);
const vec3 C_SEED = vec3(1.00, 0.96, 0.70);
const vec3 C_GLOW = vec3(0.60, 0.48, 0.08);

float pgD(vec2 p, int k, float sp) {
    float a = float(k)*PI/5.0;
    float g = float(k+1)/10.0;
    return abs(fract(dot(p, vec2(cos(a),sin(a)))/sp + g + 0.5) - 0.5)*sp;
}
float pgI(vec2 p, int k, float sp) {
    float a = float(k)*PI/5.0;
    float g = float(k+1)/10.0;
    return floor(dot(p, vec2(cos(a),sin(a)))/sp + g + 0.5);
}
float allD(vec2 p, float sp) {
    float d = 1e9;
    for (int k=0; k<5; k++) d = min(d, pgD(p, k, sp));
    return d;
}
float sumI(vec2 p, float sp) {
    float s = 0.0;
    for (int k=0; k<5; k++) s += pgI(p, k, sp);
    return s;
}

// Approximate tile "radius" — distance from origin to nearest decagon centre
// We use the continuous rosette field as a proxy for growth front distance
float rosetteField(vec2 p, float sp) {
    float s = 0.0;
    for (int k = 0; k < 5; k++) {
        float a = float(k)*PI/5.0;
        float g = float(k+1)/10.0;
        s += cos((dot(p, vec2(cos(a),sin(a)))/sp + g) * 2.0*PI);
    }
    return s;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5*iResolution.xy) / iResolution.y;

    // Growth phase: 0..GROW_TIME, then rotation
    float growTime  = 8.0;
    float growFront = min(iTime, growTime) * GROW_SPEED; // in tile-units

    // After growth: accumulate rotation
    float rotAng = max(0.0, iTime - growTime) * ROT_SPEED;
    float cr = cos(rotAng), sr = sin(rotAng);
    vec2  p  = SCALE * vec2(cr*uv.x - sr*uv.y, sr*uv.x + cr*uv.y);

    float sp = 1.0;

    // Breathing line width
    float lw = LINE_W_BASE + PULSE_AMP * sin(iTime * PULSE_HZ * 2.0 * PI);

    // Two-tone background
    float parity = mod(sumI(p, sp), 2.0);
    vec3  col    = mix(C_TILE, C_TILE2, parity * 0.5);

    // Distance to strapwork lines
    float d = allD(p, sp);

    // Glow
    float glow = 0.008 / (d*d + 0.001);
    col += C_GLOW * clamp(glow, 0.0, 0.5);

    // Strapwork lines (breathing width)
    float lm = 1.0 - smoothstep(lw - 0.004, lw + 0.004, d);
    col = mix(col, C_LINE, lm);

    // Growth front mask: everything beyond the front is dark
    float dist   = length(p) / sp;           // radial distance in tile units
    float reveal = smoothstep(growFront - 1.2, growFront + 0.3, dist);
    col = mix(col, C_BG, reveal);

    // Seed glow at origin (always visible)
    float seedGlow = exp(-length(p)*length(p) * 2.0);
    col += C_SEED * seedGlow * 0.8 * smoothstep(0.0, 0.5, iTime);

    // Vignette
    col *= 1.0 - dot(uv,uv)*0.42;

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
