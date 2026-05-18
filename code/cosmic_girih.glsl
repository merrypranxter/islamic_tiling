// cosmic_girih.glsl
// Cosmic Girih — Islamic Geometry as Celestial Mechanics
// Shadertoy-compatible fragment shader
//
// The girih tiling is re-imagined as a star map:
//   • Rosette centres (10-fold symmetry foci) become stars / galaxy cores
//   • Strapwork lines are the orbital resonance paths traced by planets
//   • Background: deep space with star field (hash-based procedural stars)
//   • Nebula glow: Gaussian haze in turquoise/violet around each rosette
//   • The entire pattern slowly rotates like the celestial sphere
//
// Rosette potential field thresholds (cosine sum ∈ [-5, +5]):
//   NEBULA_OUTER_BOUND: outer radius of broad nebula haze
//   NEBULA_ROSETTE_BOUND: tighter rosette-core nebula
//   CORE_GLOW_OUTER: start of galactic core glow
//   CORE_CENTRE: perfect 10-fold centre value (≈ -5)
//   CORE_STAR_INNER: inner point-like stellar core threshold
#define NEBULA_OUTER_BOUND   -3.0
#define NEBULA_ROSETTE_BOUND -4.8
#define NEBULA2_OUTER        -2.0
#define NEBULA2_INNER        -4.0
#define CORE_GLOW_OUTER      -4.5
#define CORE_CENTRE          -5.0
#define CORE_STAR_INNER      -4.85

#define SCALE       4.2
#define LINE_W      0.028
#define STAR_DENS   280.0   // stars per unit area (approximate)
#define NEBULA_R    0.55    // nebula radius (in tile units)
#define ROT_SPEED   0.010   // radians/second
// Star brightness falloff parameters:
//   STAR_MAG_EXP: power applied to random magnitude — higher = fewer bright stars
//   STAR_FALLOFF_BASE: Gaussian width² for faint stars (tighter = sharper point)
//   STAR_FALLOFF_VAR: extra Gaussian tightening for bright stars (varying PSF)
#define STAR_MAG_EXP      3.0
#define STAR_FALLOFF_BASE 800.0
#define STAR_FALLOFF_VAR  600.0
#define PI          3.14159265358979

const vec3 C_SPACE    = vec3(0.00, 0.01, 0.06);  // deep space black
const vec3 C_STAR     = vec3(1.00, 0.98, 0.92);  // star white
const vec3 C_ORBIT    = vec3(0.25, 0.50, 0.85);  // orbital path blue
const vec3 C_NEBULA_A = vec3(0.12, 0.60, 0.80);  // nebula cyan
const vec3 C_NEBULA_B = vec3(0.45, 0.15, 0.80);  // nebula violet
const vec3 C_CORE     = vec3(1.00, 0.90, 0.50);  // galactic core gold

// ---- Hash / noise utilities ----
float hash11(float n) { return fract(sin(n)*43758.5453123); }
float hash21(vec2  p) { return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453123); }
vec2  hash22(vec2  p) {
    p = vec2(dot(p,vec2(127.1,311.7)), dot(p,vec2(269.5,183.3)));
    return -1.0 + 2.0*fract(sin(p)*43758.5453123);
}

// ---- Procedural star field ----
// Subdivide space into cells; place a star randomly within each cell
float starField(vec2 p, float scale) {
    vec2  cell = floor(p * scale);
    vec2  frac = fract(p * scale);
    float b    = 0.0;
    for (int dy=-1; dy<=1; dy++) for (int dx=-1; dx<=1; dx++) {
        vec2 c   = cell + vec2(dx, dy);
        vec2 pos = hash22(c) * 0.5 + 0.5;  // star position in [0,1]²
        float mag = hash21(c + 0.5);        // magnitude 0..1
        float r   = length(frac - vec2(dx,dy) - pos);
        float br  = pow(mag, STAR_MAG_EXP) * exp(-r * r * (STAR_FALLOFF_BASE + mag*STAR_FALLOFF_VAR));
        b += br;
    }
    return clamp(b, 0.0, 1.0);
}

// ---- Pentagrid ----
float pgD(vec2 p, int k, float sp) {
    float a = float(k)*PI/5.0;
    float g = float(k+1)/10.0;
    return abs(fract(dot(p,vec2(cos(a),sin(a)))/sp+g+0.5)-0.5)*sp;
}
float allD(vec2 p, float sp) {
    float d=1e9;
    for(int k=0;k<5;k++) d=min(d,pgD(p,k,sp));
    return d;
}

// Continuous rosette potential field (deep minima = rosette centres)
float rosettePot(vec2 p, float sp) {
    float s=0.0;
    for(int k=0;k<5;k++){
        float a=float(k)*PI/5.0, g=float(k+1)/10.0;
        s+=cos((dot(p,vec2(cos(a),sin(a)))/sp+g)*2.0*PI);
    }
    return s;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5*iResolution.xy) / iResolution.y;

    // Celestial rotation
    float rot = iTime * ROT_SPEED;
    float cr=cos(rot), sr=sin(rot);
    vec2  p  = SCALE * vec2(cr*uv.x-sr*uv.y, sr*uv.x+cr*uv.y);

    float sp = 1.0;

    // ---- Deep space background ----
    vec3 col = C_SPACE;

    // Distant star field (two scales for depth)
    float stars1 = starField(uv + vec2(iTime*0.002, 0.0), 30.0);
    float stars2 = starField(uv * 1.7 + vec2(0.3, iTime*0.001), 50.0);
    col += C_STAR * (stars1 * 0.8 + stars2 * 0.4);

    // ---- Nebula glow at rosette centres ----
    float rPot = rosettePot(p, sp);
    // rPot ∈ [-5, 5]; deep minima (≈ -5) are rosette centres
    float nebulaT  = smoothstep(NEBULA_OUTER_BOUND,   NEBULA_ROSETTE_BOUND, rPot);
    float nebulaT2 = smoothstep(NEBULA2_OUTER,        NEBULA2_INNER,        rPot);
    vec3  nebulaCol = mix(C_NEBULA_A, C_NEBULA_B,
                         sin(rPot * 0.8 + iTime * 0.05)*0.5+0.5);
    col += nebulaCol * nebulaT * 0.55;

    // ---- Orbital path strapwork ----
    float d = allD(p, sp);

    // Faint orbital glow (wide halo)
    float orbitGlow = 0.006 / (d*d + 0.0005);
    col += C_ORBIT * clamp(orbitGlow, 0.0, 0.4);

    // Orbital line (narrower, brighter)
    float orbitLine = 1.0 - smoothstep(LINE_W - 0.004, LINE_W + 0.004, d);
    col = mix(col, C_ORBIT * 1.4, orbitLine * 0.75);

    // ---- Galactic core (bright star at each rosette centre) ----
    float coreGlow = smoothstep(CORE_GLOW_OUTER, CORE_CENTRE,     rPot);
    col += C_CORE * coreGlow * 1.8;
    // Inner point-like core
    float coreStar = smoothstep(CORE_STAR_INNER,  CORE_CENTRE,     rPot);
    col = mix(col, vec3(1.0), coreStar * 0.9);

    // ---- Lens flare / diffraction spikes on bright cores ----
    if (coreStar > 0.01) {
        for (int spike=0; spike<5; spike++) {
            float sa = float(spike)*PI/5.0;
            float sd = abs(dot(fract(p/sp+0.5)-0.5, vec2(cos(sa),sin(sa))));
            float fl = exp(-sd * sd * 800.0) * coreStar * 0.5;
            col += C_CORE * fl;
        }
    }

    // Vignette (like a telescope field stop)
    float vig = smoothstep(1.0, 0.3, length(uv));
    col *= vig;

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
