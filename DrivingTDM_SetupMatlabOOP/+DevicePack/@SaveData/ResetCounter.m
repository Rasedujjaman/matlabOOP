
%%% This function will reset the counter value to zero
%%% Input argumnet: name of the file, i.e  if the text file name is hhh.txt
%%% Then counterFileName = 'hhh'


function ResetCounter(obj, counterFileName)

    if(strcmp(counterFileName, 'SnapShotCounter'))
        fileID = fopen(fullfile([pwd, '\headerAndFunctionsSaveData'], 'SnapShotCounter.txt'), 'w');
        obj.SnapShotCounter = num2str(0);
        fprintf(fileID,'%s', obj.SnapShotCounter);
        fclose(fileID);

    end
    
    
     if(strcmp(counterFileName, 'ScanCounter'))
        fileID = fopen(fullfile([pwd, '\headerAndFunctionsSaveData'], 'ScanCounter.txt'), 'w');
        obj.ScanCounter = num2str(0);
        fprintf(fileID,'%s', obj.ScanCounter);
        fclose(fileID);
    end

end
