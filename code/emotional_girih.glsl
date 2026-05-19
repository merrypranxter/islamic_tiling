// emotional_girih.glsl
// Emotional Girih — Pattern Responds to Emotional State
// Shadertoy-compatible fragment shader
//
// The girih pattern cycles through 5 emotional states driven by iTime:
//   0 = CALM  : slow, symmetric, cool blues/greens, narrow clean lines
//   1 = JOY   : warm golds/reds, faster drift, richer complexity
//   2 = GRIEF : monochrome, desaturated, lines develop asymmetric breaks
//   3 = AWE   : maximum complexity, deep lapis + gold shimmer, near-silent motion
//   4 = CHAOS : geometric rules progressively corrupted — beautiful disorder
//
// State transitions are smooth (cross-faded over ~2 seconds).
// Emotion index: floor(iTime / STATE_DUR) mod 5

#define STATE_DUR       8.0   // seconds per emotional state
#define SCALE           4.0
#define PI              3.14159265358979
// Emotion transition boundaries (in continuous emotion index emoF ∈ [0,5)):
//   GRIEF starts ramping in at EMO_GRIEF_START (mid-joy), fully present at EMO_GRIEF_PEAK
//   AWE glow starts at EMO_AWE_START, fully present at EMO_AWE_PEAK
// These are used for state-specific visual effects that differ from palette blending.
// EMO_AWE_END / EMO_CHAOS_START: awe state ends and chaos begins at emotion index 4.5
// (halfway through the chaos state's ramp-in within the 0-5 continuous index)
#define EMO_GRIEF_START 1.5
#define EMO_AWE_END     4.5
#define EMO_GRIEF_PEAK  2.5
#define EMO_AWE_START   2.5
#define EMO_AWE_PEAK    3.5

// Emotion palettes [bg, line, accent]
const vec3 E_BG[5]   = vec3[5](
    vec3(0.04,0.18,0.28), vec3(0.22,0.08,0.04), vec3(0.10,0.10,0.10),
    vec3(0.03,0.07,0.35), vec3(0.08,0.04,0.16));
const vec3 E_LINE[5] = vec3[5](
    vec3(0.40,0.80,0.90), vec3(0.98,0.72,0.12), vec3(0.55,0.52,0.50),
    vec3(0.95,0.82,0.15), vec3(0.75,0.15,0.60));
const vec3 E_ACC[5]  = vec3[5](
    vec3(0.20,0.55,0.65), vec3(0.90,0.25,0.10), vec3(0.30,0.28,0.28),
    vec3(0.25,0.50,0.85), vec3(0.30,0.70,0.40));

float pgD(vec2 p, int k, float sp, float gamma) {
    float a = float(k)*PI/5.0;
    float g = float(k+1)/10.0 + gamma;
    return abs(fract(dot(p,vec2(cos(a),sin(a)))/sp+g+0.5)-0.5)*sp;
}
float pgI(vec2 p, int k, float sp, float gamma) {
    float a = float(k)*PI/5.0;
    float g = float(k+1)/10.0 + gamma;
    return floor(dot(p,vec2(cos(a),sin(a)))/sp+g+0.5);
}

// Chaos distortion: offset each family's grid by noise-like displacement
float hash(float n) { return fract(sin(n)*43758.5453); }

float allDist(vec2 p, float sp, float emotion) {
    float d = 1e9;
    for (int k=0; k<5; k++) {
        // Chaos state (4): distort grid offset per strand
        float gExtra = 0.0;
        if (emotion > 3.5) {
            float idx = pgI(p, k, sp, 0.0);
            gExtra = (hash(idx + float(k)*17.3) - 0.5) * (emotion - 3.5) * 0.6;
        }
        d = min(d, pgD(p, k, sp, gExtra));
    }
    return d;
}

float sumIdx(vec2 p, float sp) {
    float s = 0.0;
    for (int k=0; k<5; k++) s += pgI(p, k, sp, 0.0);
    return s;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5*iResolution.xy) / iResolution.y;

    // Current emotion state (continuous for smooth blending)
    float rawEmo = iTime / STATE_DUR;
    float emoF   = mod(rawEmo, 5.0);          // 0..5 continuous
    int   emoI   = int(mod(floor(rawEmo), 5.0)); // 0..4 integer
    int   emoN   = int(mod(float(emoI+1), 5.0));
    float emoT   = smoothstep(0.7, 1.0, fract(rawEmo)); // cross-fade tail

    // Blend palette between states
    vec3 bgCol   = mix(E_BG[emoI],   E_BG[emoN],   emoT);
    vec3 lineCol = mix(E_LINE[emoI], E_LINE[emoN],  emoT);
    vec3 accCol  = mix(E_ACC[emoI],  E_ACC[emoN],   emoT);

    // Speed and line width vary with emotion
    float speed = mix(0.01, 0.12, emoF / 4.0);   // calm=slow, chaos=fast
    float lw    = mix(0.025, 0.055, sin(emoF*PI/4.0)*0.5+0.5);
    float grief = smoothstep(EMO_GRIEF_START, EMO_GRIEF_PEAK, emoF)
                * (1.0 - smoothstep(EMO_AWE_START, EMO_AWE_PEAK, emoF));
    
    // Motion (pan direction and speed depend on emotion)
    vec2 dir = vec2(cos(emoF*1.3), sin(emoF*0.9));
    vec2 pan = dir * iTime * speed;
    vec2 p   = (uv + pan) * SCALE;

    // Grief: introduce slow asymmetric distortion (broken symmetry)
    if (grief > 0.01) {
        p.x += grief * 0.3 * sin(p.y * 1.5 + iTime * 0.2);
    }

    float sp = 1.0;

    // Region two-tone
    float par  = mod(sumIdx(p, sp), 2.0);
    vec3  col  = mix(bgCol, bgCol * 1.4 + accCol * 0.15, par * 0.45);

    // Desaturate for grief
    float lumaG = dot(col, vec3(0.299, 0.587, 0.114));
    col = mix(col, vec3(lumaG), grief * 0.75);

    // Strapwork distance with chaos distortion
    float d = allDist(p, sp, emoF);

    // Glow (stronger in awe state)
    float aweFactor = smoothstep(EMO_AWE_START, EMO_AWE_PEAK, emoF)
                    * (1.0 - smoothstep(EMO_AWE_PEAK, EMO_AWE_END, emoF));
    float glow = 0.008 / (d*d + 0.001);
    col += lineCol * glow * (0.4 + aweFactor * 1.2);

    // Lines
    float lm = 1.0 - smoothstep(lw - 0.005, lw + 0.005, d);
    col = mix(col, lineCol, lm);
    // Joy: extra inner glow on lines
    float joyFactor = smoothstep(0.5, EMO_GRIEF_START, emoF)
                    * (1.0 - smoothstep(EMO_GRIEF_START, EMO_GRIEF_PEAK, emoF));
    col += accCol * lm * joyFactor * 0.5;

    // Vignette
    col *= 1.0 - dot(uv,uv) * 0.45;

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
