
classdef scanPattern  < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties (Access = public)
        %% Properties for Raster scan and Snake movement type 
        
        no_scan_ch0 = 11;     % number of scan along channel # 0
        sval_ch0_min = -1.5;  % minimum scan voltage applied to channel # 0
        sval_ch0_max = 1.5;   % maximum scan voltage applied to channel # 0
        
        %%% The corresponding values for channel # 1
        no_scan_ch1  = 11;
        sval_ch1_min = -2;
        sval_ch1_max = 2;  
        
        
        %% Properties for Circular scan pattern
        radiusCircle = 2.30; % max value of channel#0  %% to make the outer circle closer to the numerical edge
        
        
        %% Properties for Circular scan pattern
        radiusSpiral = 2.25;  % max value of channel#0 
        
        
        %% Properties for Circular(TIR) scan pattern
        phiOutMost;
        radiusCircleTIR = 2.60;
        %%  These voltage will be supplied to the Dac
        voltage_ch0_scan 
        voltage_ch1_scan 
        
    end

    methods
        function obj = scanPattern()
           
            
            
            
            
            
        end

        %%% Function prototype to generate raster scan type pattern
        obj = rasterScanPattern(obj);
        
        %%% Function prototype to generate snake movement type pattern
        obj = snakeMovemnetScanPattern(obj);
        
        %%% Function prototype to generate concentric circular scan type pattern
        obj = circularScanPattern(obj);
        
        
        %%% Function prototype to generate concentric spiral scan type pattern
        obj = spiralScanPattern(obj);
        
        %%% Function prototype to generate Circular (TIR) pattern
        obj = circularTIR(obj);
        
        
        %%% Function prototype to get the phi value for Circular(TIR)
        %%% pattern
        
        phiOutmost = getPhiValue(obj);
        
        
        
        
    end
end