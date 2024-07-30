
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% General
rng('shuffle');


ITI_s=2;
Img_duration_s=4; %4
Wait_time_s=5;
Grey_durat_s=0.5;   %4
Instruct_durat_s=2;  %4

showInstructions=true;

dummyMode_EEG=true;
dummyMode_Eyelink=true;

%define which keyboard
taskInputKb='';
% taskInputKb='USB KVM';
% taskInputKb='USB Keyboard';



% get a list of folder names with the images
temp=dir([my_path filesep 'Imagenes Tarea DA']);
folders=cell(1,1);
c=0;
for f=1:numel(temp)
    str=temp(f).name;
    if strcmp(str(1),'.')
    else
        if isdir(str)
            c=c+1;
            folders{c,1}=temp(f).name;
        end
    end
end

folders=sort(folders); % folders should contain 5 folder names (5 image categories) 


img_Valence=imread([my_path filesep 'Imagenes Tarea DA' filesep 'Valencia_2.png']);
img_Int=imread([my_path filesep 'Imagenes Tarea DA' filesep 'Intensidad_2.png']);


txtValence='Indique Valencia, de 1 a 9';
txtIntensity='Indique Intensidad, de 1 a 9';

txtInstruction_Circle='Enfoque su atencion visual en el circulo';
txtInstruction_Free='Observe la imagen libremente';

% LOAD PICTURE SEQUENCE 
%'which_seq' can take values 1, 2 or 3
% they correspond to three different sequences with dimensions:
% individual images within image-blocks, trials, blocks of trials 

% each trial consists of one image-block of five images

% which_seq=randi([1 3],1,1);
% which_seq_str=num2str(which_seq);

load('Picture_Sequences.mat','Pics_Seq_Practice')

disp('Pics_Seq_Practice')

eval(['Pics_Seq=' 'Pics_Seq_Practice;'])


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
