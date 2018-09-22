function [ saidaVl, saidaI ] = MaxTudo( matrixT )
%MAXTUDO Summary of this function goes here
%   Detailed explanation goes here

%matrixT = VAArray;
sizeDims = size( matrixT );

%Trabalha apenas com o 11 (problemático)
%C = reshape( matrixT(11, :, :), [5, 21]); %Ambos comandos fazem igual
%dim1 = 11;
saidaVl = NaN(1,sizeDims(1));
saidaI = NaN(1,sizeDims(1));

for dim1 = 1:sizeDims(1) %dim1 = 2
    C = squeeze(matrixT(dim1, :, :));
    for dim2 = 1:sizeDims(2)
        if dim2 == 1
            maiorAcao = dim2;
        else
            if ComparaVetores(C(maiorAcao,:) , C(dim2,:) ) ~= 1
                maiorAcao = dim2;
            end
        end
    end
    
    saidaVl = 0.0;
    saidaI(dim1) = maiorAcao;

end; %end for
end %function

