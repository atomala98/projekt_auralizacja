function signal = telephone(input)

tele = fir1(50, [0.013 0.18]);

signal = filter(tele, 1, input);
end