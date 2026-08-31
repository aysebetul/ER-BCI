
prompt = "Please type the subject ID:";
subjectId = input(prompt);

try
    %% Settings
    % Screen Settings
    PsychDefaultSetup(2);
    nr=max(Screen('Preference', 'SkipSyncTests', 2));
    [w, screenRect]=PsychImaging('OpenWindow',nr,0,[],32,2); % open screen
    [centerX, centerY] = RectCenter(screenRect); % coordinates of center
    numTrials = 2;
    numBlocks = 2;
    
    % Keybord Settings
    FlushEvents('KeyDown');
    KbName('UnifyKeyNames'); 
    
    % Image Settings 
    home = '/Users/aysbtl/Documents/MATLAB/Psychtoolbox/dataset';
    image_info = 'dataset/ImageFiles/image_info.csv'; %strcat(home, 'SoundFiles/song_info.csv');
    image_info = readtable(image_info);
    sizeS = size(image_info);
    numImage = sizeS(1);
    selectedImage = cell(numBlocks,numTrials);
    imageLength = screenRect(3)/4;
    imageHeight = screenRect(3)/12;
    imageDims = [centerX-imageLength centerY-imageHeight-200 centerX+imageLength centerY+imageHeight-200];
    
    % Fixation cross Settings
    fixation = screenRect(3)/45;
    fixationColor = 255;
    fixationWidth = 5;
    fixationPos = [-fixation fixation 0 0; 0 0 -fixation fixation];
     
    % Self-Assessment Settings
    arousal = zeros(numBlocks, numTrials);
    valence = zeros(numBlocks, numTrials);
   
    % Timing Settings
    ifi = Screen('GetFlipInterval',w);
    hertz = FrameRate(w);
    waitframes = 1;
    numFrames = 1/ifi; % how many frames can fit in one second (120 frames)
    
    HideCursor;
    
    %% Experiment Start
    % 1. Introduction Message!
    text = 'Welcome to image emotion experiment. Please press any key when you are ready!';
    intro_msg(text, w, screenRect);
    for block=1:numBlocks
        for trial=1:numTrials
        
            % Select a random image 
            randImage = randi([1,30]);
            fname= strcat('dataset/ImageFiles/', string(image_info{randImage,1}), '.png');
            selectedImage(block,trial) = image_info{randSong,1};
        
            % 2.Display Image - 10s
            im=imread(fname, 'png');
            imTexture = Screen('MakeTexture',w,im);
            Screen('DrawTexture', w, imTexture, [], imageDims, 0);
            vbl = Screen('Flip', w);
            for frames=1:numFrames*2
                Screen('DrawTexture', w, imTexture, [], imageDims, 0);
                vbl = Screen('Flip',w, vbl+(waitframes-0.5)*ifi); % now visible on screen
            end
            
            % 4. SAM-Valence - 10s
            [aroScore, valScore] = sam(w,screenRect);
            arousal(block,trial) = aroScore;
            valence(block,trial) = valScore;
        
            % 5. Idle Period - 10s
            vbl = Screen('Flip', w);
            for frames=1:numFrames*2
                Screen('DrawLines', w, fixationPos, fixationWidth, fixationColor, [centerX, centerY]);
                vbl = Screen('Flip',w, vbl+(waitframes-0.5)*ifi); % now visible on screen
            end
        end 
        text = 'Time to break. You can move as you want. Please press any key when you are ready!';
        intro_msg(text, w, screenRect);
        KbWait; % waits for a keyboard press before continue
    end
    writematrix(arousal, strcat('results/s', string(subjectId), '_arousal.csv'));
    writematrix(valence, strcat('results/s', string(subjectId), '_valence.csv'));
    writecell(selectedImage, strcat('results/s', string(subjectId), '_selectedImage.csv'));
    sca;

catch
    sca; % closes the screens
    ShowCursor;
    psychrethrow(psychlasterror); % prints error message to command window
end
