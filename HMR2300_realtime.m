%% This function was designed by 
% Rodrigo Cardoso da Silva and João Victor Lopes de Loiola
% University of Brasilia
% Faculty of Technology
% Department of Electrical Engineering
% Last update: 17/10/2017

%% This function is responsible for
% Real-time plot and data acquisition from HMR2300 sensor

%% INPUTS AND OUTPUTS
% Outputs:
% BX, BY, BZ - Magnetometer readings (Gauss)
% time - time vector (seconds)
% intervals - intervals between measurements (vector, seconds)
% Inputs:
% comPort - Serial communication port to which the HMR2300 is connected to
% iterations - desired number of measurements
% Observation: The sampling time is adjustable (variable Ts)

function [BX, BY, BZ, time, intervals] = HMR2300_realtime(comPort, iterations)
    %% Output variables - memmory preallocation
    BX = zeros(iterations,1,'double');
    BY = zeros(iterations,1,'double');
    BZ = zeros(iterations,1,'double');
    intervals=zeros(iterations,1,'double');
    time = zeros(iterations,1,'double');
    
    %% Connect to the HMR2300 sensor
    sensor=HMR2300_connect(comPort);

    tic;
    Ts=0.2; % Sampling time (configurable)
    i=1;
    while i<=iterations
        time(i) = toc;
        if i > 1
            intervals(i) = toc - time(i-1);
            while intervals(i) < Ts
                intervals(i) = toc - time(i-1);
            end
        else
            intervals(i)=toc;
        end
        time(i) = toc;
        
        %% Send data request and get measurements
        [BX(i), BY(i), BZ(i)]=HMR2300_read(sensor); %Unit: Gauss. Obs.: to_microTesla_factor=*100
        
        %% Conversion from Gauss to microTesla
        BX(i)=100*BX(i);
        BY(i)=100*BY(i);
        BZ(i)=100*BZ(i);
        
        %% Real time plot
        if i==1
            handle=figure;
            set(handle,'Position',[692 (49+636/2) 667 636/2]);% Posição da figura na tela do PC (pixels) [left bottom width height]
            subplot(3,1,1);
            BX_graph=plot(time,BX);
            axis([0 10 -220 220]);
            xlabel('Time(s)');
            ylabel('B_X (\mu T)');
            current_BX = text(10, 245, sprintf('B_X = %.2f \mu T',BX(i)),'horizontalAlignment','right');
            
            subplot(3,1,2);
            BY_graph=plot(time,BY);
            axis([0 10 -220 220]);
            xlabel('Time(s)');
            ylabel('B_Y (\mu T)');
            current_BY = text(10, 245, sprintf('B_Y = %.2f \mu T',BY(i)),'horizontalAlignment','right');
            
            subplot(3,1,3);
            BZ_graph=plot(time,BZ);
            axis([0 10 -220 220]);
            xlabel('Time(s)');
            ylabel('B_Z (\mu T)');
            current_BZ = text(10, 245, sprintf('B_Z = %.2f \mu T',BZ(i)),'horizontalAlignment','right');            
            current_iteration = text(10,-245, sprintf('Current Iteration = %d',i),'horizontalAlignment','right');
        else
            figure(handle);
            subplot(3,1,1);
            set(BX_graph, 'XData', time(1:i));
            set(BX_graph, 'YData', BX(1:i));
            if time(i)>10
                set(current_BX,'string', (sprintf('Current B_X = %.2f',BX(i))), 'Position', [time(i), 245, 0]);
                axis([time(i)-10 time(i) -220 220]);
            else
                set(current_BX,'string', (sprintf('Current B_X = %.2f',BX(i))), 'Position', [10, 245, 0]);
                axis([0 10 -220 220]);
            end
            
            subplot(3,1,2);
            set(BY_graph, 'XData', time(1:i));
            set(BY_graph, 'YData', BY(1:i));
            if time(i)>10
                set(current_BY,'string', (sprintf('Current B_Y = %.2f',BY(i))), 'Position', [time(i), 245, 0]);
                axis([time(i)-10 time(i) -220 220]);
            else
                set(current_BY,'string', (sprintf('Current B_Y = %.2f',BY(i))), 'Position', [10, 245, 0]);
                axis([0 10 -220 220]);
            end
            
            subplot(3,1,3);
            set(BZ_graph, 'XData', time(1:i));
            set(BZ_graph, 'YData', BZ(1:i));
            if time(i)>10
                set(current_BZ,'string', (sprintf('Current B_Z = %.2f',BZ(i))), 'Position', [time(i), 245, 0]);
                set(current_iteration, 'string', (sprintf('Current Iteration = %d',i)), 'Position', [time(i), -245, 0]);
                axis([time(i)-10 time(i) -220 220]);
            else
                set(current_BZ,'string', (sprintf('Current B_Z = %.2f',BZ(i))), 'Position', [10, 245, 0]);
                set(current_iteration, 'string', (sprintf('Current Iteration = %d',i)), 'Position', [10, -245, 0]);
                axis([0 10 -220 220]);
            end
        end
        i=i+1;
    end
    
    %% Saves collected data and closes graphs
    current_time=clock;
    filename='magnetometer-data_';
    filename=[filename num2str(current_time(1)) '-' num2str(current_time(2))...
    '-' num2str(current_time(3)) '-' num2str(current_time(4)) 'h-'...
    num2str(current_time(5)) 'min-' num2str(current_time(6)) 's.mat'];
    close(handle);   
    save(filename);    
    clc;clear all; close all;
end