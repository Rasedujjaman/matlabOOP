%%%% This function will set the pixel format of the camera
%%%% Not recomended to use
function obj = setPixelFormat(obj, pixel_format)
         isValidString = strcmp(pixel_format, obj.authorized_pixelFormat);
            [~,idx] = find(isValidString == 1);
            if isempty(idx) %Invalid pixel format is given
                disp('Invalid pixel format, Allowed values: "Mono8", "Mono10", "Mono12"');
            else
                obj.vid.PixelFormat = pixel_format; %% set the pixel format
                obj.pixelFormat = pixel_format;  %% update the class properties
                disp('Pixel format is set properly');
            end
end
