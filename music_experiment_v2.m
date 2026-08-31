
input('start>>>','s') % prints to command window

try
    %% Settings
    % Screen Settings
    PsychDefaultSetup(2);
    nr=max(Screen('Preference', 'SkipSyncTests', 2));
    [w, screenRect]=PsychImaging('OpenWindow',nr,0,[],32,2); % open screen
    [centerX, centerY] = RectCenter(screenRect); % coordinates of center
    numTrials = 10;
    numBlocks = 10;
    
    % Keybord Settings
    FlushEvents('KeyDown');
    KbName('UnifyKeyNames'); 
    leftKey = KbName('LeftArrow');
    rightKey = KbName('RightArrow');
    esc = KbName('ESCAPE');
    space = KbName('Space');
    
    % Music Settings 
    home = '/Users/aysbtl/Documents/MATLAB/Psychtoolbox/dataset';
    song_info = 'SoundFiles/song_info.csv'; %strcat(home, 'SoundFiles/song_info.csv');
    song_info = readtable(song_info);
    numSongs = size(song_info);
    
    % Fixation cross Settings
    fixation = screenRect(3)/45;
    fixationColor = 255;
    fixationWidth = 5;
    fixationPos = [-fixation fixation 0 0; 0 0 -fixation fixation];
     
    % Self-Assessment Settings
    arousal = zeros(1,32);
    valence = zeros(1,32);
    imArousal='ImageFiles/arousal';
    imValence='ImageFiles/valence';
    imageLength = screenRect(3)/4;
    imageHeight = screenRect(3)/12;
    imageDims = [centerX-imageLength centerY-imageHeight-200 centerX+imageLength centerY+imageHeight-200];
    imaro=imread(imArousal, 'png');
    imval=imread(imValence, 'png');
    aTexture = Screen('MakeTexture',w,imaro);
    vTexture = Screen('MakeTexture',w,imval);
    aroScore = 5;
    valScore = 5;
    currentPos = 0;
    
    % Timing Settings
    ifi = Screen('GetFlipInterval',w);
    hertz = FrameRate(w);
    waitframes = 1;
    numFrames = 1/ifi; % how many frames can fit in one second (120 frames)
    
    HideCursor;
    
    %% Experiment Start
    % 1. Introduction Message!
    text = 'Welcome to music emotion experiment. Please press any key when you are ready!';
    intro_msg(text, w, screenRect);
    KbWait; % waits for a keyboard press before continue
    for block=1:numBlocks
        for trial=1:numTrials
        
            % Select a random music 
            randSong = randi([1,30]);
            fname= strcat('dataset/SoundFiles/', string(song_info{randSong,1}), '.mp3');
        
            % 2.Fixation cross and play music
            Screen('DrawLines', w, fixationPos, fixationWidth, fixationColor, [centerX, centerY]);
            Screen('Flip', w);
            play_music(fname, w)
            
            % 4. SAM-Valence
            [aroScore, valScore] = sam(w,screenRect);
            arousal(1,trial) = aroScore;
            valence(1,trial) = valScore;
        
            % 5. Idle Period
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
    sca;

catch
    sca; % closes the screens
    ShowCursor;
    psychrethrow(psychlasterror); % prints error message to command window
end
