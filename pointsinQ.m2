use R

-- This code was used to check the examples in the paper for the
-- sets of generic points in PP^1xPP^1
--- These are the horizontal lines
h1=s
h2=t
h3=s-t
h4=s+t

-- These are teh vertical lines
l1=u
l2=v
l3=u-v
l4=u+v

l5=u-3*v
l6=u+3*v

H1=ideal(h1,l1)
H2=ideal(h2,l2)
H3=ideal(h3,l3)
H4=ideal(h4,l4)

Ixx=intersect(H1,H2,H3,H4)
M1=bmatrix(5,5,Ixx)
M2=bmatrix(5,7,Ixx)

h1=s
h2=t
h3=s-3*t
h4=s+t

-- These are teh vertical lines
l1=u
l2=v
l3=u-v
l4=u+5*v

H1=ideal(h1,l1)
H2=ideal(h2,l2)
H3=ideal(h3,l3)
H4=ideal(h4,l4)

Ix=intersect(H1,H2,H3,H4)
M2=bmatrix(5,5,Ix)
