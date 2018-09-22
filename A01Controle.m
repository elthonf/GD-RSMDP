%% Prepara ambiente
cd('/Users/macbook/Documents/MATLAB/GD-RSMDP');
clear all;
rand('seed', 1); %Seta o seed para o random!

%% Gera os problemas de teste
fprintf( 'Gerando os problemas RSMDP a serem trabalhados ... \n');
pDrive = RSMDP_GenerateDrive(); %Problema da carteira de motorista
pGrid = RSMDP_GenerateGrid();
pCardio = RSMDP_GenerateCardio();
pRobo = RSMDP_GenerateRoboVigilante();

%% Calcula as respostas
%resposta1 = SolveSimpleProblem( p1, 0.95);
%resposta3 = SolveSimpleProblem( p3, 0.95);

%p1.actualPolicy = resposta1.policy
%s(1) = 87;
%resposta3.policy(54)

%% Executa Algoritmo 01
fprintf( 'Solucionando os problemas com o Algoritmo 01... \n');
fprintf( 'Drive \n');
policies01a = FuncAlg01( pDrive, pDrive.initialPolicy );
fprintf( 'Grid \n');
policies02a = FuncAlg01( pGrid, pGrid.initialPolicy );
fprintf( 'Cardio \n');
policies03a = FuncAlg01( pCardio, pCardio.initialPolicy );
fprintf( 'Robo \n');
policies04a = FuncAlg01( pRobo, pRobo.initialPolicy, 0.9 );


%% Executa Algoritmo 02
fprintf( 'Solucionando os problemas com o Algoritmo 02... \n');
policies01b = FuncAlg02( pDrive, pDrive.initialPolicy, -0.4 ); %Risk prone
policies01c = FuncAlg02( pDrive, pDrive.initialPolicy,  0.0 ); %Risk neutral
policies01d = FuncAlg02( pDrive, pDrive.initialPolicy, +0.4 ); %Risk averse

policies02b = FuncAlg02( pGrid, pGrid.initialPolicy, -0.4 ); %Risk prone
policies02c = FuncAlg02( pGrid, pGrid.initialPolicy,  0.0 ); %Risk neutral
policies02d = FuncAlg02( pGrid, pGrid.initialPolicy, +0.4 ); %Risk averse

policies03b = FuncAlg02( pCardio, pCardio.initialPolicy, -0.4 ); %Risk prone
policies03c = FuncAlg02( pCardio, pCardio.initialPolicy,  0.0 ); %Risk neutral
policies03d = FuncAlg02( pCardio, pCardio.initialPolicy, +0.4 ); %Risk averse


%% Executa Algoritmo 04
fprintf( 'Solucionando os problemas com o Algoritmo 04... \n');
[policies01e, lambda01e] = FuncAlg04( pDrive, pDrive.initialPolicy, 0.001, 0.0010000001 ); %Risk prone
%% Executa Algoritmo 04 (VERSAO BACKUP)
fprintf( 'Solucionando os problemas com o Algoritmo 04, Versão Backup... \n');

[policies01e, lambda01e] = FuncAlg04_BACK( pDrive, pDrive.initialPolicy, 0.001, 0.0010000001 ); %Risk prone
