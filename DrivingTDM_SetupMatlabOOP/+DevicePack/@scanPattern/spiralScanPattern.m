
function  spiralScanPattern(obj)

        radius = obj.radiusSpiral; % max value of channel#0 
        
        no_spiral = 5; % the number of spiral
        a = 0.0012; % constant to control the values of each spiral


        th_inner5  =  0:5:360;
        th_inner4  = 0:10:360;
        th_inner3  = 0:15:360;
        th_inner2  = 0:20:360;
        th_inner1  = 0:30:360;


        sz_voltage = size(th_inner1,2)+size(th_inner2,2)+ size(th_inner3,2)...
                +size(th_inner4,2)+size(th_inner5,2);
            
        voltage_ch0_scan = zeros(1, sz_voltage);
        voltage_ch1_scan = zeros(1, sz_voltage);



        x_old = 0;
 
        for ii = 1:no_spiral

            th_string =  ['th_inner',num2str(ii)];

            theta_temp = eval(th_string , int2str(ii));

            r_temp =  a*theta_temp + x_old;

            x = r_temp.*cosd(theta_temp);
            y = sqrt(1.7777)*r_temp.*sind(theta_temp);

            mm{ii} = x;
            nn{ii} = y;
            x_old = x(end);

        end

        volt_ch0 =  [mm{1} mm{2} mm{3} mm{4} mm{5}];
        volt_ch1 =  [nn{1} nn{2} nn{3} nn{4} nn{5}];

        obj.voltage_ch0_scan = volt_ch0(:);
        obj.voltage_ch1_scan = volt_ch1(:);
        
        disp('Spiral pattern is selected');
% %         disp(voltage_ch0_scan)
%         disp(voltage_ch1_scan) 



end