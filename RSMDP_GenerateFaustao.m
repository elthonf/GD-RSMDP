function [ problem ] = RSMDP_GenerateFaustao( semanas )
%RSMDP-GENERATE Summary of this function goes here
%   Detailed explanation goes here
% 
%nargin = 0;
if nargin < 1; semanas = 20; end;

custos = [1 2 8 16 20 64];

problem = CMDPSimples(semanas*2 + 1, 5);

goalState = problem.nStates; %Só tem 1 goal, o último ID
initialState = 1;
statePerguntas = 1:2:semanas*2;
stateDesafios = 2:2:semanas*2;
problem.states(goalState).name = 'goal';
problem.states(goalState).goal = true;
problem.states(goalState).value = 0;
problem.horizon = Inf; %Horizonte infinito

problem.initialPolicy = ones(1,problem.nStates); %Política inicial simples


%% Gera Matriz de Transicao (s,s', a) e matriz de recompensa 3D (s,s',a) e 2D (s, a)
for a = 1:problem.nActions
    problem.reward3D(:, :, a) = -custos(a);
    problem.reward2D(:, a) = custos(a);
end


for s = statePerguntas
    problem.transition(s, s+2, 1) = 0.01; %tentar a sorte (pouca sorte)
    problem.transition(s, s  , 1) = 0.99;
    problem.transition(s, min(s+2, goalState), 2) = 0.20; %Responder normal (1/5)
    problem.transition(s, s+1, 2) = 0.80;
    problem.transition(s, s+2, 3) = 0.25; %Eliminar uma (1/4)
    problem.transition(s, s+1, 3) = 0.75;
    problem.transition(s, s+2, 4) = 0.33; %Eliminar tre (1/3)
    problem.transition(s, s+1, 4) = 0.67;
    problem.transition(s, s+2, 5) = 0.5; %Eliminar tre (1/2)
    problem.transition(s, s+1, 5) = 0.5;
end;
% for s = statePerguntas
%     problem.transition(s, s+2, 1) = 0.01; %tentar a sorte (pouca sorte)
%     problem.transition(s, s, 1) = 0.99;
%     problem.transition(s, s+2, 2) = 0.20; %Responder normal (1/5)
%     problem.transition(s, s+1, 2) = 0.80;
%     problem.transition(s, s+2, 3) = 0.25; %Eliminar uma (1/4)
%     problem.transition(s, s+1, 3) = 0.75;
%     %problem.transition(s, s+2, 4) = 0.33; %Eliminar duas (1/3)
%     %problem.transition(s, s+1, 4) = 0.67;
% end;

for s = stateDesafios
    problem.transition(s, s+1, 1) = 0.01; %tentar a sorte (pouca sorte)
    problem.transition(s, s, 1) = 0.99;
    problem.transition(s, s-1, 2) = 0.20; %Desafio difícil
    problem.transition(s, s  , 2) = 0.80;
    problem.transition(s, s-1, 3:5) = 0.50; %Desafio fácil
    problem.transition(s, s  , 3:5) = 0.50;
end;

problem.transition(goalState, :, :) = 0;
problem.reward3D(goalState, :, :) = 0;
problem.reward2D(goalState, :) = 0;
end

