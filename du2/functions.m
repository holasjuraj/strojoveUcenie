1;

% PODULOHA B
function accuracy = train_and_test(train_label, train_data, test_label, test_data, kernel)
  opts = '-q';   % default kernel = gaussian
  if strcmp(kernel, 'linear')
    opts = '-t 0 -q';
  endif

  % trenovanie
  model = svmtrain(train_label, train_data, opts);
  % testovanie
  [predict_label, accuracy, dec_values] = svmpredict(test_label, test_data, model);
endfunction

% PODULOHA C
function [shift, coef] = normParams(X)
  shift = []; coef = [];
  [rows, cols] = size(X);

  for i = (1:cols)
    col = X(:, i);
    % kazdy atribut sa ma posunut (zmensit) o priemer hodnot daneho atributu
    shift = [shift; sum(col) / rows];
    % kazdy atribut sa zoskaluje (predeli) podla st. odchylky hodnot daneho atributu
    coef = [coef; std(col)];
  endfor
endfunction

function result = normalize(X, shift, coef)
  result = [];
  [rows, cols] = size(X);

  for i = (1:cols)
    col = X(:, i);
    col = (col .- shift(i)) ./ coef(i);
    result = [result, col];
  endfor
endfunction