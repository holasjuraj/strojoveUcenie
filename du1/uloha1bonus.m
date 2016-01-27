errL1prem = 0;
errL2prem = 0;
errL1demo = 0;
errL2demo = 0;
maxIter = 1000;                    % 1000 interacii

for i = 1:maxIter
	% priprava trenovania
	n = floor(1 + rand(1)*19);     % pocet atributov 1..20
	t = floor(20 + rand(1)*980);   % pocet prikladov 21..1000 (vzdy teda plati t >= n)
	X = rand(t, n);                % dizajnova matica
	coefs = -100 + rand(n, 1)*200; % koeficienty -100.0..+100.0
	y = X * coefs;                 % vektor vysledkov
	% trenovanie klasickym sposobom
	tetha = (X' * X) \ (X' * y);
	% trenovanie premudrelym sposobom
	Xl = inverse(X' * X) * X';     % lava inverzna matica k X
	tethaPrem = Xl * y;
	% trenovanie klasickym sposobom pre demonstraciu numerickych nepresnosti
	Xtrans = ((X'*5)*0.2);         % realne plati X' = ((X'*5)*0.2), kvoli presnosti nie
	tethaDemo = (Xtrans * X) \ (X' * y);
	% porovnanie odchylky
	for j = 1:n
		errL1prem += abs(tetha(j) - tethaPrem(j));
		errL1demo += abs(tetha(j) - tethaDemo(j));
	endfor
	errL2prem += (tetha - tethaPrem)'*(tetha - tethaPrem);
	errL2demo += (tetha - tethaDemo)'*(tetha - tethaDemo);
endfor
errL1prem /= maxIter;
errL2prem /= maxIter;
errL1demo /= maxIter;
errL2demo /= maxIter;

disp('Priemerna odchylka postupu prof. Premudreleho podla normy L1:');
disp(errL1prem);
disp('Priemerna demonstracna odchylka podla normy L1:');
disp(errL1demo);
disp('Priemerna odchylka postupu prof. Premudreleho podla normy L2:');
disp(errL2prem);
disp('Priemerna demonstracna odchylka podla normy L2:');
disp(errL2demo);