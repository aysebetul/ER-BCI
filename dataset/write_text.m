function write_text(text, text_size, text_color, textX, textY, w)
try
    Screen('TextSize', w, text_size);
    Screen('TextFont', w, 'Times');
    Screen('DrawText', w, text, textX, textY, text_color);
    %Screen('Flip', w);
catch
    sca; % closes the screens
    ShowCursor;
    psychrethrow(psychlasterror); % prints error message to command window
end
end