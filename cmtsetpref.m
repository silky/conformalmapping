function cmtsetpref(group,varargin)

if nargin < 2
    allgroups = fieldnames(factoryDefaults);
    if nargin==0
        group = allgroups;
    else
        validatestring(group,allgroups)
        group = {group};
    end
    showHelp(group)
    
elseif strcmp(group,'factory')
    setFactoryDefaults;
else
    cmtgroup = ['CMT',group];
    if ~isappdata(0,cmtgroup)    % first call
        setFactoryDefaults;
    end
    
    data = getappdata(0,cmtgroup);
    if ~isstruct(varargin{1})
        params = varargin(1:2:end);
        values = varargin(2:2:end);
    else
        s = varargin{1};
        params = fieldnames(s);
        values = cellfun( @(x) s.(x), params, 'uniform',false );
    end
    
    for i = 1:length(params)
        data.(lower(params{i})) = values{i};
    end
    
    setappdata(0,cmtgroup,data);
    
end

end


function setFactoryDefaults

prefs = factoryDefaults;
group = fieldnames(prefs);
for i = 1:length(group)
    p = prefs.(group{i});
    p(3:3:end) = [];   % delete the help tips
    s = struct(p{:});
    setappdata( 0, ['CMT',group{i}], s );
end

end


function showHelp(group)

% Show help on values
prefs = factoryDefaults;
fprintf('\n')
for i = 1:length(group)
    fprintf('%s group\n',group{i});
    p = prefs.(group{i});
    params = p(1:4:end);
    %values = p(2:4:end);
    valid = p(3:4:end);
    help = p(4:4:end);
    for j = 1:length(params)
        fprintf('  %16s : ',params{j})
        fprintf(' %s',help{j})
        fprintf('   %s\n',valid{j})
    end
    fprintf('\n')
end

%     fprintf('\n')
%     params = fieldnames(data);
%     for j = 1:length(params)
%         fprintf('  %15s : ',params{j})
%         
%         value = data.(params{j});
%         if ischar(value)
%             str = value;
%         elseif isnumeric(value) && numel(values{j})==1
%             str = num2str(value},'%.2g');
%         elseif islogical(value)
%             if values{j}
%                 str = 'true';
%             else
%                 str = 'false';
%             end
%         else
%             str = ['( ',class(values{j}),' value )'];
%         end
%         
%         fprintf(' %-s\n',str)
%     end
 
end

function prefs = factoryDefaults

colr = get(0,'defaultaxescolororder');
prefs.graphics = {
    'linewidth',1.5,'[ real ]','Width of all boundary curves.',...
    'linecolor',colr(1,:),'[ valid colorspec ]','Color of all boundary curves.',...
    'gridcolor',colr(2,:),'[ valid colorspec ]','Color of grid curves'
    };

prefs.szego = {
    'confcenter',0,'[ complex ]','Conformal center (image of zero).',...
    'numcollpts',512,'[ integer ]','Number of collcation points.',...
    'kernsolmethod','auto','[ ''backslash'' | ''orth_resid'' | ''auto'' ]','Solver method.',...
    'newtontol',10*eps(2*pi),'[ positive ]','Tolerance for Newton iteration',...
    'trace',false,'[ logical ]','Display information during the solving process',...
    'numfourierpts',256,'[ integer ]','Number of Fourier points on the circle.'
    };

end





