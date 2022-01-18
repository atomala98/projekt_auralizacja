f = [125, 250, 500, 1000, 2000, 4000, 8000];
RT = [6.13 6.62 6.72 6.29 4.97 3.35 1.91];
rev_time = max(RT);
Fs = 44100;
sig = rand(Fs * rev_time, 1)';
x = [];
for i = 1:length(RT)
    temp = linspace(0, 3, RT(i)*Fs);
    temp = [temp zeros(1, rev_time*Fs - RT(i)*Fs) + 3];
    x = [x; -temp];
end

x = power(10, x);

Hd = design_filter_bank(Fs);

filtered = [];
for i=2:8
    filter_spec = filter(Hd(i), sig);
    prod = x(i - 1, :) .* filter_spec;
    filtered = [filtered; prod];
end

signal = sum(filtered);

