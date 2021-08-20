  % % % This function will turn off the laser 
        function  turnOFFdevice(obj)
            %%% To turn off the laser
            
            if(obj.isLaserON == 1)
            %% To turn OFF the LASER 
                [err, y] = calllib('NKTPDLL', 'registerWriteU8', obj.portName, obj.addressModuleTypeLaserSource,...
                        obj.regID_ONandOFF, obj.valueTurnOFF_Laser, -1);  
            else
                disp('Laser is already ON');
                err = -1;
            end
            

            %%
            if (err == 0 && obj.isLaserON == 1)
                obj.isLaserON = 0;
                disp('Laser is turn off');
            end 

             
        end