
%%% This function will generate the RGB value depending on the wavelenght
%%% (in nm) provided (the visible color)

function obj = getRGBtriplet(obj, lambda)

    if nargin < 2
        w = obj.waveLength;  %% Read the wavelength from the object
    else
        w = lambda;
    end
 
 
    if (w >= 380 && w < 440)
        obj.R = -(w - 440) / (440 - 380);
        obj.G = 0.0;
        obj.B = 1.0;
    elseif( w >= 440 && w < 490)
        obj.R = 0.0;
        obj.G = (w - 440) / (490 - 440);
        obj.B = 1.0;
    elseif( w >= 490 && w < 510)
        obj.R = 0.0;
        obj.G = 1.0;
        obj.B = -(w - 510) / (510 - 490);
    elseif( w >= 510 && w < 580)
        obj.R = (w - 510) / (580 - 510);
        obj.G = 1.0;
        obj.B = 0.0;
    elseif( w >= 580 && w < 645)
        obj.R = 1.0;
        obj.G = -(w - 645) / (645 - 580);
        obj.B = 0.0;
    elseif( w >= 645 && w <= 780)
        obj.R = 1.0;
        obj.G = 0.0;
        obj.B = 0.0;
    else
        obj.R = 0.0;
        obj.G = 0.0;
        obj.B = 0.0;

    end

end