springer(N, X, Y) :-
	MaxZuege is N * N,
	length(L, MaxZuege),
	springer(N, 0, MaxZuege, X, Y, L),
	display(N, 0, L).

springer(AnzSpal, AktZug, MaxZuege, Zeile, Spalte, SchachbrettListe) :-

	Zeile >= 0, Zeile < AnzSpal, Spalte >= 0,  Spalte < AnzSpal,

	Pos is Zeile * AnzSpal + Spalte,
	AktZugNeu is AktZug+1,

	nth0(Pos, SchachbrettListe, AktZugNeu),

	ZeileM1 is Zeile - 1, ZeileM2 is Zeile - 2, ZeileP1 is Zeile + 1, ZeileP2 is Zeile + 2,
	SpalteM1 is Spalte - 1, SpalteM2 is Spalte - 2, SpalteP1 is Spalte + 1, SpalteP2 is Spalte + 2,
	maplist(bester_zug(AnzSpal, SchachbrettListe),
		[(ZeileP1, SpalteM2), (ZeileP2, SpalteM1), (ZeileP2, SpalteP1),(ZeileP1, SpalteP2),
		 (ZeileM1, SpalteM2), (ZeileM2, SpalteM1), (ZeileM2, SpalteP1),(ZeileM1, SpalteP2)],
		R),

	sort(R, RS),
	pairs_values(RS, ZugAusgefuehrt),

	move(AnzSpal, AktZugNeu, MaxZuege, ZugAusgefuehrt, SchachbrettListe).

springer(_, Max, Max, _, _, _) :- !.


move(AnzSpal, AktZugNeu, MaxZuege, [(Zeile, Spalte) | R], SchachbrettListe) :-
	springer(AnzSpal, AktZugNeu, MaxZuege, Zeile, Spalte, SchachbrettListe);
	move(AnzSpal, AktZugNeu, MaxZuege,  R, SchachbrettListe).


bester_zug(AnzSpal, _L, (Zeile, Spalte), 1000-(Zeile, Spalte)) :-
	(   Zeile < 0; Zeile >= AnzSpal; Spalte < 0;  Spalte >= AnzSpal), !.

bester_zug(AnzSpal, SchachbrettListe, (Zeile, Spalte), 1000-(Zeile, Spalte)) :-
	Pos is Zeile*AnzSpal+Spalte,
	nth0(Pos, SchachbrettListe, V),
	\+var(V), !.

bester_zug(AnzSpal, SchachbrettListe, (Zeile, Spalte), R-(Zeile, Spalte)) :-
	ZeileM1 is Zeile - 1, ZeileM2 is Zeile - 2, ZeileP1 is Zeile + 1, ZeileP2 is Zeile + 2,
	SpalteM1 is Spalte - 1, SpalteM2 is Spalte - 2, SpalteP1 is Spalte + 1, SpalteP2 is Spalte + 2,


	include(moeglicher_zug(AnzSpal, SchachbrettListe),
		[(ZeileP1, SpalteM2), (ZeileP2, SpalteM1), (ZeileP2, SpalteP1),(ZeileP1, SpalteP2),
		 (ZeileM1, SpalteM2), (ZeileM2, SpalteM1), (ZeileM2, SpalteP1),(ZeileM1, SpalteP2)],
		Res),

	length(Res, Len),

	(   Len = 0 -> R = 1000; R = Len).


moeglicher_zug(AnzSpal, SchachbrettListe, (Zeile, Spalte)) :-

	Zeile >= 0 , Zeile < AnzSpal, Spalte >= 0,  Spalte < AnzSpal,

	Pos is Zeile * AnzSpal + Spalte,

	nth0(Pos, SchachbrettListe, V),
	var(V).


display(_, _, []).

display(N, N, L) :-
	nl,
	display(N, 0, L).

display(N, M, [H | T]) :-
	writef('%3r', [H]),
	M1 is M + 1,
	display(N, M1, T).
