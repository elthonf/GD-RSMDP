
%Comparação de tempo entre vetorial e soma ordenada
v1 = linspace( 3.456e67 ,6.789e98 ,10000000);
v2 = linspace( 3.456e68 ,6.789e99 ,10000000);

tic;
ComparaVetores(v1, v2);
t.Vetorial = toc

tic;
ComparaVetoresValdinei(v1, v2);
t.Valdinei = toc

%Comparação de tempo entre matrizes

vAll = reshape( [v1 v2], [10, 10, 200000]);
vAll = reshape( [v1 v2], [10, 2, 1000000]);

tic
max(vAll, [], 2); %Original
toc

tic
MaxTudo(vAll); %Vetorial
toc

tic
MaxTudoValdinei(vAll); %Soma ordenada
toc