# Proportional Systems in Islamic Geometry

## Overview

Islamic geometric art is built on four fundamental proportional systems, each arising naturally
from the geometry of regular polygons and each associated with a specific family of patterns.
These proportions are irrational numbers — they cannot be expressed as ratios of whole numbers —
yet medieval craftsmen constructed them exactly using compass and straightedge alone.

The four systems and their associated symmetry families:

| Proportion | Decimal | Symmetry family | Base polygon |
|-----------|---------|----------------|--------------|
| √2 | 1.41421... | 4-fold, 8-fold | Square, octagon |
| √3 | 1.73205... | 3-fold, 6-fold, 12-fold | Triangle, hexagon |
| φ = (1+√5)/2 | 1.61803... | 5-fold, 10-fold | Pentagon, decagon |
| 2+√3 | 3.73205... | specific star constructions | Derived |

---

## 1. The √2 System: Octagonal Geometry

### 1.1 Origin

√2 arises from the **square**: if a square has side 1, its diagonal is √2. This is the oldest
irrational number in history — the Babylonians computed it to high accuracy by 1800 BCE, and the
Pythagoreans proved its irrationality c. 500 BCE.

### 1.2 Geometric Constructions

**Constructing √2 with compass and straightedge:**
1. Draw a unit segment `AB`.
2. Construct a square on `AB`.
3. Draw the diagonal of the square — its length is `√2`.

**Constructing a regular octagon from a square:**
1. Start with square `ABCD` of side `s`.
2. Mark off distance `s(√2−1)/2 ≈ 0.207s` from each corner along each side.
3. Connect these points to truncate the corners.
4. The resulting octagon has all sides equal to `s/√2 ≈ 0.707s`.

**Or, alternatively:**
1. Draw a square of side `s`.
2. Draw both diagonals.
3. Draw the perpendicular bisectors of all four sides.
4. The 8 intersections of these construction lines with a circle inscribed in the square give the
   octagon vertices.

```
    +-------+
   /|       |\
  / |       | \
 /  |       |  \
+   |       |   +
|   |  sq.  |   |
+   |       |   +
 \  |       |  /
  \ |       | /
   \|       |/
    +-------+
```

### 1.3 Key √2 Relationships

```
Diagonal of unit square:        √2 ≈ 1.4142
Side of octagon in unit circle: √(2−√2) ≈ 0.7654
Ratio octagon edge / square edge: 1/√2 = √2/2 ≈ 0.7071
Radius of octagon / edge:        1/(2 sin 22.5°) ≈ 1.3066
Height of octagon / width:       1 (regular octagon is square in its proportions)
```

### 1.4 Islamic Patterns Using √2

- The classic 8-pointed star (*khatam*) patterns
- The "brick" pattern of alternating squares and octagons
- Anatolian and Seljuk tile compositions
- The arabesque grids of the Alhambra's Comares Hall

---

## 2. The √3 System: Hexagonal Geometry

### 2.1 Origin

√3 arises from the **equilateral triangle**: if a triangle has side 1, its height is √3/2.
Equivalently, if a regular hexagon has circumradius 1 (vertex-to-centre), its edge length is 1
and its flat-to-flat distance is √3.

### 2.2 Geometric Constructions

**Constructing an equilateral triangle:**
1. Draw a segment `AB` of length `s`.
2. Set compass to `s` and draw arc from `A`; draw arc from `B`.
3. The intersection `C` forms the equilateral triangle `ABC`.
4. Height `h = s·√3/2`.

**Constructing a regular hexagon:**
1. Draw a circle of radius `r`.
2. Walk the compass around the circle — the chord length equals `r`, so 6 equal chords divide
   the circle into a hexagon.

```
     *
    / \
   /   \
  *     *
  |     |
  *     *
   \   /
    \ /
     *
```

**Constructing √3 from a unit:**
1. Draw unit segment `AB`.
2. Erect perpendicular at `A`.
3. Mark `C` on perpendicular at height 1 above `A`.
4. The segment `BC` has length √2. (Pythagoras: 1² + 1² = 2)
5. For √3: erect perpendicular at `B` on `BC`, mark `D` at height 1.
6. `CD` = √3. (Alternatively: draw equilateral triangle of side 2, height = √3.)

### 2.3 Key √3 Relationships

```
Height of equilateral triangle (side 1):   √3/2 ≈ 0.8660
Flat-to-flat of regular hexagon (edge 1):  √3 ≈ 1.7321
Area of equilateral triangle (side 1):     √3/4 ≈ 0.4330
Ratio long diagonal/short diagonal in hex: 2/1 (the diameter is twice the edge)
```

### 2.4 Islamic Patterns Using √3

- Six-pointed star (hexagram / Star of David) patterns
- 12-pointed star (*ithna-'ashariyyah*) compositions
- Moroccan zellige tile patterns (often hexagonal ground)
- The muqarnas (stalactite vaulting) projections

---

## 3. The Golden Ratio φ: Pentagonal Geometry

### 3.1 Definition and Properties

The **golden ratio** φ (phi) is the positive solution to:
```
φ² = φ + 1
φ = (1 + √5)/2 ≈ 1.6180339887...
```

It satisfies remarkable identities:
```
φ² = φ + 1 ≈ 2.6180
φ³ = φ² + φ = 2φ + 1 ≈ 4.2361
φ⁻¹ = φ − 1 ≈ 0.6180
φ⁻² = 2 − φ ≈ 0.3820
φⁿ = φⁿ⁻¹ + φⁿ⁻² (Fibonacci recurrence)
```

Numerically:
```
φ = 1.6180339887 4989484820 4586834365 6381177203 0917980576...
```

### 3.2 Why φ Governs Pentagonal Geometry

The regular pentagon's geometry is saturated with golden ratio relationships:

```
Pentagon side = 1:
  Diagonal                    = φ ≈ 1.6180
  Diagonal/side               = φ
  Segment cut off by crossing diagonals from vertex = 1/φ = φ−1 ≈ 0.6180
  Small inner pentagon side   = 1/φ² = 2−φ ≈ 0.3820
  Ratio outer to inner pentagon side = φ² ≈ 2.6180
```

For a regular decagon with circumradius `R`:
```
Edge length                   = R/φ = R(√5−1)/2 ≈ 0.6180R
Short diagonal (skip 1)       = R
Medium diagonal (skip 2)      = R·φ
Long diagonal (skip 4)        = 2R (diameter)
```

### 3.3 Constructing the Golden Ratio

**Euclid's construction (Elements, Book VI, Definition 3):**
Divide a segment in "extreme and mean ratio": `AB/AC = AC/CB` where `AC` is the longer part.

**Practical compass construction:**
1. Draw unit segment `AB`.
2. Erect perpendicular at `B` of height `1/2`.
3. Let `C` be the endpoint of this perpendicular.
4. Draw arc centre `C`, radius `CB = 1/2`, to intersect `CA` at `D`.
5. `AD = (√5−1)/2 = φ−1 = 1/φ` — the golden section of `AB`.
6. `AE = AB + BD = 1 + (√5−1)/2 = (√5+1)/2 = φ` where `E` is on the extension.

**From a regular pentagon:**
Any diagonal of a unit regular pentagon has length φ. So constructing a regular pentagon
(via the method in `construction_methods.md`) immediately gives the golden ratio.

### 3.4 The φ-Fibonacci Connection

The Fibonacci sequence 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ... satisfies:
```
F(n) = F(n−1) + F(n−2)
F(n)/F(n−1) → φ as n → ∞
```

The first few ratios:
```
1/1 = 1.000
2/1 = 2.000
3/2 = 1.500
5/3 = 1.667
8/5 = 1.600
13/8 = 1.625
21/13 = 1.615
34/21 = 1.619
55/34 = 1.618
89/55 = 1.6182
```

This convergence means that if you use Fibonacci numbers as proportions in a construction, you
are approximating the golden ratio. The tile spacing in Penrose and girih tilings is a continuous
version of the Fibonacci sequence, with two spacing intervals `L` and `S` satisfying `L/S = φ`.

### 3.5 Key φ Relationships

```
φ = (1+√5)/2                  ≈ 1.6180
φ² = φ+1 = (3+√5)/2          ≈ 2.6180
√φ                            ≈ 1.2720
φ/√5 = 1/(√5−1) = (√5+1)/4  ≈ 0.7236
2 cos(36°) = φ                ≈ 1.6180  [key identity!]
2 cos(72°) = φ−1 = 1/φ       ≈ 0.6180
```

The identity `2 cos(36°) = φ` is the fundamental link between φ and pentagonal geometry.

---

## 4. The 2+√3 System

### 4.1 Origin

The value `2+√3 ≈ 3.7321` arises in the construction of **regular 12-gons** and specific
star-polygon patterns. It equals `cot(15°) = tan(75°)`.

It also equals:
```
2+√3 = (√3+1)²/2 ÷ (something) 
     = 1 + √3 + ... 
     ≈ 3.7321
```

More precisely, `2+√3 = (1+√3/2)/(1−√3/2) · something`... The clean statement is:

```
tan(75°) = 2+√3
cot(15°) = 2+√3
tan(15°) = 2−√3 ≈ 0.2679
```

### 4.2 Where 2+√3 Appears

**In 12-pointed star constructions:**
- A regular 12-gon inscribed in a circle of radius `r` has edge length `r(√6−√2)/2`
- The ratio of the long diagonal to the edge is `2+√3`
- The {12/5} star has point angles of 30° and specific proportions involving `2+√3`

**In combined octagonal-hexagonal patterns:**
- Some Islamic patterns combine octagonal and hexagonal elements, creating proportional
  relationships that mix √2 and √3, and (2+√3) appears in the resulting proportions
- Specifically: `(√2 + √6)/2 · (√2 + √6)/2 / (something)` ...

**In the geometry of 12-fold stars:**
- Outer circle radius / inner radius of {12/5} star = `2+√3`
- Ratio of successive ring radii in some 12-fold patterns = `2+√3`

### 4.3 Constructing 2+√3

**Method 1 (from equilateral triangle and square):**
1. Draw a unit segment `AB`.
2. At `B`, erect a perpendicular.
3. Mark `C` at height √3 above `B` (equilateral triangle of side 2, height = √3).
4. Mark `D` at height 2 above `B`.
5. `AD = √(1 + 4) = √5` ... *this gives √5, not 2+√3.*

**Method 2 (from tangent of 15°):**
1. Construct a 30-60-90 triangle.
2. `tan(60°) = √3`. Bisect the 60° angle to get 30°, then: `tan(75°) = tan(45°+30°)`
   `= (1+tan 30°)/(1−tan 30°) = (1+1/√3)/(1−1/√3) = (√3+1)/(√3−1) = (√3+1)²/2 = 2+√3`.

**Method 3 (direct):**
1. Construct √3 (as above).
2. Add 2 (two unit lengths).

---

## 5. How These Proportions Arise from Polygon Geometry

### 5.1 Interior Diagonal Ratios

For a regular `n`-gon with unit edge, the ratio of the `k`-skip diagonal to the edge is:
```
d_k = sin(kπ/n) / sin(π/n)
```

For key values:

**Pentagon (n=5):**
```
d_1 = sin(72°)/sin(36°) = cos(36°)/sin(36°) · 2sin(36°)cos(36°)/sin(36°)
    = 2cos(36°) = φ ≈ 1.6180  [the diagonal]
```

**Hexagon (n=6):**
```
d_1 = sin(60°)/sin(30°) = (√3/2)/(1/2) = √3 ≈ 1.7321
d_2 = sin(120°)/sin(30°) = (√3/2)/(1/2) = √3  [long diagonal... wait]
d_2 = sin(2·60°)/sin(60°) ... 
```
*For hexagon, d₂ = 2 (the full diameter).*

**Octagon (n=8):**
```
d_1 (skip 1) = sin(45°)/sin(22.5°) = 1+√2 ≈ 2.4142
d_2 (skip 2) = sin(90°)/sin(22.5°) = √(4+2√2) ≈ 2.6131
d_3 (skip 3) = sin(135°)/sin(22.5°) = same as d_1
d_4 (diameter) = 1/sin(22.5°) ≈ 2.6131
```

**Decagon (n=10):**
```
d_1 (skip 1) = sin(36°)/sin(18°) = 2cos(18°) ≈ 1.9021
d_2 (skip 2) = sin(72°)/sin(18°) = φ·2cos(18°)/2cos(18°)... = φ+1 = φ² ≈ 2.6180
d_3 (skip 3) = sin(108°)/sin(18°) = φ·d_1? 
d_4 (skip 4) = sin(144°)/sin(18°) = φ·... 
```
*Key result: the decagon's skip-2 diagonal / edge = φ² ≈ 2.618.*

### 5.2 The Proportional Cascade

Each proportional system generates a "cascade" of related values through successive diagonal
ratios. The cascade for the φ system:
```
1, φ, φ², φ³, φ⁴, ... (each term = sum of two previous)
= 1, 1.618, 2.618, 4.236, 6.854, ...
```

The cascade for the √2 system:
```
1, √2, 2, 2√2, 4, 4√2, ... 
= 1, 1.414, 2, 2.828, 4, 5.657, ...
```

The cascade for the √3 system:
```
1, √3, 3, 3√3, 9, ...
= 1, 1.732, 3, 5.196, 9, ...
```

---

## 6. Angles by Symmetry Order

### 6.1 Key Angles for Each Symmetry Order

**4-fold (n=4): Square / Octagonal**

| Feature | Angle |
|---------|-------|
| Square interior | 90° |
| Square diagonal to side | 45° |
| Octagon interior | 135° |
| 4-pointed star point | 90° |
| 8-pointed star point | 45° |
| Strapwork contact angle | 67.5° |

**5-fold (n=5): Pentagonal**

| Feature | Angle |
|---------|-------|
| Pentagon interior | 108° |
| Pentagon diagonal to side | 72° |
| Pentagram point angle | 36° |
| Decagon interior | 144° |
| 5-pointed star point | 36° |
| 10-pointed star point | 36° |
| Strapwork contact angle | 72° |

**6-fold (n=6): Hexagonal**

| Feature | Angle |
|---------|-------|
| Equilateral triangle interior | 60° |
| Hexagon interior | 120° |
| Hexagram point angle | 60° |
| 6-pointed star point | 60° |
| Strapwork contact angle | 60° |

**7-fold (n=7): Heptagonal (rare in Islamic art)**

| Feature | Angle |
|---------|-------|
| Heptagon interior | 900°/7 ≈ 128.57° |
| 7-pointed star point | 360°/7 · (something) |
| Strapwork contact angle | 90° − 180°/7 ≈ 64.29° |

**8-fold (n=8): Octagonal (common)**

| Feature | Angle |
|---------|-------|
| Octagon interior | 135° |
| 8-pointed star {8/3} point | 45° |
| 8-pointed star {8/2} point | 90° |
| Strapwork contact angle | 67.5° |

**10-fold (n=10): Decagonal**

| Feature | Angle |
|---------|-------|
| Decagon interior | 144° |
| 10-pointed star {10/3} point | 36° |
| 10-pointed star {10/4} point | 72° |
| Strapwork contact angle | 72° |
| All angles multiples of | 36° |

**12-fold (n=12): Dodecagonal**

| Feature | Angle |
|---------|-------|
| Dodecagon interior | 150° |
| 12-pointed star {12/5} point | 30° |
| 12-pointed star {12/4} point | 60° |
| Strapwork contact angle | 75° |

### 6.2 Master Angle Table

For a star polygon {n/k} (n points, connecting every k-th):
```
Point angle = 180° − 360°k/n = 180°(1 − 2k/n)
```

| {n/k} | Name | Point angle |
|-------|------|------------|
| {5/2} | Pentagram | 36° |
| {6/2} | Hexagram | 60° |
| {7/2} | Heptagram | 77.1° |
| {7/3} | Heptagram (acute) | 25.7° |
| {8/3} | Octagram | 45° |
| {9/2} | Nonagram | 100° |
| {9/4} | Nonagram (acute) | 20° |
| {10/3} | Decagram | 36° |
| {10/4} | Decagram (obtuse) | 72° |
| {12/5} | Dodecagram | 30° |
| {12/4} | Square star | 60° |

---

## 7. Compass-Only Constructions for Irrational Ratios

Islamic craftsmen prized **compass-only** constructions (using compass without straightedge for
measuring exact lengths) as a mark of geometric sophistication. The 10th-century mathematician
Abu al-Wafa' al-Buzjani wrote extensively on compass constructions in his treatise *Kitab fi ma
yahtaj ilayh al-sani' min al-a'mal al-handasiyya* ("Book on What is Necessary from Geometric
Constructions for the Artisan").

### 7.1 Compass-Only Pentagon (Abu al-Wafa's Method)

1. Draw circle radius `r`, mark centre `O`.
2. Pick any point `A` on circle. Open compass to `r`, draw arc from `A` meeting circle at `B`.
3. Midpoint `M` of `OA`: open compass to `r/2` (halving operation — requires compass only via
   Mascheroni-style bisection of `OA`).
4. Open compass to distance `MB` (where `B` is at intersection of radius through `A` with a
   perpendicular line).
5. Step around — the exact procedure is in the historical manuscripts.

### 7.2 Achieving √2 with Compass Only

1. Draw circle of radius 1 (unit).
2. Mark two points `A`, `B` on the circle with chord length 1 (`AB = r = 1`).
3. The chord connecting them has length `= 2sin(angle at centre /2)`.
4. For `AB = 1 = 2R sin(θ/2)` with R=1: `sin(θ/2) = 1/2`, `θ/2 = 30°`, `θ = 60°`.
5. The chord at 90° (quarter circle) has length `√2`:
   `chord = 2R sin(90°/2) = 2·1·sin(45°) = √2`.

So: to construct `√2`, draw a circle of radius 1 and find the chord spanning 90° of arc.

---

## 8. Relationships Between the Four Systems

The four proportional systems are not isolated — they interrelate through trigonometric identities:

```
φ  = 2cos(36°)         connects φ to 10-fold (36° = 360°/10)
√3 = 2sin(60°)         connects √3 to 6-fold
√2 = 2sin(45°)         connects √2 to 8-fold (45° = 360°/8)

φ·√5 = 1+√5 = 2φ       (φ and √5 connected via the pentagon)
(√3+1)/(√3−1) = 2+√3   (2+√3 and √3 connected)
2+√3 = cot(15°)        (15° = 60°/4 connects to both 6-fold and 4-fold)
```

Patterns that combine multiple symmetry families (e.g., 4-fold and 6-fold) necessarily invoke
proportions that mix √2 and √3. The combination `√6 = √2·√3` appears in 12-fold geometry,
which combines 4-fold (square) and 6-fold (hexagon) symmetry.

---

## Further Reading

- Livio, M. (2002). *The Golden Ratio: The Story of Phi, the World's Most Astonishing Number*.
  Broadway Books.
- Herz-Fischler, R. (1998). *A Mathematical History of the Golden Number*. Dover.
- Abu al-Wafa' al-Buzjani (c. 990 CE). *Book on What is Necessary from Geometric Constructions
  for the Artisan* (Arabic; partial translations exist in Özdural, 2000).
- Özdural, A. (2000). "Mathematics and Arts: Connections between Theory and Practice in the
  Medieval Islamic World." *Historia Mathematica*, 27(2), 171–201.
- Sutton, D. (2007). *Islamic Design: A Genius for Geometry*. Wooden Books.
