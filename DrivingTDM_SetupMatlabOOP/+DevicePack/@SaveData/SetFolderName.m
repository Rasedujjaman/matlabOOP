

function SetFolderName(obj)
    c = clock();
    year = c(1);
    month = c(2);
    day = c(3);
    % Create folder named yyyymmdd
    
    obj.FolderName = strcat(num2str(year,'%04d'),num2str(month,'%02d'),num2str(day,'%02d'));

end






