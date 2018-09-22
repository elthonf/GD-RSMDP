classdef CMDPGrid < CMDPSimples
    %CMDPGrid Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mapView = []  %Variável com o MAPA VISUAL dos estados (sem utilização em cálculos)
        maskAdjacent = [] %Máscara com as adjcencias (1 = true, 0 = false) (s,s')
        maskActions = [] %Máscara com os possíveis transições (s, s', a)
    end
    
    %Construtores
    methods
        function obj = CMDPGrid(nAltura, nLargura)
            %Método contrutor
            %Gera uma matriz N x M com 8 possíveis movimentos e uma ação
            %   extra que é ficar parado
            obj = obj@CMDPSimples(nAltura * nLargura, 9);
            
            %02 - RE-Generate States named "s{n,m}"
            %Para Cell usa-se problem.states{i}
            obj.mapView = zeros(nAltura, nLargura);
            i = 1;
            for n=1:nAltura
                for m=1:nLargura
                    obj.states(i).code = i;
                    obj.states(i).name = strcat('s{', num2str(n), ',', num2str(m), '}');
                    obj.states(i).value = 0;
                    obj.states(i).aux1 = n; %aux1 mantem o número da linha
                    obj.states(i).aux2 = m; %aux1 mantem o número da coluna
                    obj.mapView(n, m) = i;
                    i = i + 1;
                end
            end
            
            %02 - RE-Generate Actions
            actions = { 'NW', 'N', 'NE', 'W', 'E', 'SW', 'S', 'SE', 'WAIT' };
            moveV = [   -1,   -1,  -1,    0,   0,   1,    1,   1,    0 ];
            moveH = [   -1,    0,   1,   -1,   1,  -1,    0,   1,    0 ];
            for i = 1:obj.nActions
                obj.actions(i).code = i;
                obj.actions(i).name = actions(i);
                obj.actions(i).value = 0;
                obj.actions(i).aux1 = moveV(i); %aux1 = o quanto se move VERTICALMENTE
                obj.actions(i).aux2 = moveH(i); %aux2 = o quanto se move HORIZONTALMENTE
            end
            
            %03 - Gera MÁSCARA DE ADJACENCIA (1 com possível, 0 com não pode para todas as ações!)
            maskAdj = zeros(obj.nStates, obj.nStates, obj.nActions);
            for s = 1:obj.nStates
                oS = obj.states(s); %Objeto S (para encurtar comandos)

                if( oS.aux1 -1 > 0); maskAdj(s, s - nLargura, :) = 1.0; end;%adjacente em N
                if( oS.aux1 -1 > 0 && oS.aux2 -1 >0); maskAdj(s, s - nLargura -1, :) = 1.0; end;%adjacente em NW
                if( oS.aux1 -1 > 0 && oS.aux2 +1 <=nLargura); maskAdj(s, s - nLargura +1, :) = 1.0; end;%adjacente em NE
                if( oS.aux1 +1 <= nAltura); maskAdj(s, s + nLargura, :) = 1.0; end;%adjacente em S
                if( oS.aux1 +1 <= nAltura && oS.aux2 -1 >0); maskAdj(s, s + nLargura -1, :) = 1.0; end;%adjacente em SW
                if( oS.aux1 +1 <= nAltura && oS.aux2 +1 <=nLargura); maskAdj(s, s + nLargura +1, :) = 1.0; end;%adjacente em SE
                if( oS.aux2 -1 >0); maskAdj(s, s -1, :) = 1.0; end;%adjacente em W
                if( oS.aux2 +1 <=nLargura); maskAdj(s, s +1, :) = 1.0; end;%adjacente em E
            end
            obj.maskAdjacent = maskAdj;
            
            %04 - Gera MÁSCARA de movimentos possíveis (1 com possível, 0 com não pode para cada acao!)
            obj.maskActions = zeros(obj.nStates, obj.nStates, obj.nActions);
            for s = 1:obj.nStates
                oS = obj.states(s); %Objeto S (para encurtar comandos)
                for a = 1:obj.nActions
                    oA = obj.actions(a); %Objeto A (para encurtar comandos)

                    %Verifica se o movimento é permitido, se for permitido, joga 1!!
                    if(oS.aux1 + oA.aux1 > 0 && oS.aux1 + oA.aux1 <= nAltura && oS.aux2 + oA.aux2 > 0 && oS.aux2 + oA.aux2 <= nLargura )
                        s2 = obj.states(s).code + (oA.aux1 * nLargura) + oA.aux2; %identifica o destino s2
                        obj.maskActions(s, s2, a) = 1;
                    end
                end
            end
            
            %05 - Gera Matriz de Transicao Básica (s,s',a) que respeita a
            %máscara de Ações
            obj.transition = obj.maskActions .* 1;
            
            %06 - Gera Matriz de Recompensa Básica 3D (s,s',a) e 2D (s,a)
            obj.reward3D = zeros( obj.nStates, obj.nStates, obj.nActions);
            obj.reward2D = zeros( obj.nStates, obj.nActions);
        end
    end
    
    %Gets and Sets
    
    %Auxiliares
    methods
        function setTransition(obj, valueMainAction, valueAdjacent)
            allAdjacent = obj.maskAdjacent .* valueAdjacent;
            allMainActions = obj.maskActions .* (valueMainAction - valueAdjacent);
            allMainActions(:,:,9) = obj.maskActions(:,:,9) .* valueMainAction; %Movimento 9 tem tratamento especial
            
            newTransition = allAdjacent + allMainActions; %Matriz com as probabilidades de movimento (exceto ficar parado)
            
            resto = 1 -  sum(newTransition,2); %Calculará o resto (probabilidade de ficar parado)
            for a = 1:obj.nActions
                restoDiagonal = diag(resto(:,1,a));
                newTransition(:,:,a) =  newTransition(:,:,a) + restoDiagonal; %resto
            end
            
            obj.transition = newTransition;
        end
    end
    
end

