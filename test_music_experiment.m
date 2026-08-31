
prompt = "Please type the subject ID:";
subjectId = input(prompt);

try
    %% Settings
    initializeSettings;

    %% Experiment Start
    % 1. Introduction Message!
    text = 'Welcome to music emotion experiment. Please press any key when you are ready!';
    width=RectWidth(Screen('TextBounds',w,text));
    write_text(text, 25, [255 255 255], centerX-width/2, centerY, w);
    vbl = Screen('Flip', w);
    KbWait; % waits for a keyboard press before continue
    tic;
    for block=1:numBlocks
        % select random "numTrials/2" indices for happy and sad song list
        % and concat songs in one table
        selectedSongs = [ss(randperm(height(ss),numTrials/2),:); hs(randperm(height(hs),numTrials/2),:)];
        randOrder = randperm(height(selectedSongs),numTrials);

        % Idle Period
        disp("Block idle started");
        disp(toc);
        for frames=1:numFrames*idle_duration
            Screen('FillRect', w, dark_gray);
            Screen('DrawLines', w, fixationPos, fixationWidth, fixationColor, [centerX, centerY]);
            vbl = Screen('Flip',w, vbl+(waitframes-0.5)*ifi); % now visible on screen
            
        end
        
        for trial=1:numTrials
            data.block(end+1) = block;
            data.trial(end+1) = trial;

            % Select a random music 
            fname= strcat('dataset/SoundFiles/', string(selectedSongs.songID(randOrder(trial))), '.mp3');
            data.music.category(end+1) = string(selectedSongs.category(randOrder(trial)));
            data.music.songID(end+1) = string(selectedSongs.songID(randOrder(trial)));
            data.music.singer(end+1) = string(selectedSongs.singer(randOrder(trial)));
            data.music.song(end+1) = string(selectedSongs.song(randOrder(trial)));
 
            % Read mp3 file from filesystem:
            [soundData, freq] = audioread(fname);
            wavedata = soundData';
            nrchannels = size(wavedata,1);

            pahandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels);
            PsychPortAudio('Volume',pahandle,volume);
            PsychPortAudio('FillBuffer', pahandle, wavedata);
            PsychPortAudio('Start', pahandle, 1, 0, 1);

            for frames=1:numFrames*song_duration
                % 1.Trigger: send Trigger when music play started
                if frames == 1
                    disp("Music started");
                    disp(toc);
                    %sendTrigger();
                end
                Screen('FillRect', w, light_gray);
                Screen('DrawLines', w, fixationPos, fixationWidth, fixationColor, [centerX, centerY]);
                vbl = Screen('Flip',w, vbl+(waitframes-0.5)*ifi); % now visible on screen
            end

            PsychPortAudio('Stop', pahandle);
            PsychPortAudio('Close', pahandle);
            % 2.Trigger: send Trigger when music play stopped
            %sendTrigger();
            disp("Music stopped");
            disp(toc);
            Screen('FillRect', w, dark_gray);
            
            % SAM-Valence
            disp("SAM started");
            disp(toc);
            [aroScore, valScore, sam_time] = sam(w,screenRect);
            data.sam.arousal(end+1) = aroScore;
            data.sam.valence(end+1) = valScore;
            data.sam.time(end+1) = sam_time;
            disp("SAM stopped");
            disp(toc);

            % Idle Period
            %vbl = Screen('Flip', w);
            disp("End trial idle started started");
            disp(toc);
            for frames=1:numFrames*idle_duration
                Screen('DrawLines', w, fixationPos, fixationWidth, fixationColor, [centerX, centerY]);
                vbl = Screen('Flip',w, vbl+(waitframes-0.5)*ifi); % now visible on screen
            end
        end 
        text = 'Time to break. You can move as you want. Please press any key when you are ready!';
        width=RectWidth(Screen('TextBounds',w,text));
        write_text(text, 25, [255 255 255], centerX-width/2, centerY, w)
        Screen('Flip', w);
        KbWait; % waits for a keyboard press before continue
    end
    sca;

catch
    sca; % closes the screens
    ShowCursor;
    psychrethrow(psychlasterror); % prints error message to command window
end
