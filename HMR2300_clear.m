%% This function was designed by 
% Rodrigo Cardoso da Silva
% University of Brasilia
% Faculty of Technology
% Department of Electrical Engineering
% Last update: 17/10/2017

%% This function is responsible for
% Clearing serial connections

%% INPUTS AND OUTPUTS
% Outputs:
% N/A
% Inputs:
% N/A

function [] = HMR2300_clear()
    if ~isempty(instrfind)
        fclose(instrfind);
        delete(instrfind);
    end
end