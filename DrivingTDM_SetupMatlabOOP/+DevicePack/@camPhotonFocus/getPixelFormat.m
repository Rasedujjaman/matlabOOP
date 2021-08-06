%%%% This function will set the pixel format of the camera
%%%% Not recomended to use
function pixel_format =  getPixelFormat(obj)
        
                pixel_format = obj.vid.PixelFormat; %% return the pixel format
                disp(pixel_format);
                
end
