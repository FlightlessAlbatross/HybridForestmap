# lets try interger optimization
import pulp
import numpy as np

# Example: Number of cells and classes
num_cells = 4000000  # example number of cells. Ultimatly we need this to go to millions!
num_classes = 5  # 5 classes

# Random probabilities for illustration (replace with your actual data)
probabilities = np.random.rand(num_cells, num_classes)

# Example class limits (replace with your actual data)
class_limits = [x*num_cells for x in [0.3, 0.1, 0.15, 0.25, 0.20]]  # example limits for each class

# Create a linear programming problem
problem = pulp.LpProblem("ClassAssignment", pulp.LpMaximize)

# Creating a list of tuples containing all the possible cell class assignments
indices = [(i, j) for i in range(num_cells) for j in range(num_classes)]

# Decision variables: Binary variables representing if cell i is assigned to class j
assignment_vars = pulp.LpVariable.dicts("Assignment", (range(num_cells), range(num_classes)), 0, 1, pulp.LpBinary)

# Objective Function: Maximize the sum of probabilities for assigned classes
problem += pulp.lpSum([probabilities[i][j] * assignment_vars[i][j] for i in range(num_cells) for j in range(num_classes)])

# Constraint: Each cell is assigned to exactly one class
for i in range(num_cells):
    problem += pulp.lpSum([assignment_vars[i][j] for j in range(num_classes)]) == 1

# Constraint: The total for each class does not exceed its limit
for j in range(num_classes):
    problem += pulp.lpSum([assignment_vars[i][j] for i in range(num_cells)]) <= class_limits[j]

# Solve the problem
problem.solve()

# Print the status of the solution
print("Status:", pulp.LpStatus[problem.status])
