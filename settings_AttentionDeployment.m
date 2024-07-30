%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% General
rng('shuffle');


ITI_s=2;
Img_duration_s=4; %4
Wait_time_s=5;
Grey_durat_s=4;   %4
Instruct_durat_s=5;  %4

showInstructions=true;

dummyMode_EEG=true;
dummyMode_Eyelink=true;


%define which keyboard
taskInputKb='Designer Compact Keyboard'; % CAR
% taskInputKb='USB KVM';
% taskInputKb='USB Keyboard';
%%

% get a list of folder names with the images
temp=dir([my_path filesep 'Imagenes Tarea DA']);
folders=cell(1,1);
c=0;

% Previo DRL
% for f=1:numel(temp)
%     str=temp(f).name;
%     if strcmp(str(1),'.') 
%     else
%         if isdir(str) % AL PARECER ESTO NO ESTABA FUNCIONANDO (CAR)
%             c=c+1;
%             folders{c,1}=temp(f).name;
%         end
%     end
% end

% Update CAR
for f=1:numel(temp)
    str=temp(f).name;
    if strcmp(str(1),'.') 
    else
        if strcmp(str(1),'0') || strcmp(str(1),'1')  
            c=c+1;
            folders{c,1}=temp(f).name;
        end
    end
end


% folders=sort(folders); % folders should contain 5 folder names (5 image categories) 


img_Valence=imread([my_path filesep 'Imagenes Tarea DA' filesep 'Valencia_2.png']);
img_Int=imread([my_path filesep 'Imagenes Tarea DA' filesep 'Intensidad_2.png']);


txtValence='Indique Valencia, de 1 a 9';
txtIntensity='Indique Intensidad, de 1 a 9';

txtInstruction_Circle='Enfoque su atencion visual en el circulo';
txtInstruction_Free='Observe la imagen libremente';

%% LOAD PICTURE SEQUENCE 
%'which_seq' can take values 1, 2 or 3
% it allows to randomly choose one out of three possible stim sets
% Stim sets are calles "Pics_Seq_[number]" and
% each is a different sequence with dimensions:
% [images within trials] x [trials] x [blocks of trials]
% 5 x 10 x 2

% each trial consists of five images

which_seq=randi([1 3],1,1);
which_seq_str=num2str(which_seq);

load('Picture_Sequences.mat',['Pics_Seq_' which_seq_str])

disp(['Pics_Seq_' which_seq_str])

eval(['Pics_Seq=' 'Pics_Seq_' which_seq_str ';'])


n_blocks=size(Pics_Seq,3);
n_trials=size(Pics_Seq,2);

Block_dumm=nan(n_trials,n_blocks);
Stim_seq=nan(n_trials,n_blocks);
for bl=1:n_blocks
    for tr=1:n_trials
        id=Pics_Seq(1,tr,bl);
        Stim_seq(tr,bl)=(id-rem(id,100))./100;  %get first number of image code
    end
    Block_dumm(:,bl)=bl;
end

grey_seq=([(0.1:0.1:0.5)' (0.1:0.1:0.5)' (0.1:0.1:0.5)'])';

grey_seq=grey_seq(:,[4 1 5 3 2]).*255;  %sort according to paper


%% PARTICIPANT DATA
participantInfo=GetSubjectInfo_AttentionDeployment;

% data structure
data.info.Subject_ID_actual=participantInfo.data{1};
data.info.Subject_ID=GenRandomString;
data.info.Subject_Age=participantInfo.data{3};
data.info.Subject_Gender=participantInfo.data{2};
data.info.Task='Attention Deployment Task';

data.info.datetime=participantInfo.data{5};
temp=regexp(participantInfo.data{5},'_','split');
data.info.timestart=temp{4};

data.vars.Picture_seq=Pics_Seq;
data.vars.Block_dumm=Block_dumm(:);
data.vars.Stim_seq=Stim_seq(:);

folder=[my_path filesep 'data'];
data_filename=[folder filesep 'data_' data.info.Subject_ID(1:2) '_' data.info.datetime];

%%%%%%% keyboard settings %%%%%%%%%%%%
KbName('UnifyKeyNames');    % keynames for all types of keyboard
% buttons to press
responseKeys={'S','L','space','ESCAPE', 'C', 'V',...
    '1', '2', '3', '4', '5', '6', '7', '8', '9'};
KbCheckList=nan(size(responseKeys));
for k=1:length(responseKeys)
    KbCheckList(k)=KbName(responseKeys{k});
end
RestrictKeysForKbCheck(KbCheckList);
[deviceIdKey,deviceNameKey]=GetKeyboardIndices;

whichKb=strcmp(taskInputKb,deviceNameKey);

device2useID=deviceIdKey(whichKb);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
