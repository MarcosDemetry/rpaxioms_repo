clear

input A B C D E F G H I J
8 2 1 6 9   27 22 29 28 43
4 4 5 6 5   44 33 38 27 37
6 6 9 8 2   22 25 48 27 43
6 5 7 1 5   32 20 48 24 40
2 1 6 7 4   20 49 38 49 23
6 3 9 6 5   26 33 30 49 35
7 9 1 2 9   20 49 46 45 30
5 1 10 10 5 25 43 33 42 22
9 9 2 6 4   24 20 48 25 24
8 1 6 5 4   28 41 21 31 26
4 7 2 10 2  25 41 36 25 40
5 6 6 7 3   24 39 42 20 33
4 3 1 5 1   38 37 25 29 41
8 6 8 9 5   47 26 30 41 27
8 2 9 6 3   49 43 25 39 20    
5 7 10 6 3  26 27 29 36 36
7 6 10 7 5    34 31 32 33 28
10 1 6 4 2    31 47 37 28 49    
8 1 3 3 5    36 46 21 35 48
8 2 2 6 8   28 32 37 43 32
end

mkmat A B C D E, matrix(P)
mkmat F G H I J, matrix(X)


* Checkax
checkax, price(P) quantity(X)
return list

checkax, price(P) quantity(X) ax(eGARP eHARP) eff(0.95)


* aei
aei, price(P) quantity(X)
return list

aei, price(P) quantity(X) axiom(eWGARP eCM) tol(6)

* powerps
powerps, price(P) quantity(X)
return list

powerps, price(P) quantity(X) axiom(eWARP eSARP) aei sim(2000) tol(6) progress

