
if isfield(EPG_parameters,'Phonemes')
    for k=1:EPG_parameters.numPhonemes
        if strcmp(EPG_parameters.Phonemes{k,3},'sil')
            colCode = 0.4*[1 1 1];
        elseif  strcmp(EPG_parameters.Phonemes{k,3},'breath')
            colCode = 0.8*[0 0 1];
        else
            colCode = [0 0 0];
        end
        % add phonemes one by one
        text(   (EPG_parameters.Phonemes{k,1}+EPG_parameters.Phonemes{k,2})/2,...
            (-1)^k*0.7*EPG_parameters.maxSignal,EPG_parameters.Phonemes{k,3}, 'color',colCode);
        % add a line at the beginning of each time identified for the phonemes
        line([EPG_parameters.Phonemes{k,1} EPG_parameters.Phonemes{k,1}],[0.8*EPG_parameters.minSignal 0.8*EPG_parameters.maxSignal],'color','r','linestyle','--')
    end
end