function jse_project_setup()
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
%   5. Load environment file and set to GLOBAL (Project specification need)
%   ------------------------    Custom Section    ------------------------
%   A. Check additional toolbox path
%   ----------------------------------------------------------------------
%_________________________________________________________________________
%   $ Dec 14 2021, Jinseok Eo , urjinseok@gmail.com
%   $ OCT  8 2023, Add environment setting and modify addpath, Jinseok Eo

%   ======================================================================
%                             Mandatory Section
%   ======================================================================
%   1. Code path check
%   ======================================================================
    mfilePath   = fileparts(mfilename('fullpath'));
    [~,pn]      = fileparts(mfilePath);
    currentPath = pwd;

if  ~(strcmpi(mfilePath,pwd))
    cd(mfilePath);
end

%   2. Check pathdef.m permission
%   ======================================================================
    err = savepath;
if  err
    warning(['savepath() failed. '         ...
             'Installation will continue ' ...
             'but your changes will not be saved.']);
end

%   3. Add project path
%   ======================================================================
    isWin   = (~isempty(contains(computer, 'PCWIN')) ||...
                          strcmp(computer, 'i686-pc-mingw32'));
    isOSX   = (~isempty(contains(computer, 'MAC'))   ||... 
               ~isempty(contains(computer, 'apple-darwin')));
    isLinux = (~isempty(contains(computer, 'linux-gnu')) ||...
               strcmp(computer,'GLNX86')                 ||...
               strcmp(computer,'GLNXA64'));
    
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
       savepath
    end

%   4. Add and save new project path
%   ======================================================================
    p        = strsplit(genpath(pwd),':');
    ref_path = ['refs' filesep 'heads'];
    r        = regexp(p,['^.*' pn filesep '.git' filesep ...
                         '(?!' ref_path ').*$'],'match');
    p = p(cell2mat(cellfun(@isempty,r,'UniformOutput',false)));
    
    for iP = 1:numel(p)
        if ~(ismember(p{iP},strsplit(path,pathsep)))
            addpath(char(p{iP}))
        end
    end

%   Remove .gitignore
%   ----------------------------------------------------------------------
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

    savepath

%   5. Load environment file and set to GLOBAL (Project Specification)
%   ======================================================================
%   Modify by Project
    global MyProject_Env
    projectEnv    = 'MyProject.env';
    MyProject_Env = loadenv(projectEnv);

%   ======================================================================
%                               Custom Section   
%   ======================================================================
%   A. Check additional toolbox path
%   ======================================================================


%__________________________________________________________________________
%   Get Back
    cd(currentPath);
