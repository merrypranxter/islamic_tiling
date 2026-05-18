# Construction Methods for Islamic Geometric Patterns

## Overview

Islamic geometric patterns are constructed through three principal methods, each yielding the same
family of designs but approached from different angles — literally and conceptually. The three
methods are:

1. **Polygonal Sub-Grid** — lay a grid of regular polygons, then extract a star-and-polygon motif
2. **Modular Design** — assemble pre-drawn tile modules (the girih system)
3. **Contact System** — construct circles in contact and derive the geometry from their
   intersections

All three methods are equivalent in principle: any pattern constructible by one can be constructed
by the others. In practice, artisans likely blended approaches, using the sub-grid to establish
proportions and the modular tiles to fill large areas efficiently.

---

## 1. Polygonal Sub-Grid Method

The sub-grid method — sometimes called the **polygonal technique** — is the most systematic and
was documented in the 10th–12th century Persian mathematical manuscripts, including the *Fi
Tabaqat al-Musiqa* and the anonymous *Fi Tadakhul al-Ashkal*.

### 1.1 Core Principle

Draw a grid of regular polygons that tile the plane (or nearly tile it — some configurations
require gap-filling polygons). Then apply a uniform **offset rule**: inside each polygon, connect
the midpoints of the edges (or points at a fixed fraction along the edges) to generate a
star-polygon rosette at each vertex.

The offset fraction is called the **contact angle** or **incidence angle** — the angle at which
the girih line meets the polygon edge. Common values:

| Pattern Family | Contact Angle |
|---------------|---------------|
| Standard Islamic star | 72° (interior to decagon) |
| Acute star | 54° |
| Obtuse star | 36° |
| Median (standard) | 72° |

---

### 1.2 Constructing a 4-Fold (Octagonal) Pattern

**Tools required:** compass, straightedge.

**Step 1 — Base square grid**

```
+-------+-------+-------+
|       |       |       |
|       |       |       |
|       |       |       |
+-------+-------+-------+
|       |       |       |
|       |       |       |
|       |       |       |
+-------+-------+-------+
```

**Step 2 — Inscribe a regular octagon in each square**

For a square of side length `s`, cut the corners at `s/(2+√2) ≈ 0.293s` from each corner.
The octagon vertices lie at the intersection of the 45° diagonals with the lines parallel to the
sides at distance `s·√2/2/(1+√2)` from the centre.

```
    .---.
   /     \
  |       |
   \     /
    '---'
```

**Step 3 — Extend alternate edges of adjacent octagons**

The squares between octagons become small squares rotated 45°. Each octagon edge that faces an
adjacent octagon generates a **strut line** crossing the gap.

```
    .---.
   /|   |\
  / |   | \
 |  +---+  |
  \ |   | /
   \|   |/
    '---'
```

**Step 4 — Apply the offset rule at 67.5°**

From the midpoint of each octagon edge, draw lines at 67.5° to the edge into the octagon interior.
These lines intersect inside the octagon, forming an 8-pointed star (octagram, {8/3}).

```
       *
      /|\
     / | \
    /  |  \
---*---+---*---
    \  |  /
     \ | /
      \|/
       *
```

**Step 5 — Continue lines across gap squares**

The lines exit the octagon through adjacent edges and cross the gap square, entering the next
octagon. The complete network forms the finished pattern.

**Mathematical proportions used:**
- Octagon internal angle: 135°
- Star point angle: 45°
- Ratio of octagon edge to square gap: 1 : (√2 − 1) ≈ 1 : 0.4142

---

### 1.3 Constructing a 5-Fold (Decagonal) Pattern

5-fold symmetry **cannot** tile the plane with a single polygon, so the sub-grid uses a
combination of regular pentagons, decagons, and gap-filling rhombi.

**Step 1 — Establish a decagonal framework**

Place a regular decagon (10-gon). The circumradius `R` and edge length `e` satisfy:
```
e = 2R · sin(π/10) = 2R · sin(18°) = R(√5−1)/2 = R/φ
```
where `φ = (1+√5)/2 ≈ 1.6180` is the golden ratio.

**Step 2 — Surround with pentagons**

A regular decagon can be surrounded by 10 regular pentagons sharing one edge each. The pentagons
leave pentagonal gaps between them — these gaps are themselves (irregular) pentagrams or can be
filled with acute rhombi.

```
         /\
        /  \
    /\ / P  \ /\
   /  X      X  \
  / P/ \    / \P \
 /  /   \  /   \  \
|  / D   \/   D \  |
```
*(D = decagon region, P = pentagon region)*

**Step 3 — Sub-grid offset lines at 72°**

At each edge of the sub-grid polygons, draw a line at 72° (= 2×36°) to the edge inward. The
angle 72° = 360°/5 is the natural contact angle for fivefold geometry. Lines from adjacent edges
converge to form 5-pointed stars inside pentagons and 10-pointed stars inside decagons.

**Step 4 — Extract the pattern lines**

The network of offset lines IS the girih pattern. Erase the sub-grid polygons; keep only the
star-and-polygon lines.

**Golden ratio relationships:**
```
φ  = (1+√5)/2 ≈ 1.6180
φ² = φ+1      ≈ 2.6180
1/φ = φ−1     ≈ 0.6180

Diagonal of unit pentagon  = φ
Long diagonal of acute rhombus / short diagonal = φ²
Decagon circumradius / edge = φ
```

---

### 1.4 Constructing a 6-Fold (Hexagonal) Pattern

Hexagons tile the plane perfectly, making 6-fold the easiest family.

**Step 1 — Triangular/hexagonal grid**

```
    / \ / \ / \
   /   X   X   \
  | hex | hex | hex |
   \   X   X   /
    \ / \ / \ /
```

**Step 2 — Apply 60° offset lines**

From each hexagon edge midpoint, draw lines at 60° inward. These produce 6-pointed stars (Star
of David / hexagram) at hexagon centres and triangular gaps between.

**Step 3 — Dual hexagonal patterns**

The hexagonal sub-grid admits two offset families:
- **Obtuse** (lines meet edge at 30°): produces a pattern of triangles and hexagrams
- **Acute** (lines meet edge at 60°): produces a pattern of interlocking stars and hexagons

**Mathematical proportions:**
```
√3 = 1.73205...
Hexagon height / width = √3
Equilateral triangle height / side = √3/2 ≈ 0.866
```

---

### 1.5 Constructing a 10-Fold Pattern

The 10-fold pattern is the most sophisticated and is the basis for the Darb-i Imam quasicrystal.

**Step 1 — Decagonal tiling basis**

Use the two Penrose-equivalent tiles: the **thick rhombus** (angles 72°/108°) and **thin rhombus**
(angles 36°/144°). These can also be assembled from girih tiles.

**Step 2 — Two-level hierarchy**

A key feature of 10-fold patterns is that the pattern can be read at two scales:
- **Small scale**: individual star polygons (decagons, pentagons, etc.)
- **Large scale**: the same pattern repeated at scale factor φ² ≈ 2.618

This self-similarity is the hallmark of a **quasicrystal**.

**Inflation ratio:**
```
Scale factor between levels = φ² = (3+√5)/2 ≈ 2.6180
```

Each large tile decomposes into smaller copies of itself according to fixed substitution rules.

---

## 2. Modular Design Method (Girih Tiles)

Rather than constructing the sub-grid each time, artisans working from at least the 11th century
used a set of **five pre-decorated tiles** — the girih tiles — that could be assembled like
jigsaw pieces. The decoration on each tile was pre-determined; aligning tiles edge-to-edge
automatically produced a consistent pattern.

The five girih tiles are:
1. **Regular decagon** (10 sides) — carries a 10-fold star
2. **Regular pentagon** (5 sides) — carries a 5-fold star
3. **Elongated hexagon** (6 sides, 2 pairs of parallel sides) — carries a bowtie motif
4. **Rhombus** (4 sides) — carries crossing lines
5. **Bow-tie / butterfly** (6 sides, non-convex) — carries a concave star element

See `girih_tile_rules.md` for full specifications.

---

## 3. Contact System Method

The contact system derives the pattern geometry from **circles in mutual tangency**. This method
is particularly suited to compass-only construction and may be the oldest technique.

**Procedure:**
1. Draw a central circle of radius `r`.
2. Pack circles of equal radius around it so they are mutually tangent.
3. The points of tangency and the intersections of the circles define the pattern vertices.
4. Connect vertices according to a uniform rule (e.g., nearest-neighbour, or skip-one).

For 6-fold patterns, 6 equal circles of radius `r` pack perfectly around a central circle of
radius `r`, with all 7 circles of equal size. The 6 tangency points form a regular hexagon.

For 5-fold patterns, 5 circles of radius `r·φ` pack around a central circle of radius `r`.

**Why the contact system works:**
The centres of tangent circles of equal radius are always at distance `2r` from each other — they
lie on a regular polygon lattice. The geometry of tangency points is therefore equivalent to the
geometry of sub-grid polygon midpoints.

---

## 4. Extracting Girih Lines from the Polygon Grid

Once the sub-grid is constructed, the girih lines are extracted as follows:

1. **Mark contact points** on each polygon edge at the offset fraction (e.g., midpoint, or 1/φ
   from one end for golden-ratio constructions).

2. **Connect contact points** within each polygon according to the polygon's internal rule:
   - In a decagon: connect every contact point to the one three positions away (skip 2)
   - In a pentagon: connect every contact point to the one two positions away (skip 1)
   - In a hexagon: connect every contact point to the one two positions away
   - In a rhombus: connect opposite contact points (a straight line through the centre)

3. **Where lines exit a polygon**, they enter the adjacent polygon through the shared edge. The
   lines must be **collinear** across the shared edge — this is the key constraint that determines
   the contact angle.

4. **The result** is a network of lines that covers the entire tiled region with no gaps and no
   contradictions.

**Collinearity constraint derivation:**

For two regular polygons sharing an edge, let the edge contact angle be `α`. The line entering
from the left polygon at angle `α` must exit as a line from the right polygon also at angle `α`
(measured from the shared edge). This constrains `α` to be:

```
α = π/2 − π/n   (for an n-gon)
```

For n=10: α = 90° − 18° = 72°  
For n=8:  α = 90° − 22.5° = 67.5°  
For n=6:  α = 90° − 30° = 60°  
For n=5:  α = 90° − 36° = 54°  
For n=4:  α = 90° − 45° = 45°  

---

## 5. Mathematical Proportions Reference

### Trigonometric Values for Key Angles

| Angle | sin | cos | tan |
|-------|-----|-----|-----|
| 18°   | (√5−1)/4 ≈ 0.309 | √(10+2√5)/4 ≈ 0.951 | √(5−2√5) ≈ 0.325 |
| 36°   | √(10−2√5)/4 ≈ 0.588 | (√5+1)/4 ≈ 0.809 | √(5−2√5) ≈ 0.727 |
| 54°   | (√5+1)/4 ≈ 0.809 | √(10−2√5)/4 ≈ 0.588 | φ ≈ 1.618 |
| 72°   | √(10+2√5)/4 ≈ 0.951 | (√5−1)/4 ≈ 0.309 | √(5+2√5) ≈ 3.078 |

### Star Polygon Notation

| Symbol | Description | Points | Skip |
|--------|-------------|--------|------|
| {5/2}  | Pentagram | 5 | 2 |
| {6/2}  | Hexagram (Star of David) | 6 | 2 |
| {8/3}  | Octagram | 8 | 3 |
| {10/3} | Decagram | 10 | 3 |
| {10/4} | Decagram (different) | 10 | 4 |
| {12/5} | Dodecagram | 12 | 5 |

### Polygon Angle Tables

| n | Interior angle | Exterior angle | Sum of angles |
|---|---------------|----------------|---------------|
| 3 | 60°  | 120° | 180°  |
| 4 | 90°  | 90°  | 360°  |
| 5 | 108° | 72°  | 540°  |
| 6 | 120° | 60°  | 720°  |
| 7 | 128.57° | 51.43° | 900° |
| 8 | 135° | 45°  | 1080° |
| 10 | 144° | 36° | 1440° |
| 12 | 150° | 30° | 1800° |

---

## 6. Compass-and-Straightedge Construction Details

### Constructing a Regular Pentagon (classic method)

1. Draw a circle of radius `R`, centre `O`.
2. Draw a diameter `AB`.
3. Construct the perpendicular bisector of `AB` to find `C` on the circle.
4. Find the midpoint `M` of `OB`.
5. Draw arc centre `M` radius `MC` to intersect `AB` at `D`.
6. Distance `CD` is the side length of the inscribed pentagon.
7. Step around the circle with compass set to `CD`.

### Constructing a Regular Decagon

Follow the pentagon construction, then bisect each arc between pentagon vertices.

Alternatively: the edge of a regular decagon inscribed in a circle of radius `R` equals `R/φ`.
Set compass to `R/φ = R(√5−1)/2` and step around.

### Achieving √2 Without a Calculator

1. Draw a unit square.
2. Its diagonal is `√2`.

### Achieving φ Without a Calculator

1. Draw a unit square `ABCD`.
2. Find midpoint `M` of `AB`.
3. Draw arc centre `M` radius `MC` to intersect extension of `AB` at `E`.
4. `AE = φ` (golden ratio).

This is Euclid's construction, Book II Proposition 11.

---

## 7. Common Mistakes and How to Avoid Them

| Mistake | Cause | Fix |
|---------|-------|-----|
| Stars don't close | Wrong contact angle | Recalculate α = 90° − π/n |
| Pattern doesn't tile | Sub-grid polygons have gap | Use correct gap-filler polygons |
| Lines don't align at boundaries | Offset not consistent | Apply same fraction to all edges |
| Asymmetric star points | Irregular base polygon | Verify polygon regularity with compass |

---

## Further Reading

- Critchlow, K. (1976). *Islamic Patterns: An Analytical and Cosmological Approach*. Thames & Hudson.
- Bonner, J. (2017). *Islamic Geometric Patterns: Their Historical Development and Traditional Methods of Construction*. Springer.
- Bourgoin, J. (1879). *Les Éléments de l'art arabe*. Paris. (Dover reprint 1973.)
- El-Said, I. & Parman, A. (1976). *Geometric Concepts in Islamic Art*. World of Islam Festival.
