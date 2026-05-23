"""
§3–§4 Grid domain — atoms, features, compile, execute.

Pipeline: ENCODE → VALIDATE(basis) → COMPILE → EXECUTE (§5.5)
"""

from primitives import peano, from_peano, compare


# §4.1 Atoms — Cell = ((row_peano, col_peano), value_peano)

def encode_cell(row, col, value):
    return ((peano(row), peano(col)), peano(value))

def cell_row(cell):    return cell[0][0]
def cell_col(cell):    return cell[0][1]
def cell_value(cell):  return cell[1]
def cell_position(cell):
    return from_peano(cell_row(cell)), from_peano(cell_col(cell))


# Grids

def encode_grid(grid):
    return [encode_cell(r, c, grid[r][c])
            for r in range(len(grid)) for c in range(len(grid[0]))]

def decode_grid(values, rows, cols):
    return [[from_peano(values[r * cols + c]) for c in range(cols)]
            for r in range(rows)]

def grid_shape(grid):
    return len(grid), len(grid[0])

def grid_bounds(cells):
    return (max(from_peano(cell_row(c)) for c in cells),
            max(from_peano(cell_col(c)) for c in cells))

def basis_valid(input_cells, output_cells):
    return ({cell_value(c) for c in output_cells}
            .issubset({cell_value(c) for c in input_cells}))


# Features (§4.4)

FEATURE_NAMES = frozenset({
    'same_row', 'same_col', 'row_mirror', 'col_mirror', 'rank',
})

def value_rank(cell, all_cells):
    """Number of colors less frequent than this cell's color."""
    sizes = {}
    for c in all_cells:
        v = cell_value(c)
        sizes[v] = sizes.get(v, 0) + 1
    return sum(1 for s in sizes.values() if s < sizes[cell_value(cell)])

def equation(output_cell, source_cell, in_bounds, all_input, graph=None):
    cmp = graph.compare if graph is not None else compare
    out_r, out_c = cell_position(output_cell)
    inp_r, inp_c = cell_position(source_cell)
    max_r, max_c = in_bounds
    return {
        'same_row':   cmp(peano(out_r), peano(inp_r)),
        'same_col':   cmp(peano(out_c), peano(inp_c)),
        'row_mirror': cmp(peano(out_r), peano(max_r - inp_r)),
        'col_mirror': cmp(peano(out_c), peano(max_c - inp_c)),
        'rank':       value_rank(source_cell, all_input),
    }


def value_matches(output_cell, input_cells, graph=None):
    cmp = graph.compare if graph is not None else compare
    v = cell_value(output_cell)
    return [c for c in input_cells if cmp(v, cell_value(c))]



# Equations (§4.3)

def write_equations(examples, grids=None, graph=None):
    unambiguous, ambiguous, background = [], [], []
    for idx, (input_cells, output_cells) in enumerate(examples):
        in_bounds = grid_bounds(input_cells)
        def eq(out_cell, src):
            return equation(out_cell, src, in_bounds, input_cells, graph)

        background.extend(
            eq(encode_cell(r, c, 0), source)
            for source in input_cells
            for r in range(in_bounds[0] + 1)
            for c in range(in_bounds[1] + 1))

        for output_cell in output_cells:
            matches = value_matches(output_cell, input_cells, graph)
            candidates = [eq(output_cell, source) for source in matches]
            if len(candidates) == 1:
                unambiguous.append(candidates[0])
            else:
                ambiguous.append(candidates)
    return unambiguous, ambiguous, background


# Execute (§4.8)

def best_source(target, candidates, rule, in_bounds, all_input, graph=None):
    from engine import match_score
    return max(candidates,
               key=lambda s: match_score(
                   equation(target, s, in_bounds, all_input, graph), rule))

def execute(rule, cells, out_rows=None, out_cols=None, in_rows=None, in_cols=None, graph=None):
    in_bounds = grid_bounds(cells)
    if in_rows is None:
        in_rows, in_cols = in_bounds[0] + 1, in_bounds[1] + 1
    if out_rows is None or out_cols is None:
        out_rows, out_cols = in_rows, in_cols

    if out_rows == in_rows and out_cols == in_cols:
        return [cell_value(best_source(t, cells, rule, in_bounds, cells, graph))
                for t in cells]

    flat = []
    for r in range(out_rows):
        for c in range(out_cols):
            target = encode_cell(r, c, 0)
            flat.append(cell_value(best_source(
                target, cells, rule, in_bounds, cells, graph)))
    return flat


# Compile (§4.7)

def compile_check(rule, examples, grids, graph=None):
    for i, (input_cells, _) in enumerate(examples):
        out_rows, out_cols = grid_shape(grids[i]["output"])
        in_rows, in_cols = grid_shape(grids[i]["input"])
        pred = decode_grid(
            execute(rule, input_cells, out_rows, out_cols, in_rows, in_cols, graph),
            out_rows, out_cols)
        if pred != grids[i]["output"]:
            return False, i
    return True, -1
