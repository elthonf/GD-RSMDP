%% Prepara ambiente
cd('/Users/macbook/Documents/MATLAB/GD-RSMDP');
clear all;
rand('seed', 1); %Seta o seed para o random!

%% Gera os problemas de teste
fprintf( 'Gerando os problemas RSMDP a serem trabalhados ... \n');
pBacteria = RSMDP_GenerateBacteria();

%pDrive.actualPolicy =  pDrive.initialPolicy;
%[~, Tg, ~, C] = pDrive.rewardMatrixExpComponents( 0.0 );

%% Executa Algoritmo 04
fprintf( 'Solucionando os problemas com o Algoritmo 04... \n');
[policies01b, lambda01b, lambdaLog01b, ~] = FuncAlg04( pBacteria, pBacteria.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
plot(lambdaLog01b);