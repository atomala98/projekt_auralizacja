function output = static_HRTF(input, HRTFL, HRTFR)

%left
signal_l = conv(input(:, 1), HRTFL, 'same');

signal_r = conv(input(:, 2), HRTFR, 'same');

output = [signal_l signal_r];

end