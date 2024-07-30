function AttentionDeploymentTask_Practice
%%
clc
my_path=pwd;
temp=regexp(pwd,filesep,'split');
if strcmp(temp{end},'AttentionDeployment')
else
    warning('CHANGE YOUR DIRECTORY TO THE ''AttentionDeployment'' FOLDER')
    my_path=uigetdir();
end 

settings_AttentionDeployment_Practice; %load up settings

Screen('Preference', 'SkipSyncTests', 1)
scrns=Screen('Screens');
[winPointer, winRect] = Screen('OpenWindow', max(scrns));
w = winRect(RectRight); %screen width, pixels
h = winRect(RectBottom); %scr een height, pixels


imSize=round([w*0.5 h*0.88]);
x=0.25*w;
y=0.1*h;
facePos=[x y imSize(1)+x imSize(2)+y];

imSize=round([w*0.6 h*0.4]);
x=0.2*w;
y=0.05*h;
Val_Int_pos=[x y imSize(1)+x imSize(2)+y];

flipInterval=Screen('GetFlipInterval',winPointer)/2;

% Show instructions

txt='PRESIONE LA BARRA DE ESPACIO PARA INICIAR PRACTICA';
Screen('TextSize',winPointer, 60);

DrawFormattedText(winPointer,txt,'center','center',0,35)
 
Screen('Flip',winPointer);

KbStrokeWait(device2useID);


ResponseValence_seq=nan(n_trials,n_blocks);
ResponseIntensity_seq=nan(n_trials,n_blocks);
RTvalence_seq=nan(n_trials,n_blocks);
RTintensity_seq=nan(n_trials,n_blocks);
 
for thisBlock=1:n_blocks   %#ok<*NODEF>
    flag_out=false;
    trialtype_seq=floor(Pics_Seq(1,:,thisBlock)./100); %#ok<*NODEF>
    if ~dummyMode_Eyelink
        Eyelink('Message', ['START BLOCK' num2str(thisBlock)]);
    end
    for thisTrial=1:n_trials
        ListenChar(2);
        % select image block to present in this trial
        currFolder=folders{trialtype_seq(thisTrial)}; %#ok<*USENS>
        d=dir(fullfile([my_path filesep 'Imagenes Tarea DA'  filesep currFolder filesep '*.jpg']));
        thisImageBlock=rem(Pics_Seq(:,thisTrial,thisBlock),100);
        disp(['block ' num2str(thisBlock) '; trial ' num2str(thisTrial)])
        for gr=1:size(grey_seq,2)  %loop through grey screens in between trials
            start=GetSecs;
            Screen('FillRect',winPointer, grey_seq(:,gr));
            Screen('FrameOval',winPointer,[0,0,0],...
                CenterRect([0,0,40,40],winRect),10,10);
            %             if gr==1
            %                 fixOnset=Screen('Flip',winPointer, start);
            %             else
            fixOnset=Screen('Flip',winPointer, (start-flipInterval)+Grey_durat_s);
            %             end
        end
        
        %display instructions, depending on trial type
        
        tmp=regexp(currFolder, '_', 'split');
        
        if strcmp(tmp{3},'FOCUS')  % participant must attend to circle
            txtInstruction=txtInstruction_Circle;
        elseif strcmp(tmp{3},'NO')  %free-viewing
            txtInstruction=txtInstruction_Free;
        end
        
        Screen(winPointer,'TextSize',70);
        DrawFormattedText(winPointer, txtInstruction, 'center','center', 200);
        instrOnset=Screen('Flip',winPointer,(fixOnset-(flipInterval))+Grey_durat_s);
        if ~dummyMode_Eyelink
            Eyelink('Message', 'INSTRUCTION SCREEN');
        end
        %loop through images within a trial
        for img=1:size(thisImageBlock,1)
            
            
            img_number=thisImageBlock(img);
            
            imageTexture=Screen('MakeTexture',winPointer,imread(d(img_number).name));
            Screen('DrawTexture',winPointer,imageTexture,[],facePos);
            if img==1
                img_start=Screen('Flip',winPointer,(instrOnset-(flipInterval))+Instruct_durat_s);
                if ~dummyMode_Eyelink
                    Eyelink('Message', ['STIM_' num2str(Pics_Seq(img,thisTrial,thisBlock))]);
                end
            else
                img_start=Screen('Flip',winPointer,(img_start-(flipInterval))+Img_duration_s);
                if ~dummyMode_Eyelink
                    Eyelink('Message', ['STIM_' num2str(Pics_Seq(img,thisTrial,thisBlock))]);
                end
            end
            
        end
        
        imageTexture=Screen('MakeTexture',winPointer,img_Valence);
        Screen('DrawTexture',winPointer,imageTexture,[],Val_Int_pos);
        Screen(winPointer,'TextSize',60);
        DrawFormattedText(winPointer, txtValence, 'center',0.6*h, 200);
        val_display=Screen('Flip',winPointer,img_start-(flipInterval)+Img_duration_s);
        if ~dummyMode_Eyelink
            Eyelink('Message', 'VALENCE SCALE');
        end
        flag_noanswer=true;
        waitAnswer=true;
        while waitAnswer
            [~,~, keyCode] = KbCheck(device2useID);
            
            if keyCode(KbName('9'))
                while KbCheck(device2useID); end %wait till release key press, only one key press is recognized
                ResponseValence_seq(thisTrial,thisBlock)=9;
                flag_noanswer=false; waitAnswer=false;
                RTvalence_seq(thisTrial,thisBlock)=GetSecs-val_display;
                if ~dummyMode_Eyelink; Eyelink('Message', 'BP9'); end
            elseif keyCode(KbName('8'))
                while KbCheck(device2useID); end %wait till release key press, only one key press is recognized
                ResponseValence_seq(thisTrial,thisBlock)=8;
                flag_noanswer=false; waitAnswer=false;
                RTvalence_seq(thisTrial,thisBlock)=GetSecs-val_display;
                if ~dummyMode_Eyelink; Eyelink('Message', 'BP8'); end
            elseif keyCode(KbName('7'))
                while KbCheck(device2useID); end %wait till release key press, only one key press is recognized
                ResponseValence_seq(thisTrial,thisBlock)=7;
                flag_noanswer=false; waitAnswer=false;
                RTvalence_seq(thisTrial,thisBlock)=GetSecs-val_display;
                if ~dummyMode_Eyelink;  Eyelink('Message', 'BP7'); end
            elseif keyCode(KbName('6'))
                while KbCheck(device2useID); end %wait till release key press, only one key press is recognized
                ResponseValence_seq(thisTrial,thisBlock)=6;
                flag_noanswer=false; waitAnswer=false;
                RTvalence_seq(thisTrial,thisBlock)=GetSecs-val_display;
                if ~dummyMode_Eyelink;  Eyelink('Message', 'BP6'); end
            elseif keyCode(KbName('5'))
                while KbCheck(device2useID); end %wait till release key press, only one key press is recognized
                ResponseValence_seq(thisTrial,thisBlock)=5;
                flag_noanswer=false; waitAnswer=false;
                RTvalence_seq(thisTrial,thisBlock)=GetSecs-val_display;
                if ~dummyMode_Eyelink;  Eyelink('Message', 'BP5'); end
            elseif keyCode(KbName('4'))
                while KbCheck(device2useID); end %wait till release key press, only one key press is recognized
                ResponseValence_seq(thisTrial,thisBlock)=4;
                flag_noanswer=false; waitAnswer=false;
                RTvalence_seq(thisTrial,thisBlock)=GetSecs-val_display;
                if ~dummyMode_Eyelink;  Eyelink('Message', 'BP4'); end
            elseif keyCode(KbName('3'))
                while KbCheck(device2useID); end %wait till release key press, only one key press is recognized
                ResponseValence_seq(thisTrial,thisBlock)=3;
                flag_noanswer=false;waitAnswer=false;
                RTvalence_seq(thisTrial,thisBlock)=GetSecs-val_display;
                if ~dummyMode_Eyelink;  Eyelink('Message', 'BP3'); end
            elseif keyCode(KbName('2'))
                while KbCheck(device2useID); end %wait till release key press, only one key press is recognized
                ResponseValence_seq(thisTrial,thisBlock)=2;
                flag_noanswer=false; waitAnswer=false;
                RTvalence_seq(thisTrial,thisBlock)=GetSecs-val_display;
                if ~dummyMode_Eyelink;  Eyelink('Message', 'BP2'); end
            elseif keyCode(KbName('1'))
                while KbCheck(device2useID); end %wait till release key press, only one key press is recognized
                ResponseValence_seq(thisTrial,thisBlock)=1;
                flag_noanswer=false; waitAnswer=false;
                RTvalence_seq(thisTrial,thisBlock)=GetSecs-val_display;
                if ~dummyMode_Eyelink;  Eyelink('Message', 'BP1'); end
            end
            
            if GetSecs-val_display>=Wait_time_s
                flag_noanswer=true;
                waitAnswer=false;
            end
            if keyCode(KbName('ESCAPE'))
                flag_out=true;
                break
            end
        end
        
        
        
        % show in screen the response that participant just gave
        txtNumPressed=num2str(ResponseValence_seq(thisTrial,thisBlock));
        if isnan(ResponseValence_seq(thisTrial,thisBlock))
            txtNumPressed='sin respuesta';
        end
        Screen(winPointer,'TextSize',60);
        DrawFormattedText(winPointer, ['valencia ' txtNumPressed], 'center',0.7*h, [200;0;0]);
        response_display=Screen('Flip',winPointer,0);
        
        if flag_out
            break
        end
        
        imageTexture=Screen('MakeTexture',winPointer,img_Int);
        Screen('DrawTexture',winPointer,imageTexture,[],Val_Int_pos);
        Screen(winPointer,'TextSize',60);
        DrawFormattedText(winPointer, txtIntensity, 'center',0.6*h, 200);
        int_display=Screen('Flip',winPointer,response_display-(flipInterval)+0.35,0);
        if ~dummyMode_Eyelink
            Eyelink('Message', 'INTENSITY SCALE');
        end
        
        flag_noanswer2=true;
        waitAnswer=true;
        while waitAnswer
            [~,~, keyCode] = KbCheck(device2useID);
            %             [~,~, keyCode] = KbCheck();
            
            if keyCode(KbName('9'))   % '9('
                while KbCheck(device2useID); end %wait till release key press, only one key press is recognized
                ResponseIntensity_seq(thisTrial,thisBlock)=9;
                flag_noanswer2=false; waitAnswer=false;
                RTintensity_seq(thisTrial,thisBlock)=GetSecs-int_display;
                if ~dummyMode_Eyelink; Eyelink('Message', 'BP9'); end
            elseif keyCode(KbName('8'))  % '8*'
                while KbCheck(device2useID); end %wait till release key press, only one key press is recognized
                ResponseIntensity_seq(thisTrial,thisBlock)=8;
                flag_noanswer2=false; waitAnswer=false;
                RTintensity_seq(thisTrial,thisBlock)=GetSecs-int_display;
                if ~dummyMode_Eyelink;  Eyelink('Message', 'BP8'); end
            elseif keyCode(KbName('7'))  % '7&'
                while KbCheck(device2useID); end %wait till release key press, only one key press is recognized
                ResponseIntensity_seq(thisTrial,thisBlock)=7;
                flag_noanswer2=false; waitAnswer=false;
                RTintensity_seq(thisTrial,thisBlock)=GetSecs-int_display;
                if ~dummyMode_Eyelink; Eyelink('Message', 'BP7'); end
            elseif keyCode(KbName('6'))   % '6^'
                while KbCheck(device2useID); end %wait till release key press, only one key press is recognized
                ResponseIntensity_seq(thisTrial,thisBlock)=6;
                flag_noanswer2=false; waitAnswer=false;
                RTintensity_seq(thisTrial,thisBlock)=GetSecs-int_display;
                if ~dummyMode_Eyelink; Eyelink('Message', 'BP6'); end
            elseif keyCode(KbName('5'))   % '5%'
                while KbCheck(device2useID); end %wait till release key press, only one key press is recognized
                ResponseIntensity_seq(thisTrial,thisBlock)=5;
                flag_noanswer2=false; waitAnswer=false;
                RTintensity_seq(thisTrial,thisBlock)=GetSecs-int_display;
                if ~dummyMode_Eyelink;  Eyelink('Message', 'BP5'); end
            elseif keyCode(KbName('4'))  %'4$'
                while KbCheck(device2useID); end %wait till release key press, only one key press is recognized
                ResponseIntensity_seq(thisTrial,thisBlock)=4;
                flag_noanswer2=false; waitAnswer=false;
                RTintensity_seq(thisTrial,thisBlock)=GetSecs-int_display;
                if ~dummyMode_Eyelink; Eyelink('Message', 'BP4'); end
            elseif keyCode(KbName('3'))   %'3#'
                while KbCheck(device2useID); end %wait till release key press, only one key press is recognized
                ResponseIntensity_seq(thisTrial,thisBlock)=3;
                flag_noanswer2=false; waitAnswer=false;
                RTintensity_seq(thisTrial,thisBlock)=GetSecs-int_display;
                if ~dummyMode_Eyelink; Eyelink('Message', 'BP3'); end
            elseif keyCode(KbName('2'))   % '2@'
                while KbCheck(device2useID); end %wait till release key press, only one key press is recognized
                ResponseIntensity_seq(thisTrial,thisBlock)=2;
                flag_noanswer2=false; waitAnswer=false;
                RTintensity_seq(thisTrial,thisBlock)=GetSecs-int_display;
                if ~dummyMode_Eyelink; Eyelink('Message', 'BP2'); end
            elseif keyCode(KbName('1'))   % '1!'
                while KbCheck(device2useID); end %wait till release key press, only one key press is recognized
                ResponseIntensity_seq(thisTrial,thisBlock)=1;
                flag_noanswer2=false; waitAnswer=false;
                RTintensity_seq(thisTrial,thisBlock)=GetSecs-int_display;
                if ~dummyMode_Eyelink; Eyelink('Message', 'BP1'); end
            end
            
            if GetSecs-int_display>=Wait_time_s
                flag_noanswer2=true;
                waitAnswer=false;
            end
            
            if keyCode(KbName('ESCAPE'))
                flag_out=true;
                break
            end
        end
        
        if flag_noanswer
            disp('Participant did not respond (valence)')
        end
        
        if flag_noanswer2
            disp('Participant did not respond (intensity)')
        end
        
         % show in screen the response that participant just gave
        txtNumPressed=num2str(ResponseIntensity_seq(thisTrial,thisBlock));
        if isnan(ResponseIntensity_seq(thisTrial,thisBlock))
            txtNumPressed='sin respuesta';
        end 
        Screen(winPointer,'TextSize',60);
        DrawFormattedText(winPointer, ['intensidad ' txtNumPressed], 'center',0.7*h, [200;0;0]);
        Screen('Flip',winPointer,0);
        WaitSecs(0.35)
        
        
        if flag_out
            break
        end
        
    end
    
%     temp1=RTintensity_seq(:);
%     temp1=round(temp1*1000)/1000;  % 2 decimals
%     data.vars.RTintensity_seq=temp1;
%     
%     temp2=ResponseIntensity_seq(:);
%     data.vars.ResponseIntensity_seq=temp2;+++++++++++++++++++++++++++++
%     
%     temp1=RTvalence_seq(:);
%     temp1=round(temp1*1000)/1000;  % 2 decimals
%     data.vars.RTvalence_seq=temp1;
    
%     temp2=ResponseValence_seq(:);
%     data.vars.ResponseValence_seq=temp2;
%     
%     saveBehavData_AttDeploy(data, data_filename)
    
    if flag_out
        break
    end
    
end

WaitSecs(2);
Screen(winPointer,'TextSize',80);
DrawFormattedText(winPointer, 'Muchas Gracias', 'center','center', 200);
Screen('Flip',winPointer)
WaitSecs(2);

if ~dummyMode_Eyelink
    disp('Closing Eyelink...')
    stopAndCloseEyeLink
end
ListenChar(0);


sca
