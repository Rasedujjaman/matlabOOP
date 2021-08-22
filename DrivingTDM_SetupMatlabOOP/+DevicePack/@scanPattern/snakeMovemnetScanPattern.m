

function snakeMovemnetScanPattern(obj)

ch0_scan = linspace(obj.sval_ch0_min, obj.sval_ch0_max  , obj.no_scan_ch0);
ch0_step = ch0_scan(end) - ch0_scan(end-1);

ch1_scan = linspace(obj.sval_ch1_max, obj.sval_ch1_min, obj.no_scan_ch1);
ch0_step = ch1_scan(end) - ch1_scan(end-1);


ch0_scan_matrix = zeros(obj.no_scan_ch0, obj.no_scan_ch0);
for ii=1:no_scan_ch0
for jj = 1:no_scan_ch0
    ch0_scan_matrix(jj,ii) = ch0_scan(ii);
end
end

ch1_scan_matrix = zeros(obj.no_scan_ch1, obj.no_scan_ch1);
for ii=1:no_scan_ch1
for jj = 1:no_scan_ch1
    ch1_scan_matrix(ii,jj) = ch1_scan(ii);
end
end

%%
sz_row = size(ch0_scan_matrix,1);
        sz_col = size(ch0_scan_matrix,1);

        for ii = 1:sz_row 
        for jj = 1:sz_col
            if(mod(ii,2) == 0)
                mask0_odd(ii,jj) = 1;
                mask0_even(ii,jj) = 0;
            else
                mask0_odd(ii,jj) = 0;
                mask0_even(ii,jj) = 1;
            end
        end
        end


% % mask0_odd : keeps the elements in the even rows and make zeros the odd rows
% % mask1_even : keeps the elements in the odd rows and make zeros the even rows

        temp_mat1_ch0 = ch0_scan_matrix.*mask0_odd;
        temp_mat2_ch0 = ch0_scan_matrix.*mask0_even;
        temp_mat1_ch0 = fliplr(temp_mat1_ch0);


        temp_mat1_ch1 = ch1_scan_matrix.*mask0_odd;
        temp_mat2_ch1 = ch1_scan_matrix.*mask0_even;
        temp_mat1_ch1 = fliplr(temp_mat1_ch1);


        ch0_scan_matrix = temp_mat1_ch0 + temp_mat2_ch0;
        ch1_scan_matrix = temp_mat1_ch1 + temp_mat2_ch1;
        
        voltage_ch0_scan = ch0_scan_matrix';
        obj.voltage_ch0_scan = voltage_ch0_scan(:);

        voltage_ch1_scan = ch1_scan_matrix';
        obj.voltage_ch1_scan = voltage_ch1_scan(:);
        
        disp('Snake motion type pattern is selected');

end