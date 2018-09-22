function [ problem ] = RSMDP_GenerateTesteExemploDiss( )
%RSMDP-GENERATE Summary of this function goes here
%   Detailed explanation goes here

problem = CMDPSimples(4, 2, false);

problem.states(1).name = 's0';
problem.states(2).name = 's1'; %Falso final
problem.states(3).name = 's2'; %Falso final
problem.states(4).name = 'sg'; %Falso final
problem.states(4).goal = 1; 

problem.actions(1).name = 'a1';
problem.actions(2).name = 'a2';

problem.horizon = Inf; %Horizonte infinito
problem.initialPolicy = 1 * ones(1,problem.nStates); %Política inicial simples 


%% Atualiza Matriz de Transicao (s, s', a) e matriz de recompensa 2D (s, a)
p1 = 0.9;
p2 = 0.7;

%permanecer (a1)
problem.transition(1, 2, 1) = p1;
problem.transition(1, 1, 1) = 1 - p1;
problem.transition(2, 4, 1) = p1;
problem.transition(2, 2, 1) = 1 - p1;

problem.transition(1, 3, 2) = p2;
problem.transition(1, 1, 2) = 1 - p2;
problem.transition(3, 4, 2) = p2;
problem.transition(3, 3, 2) = 1 - p2;


%CUSTOS (1)
problem.reward2D(:, 1) = +15.0; %esq
problem.reward2D(:, 2) = +5.0; %meio



end

