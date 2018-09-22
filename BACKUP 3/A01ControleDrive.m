%% Prepara ambiente
cd('/Users/macbook/Documents/MATLAB/GD-RSMDP/BACKUP 3');
clear all;
rand('seed', 1); %Seta o seed para o random!

%% Gera os problemas de teste
fprintf( 'Gerando os problemas RSMDP a serem trabalhados ... \n');
pDrive = RSMDP_GenerateDrive(); %Problema da carteira de motorista com 11 estados
pDrive2 = RSMDP_GenerateDrive2(); %Problema da carteira de motorista com 12 estados

%pDrive.actualPolicy =  pDrive.initialPolicy;
%[~, Tg, ~, C] = pDrive.rewardMatrixExpComponents( 0.0 );

%% Executa Algoritmo 04
fprintf( 'Solucionando os problemas com o Algoritmo 04... \n');
[policies01e, lambda01e, lambdaLog01e, ~] = FuncAlg04_ORIGINAL( pDrive, pDrive.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
[policies02e, lambda02e, lambdaLog02e, ~] = FuncAlg04_ORIGINAL( pDrive2, pDrive2.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
plot(lambdaLog01e);
plot(lambdaLog02e);

%Novos:
[policies01f, lambda01f, lambdaLog01f, ~] = FuncAlg04( pDrive, pDrive.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
[policies02f, lambda02f, lambdaLog02f, ~] = FuncAlg04( pDrive2, pDrive2.initialPolicy, 0.001, 0.0010000001, -0.1 ); %Risk prone
plot(lambdaLog02f);


%% GEra imagem para o artigo
plot(lambdaLog02e);

xlabel('atualizações do fator de sensibilidade a risco');
ylabel('valor do fator de sensibilidade a risco') ;
