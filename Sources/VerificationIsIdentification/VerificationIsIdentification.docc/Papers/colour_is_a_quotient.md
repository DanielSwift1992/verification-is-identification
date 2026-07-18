# Colour Is a Quotient (Gamut)

Colour is not a property of light. It is a class of lights: everything the eye maps to one image is one colour, however many beams the class holds. From that one move, the quotient, the author derives the colour stack and closes the pipeline: coordinates as charts on the quotient, hue as a residue, the display as a stated source whose reach is a cone, out-of-gamut as an empty candidate set, and bit depth as the length of a walk. The claim, pinned: colour is a quotient, and every colour space, gamut, and depth question is a question about the quotient's charts, cones, and ladders. The author pinned the two claims in the lattice first (`Colour.swift`) and wrote this paper against that encoding.

## §0. Derivation

No new postulate. From Seeing Is Encoding: the projection and its kernel. From Form Is Gauge: one content under many charts. From Light Is a Ruler: the residue and the two-tier distance. From Dynamics Is Substitution: the stated source. Colour is those four, composed on the eye.

## §1. A colour is a fiber

**CiQ1 (The quotient).** The eye's projection partitions all beams: two beams are one colour exactly when their images coincide. A colour is a fiber of that projection (the metameric class whole), and the space of colours is the quotient of light by the eye's kernel. Every colour coordinate ever written parameterizes the quotient, never the light: the chart reads nothing inside the fiber, and what it cannot read, no arithmetic on coordinates recovers. **[solid: ``ColourIsQuotient``]**

## §2. Colour spaces are charts

**CiQ2 (One quotient, many gauges).** RGB triples, XYZ, Lab, OKLCH: charts on one three-channel quotient, related by re-parameterization, the same content under different spellings, which is the gauge freedom of forms. The linear charts respect mixing, and the bent ones are for something else. One chart is canonical for mixing: the linear one, where the sum of lights is the sum of coordinates. Mixing is there, and every other chart is a spelling at the edge. A perceptually uniform chart bends its coordinates until the perceptual distance is flat along them: equal steps, equal felt difference. And one coordinate is not like the others: hue closes on itself. Hue is a residue (a position on a finite ring, the same carrier as a wave's phase), so complements are the half-turn, and the complement of the complement is the hue itself, an involution checked once for the whole ring.

## §3. A display is a cone

**CiQ3 (Gamut is a cone, and outside it S is empty).** A display is a stated source: finitely many primaries, each a written spectrum, with nonnegative levels. Its reach in the quotient is the cone the primaries span. A colour inside the cone is matched by stated levels: the certificate is the levels themselves, and membership never needs an inverse matrix, because the witness is the decomposition. A colour outside has no matching levels at all: the candidate set is empty, and the display refuses by name instead of clipping in silence. The refusal is decidable before anything shines, because the primaries are written whole. **[solid: ``GamutIsCone``]**

**CiQ4 (Three primaries never suffice).** The visible colours of single lines are a curve whose region is convex, and any three primaries span a triangle inside it: some pure line is always outside. Wider gamuts have their corners nearer the curve (the widest stated primaries are single lines themselves), and still the triangle is a triangle. Reaching every colour needs more primaries, or the identity encoder: a display that states the spectrum itself. The limit is convexity, never engineering.

## §4. Depth is a walk

**CiQ5 (Bits are halvings).** A channel's depth is the length of its walk: each bit halves the remaining brightness interval, eight bits are eight halvings, and a high-dynamic-range channel is the same walk grown longer. Precision of colour and precision of measurement are one form (a walk down stated divisions), and the display's finest step is the walk's last door, stated, never approximated. And the walk is more than storage. The eye reads brightness by ratios, a halving is one ratio, so the rung of the highest lit door is the level's logarithm: the walk's depth is the perceptually flat coordinate, and felt distance is a difference of rungs, never of counts.

## §5. Two distances, one hierarchy

**CiQ6 (Structural below, perceptual above).** The structural distance is on beams, and the perceptual distance is on the quotient. The projection maps the first onto the second and forgets the rest: a metameric pair is far below and at zero above. Every colour-difference formula is a metric on the quotient, so none of them can price what the eye already lost. The perceptually flat chart is exactly the gauge in which the upper metric is flat along coordinates. The hierarchy is the account of colour difference, never either floor alone.

## §6. The eye bounds the record

**CiQ7 (The felt step is data too).** The eye has a resolution: below one just-noticeable difference, two stimuli are one percept. The threshold is measured physiology, and it enters like every magnitude here: stated data with a pedigree, an experiment's rather than a committee's. Telling apart is then an edge comparison against the stated step. The two pedigrees never mix: physiology bounds a record's reach, and committees only name regions of it.

**CiQ8 (The perceptual quotient is finite, so completeness is a file).** Walk the ladder until adjacent rungs are one felt step apart: on deeper rungs there is nothing the quotient can carry, so the eye, not the lattice, sets the depth of a finished record. Across chromaticity the same threshold tiles the visible region into finitely many distinguishable cells: millions of them, and finite. A finite set is a file: every colour a human can tell apart is recordable whole, and "all the colours" is no figure of speech. The displays are then regions of that one field, sRGB inside P3 inside Rec.2020 inside the eye: markers on the eye's own map, useful for comparison and nothing else. The outermost cone is no standard's: it is the eye's, and the record covers it.

## §7. Standards enter as data

**CiQ9 (No committee number is inside a mechanism).** A colour standard (a white point, a threshold, a transfer curve) is a committee's stated agreement, and it enters this system the way any agreement does: as named data with a pedigree, never as a constant inside an operation. The engine keeps four operations forever (sum, product, and the two edge comparisons), and every standard reduces to them in one of three ways.

A rational bound dissolves by cross-multiplication. A ratio like 4.5:1 is nine against two, and an offset like 0.05 is one twentieth. Multiply the whole inequality through by the common denominator, and both sides are then sums and products of integers on the lattice, compared at the edge. No lattice is ever the wrong size for a rational standard, because the scaling is itself a composition.

A curve (a display's transfer function, transcendental by its formula) enters as a stated table on the ladder: one pair per rung, precision stated by depth, monotonicity a judged chain of edge comparisons. The formula is outside, as the table's generator. The system judges the table, and a table is also what the physical device has of the same curve.

Membership in a cone is a witness, never an inverse. A colour is inside a chart's gamut exactly when a decomposition over the stated primaries exists, and the decomposition is the certificate, checked against the primaries' own stated weights, so the inverse matrix exists nowhere. Outside is the empty candidate set, the same refusal every question in this system ends in.

## §8. Statement

Colour is a quotient. The eye's kernel makes the class, the class is the colour, and the charts (RGB, OKLCH, all of them) parameterize classes, with hue a residue on its ring. A display is a stated source whose reach is a cone in the quotient: inside, levels certify the match, and outside, the candidate set is empty and the refusal is named. Three primaries never cover the curve, by convexity. Depth is a walk of halvings, and colour difference is a two-storey affair: structural on the light, perceptual on the quotient, related by the projection that forgets. Standards enter as data on the lattice (rational bounds by cross-multiplication, curves by stated tables, membership by witness), and the engine's operations never grow. The whole pipeline loses information at exactly one point, the device's own cone, and the system names that point instead of hiding it: a colour here is a projected fact, never a clipped number. The outermost cone belongs to no standard: it is the eye's, the perceptual quotient inside it is finite, and a finished record is at the eye's own resolution. From the spectral line to the screen's last bit, every storey is the same mathematics: a finite structure, a stated law, a decided question.

## Scope

Claimed: the quotient, its charts, hue as a residue with its involution, the cone of stated primaries, refusal outside the cone, the convexity limit, depth as halvings, the entry of standards as data (rational bounds, stated curve tables, witness membership), and the eye as the outer bound: a stated felt step, a finite perceptual quotient, depth finished at the eye's resolution. The felt step's values and the unevenness of real discrimination ellipses are experimental data at the edge. The stated instance here is one isotropic step, named as such. Not claimed: the numerical weights of any real observer (they are at the edge), individual variation and adaptation, white points and tone mapping, and the smooth geometry of real chromaticity: the theorems are on stated instances, and numbers are at the reading edge.

## §9. Dependency

| Source | Used |
|---|---|
| Seeing Is Encoding | the projection, its kernel, the metameric class, the identity encoder |
| Form Is Gauge | one content under many charts, the gauge that flattens a metric |
| Light Is a Ruler | the residue as a cyclic coordinate, the two-tier distance, walks as precision |
| Dynamics Is Substitution | the stated source, decidability before the first act |
| Existence Is Finite | finite bases, finite rings, finite walks |
| V=I | the empty candidate set as the form of refusal |

The worked instance is beside the light domain in the examples: the metameric twins as one fiber, a one-primary display that reaches equal channels and refuses unequal ones by name, and the six-spoke hue ring with its complement involution checked generically. The author pinned the two claims in the lattice before stating them in prose, and this document exists so the colour half of the quotient is one in prose and in types.

## Topics

### Theorems this paper proves

- ``ColourIsQuotient``
- ``GamutIsCone``
