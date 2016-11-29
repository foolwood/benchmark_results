
% This script downloads and extracts all videos to the path specified
% below.
%
% Joao F. Henriques, 2014
% http://www.isr.uc.pt/~henriques/


%local path where the videos will be located.
%note that if you change it here, you must also change it in RUN_TRACKER.
base_path = './data/Benchmark/';


%list of videos to download
videos = {'basketball', 'bolt', 'boy', 'car4', 'carDark', 'carScale', ...
	'coke', 'couple', 'crossing', 'david2', 'david3', 'david', 'deer', ...
	'dog1', 'doll', 'dudek', 'faceocc1', 'faceocc2', 'fish', ...
    'fleetface', 'football', 'football1', 'freeman1', 'freeman3', ...
    'freeman4', 'girl', 'ironman', 'jogging', 'jumping', 'lemming', ...
    'liquor', 'matrix', 'mhyang', 'motorRolling', 'mountainBike', ...
    'shaking', 'singer1', 'singer2', 'skating1', 'skiing', 'soccer', ...
    'subway', 'suv', 'sylvester', 'tiger1', 'tiger2', 'trellis', ...
    'walking', 'walking2', 'woman'};


if ~exist(base_path, 'dir'),  %create if it doesn't exist already
	mkdir(base_path);
end

if ~exist('matlabpool', 'file'),
	%no parallel toolbox, use a simple 'for' to iterate
	disp('Downloading videos one by one, this may take a while.')
	disp(' ')
	
	for k = 1:numel(videos),
		disp(['Downloading and extracting ' videos{k} '...']);
		unzip(['http://cvlab.hanyang.ac.kr/tracker_benchmark/seq/' ...
            videos{k} '.zip'], base_path);
	end
	
else
	%download all videos in parallel
	disp('Downloading videos in parallel, this may take a while.')
	disp(' ')
	
	if matlabpool('size') == 0,
		matlabpool open;
	end
	parfor k = 1:numel(videos),
		disp(['Downloading and extracting ' videos{k} '...']);
		unzip(['http://cvlab.hanyang.ac.kr/tracker_benchmark/seq/' ...
            videos{k} '.zip'], base_path);
	end
end

