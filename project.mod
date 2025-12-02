set S;   # shoe types
set K;   # raw materials
set M;   # machines
set W;   # warehouses

param D{S};          # demand for February (pairs)
param p{S};          # sales price per pair
param a{S, K} default 0;        # quantity of raw material k per pair of shoe s
param c{K};          # cost per unit of raw material k
param t{S, M} default 0;        # processing time of shoe s on machine m (seconds)
param o{M};          # operating cost of machine m ($ per minute)
param C{W};          # warehouse capacity (pairs)
param u{K};			# Raw material quantity

var x{S} integer >= 0;   # number of pairs of shoe s produced and sold

maximize profit:
    sum{s in S} p[s]*x[s] #revenue
  - sum{s in S, k in K} c[k]*a[s, k]*x[s] #material costs
  - sum{s in S, m in M} (t[s, m]/3600) * x[s] * ( o[m]*60 + 25) #machine costs
  - sum{s in S} 10*(D[s]-x[s]); #unmet demand

# Machine time: each machine m has 12 h/day * 28 days = 336 hours
# Convert total time to hours: t[m,s]/3600 * x[s]
subject to Machine_Available{m in M}:
    sum{s in S} (t[s, m]/3600) * x[s] <= 12*28;

# Budget for raw materials
subject to Budget:
    sum{s in S, k in K} c[k]*a[s, k]*x[s] <= 10000000;

# Warehouse capacity (assuming C[w] is in pairs)
subject to Warehouse_Cap:
    sum{s in S} x[s] <= sum{w in W} C[w];

#Raw Material Quantity
subject to Quantity{k in K}:
	sum{s in S} x[s] * a[s, k] <= u[k];
	
#Demand
subject to Demand{s in S}:
	x[s] <= D[s];
	