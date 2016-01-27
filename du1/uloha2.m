source('functions.m');
% nastavenie parametrov
d = 3;
data = dlmread('Concrete_Data.csv', ';');
% vybratie trenovacej a testovacej mnoziny (poduloha a)
[rows, cols] = size(data);
randOrder = randperm(rows);
Ttrain = data(randOrder(1:800), :);
Ttest = data(randOrder(801:end), :);
% spocitanie trenovacej a testovacej chyby
[trainErrs, testErrs] = computeErrors(Ttrain, Ttest, d, 100:100:800);
% vykreslenie grafov (poduloha c, d)
surf(trainErrs);
view(130, 30);
xlabel('*100 = |T|'); ylabel('d'); zlabel('chyba (lin. mierka)');
print -dpng trainErrs.png;

surf(testErrs);
set(gca, 'zscale', 'log');
view(130, 30);
xlabel('*100 = |T|'); ylabel('d'); zlabel('chyba (log. mierka)');
print -dpng testErrs.png;
% vypisanie (poduloha c, d)
format bank;
trainErrs = [(0:d)', [100:100:800; trainErrs]]
testErrs = [(0:d)', [100:100:800; testErrs]]