function [Hd, F0]=design_filter_bank(fs)

BandsPerOctave = 1;
N = 6;           % Filter Order
F0 = 1000;       % Center Frequency (Hz)
Fs = fs;      % Sampling Frequency (Hz)
f = fdesign.octave(BandsPerOctave,'Class 1','N,F0',N,F0,Fs);


F0 = validfrequencies(f);
Nfc = length(F0);
for i=1:Nfc,
    f.F0 = F0(i);
    Hd(i) = design(f,'butter');
end
