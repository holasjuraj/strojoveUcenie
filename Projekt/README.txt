========== ODHADOVANIE CIEN MOBILNYCH TELEFONOV ==========
Projekt - Strojove ucenie (2-INF-150)
Juraj Holas
10.2.2015

===== Projekt =====
Pisomnu cast projektu najdete v doc/Projekt.pdf .

===== Java program =====
Program v Jave sa pouziva na predspracovanie dat. Jeho zdrojove subory su v
priecinku src/ , skompilovane .class subory v bin/ . Program bol vyvyjany v
prostredi Eclipse, pokial sa importuje do tohto prostredia tak staci spustit
hlavnu triedu MergeTables, a program vykona vsetko co ma.
Pokial chcete, mozete zdrojove subory rekompilovat klasicky pomocou:
> javac MergeTables.java
Nasledne spustit pomocou:
> java MergeTables
Pri takomto priamom spustani je vsak potrebne presunut/skopirovat priecinok
res/ do aktualneho priecinka, odkial sa program spusta (prip. upravit cesty ku
vstupnym suborom v zdrojovom kode).

===== Octave program =====
Skript v Octave pocita samotnu lin. regresiu a uspesnost celeho algorimu. Jeho
zdrojove subory su v octave/ . Po spusteni Octave v tomto priecinku sa cely
vypocet inicializuje jednoducho prikazom "regres". Hned na zaciatku zdrojoveho
kodu je mozne upravit zakladne parametre: maximalny stupen polynomialneho
rozvoja (dMax), stupen k-fold testovania (kMax), a cesty ku vstupnym suborom
(vystupy z predspracovania Java programom).

===== Datove subory =====
Vsetky datove subory su v priecinku res/ :
- data.xlsx = vsetky vstupne data v Exceli
- data_[ceny|parametre|top].csv = data z Excelu ulozene v .csv, ako oddelovac
  je pouzita ";".
- [test|train]_in.csv = vystup po predspracovani, vstup do regresneho algoritmu
  v Octave
- [test|train]_in_noscale.csv = starsia verzia predspracovanych dat, bez
  skalovania technickych parametrov
- results.txt = suhrn vysledkov zo vsetkych testovani
- results.xlsx = prehladnejsi suhrn vysledkov zo vsetkych testovani, grafy