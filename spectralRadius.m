function [ retValue ] = spectralRadius( matrix )
%SPECTRALRADIUS Summary of this function goes here
%   Detailed explanation goes here

% Encontrado em: (páginas 227 e 228)
% https://books.google.com.br/books?id=QWub-UVGxqkC&pg=PA228&lpg=PA228&dq=matlab+spectral+radius&source=bl&ots=ylxokO_b7Z&sig=kuuPVOSuqV_z6yeVSUbNPfGg8z4&hl=pt-BR&sa=X&ved=0ahUKEwjan9mpkYrRAhVLHZAKHXwIBi4Q6AEIdDAJ#v=onepage&q=matlab%20spectral%20radius&f=false
%
    %retValue = max( eig(matrix) ) ;
    
    
    %Variação de código
    %http://marian.fsik.cvut.cz/NM/Amat1.html
    retValue = max(abs(eig(matrix))) ;
    %retValue = max(abs(eigs(matrix,20))) ;
end

