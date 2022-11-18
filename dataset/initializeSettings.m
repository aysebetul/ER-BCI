% parameters should be set before experiment
song_duration=5; % song duration
idle_duration=2;
volume = 0.3; % should be between 0-1
numTrials = 2;
numBlocks = 2;

%% Constant Parameters
% Screen Settings
% Perform basic initialization of the sound driver:
PsychDefaultSetup(2);
nr=max(Screen('Preference', 'SkipSyncTests', 2));
[w, screenRect]=PsychImaging('OpenWindow',nr,0,[],32,2); % open screen
[centerX, centerY] = RectCenter(screenRect); % coordinates of center
data.screen.x = centerX;
data.screen.y = centerY;
data.screen.rectangle = screenRect;

% Colors
white = WhiteIndex(w);
black = BlackIndex(w);
dark_gray = GrayIndex(w,0.8);
light_gray = GrayIndex(w,0.2);

% Sound Settings
InitializePsychSound;
devices = PsychPortAudio('GetDevices', [], []);
data.sound.deviceName = devices(2).DeviceName;
data.sound.LowInputLatency = devices(2).LowInputLatency;
data.sound.LowOutputLatency = devices(2).LowOutputLatency;
data.sound.HighInputLatency = devices(2).HighInputLatency;
data.sound.HighOutputLatency = devices(2).HighOutputLatency;
data.sound.samplingRate = devices(2).DefaultSampleRate;

% % Trigger Settings
% %config_io;
% %address = hex2dec('DFF8');  % ??
% port = "COM4";
% baudrate = 9600;
% s = serialport(port, baudrate,"Timeout",5);
% data.trigger = [];
% 
% % LSL Settings
% lib = lsl_loadlib();
% LSL_markers_info = lsl_streaminfo(lib,'TriggerStream','Markers',1,0,'cf_int32','SourceID42');
% LSL_markers = lsl_outlet(LSL_markers_info);

% Keybord Settings
FlushEvents('KeyDown');
KbName('UnifyKeyNames'); 

% Music Settings
home = '/Users/aysbtl/Documents/MATLAB/Psychtoolbox/dataset';
song_info = 'dataset/SoundFiles/song_info.csv'; %strcat(home, 'SoundFiles/song_info.csv');
song_info = readtable(song_info);
hs = song_info(song_info.category==1,:);
ss = song_info(song_info.category==0,:);
devices = PsychPortAudio('GetDevices', [], []);
data.music.singer = strings;
data.music.song= strings;
data.music.songID= strings;
data.music.category = [];

% Load data into memory?

% Fixation cross Settings
fixation = screenRect(3)/45;
fixationColor = 255;
fixationWidth = 5;
fixationPos = [-fixation fixation 0 0; 0 0 -fixation fixation];
data.fixation.color = fixationColor;
data.fixation.posititon = fixationPos;
data.fixation.width = fixationWidth;

% Timing Settings
ifi = Screen('GetFlipInterval',w);
hertz = FrameRate(w);
waitframes = 1;
numFrames = 1/ifi; % how many frames can fit in one second (120 frames)

% Save all information
data.exp = 'music_experiment';
data.subject = subjectId;
data.trial = [];
data.block = [];
data.trial_time = [];
data.date = date;
data.ifi = ifi;
data.volume = volume;

data.sam.time = [];
data.sam.arousal = [];
data.sam.valence = [];

HideCursor;