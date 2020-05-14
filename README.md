# Digital Signal Processing
Given an input signal, *signal_102.wav*, of the form
![formula](/img/formula.png)
the requirede task is to extract a stereo audio file, using the filters de-
scribed in the corrisponding sections of this paper.

>**For a detailed description of the project, see the PDF file inside the [Discussion and results](https://github.com/gitMelk/Digital-Signal-Processing/tree/master/Discussion%20and%20results) folder**

# Introduction to the project


Known information:
-x1(nT) and x2(nT) are two real audio information signals with fre-
quency band [20,8000] Hz;
- The sampling frequency is 96000 Hz;
- The audio file is 42 seconds long;
- f1 and f2 are the frequencies of the carriers, their relation is: 10000
Hz ≤ f1 < f2 ≤ 38000 Hz; f2− f1 ≤ 17000 Hz. A1 and A2 are the
amplitudes of the carriers.

>![first-image](/img/1.png)
>*Plot of the raw data and its spectrum. It clearly shows
two main peaks and they are the frequencies of the carriers: f1 at 18800
Hz and f2 at 37600 Hz.*

And as final result an audio file is produced, it’s a segment from “Father and Son” by
Cat Stevens.: 
>![second-image](/img/5.png)
>*In the final spectrum of the two demodulated signals,  we
can see that only the frequencies until 8000 Hz are relevant, so, as we
wanted, there is no high frequency presence outside the filtered range.*


<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />For the paper, the license used is: <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.
