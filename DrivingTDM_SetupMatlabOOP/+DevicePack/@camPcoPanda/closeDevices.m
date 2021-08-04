  function closeDevices(obj)
        disp('Acquisition complete');
      
        if(obj.glvar.camera_open==1)
            obj.glvar.do_close=1;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% To reset all the parameters to the default values
            errorCode = calllib('PCO_CAM_SDK', 'PCO_ResetSettingsToDefault' ,obj.out_ptr);
            if(errorCode == 0)
                disp('Camera is reset to default settings');
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.glvar.do_libunload=1;
            pco_camera_open_close(obj.glvar);
        end
        
        imaqreset;  %% IT WILL RELEASE THE CAMEAR FROM MATLAB FORCEFULLY
        
        
        disp('Camera shutdown');
            
end