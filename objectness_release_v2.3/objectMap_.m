function [ objMap, boxes ] = objectMap_( img, numberSamples, cue_num)

addpath('./objectness_release_v2.3/MEX/');
addpath('./objectness_release_v2.3/pff_segment/');
addpath('./objectness_release_v2.3/Data/');

map = zeros(size(img,1),size(img,2));
img = gray2rgb(img);
dir_root = pwd;
params = defaultParams_new(dir_root, cue_num);   % Parameters alternation is here.

% single cues
if length(params.cues)==1
    distributionBoxes = computeScores_new(img,params.cues{1},params);
    switch lower(params.sampling)
        case 'nms'
            % nms sampling
            % consider only params.distribution_windows (= 100k windows)
            if size(distributionBoxes,1) > params.distribution_windows
                indexSamples = scoreSampling(distributionBoxes(:,5),params.distribution_windows,1);
                distributionBoxes = distributionBoxes(indexSamples,:);
            end
            % sampling
            boxes = nms_pascal(distributionBoxes, 0.5,numberSamples);
            
        case 'multinomial'
            % multinomial sampling
            % sample from the distribution of the scores
            indexSamples = scoreSampling(distributionBoxes(:,end),numberSamples,1);
            boxes = distributionBoxes(indexSamples,:);
            
        otherwise
            display('sampling procedure unknown')
    end
else
    % combination of cues
    distributionBoxes = computeScores_new(img,'MS',params);     % default:100000*5
    % Rearrange the cues such that 'MS' is the first cue
    if ~strcmp(params.cues{1},'MS')
        params.cues{strcmp(params.cues,'MS')} = params.cues{1};
        params.cues{1} ='MS';
    end
    
    score = zeros(size(distributionBoxes,1),length(params.cues));
    score(:,1) = distributionBoxes(:,end);
    windows = distributionBoxes(:,1:4);
    
    % The following is time-consuming.
    for idx = 2:length(params.cues)
        temp = computeScores_new(img,params.cues{idx},params,windows);
        score(:,idx) = temp(:,end);
    end
    
    scoreBayes = integrateBayes_new(params.cues,score,params);
    switch lower(params.sampling)
        case 'nms'
            % nms sampling
            % ���ַ���scoreֵ�Ӵ�С������ˣ��޸�distribution����10�򣩾ͻ����
            distributionBoxes(:,5) = scoreBayes;
            boxes = nms_pascal(distributionBoxes, 0.5, numberSamples);
            
        case 'multinomial'
            % multinomial sampling
            % ����scoreֵû��������Ҫwindows����
            % sample from the distribution of the scores
            indexSamples = scoreSampling(scoreBayes,numberSamples,1);
            boxes = [windows(indexSamples,:) scoreBayes(indexSamples,:)];
            
        otherwise
            display('sampling procedure unknown')
    end
end

boxes = sortrows(boxes,5);      % ���յ�5�У�score����ֵ�����򣨴�С��������
for idx = 1:size(boxes,1)
    maskBox = zeros(size(img,1), size(img,2));
    xmin = round(boxes(idx,1));
    ymin = round(boxes(idx,2));
    xmax = round(boxes(idx,3));
    ymax = round(boxes(idx,4));
    score = boxes(idx,5);
    % score with exponent
    score_weight = objWeight_(xmin, ymin, xmax, ymax, score);
    maskBox(ymin:ymax,xmin:xmax) = score_weight;
    
    %maskBox(ymin:ymax,xmin:xmax) = score;
    map = map + maskBox;
end
objMap = mat2gray(map);
end
