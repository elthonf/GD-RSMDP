function [ problem ] = RSMDP_GenerateMinami( pUp, pDown, costUp, costDown )
%RSMDP-GENERATE Summary of this function goes here
%   Detailed explanation goes here
%nargin=0
if nargin < 1; pUp = 0.8689; end;
if nargin < 2; pDown = pUp; end;
if nargin < 3; costUp = 1; end;
if nargin < 4; costDown = costUp; end;

problem = CMDPSimples(9, 2);

goalState = problem.nStates;
zeroState = 1;
upStates = [6 7 8];
downStates = [2 3 4 5];
aUp = 1;
aDown = 2;

problem.states(goalState).name = 'goal';
problem.states(goalState).goal = true;
problem.states(goalState).value = 0;
problem.horizon = Inf; %Horizonte infinito

%problem.initialPolicy = ones(1, problem.nStates); %Política inicial simples
%problem.initialPolicy = [2 2 2 2 2 1 1 1 1];
problem.initialPolicy = [1 1 1 1 1 2 2 2 2];

%% Gera Matriz de Transicao (s,s', a) e matriz de recompensa 3D (s,s',a) e 2D (s, a)
problem.reward3D(:, :, aUp) = -costUp;
problem.reward2D(:, aUp) = costUp;
problem.reward3D(:, :, aDown) = -costDown;
problem.reward2D(:, aDown) = costDown;

%Cima a = aUp
problem.transition(1, 6, aUp) = pUp;
problem.transition(6, 7, aUp) = pUp;
problem.transition(7, 8, aUp) = pUp;
problem.transition(8, 9, aUp) = pUp;
problem.transition([zeroState upStates], zeroState, aUp) = 1 - pUp;
for s = downStates
    problem.transition(s, s, aUp) = 1;
end

%Baixo a = 2
problem.transition(1, 2, aDown) = pDown;
problem.transition(2, 3, aDown) = pDown;
problem.transition(3, 4, aDown) = pDown;
problem.transition(4, 5, aDown) = pDown;
problem.transition(5, 9, aDown) = pDown;
for s = [zeroState downStates]
    problem.transition(s, s, aDown) = 1 - pDown;
end
for s = upStates
    problem.transition(s, s, aDown) = 1;
end

problem.transition(goalState, :, :) = 0;
problem.reward3D(goalState, :, :) = 0;
problem.reward2D(goalState, :) = 0;
end

