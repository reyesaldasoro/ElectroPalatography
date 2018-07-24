% detect which phoneme is depending on the current time vector
% EPG_parameters.tempTimeVector(1,k)

if isfield(EPG_parameters,'Phonemes')
    
    try
        currentPhoneme = find( ([EPG_parameters.Phonemes{:,1}]>EPG_parameters.tempTimeVector(1,k)) ~= ...
            ([EPG_parameters.Phonemes{:,2}]>EPG_parameters.tempTimeVector(1,k)) );
    catch
        currentPhoneme = 0;
    end
    if currentPhoneme >0
        %for k=1:EPG_parameters.numPhonemes
        if strcmp(EPG_parameters.Phonemes{currentPhoneme,3},'sil')
            colCode = 0.4*[1 1 1];
        elseif  strcmp(EPG_parameters.Phonemes{currentPhoneme,3},'breath')
            colCode = 0.8*[0 0 1];
        else
            colCode = [0 0 0];
        end
        % add phonemes one by one
        h1.Title.String = EPG_parameters.Phonemes{currentPhoneme,3};
        h1.Title.Color = colCode;
        h1.Title.FontSize = 16;
%        text(   (EPG_parameters.Phonemes{currentPhoneme,1}+EPG_parameters.Phonemes{currentPhoneme,2})/2,...
 %           (-1)^currentPhoneme*0.7*EPG_parameters.maxSignal,EPG_parameters.Phonemes{currentPhoneme,3}, 'color',colCode);
        % add a line at the beginning of each time identified for the phonemes
        % line([EPG_parameters.Phonemes{currentPhoneme,1} EPG_parameters.Phonemes{currentPhoneme,1}],[0.8*EPG_parameters.minSignal 0.8*EPG_parameters.maxSignal],'color','r','linestyle','--')
    end
end