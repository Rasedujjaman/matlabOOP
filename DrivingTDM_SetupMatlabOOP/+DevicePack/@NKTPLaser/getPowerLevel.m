

%%% function to display the port name where the laser is connected

function obj = getPowerLevel(obj)
    disp(['Power level of the Laser is: ', num2str(obj.powerLevel), '%']);
end