classdef CNumero < handle
    %CNUMERO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        digitos = 10;
        sinal = 0;
        valoresInt = zeros(1000,1);
        valoresDec = zeros(1000,1);
    end
    
    methods
        function obj = CNumero(vlInicial)
            if vlInicial == 0
                return;
            end;

            %Decompoe o sinal
            if(vlInicial > 0.0); obj.sinal = 1.0; else obj.sinal = -1.0; vlInicial = vlInicial * -1; end;
            
            %Pega os inteiros
            vlstr = num2str(vlInicial, '%500.9f');
            cont = 1;
            for i = (length(vlstr)-10):-10:1
                obj.valoresInt(cont,1) = str2double(    vlstr(max(i-9,1):i)   );
                cont = cont+1;
            end
            
            %Pega os decimais
            vlstr = num2str(mod(vlInicial, 1), '%0.200f');
            cont = 1;
            for i = 2:10:length(vlstr)
                obj.valoresDec(cont,1) = str2double(    vlstr(i:min(i+9,length(vlstr)))   );
                cont = cont+1;
            end
            
            if obj.sinal == -1
                obj.valoresInt = obj.valoresInt .* obj.sinal;
                obj.valoresDec = obj.valoresInt .* obj.sinal;
            end;
            
        end
        
        function somaObj = somaObj(obj, vl2)
            somaObj = CNumero(0);
            if obj.sinal == vl2.sinal || obj.sinal == 0 || vl2.sinal == 0
                if obj.sinal ~= 0
                    somaObj.sinal = obj.sinal;
                else
                    somaObj.sinal = vl2.sinal;
                end
                somaObj.valoresInt = obj.valoresInt + vl2.valoresInt;
                somaObj.valoresDec = obj.valoresDec + vl2.valoresDec;
            else
                error( 'Nao foi feito soma para sinais diferentes')
            end;
        end
        
        function maior = maior(obj, vl2)
            % 1 - Testa pelos sinais
            if obj.sinal ~= vl2.sinal
                if obj.sinal == 1; maior = 1; else maior = 2; end;
                return;
            end;
            
            %2 - testa pelos inteiros
            diferenca = obj.valoresInt - vl2.valoresInt;
            maiorRelevante = max( (diferenca ~= 0)' .* (1:1000));
            
            if maiorRelevante ~= 0
                if diferenca(maiorRelevante) > 0
                    maior = 1;
                    %if obj.sinal == -1; maior = 2; end;
                    return;
                end;
                if diferenca(maiorRelevante) < 0
                    maior = 2;
                    %if obj.sinal == -1; maior = 1; end;
                    return;
                end;
            end;
            
            %3 - testa pelos decimais
            diferenca = obj.valoresDec - vl2.valoresDec;
            maiorRelevante = max( (diferenca ~= 0)' .* (1000:-1:1));
            
            if maiorRelevante ~= 0
                if diferenca(1001 - maiorRelevante) > 0
                    maior = 1;
                    %if obj.sinal == -1; maior = 2; end;
                    return;
                end;
                if diferenca(1001 - maiorRelevante) < 0
                    maior = 2;
                    %if obj.sinal == -1; maior = 1; end;
                    return;
                end;
            end;
            
            %Final da funcao, tudo igual, entao retorna 1 mesmo
            maior = 1;
        end
        
    end
    
    
    
    
    
end

