%% Prepara ambiente
cd('/Users/macbook/Documents/MATLAB/GD-RSMDP');
clear all;
rand('seed', 1); %Seta o seed para o random!

%% Gera os problemas de teste
fprintf( 'Gerando os problemas RSMDP a serem trabalhados ... \n');
pMilhao = RSMDP_GenerateMilhao(30);
%pRiver.initialPolicy = [3 3 4 3 3 4 3 3 4 3 3 4 3 3 4 3 3 4 1 2 1 ];
eps = 0.001;
%% Parametros para Debug
if false
    mdp = pMilhao;
    initialPolicy = mdp.initialPolicy;
    epsilon = eps;
    beta = eps + 0.0000000001;
    riskFactor = -0.1;
    modo = 0;
end
%% SOLVE usando os algoritmos
[policies_, lambda_, lambdaLog_, ~, lambdaConv_] = FuncAlg04( pMilhao, pMilhao.initialPolicy, eps, eps + 0.0000000001, -0.1, 0 ); %Risk prone
[policiesa, lambdaa, lambdaLoga, ~, lambdaConva] = FuncAlg04( pMilhao, pMilhao.initialPolicy, eps, eps + 0.0000000001, -0.1, 1 ); %Risk prone
%[policiesb, lambdab, lambdaLogb, ~, lambdaConvb] = FuncAlg04( pMilhao, pMilhao.initialPolicy, eps, eps + 0.0000000001, -0.1, 2 ); %Risk prone
%[policiesc, lambdac, lambdaLogc, ~, lambdaConvc] = FuncAlg04( pMilhao, pMilhao.initialPolicy, eps, eps + 0.0000000001, -0.1, 3 ); %Risk prone
%resultOriginal = reshape(policies_{length(policies_)}, nCol, nRow)'
%resultTratado = reshape(policiesa{length(policiesa)}, nCol, nRow)'

policies_{length(policies_)}
policiesa{length(policiesa)}

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

pol_inicial = policiesa{length(policiesa)};
num2str(pol_inicial)
pol_simples = FuncAlg02( pRiver, pol_inicial, -2.0000 );
num2str( pol_simples{length(pol_simples)} )
reshape(pol_simples{length(pol_simples)}, nCol, nRow)'


