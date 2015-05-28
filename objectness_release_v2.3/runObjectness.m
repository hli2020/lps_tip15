
function boxes = runObjectness(img,numberSamples,params)
%This function computes the objectness measure and samples boxes from it.

%INPUT
%img - input image
%numberSamples - number of windows sampled from the objectness measure
%params - struct containing parameters of the function (loaded in startup.m)

%OUTPUT
%boxes - samples windows from the objectness measure
%      - each row contains a window using the format [xmin ymin xmax ymax score]

dir_root = pwd;
img = gray2rgb(img);

if nargin < 3
    try
        struct = load([dir_root '\objectness-release-v2.2_Francis\Data\params_ED.mat']);
        params = struct.params;
        clear struct;
    catch
        params = defaultParams(dir_root);
        save([dir_root '\objectness-release-v2.2_Francis\Data\params.mat'],'params');
    end
end
%params = updatePath(dir_root,params);

if not(ismember('MS',params.cues))
    display('ERROR: combinations have to include MS');
    boxes = [];
    return
end

if length(unique(params.cues)) ~= length(params.cues)
    display('ERROR: repetead cues in the combination');
    boxes = [];
    return
end

distributionBoxes = computeScores(img,'MS',params);
%rearrange the cues such that 'MS' is the first cue
if ~strcmp(params.cues{1},'MS')
    params.cues{strcmp(params.cues,'MS')} = params.cues{1};
    params.cues{1} ='MS';
end

score = zeros(size(distributionBoxes,1),length(params.cues));
score(:,1) = distributionBoxes(:,end);
windows = distributionBoxes(:,1:4);
for idx = 2:length(params.cues)
    temp = computeScores(img,params.cues{idx},params,windows);
    score(:,idx) = temp(:,end);
end
scoreBayes = integrateBayes(params.cues,score,params);

switch lower(params.sampling)
    case 'nms'
        %nms sampling
        
        distributionBoxes(:,5) = scoreBayes;
        boxes = nms_pascal(distributionBoxes, 0.5, numberSamples);
        
    case 'multinomial'
        %multinomial sampling
        
        %sample from the distribution of the scores
        indexSamples = scoreSampling(scoreBayes,numberSamples,1);
        boxes = [windows(indexSamples,:) scoreBayes(indexSamples,:)];
        
    otherwise
        display('sampling procedure unknown')
end

end


