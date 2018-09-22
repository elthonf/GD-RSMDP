function [ problem ] = RSMDP_GenerateRiver( n, m )
%RSMDP-GENERATE Summary of this function goes here
%   Detailed explanation goes here
%   n = number of lines
%   m = number of rows

if nargin < 1; n = 3; end;
if nargin < 2; m = 3; end;
if n < 3; n = 3; end; %
if m < 3; m = 3; end;

%  n = 9;m = 5;


problem = CMDPGrid( n, m );


problem.actions([1,3,6,8]) = []; %Remove as 4 ações não utilizadas
problem.nActions = 5;
problem.transition(:,:,[1,3,6,8]) = [];
problem.reward3D(:,:,[1,3,6,8]) = [];
problem.reward2D(:,[1,3,6,8]) = [];
problem.maskAdjacent(:,:,[1,3,6,8]) = [];
problem.maskActions(:,:,[1,3,6,8]) = [];

%Seta arrays auxiliares de estados
stateGoal = n * m; %Apenas ultimo estado é meta
stateStart = n * m - m + 1;    %Apenas ultimo da primeira coluna é Start
stateBridge = 2:(m-1); %Estados da ponte
stateLandLeft = 1:m:stateStart; %estados com terra (margem esquera e direita)
stateLandRight = m:m:stateGoal; %estados com terra (margem esquera e direita)
stateWaterfall = stateStart+1:stateGoal-1; %Estados waterfall
stateWater = 1:stateGoal; 
stateWater([stateStart, stateGoal, stateLandLeft, stateLandRight, stateBridge, stateWaterfall] ) = []; %remove 

%Seta estado(s) meta(s)
problem.states(stateGoal).goal = true;
problem.horizon = Inf; %Horizonte infinito ou indeterminado


%% Gera Matriz de recompensa 3D (s,s',a)
%problem.reward3D(:, :, :) = -1.0; %Cada movimento (ação), tem custo -1;
%problem.reward3D(:, failStates, :) = -100.0; %Cada movimento para um fail, tem custo -100;
%problem.reward3D(:, goalStates, :) = +100.0; %Cada movimento para um goal, tem recompensa +100;

%% Gera matriz de recompensa 2D (s, a)
problem.reward2D(:, :) = +1.0; %Cada movimento (ação), tem custo -1; (custo está positivo devido algoritmo 4)
%problem.reward2D(stateWaterfall, :) = +150.0; %Cada movimento (ação), tem custo -1; (custo está positivo devido algoritmo 4)
%problem.reward2D(stateWaterfall, 5) = +100.0; %Cada movimento (ação), tem custo -1; (custo está positivo devido algoritmo 4)
%problem.reward2D(stateWater, 4) = +2.0; %Cada movimento para baixo no rio(ação), tem custo -1; (custo está positivo devido algoritmo 4)

%% Gera matriz de transição (s,s',a)
problem.transition(:,:,:) = 0.0; %Zera matriz

%Probabilidades em terra e na ponte:
% Ficar parado (wait=5) = 100%
problem.transition([stateLandLeft,stateLandRight,stateBridge],:,5) = problem.maskActions([stateLandLeft,stateLandRight,stateBridge],:,5) .* 1.00;

%Mover para qualquer lugar = 99% (1% de não sair do lugar)
problem.transition([stateLandLeft,stateLandRight,stateBridge],:,[1,2,3,4]) = problem.transition([stateLandLeft,stateLandRight,stateBridge],:,[1,2,3,4]) + problem.maskActions([stateLandLeft,stateLandRight,stateBridge],:,[1,2,3,4]) .* 0.99;
problem.transition([stateLandLeft,stateLandRight,stateBridge],:,1) = problem.transition([stateLandLeft,stateLandRight,stateBridge],:,1) + problem.maskActions([stateLandLeft,stateLandRight,stateBridge],:,5) .* 0.01;
problem.transition([stateLandLeft,stateLandRight,stateBridge],:,2) = problem.transition([stateLandLeft,stateLandRight,stateBridge],:,2) + problem.maskActions([stateLandLeft,stateLandRight,stateBridge],:,5) .* 0.01;
problem.transition([stateLandLeft,stateLandRight,stateBridge],:,3) = problem.transition([stateLandLeft,stateLandRight,stateBridge],:,3) + problem.maskActions([stateLandLeft,stateLandRight,stateBridge],:,5) .* 0.01;
problem.transition([stateLandLeft,stateLandRight,stateBridge],:,4) = problem.transition([stateLandLeft,stateLandRight,stateBridge],:,4) + problem.maskActions([stateLandLeft,stateLandRight,stateBridge],:,5) .* 0.01;

% Mover para oeste (2), na margem esquerda é igual ficar parado (5)
problem.transition(stateLandLeft,:,2)  = problem.transition(stateLandLeft,:,2)  + problem.maskActions(stateLandLeft,:,5) .* 0.99;
% Mover para leste (3), na margem direita é igual ficar parado (5)
problem.transition(stateLandRight,:,3) = problem.transition(stateLandRight,:,3) + problem.maskActions(stateLandRight,:,5) .* 0.99;
% Mover para norte (1), na ponte é igual ficar parado (5)
problem.transition(stateBridge,:,1) = problem.transition(stateBridge,:,1) + problem.maskActions(stateBridge,:,5) .* 0.99;
% Mover para norte (1), nas duas margens de entrada da ponte é igual ficar parado (5)
problem.transition([1,m],:,1) = problem.transition([1,m],:,1) + problem.maskActions([1,m],:,5) .* 0.99;

% Mover para sul (4), no start é igual ficar parado (5)
problem.transition(stateStart,:,4) = problem.transition(stateStart,:,4) + problem.maskActions(stateStart,:,5) .* 0.99;


%Probabilidades NO RIO
% Mover para norte (1) ou sul (4) ou wait(5), no rio não é permitido. Entao é igual ficar parado (5)
problem.transition(stateWater,:,5) = problem.maskActions(stateWater,:,5);
problem.transition(stateWater,:,1) = problem.maskActions(stateWater,:,5);
problem.transition(stateWater,:,4) = problem.maskActions(stateWater,:,5);
%problem.transition(stateWater,:,4) = problem.maskActions(stateWater,:,4);

% Mover para oeste (2), no rio é 80% possível e 20% de ir para baixo!!
problem.transition(stateWater,:,2) = problem.transition(stateWater,:,2)  + problem.maskActions(stateWater,:,2) .* 0.80;
problem.transition(stateWater,:,2) = problem.transition(stateWater,:,2)  + problem.maskActions(stateWater,:,4) .* 0.20;

% Mover para leste (3), no rio é 80% possível e 20% de
problem.transition(stateWater,:,3) = problem.transition(stateWater,:,3)  + problem.maskActions(stateWater,:,3) .* 0.80;
problem.transition(stateWater,:,3) = problem.transition(stateWater,:,3)  + problem.maskActions(stateWater,:,4) .* 0.20;

%Probabilidades NA CACHOEIRA!!
% Nenhum movimento é permitido. Apenas vai para reStart
problem.transition(stateWaterfall,:,:) = 0.0;
problem.transition(stateWaterfall,stateStart,:) = 1.0;

%Probabilidades NA META!!
% Nenhum movimento não é permitido. Apenas fica nela mesta
problem.transition(stateGoal,:,:) = 0.0;

%% Gera uma politica inicial qualquer
problem.initialPolicy = 3 * ones(1,problem.nStates); %Política inicial simples (direita sempre)
problem.initialPolicy(stateLandRight) = 3; %Margem direita vai sempre para baixo
problem.initialPolicy(stateWaterfall) = 5; %Cachoeira não há nada a fazer
problem.initialPolicy(stateStart) = 1; %Inicial vai para o norte


end

