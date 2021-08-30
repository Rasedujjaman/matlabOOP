
%%% This function will display the wavelength of the laser output beam

function lambda = getWavelength(obj)

    lambda = obj.waveLength;    
    disp(['The wavelength is ', num2str(obj.waveLength), 'nm']);
end