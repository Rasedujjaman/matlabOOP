
function [outImageFrame] = getImageFrame(obj)
% %     [errorCode, outImageFrame] = pco_sdk_example_single();   %% Grab and display a single image 
    
%%%% Here we will use a predefined function called 'pco_camera_stack' that
%%%% resides in /headerAndFunctionsPcoPanda/scripts/

[errorCode,ima,metadata, glvar]=pco_camera_stack(1,obj.glvar);  %%% function to grab one image frame
outImageFrame = ima;  
obj.glvar = glvar;
% % [errorCode, outImageFrame] = grabSingleImage(obj);
end
