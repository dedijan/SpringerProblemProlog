% Lösen des Springerproblems mit N Zeilen/Spalten und X
% und Y als Startkoordinaten(Quadratisches Brett)
springer(N, X, Y) :-
	MaxZuege is N * N,
	length(L, MaxZuege),
	springer(N, 0, MaxZuege, X, Y, L),
	display(N, 0, L).

% springer(AnzSpal, AktZug, MaxZuege, Zeile, Spalte, SchachbrettListe),
% AnzSpal         : Anzahl der Spalten pro Zeile
% AktZug          : Aktueller Zug
% MaxZuege        : Maximale Anzahl an Zügen
% Zeile/Spalte    : Aktuelle Position des Springers
% SchachbrettListe: Liste mit allen Positionen des Schachbrettes

% Suche nach neuen Positionen bzw. Zuegen
springer(AnzSpal, AktZug, MaxZuege, Zeile, Spalte, SchachbrettListe) :-

	% Prüfen, ob die Position noch auf dem Feld ist
	Zeile >= 0, Zeile < AnzSpal, Spalte >= 0,  Spalte < AnzSpal,

	% Berechnung der eindimensionalen Position und Erhöhung des Zugzählers
	Pos is Zeile * AnzSpal + Spalte,
	AktZugNeu is AktZug+1,

	% Prüfen, ob der Platz frei ist
	nth0(Pos, SchachbrettListe, AktZugNeu),

	% Ermittlung möglicher neuer Positionen, speichern in Liste R
	ZeileM1 is Zeile - 1, ZeileM2 is Zeile - 2, ZeileP1 is Zeile + 1, ZeileP2 is Zeile + 2,
	SpalteM1 is Spalte - 1, SpalteM2 is Spalte - 2, SpalteP1 is Spalte + 1, SpalteP2 is Spalte + 2,
	maplist(bester_zug(AnzSpal, SchachbrettListe),
		[(ZeileP1, SpalteM2), (ZeileP2, SpalteM1), (ZeileP2, SpalteP1),(ZeileP1, SpalteP2),
		 (ZeileM1, SpalteM2), (ZeileM2, SpalteM1), (ZeileM2, SpalteP1),(ZeileM1, SpalteP2)],
		R),

	% Sortiert die Liste R aufsteigend. Ausgegeben wird die sortierte Liste RS
	sort(R, RS),

	% Entfernen von Keys von Key-Value Pairs und Erstellung neuer Liste
	% ZugAusgefuehrt
	pairs_values(RS, ZugAusgefuehrt),

	% Springerzug ausfuehren
	move(AnzSpal, AktZugNeu, MaxZuege, ZugAusgefuehrt, SchachbrettListe).

% Das Spiel ist vorbei, wenn AktZug = MaxZuege
springer(_, Max, Max, _, _, _) :- !.


% Ausführen des Zuges und weiterer Zuege
move(AnzSpal, AktZugNeu, MaxZuege, [(Zeile, Spalte) | R], SchachbrettListe) :-
	springer(AnzSpal, AktZugNeu, MaxZuege, Zeile, Spalte, SchachbrettListe);
	move(AnzSpal, AktZugNeu, MaxZuege,  R, SchachbrettListe).


% Ein invalider(ausserhalb des Feldes) Zug wird mit 1000 bewertet
bester_zug(AnzSpal, _L, (Zeile, Spalte), 1000-(Zeile, Spalte)) :-
	(   Zeile < 0; Zeile >= AnzSpal; Spalte < 0;  Spalte >= AnzSpal), !.

% Ein invalider(schon belegt) Zug wird mit 1000 bewertet
bester_zug(AnzSpal, SchachbrettListe, (Zeile, Spalte), 1000-(Zeile, Spalte)) :-
	Pos is Zeile*AnzSpal+Spalte,
	nth0(Pos, SchachbrettListe, V),
	\+var(V), !.

% Ein valider Zug wird mit der Anzahl der moeglichen Zuege bewertet
bester_zug(AnzSpal, SchachbrettListe, (Zeile, Spalte), R-(Zeile, Spalte)) :-
	ZeileM1 is Zeile - 1, ZeileM2 is Zeile - 2, ZeileP1 is Zeile + 1, ZeileP2 is Zeile + 2,
	SpalteM1 is Spalte - 1, SpalteM2 is Spalte - 2, SpalteP1 is Spalte + 1, SpalteP2 is Spalte + 2,

	% Bildet Key-Value Pairs, wobei der Key die Anzahl der
	% moeglichen Folgezuege ist und der Value die Position
	include(moeglicher_zug(AnzSpal, SchachbrettListe),
		[(ZeileP1, SpalteM2), (ZeileP2, SpalteM1), (ZeileP2, SpalteP1),(ZeileP1, SpalteP2),
		 (ZeileM1, SpalteM2), (ZeileM2, SpalteM1), (ZeileM2, SpalteP1),(ZeileM1, SpalteP2)],
		Res),

	% Ermittlung der Länger der Liste und speichern in
	% der Variablen Len
	length(Res, Len),

	% If Bedingung: wenn die Liste keine Elemente hat, wird der
	% Zug mit 1000 bewertet, andernfalls wird der Zug mit der
	% möglichen Anzahl der Folgezuege bewertet
	(   Len = 0 -> R = 1000; R = Len).


% Prueft, ob der Zug valide ist
moeglicher_zug(AnzSpal, SchachbrettListe, (Zeile, Spalte)) :-
	% Position muss auf dem Schachbrett liegen
	Zeile >= 0 , Zeile < AnzSpal, Spalte >= 0,  Spalte < AnzSpal,

	% Berechnung der Position
	Pos is Zeile * AnzSpal + Spalte,

	% Prueft, ob die Position auf dem Schachbrett in der Liste schon
	% belegt ist
	nth0(Pos, SchachbrettListe, V),
	var(V).


% Wenn die Liste leer ist, Ausgabe beenden
display(_, _, []).

% Start einer neuen Liste
display(N, N, L) :-
	nl,
	display(N, 0, L).

% Head der Liste ausgeben und erneute Aufrufe fuer
% den Tail der Liste
display(N, M, [H | T]) :-
	writef('%3r', [H]),
	M1 is M + 1,
	display(N, M1, T).
