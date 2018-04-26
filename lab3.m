close all; %deletes all figures
clear all; %removes all variables from the current workspace

I_channel='distorted_I.wav'; %Load 'distorted_I.wav'
Q_channel='distorted_Q.wav'; %Load 'distorted_Q.wav'
wavchunksizefix(I_channel); %Correct for poorly formatted wav files and allow them to be read by MATLAB
wavchunksizefix(Q_channel); 
[II,Fs]=audioread(I_channel); %Read I siginal channel from wav file, Fs = sampling rate in I singal channel per second
[QQ,Fs]=audioread(Q_channel); %Read Q siginal channel from wav file, Fs = sampling rate in Q singal channel per second
II=II(:,1); %Ignore more than one channels
QQ=QQ(:,1);
Ts=1/Fs; %Ts is the inter-sample interval

signal=II'+j*QQ'; %s = i + jq, to combine real and imaginary part
N = length(signal) %Returns the length of the signal
singal = sigwin.hann(N,'periodic'); %Using hanning window to reduce leakage and frequency interference
T_buf = 0.5; %Number of seconds worth of samples
N_buf = floor(T_buf/Ts); %Total number of samples

n=0; %Counter
undistorted_signal = zeros(1,N); %Create a 1-by-N matrix of all zeros
ffreq_estimate = 0; %Initial the average estimated frequency

%Now sit in a loop and process each block of signals
while ((n+1)*N_buf <= N)
    freq_estimate=freq_estimator(signal((n*N_buf+1:(n+1)*N_buf)),Ts); %Use freq_estimator function to estimate the frequency of each part
    n_res_mod=exp(-j*2*pi*freq_estimate*((n*N_buf+1:(n+1)*N_buf))*Ts); %The "residual modulation" factor from frequency error
    undistorted_signal((n*N_buf+1:(n+1)*N_buf)) = signal((n*N_buf+1:(n+1)*N_buf)).*n_res_mod; %Undistorted each block of signals
    ffreq_estimate = ffreq_estimate + freq_estimate; %Calculate total estimated frequency
    n=n+1;
end;

freq_avg_estimate = ffreq_estimate/(n-1); %Calculate average estimated frequency
str1=sprintf('Average estimated frequency is: %0.1f Hz', freq_avg_estimate); %Print the average estimated frequency
display(str1); %Display the average estimated frequency
undistorted_signal = real(undistorted_signal); %returns the real part of singal
audiowrite('undistorted_output.wav',undistorted_signal,Fs); %Write a WAVE file in the current folder

function freq_estimate = freq_estimator(audio,Ts) %A function to estimate the frequency
sigphase=angle((audio).^2); %Return phase angle of the squared audio signal
tsamp_n = Ts:Ts:(Ts*length(audio));
uwphase=unwrap(sigphase); %Unwrap the phase angle because if phase crosses 360 degrees and reset to zero which will make it impossible to see the linear variation over time
p=polyfit(tsamp_n,uwphase,1); %Fit a polynomial of degree 1
freq_estimate=p(1)/(2*pi*2);
str2=sprintf('The Estimated frequency is: %0.1f Hz',freq_estimate); %The estimated frequency for each time period
display(str2);

end
