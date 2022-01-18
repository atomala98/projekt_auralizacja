function response = imp_response(RT, Fs)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
f = [125, 250, 500, 1000, 2000, 4000];
rev_time = max(RT);
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
for i=2:7
    filter_spec = filter(Hd(i), sig);
    prod = x(i - 1, :) .* filter_spec;
    filtered = [filtered; prod];
end

response = sum(filtered);

end