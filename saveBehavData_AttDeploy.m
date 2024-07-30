function saveBehavData_AttDeploy(data, data_filename)

% generate file name
datetimestr=GetCurrDateTime();
temp=regexp(datetimestr,'_','split');
data.info.timefinish=temp{4};

% write data
fileID = fopen([data_filename '.txt'],'w');
fprintf(fileID,'%s\t%s\r\n','Fecha (yyyy_mm_dd):',datetimestr(1:10));
fprintf(fileID,'%s\t%s\r\n','Hora inicio:',data.info.timestart);
fprintf(fileID,'%s\t%s\r\n','Hora fin:',temp{4});
fprintf(fileID,'%s\t%s\r\n','Tarea:', data.info.Task);
fprintf(fileID,'%s\t%s\r\n','Participante:',data.info.Subject_ID);
fprintf(fileID,'%s\t%s\r\n','Genero:',data.info.Subject_Gender);
fprintf(fileID,'%s\t%s\r\n\r\n','Edad:',data.info.Subject_Age);

fprintf(fileID,'%s\t%s\t%s\t%s\t%s\t%s\r\n','Bloque','Estimulo','Resp_Val','Resp_Int', 'TR_Val(s)','TR_Int(s)');
fprintf(fileID,'%g\t%g\t%g\t%g\t%g\t%g\r\n',([data.vars.Block_dumm data.vars.Stim_seq data.vars.ResponseValence_seq data.vars.ResponseIntensity_seq data.vars.RTvalence_seq data.vars.RTintensity_seq])');

fclose(fileID);

BehavData=data; %#ok<NASGU>
save([data_filename '.mat'],'BehavData')