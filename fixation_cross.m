function fixation_cross(w, screenRect)

try
    %Fixation Cross
    [centerX, centerY] = RectCenter(screenRect); % coordinates of center
    fixation = screenRect(3)/45;
    fixationColor = 255;
    fixationWidth = 5;
    fixationPos = [-fixation fixation 0 0; 0 0 -fixation fixation];
    Screen('DrawLines', w, fixationPos, fixationWidth, fixationColor, [centerX, centerY]);
catch
    sca; % closes the screens
    ShowCursor;
    psychrethrow(psychlasterror); % prints error message to command window
end

end
