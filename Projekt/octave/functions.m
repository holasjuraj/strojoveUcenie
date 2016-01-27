1; % Aby to Octave nebral ako function file

% Parametre pre skalovanie pre exp. a log. funkcie
global selectionExp = [4:6, 8, 10:12, 18, 19];
global selectionLog = [7, 9:13, 15:16];
global coefExp = [];
global coefLog = [];

% Generovanie skalovacich parametrov
function generateCoefs(X)
  global selectionExp;
  global selectionLog;
  global coefExp;
  global coefLog;
  coefExp = [];
  coefLog = [];

  % Kazdy atribut sa predeli o priemer hodnot daneho atributu
  for i = selectionExp
    col = X(:, i);
    coefExp = [coefExp, mean(col)];
  endfor
  for i = selectionLog
    col = X(:, i);
    coefLog = [coefLog, mean(col)];
  endfor
endfunction

% Generalizovana linearna regresia
function tetha = linreg(X, y, d, expfun, logfun)
  Phi = generatePhi(X, d, expfun, logfun);
  tetha = (Phi' * Phi) \ (Phi' * y);
endfunction

% Hypoteza
function result = h(X, tetha, d, expfun, logfun)
  Phi = generatePhi(X, d, expfun, logfun);
  result = Phi * tetha;
endfunction

% Rozvoj bazovymi funkciami
function Phi = generatePhi(X, d, expfun, logfun)
  global selectionExp;
  global selectionLog;
  global coefExp;
  global coefLog;

  [t, n] = size(X);
  exponents = exponents(d, n);
  Phi = [];
  % Mocniny
  for i = 1:t
    Phi = [Phi; prodPowerRow(X(i,:), exponents)];
  endfor

  % Exponencialna
  if expfun == 1
    % % Bez skalovania
    % selected = [4:6, 8, 10:12, 18, 19];
    % Phi = [Phi, pow2(X(:, selected))];
    % % Manualne skalovanie
    % Phi = [Phi, pow2( X(:, 4) ./ 9320.872609 )];
    % Phi = [Phi, pow2( X(:, 5) ./ 9.02173913 )];
    % Phi = [Phi, pow2( X(:, 6) ./ 137.3043478 )];
    % Phi = [Phi, pow2( X(:, 8) ./ 4.74 )];
    % Phi = [Phi, pow2( X(:, 10) ./ 1.77826087 )];
    % Phi = [Phi, pow2( X(:, 11) ./ 3.434782609 )];
    % Phi = [Phi, pow2( X(:, 12) ./ 1.576086957 )];
    % Phi = [Phi, pow2( X(:, 18) ./ 2351.73913 )];
    % Phi = [Phi, pow2( X(:, 19) ./ 62.95695652 )];
    % Automaticke skalovanie
    Phi = [Phi, pow2( X(:, selectionExp) ./ repmat(coefExp, t, 1) )];
  endif

  % Logaritmus
  if logfun == 1
    % % Bez skalovania
    % selected = [7, 9:13, 15:16];
    % Phi = [Phi, log2(X(:, selected))];
    % % Manualne skalovanie
    % Phi = [Phi, log2( X(:, 7) ./ 1402.956522 )];
    % Phi = [Phi, log2( X(:, 9) ./ 332.4347826 )];
    % Phi = [Phi, log2( X(:, 10) ./ 1.77826087 )];
    % Phi = [Phi, log2( X(:, 11) ./ 3.434782609 )];
    % Phi = [Phi, log2( X(:, 12) ./ 1.576086957 )];
    % Phi = [Phi, log2( X(:, 13) ./ 13.73913043 )];
    % Phi = [Phi, log2( X(:, 15) ./ 10.34565217 )];
    % Phi = [Phi, log2( X(:, 16) ./ 1226.086957 )];
    % Automaticke skalovanie
    Phi = [Phi, log2( X(:, selectionLog) ./ repmat(coefLog, t, 1) )];
  endif
endfunction

% Umocnenie jedneho riadka matice
function result = prodPowerRow(x, exponents)
  x = [1, x];
  [rows, cols] = size(exponents);
  result = [];
  for i = 1:rows
    result = [result, prod(x .^ exponents(i,:))];
  endfor
endfunction

% Pocitanie exponentov
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

% Funkcia prebrana z https://code.google.com/p/pmtk3/source/browse/trunk/util/argmin.m?spec=svn35&r=35
% v sulade s licenciou MIT License: http://opensource.org/licenses/mit-license.php
function indices = argmin(v)
  [m i] = min(v(:));
  if isvector(v)
    indices = i;
  else
    indices = ind2subv(sizePMTK(v), i);
  endif
endfunction