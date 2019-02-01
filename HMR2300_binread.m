%% This function was designed by 
% Rodrigo Cardoso da Silva
% University of Brasilia
% Faculty of Technology
% Department of Electrical Engineering
% Last update: 13/03/2018

%% This function is responsible for
% Reading a value from the HMR2300 magnetometer (binary conversion method)

%% INPUTS AND OUTPUTS
% Outputs:
% BX, BY, BZ - Magnetometer readings (Gauss)
% Inputs:
% HMR2300_sensor - Serial communication object

function [BX, BY, BZ] = HMR2300_binread(HMR2300_sensor)
    data=[];
        
    % Calibration parameters
    FieldMagnitude = 0.2870;
    Scalex = 0.2541;
    Scaley = 0.2673;
    Scalez = 0.2726;
    Offsetx = -0.6501;
    Offsety = 0.0066;
    Offsetz = -0.6161;
    %% Pre-set the sensor to display measurements in binary format
    % Comment these lines for better performance
    
    %display('Readings in binary format')
    %fprintf(HMR2300_sensor, '%s\n', '*01WE'); % Change readings to ASCII format (part 1/2)
    %pause(0.15);
    %data=fgetl(HMR2300_sensor)
    %fprintf(HMR2300_sensor, '%s\n', '*01B'); % Change readings to ASCII format (part 2/2)
    %pause(0.15);
    %data=fgetl(HMR2300_sensor)

    %% Send data request
    fprintf(HMR2300_sensor, '%s\n', '*00P');
    pause(0.003); %delay (observation: must be at least equal to 7 reading clocks (see datasheet).
    data = fread(HMR2300_sensor,7,'uint8');

    if bitget(data(1), 8)
        % If the MSB is 1, number is negative (use 2-complements to determine number)
        BX = uint16(bitsll(data(1),8) + data(2));
        BX = -int16(bitcmp(BX) + 1);
    else
        BX = bitsll(data(1),8) + data(2);
    end
    
    if bitget(data(3), 8)
        % If the MSB is 1, number is negative (use 2-complements to determine number)
        BY = uint16(bitsll(data(3),8) + data(4));
        BY = -int16(bitcmp(BY) + 1);
    else
        BY = bitsll(data(3),8) + data(4);
    end
    
    if bitget(data(5), 8)
        % If the MSB is 1, number is negative (use 2-complements to determine number)
        BZ = uint16(bitsll(data(5),8) + data(6));
        BZ = -int16(bitcmp(BZ) + 1);
    else
        BZ = bitsll(data(5),8) + data(6);
    end
    
    %% Change readings to ASCII format in case verification between ASCII and binary formats is needed
    % Comment these lines after verification
    %display('Readings in ASCII format')
    %fprintf(HMR2300_sensor, '%s\n', '*01WE'); % Change readings to ASCII format (part 1/2)
    %pause(0.15);
    %data=fgetl(HMR2300_sensor)
    %fprintf(HMR2300_sensor, '%s\n', '*01A'); % Change readings to ASCII format (part 2/2)
    %pause(0.15);
    %data=fgetl(HMR2300_sensor)
    %fprintf(HMR2300_sensor, '%s\n', '*01P'); % Request a single measurement of each sensor
    %pause(0.15);
    %data=fgetl(HMR2300_sensor)
    
    %% Convert from ASCII data scale (-30,000 to 30,000) to Gauss scale (-2 to 2)
    % (see datasheet)
    BX=double(BX)/15000; 
    BY=double(BY)/15000;
    BZ=double(BZ)/15000;
    
    %calibration
    BX = ((BX - Offsetx)/Scalex)*FieldMagnitude;
    BY = ((BY - Offsety)/Scaley)*FieldMagnitude;
    BZ = ((BZ - Offsetz)/Scalez)*FieldMagnitude;    
end