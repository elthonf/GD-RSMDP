function [ problem ] = RSMDP_GenerateRoboVigilante( )
%RSMDP-GENERATE Summary of this function goes here
%   Detailed explanation goes here

problem = CMDPSimples(3, 3, false);

problem.states(1).name = 'esq';
problem.states(2).name = 'meio'; %Falso final
problem.states(3).name = 'dir'; %Falso final

problem.actions(1).nanme = 'permanecer';
problem.actions(2).name = 'paraesq';
problem.actions(3).name = 'paradir';

problem.horizon = Inf; %Horizonte infinito
problem.initialPolicy = 1 * ones(1,problem.nStates); %Política inicial simples (sempre permanecer)


%% Atualiza Matriz de Transicao (s, s', a) e matriz de recompensa 2D (s, a) 
%permanecer (1)
problem.transition(1, 1, 1) = 1.0; %esq, esq, permanecer
problem.transition(2, 2, 1) = 1.0; %meio, meio, permanecer
problem.transition(3, 3, 1) = 1.0; %dir, dir, permanecer

%paraesq (2)
problem.transition(2, 1, 2) = 0.7; %meio, esq, paraesq
problem.transition(2, 2, 2) = 0.3; %meio, meio, paraesq
problem.transition(3, 2, 2) = 0.7; %dir, meio, paraesq
problem.transition(3, 3, 2) = 0.3; %dir, dir, paraesq
problem.transition(1, 1, 2) = 1.0; %esq, esq, paraesq

%paradir (3)
problem.transition(2, 3, 3) = 0.7; %meio, dir, paradir
problem.transition(2, 2, 3) = 0.3; %meio, meio, paradir
problem.transition(1, 2, 3) = 0.7; %esq, meio, paradir
problem.transition(1, 1, 3) = 0.3; %esq, esq, paradir
problem.transition(3, 3, 3) = 1.0; %dir, dir, paradir

%permanecer (1)
problem.reward2D(1, :) = -1.0; %esq
problem.reward2D(2, :) = +0.0; %meio
problem.reward2D(3, :) = +4.0; %dir



%permanecer (1)
%problem.reward2D(1, 1) = -1.0; %esq
%problem.reward2D(2, 1) = +0.0; %meio
%problem.reward2D(3, 1) = +4.0; %dir
%paraesq (2)
%problem.reward2D(2, 2) = -1.0; %meio
%problem.reward2D(3, 2) = +0.0; %dir
%paradir (3)
%problem.reward2D(1, 3) = +0.0; %esq
%problem.reward2D(2, 3) = +4.0; %meio


end

