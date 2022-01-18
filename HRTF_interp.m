function [out, test] = HRTF_interp(HRTF_to_use, interp, HRTFs, signal)

HRTF_arr_l = [];
HRTF_arr_r = [];

for i = HRTF_to_use
    HRTF_arr_l = [HRTF_arr_l HRTFs{i, 3}];
    HRTF_arr_r = [HRTF_arr_r HRTFs{i, 4}];
end


HRTF_arr_l = HRTF_arr_l';
HRTF_arr_r = HRTF_arr_r';


HRTF_arr_interp_l = [];
HRTF_arr_interp_r = [];

%HRTF_arr_l(1, :)

for i = 1:size(HRTF_to_use, 2)-1
    for j = 0:interp
        HRTF_arr_interp_l = [HRTF_arr_interp_l; HRTF_arr_l(i, :)*abs(j - 5)/5 + HRTF_arr_l(i + 1, :)*j/5];
    end
end

%HRTF_arr_interp_l(1, :)

for i = 1:size(HRTF_to_use, 2)-1
    for j = 0:interp
        HRTF_arr_interp_r = [HRTF_arr_interp_r; HRTF_arr_r(i, :)*abs(j - 5)/5 + HRTF_arr_r(i + 1, :)*j/5];
    end
end

splits = size(signal, 1) / size(HRTF_arr_interp_l, 1);

out_l = [];
out_r = [];

test = [];

for i = 1:size(HRTF_arr_interp_l, 1)
    %out_l = [out_l; signal(floor((i-1)*splits+1):floor(i*splits), 1)];
    %out_r = [out_r; signal(floor((i-1)*splits+1):floor(i*splits), 2)];
    out_l = [out_l; conv(signal(floor((i-1)*splits+1):floor(i*splits), 1), HRTF_arr_interp_l(i, :), 'same')];
    out_r = [out_r; conv(signal(floor((i-1)*splits+1):floor(i*splits), 2), HRTF_arr_interp_r(i, :), 'same')];
end

test = signal;

out = [out_l out_r];

end
