R=QQ[s,t,u,v, Degrees=>{{1,0},{1,0},{0,1},{0,1}}]
S=QQ[X,Y,Z,W]

T=R**S

installPackage "EliminationMatrices"
--installPackage "Depth"


----* bgb      *--------------------
------------------------------------
---- INPUT    ----------------------
---- M = a bigraded module 
------------------------------------
---- OUTPUT   ----------------------
---- Bigraded betti numbers of M
------------------------------------
bgb = (M)->( FR = res M;
      PD = pdim M;
      apply(PD+1, i-> tally(degrees source FR.dd_i))
      )
------------------------------------


----* zcomplex *--------------------
------------------------------------
----  INPUT ----
----  M = ideal that defines the map into projective 3-space.
----      In the notation of the paper this is I_u.
----  a = degree in s,t
----  b = degree in u,v
---- (a,b) is the bidegree of the polynomials 
-------------------------------------
---- OUTPUT -------------------------
---- eqzcpx, this variable contains the power
---- of the implicit equation computed by the function zcomplex.
--------------------------------------
---- DESCRIPTION   --------------------
---- The function zcomplex computed a power of the implicit equation
---- of the map determined by the generators of M. The bidegree of
---- the generators of M is (a,b).
---------------------------------------
---- DOCUMENTATION --------------------
---- cpx is the Koszul complex associated to the generators of the ideal M (i.e I_u)
---- cpx2 is the koszul complex associated to the sequence (X,Y,Z,W)
---- C is the full Z-complex which was computed straight from the koszul
---- complex cpx by taking kernels of the maps
---- C2strand is the approximation complex in which the modules are
---- in the desired degree but the maps are still the ones from the kozxul complex.
---- Cvst. gives the desired matrices in the right bidegree, ignore the modules.
------------------------------------------
zcomplex = (M,a,b)->(
--changeT();
cpx=koszul gens M;
L=apply(5,i->kernel cpx.dd_i);
cpx2=koszul gens ideal(X,Y,Z,W);
C=new ChainComplex;
C#0=L_0;
C#1=L_1;
C#2=L_2;
C#3=L_3;
C#4=L_4;
C.dd#0=cpx2.dd_0;
C.dd#1=cpx2.dd_1;
C.dd#2=cpx2.dd_2;
C.dd#3=cpx2.dd_3;
C.dd#4=cpx2.dd_4;
B=apply(5,i-> super basis({2*a-1+i*a,b-1+i*b},C#i));
C2strand=new ChainComplex;
C2strand#0=B_0;
C2strand#1=B_1;
C2strand#2=B_2;
C2strand#3=B_3;
C2strand#4=B_4;
C2strand.dd#0=cpx2.dd_0;
C2strand.dd#1=cpx2.dd_1;
C2strand.dd#2=cpx2.dd_2;
C2strand.dd#3=cpx2.dd_3;
C2strand.dd#4=cpx2.dd_4;
matmaps=apply(5,i-> C2strand.dd_i*C2strand#i);
rels=apply(5,i-> C.dd_i*B_i);
indmaps=apply(4,i->inducedMap(image(B_i),image(B_(i+1)),C.dd_(i+1)));
mds=apply(4,k->map(T^(numgens target indmaps_k),T^(numgens source indmaps_k),(i,j)->
(indmaps_k)_(i,j)));
Cvst=chainComplex mds;
--D={};
--mns=maxCol(Cvst.dd_1);
--D=D|{mns_0};
--k=numgens source Cvst.dd_1;
--rows=for i from 0 to k-1 list (if not member(i,mns_1) then continue i);
--rows=delete(,rows);
--D=D|{Cvst.dd_2^rows};
--time eqzcpx= (det D_0)/(det D_1); --this line computes the determinant of the complex
)
-----------------------------------------------------------------------------------------


----* kbpts *-------------
--------------------------
---- INPUT ---------------
---- k = number of points
--------------------------
---- OUTPUT---------------
---- I = bigraded ideal of a generic set of k points
----     in P^1xP^1
--------------------------
---- DESCRIPTION ---------
---- This code randomly chooses k generic points in P^1xP^1
---- and computes the ideal determined
---- by these points
--------------------------
---- DOCUMENTATION -------
--------------------------

kbpts=(k)->(
i=0;
lst={};
while i<k
do(
M=random((ZZ/11)^1,(ZZ/11)^2);
M=sub(M,R);
forms=matrix{{s},{t}};
Lp=M*forms;
M=random((ZZ/11)^1,(ZZ/11)^2);
M=sub(M,R);
forms=matrix{{u},{v}};
Lq=M*forms;
testo=ideal(Lp,Lq);
lst=lst|{testo};
i=i+1;
);
I=lst_0;
j=1;
while j<k
do(
I=intersect(I,lst_j);
j=j+1;
);
return I;
)
-----------------------------------------------------------

----* gexample *---------------------------------------
----  INPUT     -----------
---- a,b = integers that correspond to a bidegree (a,b)
---- r   = number of basepoints
----  OUTPUT    -----
---- Ju  = <f0,f1,f2,f3>  an ideal generated by elements
----       of bidegree (a,b)
-----------------------------------------------------------
---- DESCRIPTION ------------------------------------------
---- This function creates a generic 4-dimensional vector space of bidegree (a,b)
---- of forms that vanish at a generic set of r points.
gexample=(a,b,r)->(
    J=kbpts(r);
    B=super basis({a,b},J);
    n=rank source B;
    C=random(R^n,R^4);
    Ju= ideal(B*C);
    return Ju;
    )
------------------------------------------------------


----* blockv *----------------------------------------
------------------------------------------------------
---- INPUT       -------------------------------------
---- V = column vector
---- i= number of times to translate V diagonally to form an 
----    almost diagonal matrix
-------------------------------------------------------
---- OUTPUT      --------------------------------------
---- blockv = almost diagonal block matrix
-------------------------------------------------------
---- DESCRIPTION -------------------
---- This code  builds a block matrix out of
---- a column vector by translating diagonally the vector
---- and adding zeros to the other entries
------------------------------------------------------
---- DOCUMENTATION -----------------------------------
---- This function is used to compute the almost diagonal
---- block matrices VW_i that show up in the proof of
---- the description of the syzygies of the ideal
--------------------------------------------------------

blockV=(V,i)->(
    j=1;
    zerom=matrix{{0}};
    blockv=V;
    nextcolumn=matrix{{0}};
    while j<i do(
	blockv=blockv||zerom;
	nextcolumn=transpose(zerom)||V;
	blockv=blockv|nextcolumn;
	zerom=zerom|matrix{{0}};
	j=j+1;
	);
    return blockv;
    )
----------------------------------------

----* VW1   *----- for the case deg Q_i=deg P_i=j
---------------------------------------------------
---- INPUT  ---------------------------------------
---- i = number of blocks in the VW matrix 
---- A = coefficients of the generic forms Q_i
---- B = coefficients of the generic forms P_i
------------------------------------------------------
---- OUTPUT ---------------------------------------
---- VW1 = VW_i matrixes associated to the coeffient
---- matrices A,B.
---------------------------------------------------------
----  This function is used to compute the almost diagonal
----  block matrices VW_i that show up in the proof of
----  the description of the syzygies of the ideal.

VW1=(i,A,B)->(
    --A=random(R^(j+1),R^4);
    V=blockV(A_{0},i+1);
    V=V|blockV(A_{1},i+1);
    V=V|blockV(A_{2},i+1);
    V=V|blockV(A_{3},i+1);
   -- B=random(R^(j+1),R^4);
    W=blockV(B_{0},i+1);
    W=W|blockV(B_{1},i+1);
    W=W|blockV(B_{2},i+1);
    W=W|blockV(B_{3},i+1);
    return V||W;
    )

---------------------------------------------

----* VW2 *----- for the case deg Q_i=j+1 and deg P_i=j
---------------------------------------------------
---- INPUT  ---------------------------------------
---- i = number of blocks in the VW matrix 
---- A = coefficients of the generic forms Q_i
---- B = coefficients of the generic forms P_i
------------------------------------------------------
---- OUTPUT ---------------------------------------
---- VW1 = VW_i matrixes associated to the coeffient
---- matrices A,B.
---------------------------------------------------------
----  This function is used to compute the almost diagonal
----  block matrices VW_i that show up in the proof of
----  the description of the syzygies of the ideal.---- This is some code that makes up a VW matrix like the one
---- that shows up in my proof.
VW2=(i,A,B)->(
   -- A=random(R^(j+2),R^4);
    V=blockV(A_{0},i+1);
    V=V|blockV(A_{1},i+1);
    V=V|blockV(A_{2},i+1);
    V=V|blockV(A_{3},i+1);
   -- B=random(R^(j+1),R^4);
    W=blockV(B_{0},i+1);
    W=W|blockV(B_{1},i+1);
    W=W|blockV(B_{2},i+1);
    W=W|blockV(B_{3},i+1);
    return V||W;
    )

----------------------------------------------


----* QPextract *-----------------------------
----------------------------------------------
---- INPUT  ----------------------------------
---- G  = basis of forms of degree (a,1) that vanish at a set
----      of r points. 
---- Iu = generic 4-dimensional vector subspace of G
----  r = number of basepoints
----  i = number of blocks in the VW_i matrix
----  a = degree in (s,t)
------------------------------------------------
---- OUTPUT -----------------------------------
-----------------------------------------------
---- VW1 = VW_i matrix in terms of the coefficient matrices A,B.
---------------------------------------------------------------
----  DESCRIPTION  ----------------------------
----  With is code we extract the QP matrix associated
----  to an ideal I_u, Q,P are these matrices and we can 
----  use them to create the QP matrix and see the kernel.
------------------------------------------------------
QPextract=(Iu,G,a,r,i)->(
   -- Iu= gexample(a,b,r);
    k=r//2;
  --  G=super basis({k,1},J);
    F=transpose gens Iu;
    col1QP=(gens(kernel(F^{0}|G)))_{1}^{1,2};
    col2QP=(gens(kernel(F^{1}|G)))_{1}^{1,2};
    col3QP=(gens(kernel(F^{2}|G)))_{1}^{1,2};
    col4QP=(gens(kernel(F^{3}|G)))_{1}^{1,2};
    QP=col1QP|col2QP|col3QP|col4QP;
    Q=QP^{0};
    P=QP^{1};
    basisforms= super basis({a-k,0},R);
    A=contract(transpose Q,basisforms);
    B=contract(transpose P,basisforms);
    return VW1(i,transpose(A),transpose(B));-- the VW1 here means I'm looking at the case r=even.
)
-----------------------------------------------------------

----* bhfq *--------------------------------------
--------------------------------------------------
---- INPUT ---------------------------------------
--------------------------------------------------
---- i,j = a bidegree.
----       the bigraded Hilbert function.
----   I = bigraded ideal.
---------------------------------------------------
----  OUTPUT --------------------------------------
---- H(i,j,I) = Value of the bigraded Hilbert function
----            of I at (i,j).
---------------------------------------------------
bhfq=(i,j,I)->(
          M=super basis({i,j},I);
          N=super basis({i,j},R);
          m=numgens source M;
          n=numgens source N;
          hfq=n-m;
          return hfq;
)
----------------------------------------------------


----* bmatrix  *--------------------------------------
--------------------------------------------------
---- INPUT ---------------------------------------
--------------------------------------------------
---- i,j = a range of bidegrees to compute the Hilbert function.
----   I = bigraded ideal.
---------------------------------------------------
----  OUTPUT --------------------------------------
---- hmat  = matrix of the values of H(i,j,I)
---------------------------------------------------
bmatrix=(i,j,I)->(
             k    = 0;
             hmat = {};
             while k<i
                do(
                  rows=for q from 0 to j list bhfq(k,q,I);
                  hmat=hmat|{rows};
                  k=k+1;
                   );
          return matrix hmat;
      )
----------------------------------------------------