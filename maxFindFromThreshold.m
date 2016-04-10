function maxFreqs = maxFindFromThreshold (sig,threshold,fSampling)

   w = linspace(0,300,4096);
   ww = 2*pi*w / (fSampling*60);
    
   Psig = abs(freqz( sig,1,ww )).^2;
   
   

   [ ~ , maxFreqs] =  findpeaks(Psig,'minpeakheight',threshold * max(Psig),...
    'minpeakdistance',3,'SortStr','descend');


end