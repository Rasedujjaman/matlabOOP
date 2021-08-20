  
%%%% The function will capture one image
function outImageFrame = getImageFrame(obj)
       
        
           outImageFrame = obj.vid.snapshot();
           
           pause(obj.getExposureTime()/1000);
           outImageFrame = (outImageFrame)';   %% Now the first dimension indicates the width of the image
                                               %%% and the second dimension indicates the height of the captured image 
      
           
 end