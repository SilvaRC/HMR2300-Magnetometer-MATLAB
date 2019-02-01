%% This function was designed by 
% Rodrigo Cardoso da Silva
% University of Brasilia
% Faculty of Technology
% Department of Electrical Engineering
% Last update: 22/03/2018

%% This function is responsible for
% Configuring the HMR2300 sensor to work with binary measurements
% and baud rate at 19200bps

%% INPUTS AND OUTPUTS
% Outputs:
% N/A
% Inputs:
% sensor - the sensor object from "HMR2300_connect(_vx).m"
function HMR2300_config(HMR2300_sensor)
    %% Clears buffer
    while 1
        message = fgetl(HMR2300_sensor);
        if exist(message)==0
            break;
        end
    end
    
    %% Gets sensor ID
    fprintf(HMR2300_sensor,'%s\n','*99ID');
    pause(1);
    ID_string = fgetl(HMR2300_sensor);
    ID_char = strread(ID_string,'%s','delimiter',' ');
    display(ID_char(2));
    WE_string = sprintf('*%sWE',char(ID_char(2)));
    Bin_string = sprintf('*%sB',char(ID_char(2)));
    
    %% Set baudrate at 19,200 bps (broadcasts to all sensors connected)
    fprintf(HMR2300_sensor,'%s\n','*99WE');
    display('*99WE');
    pause(1);
    message = fgetl(HMR2300_sensor)    
    
    fprintf(HMR2300_sensor,'%s\n','*99!BR=F');
    display('*99!BR=F');
    pause(1);
    message = fgetl(HMR2300_sensor)
    if strcmp(message, 'OK')==1
        set(HMR2300_sensor, 'BaudRate', 19200);
    end
    
    %% Set binary format
    fprintf(HMR2300_sensor,'%s\n',WE_string);
    display(WE_string);
    pause(1);
    message = fgetl(HMR2300_sensor)    
    
    fprintf(HMR2300_sensor,'%s\n',Bin_string);
    display(Bin_string);
    pause(1);
    message = fgetl(HMR2300_sensor)
end