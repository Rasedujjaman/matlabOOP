

function rasterScanPattern(obj)

ch0_scan = linspace(obj.sval_ch0_min, obj.sval_ch0_max, obj.no_scan_ch0);
ch0_step = ch0_scan(end) - ch0_scan(end-1);

ch1_scan = linspace(obj.sval_ch1_max, obj.sval_ch1_min, obj.no_scan_ch1);
ch0_step = ch1_scan(end) - ch1_scan(end-1);


ch0_scan_matrix = zeros(obj.no_scan_ch0, obj.no_scan_ch0);
for ii=1:obj.no_scan_ch0
for jj = 1:obj.no_scan_ch0
    ch0_scan_matrix(jj,ii) = ch0_scan(ii);
end
end

ch1_scan_matrix = zeros(obj.no_scan_ch1, obj.no_scan_ch1);
for ii=1:obj.no_scan_ch1
for jj = 1:obj.no_scan_ch1
    ch1_scan_matrix(ii,jj) = ch1_scan(ii);
end
end


voltage_ch0_scan = ch0_scan_matrix';
obj.voltage_ch0_scan = voltage_ch0_scan(:);

voltage_ch1_scan = ch1_scan_matrix';
obj.voltage_ch1_scan = voltage_ch1_scan(:);

disp('Raster scan is selected');
end