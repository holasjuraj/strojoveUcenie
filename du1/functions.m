1; % aby to Octave nebral ako function file

function [trainErrs, testErrs] = computeErrors(Ttrain, Ttest, dMax, tOptions)
  trainErrs = [];
  testErrs = [];

  for d = 1:dMax
    tNum = 1;
    for t = tOptions
      % vyber podmnoziny trenovacich prikldov, separacia atributov
      X = Ttrain(1:t, 1:8);
      y = Ttrain(1:t, 9);
      % trenovanie
      tetha = linregd(X, y, d)

      % spocitanie trenovacej chyby na jeden priklad (poduloha c)
      yPredicted = h(X, d, tetha);
      err = ((yPredicted - y)' * (yPredicted - y)) / t;
      trainErrs(d, tNum) = err;

      % spocitanie testovacej chyby na jeden priklad (poduloha d)
      X = Ttest(:, 1:8);
      y = Ttest(:, 9);
      yPredicted = h(X, d, tetha);
      err = ((yPredicted - y)' * (yPredicted - y)) / t;
      testErrs(d, tNum) = err;

      tNum++;
    endfor
  endfor
endfunction

% poduloha b
function tetha = linregd(X, y, d)
  Phi = generatePhi(X, d);
  tetha = (Phi' * Phi) \ (Phi' * y);
endfunction

% poduloha b
function result = h(X, d, tetha)
  Phi = generatePhi(X, d);
  result = Phi * tetha;
endfunction

function Phi = generatePhi(X, d)
  [t, n] = size(X);
  exponents = exponents(d, n);
  Phi = [];
  for i = 1:t
    Phi = [Phi; prodPowerRow(X(i,:), exponents)];
  endfor
endfunction

function result = prodPowerRow(x, exponents)
  x = [1, x];
  [rows, cols] = size(exponents);
  result = [];
  for i = 1:rows
    result = [result, prod(x .^ exponents(i,:))];
  endfor
endfunction

function result = exponents(d, n)
  if n == 0
    result = [d];
    return;
  endif

  result = [];
  for i = 0:d
    nextExps = exponents(d-i, n-1);
    [rows, cols] = size(nextExps);
    result = vertcat(horzcat(ones(rows, 1) * i, nextExps), result);
  endfor
endfunction