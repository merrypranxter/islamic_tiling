// musical_girih.glsl
// Musical Girih — Islamic Pattern as Synesthetic Musical Score
// Shadertoy-compatible fragment shader
//
// The pentagrid naturally decomposes space into 5 "voices" (line families),
// mapped to the 5 notes of the pentatonic scale (C D E G A).
// A wavefront travels outward from the centre; where it encounters a tile
// vertex it "plays" — triggering a brightness flare.
//
// Visual elements:
//   • 5 tile colours = 5 pentatonic notes (colour-music synesthesia)
//   • Wave pulse: circular wavefront expanding at WAVE_SPEED
//   • "Pluck" flares: exponentially decaying bright bursts at rosette centres
//     triggered when the wave passes through
//   • Interference: secondary reflections create rhythmic patterns
//   • Pentatonic palette: warm gold (Do), terracotta (Re), sage (Mi),
//                         sky blue (Sol), violet (La)
//
// The result should be felt as rhythm — a visual tabla.

#define SCALE        4.0
#define LINE_W       0.030
#define WAVE_SPEED   1.5     // tile-widths per second
#define WAVE_DECAY   1.8     // spatial decay of wave amplitude
#define FLARE_DUR    0.5     // duration of tile-pluck flare (seconds)
#define PI           3.14159265358979
// Musical timing constants
// WAVE_PERIOD: one "bar" in tile-travel time; secondary wavefronts offset by WAVE_PERIOD/4
#define WAVE_PERIOD  3.5     // seconds between repeating wavefronts (one musical phrase)
// BEAT_MEASURES: number of WAVE_PERIODs per screen-wide accent pulse (≈ 4-beat measure)
#define BEAT_MEASURES 4.0

// Pentatonic note colours (warm → cool progression matches C D E G A)
const vec3 NOTE_DO  = vec3(0.95, 0.82, 0.10);  // C — gold
const vec3 NOTE_RE  = vec3(0.85, 0.35, 0.12);  // D — terracotta
const vec3 NOTE_MI  = vec3(0.30, 0.68, 0.32);  // E — sage green
const vec3 NOTE_SOL = vec3(0.15, 0.55, 0.88);  // G — sky blue
const vec3 NOTE_LA  = vec3(0.60, 0.20, 0.85);  // A — violet
const vec3 C_BG     = vec3(0.04, 0.06, 0.18);
const vec3 C_WAVE   = vec3(1.00, 0.98, 0.90);  // wave crest colour

vec3 noteColor(int n) {
    if (n==0) return NOTE_DO;
    if (n==1) return NOTE_RE;
    if (n==2) return NOTE_MI;
    if (n==3) return NOTE_SOL;
    return NOTE_LA;
}

// ---- Pentagrid ----
float pgD(vec2 p, int k, float sp) {
    float a=float(k)*PI/5.0, g=float(k+1)/10.0;
    return abs(fract(dot(p,vec2(cos(a),sin(a)))/sp+g+0.5)-0.5)*sp;
}
float pgI(vec2 p, int k, float sp) {
    float a=float(k)*PI/5.0, g=float(k+1)/10.0;
    return floor(dot(p,vec2(cos(a),sin(a)))/sp+g+0.5);
}
float allD(vec2 p, float sp) {
    float d=1e9; for(int k=0;k<5;k++) d=min(d,pgD(p,k,sp)); return d;
}

// Dominant family (which note this region "belongs to")
int dominantFamily(vec2 p, float sp) {
    float dmin=1e9; int best=0;
    for(int k=0;k<5;k++){
        float d=pgD(p,k,sp);
        if(d<dmin){dmin=d; best=k;}
    }
    return best;
}

// Rosette potential field
float rosettePot(vec2 p, float sp) {
    float s=0.0;
    for(int k=0;k<5;k++){
        float a=float(k)*PI/5.0, g=float(k+1)/10.0;
        s+=cos((dot(p,vec2(cos(a),sin(a)))/sp+g)*2.0*PI);
    }
    return s;
}

// Wave function: circular wavefront from origin
// Returns wave amplitude [0,1] at position p, for wavefront at radius R
float wavePulse(vec2 p, float wavefrontR) {
    float r    = length(p);
    float dist = r - wavefrontR;
    // Gaussian pulse around the wavefront
    float amp  = exp(-dist*dist * WAVE_DECAY * WAVE_DECAY);
    // Decay with distance from origin
    amp *= exp(-r * 0.12);
    return clamp(amp, 0.0, 1.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord - 0.5*iResolution.xy) / iResolution.y;
    // Slow pan to reveal more of the tiling
    vec2 pan = vec2(cos(iTime*0.035), sin(iTime*0.025)) * 0.4;
    vec2 p   = (uv + pan) * SCALE;

    float sp = 1.0;

    // ---- Tile note colour ----
    int  fam = dominantFamily(p, sp);
    vec3 noteCol = noteColor(fam);

    // Subtle two-tone modulation within each note family
    float idx = pgI(p, fam, sp);
    noteCol *= 0.80 + 0.20 * mod(idx, 2.0);

    vec3 col = mix(C_BG, noteCol * 0.5, 0.6);

    // ---- Strapwork lines ----
    float d  = allD(p, sp);
    float lm = 1.0 - smoothstep(LINE_W-0.004, LINE_W+0.004, d);
    // Lines are coloured by the note but lightened
    vec3 lineCol = noteCol * 0.6 + vec3(0.4);
    col = mix(col, lineCol, lm * 0.8);

    // ---- Traveling wave pulse ----
    // Multiple concentric wavefronts (like plucking a string repeatedly)
    float waveAmp = 0.0;
    for (int i = 0; i < 4; i++) {
        float tOff       = float(i) * WAVE_PERIOD * 0.25;
        float wavefrontR = mod(iTime * WAVE_SPEED - tOff, 20.0);
        waveAmp += wavePulse(p, wavefrontR) / (float(i) + 1.0);
    }
    waveAmp = clamp(waveAmp, 0.0, 1.0);

    // Wave lights up the lines it passes through
    col += lineCol * waveAmp * 1.2;
    // Wave also illuminates tile interiors briefly
    col += noteCol * waveAmp * 0.4;

    // ---- Rosette "pluck" flares ----
    // When the wavefront passes a rosette centre, it triggers a bright flare
    // Model: rosette "rings" at radius R_wave at time T_ring
    float rPot    = rosettePot(p, sp);
    float isRos   = smoothstep(-4.3, -5.0, rPot); // near a rosette centre

    // Multiple wave arrivals create multiple flares
    float flareAmp = 0.0;
    float r = length(p);
    for (int i = 0; i < 4; i++) {
        float tOff      = float(i) * WAVE_PERIOD * 0.25;
        float arrivalT  = r / WAVE_SPEED + tOff;
        float tSinceArr = mod(iTime - arrivalT, WAVE_PERIOD);
        flareAmp += exp(-tSinceArr / FLARE_DUR) * isRos / (float(i)+1.0);
    }
    flareAmp = clamp(flareAmp, 0.0, 2.0);

    // Flare colour is the note colour, brightened to white at peak
    col += mix(noteCol, C_WAVE, clamp(flareAmp, 0.0, 1.0)) * flareAmp * 0.9;

    // ---- Beat marker: central pulse ----
    // A slow accent pulse on the whole screen to mark measure boundaries
    // beatPeriod: BEAT_MEASURES phrases × WAVE_PERIOD / (speed × scale) = screen-crossing time
    float beatPeriod = BEAT_MEASURES * (WAVE_PERIOD / (WAVE_SPEED * SCALE));
    float beat = exp(-mod(iTime, beatPeriod) * 3.0) * 0.15;
    col += vec3(beat);

    // Vignette
    col *= 1.0 - dot(uv,uv) * 0.42;

    fragColor = vec4(clamp(col, 0.0, 1.0), 1.0);
}
