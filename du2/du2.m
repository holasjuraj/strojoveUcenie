source('functions.m');

% PODULOHA A
% nacitanie dat
data = csvread('pima-indians-diabetes.data.txt');
% prehodenie predpovedanej hodnoty do prveho stlpca, a zmena z {0,1} na {-1,1}
data = [((data(:, 9) .*2) .-1), data(:, 1:8)];

% nahodny vyber trenovacej a testovacej mnoziny v pomere cca 6:4
[rows, cols] = size(data);
randOrder = randperm(rows);
splitIndex = round(rows * 0.6)

train_data = data(randOrder(1 : splitIndex), 2:end);  % trenovacie atributy
train_label = data(randOrder(1 : splitIndex), 1);     % trenovacie vysledky

test_data = data(randOrder(splitIndex+1 : end), 2:end); % testovacie atributy
test_label = data(randOrder(splitIndex+1 : end), 1);    % testovacie vysledky (pouzite iba na zistovanie uspesnosti)

% PODULOHA B
disp('Linear kernel:');
accL = train_and_test(train_label, train_data, test_label, test_data, 'linear');

disp('Gaussian kernel:');
accG = train_and_test(train_label, train_data, test_label, test_data, 'gaussian');

% PODULOHA C
% zisteneie normalizacnych parametrov
[shift, coef] = normParams(train_data);
% normalizacia
train_data = normalize(train_data, shift, coef);
test_data = normalize(test_data, shift, coef);
% opatovne trenovanie a testovanie
disp('Normalization & linear kernel:');
accNL = train_and_test(train_label, train_data, test_label, test_data, 'linear');

disp('Normalization & gaussian kernel:');
accNG = train_and_test(train_label, train_data, test_label, test_data, 'gaussian');
% porovnanie
printf('Improvement on linear kernel: %f%%\n', (accNL(1) - accL(1)));
printf('Improvement on gaussian kernel: %f%%\n', (accNG(1) - accG(1)));