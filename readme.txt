23 giugno 2023

Per compilare il primo esercizio fare "make" o "make first" nel terminale.
Per compilare il secondo esercizio fare "make second" nel terminale.
Lanciare "./a.out" per vedere l'esecuzione.

N.B non è presente la sottrazione degli insiemi.
    So che non è proprio corretto ma gli insiemi vuoti (quelli non inizializzati) hanno solo 0 come elemento al loro interno

Per il primo esercizio si possono eseguire i seguenti comandi:

1.AGGIUNGERE UN INSIEME : X = sB 
    dove X sta per una lettera in maiuscolo tra A e Z
    dove B sta per un numero binario massimo 32 bit e minimo 1 bit
    esempio1 -> A = s1001 (corretto)
    NON aggiungere uno spazio tra s e B
    esempio2 -> A = s 1001 (sbagliato, darà syntax error)

2.AGGIUNGER UN INDICE AD UN INSIEME : add iI to sX
    dove I sta per un' indice che va da 0 a 31
    dove X sta per una lettera in maiuscolo tra A e Z
    esempio -> add i1 to sA = s1011

3.OPERAZIONE DI UNIONE: X u Y
    dove X e Y stanno per lettere maiuscole oppure degli insiemi
    esempio1 -> A u B
    esempio2 -> A u s11010 (commutativa)

4.OPERAZIONE DI INTERSEZIONE: X r Y
    dove X e Y stanno per lettere maiuscole oppure degli insiemi
    esempio1 -> A r B
    esempio2 -> s11010 r B (commutativa)

5.OPERAZIONE DI NEGAZIONE: nX
    dove X sta per una lettera in maiuscolo tra A e Z
    esempio1 -> A = s1001, nA = 0110

6.Come da traccia le istruzioni elencate sopra possono essere concatenate dando vita ad espressioni
usando le parentesi. Se nell'espressione ci sono insiemi non inizializzati il programma li tratta come insiemi vuoti
    esempio1 ->(A u B) u (B r A)
    esempio2 ->(add i3 to sA) u nB u (C r D)

Per il secondo esercizio si possono scrivere le espressioni come nel primo esercizio

E.M.