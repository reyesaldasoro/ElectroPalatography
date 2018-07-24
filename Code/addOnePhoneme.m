% detect which phoneme is depending on the current time vector
% videoParam.tempTimeVector(1,k)

if isfield(videoParam,'LAB')
    
    try
        currentPhoneme = find( ([videoParam.Phonemes{:,1}]>videoParam.tempTimeVector(1,k)) ~= ...
            ([videoParam.Phonemes{:,2}]>videoParam.tempTimeVector(1,k)) );
    catch
        currentPhoneme = 0;
    end
    if currentPhoneme >0
        %for k=1:videoParam.numPhonemes
        if strcmp(videoParam.Phonemes{currentPhoneme,3},'sil')
            colCode = 0.4*[1 1 1];
        elseif  strcmp(videoParam.Phonemes{currentPhoneme,3},'breath')
            colCode = 0.8*[0 0 1];
        else
            colCode = [0 0 0];
        end
        % add phonemes one by one
        h1.Title.String = videoParam.Phonemes{currentPhoneme,3};
        h1.Title.Color = colCode;
        h1.Title.FontSize = 16;
%        text(   (videoParam.Phonemes{currentPhoneme,1}+videoParam.Phonemes{currentPhoneme,2})/2,...
 %           (-1)^currentPhoneme*0.7*videoParam.maxSignal,videoParam.Phonemes{currentPhoneme,3}, 'color',colCode);
        % add a line at the beginning of each time identified for the phonemes
        % line([videoParam.Phonemes{currentPhoneme,1} videoParam.Phonemes{currentPhoneme,1}],[0.8*videoParam.minSignal 0.8*videoParam.maxSignal],'color','r','linestyle','--')
    end
end