function [masterPath,dataPath] = jse_project_setup()
% JSE_PROJECT_SETUP is template setup file for project MATLAB based code
% folder. If the project is performed in various environments, you can
% proceed with setting by executing this code. If .gitignore exist, we
% don't add ignored path.
%
%   Contents of the setup code. 
%    - You can add elements to create a custom project setup.
%   ------------------------  Mandatory Section   ------------------------
%   1. Code path check
%   2. Check pathdef.m permission
%   3. Remove old project path
%   4. Add and save new project path
%   ------------------------    Custom Section    ------------------------
%   5. Setting masterPath & dataPath 
%   6. Check required software path 
%   7. +++
%   ----------------------------------------------------------------------
%
%   # This code referenced VBA_setup.m from VBA-toolbox.
%     (https://mbb-team.github.io/VBA-toolbox)
%   
%   $ Dec 14 2021, Jinseok Eo , urjinseok@gmail.com

%%  1. Code path check
%   ----------------------------------------------------------------------
mfilePath   = fileparts(mfilename('fullpath'));
[~,pn]      = fileparts(mfilePath);
currentPath = pwd;

if  ~(strcmpi(mfilePath,pwd))
    cd(mfilePath);
end

%%  2. Check pathdef.m permission
%   ----------------------------------------------------------------------
err = savepath;

if err
    % warn user the new path wont be saved:
    warning(['savepath() failed. ' ...
        'Installation will continue but your changes will not be saved.']);
end

%%  3. Remove old project path 
%   ----------------------------------------------------------------------
%   Check Operation system
isWin   = (~isempty(contains(computer, 'PCWIN')) || ...
                                      strcmp(computer, 'i686-pc-mingw32'));
isOSX   = (~isempty(contains(computer, 'MAC'))   || ... 
                             ~isempty(contains(computer, 'apple-darwin')));
isLinux = (strcmp(computer,'GLNX86') || strcmp(computer,'GLNXA64') ||...
                                ~isempty(contains(computer, 'linux-gnu')));

if isOSX || isLinux
    p = strsplit(path,':');
elseif isWin
    p = strsplit(path,';');
end

r = regexp(p, ['^.*' pn '.*$'],'match');
r = r(~cell2mat(cellfun(@isempty,r,'UniformOutput',false)));

if  ~(isempty(r))
    for iP = 1:numel(r)
        rmpath(char(r{iP}))
    end
    try
        savepath
    catch

    end
end
%%  4.Add and save new project path
%   ----------------------------------------------------------------------
p        = strsplit(genpath(pwd),':');
ref_path = ['refs' filesep 'heads'];
r        = regexp(p,['^.*' pn filesep '.git' filesep ...
                                           '(?!' ref_path ').*$'],'match');
p = p(cell2mat(cellfun(@isempty,r,'UniformOutput',false)));

for iP = 1:numel(p)
    addpath(char(p{iP}))
end

%   Remove .gitignore
gitig    = [pwd filesep '.gitignore'];
if  exist(gitig,'file')
    fid   = fopen(gitig);
    tline = fgetl(fid);
    warning off
    while ischar(tline)
        try
            rmpath(tline);
        catch
        end
        tline = fgetl(fid);
    end
    warning on 
end

try
    savepath
catch

end

%%  5. Setting masterPath and dataPath
%   ----------------------------------------------------------------------


%%  6. Check required softwarepath
%   ----------------------------------------------------------------------
%   SPM
try
    p = fileparts(which('spm'));
    fprintf('Required software : SPM is installed in %s\n',p);
catch
    fprintf('Please add SPM in your MATLAB path\n');
end

%   mnet
try
    p = fileparts(which('mnet'));
    fprintf('Required software : mnet is installed in %s\n',p);
catch
    fprintf('Please add mnet in your MATLAB path\n');
end

%%  Return to folder
%   ----------------------------------------------------------------------
cd(currentPath);
