function [ saidaVl, saidaI ] = MaxTeste( matrixT )
%MAXTESTE Summary of this function goes here
%   Detailed explanation goes here

sizeDims = size( matrixT );
%saidaVl = NaN( 1, sizeDims(1) );
saidaVl = sym('a',[1 sizeDims(1)]);
saidaI = NaN( 1, sizeDims(1) );

for i1 = 1:sizeDims(1)
    saidaI(i1) = 0;
    saidaVl(i1) = NaN;
    for i2 = 1:sizeDims(2)
%         soma = vpa(0.0);
%         for i3 = 1:sizeDims(3)
%             soma = soma + vpa(matrixT(i1, i2, i3));
%         end
        soma = sum( vpa( reshape( matrixT(i1, i2, :) , 1, sizeDims(3)) ) );
        
        if(i2==1 || int8( soma > saidaVl(i1)) )
            saidaI(i1) = i2;
            saidaVl(i1) = soma;
        end;
    end
end

end

