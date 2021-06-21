

%%% The program is to test the Dac class
clear all
close all

dq = Dac;
% % dq.setVoltageMode();
% % dq.putVoltage();
% % dq.setVoltageMode();
dq.voltChannelX = 0.5;
dq.voltChannelY = 0.6;

%%% This putVoltage function is overloaded
dq.putVoltage();
dq.putVoltage(0,0);  
dq.putVoltage(0.4, 0.3);
dq.putVoltage(0);






