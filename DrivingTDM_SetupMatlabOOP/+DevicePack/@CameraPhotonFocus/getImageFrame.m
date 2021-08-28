  
%%%% The function will capture one image
function outImageFrame = getImageFrame(obj)

    outImageFrame = obj.vid.snapshot();
    outImageFrame = (outImageFrame)';   %% Now the first dimension indicates the width of the image
                                       %%% and the second dimension indicates the height of the captured image 
    pause((obj.getExposureTime() + obj.getReadoutTime())/1000);

 end