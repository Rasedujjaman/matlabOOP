
%%%% This function will turn on the LASER Source

function obj = turnONdevice(obj)
%%%% To turn on the laser
    if(obj.isLaserON == 0)
        [err, y] = calllib('NKTPDLL', 'registerWriteU8', obj.portName, obj.addressModuleTypeLaserSource,...
        obj.regID_ONandOFF, obj.valueTurnON_Laser, -1); %% To turn ON the LASER
    else
        disp('Laser is already ON');
        err = -1;
    end

    if (err == 0 && obj.isLaserON == 0)
        obj.isLaserON = 1;
        disp('Laser is ON');
    end
end
