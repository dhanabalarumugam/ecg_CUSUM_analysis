%	TITLE:      ECG Signal Analysis for MI Detection
%	
%	AUTHORS:    Uzair Akbar
%	            Asfandyar Hassan Shah
%	            Ryshum Ali
%	            Mahnoor Naveed
%               Saad Qureshi
%	
%	INSTITUTION:National University of Sciences & Technology (NUST), Sector
%	            H-12, Islamabad Pakistan.
%	
%	DATED:      May 29, 2015
%	
%	VERSION:    0.0.1
%	
%	LICENSE:	CC0 1.0 Universal
%	
%	REPORT:		http://www.slideshare.net/uzairakbar25/project-report-48938679
%   
%   DESCRIPTION:
%               This project studies a prospective method by which we can
%   detect MI. Our approach analyses the ECG (electrocardiogram) of a
%   patient in real-time and extracts the ST elevation from each cycle.
%   The ST elevation plays an important part in MI detection. We then use
%   the sequential change point detection algorithm; CUmulative SUM
%   (CUSUM), to detect any deviation in the ST elevation spectrum and to
%   raise an alarm if we find any.

clear;
clc;

Fs = 250;       %   ECG Sampling Frequency
T = 3600*2;     %   Time in seconds

%   The project uses the EDB medical database from the PhysioNet. This
%   database consists of 90 annotated ECG recordings from 79 subjects.
%   These subjects have various heart anomalies (vessel disease,
%   hypertension, coronary artery disease, ventricular dyskinesia, and
%   myocardial infarction). Each data trace is two hours in duration and
%   contains two signals (2-lead ECG), each sampled at 250 samples per
%   second with 12-bit resolution over a nominal 20 millivolt input range.
%   The sample values were rescaled after digitization with reference to
%   calibration signals in the original analog recordings, in order to
%   obtain a uniform scale of 200 ADC units per millivolt for all signals.
%   The database is available at:
%   
%   http://www.physionet.org/physiobank/database/edb/
%   
%   Patient e0105.dat was particalarly interesting as he has Inferior
%   myocardial infarction and our algorithm showed positive results for the
%   ECG.

ecg_file = fopen('e0105.dat','r');          %   PLEASE LOAD THE RELEVANT
ecg = fread(ecg_file, T*Fs, 'bit12', 12);   %   ECG FILE HERE.

[processed_ecg, det] = ecgPreprocessing(ecg, Fs);

Fs = Fs/4;
[P, Q, R, S, T] = ecgAnalysis( processed_ecg, Fs, det);

miDetection( processed_ecg, S, T);

fclose(ecg_file);