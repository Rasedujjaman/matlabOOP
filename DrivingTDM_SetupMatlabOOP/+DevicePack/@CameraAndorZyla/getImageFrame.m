  
%%%% The function will perform the actual image capure
function outImageFrame = getImageFrame(obj)

            [rc] = AT_QueueBuffer(obj.hndl,obj.imageSize);
% %             AT_CheckWarning(rc);
            [rc] = AT_Command(obj.hndl,'SoftwareTrigger');
% %             AT_CheckWarning(rc);
            [rc,buf] = AT_WaitBuffer(obj.hndl,1000);
% %             disp('Toto');
% %              pause(obj.getExposureTime()*20);  %% Wait to transfer back the image from camera to workspace
% % 
           

            [rc,outImageFrame] = AT_ConvertMono16ToMatrix(buf,obj.height,obj.width, obj.stride);
             AT_CheckWarning(rc);
             

             obj.Image = outImageFrame;  %% Update the variable containing the image 
             
             pause((obj.getExposureTime() + obj.getReadoutTime()));
            
 end