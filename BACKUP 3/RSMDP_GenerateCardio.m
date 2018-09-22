function [ problem ] = RSMDP_GenerateCardio( )
%RSMDP-GENERATE Summary of this function goes here
%   Detailed explanation goes here

problem = CMDPSimples(8, 3, false);

problem.states(1).name = 'cardiopatia';
problem.states(2).name = 'cardiopatia controlada'; %Falso final
problem.states(3).name = 'cardiopatia controlada com ef. colateral'; %Falso final
problem.states(4).name = 'cardiopatia grave';
problem.states(5).name = 'cardiopatia irreversível';
problem.states(6).name = 'AVC'; %Falso final
problem.states(7).name = 'morte'; %Falso final
problem.states(8).name = 'fim do tratamento';
problem.states(8).goal = true;

problem.actions(1).name = 'droga d1';
problem.actions(2).name = 'droga d2';
problem.actions(3).name = 'transplante';

problem.horizon = Inf; %Horizonte infinito
problem.initialPolicy = 1 * ones(1,problem.nStates); %Política inicial simples (sempre droga 1)


%% Atualiza Matriz de Transicao (s, s', a) e matriz de recompensa 2D (s, a) 
%cardiopatia (1) e droga 1 (1)
problem.transition(1, 2, 1) = 0.3; % 50% para cada
problem.transition(1, 3, 1) = 0.3;
problem.transition(1, 4, 1) = 0.2; % 50% para cada
problem.transition(1, 5, 1) = 0.2;
problem.reward2D(1, 1) = -30.0;

%cardiopatia (1) e droga 2 (2)
problem.transition(1, 2, 2) = 0.4; % 50% para cada
problem.transition(1, 4, 2) = 0.4;
problem.transition(1, 5, 2) = 0.1; % 50% para cada
problem.transition(1, 6, 2) = 0.1;
problem.reward2D(1, 2) = -20.0;

%cardiopatia (1) e transplante (3)
problem.transition(1, 3, 3) = 0.7;
problem.transition(1, 7, 3) = 0.3;
problem.reward2D(1, 3) = -75.0;

%cardiopatia grave (4) e droga 1 (1)
problem.transition(4, 4, 1) = 0.4; % 50% para cada
problem.transition(4, 5, 1) = 0.4;
problem.transition(4, 6, 1) = 0.2;
problem.reward2D(4, 1) = -30.0;

%cardiopatia grave (4) e droga 2 (2)
problem.transition(4, 3, 2) = 0.35; % 50% para cada
problem.transition(4, 5, 2) = 0.35;
problem.transition(4, 6, 2) = 0.3;
problem.reward2D(4, 2) = -25.0;

%cardiopatia grave (4) e transplante (3)
problem.transition(4, 3, 3) = 0.6;
problem.transition(4, 7, 3) = 0.4;
problem.reward2D(4, 3) = -70.0;

%cardiopatia irreversível (5) e droga 1 (1)
problem.transition(5, 5, 1) = 0.35; % 50% para cada
problem.transition(5, 6, 1) = 0.35;
problem.transition(5, 7, 1) = 0.3;
problem.reward2D(5, 1) = -40.0;

%cardiopatia irreversível (5) e droga 2 (2)
problem.transition(5, 6, 2) = 0.35;
problem.transition(5, 7, 2) = 0.3;
problem.reward2D(5, 2) = -30.0;

%cardiopatia irreversível (5) e transplante (3)
problem.transition(5, 3, 3) = 0.6;
problem.transition(5, 7, 3) = 0.4;
problem.reward2D(5, 3) = -70.0;

%estados finais:
% (2) Cardiopatia controlada
problem.transition(2, 8, :) = 1.0;
problem.reward2D(2, :) = 0.0;
% (3) Cardiopatia controlada com efeito colateral
problem.transition(3, 8, :) = 1.0;
problem.reward2D(3, :) = -2.0;
% (6) AVC
problem.transition(6, 8, :) = 1.0;
problem.reward2D(6, :) = -85.0;
% (7) morto
problem.transition(7, 8, :) = 1.0;
problem.reward2D(7, :) = -100.0;
% (8) Fim de tratamento
end

