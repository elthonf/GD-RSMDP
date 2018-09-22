function [ problem ] = RSMDP_GenerateMilhao( n, custos )
%RSMDP-GENERATE Summary of this function goes here
%   Detailed explanation goes here
% 
%nargin = 0;
if nargin < 1; n = 11; end;
if nargin < 2; custos = [1 2 4 8 16]; end;
if length(custos) ~= 5; custos = [1 2 4 8 16]; end;
problem = CMDPSimples(n, 5);

goalState = problem.nStates; %Só tem 1 goal, o último ID
initialState = 1;
problem.states(goalState).name = 'goal';
problem.states(goalState).goal = true;
problem.states(goalState).value = 0;
problem.horizon = Inf; %Horizonte infinito

problem.initialPolicy = ones(1,problem.nStates); %Política inicial simples


%% Gera Matriz de Transicao (s,s', a) e matriz de recompensa (s,s',a)
for s = 1:(problem.nStates)
    for a = 1:problem.nActions
        vl_inicio = 0.8 - problem.actions(a).value * 0.1;
        vl_correto = (1 - vl_inicio) / 2;
        problem.transition(s, initialState, a) = vl_inicio; 
        problem.transition(s, s, a) = problem.transition(s, s, a) + vl_correto;
        problem.transition(s, min(s+1, goalState), a) = problem.transition(s, min(s+1, goalState), a) + vl_correto;
        problem.reward3D(s, [initialState s min(s+1, goalState)], a) = custos(a) *-1.0 ;
        problem.reward2D(s, a) = custos(a);
    end;
end;

problem.transition(goalState, :, :) = 0;
problem.reward3D(goalState, :, :) = 0;

end

