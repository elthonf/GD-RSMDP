function [ problem ] = RSMDP_GenerateGridModelo(  )
%RSMDP_GENERATEGRIDMODELO Gera o grid modelo do artigo 
%   Artigo do Moldovan
%   Risk Aversion in Markov Decision Processes
%   via Near-Optiomal Chernoff Bounds

nAltura = 10; %10
nLargura = 12; %12
problem = CMDPGrid(nAltura, nLargura);
problem.horizon = 35;

goalStates = (38);
failStates = [13, 25, 37, 49, 50, 52, 53, 56, 61, 62, 64, 73, 74];

for i = 1:size(goalStates, 2)
    %problem.states(goalStates(i)).goal = true;
end
for i = 1:size(failStates, 2)
    %problem.states(failStates(i)).fail = true;
end

%Uma pol�tica inicial qualquer. Neste caso � uma pol�tica besta para chegar
%no Goal state
problem.actualPolicy = [ repmat(7, 1, 3*12) , repmat(5, 1, 1), 9, repmat(4, 1, 10) , repmat(2, 1, 6*12)];

%% Gera Matriz de Transicao correta (n�o obedece mask) (s,s',a)
problem.transition = ( problem.maskAdjacent .* 0.01) + ( problem.maskActions .* 0.92); %0.92 + 0.01 = 0.93
problem.transition(:,:,9) = 0; % Para este problema, WAIT nao � permitido, ou seja, zera todos
problem.transition(problem.absorbingStates,:,:) = 0; % Zera as transi��es dos absorving states para todas as a��es
for s = 1 : problem.nStates
    problem.transition(s,s,:) = 1; % Absorving states tem prob 100% para ele mesmo para todas as a��es
end

%% Gera Matriz de Recompensa B�sica (s,s',a)
problem.reward3D(:,:,:) = -1;                  % Qualquer movimento tem custo 1
problem.reward3D(:,problem.goalStates,:) = 35; % Estados Goal tem recompensa de 35
problem.reward3D(:,problem.failStates,:) = -35; % Estados FAIL tem custo de 35 (-35)

%% Gera matriz de recompensa 2D (s, a) a partir da 3D
%rewardResum = sum( problem.reward3D, 2 );
%rewardResum = reshape( rewardResum, problem.nStates, problem.nActions );
%problem.reward2D = rewardResum;
%N�o � mais a partir da 3D
problem.reward2D(:,:) = -1;
problem.reward2D(26,7) = 35;
problem.reward2D(37,5) = 35;
problem.reward2D(39,4) = 35;
problem.reward2D(50,2) = 35;

end

