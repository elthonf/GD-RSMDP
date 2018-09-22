function [ problem ] = RSMDP_GenerateDrive( )
%RSMDP-GENERATE Summary of this function goes here
%   Detailed explanation goes here

problem = CMDPSimples(12, 5);

goalState = problem.nStates;
%problem.goalStates = (goalState); %Só tem 1 goal, o último ID
%problem.failStates = [3,6];

problem.states(goalState).name = 'goal';
problem.states(goalState).goal = true;
problem.states(goalState).value = Inf;
problem.horizon = Inf; %Horizonte infinito

problem.initialPolicy = ones(1,problem.nStates); %Política inicial simples

%problem.initialPolicy = 5 .* problem.initialPolicy; %código 5 = 4 horas!
problem.initialPolicy(12) = 1; %Para o estado final, a ação é 1 (zero horas)

%% Gera Matriz de Transicao (s,s', a) e matriz de recompensa (s,s',a)
for s = 1:(problem.nStates-1) %Ultimo é Goal, não entra no Loop
    for a = 1:problem.nActions
        vl1 = 0.08 * problem.states(s).value + 0.04 * problem.actions(a).value;
        vl2 = 1 - vl1;
        problem.transition(s, goalState, a) = vl1;
        problem.transition(s, min(s+a-1,11), a) = vl2;
        problem.reward3D(s, goalState, a) = 0.0; %Aprova, a meu ver o custo também deveria ser (2 + a)
        problem.reward3D(s, min(s+a-1,11), a) = problem.actions(a).value *-1.0 - 2.0; %paga 1 dolar por hora de aula + 2 dolares pela prova
    end
end

%% Gera matriz de recompensa 2D (s, a) a partir da 3D
rewardResum = sum( problem.reward3D, 2 ); %Soma na segunda dimensão
rewardResum = reshape( rewardResum, problem.nStates, problem.nActions );
problem.reward2D = rewardResum;


problem.reward2D = problem.reward2D * -1.0; %Transforma os custos (inicialmente negativos) em positivos
end

