
%%%% This function will turn on the LASER Source

function obj = turnONdevice(obj)
%%%% To turn on the laser
[err, y] = calllib('NKTPDLL', 'registerWriteU8', obj.portName, obj.addressModuleTypeLaserSource,...
    obj.regID_ONandOFF, obj.valueTurnON_Laser, -1); %% To turn ON the LASER

if (err == 0)
    disp('Laser is ON');
end
end
