%% Prepara ambiente
cd('/Users/macbook/Documents/MATLAB/GD-RSMDP');
clear all;
rand('seed', 1); %Seta o seed para o random!

%% Gera os problemas de teste
nRow = 8;
nCol = 25;
fprintf( 'Gerando os problemas RSMDP a serem trabalhados ... \n');
pRiver = RSMDP_GenerateRiver(nRow, nCol, 0.99, 0.40, 4, 1);
%pRiver.initialPolicy = [3 3 4 3 3 4 3 3 4 3 3 4 3 3 4 3 3 4 1 2 1 ];
eps = 0.001;
%% Parametros para Debug
if false
    mdp = pRiver;
    initialPolicy = mdp.initialPolicy;
    epsilon = eps;
    beta = eps + 0.0000000001;
    riskFactor = -0.1;
    modo = 0;
end
%% SOLVE usando os algoritmos
risk = -0.01;
risk = -.90;
tic
%[policies_, lambda_, lambdaLog_, ~, lambdaConv_, tempo_] = FuncAlg04( pRiver, pRiver.initialPolicy, eps, eps + 0.0000000001, risk, 0 ); %Risk prone
[policiesa, lambdaa, lambdaLoga, ~, lambdaConva, tempoa] = FuncAlg04( pRiver, pRiver.initialPolicy, eps, eps + 0.0000000001, risk, 1 ); %Risk prone
%[policiesb, lambdab, lambdaLogb, ~, lambdaConvb, tempob] = FuncAlg04( pRiver, pRiver.initialPolicy, eps, eps + 0.0000000001, risk, 2 ); %Risk prone
%[policiesc, lambdac, lambdaLogc, ~, lambdaConvc, tempoc] = FuncAlg04( pRiver, pRiver.initialPolicy, eps, eps + 0.0000000001, risk, 3 ); %Risk prone
toc
%resultOriginal = reshape(policies_{length(policies_)}, nCol, nRow)'
resultTratado = reshape(policiesa{length(policiesa)}, nCol, nRow)'

%% Gera análise de lambdas
lambdas = [0.00:0.01:lambda_ lambda_];
VsDePi = zeros( pRiver.nStates, length(lambdas) );
pRiver.actualPolicy = policiesa{length(policiesa)};
for i = 1:length(lambdas)
    VsDePi(:,i) = pRiver.rewardMatrixExp( lambdas(i) , 1.0);
    fprintf(' [%d]  %d . \n', i, lambdas(i) )
end
%% Salva TUDO
path_out = '/Volumes/GoogleDrive/Meu Drive/USP/Dissertacao Elthon/Experimentos/ReportFinal/Marks/';

save( strcat(path_out, 'pRiver', num2str(nRow), 'p', num2str(nCol), '.mat') ...
    ,'nRow', 'nCol', 'resultOriginal', 'resultTratado' ...
    ,'policies_', 'lambda_', 'lambdaLog_', 'lambdaConv_' ...
    ,'policiesa', 'lambdaa', 'lambdaLoga', 'lambdaConva' ...
    ,'policiesb', 'lambdab', 'lambdaLogb', 'lambdaConvb' ...
    ,'policiesc', 'lambdac', 'lambdaLogc', 'lambdaConvc' ...
    ,'lambdas', 'VsDePi' ...
    )

fprintf('> Arquivo salvo com sucesso. \n' )

%% Iteraçao de política simples

pol_inicial = policiesa{length(policiesa)-2};
num2str(pol_inicial)
tic
pol_simples = FuncAlg02( pRiver, pol_inicial, lambdaLoga(length(lambdaLoga)-1) );
toc
num2str( pol_simples{length(pol_simples)} )
reshape(pol_simples{length(pol_simples)}, nCol, nRow)'

%%
l_pointer = 1;
tic
for p = 1:length(policiesa)-1
    pol_inicial = policiesa{p};
    l_pointer = l_pointer + lambdaConva(p);
    pol_simples = FuncAlg02( pRiver, pol_inicial, lambdaLoga(l_pointer) );
end
toc
reshape(pol_simples{length(pol_simples)}, nCol, nRow)'


%% Dada uma politica inicial e um fator de risco, calcula a politica resultante
% Obs: Dar como P0 uma politica final
police_final = policiesa{length(policiesa)};
risk = 0.002;
tic
[policies_unique, lambda_unique, lambdaLog_unique, ~, lambdaConv_unique, tempo_unique] = FuncAlg04( pRiver, police_final, eps, eps + 0.0000000001, risk, 1, false ); %Risk prone
toc
%reshape(policies_unique{length(policies_unique)}, nCol, nRow)'



police_final = policiesa{length(policiesa)};
risk = 0.002;
pRiver.actualPolicy = police_final;
[VPActual,VPActual2] = pRiver.rewardMatrixExp(risk, 1.0);
max(VPActual), min(VPActual)
