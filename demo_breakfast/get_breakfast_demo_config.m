function [config] = get_breakfast_demo_config(path_root, path_input, path_gen, path_out)
%GET_BREAKFAST_DEMO_CONFIG loads frame representations and related segmentations and returns then in unit form  
% Input:
% path_root - path to the root folder
% path_input - path to the input feature
% path_gen - path for generated temp files
% path_out - path for output result files
%
% Output:
% config - struct with configuration values
%

% Copyright (C) 2014 H. Kuehne
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.


% for the first split (in folder ... /s1)
use_split = 1;

% if you want to run overall splits please don't forget to adapt the
% train/test pattern
% regular expression for test data (first split)
config.pattern_test = '(P03_|P04_|P05_|P06_|P07_|P08_|P09_|P10_|P11_|P12_|P13_|P14_|P15_)';
% regular expression for training data (second split)
config.pattern_train = '(P16_|P17_|P18_|P19_|P20_|P21_|P22_|P23_|P24_|P25_|P26_|P27_|P28_|P29_|P30_|P31_|P32_|P33_|P34_|P35_|P36_|P37_|P38_|P39_|P40_|P41_|P42_|P43_|P44_|P45_|P46_|P47_|P48_|P49_|P50_|P51_|P52_|P53_|P54_)'

% feature file ending 
config.file_ending = '.txt'

% folder with segmentation files (xml-style)
config.features_dir = [path_input, '/s1'];

% folder with segmentation files (xml-style)
config.features_segmentation = [path_root, '/segmentation'];

% temporary directory
config.tmp_dir = [path_gen, '/tmp/'];
if isempty(dir(config.tmp_dir))
    mkdir(config.tmp_dir);
end
% temporary label directory...
config.label_dir = [path_gen, '/label/'];
if isempty(dir(config.label_dir))
    mkdir(config.label_dir);
end


%% Files provided by user
% dictionary file
config.dict_file = ['', path_root, '/breakfast.dict'];

% grammar file
config.grammar_file = ['', path_root, '/breakfast.grammar'];

%% Files generated by htk ... you don't need to care about that
% latice file
config.latice_file=['', config.grammar_file, '.net.slf'];

% config.hmm_file
config.hmm_file = ['', path_out, '/breakfast.hmms'];

% hmm list file
config.hmm_list_file = ['', path_out, '/breakfastlist.txt'];

% test list file
config.test_list_file = ['', path_out, '/breakfasttest.list'];

% reference master label file
config.ref_file = ['', path_out, '/breakfast.ref.mlf'];

% recogmition_file
config.recog_file = ['', path_out, '/breakfast.reco.mlf'];

% first use winner takes all ...
config.unique_action_labels = {...
'pour_cereals', ... % $CEREALS |
'pour_coffee', ...  % $COFFEE |
'fry_egg', ...  % $FRIEDEGG |
'squeeze_orange', ...  % $JUICE |
'spoon_powder', ...  % $MILK |
'stir_dough', ...  % $PANCAKE |
'cut_fruit', ...  % $SALAT |
'put_toppingOnTop', ...  % $SANDWICH |
'stirfry_egg', ... % $SCRAMBLEDEGG |
'add_teabag', ... % $TEA ;
};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parameteres
%feature normalization
config.normalization = 'std';
config.noSIL = '';

% output file names:
output_preface = 'demo_breakfast_output';
ref_preface = 'demo_breakfast_ref';
filesave_preface = 'results_breakfast_';

% set output file names
config.output_file = [ path_out, '/', output_preface, '_s', num2str(use_split),'.txt'];
% reference master label file
config.ref_file = ['', path_out, '/', ref_preface, '_s', num2str(use_split),'.ref.mlf'];
% recogmition_file
config.recog_file = ['', path_out, '/', output_preface, '_s', num2str(use_split),'.reco.mlf'];

config.defnumstates = -2; % -1 = five prototypes, -2 = linear divided by 7, > 0 fix number of states 
config.numberOfMixtures = 1;

%set min / max number of samples to use for training
config.min_number_samples = 50;
config.max_number_samples = 80;

% ID for temporary files
config.ind_nr = 1;
config.defhmm.ind_nr = 1000*config.ind_nr + 100*abs(config.defnumstates) + 10*config.numberOfMixtures + use_split;

% hmm file name and definition
config.hmm_file_name = [config.hmm_file(1:end-5), '_', num2str(config.defnumstates),'sts_', num2str(config.numberOfMixtures),'mix_s', num2str(use_split), config.hmm_file(end-4:end)];
config.dir_hmm_def = [config.tmp_dir,  num2str(config.defhmm.ind_nr), '/'];
if isempty(dir(config.dir_hmm_def))
    mkdir(config.dir_hmm_def);
end

end