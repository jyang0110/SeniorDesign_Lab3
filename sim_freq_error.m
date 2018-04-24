% a script that reads a clean wav file and deliberately introduces
% a specified frequency error and saves the result in a pair of new wav
% files representing the I and Q received signal channels

% this script should be used for testing your frequency-error correction
% DSP module. Specifically, your module should be able to read the two
% distorted wav files output by this script and produce a "cleaned up" 
% set of audio samples that sound like the original

clear all;

wavfilename='bicycle_built_for_2_feb16_2012.wav';

% this script will be sometimes needed to correct for poorly formatted wav
% files and allow them to be read by MATLAB.
% wavchunksizefix(wavfilename);

% read samples from wav file
[yy,Fs]=audioread(wavfilename);

% ignore other channels if more than one channel is present
y=yy(:,1);
% playback a few seconds of samples just to test
sound(y(1:3*Fs),Fs);
pause(3);

% Fs is the sample rate and Ts is the inter-sample interval
Ts=1/Fs;

N=length(y);    % total number of samples
% the vector of sampling times
t_samp=Ts*(0:N-1);

% specify the frequency error you want to apply
% typical values are in the range -500 Hz to 500 Hz
% note that frequency error can be nagative
freq_err=-185;   % units of Hz

% the "residual modulation" factor from frequency error
res_mod=exp(1j*2*pi*freq_err*t_samp);

distorted_signal=transpose(y).*res_mod;

distorted_I=real(distorted_signal);
distorted_Q=imag(distorted_signal);

% play back a few seconds worth of the distorted audio
sound(distorted_I(1:3*Fs),Fs);
pause(3);

% save the I and Q channels of the distorted signal in wav files
audiowrite('distorted_I.wav',distorted_I,Fs);
audiowrite('distorted_Q.wav',distorted_Q,Fs);
