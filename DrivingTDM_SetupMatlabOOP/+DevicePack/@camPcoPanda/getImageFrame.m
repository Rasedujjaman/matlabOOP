
function outImageFrame = getImageFrame(obj)
% %     [errorCode, outImageFrame] = pco_sdk_example_single();   %% Grab and display a single image 
    
% %  subfunc=pco_camera_subfunction();  
[errorCode,ima,metadata,obj.glvar]=pco_camera_stack(1,obj.glvar);  %%% function to grab one image frame
outImageFrame = ima;       
% % [errorCode, outImageFrame] = grabSingleImage(obj);
end
