function [aroScore, valScore, sam_time] = sam(w, screenRect)

    try
    [centerX, centerY] = RectCenter(screenRect); % coordinates of center
    
    % Keybord Settings
    FlushEvents('KeyDown');
    KbName('UnifyKeyNames'); 
    leftKey = KbName('LeftArrow');
    rightKey = KbName('RightArrow');
    esc = KbName('ESCAPE');
    space = KbName('Space');
    
    % Self-Assessment
    imArousal='images/arousal';
    imValence='images/valence';
    imScale='images/scales';
    imageLength = screenRect(3)/3.5;
    imageHeight = screenRect(3)/16.5;
    imageDims = [centerX-imageLength centerY-imageHeight-150 centerX+imageLength centerY+imageHeight-150];
    scaleDims = [centerX-430 centerY-35 centerX+430 centerY-5];
    imaro=imread(imArousal, 'png');
    imval=imread(imValence, 'png');
    scale= imread(imScale, 'png');
    aTexture = Screen('MakeTexture',w,imaro);
    vTexture = Screen('MakeTexture',w,imval);
    sTexture = Screen('MakeTexture',w,scale);
    aroScore = 5;
    valScore = 5;

    % Cursor
    width  = 20;           % width of arrow head
    triHead   = [ centerX, centerY+30 ]; % coordinates of head
    firstPoints = [ triHead-[width,0]         % left corner
                  triHead+[width,0]         % right corner
                  triHead+[0,-width] ];      % vertex
    triColor = [0 255 0]; 
    triPos = firstPoints;
  
    text = 'Arousal (Calm/Excited)';
    text_width=RectWidth(Screen('TextBounds',w,text));
    write_text(text, 35, [255 255 255], centerX-text_width/2, centerY-300, w);
    Screen('DrawTexture', w, aTexture, [], imageDims, 0);
    Screen('DrawTexture', w, sTexture, [], scaleDims, 0);
    Screen('FillPoly', w,triColor, triPos);
    Screen('Flip',w); % SAM image is now visible on the screen
    
    currentPos = 0;
    [pressed, ~, keyCode] = KbCheck; % determine state of keyboard

    while 1
        write_text(text, 35, [255 255 255], centerX-text_width/2, centerY-300, w);
        Screen('DrawTexture', w, aTexture, [], imageDims, 0);
        Screen('DrawTexture', w, sTexture, [], scaleDims, 0);
        Screen('FillPoly', w,triColor, triPos);
        Screen('Flip',w); % SAM image is now visible on the screen 
        
        if  keyCode(rightKey) && pressed && aroScore<9
            aroScore = aroScore + 1;
            currentPos = currentPos + 94;
            triPos = [ triHead-[width-currentPos,0]        % left corner
                       triHead+[width+currentPos,0]         % right corner
                       triHead+[currentPos,-width] ];      % vertex
            write_text(text, 35, [255 255 255], centerX-text_width/2, centerY-300, w);
            Screen('DrawTexture', w, aTexture, [], imageDims, 0);
            Screen('DrawTexture', w, sTexture, [], scaleDims, 0);
            Screen('FillPoly', w, triColor, triPos);
            Screen('Flip',w); % now visible on screen  
            while KbCheck;end
            
        elseif keyCode(leftKey) && pressed && aroScore>1
            aroScore = aroScore - 1;
            currentPos = currentPos - 94;
            triPos = [ triHead-[width-currentPos,0]        % left corner
                       triHead+[width+currentPos,0]         % right corner
                       triHead+[currentPos,-width] ];      % vertex
            write_text(text, 35, [255 255 255], centerX-text_width/2, centerY-300, w);
            Screen('DrawTexture', w, aTexture, [], imageDims, 0);
            Screen('DrawTexture', w, sTexture, [], scaleDims, 0);
            Screen('FillPoly', w, triColor, triPos);
            Screen('Flip',w); % now visible on screen  
            while KbCheck;end
    
        elseif keyCode(space)
            break;
        end
        [pressed, ~, keyCode] = KbCheck; % determine state of keyboard
        
    end
    while KbCheck;end
    
    text = 'Valence (Negative/Positive)';
    text_width=RectWidth(Screen('TextBounds',w,text));
    write_text(text, 35, [255 255 255], centerX-text_width/2, centerY-300, w);
    Screen('DrawTexture', w, vTexture, [], imageDims, 0);
    Screen('DrawTexture', w, sTexture, [], scaleDims, 0);
    Screen('FillPoly', w,triColor, firstPoints);
    Screen('Flip',w); % SAM image is now visible on the screen 
    triPos = firstPoints;
    currentPos=0;
    [pressed, ~, keyCode] = KbCheck; % determine state of keyboard

    while 1
        write_text(text, 35, [255 255 255], centerX-text_width/2, centerY-300, w);
        Screen('DrawTexture', w, vTexture, [], imageDims, 0);
        Screen('DrawTexture', w, sTexture, [], scaleDims, 0);
        Screen('FillPoly', w,triColor, triPos);
        Screen('Flip',w); % SAM image is now visible on the screen
        
        if  keyCode(rightKey) && pressed && valScore<9
            valScore = valScore + 1;
            currentPos = currentPos + 94;
            triPos = [ triHead-[width-currentPos,0]        % left corner
                       triHead+[width+currentPos,0]         % right corner
                       triHead+[currentPos,-width] ];      % vertex
            write_text(text, 35, [255 255 255], centerX-text_width/2, centerY-300, w);
            Screen('DrawTexture', w, vTexture, [], imageDims, 0);
            Screen('DrawTexture', w, sTexture, [], scaleDims, 0);
            Screen('FillPoly', w,triColor, triPos);
            Screen('Flip',w); % now visible on screen  
            while KbCheck;end
            
        elseif keyCode(leftKey) && pressed && valScore>1
            valScore = valScore - 1;
            currentPos = currentPos - 94;
            triPos = [ triHead-[width-currentPos,0]        % left corner
                       triHead+[width+currentPos,0]         % right corner
                       triHead+[currentPos,-width] ];      % vertex
            write_text(text, 35, [255 255 255], centerX-text_width/2, centerY-300, w);
            Screen('DrawTexture', w, vTexture, [], imageDims, 0);
            Screen('DrawTexture', w, sTexture, [], scaleDims, 0);
            Screen('FillPoly', w,triColor, triPos);
            Screen('Flip',w); % now visible on screen  
            while KbCheck;end
    
        elseif keyCode(space)
            break;
        end
        [pressed, ~, keyCode] = KbCheck; % determine state of keyboard
    end

    catch
        sca; % closes the screens
        ShowCursor;
        psychrethrow(psychlasterror); % prints error message to command window
    end

end