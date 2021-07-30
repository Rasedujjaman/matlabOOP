classdef Optotune < handle
    
    properties (Constant = true)
        Port = "COM5";
        WaitTime = 0.1;
    end
    
    properties (GetAccess = public, SetAccess = public)
        Com; %Communication
        Temperature = 20;
        Current = 0;
        MinCurrent = 0;
        MaxCurrent = 0;
        CurrentRange = 292.84;
        MinFocalPower;
        MaxFocalPower;
        Frequency;
        MinPeriodic;
        MaxPeriodic;
    end

    methods
        function obj = Optotune()
            % Connect to lens Port
            obj.Com = serial(obj.Port);
            % Open communication
            fopen(obj.Com);
            % Say hello to the lens
            fwrite(obj.Com,"Start");
            % Get the answer from the lens
            response = fscanf(obj.Com);
            if ~contains(response,"Ready")
                disp('Error with the connection to the Lens')
            end
            % Read the leftover bites, if any
            if obj.Com.BytesAvailable
                fread(obj);
            end
            % limits for Current Mode
            GetHardMaxCurrent(obj);
            GetSoftMaxCurrent(obj);
            GetSoftMinCurrent(obj);
            % Get limits for Focal Power Mode, and set default mode to Focal Power
            SetModeFocalPower(obj);
        end
        
        %% Temperature
        function GetTemperature(obj)
            % Add CRC to command
            command = obj.append_crc('TA'-0);
            % Send command to Lens
            fwrite(obj.Com, command);
            % Wait a bit for Lens to prepare response
            pause(obj.WaitTime);
            % Get response
            response = fread(obj.Com,obj.Com.BytesAvailable);  % fread(port,number of bytes)
            % Extract temperature in bytes (bytes 4 and 5)
            temperature = response(4)*(hex2dec('ff')+1) + response(5);
            % Multiply by 0.0625 to get temperature in °C
            obj.Temperature = temperature*0.0625;
            disp(obj.Temperature)
        end
        
        %% Current
        function SetCurrent(obj,Volt)
            % 0 Volt correspond to the minimum software current
            % 5 Volts to the maximum software current 
            % This way, we can set the same input using this controler or the analog input
            if Volt > 5 || Volt <0
                disp('Lens Voltage outside range')
            else
            % Compute current in mA
            current =  Volt*(obj.MaxCurrent - obj.MinCurrent)/5;
            % Convert into a value between à and 4095, floor required to get an integer
            current = floor((current/obj.MaxCurrent)*4095);
            % Compute Low Byte and High Byte to send
            LB = mod(current,256); %% low byte
            HB = (current-LB)/256; %% high byte
            % Send command
            command = obj.append_crc(['Aw'-0 HB LB]);
            fwrite(obj.Com, command);
            end
        end
        
        function GetCurrent(obj)
            command = obj.append_crc(['Ar'-0 0 0]);
            % Send command
            fwrite(obj.Com, command);
            % Wait for response
            pause(obj.WaitTime);
            % Read response
            response = fread(obj.Com,obj.Com.BytesAvailable);
            % Extract current value, bytes 2 and 3, as a value between 0 and 4095
            current = response(2)*(hex2dec('ff')+1) + response(3);
            % Convert into mA
            obj.Current = current*obj.CurrentRange/4095;
            disp(obj.Current)
        end
        
        
        % Current limits 
        % Hardware current limit (set to 292.84 mA by design)
        function GetHardMaxCurrent(obj)
            command = obj.append_crc(['CrMA'-0 0 0]);
            fwrite(obj.Com, command);
            pause(obj.WaitTime);
            % Get response
            response = fread(obj.Com,obj.Com.BytesAvailable);
            % Read max current (bytes 4 and 5)
            currentrange = response(4)*(hex2dec('ff')+1) + response(5);
            %Convert into mA
            obj.CurrentRange = currentrange/100;           
        end
        
        % Software Max Current
        function GetSoftMaxCurrent(obj)
            command = obj.append_crc(['CrUA'-0 0 0]);
            fwrite(obj.Com, command);
            pause(obj.WaitTime);
            % Get response
            response = fread(obj.Com,obj.Com.BytesAvailable);
            % Read max current (bytes 4 and 5) coded between -4096 and +4096
            maxcurrent = response(4)*(hex2dec('ff')+1) + response(5);
            % Convert into mA, knowing 0 == 0 mA, and 4096 == 292.84 mA  == CurrentRange 
            obj.MaxCurrent = maxcurrent/4095*obj.CurrentRange;
        end
         
        % Software Min Current       
        function GetSoftMinCurrent(obj)
            command = obj.append_crc(['CrLA'-0 0 0]);
            fwrite(obj.Com, command);
            pause(obj.WaitTime);
            % Get response
            response = fread(obj.Com,obj.Com.BytesAvailable);
            % Read min current (bytes 4 and 5) coded between -4096 and +4096
            mincurrent = response(4)*(hex2dec('ff')+1) + response(5); 
            % Convert into mA, knowing 0 == 0 mA, and 4096 == 292.84 mA  == CurrentRange 
            obj.MinCurrent = mincurrent/4095*obj.CurrentRange;
        end
        
        %% Set Lens Focal Power
        function SetFocalPower(obj,Dioptries)
            if Dioptries > obj.MaxFocalPower || Dioptries <obj.MinFocalPower
                disp('Lens Focal Power outside range')
            else
            % Compute Focal Power in software units
            focalpower = floor((Dioptries+5)*200);
            % Compute Low Byte and High Byte to send
            LB = mod(focalpower,256); %% low byte
            HB = (focalpower-LB)/256; %% high byte
            % Send command
            command = obj.append_crc(['PwDA'-0 HB LB -0 -0]);
            fwrite(obj.Com, command);
            end
        end
        
        
        %% Set Amplitude and Frequency of the Periodic Modes (Sinusoidal, Triangular, Rectangular)
        function SetFrequency(obj,Frequency) % Frequency in Hz
            % if frequency above 20 Hz, the lens cannot follow
            if Frequency > 20
                disp('Too fast for the Lens')
            else
                % Convert Hz into mHz
                Frequency = 1000*Frequency;
                % Convert into 32 bytes value
                B4 = mod(Frequency,256); %% 4th byte
                B3 = mod(((Frequency-B4)/2^8),256); %% third byte
                B2 = mod(((Frequency-B3*2^8-B4)/2^16),256); %% second byte
                B1 = mod(((Frequency-B2*2^16-B3*2^8-B4)/2^24),256); %% first byte
                command = obj.append_crc(['PwFA'-0 B1 B2 B3 B4]);
                fwrite(obj.Com, command);
            end
        end
        
        function GetFrequency(obj)
            command = obj.append_crc(['PrFA'-0 0 0 0 0]);
            % Send command
            fwrite(obj.Com, command);
            % Wait for response
            pause(obj.WaitTime);
            % Read response
            response = fread(obj.Com,obj.Com.BytesAvailable);      
            obj.Frequency = (response(5) * 2^24 + response(6) * 2^16 + response(7) * 2^8 + response(8))/1000;
            disp(obj.Frequency)
        end
        
        function SetPeakToPeak(obj,Min,Max)
            % If Min>Max, invert values
            if Min>Max
                M = Max;
                Max = Min;
                Min = M;
            end
            % if Min or Max are outside the allowed range of 0 to 5V, display error message
            if Max > 5 || Min <0
                disp('Lens Voltage outside range')
            else
                % Set lower limit
                % Compute current in mA. CurrentRange/5V
                current =  Min*(obj.MaxCurrent - obj.MinCurrent)/5;
                % Convert into a value between à and 4095, floor required to get an integer
                current = floor((current/obj.MaxCurrent)*4095);
                % Compute Low Byte and High Byte to send
                LB = mod(current,256); %% low byte
                HB = (current-LB)/256; %% high byte
                % Send command
                command = obj.append_crc(['PwLA'-0 HB LB 0 0]);
                fwrite(obj.Com, command);
                % Set higher limit
                % Compute current in mA. CurrentRange/5V
                current =  Max*(obj.MaxCurrent - obj.MinCurrent)/5;
                % Convert into a value between à and 4095, floor required to get an integer
                current = floor((current/obj.MaxCurrent)*4095);
                % Compute Low Byte and High Byte to send
                LB = mod(current,256); %% low byte
                HB = (current-LB)/256; %% high byte
                % Send command
                command = obj.append_crc(['PwUA'-0 HB LB 0 0]);
                fwrite(obj.Com, command);
            end       
        end
        
        function GetPeakToPeak(obj)
            % lower current
            command = obj.append_crc(['PrLA'-0 0 0 0 0]);
            % Send command
            fwrite(obj.Com, command);
            % Wait for response
            pause(obj.WaitTime);
            % Read min current (bytes 4 and 5) coded between -4096 and +4096
            mincurrent = response(4)*(hex2dec('ff')+1) + response(5); 
            % Convert into mA, knowing 0 == 0 mA, and 4096 == 292.84 mA  == CurrentRange 
            obj.MinPeriodic = mincurrent/4095*obj.CurrentRange;
            % higher current
            command = obj.append_crc(['PrUA'-0 0 0 0 0]);
            % Send command
            fwrite(obj.Com, command);
            % Wait for response
            pause(obj.WaitTime);
            % Read min current (bytes 4 and 5) coded between -4096 and +4096
            maxcurrent = response(4)*(hex2dec('ff')+1) + response(5); 
            % Convert into mA, knowing 0 == 0 mA, and 4096 == 292.84 mA  == CurrentRange 
            obj.MaxPeriodic = maxcurrent/4095*obj.CurrentRange;
        end
        
        %% Set Lens working Mode (Current, Analog, FocalPower)
        function SetModeCurrent(obj)
            command = obj.append_crc('MwDA'-0);
            fwrite(obj.Com, command);
            pause(obj.WaitTime);
            % Get response
            response = fread(obj.Com,obj.Com.BytesAvailable);
            if strcmp(cellstr(char(response(1:3))'), 'MDA')
                disp('Lens set to Current Mode succesfully');
            end
        end
        
        function SetModeAnalog(obj)
            command = obj.append_crc('MwAA'-0);
            fwrite(obj.Com, command);
            pause(obj.WaitTime);
            % Get response
            response = fread(obj.Com,obj.Com.BytesAvailable);
            if strcmp(cellstr(char(response(1:3))'), 'MAA')
                disp('Lens set to Analog Mode succesfully');
            end
        end
        
        function SetModeFocalPower(obj)
            command = obj.append_crc('MwCA'-0);
            fwrite(obj.Com, command);
            pause(obj.WaitTime);
            % Get response
            response = fread(obj.Com,obj.Com.BytesAvailable);
            if strcmp(cellstr(char(response(1:3))'), 'MCA')
                disp('Lens set to Focal Power Mode succesfully');
            end
            % Get Max and Min Focal Power
            maxfocalpower = response(5)*(hex2dec('ff')+1) + response(6);
            minfocalpower = response(7)*(hex2dec('ff')+1) + response(8);
            % Convert in Dioptries (Type A firmwire)
            obj.MaxFocalPower = maxfocalpower/200-5;
            obj.MinFocalPower = minfocalpower/200-5;
        end
        
        function SetModeSinusoidal(obj)
            command = obj.append_crc('MwSA'-0);
            fwrite(obj.Com, command);
            pause(obj.WaitTime);
            % Get response
            response = fread(obj.Com,obj.Com.BytesAvailable);
            if strcmp(cellstr(char(response(1:3))'), 'MSA')
                disp('Lens set to Sinusoidal Mode succesfully');
            end
            % By default, set a 1 Hz signal between 0 and 3 V
            obj.SetFrequency(1);
            obj.SetPeakToPeak(0,3);
        end
        
        function SetModeTriangular(obj)
            command = obj.append_crc('MwTA'-0);
            fwrite(obj.Com, command);
            pause(obj.WaitTime);
            % Get response
            response = fread(obj.Com,obj.Com.BytesAvailable);
            if strcmp(cellstr(char(response(1:3))'), 'MTA')
                disp('Lens set to Triangular Mode succesfully');
            end
            % By default, set a 1 Hz signal between 0 and 3 V
            obj.SetFrequency(1);
            obj.SetPeakToPeak(0,3);
        end
        
        function SetModeRectangular(obj)
            command = obj.append_crc('MwQA'-0);
            fwrite(obj.Com, command);
            pause(obj.WaitTime);
            % Get response
            response = fread(obj.Com,obj.Com.BytesAvailable);
            if strcmp(cellstr(char(response(1:3))'), 'MQA')
                disp('Lens set to Triangular Mode succesfully');
            end
            % By default, set a 1 Hz signal between 0 and 3 V
            obj.SetFrequency(1);
            obj.SetPeakToPeak(0,3);
        end
        
        
        % Get Lens working Mode
        function GetMode(obj)
            command = obj.append_crc('MMA'-0);
            fwrite(obj.Com, command);
            pause(obj.WaitTime);
            response = fread(obj.Com,obj.Com.BytesAvailable);
            switch response(4)
                case 1
                    disp('Lens is driven in Current mode');
                case 2
                    disp('Lens is driven in Sinusoidal Singal mode');
                case 3
                    disp('Lens is driven in Triangular mode');
                case 4
                    disp('Lens is driven in Retangular mode');
                case 5
                    disp('Lens is driven in Focal Power mode');
                case 6
                    disp('Lens is driven in Analog mode');
                case 7
                    disp('Lens is driven in Position Controlled Mode');
            end
        end
        
        
        %% Add CRC bytes
        function output = append_crc(~,intput_command)
            % Calculates check sum for Optotune lens driver and appends it to the end of the message
            % written by Roman Spesyvtsev @ https://github.com/ramzes3/Optotune-ETL-control-in-matlab/blob/master/append_crc.m
            % The code is provided under the GPL licinse without any warranty 
            a = intput_command;
            s1 = length(a); %% size of the command array
            crc = uint16(0); %%, i;
            i = uint16(0);
            c1 = hex2dec('a001');
            for i=1:s1
                crc = bitxor(crc,a(i)); %% crc = crc^a;
                for j = 1:8
                    if bitand(crc,1)  %%crc & 1
                        crc = bitshift(crc,-1); %% crc = crc >> 1; %% crc = (crc >> 1) ^ 0xA001;
                        crc = bitxor(crc, c1); %% crc = crc ^ c1;
                    else
                        crc = bitshift(crc,-1); %% crc = crc >> 1 
                    end
                end
            end
            check_sum = a;
            check_sum(end+1) = bitand(crc,hex2dec('ff'));
            check_sum(end+1) = bitshift(crc,-8);
            %%check_sum(end+1) = bitshift(bitand(crc,hex2dec('ff00')),-8);
            output = check_sum;
        end
       
        
        function Delete(obj)
            fclose(obj.Com);
            delete(obj.Com);
            clear obj.Com
            clear obj
        end
        
    end
        
end

