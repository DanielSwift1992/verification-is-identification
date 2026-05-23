"""
Task definitions for Verification Is Identification.

Each task: train (list of {input, output}), test (list of {input, output}).
5 tasks demonstrating the core pipeline.

Training examples sufficient for R4 (|S|=1 in feature F):
  - Duplicate values with asymmetric position → discriminate rank-based rules
  - 3+ row grids → discriminate same_row:False from row_mirror
  - Asymmetric grids → discriminate col_mirror from same_col
"""

TASKS = [
    ("Identity", {
        'train': [
            {'input': [[1, 2], [3, 4]], 'output': [[1, 2], [3, 4]]},
            {'input': [[5, 0], [0, 5]], 'output': [[5, 0], [0, 5]]},
            {'input': [[1, 2, 3], [4, 5, 6], [7, 8, 1]], 'output': [[1, 2, 3], [4, 5, 6], [7, 8, 1]]},
        ],
        'test': [{'input': [[2, 0], [0, 3]], 'output': [[2, 0], [0, 3]]}],
    }),

    ("Horizontal flip", {
        'train': [
            {'input': [[1, 2, 3], [4, 5, 6]], 'output': [[3, 2, 1], [6, 5, 4]]},
            {'input': [[7, 8], [9, 0]], 'output': [[8, 7], [0, 9]]},
            {'input': [[1, 2, 1], [3, 4, 5], [6, 7, 6]], 'output': [[1, 2, 1], [5, 4, 3], [6, 7, 6]]},
        ],
        'test': [{'input': [[1, 0, 3], [0, 5, 0]], 'output': [[3, 0, 1], [0, 5, 0]]}],
    }),

    ("Vertical flip", {
        'train': [
            {'input': [[1, 2], [3, 4]], 'output': [[3, 4], [1, 2]]},
            {'input': [[5, 6, 7], [8, 9, 0]], 'output': [[8, 9, 0], [5, 6, 7]]},
            {'input': [[1, 2], [3, 4], [5, 6]], 'output': [[5, 6], [3, 4], [1, 2]]},
        ],
        'test': [{'input': [[1,2,3],[4,5,6],[7,8,9]], 'output': [[7,8,9],[4,5,6],[1,2,3]]}],
    }),

    ("Fill minority", {
        'train': [
            {'input': [[0, 0], [0, 1]], 'output': [[1, 1], [1, 1]]},
            {'input': [[2, 0], [0, 0]], 'output': [[2, 2], [2, 2]]},
            {'input': [[0,0,0],[0,5,0],[0,0,0]], 'output': [[5,5,5],[5,5,5],[5,5,5]]},
        ],
        'test': [{'input': [[0, 3], [0, 0]], 'output': [[3, 3], [3, 3]]}],
    }),

    ("Fill majority", {
        'train': [
            {'input': [[1,1,1],[1,0,1],[1,1,1]], 'output': [[1,1,1],[1,1,1],[1,1,1]]},
            {'input': [[3,3,3,3],[3,0,0,3],[3,3,3,3]], 'output': [[3,3,3,3],[3,3,3,3],[3,3,3,3]]},
            {'input': [[4, 4], [0, 4]], 'output': [[4, 4], [4, 4]]},
        ],
        'test': [{'input': [[5, 5], [0, 5]], 'output': [[5, 5], [5, 5]]}],
    }),
]
