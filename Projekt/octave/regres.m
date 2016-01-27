source('functions.m');

% Nastavenie parametrov
dMax = 1;
kMax = 5;
Ttrain = dlmread('../res/train_in.csv', ';');
Ttest = dlmread('../res/test_in.csv', ';');

% Regresia a spocitanie testovacej chyby
for d = 1:dMax
  for expfun = 0:1
    for logfun = 0:1
      % TRENOVANIE
      % Separacia atributov
      X = Ttrain(:, 1:19);
      yMin = Ttrain(:, 20);
      yAvg = Ttrain(:, 21);
      
      % k-fold
      [rows, cols] = size(X);
      randOrder = randperm(rows);
      kSize = rows / kMax;
      tethaMin = [];
      tethaAvg = [];
      errMin = [];
      errAvg = [];
      for k = 1:kMax
        startI = round((k-1)*kSize + 1);
        endI = round(k*kSize);
        trainI = randOrder([1:startI, endI:end]);
        testI = randOrder( startI:endI );
        % k-fold trenovanie
        generateCoefs(X(trainI, :));
        tethaMin = [tethaMin, linreg(X(trainI, :), yMin(trainI, :), d, expfun, logfun)];
        tethaAvg = [tethaAvg, linreg(X(trainI, :), yAvg(trainI, :), d, expfun, logfun)];
        % k-fold testovanie
        yMinPredicted = h(X(testI, :), tethaMin(:, k), d, expfun, logfun);
        yAvgPredicted = h(X(testI, :), tethaAvg(:, k), d, expfun, logfun);
        % Spocitanie chyby
        errMin = [errMin, mean(abs(yMin(testI, :) - yMinPredicted) ./ yMin(testI, :)) * 100];
        errAvg = [errAvg, mean(abs(yAvg(testI, :) - yAvgPredicted) ./ yAvg(testI, :)) * 100];
      endfor
      % Vybratie najlepsej hypotezy
      tethaMin = tethaMin(:, argmin(errMin));
      tethaAvg = tethaAvg(:, argmin(errAvg));

      % % Bez k-fold
      % generateCoefs(X);
      % tethaMin = linreg(X, yMin, d, expfun, logfun);
      % tethaAvg = linreg(X, yAvg, d, expfun, logfun);


      % TESTOVANIE
      % Separacia atributov
      X = Ttest(:, 1:19);
      yMin = Ttest(:, 20);
      yAvg = Ttest(:, 21);

      % Predikcia
      yMinPredicted = h(X, tethaMin, d, expfun, logfun);
      yAvgPredicted = h(X, tethaAvg, d, expfun, logfun);

      % Spocitanie testovacej chyby na jeden priklad
      errMin = mean(abs(yMin - yMinPredicted) ./ yMin) * 100;
      errAvg = mean(abs(yAvg - yAvgPredicted) ./ yAvg) * 100;

      % Vypis
      disp('');
      disp('======== Results: ========');
      d
      expfun
      logfun
      errMin
      errAvg
      disp('==========================');
    endfor
  endfor
endfor