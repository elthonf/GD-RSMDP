function [ problem ] = RSMDP_GenerateWar( altura )
%RSMDP-GENERATE Summary of this function goes here
%   Detailed explanation goes here
% 
%nargin = 0;
if ~exist('altura', 'var'); altura = 20; end;
initialState = 1;
estadosc1 = 2:4:altura*4;
estadosc2 = 3:4:altura*4;
estadosc3 = 4:4:altura*4;
estadosc4 = 5:4:altura*4+1;
goalState =  altura * 4 + 2;
%estadosc1 = [initialState estadosc1];

problem = CMDPSimples(goalState, 5);

problem.states(initialState).name = 'begin';
problem.states(goalState).name = 'goal';
problem.states(goalState).goal = true;
problem.states(goalState).value = 0;
problem.horizon = Inf; %Horizonte infinito

problem.initialPolicy = ones(1,problem.nStates); %Política inicial simples

problem.actions(1).name = 'Avançar';
problem.actions(2).name = 'Avançar 2x';
problem.actions(3).name = 'Avançar e atirar';
problem.actions(4).name = 'Move Esquerda';
problem.actions(5).name = 'Move Direita';

%Penalties
problem.states(initialState).pen = 0.00;
problem.states(goalState).pen = 0.00;
for s = estadosc1; problem.states(s).pen = 0.05; end;
for s = estadosc2; problem.states(s).pen = 0.10; end;
for s = estadosc3; problem.states(s).pen = 0.15; end;
for s = estadosc4; problem.states(s).pen = 0.00; end;

custos = [1.1 1.2 1.4 1.1 1.1];

%% Gera matriz de recompensa 3D (s,s',a) e 2D (s, a)
for a = 1:problem.nActions
    problem.reward3D(:, :, a) = -custos(a);
    problem.reward2D(:, a) = custos(a);
end

%%  Gera Matriz de Transicao (s,s', a)
problem.transition(initialState, 2:5, :) = 0.20;
problem.transition(initialState, initialState, :) = 0.80;
for s = 2:problem.nStates  % 'Avançar';
    problem.transition(s, min(s+4, goalState), 1) = 0.20 - problem.states(s).pen;
    problem.transition(s, s, 1) = 0.80                   + problem.states(s).pen;
end
for s = 2:problem.nStates  % 'Avançar 2x';
    problem.transition(s, min(s+8, goalState), 2) = 0.30 - problem.states(s).pen;
    problem.transition(s, min(s+4, goalState), 2) = problem.transition(s, min(s+4, goalState), 2) + 0.30;
    problem.transition(s, s, 2) = 0.40                   + problem.states(s).pen;
end
for s = 2:problem.nStates  % 'Avançar e atirar';
    problem.transition(s, min(s+4, goalState), 3) = 0.90 - problem.states(s).pen;
    problem.transition(s, s, 3) = 0.10                   + problem.states(s).pen;
end
for s = [estadosc2 estadosc3 estadosc4]  % 'Esquerda';
    problem.transition(s, s-1, 4) = 0.90                 - problem.states(s).pen;
    problem.transition(s, s, 4) = 0.10                   + problem.states(s).pen;
end
for s = [estadosc1 estadosc2 estadosc3]  % 'Direita';
    problem.transition(s, s+1, 5) = 0.90                 - problem.states(s).pen;
    problem.transition(s, s, 5) = 0.10                   + problem.states(s).pen;
end

problem.transition(goalState, :, :) = 0;
problem.reward3D(goalState, :, :) = 0;
problem.reward2D(goalState, :) = 0;
end

