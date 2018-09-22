function [ maxarray, maxindex ] = MaxArray( array1, array2 )
%MaxARRAY Summary of this function goes here
%   Detailed explanation goes here


%array1 = VPActual' .* pRiver2.transition(11, :, 2)
%array2 = VPActual' .* pRiver2.transition(11, :, 3)

    sum1 = sum(vpa(array1));
    sum2 = sum(vpa(array2));
    
    
    if(int8(sum1 >= sum2))
        maxarray = array1;
        maxindex = 1;
    else
        maxarray = array2;
        maxindex = 2;
    end;

end


