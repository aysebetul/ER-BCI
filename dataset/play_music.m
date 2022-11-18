function play_music(filename, duration, volume)

% Read mp3 file from filesystem:
[soundData, freq] = audioread(filename);
wavedata = soundData';
nrchannels = size(wavedata,1); % Number of rows == number of channels.


try
    % Try with the 'freq'uency we wanted:
    pahandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels);
catch
    % Failed. Retry with default frequency as suggested by device:
    fprintf('\nCould not open device at wanted playback frequency of %i Hz. Will retry with device default frequency.\n', freq);
    fprintf('Sound may sound a bit out of tune, ...\n\n');
    psychlasterror('reset');
    pahandle = PsychPortAudio('Open', device, [], 0, [], nrchannels);
end

PsychPortAudio('Volume',pahandle,volume);

% Fill the audio playback buffer with the audio data 'wavedata':
PsychPortAudio('FillBuffer', pahandle, wavedata);
%3. Trigger: send Trigger when it starts to play music
%send_trigger();

PsychPortAudio('Start', pahandle, 1, 0, 1);

WaitSecs(duration);

% Stop playback:
PsychPortAudio('Stop', pahandle);

%4. Trigger: send Trigger when the music stops
%send_trigger();
%Screen('FillRect', w, dark_gray);

% Close the audio device:
PsychPortAudio('Close', pahandle);

% Done.
fprintf('Finished \n');

end