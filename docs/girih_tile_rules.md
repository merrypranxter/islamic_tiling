# Girih Tile Rules and Specifications

## Overview

The **girih tiles** are a set of five equilateral polygons decorated with interior lines (the
**girih strapwork**) that can be assembled edge-to-edge to produce Islamic geometric patterns. The
word *girih* (گره) means "knot" in Persian.

The five tiles were identified by Peter Lu and Paul Steinhardt in their 2007 *Science* paper as the
systematic basis for a large class of medieval Islamic patterns. Evidence from the 1197 CE
Gunbad-i Kabud tomb tower in Maragha, Iran, and the Topkapi scroll (c. 15th century) confirms
their use as a design system at least from the 12th century CE.

**Key property:** All five tiles have the **same edge length**. This means any edge of any tile
can abut any edge of any other tile, making the system highly flexible.

---

## 1. The Five Girih Tiles

### 1.1 Decagon (10-sided regular polygon)

```
         *
        / \
       /   \
      *     *
     /       \
    *         *
     \       /
      *     *
       \   /
        \ /
    *----+----*
        / \
       ...
```

More accurately, a regular decagon:

```
        .----.
      /        \
    /            \
   |              |
   |              |
    \            /
      \        /
        '----'
```

| Property | Value |
|----------|-------|
| Number of sides | 10 |
| Interior angle at each vertex | 144° |
| Sum of interior angles | 1440° |
| Edge length | `e` (unit) |
| Circumradius | `e · φ = e(1+√5)/2 ≈ 1.618e` |
| Inradius | `e · φ · cos(18°) ≈ 1.539e` |

**Interior decoration:** A 10-pointed star ({10/4} or {10/3} depending on the period/region).
The decoration lines connect non-adjacent vertices of the decagon, dividing the interior into a
central decagon (at smaller scale) surrounded by 10 kite-shaped regions.

**Strapwork lines inside the decagon:**
- 10 lines, each connecting a point on one edge to a point on the edge 3 positions away
- The lines are equally spaced along each edge at the **girih contact fraction**
- Contact angle: 72° from each edge

---

### 1.2 Pentagon (regular 5-sided polygon)

```
       *
      / \
     /   \
    *     *
     \   /
      * *
       *
```

| Property | Value |
|----------|-------|
| Number of sides | 5 |
| Interior angle at each vertex | 108° |
| Sum of interior angles | 540° |
| Edge length | `e` (unit) |
| Circumradius | `e/(2 sin 36°) ≈ 0.851e` |
| Inradius | `e/(2 tan 36°) ≈ 0.688e` |

**Interior decoration:** A 5-pointed star (pentagram, {5/2}). The lines connect each edge contact
point to the contact point on the edge two positions away (skipping one edge).

**Strapwork lines:**
- 5 lines forming a pentagram
- Each line makes a 72° angle with the edge it touches
- The pentagram interior creates a smaller regular pentagon at the centre

**Note:** The pentagon is the only non-convex-compatible tile; it cannot tile the plane by itself,
but in combination with the other girih tiles it fills space without gaps.

---

### 1.3 Elongated Hexagon (6-sided, two types of angles)

This tile has 6 sides but is **not** a regular hexagon. It has two pairs of interior angles:

```
    *-----------*
   / \         / \
  /   \       /   \
 *     *-----*     *
  \   /       \   /
   \ /         \ /
    *-----------*
```

| Property | Value |
|----------|-------|
| Number of sides | 6 |
| Angles at long-edge vertices | 108° |
| Angles at short-edge vertices | 144° |
| Edge length (all edges) | `e` (unit) |
| Symmetry | 2-fold (180° rotation) |

The angle sequence around the hexagon: 144°, 108°, 144°, 144°, 108°, 144°.

**Interior decoration:** Two lines forming an elongated "bowtie" or "barrel" shape — specifically,
two lines that run roughly parallel to the long axis, each connecting a point on one short edge to
a point on the short edge at the other end.

---

### 1.4 Rhombus (4-sided, two types of angles)

A rhombus with angles 72° and 108°.

```
      *
     / \
    /   \
   *     *
    \   /
     \ /
      *
```

| Property | Value |
|----------|-------|
| Number of sides | 4 |
| Acute angle | 72° |
| Obtuse angle | 108° |
| Edge length | `e` (unit) |
| Long diagonal | `e · 2 cos 36° = e · φ ≈ 1.618e` |
| Short diagonal | `e · 2 cos 72° ≈ 0.618e` |
| Ratio long/short diagonal | `φ² ≈ 2.618` |

**Interior decoration:** Two lines, each running from a contact point on one edge to a contact
point on the adjacent edge, crossing in the interior. The crossing point is not the centre of the
rhombus.

---

### 1.5 Bow-Tie / Butterfly (6-sided, non-convex)

The most unusual of the five tiles — it is concave (non-convex).

```
    *-----------*
    |           |
    * *       * *
      |       |
      *-------*
```

More accurately:

```
   *-----*     *-----*
    \     \   /     /
     \     \ /     /
      *      *      *
     /     / \     \
    /     /   \     \
   *-----*     *-----*
```

The tile looks like two pentagons joined at a vertex, with a concave notch at that vertex.

| Property | Value |
|----------|-------|
| Number of sides | 6 |
| Reflex angle (at notch) | 216° (= 360° − 144°) |
| Other angles | 72° × 2 and 144° × 3 |
| Edge length | `e` (unit) |
| Symmetry | Bilateral (one mirror axis) |

**Interior decoration:** Two lines that form a V-shape pointing toward the concave notch,
reminiscent of a small arrow or chevron.

---

## 2. Edge Length and Angle Summary

All five tiles have the **same edge length** `e`. Their angles are all **multiples of 36°**:

| Tile | Angles (degrees) | Angle multiples of 36° |
|------|-----------------|------------------------|
| Decagon | 144° × 10 | 4 × 36° |
| Pentagon | 108° × 5 | 3 × 36° |
| Elongated hexagon | 144°, 108°, 144°, 144°, 108°, 144° | 4, 3, 4, 4, 3, 4 |
| Rhombus | 72°, 108°, 72°, 108° | 2, 3, 2, 3 |
| Bow-tie | 72°, 72°, 216°, 72°, 72°, 216° | 2, 2, 6, 2, 2, 6 |

The fact that all angles are multiples of 36° is what allows them to fit together: at any vertex
in the assembled tiling, the angles must sum to 360° = 10 × 36°.

---

## 3. Matching Rules

### 3.1 Edge Compatibility

Since all edges have the same length `e`, **any edge of any tile can be joined to any edge of any
other tile** — there is no edge-type incompatibility as in some other tiling systems (e.g.,
Penrose tiles use two edge lengths).

### 3.2 Strapwork Continuity Rule

The matching rule is enforced by the **interior decoration lines**: when two tiles share an edge,
the strapwork line that exits one tile through that edge must **continue as a straight line** into
the adjacent tile through the same edge point.

This is equivalent to saying: the contact points on all edges are at the **same fractional
position** along the edge, and the line angle is the **same** on both sides of the edge.

Contact fraction: the girih lines meet each edge at a distance of `e/φ = e(√5−1)/2 ≈ 0.618e`
from one end (and `e/φ² ≈ 0.382e` from the other end), dividing the edge in the golden ratio.

Wait — more precisely, there are **two** contact points per edge for tiles where two lines cross
an edge, but for the standard girih system each edge has exactly **one** line crossing it. The
contact point is at the **midpoint** of the edge for the elongated hexagon's strapwork, and at
a position determined by the specific tile geometry for others.

### 3.3 Vertex Angle Compatibility

At every interior vertex of the assembled tiling, the vertex angles of the surrounding tiles must
sum to exactly 360°. Since all angles are multiples of 36°, this means they must sum to 10 × 36°.

Some valid vertex configurations:

```
Decagon + pentagon + rhombus: 144° + 108° + 108° = 360°  ✓
Decagon + 2×pentagon: 144° + 108° + 108° = 360°  ✓
2×rhombus + pentagon: 72° + 72° + 216° = 360°  ✓
Pentagon + bow-tie vertex: combinations vary
```

---

## 4. Relationship to Penrose Tilings

### 4.1 Penrose P2 Tiling (Kite and Dart)

The Penrose P2 tiling uses two tiles:
- **Kite**: angles 72°, 72°, 72°, 144°
- **Dart**: angles 36°, 72°, 36°, 216°

### 4.2 Penrose P3 Tiling (Thick and Thin Rhombi)

The Penrose P3 tiling uses two tiles:
- **Thick rhombus**: angles 72°, 108°, 72°, 108° — **same as the girih rhombus!**
- **Thin rhombus**: angles 36°, 144°, 36°, 144°

### 4.3 Equivalence

The girih rhombus is identical to the Penrose P3 thick rhombus.

More significantly, the girih **decagon** and **pentagon** tiles can be decomposed into Penrose
kite and dart tiles, establishing a formal mathematical equivalence.

The Penrose thin rhombus can be obtained from two girih bow-tie halves (bisecting the bow-tie
across its mirror axis).

**Conversion between systems:**
```
Girih decagon   → 10 kites (P2) or 5 thick + 5 thin rhombi (P3)
Girih pentagon  → 5 kites
Girih rhombus   → 1 thick rhombus (P3) directly
Girih bow-tie   → 2 darts (P2) or 1 thin rhombus (P3)
Girih hex       → 2 thick rhombi (P3)
```

### 4.4 Quasicrystalline Order

Because the girih tiles are equivalent to Penrose tiles, an aperiodic assembly of girih tiles (as
found in the Darb-i Imam) has the same mathematical properties as a Penrose tiling:
- **Long-range order**: Bragg peaks in the diffraction pattern
- **5-fold / 10-fold symmetry**: impossible in periodic crystals (crystallographic restriction)
- **Self-similarity**: inflating by φ² yields the same tiling
- **Aperiodicity**: the tiling never repeats with any translational period

---

## 5. Inflation and Deflation Rules (Substitution Tiling)

The girih tiles admit a **substitution (inflation) rule**: each tile can be replaced by a scaled
assembly of smaller girih tiles, such that the same pattern emerges at all scales.

**Inflation scale factor:** φ² = (3+√5)/2 ≈ 2.6180

### 5.1 Deflation Rules

After scaling down by φ², each original tile is decomposed ("deflated") into:

| Original tile | Deflates into |
|--------------|---------------|
| Decagon | 1 small decagon + 10 small kites (= 5 pentagons + 5 bow-tie halves) |
| Pentagon | 1 small pentagon + 5 small bow-tie halves (≈ 1 pentagon + ... ) |
| Elongated hexagon | 2 small rhombi + 2 small bow-tie halves |
| Rhombus | 1 small rhombus + 2 small bow-tie halves |
| Bow-tie | 1 small bow-tie + 1 small rhombus section |

The exact deflation rules depend on the specific variant of the girih system; the Darb-i Imam
tiling uses a specific two-level hierarchy — see `darb_imam_analysis.md` for details.

### 5.2 Inflation Rules (Reverse)

**Inflation** replaces each small tile with a larger tile, grouping adjacent small tiles together:
- Five small pentagons arranged around a shared vertex → one large decagon
- Two small rhombi side by side (sharing a long edge) → one large elongated hexagon
- One small rhombus + two adjacent small bow-ties → one large rhombus

**Self-similarity equation:**
A girih tiling `T` is **self-similar** if inflating all tiles by factor `φ²` and then applying the
deflation rules produces a tiling identical (up to translation and rotation) to `T`.

The Penrose tiling is self-similar in this sense; so are the quasicrystalline Islamic patterns.

---

## 6. Decorated Strapwork Lines — Detailed Specification

For each tile, the strapwork lines are specified by their endpoints on the tile edges. All
measurements are fractions of the edge length `e`.

### 6.1 Decagon

Each edge has one contact point at its midpoint (fraction 1/2). The strapwork lines connect each
midpoint to the midpoint of the edge 3 positions away (modulo 10). This generates a {10/3}
decagram pattern inside the tile.

```
Vertices labelled 0–9, edges 0–9 (edge i connects vertex i to vertex i+1)
Contact point on edge i: midpoint
Line from edge i → edge (i+3) mod 10
Line from edge i → edge (i+7) mod 10  [same line, opposite direction]
Total: 10 lines forming a 10-pointed star
```

### 6.2 Pentagon

Each edge midpoint connects to the midpoint of the edge 2 positions away. This generates a
pentagram {5/2}.

```
Contact point: midpoint of each edge
Line from edge i → edge (i+2) mod 5
Total: 5 lines forming a pentagram
```

### 6.3 Elongated Hexagon

Two contact points per long edge, one per short edge. The strapwork forms a bowtie/barrel.

### 6.4 Rhombus

Contact points at midpoints of all 4 edges. Two crossing lines connect opposite-edge midpoints.

```
Line 1: midpoint(edge 0) → midpoint(edge 2)  [short diagonal direction]
Line 2: midpoint(edge 1) → midpoint(edge 3)  [long diagonal direction]
The two lines cross inside the rhombus (not at its centre)
```

### 6.5 Bow-tie

Contact points at midpoints of the four outer edges (the concave edges have no contact lines in
the standard system). Two lines form a V pointing toward the concave notch.

---

## 7. Historical Development

| Period | Development |
|--------|-------------|
| c. 836 CE | Abu Yahya al-Marrakushi documents geometric constructions |
| 10th c. | Al-Buzjani writes *On the Geometric Constructions Necessary for the Artisan* |
| 1073–1092 CE | Kharraqan tomb towers, Iran — early girih-like patterns |
| c. 1197 CE | Gunbad-i Kabud, Maragha — clear evidence of girih tile system |
| c. 1200–1400 CE | Widespread use across the Islamic world |
| c. 1453 CE | Darb-i Imam, Isfahan — quasicrystalline pattern (see darb_imam_analysis.md) |
| c. 15th c. | Topkapi scroll compiled — documents both sub-grid and modular methods |
| 1974 CE | Roger Penrose independently discovers aperiodic tilings |
| 2007 CE | Peter Lu and Paul Steinhardt identify girih tiles, discover Darb-i Imam quasicrystal |

---

## 8. Quick Reference: Tile Properties

```
┌──────────────────┬──────┬──────────────────────────────┬──────────────┐
│ Tile             │Sides │ Angles (°)                   │ Symmetry     │
├──────────────────┼──────┼──────────────────────────────┼──────────────┤
│ Decagon          │  10  │ 144 × 10                     │ 10-fold      │
│ Pentagon         │   5  │ 108 × 5                      │ 5-fold       │
│ Elongated hexagon│   6  │ 108, 144, 144, 108, 144, 144 │ 2-fold       │
│ Rhombus          │   4  │ 72, 108, 72, 108             │ 2-fold       │
│ Bow-tie          │   6  │ 72, 72, 216, 72, 72, 216     │ bilateral    │
└──────────────────┴──────┴──────────────────────────────┴──────────────┘
All edge lengths equal. All angles are multiples of 36°.
```

---

## Further Reading

- Lu, P. J. & Steinhardt, P. J. (2007). "Decagonal and Quasi-Crystalline Tilings in Medieval
  Islamic Architecture." *Science*, 315(5815), 1106–1110.
- Penrose, R. (1974). "The Role of Aesthetics in Pure and Applied Mathematical Research."
  *Bulletin of the Institute of Mathematics and its Applications*, 10, 266–271.
- Grünbaum, B. & Shephard, G. C. (1987). *Tilings and Patterns*. W. H. Freeman.
- Cromwell, P. R. (2009). "The Search for Quasi-Periodicity in Islamic 5-fold Ornament."
  *The Mathematical Intelligencer*, 31(1), 36–56.
