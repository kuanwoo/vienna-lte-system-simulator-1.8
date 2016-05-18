clear all; close all; clc;

udtm_folder   = './non_public_data/LTE_trial/traffic_maps';
data_file     = 'trial_PS_2010_DI_focus.bil';
hdr_file      = 'trial_PS_2010_DI_focus.HDR';
gen_file_name = 'trafficmap_generic.bil';
gen_hdr_name  = 'trafficmap_generic.HDR';
udtm_file_hdr = fopen(fullfile(udtm_folder, gen_hdr_name),  'r');
udtm_file     = fopen(fullfile(udtm_folder, gen_file_name), 'r');
% udtm_file_hdr = fopen(fullfile(udtm_folder, hdr_file),  'r');
% udtm_file     = fopen(fullfile(udtm_folder, data_file), 'r');
% gen_file      = fopen(fullfile(udtm_folder, gen_file_name), 'w');

%% Header file information
udtm_hdr = textscan(udtm_file_hdr, '%s %f');

udtm.description.NWxmap = udtm_hdr{2}(1);
udtm.description.NWymap = udtm_hdr{2}(2);
udtm.description.xdim   = udtm_hdr{2}(3);
udtm.description.ydim   = udtm_hdr{2}(4);
udtm.description.ncols  = udtm_hdr{2}(5);
udtm.description.nrows  = udtm_hdr{2}(6);
udtm.description.nbits  = udtm_hdr{2}(7);
udtm.description.nbands = udtm_hdr{2}(8);

udtm.description.SWxmap = udtm.description.NWxmap;                                                % Lower-leftmost corner (x) -> SW
udtm.description.SWymap = udtm.description.NWymap - udtm.description.ydim*(udtm.description.nrows-1/100); % Lower-leftmost corner (y) -> SW
   
udtm.description.NExmap = udtm.description.NWxmap + udtm.description.xdim*(udtm.description.ncols-1/100);
udtm.description.NEymap = udtm.description.NWymap;
    
udtm.description.SExmap = udtm.description.NExmap;
udtm.description.SEymap = udtm.description.SWymap;
    
udtm.description.roi_x = [udtm.description.SWxmap udtm.description.SExmap];
udtm.description.roi_y = [udtm.description.SWymap udtm.description.NWymap];

%%

udtm_map_t = fread(udtm_file, [udtm.description.ncols, udtm.description.nrows], 'single', 'l');
udtm_map_t(udtm_map_t==-realmax('single')) = 0; % In order to fill the 'holes' in the traffic map

%% Generate generic traffic map

% mean_users_per_sqkm = 0.5;
% A = repmat(mean_users_per_sqkm, 480, 400);
% fwrite(gen_file, A, 'single','l');