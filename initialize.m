function fPrev = initialize(sig,accData)
% initialize estimate initial fequency
    % parameters : 
    %   sig     : ppg signal data
    %   accData : accelaration data (x,y,z)
    
w=linspace(50,150,4000);
ww = 2 * pi * linspace(50,150,4000) / (125 * 60); 
fSig = abs(freqz(sig, 1, ww));

[val,locs]=findpeaks(fsig, 'MINPEAKHEIGHT', 0.8*max(fsig),...
                    'SORTSTR', 'descend');
                
if length(locs)==1
    fPrev = val;
    return;
end

% if more than one frequencies have value above 80% 
% then we look for their second harmonics

peakFrequency = w(locs);
secondHarmonicMax = -1;

for i = 1:length(locs)
    for j = 1:length(locs)
        if i ~= j && abs( 2 * peakFrequency(i) - peakFrequency(j)) < 5 
            if peakFrequency(i) > secondHarmonicMax
               secondHarmonicMax =  peakFrequency(i);
            end         
        end
        
    end
end









end