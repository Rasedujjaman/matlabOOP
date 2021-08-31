

%%% function to display the port name where the laser is connected

function nameComPort = getPortName(obj)
    disp(['Laser is connected to port: ', obj.portName]);
    nameComPort = obj.portName;
    
end