
-- List of functions
-- bgb
-- zcomplex
-- kbpts
-- gexample
-- blockv
-- VW1
-- VW2
-- QPextract
-- bhfq
-- bmatrix
--




--- INSTRUCTIONS -----------
--- load the functions.m2 file
load "functions.m2"
use R -- this makes sure computations are done in the correct ring.
-----------------------------


--- EXAMPLES -------------------------
--------------------------------------

----* Example 1 *---------------------
---- Ix is the ideal of 2 generic points
R=QQ[s,t,u,v, Degrees=>{{1,0},{1,0},{0,1},{0,1}}]
S=QQ[X,Y,Z,W]
T=R**S
use R
Ix=intersect(ideal(s,u),ideal(t,v))
---- the code below computes the Hilbert function
---- of the ideal Ix
bmatrix(5,5,Ix)
---- we may look at the basis elements that generate
---- Ix in bidegree (3,1)
B=super basis({3,1},Ix)
---- Then we choose a generic 4-dimension vector
---- subspace of Ix in bidegree (3,1)
C=matrix{{1,0,0,0,-1,1},{0,1,0,0,1,1},{0,0,1,0,1,-3},{0,0,0,1,-5,1}}
C=matrix{{1,0,0,0,0,1},{0,0,0,1,0,1},{0,0,1,1,0,0},{0,1,1,1,0,0}}
C=substitute(C,R)
use R
Iu = ideal(C*transpose(B))
gens minors(4,C)
---- all of the minors of C are nonzero so we are
---- in the hypotheses of the theorem
---- In the next four lines we compute the implicit equation
---- we need to change the ring in which we are working on.
use T
Iu=substitute(Iu,T)
time zcomplex(Iu,3,1)
eqzcpx
-----------------
Cvst.dd -- this is the Z-complex in bidegree (3,1)
----------------
---- We can also check the bidegrees of all the syzygies
---- of ideal.
bgb coker gens Iu
------------------------------------------------------------
----------------- END OF EXAMPLE 1  ------------------------
------------------------------------------------------------


---* Example 2 *--------------------------------------------
---- Ix is the ideal of 2 generic points
use R
Ix=intersect(ideal(s,u),ideal(t,v))
---- the code below computes the Hilbert function
---- of the ideal Ix
bmatrix(5,5,Ix)
---- we may look at the basis elements that generate
---- Ix in bidegree (3,1)
B=super basis({3,1},Ix)
---- Then we choose a generic 4-dimension vector
---- subspace of Ix in bidegree (3,1)
C=matrix{{1_R,1,0,0,0,0},{0,1,1,0,0,0},{0,0,1,1,0,0},{0,0,0,1,1,1}}
C=substitute(C,R)
Iu = ideal(C*transpose(B))
gens minors(4,C)
---- all of the minors of C are nonzero so we are
---- in the hypotheses of the theorem
---- In the next four lines we compute the implicit equation
---- we need to change the ring in which we are working on.
use T
toT = map(T,R)
toT(Iu)
Iu=substitute(Iu,T)
zcomplex(Iu,3,1)
eqzcpx
eqzcpx
-----------------
Cvst.dd -- this is the Z-complex in bidegree (3,1)
----------------
---- We can also check the bidegrees of all the syzygies
---- of ideal.
bgb coker gens Iu
-------------------------------------------------------------
------------------------------------------------------------
----------------- END OF EXAMPLE 2  ------------------------
------------------------------------------------------------


A = CC[gens R]
F = flatten entries sub(gens Iu, A)
I = ideal 0_A
numericalImageDim(F,I)
W = numericalImageDegree(F,I)
peek W
numericalHilbertFunction(F,I,10)
numericalImageSample(F,I,100)
p = numericalImageSample(F,I)
isOnImage(W,p)

-----------
use R
Iu=blin(4,1)
time grobnerb(Iu)
Iu=substitute(Iu,T)
time zcomplex(Iu,4,1)
Iu=substitute(Iu,R)
time optimus(Iu,4,1)
---


---* Example 3 *---------------------------------------------
restart
use R
Iu  = gexample(3,1,4)
--bgb coker gens Iu
use T
Iu = substitute(Iu,T)
time zcomplex(Iu,3,1)
eqzcpx
use T
eqzcpx=substitute(eqzcpx,T)
Cvst.dd_1
Cvst.dd_2
radical ideal(eqzcpx)
J=ideal(jacobian ideal(eqzcpx))
I=ideal(eqzcpx)+J
associatedPrimes I
------------------------------------------------------------
----------------- END OF EXAMPLE 3  ------------------------
------------------------------------------------------------

---* Example 4 *---------------------------------------------
use R
Iu  = gexample(9,1,4)
bgb coker gens Iu
use T
Iu = substitute(Iu,T)
time zcomplex(Iu,9,1)
eqzcpx
use T
eqzcpx=substitute(eqzcpx,T)
Cvst.dd_1
Cvst.dd_2
radical ideal(eqzcpx)
J=ideal(jacobian ideal(eqzcpx))
I=ideal(eqzcpx)+J
associatedPrimes I
------------------------------------------------------------
----------------- END OF EXAMPLE 4  ------------------------
------------------------------------------------------------


---* Example 5 *---------------------------------------------
---- Ix is the ideal of 2 generic points
use R
Ix=kbpts(4)
---- the code below computes the Hilbert function
---- of the ideal Ix
bmatrix(5,5,Ix)
---- we may look at the basis elements that generate
---- Ix in bidegree (3,1)
B=super basis({3,1},Ix)
---- Then we choose a generic 4-dimension vector
---- subspace of Ix in bidegree (3,1), but the dimension of B is 4
---- so we may just choose B
Iu = ideal(B)
---- so we are
---- in the hypotheses of the theorem
---- In the next four lines we compute the implicit equation
---- we need to change the ring in which we are working on.
use T
Iu=substitute(Iu,T)
time zcomplex(Iu,3,1)
eqzcpx
--
Cvst.dd -- this is the Z-complex in bidegree (3,1)
----------------
---- We can also check the bidegrees of all the syzygies
---- of ideal.
use R
Iu=substitute(Iu,R)
syz gens Iu
bgb coker gens Iu
------------------------------------------------------------
----------------- END OF EXAMPLE 5  ------------------------
------------------------------------------------------------

