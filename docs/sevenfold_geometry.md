# Seven-Fold Geometry: The Forbidden Symmetry

## 1. Introduction: Why Seven is Special

The number **seven** has a unique status in Islamic cosmology — the seven heavens, the
seven verses of al-Fatiha, the seven days of the week, the seven planets of classical
astronomy. Yet 7-fold symmetry is almost entirely **absent** from classical Islamic
geometric art. This is not an oversight; it is a mathematical necessity.

A regular heptagon (7-gon) has interior angles of 900°/7 ≈ 128.57°. This angle is
**irrational with respect to 360°**: no integer multiple of 128.57° equals 360°.
Therefore, a group of heptagons around a vertex cannot fill space without gaps or
overlaps. The 7-gon cannot tile the plane.

This document explores the mathematics of 7-fold geometry — what makes it impossible
as a periodic tiling, what makes it possible as a quasiperiodic system, and how to
generate 7-fold patterns computationally that would have remained inaccessible to
medieval craftsmen working with compass and straightedge.

---

## 2. The Crystallographic Restriction — Exactly

### 2.1 Statement

**Theorem (Crystallographic Restriction):** A 2D periodic lattice can only have
rotational symmetries of order n = 1, 2, 3, 4, or 6.

In other words: 5-fold, 7-fold, 8-fold, 9-fold, 10-fold, 11-fold, ... rotational
symmetry is **impossible** in any periodic tiling.

### 2.2 Proof (Elementary)

Suppose a 2D lattice has a `n`-fold rotation axis at the origin. Pick any lattice
vector **v**. Then **v** rotated by 2π/n is also a lattice vector. Call it **v'**.

The sum **v + v'** must also be a lattice vector (lattices are closed under addition).
But |**v + v'**| = 2|**v**| cos(π/n).

For this to produce a valid lattice vector, the rotation must map lattice vectors to
lattice vectors. This constrains: **2cos(2π/n) ∈ ℤ** (the trace of the rotation matrix
must be an integer for it to act on an integer lattice).

```
n = 1:  2cos(360°) =  2  ∈ ℤ  ✓  → trivial (identity)
n = 2:  2cos(180°) = −2  ∈ ℤ  ✓  → 2-fold
n = 3:  2cos(120°) = −1  ∈ ℤ  ✓  → 3-fold
n = 4:  2cos(90°)  =  0  ∈ ℤ  ✓  → 4-fold
n = 6:  2cos(60°)  =  1  ∈ ℤ  ✓  → 6-fold
n = 5:  2cos(72°)  ≈  0.618      ∉ ℤ  ✗
n = 7:  2cos(2π/7) ≈  1.247      ∉ ℤ  ✗
n = 8:  2cos(45°)  = √2 ≈ 1.414  ∉ ℤ  ✗
n = 12: 2cos(30°)  = √3 ≈ 1.732  ∉ ℤ  ✗
```

Only n ∈ {1, 2, 3, 4, 6} satisfy 2cos(2π/n) ∈ ℤ — these are the only allowed
rotational symmetries for periodic tilings. QED.

### 2.3 What This Means for 7-Fold

7-fold rotational symmetry cannot occur in any periodic tiling. Period. This is an
absolute mathematical theorem with no exceptions.

**However:** A quasiperiodic structure is NOT a periodic lattice, so the crystallographic
restriction does not apply. And indeed, **7-fold quasiperiodic structures do exist**
mathematically — though they are rarer and more exotic than 5-fold or 8-fold.

---

## 3. The Heptagrid: Generating 7-Fold Patterns

### 3.1 The de Bruijn Construction (Generalised)

Just as de Bruijn's pentagrid (5 families of lines) generates Penrose-like 5-fold
quasiperiodic tilings, a **heptagrid** (7 families of lines at angles k·π/7 for k=0..6)
generates 7-fold quasiperiodic patterns. The dual of the heptagrid is a tiling by the
7-fold generalisation of girih tiles.

**Line families of the heptagrid:**
```
Family 0: lines at angle   0°
Family 1: lines at angle  25.71° (= π/7 × 360°/(2π) ≈ 25.714°)
Family 2: lines at angle  51.43°
Family 3: lines at angle  77.14°
Family 4: lines at angle 102.86°
Family 5: lines at angle 128.57°
Family 6: lines at angle 154.29°
```

Each family k has parallel lines with spacing `sp` and phase offset `γ_k = (k+1)/14`.

### 3.2 The Dual Tiling: Heptagonal Rhombi

The dual of the heptagrid is a tiling by **rhombi** with angles that are multiples of
180°/7 ≈ 25.71°:

| Rhombus type | Acute angle | Obtuse angle | Sharpness |
|-------------|-------------|--------------|-----------|
| Type 1 (thin) | 180°/7 ≈ 25.71° | 6·180°/7 ≈ 154.29° | Very sharp |
| Type 2 | 2·180°/7 ≈ 51.43° | 5·180°/7 ≈ 128.57° | Medium |
| Type 3 (thick) | 3·180°/7 ≈ 77.14° | 4·180°/7 ≈ 102.86° | Blunt |

There are 3 rhombus types (for 7-fold, compared to 2 for 5-fold/Penrose). The dual
tiling contains all three types in specific proportions.

### 3.3 The Heptagonal Inflation Ratio

For the 7-fold system, the self-similar inflation ratio is given by:
```
λ₇ = 2cos(π/7) ≈ 1.80194
```
This is the largest root of the minimal polynomial:
```
x³ − x² − 2x + 1 = 0
```
(a cubic, compared to the quadratic x² − x − 1 = 0 for the golden ratio φ in the 5-fold case).

This means λ₇ is an **algebraic number of degree 3** — it lives in a degree-3 extension
of the rationals (not degree 2 like φ). This is why 7-fold geometry is significantly more
complex to handle algebraically than 5-fold: you need three basis numbers instead of two.

**Exact arithmetic for 7-fold requires:**
```
Q(2cos(π/7)) ≅ Q[x]/(x³ − x² − 2x + 1)
```
Every coordinate in the 7-fold dual tiling lives in this degree-3 field extension.

---

## 4. Angles and Proportions in 7-Fold Geometry

### 4.1 The Fundamental Angle: 180°/7

All angles in 7-fold geometry are multiples of:
```
Δ₇ = π/7 = 180°/7 ≈ 25.7143°
```

Key angles:
```
1 × Δ₇  ≈ 25.71°   thin rhombus acute angle
2 × Δ₇  ≈ 51.43°   medium rhombus acute angle
3 × Δ₇  ≈ 77.14°   thick rhombus acute angle; also heptagon interior vertex
4 × Δ₇  ≈ 102.86°  thick rhombus obtuse angle
5 × Δ₇  ≈ 128.57°  heptagon interior angle (= 900°/7)
6 × Δ₇  ≈ 154.29°  thin rhombus obtuse angle
7 × Δ₇  = 180°     straight line
14 × Δ₇ = 360°     full turn
```

Note that at any vertex of the heptagrid dual, the angles MUST sum to 360° = 14 × Δ₇.
The possible combinations:
```
3 × (4Δ₇) + 1 × (2Δ₇) = 14Δ₇  ✓  (three thick rhombi + one medium)
2 × (5Δ₇) + ... = various      ...
```

### 4.2 Trigonometric Values

Unlike 5-fold (where everything reduces to rationals plus √5), 7-fold trigonometry
involves **cosines of π/7, 2π/7, 3π/7** which are roots of the cubic:
```
8x³ − 4x² − 4x + 1 = 0
```
The three roots are: cos(π/7), cos(3π/7), cos(5π/7).

**Exact values:**
```
cos(π/7)  ≈ 0.9009688679  (no simple radical form)
cos(2π/7) ≈ 0.6234898019
cos(3π/7) ≈ 0.2225209340
```

The sum identity:
```
cos(π/7) + cos(3π/7) + cos(5π/7) = 1/2
```

And the product:
```
cos(π/7) · cos(2π/7) · cos(3π/7) = 1/8
```

These are the "beautiful" identities of 7-fold geometry — they exist, but they are
not as elegant as the golden ratio's φ² = φ + 1. The 7-fold system does not have
a single named constant analogous to φ; instead, it requires three basis values.

### 4.3 The Heptagonal Numbers

Analogous to the Fibonacci numbers for 5-fold, 7-fold has the **heptanacci-like**
sequences generated by the substitution rules. For the three rhombus types with counts
(a, b, c) under inflation:

Substitution matrix M:
```
M = [[1, 1, 1],     (thin → thin + medium + thick)
     [2, 1, 2],     (medium → 2 thin + medium + 2 thick)
     [1, 1, 1]]     (thick → thin + medium + thick)
```
*(Approximate; exact substitution rules depend on the specific 7-fold variant)*

The dominant eigenvalue of M is λ₇ ≈ 1.802, confirming the inflation ratio.

---

## 5. 7-Fold Stars: {7/2} and {7/3}

### 5.1 The Heptagram {7/2}

Connecting every 2nd vertex of a regular heptagon:
- 7 points
- Point angle = 180°(7 − 4)/7 = 180° × 3/7 ≈ 77.14°
- This is the "wider" heptagram — moderately sharp points

### 5.2 The Heptagram {7/3}

Connecting every 3rd vertex of a regular heptagon:
- 7 points
- Point angle = 180°(7 − 6)/7 = 180° × 1/7 ≈ 25.71°
- This is the "sharper" heptagram — extremely narrow points, blade-like

### 5.3 Constructing {7/2} with Compass

A regular heptagon cannot be constructed with compass and straightedge alone (it is
not constructible by classical methods). However, an **approximate** heptagon can be
constructed as follows:

**Richmond's approximate construction (1893):**
1. Draw a circle of radius `R`.
2. Mark point `A` on the circle.
3. Find the point `B` at height `R/4` above centre on the vertical diameter.
4. Draw arc from `A` through `B` — the intersection `C` with the horizontal gives
   an approximately correct 1/7 arc.
5. Step `AC` around the circle 7 times — the error is about 0.03°.

**Exact compass-only construction:** Does not exist for the heptagon (or any regular
n-gon where n has an odd prime factor other than Fermat primes 3, 5, 17, 257, 65537).
This is Gauss's theorem on constructible polygons.

### 5.4 Historical Near-Appearances of 7-Fold

Despite the mathematical impossibility, approximate 7-fold elements occasionally
appear in historical Islamic art:

- Some Moroccan fountain compositions have **14 panels** (2 × 7) arranged in a
  14-fold arrangement that creates the visual impression of 7-fold symmetry
- Certain carpet designs use 7-part border repeats
- The **Timbuktu manuscripts** (14th–17th century, Mali) contain mathematical
  notes on geometric construction that include 7-fold constructions, though the
  accuracy of these constructions is debated

No confirmed quasiperiodic 7-fold tiling has been found in historical architecture.
The 7-fold system exists as a **modern extension** of the medieval tradition —
achievable only with computational tools.

---

## 6. Computational 7-Fold Patterns

### 6.1 Shader Implementation (Fragment Shader)

The heptagrid approach in GLSL:

```glsl
#define N_FAM 7
#define PI    3.14159265358979

float hgDist(vec2 p, int k, float sp) {
    float a     = float(k) * PI / float(N_FAM);     // angle = k·π/7
    float gamma = float(k + 1) / float(2 * N_FAM);  // phase = (k+1)/14
    vec2  n     = vec2(cos(a), sin(a));
    float proj  = dot(p, n) / sp + gamma;
    return abs(fract(proj + 0.5) - 0.5) * sp;
}

float allDist(vec2 p, float sp) {
    float d = 1e9;
    for (int k = 0; k < N_FAM; k++) d = min(d, hgDist(p, k, sp));
    return d;
}
```

See `code/sevenfold_girih.glsl` for the complete rendering implementation.

### 6.2 Python Exact Construction

For exact coordinates using the algebraic number field Q(2cos(π/7)):

```python
from sympy import cos, pi, Rational, minimal_polynomial, symbols, sqrt
from sympy.polys.numberfields import field_isomorphism

# The key algebraic number
x = symbols('x')
c = cos(pi / 7)  # the fundamental 7-fold constant
# Minimal polynomial of 2cos(π/7): 8x³ - 4x² - 4x + 1
# (where x = cos(π/7))
minpoly = 8*x**3 - 4*x**2 - 4*x + 1

# To work in exact arithmetic, use the number field Q(c) ≅ Q[x]/(minpoly)
# Coordinates of the heptagrid are expressible as a + b·c + c2·c²
# where a, b, c2 ∈ Q
```

### 6.3 The 7-Fold Substitution Tiling

A clean 7-fold quasiperiodic tiling can be generated by the substitution rule:

```
Thin rhombus (T) →  T + M + M + M + T   (5 small rhombi)
Medium rhombus (M) → T + M + T + T + M + M + T  (7 small rhombi)
Thick rhombus (K) → T + M + T   (3 small rhombi)
```

*(Exact rules depend on orientation; see Socolar (1989) for the precise formulation)*

Starting from a single thick rhombus and applying the substitution repeatedly:
```
Level 0: K  (1 tile)
Level 1: T + M + T  (3 tiles)
Level 2: (5+7+5) = 17 tiles
Level 3: ...expanding by factor ≈ λ₇² ≈ 3.25 per level
```

---

## 7. The 14-Fold Star: {14/n}

The 7-fold system generates not just 7-fold but also **14-fold** stars, just as
the 5-fold system generates both {5/2} and {10/3} stars.

**The {14/5} star:** 14 points, point angle = 180°(14−10)/14 = 180°·4/14 ≈ 51.43°
**The {14/3} star:** 14 points, point angle = 180°(14−6)/14 = 180°·8/14 ≈ 102.86°
**The {14/7} star:** This decomposes into 7 separate line segments — not a connected star.

In the heptagrid rendering, the 14-fold rotette (rosette with 14-fold symmetry) appears
at the intersection of all 7 line families — the deepest potential minimum of the
rosette field, analogous to the 10-fold rosette in the pentagrid.

---

## 8. Why 7-Fold is "Alien"

The visual effect of 7-fold patterns on human observers is distinctly different from
5-fold, 6-fold, or 8-fold patterns. The reason is partly neurological:

**Human visual system and symmetry detection:** The brain detects rotational symmetry
through a process that essentially counts the number of identical sectors. For n = 4, 6, 8,
the sectors fit into the natural horizontal/vertical orientation of our visual field.
For n = 5 and 10, the diagonal symmetry creates the "golden ratio" familiarity response.

**For n = 7:** The 25.7° sector angle does not align with any familiar visual anchor.
The pattern appears "almost symmetric" but never quite completing — the eye expects
a familiar arrangement and finds instead perpetual almost-closure. This creates the
specific *unease* or *hypnotic fascination* associated with 7-fold patterns in viewer
response studies.

Islamic cosmological numerology would interpret this as appropriate: 7 is the number
of the mysterious and the celestial (seven heavens), and a 7-fold pattern should
*resist* comfortable apprehension — it should lead the eye upward rather than settling it.

---

## Further Reading

- Socolar, J. E. S. (1989). "Simple octagonal and dodecagonal quasicrystals."
  *Physical Review B*, 39(15), 10519. [7-fold and other unusual quasi-symmetries]
- de Bruijn, N. G. (1981). "Algebraic theory of Penrose's non-periodic tilings."
  *Proceedings Koninklijke Nederlandse Akademie van Wetenschappen A*, 84(1), 39–66.
  [The general N-grid construction]
- Koca, M., Koca, N. O., & Koç, R. (2014). "7-fold and 14-fold symmetric
  quasiperiodic structures." *Journal of Physics A*, 47(27).
- Baake, M. & Grimm, U. (2013). *Aperiodic Order, Volume 1: A Mathematical Primer*.
  Cambridge University Press. [Complete mathematical treatment]
- Nischke, K.-P. & Danzer, L. (1996). "A construction of inflation rules based on
  n-fold symmetry." *Discrete & Computational Geometry*, 15(2), 221–236.
