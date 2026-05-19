# Rosettes: The Atomic Unit of Islamic Geometric Art

## 1. What is a Rosette?

The **rosette** is the fundamental building block of Islamic geometric art — the isolated
n-fold star surrounded by a ring of pointed petal segments, which in turn are surrounded by
connector shapes that link one rosette to the next. Every complex girih tiling can be read
as a **field of rosettes** connected by secondary lattice elements.

The word *rosette* (from Latin *rosetta*, little rose) entered Islamic art scholarship through
European art history; the Arabic-Persian term is closer to **نجمة** (*najma*, star) or
**گل** (*gol*, flower) — the pattern is simultaneously a star and a flower, both astronomical
and botanical.

### 1.1 Anatomy of a Rosette

```
                        ·   ·
                      ·       ·
                    ·  petal  ·
                  ·             ·
                ·    →  tip  ←   ·
              ·    ↗            ↖  ·
            ·                       ·
          * — — — — — — — — — — — — *
          |         core             |
          |    (central polygon)     |
          * — — — — — — — — — — — — *
            ·                       ·
              ·  connector   ·  ·
```

A complete rosette consists of three concentric zones:

1. **Core** — the central regular polygon (decagon for 10-fold, hexagon for 6-fold, etc.)
   This is the "heart" of the rosette; in tile work it is often the richest colour.

2. **Petal ring** — N pointed star-arms projecting outward from the core. Each petal is an
   isosceles triangle or kite shape. The **petal tip angle** determines the "sharpness" of
   the style:
   - 36° tips → acute, blade-like (most classical, used in Darb-i Imam)
   - 54° tips → medium sharpness
   - 72° tips → blunt, stubby

3. **Connector zone** — the spaces between adjacent petals. In an isolated rosette these are
   open (negative space); in a tiling they are filled by connecting polygon shapes that link
   neighbouring rosettes.

---

## 2. The Rosette Construction Process

### 2.1 Compass-and-Straightedge Method

**For a 10-fold rosette (decagram):**

**Step 1 — Circumscribed circle**
Draw a circle of radius `R` (the outer radius of the finished rosette).

**Step 2 — Mark 10 vertices**
Divide the circle into 10 equal arcs (36° each). Mark the 10 vertices on the circle.
Compass method: first construct a regular pentagon (see `construction_methods.md`);
then bisect each arc to get 10 points.

**Step 3 — Draw the core decagon**
Connect adjacent vertices to form the outer decagon. This represents the boundary
between the petal tips and the connector zone.

**Step 4 — Inner circle**
For a {10/3} rosette (connecting every 3rd vertex), the petal tips lie on an inner
circle of radius:
```
r_inner = R · cos(2π/10) / cos(π/10) = R · cos(36°) / cos(18°) ≈ R · 0.618 / 0.951 ≈ R · 0.650
```
Wait — more precisely, the inner ring radius is determined by the petal geometry.
For a star with `n` points and connecting every `k`-th vertex:
```
r_inner = R · sin((k-1)π/n) / sin(kπ/n)
```
For n=10, k=3: `r_inner = R · sin(2π/10) / sin(3π/10) = R · sin(36°)/sin(54°) ≈ R · 0.588/0.809 ≈ 0.727R`

**Step 5 — Draw the star**
Connect each of the 10 outer vertices to the vertex 3 positions away. The resulting
{10/3} star crosses itself to create the central decagonal core.

**Step 6 — Strapwork contact points**
Mark the contact points on each segment at the golden section: `1/φ² ≈ 0.382` from
one end. Connect these to form the interlacing strapwork.

---

### 2.2 The {n/k} Notation

A rosette is characterised by its **Schläfli symbol** {n/k}:
- `n` = number of points (the fold symmetry)
- `k` = the "skip" count (how many vertices you skip when drawing the star)

| Symbol | Name | Points | Tip angle | Common use |
|--------|------|--------|-----------|------------|
| {5/2}  | Pentagram | 5 | 36° | Small pentagons in 5-fold patterns |
| {6/2}  | Hexagram | 6 | 60° | Six-fold (Star of David structure) |
| {8/3}  | Octagram | 8 | 45° | Alhambra-style 8-fold patterns |
| {10/3} | Decagram | 10 | 36° | Standard girih rosette |
| {10/4} | Decagram (wide) | 10 | 72° | Less common, wider petals |
| {12/5} | Dodecagram | 12 | 30° | 12-fold, Moroccan zellige |
| {12/4} | Hexagonal star | 12 | 60° | Common in Ottoman tilework |

**Tip angle formula:**
```
tip angle = π − 2πk/n = 180° − 360°k/n
```

For {10/3}: tip = 180° − 108° = 72°? 
Actually: tip angle = π(1 − 2k/n) = 180°(n − 2k)/n
For {10/3}: tip = 180°(10−6)/10 = 180°×4/10 = 72°

Wait — for {5/2} (pentagram): tip = 180°(5−4)/5 = 36°. Correct ✓
For {10/3}: tip = 180°(10−6)/10 = 72°. ✓
For {8/3}: tip = 180°(8−6)/8 = 45°. ✓

---

## 3. Rosette Types by Symmetry Order

### 3.1 Four-Fold Rosettes ({8/n})

**{8/3} — The Alhambra Star**

The 8-pointed star with 45° tips. Ubiquitous in Seljuk, Mamluk, and Andalusian art.
It appears on nearly every tiled floor, carved stucco wall, and wooden screen in the
Alhambra. The central octagon and surrounding 8 petals connect to square connectors and
octagonal secondary shapes.

**Proportions:** All lengths involve √2.
```
Core octagon edge / petal height = √2 − 1 ≈ 0.414
Outer circle / inner circle = √(2 + √2) / 1 ≈ 1.848
```

**{8/2} — The Square Star**

Connecting every 2nd vertex of an octagon gives a compound figure: two overlapping
squares rotated 45° relative to each other (Star of Lakshmi). Less common in Islamic art
than the {8/3} star but appears in carpet designs and manuscript illumination.

---

### 3.2 Five-Fold Rosettes ({10/n})

**{10/3} — The Classical Islamic Rosette**

This is the fundamental unit of the 5-fold/10-fold girih system. Its tip angle of 72°
(NOT 36° — see the calculation above) gives it a distinctive full, rounded quality.

The petal kite shape: the two sides of each petal make an angle of 72° at the tip.
The base of each petal (connecting it to the core) spans 36° of the outer circle.

**Proportions:** All lengths involve φ.
```
Outer radius / core radius = φ
Petal height / petal base  = φ
Long diagonal / short diagonal of petal kite = φ²
```

**{10/4} — The Wider Decagram**

Connecting every 4th vertex gives a different 10-pointed star with 72° tips — but a
completely different geometry. This star decomposes into two overlapping regular pentagons
(one regular pentagon connects every other vertex of a regular decagon when k=2; here k=4
gives the same decomposition structure). Less common in classical Islamic art; occasionally
seen in Ottoman work.

**{5/2} — The Pentagram**

The 5-pointed star with 36° tips. Appears at the corners and filling shapes of 10-fold
compositions — never as the primary rosette centre but always in a supporting role.
Every pentagonal girih tile contains an implicit {5/2} pentagram as its interior
decoration.

---

### 3.3 Six-Fold Rosettes ({12/n} and {6/n})

**{12/5} — The Moroccan Dodecagram**

12 petals with 30° tips — the sharpest classical rosette. The extreme fineness of
30° tips requires exquisite precision in stone-cutting or tile work. Found predominantly
in Moroccan zellige and Mamluk Cairo patterns. The connector shapes between petals are
small equilateral triangles.

**{6/2} — The Hexagram**

Six petals with 60° tips. The Star of David / Seal of Solomon shape; appears in Islamic
geometric art as a secondary rosette in 6-fold and 12-fold patterns. Not typically used
as the primary design element (perhaps due to its Jewish/Christian associations).

---

### 3.4 Rare and Exotic Rosettes

**{7/2}, {7/3} — Heptagram Rosettes**

Heptagram rosettes with 7 petals. Almost never found in historical Islamic art (the 7-fold
system cannot tile the plane). When they do appear, it is often as isolated decorative
elements — in a manuscript border, not a repeating pattern.

**{9/n} — Enneagram Rosettes**

9-fold patterns are equally rare and for the same reason (9-fold cannot tile the plane
with a simple polygon). See `sevenfold_geometry.md` for the theory of these "impossible"
symmetries.

---

## 4. The Rosette as Module

### 4.1 The Modular Design System

In the girih tile system, the **decagonal tile** is essentially a pre-drawn rosette: it
carries the {10/3} star decoration on its interior, and its 10 edges connect to the edges
of adjacent tiles. The girih system can be thought of as:

> **A set of pre-drawn rosette modules that clip together at their edges.**

Each edge of a girih tile has one strapwork line crossing it (the "contact point"). When
two edges are joined, their contact points align and the strapwork lines continue smoothly
across the join. The result is that assembling tiles is the same as assembling rosettes —
the mathematics is encoded in the modules, not in the craftsman's head.

### 4.2 Rosette Density

In a Penrose / girih quasiperiodic tiling, the density of 10-fold rosette centres follows
the Fibonacci/golden-ratio distribution:
```
Fraction of tiles that are decagons = 1 / (1 + φ + φ² + ...) ≈ 1/φ⁴ ≈ 0.146
```
Approximately 14.6% of all tile positions in the quasiperiodic tiling are decagon centres
(rosette centres). The rest are pentagons, hexagons, rhombi, and bow-ties.

For the purely periodic (approximant) tilings, the fraction can vary widely depending on
how many decagons the designer chooses to include.

---

## 5. Rosette Construction in Code

### 5.1 SDF Approach (fragment shader)

```glsl
// Fold angle into one fundamental sector of width 2π/n
float a = atan(p.y, p.x);
float sector = 2.0 * PI / float(N);
a = mod(a + 0.5 * sector, sector) - 0.5 * sector;  // a ∈ [-sector/2, sector/2]

// Star arm: in the sector, the arm spans angle ±halfTip at radius r
float halfTip = tipAngle * 0.5;  // tip angle in radians
float armDist = abs(p.y) - length(p) * sin(halfTip);  // approximately
float radial  = length(p) - R;  // negative inside outer radius

float starSDF = max(armDist, radial);  // inside arm: both negative
```

See `code/rosette_girih.glsl` for the complete implementation.

### 5.2 Parametric SVG Approach

```python
import math

def rosette_points(n, k, R, r_inner):
    """
    Generate the vertices of an {n/k} star rosette.
    n = number of points, k = skip count, R = outer radius, r_inner = inner radius.
    Returns list of (x, y) tuples for the star outline.
    """
    pts = []
    for i in range(2 * n):
        if i % 2 == 0:
            # Outer vertex (tip)
            angle = i * math.pi / n
            pts.append((R * math.cos(angle), R * math.sin(angle)))
        else:
            # Inner vertex (indent)
            angle = i * math.pi / n
            pts.append((r_inner * math.cos(angle), r_inner * math.sin(angle)))
    return pts
```

---

## 6. Colour Traditions for Rosettes

Historical tilework at major monuments assigns consistent colours to rosette elements:

### 6.1 Persian Tradition (12th–17th century CE)
- Core decagon: **deep cobalt blue** (*lapis lazuli* — the most expensive pigment)
- Petals: **turquoise** (*faience* glaze — the second-most prized colour)
- Connectors: **white** or **ivory** (cut stucco or white tile)
- Strapwork lines: **black** outline over the tile borders, or **gold** lustre

### 6.2 Andalusian Tradition (Alhambra, 13th–15th century)
- Rosette core: **deep red** or **dark blue**
- Petals: **white/ivory** (carved stucco)
- Connectors: **terracotta red** or **deep blue** (alternating)
- Background: **red and gold** (the Nasrid dynasty colours)

### 6.3 Moroccan Tradition (zellige, 13th century onward)
- Intensive polychrome: **5–7 distinct tile colours** per pattern
- Rosette cores: black or deep blue
- Petals: white, yellow, green, turquoise (each petal alternating colour)
- Connectors: black grout lines (the characteristic Moroccan zellige look)

### 6.4 Ottoman Tradition (Iznik tilework, 16th–17th century)
- White ground with cobalt blue and "tomato red" (unique to Ottoman Iznik)
- Rosette outlines: cobalt blue strapwork on white ground
- Petal fills: alternating blue and red
- The Iznik palette developed after 1530 with the introduction of Armenian bole red

---

## 7. Rosettes in Architecture: Functional vs. Decorative

A rosette is not only a visual motif — in Islamic architecture it serves structural and
symbolic purposes:

**Structural:** In muqarnas vaulting, each rosette centre corresponds to a major structural
joint or key vertex in the three-dimensional bracket system. The geometric logic of the
rosette encodes the logic of the architectural structure above it.

**Symbolic:** The rosette maps onto Islamic cosmological symbolism:
- **The centre core** = the Divine Unity (tawhid), one indivisible principle
- **The petals** = the divine attributes or names (the 99 Names of God in Islamic theology),
  each proceeding from the central unity
- **The strapwork connections** = the relationships between the divine attributes, forever
  linked into an unbreakable geometric unity
- **The infinite field of rosettes** = the infinity of divine manifestation, filling all space
  without contradiction or repetition

This cosmological reading is not imposed by later scholars — it is documented in medieval
mathematical-theological texts, particularly by Islamic philosophers and geometers who
explicitly connected the mathematical properties of geometric patterns to theological concepts
of divine order.

---

## Further Reading

- Critchlow, K. (1976). *Islamic Patterns: An Analytical and Cosmological Approach*.
  Thames & Hudson. [The cosmological interpretation]
- Bonner, J. (2017). *Islamic Geometric Patterns*. Springer. [Technical construction]
- Lee, A. J. (1987). "Islamic star patterns." *Muqarnas*, 4, 182–197.
- Kaplan, C. S. (2000). *Computer Graphics and Geometric Ornamental Design*.
  PhD thesis, University of Washington. [Computational rosette generation]
- Abas, S. J. & Salman, A. S. (1995). *Symmetries of Islamic Geometrical Patterns*.
  World Scientific.
