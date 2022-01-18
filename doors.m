function signal = doors(R, input, Fs)

[H, fc] = design_filter_bank(Fs);

w = sqrt(10.^-(R/10));

signal = zeros(length(filter(H(1), input)), 1);

for i = 1:length(fc)
    signal = signal + filter(H(i), input)*w(i);
end

end