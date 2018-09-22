function [ problem ] = RSMDP_GenerateGrid( )
%RSMDP-GENERATE Summary of this function goes here
%   Detailed explanation goes here

problem = CMDPGrid( 5, 5 );
problem.setTransition(0.8, 0.02); % 0.80 de executar a ação esperada. 0.02 de ir para lado adjacente. Diferença: fica parado!

goalStates = [10];
failStates = [3, 5, 6, 13, 14, 15, 18];

%problem.states(goalState).name = 'goal';
problem.states(goalStates).goal = true;
%problem.states(goalState).value = Inf;
problem.horizon = Inf; %Horizonte infinito ou indeterminado

problem.initialPolicy = 9 * ones(1,problem.nStates); %Política inicial simples (ficar parado sempre)

%% Gera Matriz de recompensa 3D (s,s',a)
problem.reward3D(:, :, :) = -1.0; %Cada movimento (ação), tem custo -1;
problem.reward3D(:, failStates, :) = -100.0; %Cada movimento para um fail, tem custo -100;
problem.reward3D(:, goalStates, :) = +100.0; %Cada movimento para um goal, tem recompensa +100;

%% Gera matriz de recompensa 2D (s, a)
problem.reward2D(:, :) = -1.0; %Cada movimento (ação), tem custo -1;

for s = failStates %Se do estado s, tomar uma ação que caia em um fail, custo = -100 (-1 -99)
    maskFail = reshape( problem.maskActions(:,s,:) , problem.nStates, problem.nActions);
    maskFail = -99 .* maskFail;
    problem.reward2D = problem.reward2D + maskFail;
end

for s = goalStates %Se do estado s, tomar uma ação que caia em um goal, recpmpensa = 100 (-1 +101)
    maskGoal = reshape( problem.maskActions(:,s,:) , problem.nStates, problem.nActions);
    maskGoal = 101 .* maskGoal;
    maskGoal(:,9) = 0; %ficar parado não deve gerar mais recompensa, mesmo que seja estado meta.
    problem.reward2D = problem.reward2D + maskGoal;
end


end

