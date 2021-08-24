
function circularTIR(obj)


        radius = obj.radiusCircle;
        no_circle = 5;
        r_step = radius/no_circle;
        r = radius:-r_step:0;
        
        phiStep = 15;  %%% Chose this value to change the step size 
        phiTotal = 360;
        
        
        
        th_outmost = 0:phiStep:(phiTotal-phiStep);
    
        
       
        
        for ii= 1:size(th_outmost,2)
            temp = th_outmost(ii);
            volt_th_outmost_ch0(ii) = r(1)*sind(temp);
            volt_th_outmost_ch1(ii) = r(1)*sqrt(1.7777)*cosd(temp);
            
        end
            
       
        volt_ch0 = volt_th_outmost_ch0;
        
        volt_ch1 = volt_th_outmost_ch1;
        
        
% %         voltage_ch0_scan = volt_ch0; %% the original
% %         voltage_ch1_scan = volt_ch1;

        voltage_ch0_scan = volt_ch0  + 0.15;  % % this 0.15 volt is applied to shift the specular globally to the right 
                                                % % (+x direction)
                                               
        voltage_ch1_scan = volt_ch1; 
        
        obj.voltage_ch0_scan = voltage_ch0_scan(:);
        obj.voltage_ch1_scan = voltage_ch1_scan(:);
         
        disp('Circular pattern (out most circle) is selected');

        
        obj.phiOutMost = th_outmost;  

end