close all
clear all
clc
% input signal
[y,Fs] = audioread('signal_102.wav');
%% Plot of the signal and spectrum
N = size(y,1); % number of samples of the signal
t = linspace(0,N/Fs,N); % time vector

yDft = fft(y);
f = (0:length(y)-1)*(Fs/length(yDft));
powerY_dB = 20*log(abs(yDft));
absY = abs(yDft);
figure
subplot(2,1,1)
plot(t,y);
grid on
title('Original signal')
xlabel('Time(s)')
ylabel('y(nT)')
subplot(2,1,2)
plot(f,absY)
grid on
title('Magnitude')
xlabel('Frequency (Hz)')
ylabel('|DFT(y)|')
%% To find the peaks values (f and A)
[amplitudePeaks frequencyPeaks] = findpeaks(absY,Fs,'MinPeakDistance',5); 
%figure, findpeaks(absY,Fs,'MinPeakDistance',5)
%%
f1 = f(find(absY(1:N/2) == amplitudePeaks(2)));
f2 = f(find(absY(1:N/2) == amplitudePeaks(3)));
A1 = 2*abs(amplitudePeaks(2))/length(f);
A2 = 2*abs(amplitudePeaks(3))/length(f);
fprintf('\n *** Peaks *** \n');
fprintf('First peak found at  %5.0f Hz\n',f1);
fprintf('Second peak found at %5.0f Hz\n',f2);
fprintf('Estimated amplitude A1 = %0.2f\n',A1);
fprintf('Estimated amplitude A2 = %0.2f\n',A2);
%% First Filter: notch
d_f3db = 10;
%for f1
f0 = f1;
r = 1 - d_f3db*pi/Fs;
b0 = (1-r);
den = [1 -2*cos(2*pi*f0/Fs) r^2]; 
num = [b0 0 -b0];
figure
freqz(num, den, length(f), 'whole',Fs);
title('Second order IIR pass-band for the first carrier')
x1IIR = filter(num, den, y);


% For f2
f0 = f2;
r = 1 - d_f3db*pi/Fs;
b0 = (1-r);
den = [1 -2*cos(2*pi*f0/Fs) r^2]; %for f2
num = [b0 0 -b0];

figure
freqz(num, den, length(f), 'whole',Fs);
title('Second order IIR pass-band for the second carrier')
x2IIR = filter(num, den, y);

fprintf('\n *** second order IIR *** \n');
fprintf('3dB Bandwidth for both the IIR = %2.0f Hz\n',d_f3db);
fprintf('Target frequency first filter  = %5.0f Hz\n',f1);
fprintf('Target frequency second filter = %5.0f Hz\n',f2);
% Demodulation
x1Track = (1/A1)*x1IIR.*y;
x2Track = (1/A2)*x2IIR.*y;
%% Second filter: low pass
rpLP = 3;           % Passband ripple
rsLP = 80;          % Stopband ripple
fCut = [8000 9000];  % Cutoff frequencies

fLP = [0 2*fCut(1)/Fs 2*fCut(2)/Fs 1];
aLP = [1 1 0 0]; % desired amplitude
% Filter order
nLP = -(10*log(10^(rpLP/20)*10^(-rsLP/20))+13)/(14.6*(fCut(2)-fCut(1))/Fs); 

lowPass = firpm(ceil(nLP),fLP,aLP);
figure
freqz(lowPass,1,length(f), 'whole',Fs);
title('Linear-phase FIR low pass')

fprintf('\n *** Low pass linear phase *** \n');
fprintf('Pass band frequency = %4.0f Hz\n',fCut(1));
fprintf('Stop band frequency = %4.0f Hz\n',fCut(2));
fprintf('Desired amplitude of pass band = %1.0f \n',aLP(1));
fprintf('Desired amplitude of stop band = %1.0f \n',aLP(3));
fprintf('Stop band attenuation = %1.0f dB\n',rsLP);
fprintf('Pass-band ripple = %1.0f dB\n',rpLP);
fprintf('Order N = %1.0f \n',ceil(nLP));

x1TrackLP = filter(lowPass,1, x1Track);
x2TrackLP = filter(lowPass,1, x2Track);
%%
% Third filter: high pass
% Computation of the notch filter coefficients
f0 = 0;
d_f3dbHP = 40; 
num = [1 -2*cos(2*pi*f0/Fs) 1];
r = 1-pi*d_f3dbHP/Fs;
den = [1 -2*r*cos(2*pi*f0/Fs) r^2];
% Computation of the frequency response
figure
freqz(num,den,length(f),'whole',Fs);
title('Notch IIR high pass frequency response')

fprintf('\n *** High pass IIR *** \n');
fprintf('Center frequency = %1.0f Hz\n',f0);
fprintf('3dB Bandwidth = %2.0f Hz\n',d_f3dbHP);

x1TrackFinal = filter(num,den, x1TrackLP);
x2TrackFinal = filter(num,den, x2TrackLP);
%
x1TrackFinalDft = fft(x1TrackFinal);
fX1 = (0:length(x1TrackFinal)-1)*(Fs/length(x1TrackFinalDft));
absX1TrackFinalDft = abs(x1TrackFinalDft);

x2TrackFinalDft = fft(x2TrackFinal);
fX2 = (0:length(x2TrackFinal)-1)*(Fs/length(x2TrackFinalDft));
absX2TrackFinalDft = abs(x2TrackFinalDft);
figure
subplot(121)
plot(fX1,absX1TrackFinalDft)
title('DFT of the first signal')
xlabel('Frequency (Hz)')
ylabel('|DFT(x1)|')
subplot(122)
plot(fX2,absX2TrackFinalDft)
title('DFT of the second signal')
xlabel('Frequency (Hz)')
ylabel('|DFT(x2)|')


%
% Wrapping up
audioDoubleChannel = [x1TrackFinal x2TrackFinal];
audiowrite('DSP.wav',audioDoubleChannel, Fs)
%testPlayer = audioplayer(aTest,Fs);
%testPlayer.play;
