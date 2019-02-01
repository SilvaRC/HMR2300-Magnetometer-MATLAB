%% This function was designed by 
% Rodrigo Cardoso da Silva and João Victor Lopes de Loiola
% University of Brasilia
% Faculty of Technology
% Department of Electrical Engineering
% Last update: 17/10/2017

%% This function is responsible for
% Reading a value from the HMR2300 magnetometer (ASCII conversion method)

%% INPUTS AND OUTPUTS
% Outputs:
% BX, BY, BZ - Magnetometer readings (Gauss)
% Inputs:
% HMR2300_sensor - Serial communication object

function [BX, BY, BZ] = HMR2300_read(HMR2300_sensor)
    data=[];
    %% Send data request
    while size(data,2) ~= 27
        fprintf(HMR2300_sensor, '%s\n', '*00P');
        pause(0.15); %delay (observation: must be at least equal to 7 reading clocks (see datasheet).
        data=fgetl(HMR2300_sensor);
        if ((data(4)~=','))%||(data(13)~=',')||(data(22)~=','))
            data=[];
            continue;
        end
    end        

    %% Convert ASCII data to integers
    % Observation: see datasheet to understand the indexes below 
    % (data is given in a 28-byte format) 
    BX=str2num([data(1:3) '.' data(5:7)]);
    BY=str2num([data(10:12) '.' data(14:16)]);
    BZ=str2num([data(19:21) '.' data(23:25)]);
    
    %% Multiply values by 1000 factor (',' in the data is not a decimal point)
    % and convert from ASCII data scale (-30,000 to 30,000) to Gauss scale (-2 to 2)
    % (see datasheet)
    BX=BX/15; % equivalent to multiplying by 1000 and dividing by 15000
    BY=BY/15;
    BZ=BZ/15;
end