# Muqarnas: Geometry of the Stalactite Vault

## 1. What are Muqarnas?

**Muqarnas** (مقرنس, pronounced *moo-kar-nas*) are the characteristic three-dimensional
bracket systems of Islamic architecture — cascading layers of small, interlocking geometric
cells that fill transitions, vault interiors, hood mouldings, and the undersides of
arches. The English approximation "stalactite vaulting" captures their appearance: they
look like crystalline cave formations suspended from the ceiling.

The word is Arabic, possibly derived from *qarana* (قَرَن, "to join") or from a Greek
root; it appears in Arabic texts from at least the 10th century CE. Contemporary
architects in Iran, Iraq, and Central Asia would have called them by the Persian word
**moqarnas** or the term **honijar** (هونیجار) in some regional traditions.

Unlike a Gothic flying buttress (which is structural), most muqarnas are **purely
decorative**. The structural work is done by the masonry behind; the muqarnas are
attached as an ornamental skin. However, some muqarnas — particularly in wooden ceilings —
are integral to the structure.

---

## 2. Mathematical Structure

### 2.1 The Plan: A Two-Dimensional Tiling

The key mathematical insight about muqarnas is: **the plan view (seen from directly
below) is a 2D Islamic geometric pattern**. Every muqarnas dome or vault has an
associated plan, and this plan is a standard geometric tiling.

```
Top view (plan):                Side view (profile):

  +-------+                    ___________
 / octag / \                  |tier 4      |
/ onal  /   \                 |___tier 3___|
+-------+   +                  |_tier 2_|
 \     / sq \                   |tier1 |
  \   /  uar \                  +------+
   \ / e cell +
    +----------
```

The relationship between plan and elevation is:
- Each **cell** in the plan corresponds to one **bracket unit** in 3D
- Different cell types (square, octagonal, triangular, etc.) correspond to different
  bracket shapes
- The cell's position in the plan determines its height (which "tier" it sits on)
- Adjacent cells that share an edge must be on adjacent tiers

### 2.2 The Three-Dimensional Cells

Each cell type in the plan maps to a specific 3D form:

| Plan cell | 3D form | Profile |
|-----------|---------|---------|
| Square | Simple bracket (flat or slightly curved) | Trapezoidal cross-section |
| Octagon | Half-dome or conical hood | Prismatic, with faceted top |
| Triangle | Half-pyramid | Triangular prism, sloped |
| Rhombus | Slanted bracket | Parallelogram-section |
| Pentagon | Pentagonal cupola | Pentagonal prism |

The height of each cell type is standardised within any given design:
a "storey" typically equals one cell width × a fixed height ratio (often 1:1 or 1:2).

### 2.3 Tier Assignment Rules

The fundamental constraint is that adjacent cells must be on **adjacent tiers** (height
levels differing by exactly ±1). This is equivalent to saying the **height function**
on the plan cells is a proper colouring of the adjacency graph with consecutive integers.

```
Valid tier assignment:          Invalid (adjacent cells same tier):
  3 2 3                             2 2 3
  2 1 2                             2 1 2
  3 2 3                             3 2 1   ← 2 and 2 share an edge ✗
```

The number of tiers determines the height of the vault. Historical examples range
from 3 tiers (simple hood mouldings) to 16+ tiers (the Alhambra's Hall of the
Two Sisters, which has 14 tiers).

### 2.4 Topological Constraint

For the tier assignment to exist (for the muqarnas to be physically constructible),
the adjacency graph of the plan cells must be **bipartite** — cells must be divisible
into two groups (even/odd tiers) with no edges within a group.

This is equivalent to requiring that all cycles in the plan adjacency graph have
**even length** — which is automatically satisfied by the square-octagon tiling and
many other Islamic tilings (see `strapwork_weaving.md`, section 2.3 on bipartiteness).

---

## 3. Historical Development

### 3.1 Origins (9th–11th Century CE)

The earliest certain muqarnas appear in the **Nishapur region of Khorasan** (present-day
northeastern Iran) in the 10th century CE. The oldest surviving examples are in:

- **Qal'a-i Bukhara** (Samanid period, c. 10th century): simple conical niches
- **Mausoleum of the Samanids, Bukhara** (c. 900 CE): geometric brick patterns that
  prefigure muqarnas in 2D
- **Gunbad-i Qabus** (1006 CE): a round tower tomb with interior hood mouldings using
  proto-muqarnas geometry

The development of full muqarnas appears to have happened rapidly in the period
1000–1100 CE, possibly as artisans formalised the geometry of earlier squinch
constructions (the squinch being a structural arch that transforms a square plan
into an octagonal dome base).

### 3.2 The Seljuk Period (1037–1194 CE)

The Seljuk Turks, patrons of an extraordinary flowering of Persian art, deployed
muqarnas on a vast scale. Key examples:

**The Great Mosque of Isfahan** (*Masjid-i Jum'a*, various phases 771–1229 CE):
Multiple muqarnas domes, each representing a different design approach. The "North
Dome" (1088–89 CE, commissioned by Nizam al-Mulk) contains one of the earliest
large-scale muqarnas in a formal mathematical geometric style.

**The Friday Mosque, Zavara, Iran** (1135–36 CE): Contains fully developed muqarnas
in the qibla iwan. Extensively studied by Yasser Tabbaa (2002).

### 3.3 Fatimid and Ayyubid Cairo (10th–13th Century)

Egyptian muqarnas developed along a different trajectory from the Persian tradition,
using simpler 4-fold geometry:

**Al-Azhar Mosque, Cairo** (970 CE onward): The Fatimid additions include early
muqarnas hood mouldings over mihrabs.

**The Mausoleum of Imam Shafi'i, Cairo** (1211 CE, Ayyubid): Contains a muqarnas
dome of remarkable complexity for its date, using a 4-fold plan with up to 9 tiers.

### 3.4 Andalusian Peak: The Alhambra (1238–1358 CE)

The Alhambra represents the **highest development of muqarnas design**, with:

**Hall of the Two Sisters (Sala de las Dos Hermanas)** (c. 1352–1391 CE):
- Plan: 16-fold symmetric octagonal grid
- Tiers: 14 tiers (16m from floor to apex)
- Cells: approximately 5,416 individual cells
- Material: carved and painted stucco
- The tiered section creates an optical illusion of extreme depth and height

**Hall of the Abencerrajes** (c. 1354 CE):
- 8-fold plan, star-shaped with 8-pointed main stars
- 9 tiers, narrower but equally complex

**The Lions' Court fountain dome** (c. 1370 CE):
- Low dome of moderate complexity
- Demonstrates muqarnas at a smaller, more intimate scale

The Alhambra muqarnas are not structural — they hang from a flat ceiling above. The
visual depth is entirely created by the layered geometry.

### 3.5 Persian Florescence (14th–17th Century CE)

**The Ilkhanid period** produced muqarnas of extraordinary mathematical complexity,
often combining Persian geometric tradition with new influences from Central Asia.

**Sultan Öljaitü Mausoleum, Sultaniyya** (1302–12 CE): One of the largest domed
structures in the world. The interior muqarnas transition between the octagonal base
and the drum of the dome is of unprecedented scale.

**The Shrine of Shah Nematollah Vali, Mahan, Iran** (c. 1436–1601 CE): Contains
muqarnas using 12-fold geometry — the most complex symmetry order regularly deployed.

**The Imam Mosque (Masjid-i Shah), Isfahan** (1611–1630 CE): Shah Abbas the Great's
masterpiece. The iwans and main dome contain muqarnas of extraordinary richness,
combining 8-fold and 5-fold elements in the same composition.

---

## 4. Construction Methods

### 4.1 The Two-Dimensional Drawing (Plan)

Medieval architects designed muqarnas using the **plan drawing** — a 2D representation
of the tiling pattern that encodes the 3D structure. The Topkapi scroll (c. 15th
century) contains numerous such plan drawings, establishing that the plan-based design
method was the standard tool of the trade.

The plan drawing specifies:
1. The cell tessellation (which polygon types fill the floor plan)
2. The tier assignments (written numerically in historical examples)
3. The cell boundary orientations (which edges face which direction)

From these three specifications, a skilled craftsman could construct the 3D brackets
without any additional information.

### 4.2 Cell Proportions

The proportional system for muqarnas cells follows the same √2, √3, φ rules as flat
Islamic geometry:

**Square cells:** all sides equal; height = width (1:1 storey ratio)
**Octagonal cells:** base = s, height = s/2 (the half-dome profile is a half-octagon)
**Rhombus cells:** dimensions determined by the rhombus angles (72°/108°)

### 4.3 Nested Muqarnas (Stalactite Structure)

In the most sophisticated examples, each muqarnas tier is itself subdivided:

```
Tier 4 (top):     ■ ■ ■ ■ ■ ■ ■ ■    (fine cells, small scale)
Tier 3:         ■ ■ ■ ■ ■ ■ ■ ■ ■ ■  (medium cells)
Tier 2:       ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ (larger cells)
Tier 1:     ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ (largest cells)
```

This nesting creates the characteristic "crystalline" appearance of depth, as the eye
perceives multiple scales of the same geometric logic receding into the vault.

---

## 5. Geometric Invariants

### 5.1 Plan Euler Characteristic

For a muqarnas plan with V vertices, E edges, F faces (cells):
```
V − E + F = 1   (for a simply-connected plan)
```
The number of tier levels required is:
```
min tiers ≥ chromatic number of the adjacency graph ≥ 2 (since bipartite)
```
In practice, the number of tiers used is much larger than the minimum — typically
6–16, as more tiers create richer visual complexity.

### 5.2 The Height Function

For a valid muqarnas, the height function h(cell) must satisfy:
```
|h(cell A) − h(cell B)| = 1   for all adjacent cells A, B
```

This is exactly the definition of a **proper 2-colouring** function (where
the "colour" is even/odd parity of the tier height). Since the plan adjacency
graph is bipartite, exactly two classes of cells exist: even-tier and odd-tier.
All even-tier cells receive one profile shape; all odd-tier cells receive another.

In the most generalised treatment (Hamekasi, Taremi Moghaddam, & Fallah, 2011),
the height function can vary continuously rather than by integer steps, producing
**smooth muqarnas** that grade seamlessly between levels — a development attributed
to the master architect Naqshband in 15th-century Herat.

---

## 6. Computational Approaches

### 6.1 Plan-to-3D Algorithm

Given a muqarnas plan (2D tile description), generate the 3D geometry:

```
For each cell in the plan:
    1. Determine cell type from polygon shape
    2. Look up the 3D bracket shape for that cell type
    3. Rotate the bracket to align with cell orientation in the plan
    4. Translate the bracket to the cell's plan position and tier height
    5. Add the bracket geometry to the 3D mesh
```

This algorithm was implemented by:
- Takahashi & Tanimoto (2002): *Computational Reconstruction of Muqarnas*
- Huerta (2005): mathematical analysis of the tier assignment problem
- Hamekasi, Taremi Moghaddam & Fallah (2011): formal parametric muqarnas system

### 6.2 Generative Design

A muqarnas can be generated **procedurally** from three parameters:
1. The plan tiling type (square-octagon, hexagonal, etc.)
2. The number of tiers
3. The cell height ratio (how steep the profile is)

This allows systematic exploration of the design space, including many configurations
that were never built historically. The shader `code/muqarnas_girih.glsl` implements
a simplified 2D projection of this generative approach.

---

## 7. Connection to Islamic Geometric Patterns

Muqarnas represent the **three-dimensional realisation** of the same geometric principles
that produce Islamic flat-surface patterns. The correspondence is direct:

| 2D flat pattern | 3D muqarnas |
|----------------|-------------|
| Tile shape | Cell type and profile |
| Tile edge | Adjacent-cell boundary |
| Star polygon centre | Top of highest tier (apex) |
| Strapwork line | Cell edge outline |
| Pattern field | Vault plan |
| Two-colouring | Even/odd tier assignment |

This means that a designer who understands 2D girih tiles automatically understands
the geometry of muqarnas — the 3D system is the 2D system with the addition of one
dimension (height/tier assignment).

---

## 8. Symbolic Significance

Like the flat geometric patterns, muqarnas carry symbolic content in the Islamic
theological tradition:

**The Descent:** Muqarnas conventionally fill the zone of transition from a square
base (the material world, four elements) to a round dome (the celestial sphere, unity).
The progressive layers represent stages in the descent from divine unity to material
multiplicity — or conversely, the ascent of the worshipper from earth toward heaven.

**Light:** A muqarnas dome is designed to modulate and scatter light. Windows placed
in the drum are angled so that light falls on the muqarnas cells from multiple directions,
creating an interplay of light and shadow that animates the geometry. The overall effect
is a shimmer of light from an apparently sourceless luminosity — a deliberate evocation
of the divine light described in the *Nur Verse* of the Qur'an (24:35).

---

## Further Reading

- Tabbaa, Y. (2002). *The Transformation of Islamic Art During the Sunni Revival*.
  University of Washington Press. [Historical development]
- Necipoğlu, G. (1995). *The Topkapi Scroll*. Getty Center. [Plan drawings in the scroll]
- El-Said, I. & Parman, A. (1976). *Geometric Concepts in Islamic Art*. World of Islam Festival.
- Hamekasi, N., Taremi Moghaddam, F. & Fallah, A. (2011). "Computational Geometry for
  Muqarnas Design." *Proceedings of IASS Symposium*.
- Huerta, S. (2005). "Mecánica de las bóvedas tabicadas de Guastavino."
  *Informes de la Construcción*, 57(499–500), 175–186.
- Shiro Takahashi, Masaaki Tanimoto (2002). "Reconstruction of Muqarnas by Computer."
  *Proceedings of International Conference on Geometry and Graphics*.
