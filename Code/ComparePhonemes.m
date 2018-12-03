clear all
%%
%baseDir    = '/Users/ccr22/OneDrive - City, University of London/Acad/City_Research/JoVerhoeven/MOCHA_Relabelled/fsew0_v1.1\';
%baseDir     = 'D:\OneDrive - City, University of London\Acad\City_Research\JoVerhoeven\MOCHA_Relabelled\fsew0_v1.1\';
%baseDir    = 'D:\OneDrive - City, University of London\Acad\City_Research\JoVerhoeven\MOCHA_Relabelled\msak0_v1.1\';
%speaker     = 'msak';
speaker     = 'fsew';
baseDir     = strcat('D:\OneDrive - City, University of London\Acad\City_Research\JoVerhoeven\MOCHA_Relabelled\',speaker,'0_v1.1\');
dir0        = dir(strcat(baseDir,'*.mat'));
numPhrases  = size(dir0,1);
%% define phonemes of interest in a list
listPhonemes    = {'n','d','t','r','ng','g','k','w','z','s','zh','sh','l','jh','ch'};
numPhonemes     = size(listPhonemes,2);
%% initialise the cell where results will be stored
avPhoneme_tot{numPhonemes,8}=[];
for count_phoneme = 1:numPhonemes
    avPhoneme_tot{count_phoneme,1} = listPhonemes{count_phoneme};
    %avPhoneme_tot{count_phoneme,2} =[];
end
%% calculate all the occurrences per phrase / per phoneme
for k=1:numPhrases
    % iterate over the
    disp(dir0(k).name)
    load(strcat(baseDir,dir0(k).name));
    for count_phoneme = 1:size(listPhonemes,2)
        avPhoneme_tot{count_phoneme,2} = extract_Phoneme_EPG_2018_11_28(EPG_parameters,listPhonemes{count_phoneme},avPhoneme_tot{count_phoneme,2});
    end
end

%% Calculate asymmetries

for k = 1:numPhonemes
    totalActivation     = sum(avPhoneme_tot{k,2}(:));
    frontActivation     = sum(sum(sum(avPhoneme_tot{k,2}(1:150,:,:))));
    backActivation      = sum(sum(sum(avPhoneme_tot{k,2}(151:300,:,:))));
    totalAsymmetry      = sum([sum(sum(avPhoneme_tot{k,2}(:,1:120,:)))          sum(sum(avPhoneme_tot{k,2}(:,121:240,:)))],3)/totalActivation;
    frontAsymmetry      = sum([sum(sum(avPhoneme_tot{k,2}(1:150,1:120,:)))      sum(sum(avPhoneme_tot{k,2}(1:150,121:240,:)))],3)/frontActivation;
    backAsymmetry       = sum([sum(sum(avPhoneme_tot{k,2}(151:300,1:120,:)))    sum(sum(avPhoneme_tot{k,2}(151:300,121:240,:)))],3)/backActivation;
    avPhoneme_tot{k,3}  = totalAsymmetry(1);
    avPhoneme_tot{k,4}  = totalAsymmetry(2);
    avPhoneme_tot{k,5}  = frontAsymmetry(1);
    avPhoneme_tot{k,6}  = frontAsymmetry(2);
    avPhoneme_tot{k,7}  = backAsymmetry(1);
    avPhoneme_tot{k,8}  = backAsymmetry(2);
end


%% Display
jet2=jet;
jet2(1,:) =0;

for k = 1:numPhonemes
    
    
    
    figure(1)
    imagesc(sum(avPhoneme_tot{k,2},3));colorbar
    colormap(jet2)
    %  title(strcat('msak: [',32,avPhoneme_tot{k,1},32,'], Asym:',num2str(totalAsymmetry(1)),'/',num2str(totalAsymmetry(2))),'fontsize',15)
    combinedTitle{1}    = strcat(speaker,': [',32,avPhoneme_tot{k,1},32,']');
    combinedTitle{2}    = strcat('Total Asym:',32,num2str(totalAsymmetry(1)),32,'/',32,num2str(totalAsymmetry(2)));
    combinedTitle{3}    = strcat('Front Asym:',32,num2str(frontAsymmetry(1)),32,'/',32,num2str(frontAsymmetry(2)));
    combinedTitle{4}    = strcat('Back  Asym:',32,num2str(backAsymmetry(1)),32,'/',32,num2str(backAsymmetry(2)));
    
    title(combinedTitle,'fontsize',12)
    %  title(strcat('fsew: [',32,avPhoneme_tot{k,1},32,'], Asym:',num2str(totalAsymmetry(1)),'/',num2str(totalAsymmetry(2))),'fontsize',15)
    axis off
    
    %  filename=strcat('msak_sum_',avPhoneme_tot{k,1});
    filename=strcat(speaker,'_sum_',avPhoneme_tot{k,1});
    set(gcf,'color','w')
    set(gcf,'PaperPositionMode','auto')
    set(gcf,'InvertHardcopy','off')
    print('-djpeg','-r100',filename)
    
    
    figure(2)
    montage(avPhoneme_tot{k,2}./(repmat(max(max(avPhoneme_tot{k,2})),[300 240 1])))
    colormap(jet2)
    %  title(strcat('msak: [',32,avPhoneme_tot{k,1},32,'], Asym:',num2str(totalAsymmetry(1)),'/',num2str(totalAsymmetry(2))),'fontsize',15)
    title(strcat(speaker,': [',32,avPhoneme_tot{k,1},32,'], Asym:',num2str(totalAsymmetry(1)),'/',num2str(totalAsymmetry(2))),'fontsize',15)
    drawnow
    pause(0.5)
    
    %  filename=strcat('msak_montage_',avPhoneme_tot{k,1});
    filename=strcat(speaker,'_montage_',avPhoneme_tot{k,1});
    set(gcf,'color','w')
    set(gcf,'PaperPositionMode','auto')
    set(gcf,'InvertHardcopy','off')
    print('-djpeg','-r100',filename)
    
    %sum([sum(sum(avPhoneme_d(:,1:120,:))) sum(sum(avPhoneme_d(:,121:240,:)))],3)/sum(avPhoneme_d(:))
end
