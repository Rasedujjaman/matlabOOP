

function  IncrementCounter(obj, counterFileName)
    
    if(strcmp(counterFileName, 'SnapShotCounter'))
        fileID = fopen(fullfile([pwd, '\headerAndFunctionsSaveData'], 'SnapShotCounter.txt'), 'r');

        value = str2double(fscanf(fileID, '%s', Inf));
        value = num2str(value + 1);
        fclose(fileID);
        
        fileID = fopen(fullfile([pwd, '\headerAndFunctionsSaveData'], 'SnapShotCounter.txt'), 'w');
        obj.SnapShotCounter = value;
        fprintf(fileID,'%s', obj.SnapShotCounter);
        fclose(fileID);

    end
    
    
     if(strcmp(counterFileName, 'ScanCounter'))
        fileID = fopen(fullfile([pwd, '\headerAndFunctionsSaveData'], 'ScanCounter.txt'), 'r+');

        value = str2double(fscanf(fileID, '%s', Inf));
        value = num2str(value + 1);
        obj.ScanCounter = value;
        fclose(fileID);
        fileID = fopen(fullfile([pwd, '\headerAndFunctionsSaveData'], 'ScanCounter.txt'), 'r+');

        fprintf(fileID,'%s', value);
        fclose(fileID);

    end

end