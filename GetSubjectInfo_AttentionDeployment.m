function participantInfo=GetSubjectInfo_AttentionDeployment
%%
tit='Ingrese Informacion';
instrBox={'ID del participante','Genero (F o M)','Edad (anios)',...
    'Investigador a cargo del registro'};
opt.Resize='on';
opt.WindowStyle='normal';
opt.WindowSize=100;
wSize=repmat([1 50],size(instrBox,3),1);
defaultID={'ID Participante','F','18','Nicolas Nunez'};

participantInfo=struct;
% write info
instrBox2=horzcat(instrBox,{'Fecha','LocalHost'});
for ii=1:numel(instrBox2)
    participantInfo.id{ii,1}=instrBox2{ii};
end


% subInfo.id={instrBox{1};instrBox{2};instrBox{3};instrBox{4};instrBox{5};...
%     'Fecha';'Sistema';'Usuario';'LocalHost'};
participantInfo.data=inputdlg(instrBox,tit,wSize,defaultID,opt);

% append date
rn=size(participantInfo.data,1);
datetimestr=GetCurrDateTime();
participantInfo.data{rn+1}=datetimestr;

% append computer info
% computerInfo=Screen('Computer');
[~,host]=system('hostname');
rn=size(participantInfo.data,1);
participantInfo.data{rn+1}=host;
% subInfo.data{rn+2}=computerInfo.processUserShortName;
% subInfo.data{rn+3}=computerInfo.localHostName;
end