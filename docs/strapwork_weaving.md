# Strapwork: Band Interlacing in Islamic Geometric Art

## 1. What is Strapwork?

**Strapwork** (also called *band interlacing*, *knot-work*, or in Arabic *tashbīk* — تشبيك,
"interlacing") is the visual technique of rendering the geometric lines of a pattern as
three-dimensional woven bands rather than flat lines. Each line becomes a ribbon or strap of
finite width, and wherever two straps cross, one passes **over** the other, creating the illusion
of a woven fabric or basket-weave lifted off the surface.

The result transforms a 2D geometric pattern into a compelling 3D illusion of interlaced ribbons.

```
Flat lines:                 Strapwork:

    /                          / → top band
   /                      ====/ crosses
  X                       |||X
   \                      ====  bottom band (behind)
    \                          \
```

### 1.1 Historical Context

Strapwork is attested in Islamic art from at least the 8th century CE. It appears in:
- **Architecture**: carved stone and stucco, tilework (*qashani*), woodwork (*khatam*)
- **Manuscripts**: illuminated Qur'ans (the *unwan* header decoration)
- **Metalwork**: inlaid brass and bronze
- **Textiles**: woven and embroidered fabrics

The same visual tradition appears — with different local character — in Celtic illumination
(Book of Kells, c. 800 CE), Viking stone carving, and Byzantine mosaic borders.

---

## 2. The Fundamental Over-Under Rule

### 2.1 Alternating Parity

The defining rule of valid strapwork is: **at each crossing, the over/under relationship
alternates consistently along each strand**. That is, if a strand passes OVER at one crossing,
it must pass UNDER at the next crossing along that strand.

```
Strand A travels left to right:
  crossing 1: A over B  → parity = OVER
  crossing 2: A under C → parity = UNDER
  crossing 3: A over D  → parity = OVER
  crossing 4: A under E → parity = UNDER
  ...
```

This is the same rule that governs plain weaving (over-under-over-under in both warp and weft
directions) and is also the rule that determines whether a knotwork diagram is a valid
alternating knot diagram.

### 2.2 Why the Rule Creates a Valid Weave

**Theorem:** If the alternating parity rule is satisfied at every crossing, then the strapwork
is topologically equivalent to a planar projection of a set of unknotted loops in 3D space
(with possible knotting between distinct loops).

**Proof sketch:** Assign height z = 0 to all strands in the plane. At each crossing where strand
A goes over strand B, lift strand A to z = +ε above strand B. The alternating rule ensures that
no strand is required to be simultaneously above and below another strand at the same crossing,
which would be a topological contradiction.

### 2.3 The Checkerboard Assignment

A clean way to assign over/under values globally: **colour the regions of the pattern in a
two-colouring** (like a checkerboard, where no two adjacent regions share a colour). Then define
the rule: whenever a strand travels from a dark region on its left to a light region on its right,
it goes over; otherwise it goes under.

```
    dark  |  light
    ------+------
    over  |  under
```

For this assignment to be consistent, the dual graph of the pattern (regions as vertices, edges
where regions share a strand boundary) must be **bipartite** — i.e., have no odd cycles.

**Key fact:** The girih line pattern (the planar graph of strapwork lines) is always bipartite
because it is a planar graph where all faces have an even number of edges. This follows from the
geometry: every vertex in the girih pattern has degree 4 (four lines meet), and the faces
alternate between star points and polygonal regions, both with even edge counts (for 5-fold:
10-gons, 5-gons, rhombi with 4 sides, etc.).

---

## 3. Topological Constraints

### 3.1 Consistency Check

Before rendering, verify:
1. **Degree-4 vertices only**: Every crossing must have exactly 4 strands meeting. If a vertex
   has degree 2 (a corner) or degree 3 (a T-junction) or 6+, the standard over-under rule
   breaks down.
2. **No self-intersections**: Each strand should cross other strands, not itself.
3. **Planar graph**: The pattern should be embeddable in the plane without additional crossings.

### 3.2 The Euler Characteristic Constraint

For a strapwork pattern on a planar surface, the Euler characteristic gives:
```
V − E + F = 2    (for sphere topology, or 0 for torus, etc.)
```

where `V` = crossings, `E` = strand segments between crossings, `F` = enclosed regions + 1
(the unbounded region).

Since each crossing has degree 4: `2E = 4V`, so `E = 2V`. Substituting: `V − 2V + F = 2`,
giving `F = V + 2`. This constrains the allowed configurations.

### 3.3 Valid Weave Consistency

A strapwork diagram is **topologically consistent** (is a valid weave) if and only if:
1. The over-under rule alternates along every strand.
2. At every crossing, the "over" strand and "under" strand are distinct strands.

Condition 2 rules out **self-crossing** strands, where the same strand appears both above and
below itself at a crossing — a topological impossibility in 3D.

---

## 4. Determining Over/Under from Girih Geometry

### 4.1 The Canonical Assignment

The standard convention in Islamic strapwork is:

**Step 1:** Two-colour the pattern regions (faces of the planar graph).

**Step 2:** Shade the regions that are enclosed by the star points dark; shade the connecting
polygon regions light. (In practice: shade "star interior" regions dark, "ground" regions light.)

**Step 3:** Apply the right-hand rule: as a strand travels in the direction of its natural
orientation (following the star outline clockwise), whenever it passes from dark-on-right to
light-on-right, it goes OVER.

### 4.2 Rotation Direction

An equivalent rule that avoids two-colouring:

**At each crossing, the strand that is rotating more clockwise (in the local coordinate frame of
the crossing) goes OVER the strand rotating more counter-clockwise.**

This rule is consistent because the girih lines have a natural orientation (they wind around the
star centres), and the winding direction alternates over/under.

### 4.3 Algorithmic Assignment

```
For each crossing C:
  1. Label the four strands meeting at C as N, E, S, W (by direction).
  2. One pair (N–S or E–W) is the "continuous" strands (straight through).
  3. Assign: one continuous pair goes over, the other under.
  4. Check consistency with adjacent crossings: each strand must alternate.
  5. If inconsistency found: flip the assignment at C and all connected crossings.
```

In practice, Islamic pattern software (and artisans using the girih tile method) uses the
canonical two-colouring assignment, which is always consistent for valid girih tilings.

---

## 5. Celtic Knotwork vs. Islamic Strapwork

### 5.1 Similarities

Both traditions:
- Use alternating over-under weaving
- Are based on underlying planar graphs (Celtic: grid-based; Islamic: star-polygon-based)
- Create closed loops of ribbon
- Appear in illuminated manuscripts, stone carving, and metalwork
- Were developed independently and reached high sophistication c. 700–1200 CE

### 5.2 Differences

| Feature | Celtic Knotwork | Islamic Strapwork |
|---------|----------------|-------------------|
| Base geometry | Rectangular grid | Star-polygon / girih tiles |
| Symmetry | Often bilateral, linear borders | Rotational (4, 5, 6, 8, 10-fold) |
| Band width | Often variable | Often uniform |
| Colour usage | Multicoloured strands common | Often monochrome outline |
| Termination | Closed loops standard | Open field (no termination) common |
| Cultural context | Pre-Christian Irish/British | Islamic sacred architecture |
| Primary medium | Vellum illumination, stone | Stone, tile, wood, manuscript |

### 5.3 The Structural Difference

Celtic knotwork typically generates **1 or 2 closed loops** by design — the craftsman
manipulates the pattern to close it up. Islamic strapwork is typically designed as an **infinite
field pattern** that extends to fill any surface, with the boundary determined by the architecture
rather than by the pattern itself.

---

## 6. Rendering Techniques

### 6.1 Z-ordering (Painter's Algorithm)

The simplest rendering approach: draw all "under" strands first, then draw all "over" strands.

```python
# Pseudocode
for strand in all_strands:
    draw_strand_without_crossings(strand, color)

for crossing in all_crossings:
    erase_gap_in_under_strand(crossing)
    draw_over_strand_segment(crossing)
```

The gap in the under strand (where it disappears behind the over strand) is the visual cue for
depth. Gap width should be the same as the strand width for a clean look.

### 6.2 Distance Field Rendering

For high-quality rendering, compute a **signed distance field** (SDF) for the strapwork:

1. For each pixel, compute the minimum distance to any strand centreline.
2. If distance < `band_width/2`: the pixel is on a strand.
3. Determine which strand (if multiple within range) is "on top" at this pixel.
4. Apply lighting based on the strand orientation and z-height.

The SDF approach allows:
- Anti-aliased edges at any resolution
- Smooth depth (bevel / chamfer) on strand edges
- Consistent appearance when pattern is scaled

### 6.3 Shadow and Highlight

To enhance the 3D appearance:

**Ambient occlusion:** The gap where an under-strand passes behind an over-strand is darkened
(the over-strand casts a shadow on the under-strand beneath it).

**Edge bevel:** Each strand is rendered not as a flat ribbon but as a slightly rounded or
bevelled cross-section (trapezoidal or semicircular). The lit edge (typically top-left) is
highlighted, and the shadow edge (bottom-right) is darkened.

```
Cross-section of a strand (looking along its length):
         ___________
        /           \     ← highlight
       |   strand    |
        \___________/     ← shadow
```

**Typical colour assignments in historical work:**
- Over-strand: slightly lighter (catching more light)
- Under-strand visible portion: slightly darker
- Gap: much darker or black (deep shadow)

### 6.4 Width-to-Gap Ratio

The visual quality of strapwork depends on the ratio of strand width to the gap at crossings.
Historical examples suggest:
- Very tight interlace: width ≈ gap (gap/width ≈ 1:1)
- Standard interlace: gap ≈ 0.3–0.5 × width
- Open interlace: gap ≈ 0.1 × width

For star patterns, the strand width is typically 1/4 to 1/3 of the girih line spacing.

---

## 7. Knot Theory: Knots vs. Links in Girih Patterns

### 7.1 Topological Classification

Every strapwork pattern is, topologically, a **link** — a set of closed curves in 3D space that
may be tangled. The components of the link are the individual strands (closed loops).

A link with one component is a **knot**; with two or more components it is a (proper) **link**.

### 7.2 When Girih Patterns Create Knots

**For a single strand (knot):**
The pattern has only one component if and only if the two-colouring graph is connected in a
specific way — specifically, if the "Hamiltonian path" through crossings forms a single cycle.

For the standard 5-fold patterns:
- The basic pentagonal unit cell produces a **trefoil knot** or **unknot** depending on the
  specific boundary conditions and tile arrangement.
- The Darb-i Imam style quasicrystalline arrangement typically produces a **single unknot**
  (topologically equivalent to a circle) of infinite length, which for any finite patch is
  a collection of arcs with open ends.

**For multiple strands (links):**
More common in practice. The number of strands is determined by the formula:
```
Number of strands = χ/2  (where χ is related to the Euler characteristic)
```
More precisely: for a planar strapwork pattern with `V` crossings, the number of closed strands
is `V/2` ... this is not quite right in general. The correct formula requires tracing the strands.

### 7.3 The Link Invariant of a Girih Pattern

For any finite patch of a girih pattern with well-defined boundary conditions, one can compute:
- The number of distinct closed loops (strands)
- The linking number between each pair of strands
- The Alexander polynomial, Jones polynomial, etc. of each strand

However, most Islamic strapwork art is not designed with the knot-theory perspective — the
topological properties are incidental results of the over-under rule, not intentional design
targets (with some possible exceptions in Celtic knotwork, which often aims for specific counts).

---

## 8. Historical Examples: Specific Monuments

### 8.1 The Alhambra, Granada (1238–1358 CE)

The Alhambra contains numerous strapwork panels, particularly:
- **Comares Hall (Salón de Comares)**: The 8-fold octagonal strapwork ceiling, one of the largest
  wooden strapwork domes in the world.
- **Hall of the Two Sisters (Sala de las Dos Hermanas)**: Star-polygon tile floors with
  strapwork overlay in the carved stucco above.
- The carved wood panels (*alicatados* and *artesonado*) throughout the palace.

### 8.2 The Topkapi Scroll (c. 15th century CE)

A 29-metre long architectural scroll in the Topkapi Palace Museum, Istanbul. It documents
geometric patterns and their construction methods. Many patterns include explicit strapwork
lines as part of the documentation. The scroll appears to be a craftsman's technical reference
rather than a finished artwork.

### 8.3 The Sultan Hassan Mosque, Cairo (1356–1363 CE)

The madrasa-mosque of Sultan Hassan contains extensive marble inlay strapwork in its courtyard.
The 4-fold and 8-fold patterns are executed at large scale with polychrome marble, using the
strapwork over-under rule to guide the marble cutting.

### 8.4 The Selimiye Mosque, Edirne (1569–1575 CE)

Sinan's masterpiece contains tile panels with complex 10-fold strapwork in the Iznik tile
revetment. The 10-fold patterns here show the transition to Ottoman geometric style.

### 8.5 The Shrine of Shah Nematollah Vali, Mahan (c. 1436–1601 CE)

Contains extraordinarily complex 12-fold strapwork in glazed tile, combining dodecagonal
symmetry with floral arabesque. One of the most technically accomplished examples of Islamic
geometric art with strapwork.

---

## 9. Mathematical Foundations: Summary

The strapwork technique rests on three mathematical pillars:

1. **Graph theory**: The girih line pattern is a 4-regular planar graph. Its 2-colouring (the
   basis for over-under assignment) exists and is unique because the graph is bipartite — all
   face lengths are even (multiples of 2).

2. **Knot theory**: The strapwork is an alternating link diagram. The Seifert circle decomposition
   gives the number of components (strands). For "nice" patterns (genus-0 Seifert surfaces), the
   linking numbers are all ±1.

3. **Computational geometry**: The rendering requires z-ordering (or depth-buffering), signed
   distance fields, and normal computation for lighting. Modern implementations use GPU shaders.

---

## Further Reading

- Cromwell, P. R. (2012). "Celtic Knotwork: Mathematical Art." *The Mathematical Intelligencer*,
  15(1), 36–47.
- Jablan, S. V. (2002). *Symmetry, Ornament and Modularity*. World Scientific.
- Adams, C. C. (1994). *The Knot Book*. W. H. Freeman.
- Kaplan, C. S. (2005). "Islamic star patterns from polygons in contact." *Proceedings of the
  3rd International Conference on Computer Graphics and Interactive Techniques in Australasia
  and South East Asia*, pp. 177–185.
- Lee, A. J. (1987). "Islamic star patterns." *Muqarnas*, 4, 182–197.
- Necipoğlu, G. (1995). *The Topkapi Scroll: Geometry and Ornament in Islamic Architecture*.
  Getty Center for the History of Art and the Humanities.
