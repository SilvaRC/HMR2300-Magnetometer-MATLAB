%% This function was designed by 
% Rodrigo Cardoso da Silva
% University of Brasilia
% Faculty of Technology
% Department of Electrical Engineering
% Last update: 12/03/2018

%% This function is responsible for
% Connecting to the HMR2300 Magnetometer from Honeywell

%% INPUTS AND OUTPUTS
% Outputs:
% HMR2300_sensor - Configured serial communication object
% Inputs:
% comPort - Serial communication port to which the sensor is connected in
% the computer.
% Observation: Verify in the Device Manager (Win) or analog for the comPort
% Recommended software: Termite, for serial communication tests outside
% MATLAB environment.
function [HMR2300_sensor, erro] = HMR2300_connect(comPort, init_baudrate)
    erro = 1; %Error flag initially set as 1
    
    %% Clearing connection environment
    % Comment this if-statement when multiple instruments may be used.
    %if ~isempty(instrfind)
    %    fclose(instrfind);
    %    delete(instrfind);
    %end
    
    %% Configuration parameters
    rate=init_baudrate; % Communication rate: 9600 or 19200 (bps) (configurable, see datasheet)

    %% Serial communication object and its configuration
    HMR2300_sensor=serial(comPort);
    set(HMR2300_sensor,'DataBits',8);
    set(HMR2300_sensor,'StopBits',1);
    set(HMR2300_sensor,'BaudRate', rate);
    set(HMR2300_sensor,'Parity','none');
    set(HMR2300_sensor,'Terminator','CR');
    fopen(HMR2300_sensor);
    
    %% Communication test
    %If the command sent has 10 characters after an asterisk '*',
    %the sensor will answer with the "Re-enter" string (see datasheet).
    fprintf(HMR2300_sensor,'%s\n','*00H'); % Ensure that the ID number is correct (*idH*)
    pause(0.02);
    a='1234567890123456789';
    sensor_hardware_version='H/W vers: 2.0 Rev A';
    while(strcmp(a(1:19),sensor_hardware_version)==0)
        a=fgetl(HMR2300_sensor);
    end
    if(strcmp(a(1:19),sensor_hardware_version)==1)
        disp('serial read')
        mbox = msgbox('Serial Communication setup'); uiwait(mbox);
        erro = 0; %Communication succeeded, error flag set as 0 
    end
    
    %% Boost Baud rate!
    % Send '*01WE' and '*01!BR=F' commands to set Baudrate to 19200 bps
end