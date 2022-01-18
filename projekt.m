% HRTFs for intrpolation
%interp_HRTF = [34, 35, 36, 37, 38, 39, 40, 100, 101, 102, 103, 104, 105, 106, 107, 108, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 271, 272, 273, 274, 275, 276, 277, 278, 279];
interp_HRTF = [313:332 261:279];


% folder name

folder = 'output_files\';

% loading audio files
[corridor, Fs_cor] = audioread("corridor.wav");

[music, Fs_mus] = audioread('muzyka1.wav');

[phone, Fs_pho] = audioread('mowa.wav');

phone = [phone phone];

%cutting music recording

music = music(1:300000, :);

music = [mean(music, 2) mean(music, 2)];

%setting audio levels

corridor = corridor / 3;

music = music / 25;

phone = phone / 20;

% normalise recordings

audiowrite(folder + "corridor-normalised.wav", corridor, Fs_cor);

audiowrite(folder + "music-normalised.wav", music, Fs_mus);

audiowrite(folder + "phone-normalised.wav", phone, Fs_pho);

% adding doors absorbtion

corridor = doors([20, 10, 5, 15, 20, 25, 30, 35, 37, 39], corridor, Fs_cor);

audiowrite(folder + "corridor-absorbtion.wav", corridor, Fs_cor);

% filtering phone call

phone = telephone(phone);

audiowrite(folder + "phone-filtered.wav", phone, Fs_pho);

% HRTF

load HRTF_new.mat;

% phone 

music_start = music(1:size(music, 1) * (3/4), :);

music_end = music(size(music, 1) * (3/4):size(music, 1), :);

music_start = static_HRTF(music_start, HRTFs{313, 3}, HRTFs{313, 4});

music_end = HRTF_interp(interp_HRTF, 2, HRTFs, music_end);

music = [music_start; music_end];

audiowrite(folder + "music-HRTF.wav", music, Fs_mus);

% right ear call - HRTF(279);

phone = static_HRTF(phone, HRTFs{279, 3}, HRTFs{279, 4});

audiowrite(folder + "phone-HRTF.wav", phone, Fs_pho);

% impulse responses

[real_response, Fs_res] = audioread('real-response.wav');

real_response = mean(real_response, 2);

fake_response = imp_response([1.81, 1.43, 1.06, 1.02, 0.96, 0.92], Fs_res)';

audiowrite(folder + "fake-response.wav", fake_response, Fs_res);

% adding reverb

true_music = [conv(music(:, 1), real_response, 'same') conv(music(:, 2), real_response, 'same')];

true_phone = [conv(phone(:, 1), real_response) conv(phone(:, 2), real_response)];

true_corridor = [conv(corridor(:, 1), real_response), conv(corridor(:, 2), real_response)];

audiowrite(folder + "corridor-real-reverb.wav", true_corridor, Fs_cor);

audiowrite(folder + "music-real-reverb.wav", true_music, Fs_mus);

audiowrite(folder + "phone-real-reverb.wav", true_phone, Fs_pho);


% normalising fake response

diff = mean(abs(fake_response), 'all') / mean(abs(real_response), 'all');

fake_response = fake_response / diff;

fake_music = [conv(music(:, 1), fake_response, 'same') conv(music(:, 2), fake_response, 'same')];

fake_phone = [conv(phone(:, 1), fake_response) conv(phone(:, 2), fake_response)];

fake_corridor = [conv(corridor(:, 1), fake_response), conv(corridor(:, 2), fake_response)];

audiowrite(folder + "corridor-fake-reverb.wav", fake_corridor, Fs_cor);

audiowrite(folder + "music-fake-reverb.wav", fake_music, Fs_mus);

audiowrite(folder + "phone-fake-reverb.wav", fake_phone, Fs_pho);

% phone call sum

true_phone_call = [true_music; true_phone];

fake_phone_call = [fake_music; fake_phone];

audiowrite(folder + "phone-call.wav", true_phone_call, Fs_pho);

% recording sum

output = [true_corridor(1:80000, :); true_corridor(80000:(80000 + size(true_phone_call, 1) - 1), :) + true_phone_call; true_corridor(80000 + size(true_phone_call, 1):1000000, :)];

fake_output = [fake_corridor(1:80000, :); fake_corridor(80000:(80000 + size(fake_phone_call, 1) - 1), :) + fake_phone_call; fake_corridor(80000 + size(fake_phone_call, 1):1000000, :)];

audiowrite(folder + "final-version.wav", output, Fs_pho);

audiowrite(folder + "fake-final-version.wav", fake_output, Fs_pho);
