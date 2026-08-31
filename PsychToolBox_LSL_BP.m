% Clear the workspace
clear all;
close all;
sca;
Screen('Preference', 'SkipSyncTests', 1);

NumTrials = 1000;
FlashTime = 0.5;

% LSL Setup
lib = lsl_loadlib();
LSL_markers_info = lsl_streaminfo(lib,'TriggerStream','Markers',1,0,'cf_int32','SourceID42');
LSL_markers = lsl_outlet(LSL_markers_info);

% TriggerBox Setup:
%port = serialport('COM3',9600);

% Start immediately (0 = immediately)
startCue = 10;
% pause(10)

%---------------
% Screen Setup
%---------------

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');

% Select the external screen if it is present, else revert to the native
% screen
screenNumber = max(screens);

% Define black, white and grey
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
grey = white / 2;

% Open an on screen window and color it grey
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Set the blend function for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Get the size of the on screen window in pixels
% For help see: Screen WindowSize?
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
baseRect = [0 0 100 100];
rectColor_w = [1 1 1];
rectColor_b = [0 0 0];


% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Get the centre coordinate of the window in pixels
% For help see: help RectCenter
% [xCenter, yCenter] = RectCenter(windowRect);

% Set the text size
% Screen('TextSize', window, 70);

% Calculate how long the beep and pause are in frames
FlashFrames = round(FlashTime / ifi);


% Draw beep text
for t = 1:NumTrials
    for i = 1:FlashFrames
        if i == 1
            LSL_markers.push_sample(1);
            %write(port, 1, "uint8");
        end
        Screen('FillRect', window, rectColor_w, baseRect);
        % Flip to the screen
        Screen('Flip', window);        
    end
    for i = 1:FlashFrames
        if i == 1
            LSL_markers.push_sample(0);
            %write(port, 0, "uint8");
        end
        Screen('FillRect', window, rectColor_b, baseRect);
        % Flip to the screen
        Screen('Flip', window);        
    end
    NumTrials = NumTrials + 1;
end
sca
delete(LSL_markers);
