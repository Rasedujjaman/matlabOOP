
function circularScanPattern(obj)


        radius = obj.radiusCircle;
        no_circle = 5;
        r_step = radius/no_circle;
        r = radius:-r_step:0;
        
        
        th_outmost = 0:10:350;
        th_inner1  = 0:10:350;
        th_inner2  = 0:15:345;
        th_inner3  = 0:20:340;
        th_inner4  = 0:30:330;
        th_inmost  = 0;
        
        sz_voltage = size(th_outmost,2)+size(th_inner1,2)+ size(th_inner2,2)...
            +size(th_inner3,2)+size(th_inner4,2)+size(th_inmost,2);
        
        voltage_ch0_scan = zeros(1, sz_voltage);
        voltage_ch1_scan = zeros(1, sz_voltage);
        
        for ii= 1:size(th_outmost,2)
            temp = th_outmost(ii);
            volt_th_outmost_ch0(ii) = r(1)*sind(temp);
            volt_th_outmost_ch1(ii) = r(1)*sqrt(1.7777)*cosd(temp);
            
        end
            
        for ii= 1:size(th_inner1,2)
            temp = th_inner1(ii);
            volt_th_inner1_ch0(ii) = r(2)*sind(temp);
            volt_th_inner1_ch1(ii) = r(2)*sqrt(1.7777)*cosd(temp);
            
        end
        
        
        for ii= 1:size(th_inner2,2)
            temp = th_inner2(ii);
            volt_th_inner2_ch0(ii) = r(3)*sind(temp);
            volt_th_inner2_ch1(ii) = r(3)*sqrt(1.7777)*cosd(temp);
            
        end
        
        
        for ii= 1:size(th_inner3,2)
            temp = th_inner3(ii);
            volt_th_inner3_ch0(ii) = r(4)*sind(temp);
            volt_th_inner3_ch1(ii) = r(4)*sqrt(1.7777)*cosd(temp);
            
        end
        
        for ii= 1:size(th_inner4,2)
            temp = th_inner4(ii);
            volt_th_inner4_ch0(ii) = r(5)*sind(temp);
            volt_th_inner4_ch1(ii) = r(5)*sqrt(1.7777)*cosd(temp);
            
        end
        
        
        for ii= 1:size(th_inmost,2)
            temp = th_inmost(ii);
            volt_th_inmost_ch0(ii) = r(6)*sind(temp);
            volt_th_inmost_ch1(ii) = r(6)*sqrt(1.7777)*cosd(temp);
            
        end
        
        
        
        
        volt_ch0 = [volt_th_outmost_ch0, volt_th_inner1_ch0, volt_th_inner2_ch0, volt_th_inner3_ch0, ...
            volt_th_inner4_ch0, volt_th_inmost_ch0];
        
        volt_ch1 = [volt_th_outmost_ch1, volt_th_inner1_ch1, volt_th_inner2_ch1, volt_th_inner3_ch1, ...
            volt_th_inner4_ch1, volt_th_inmost_ch1];
        
        
% %         voltage_ch0_scan = volt_ch0; %% the original
% %         voltage_ch1_scan = volt_ch1;

        voltage_ch0_scan = volt_ch0  + 0.15;  % % this 0.15 volt is applied to shift the specular globally to the right 
                                                % % (+x direction)
                                               
        voltage_ch1_scan = volt_ch1; 
        
        obj.voltage_ch0_scan = voltage_ch0_scan(:);
        obj.voltage_ch1_scan = voltage_ch1_scan(:);
        
% %         sz_ch0 = size(voltage_ch0_scan,1);
       
        disp('Circular pattern is selected');
% %         disp(sz_ch0)
% %         disp(voltage_ch0_scan)



end