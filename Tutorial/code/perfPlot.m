clear
close all;
clc

addpath('./util');

attPath = './anno/att/'; % The folder that contains the annotation files for sequence attributes

attName={'illumination variation'	'out-of-plane rotation'	'scale variation'	'occlusion'	'deformation'	'motion blur'	'fast motion'	'in-plane rotation'	'out of view'	'background clutter' 'low resolution'};

attFigName={'illumination_variations'	'out-of-plane_rotation'	'scale_variations'	'occlusions'	'deformation'	'blur'	'abrupt_motion'	'in-plane_rotation'	'out-of-view'	'background_clutter' 'low_resolution'};


plotDrawStyleAll={   struct('color',[1,0,0],'lineStyle','-'),...
    struct('color',[0,1,0],'lineStyle','-'),...
    struct('color',[0,0,1],'lineStyle','-'),...
    struct('color',[0,0,0],'lineStyle','-'),...%    struct('color',[1,1,0],'lineStyle','-'),...%yellow
    struct('color',[1,0,1],'lineStyle','-'),...%pink
    struct('color',[0,1,1],'lineStyle','-'),...
    struct('color',[0.5,0.5,0.5],'lineStyle','-'),...%gray-25%
    struct('color',[136,0,21]/255,'lineStyle','-'),...%dark red
    struct('color',[255,127,39]/255,'lineStyle','-'),...%orange
    struct('color',[0,162,232]/255,'lineStyle','-'),...%Turquoise
    struct('color',[163,73,164]/255,'lineStyle','-'),...%purple    %%%%%%%%%%%%%%%%%%%%
    struct('color',[1,0,0],'lineStyle','--'),...
    struct('color',[0,1,0],'lineStyle','--'),...
    struct('color',[0,0,1],'lineStyle','--'),...
    struct('color',[0,0,0],'lineStyle','--'),...%    struct('color',[1,1,0],'lineStyle','--'),...%yellow
    struct('color',[1,0,1],'lineStyle','--'),...%pink
    struct('color',[0,1,1],'lineStyle','--'),...
    struct('color',[0.5,0.5,0.5],'lineStyle','--'),...%gray-25%
    struct('color',[136,0,21]/255,'lineStyle','--'),...%dark red
    struct('color',[255,127,39]/255,'lineStyle','--'),...%orange
    struct('color',[0,162,232]/255,'lineStyle','--'),...%Turquoise
    struct('color',[163,73,164]/255,'lineStyle','--'),...%purple    %%%%%%%%%%%%%%%%%%%
    struct('color',[1,0,0],'lineStyle','-.'),...
    struct('color',[0,1,0],'lineStyle','-.'),...
    struct('color',[0,0,1],'lineStyle','-.'),...
    struct('color',[0,0,0],'lineStyle','-.'),...%    struct('color',[1,1,0],'lineStyle',':'),...%yellow
    struct('color',[1,0,1],'lineStyle','-.'),...%pink
    struct('color',[0,1,1],'lineStyle','-.'),...
    struct('color',[0.5,0.5,0.5],'lineStyle','-.'),...%gray-25%
    struct('color',[136,0,21]/255,'lineStyle','-.'),...%dark red
    struct('color',[255,127,39]/255,'lineStyle','-.'),...%orange
    struct('color',[0,162,232]/255,'lineStyle','-.'),...%Turquoise
    struct('color',[163,73,164]/255,'lineStyle','-.'),...%purple
    };

plotDrawStyle10={   struct('color',[1,0,0],'lineStyle','-'),...
    struct('color',[0,1,0],'lineStyle','--'),...
    struct('color',[0,0,1],'lineStyle',':'),...
    struct('color',[0,0,0],'lineStyle','-'),...%    struct('color',[1,1,0],'lineStyle','-'),...%yellow
    struct('color',[1,0,1],'lineStyle','--'),...%pink
    struct('color',[0,1,1],'lineStyle',':'),...
    struct('color',[0.5,0.5,0.5],'lineStyle','-'),...%gray-25%
    struct('color',[136,0,21]/255,'lineStyle','--'),...%dark red
    struct('color',[255,127,39]/255,'lineStyle',':'),...%orange
    struct('color',[0,162,232]/255,'lineStyle','-'),...%Turquoise
    };

seqs=configSeqs;

trackers=configTrackers;

% seqs = seqs(1:10);
% trackers = trackers(1:10);

numSeq=length(seqs);
numTrk=length(trackers);

nameTrkAll=cell(numTrk,1);
for idxTrk=1:numTrk
    t = trackers{idxTrk};
    nameTrkAll{idxTrk}=t.namePaper;
end

nameSeqAll=cell(numSeq,1);
numAllSeq=zeros(numSeq,1);

att=[];
for idxSeq=1:numSeq
    s = seqs{idxSeq};
    nameSeqAll{idxSeq}=s.name;
    
    s.len = s.endFrame - s.startFrame + 1;
    
    numAllSeq(idxSeq) = s.len;
    
    att(idxSeq,:)=load([attPath s.name '.txt']);
end

attNum = size(att,2);

figPath = './figs/overall/';

perfMatPath = './perfMat/overall/';

if ~exist(figPath,'dir')
    mkdir(figPath);
end

metricTypeSet = {'error', 'overlap'};
evalTypeSet = {'SRE', 'TRE', 'OPE'};

% rankingType = 'AUC';%AUC, threshod
if strcmp(metricTypeSet,'overlap')
    rankingType = 'AUC';%AUC, threshod
else
    rankingType = 'threshold';%AUC, threshod
end
    

rankNum = 10;%number of plots to show

if rankNum == 10
    plotDrawStyle=plotDrawStyle10;
else
    plotDrawStyle=plotDrawStyleAll;
end

thresholdSetOverlap = 0:0.05:1;
thresholdSetError = 0:50;

for i=1:length(metricTypeSet)
    metricType = metricTypeSet{i};%error,overlap
    
    switch metricType
        case 'overlap'
            thresholdSet = thresholdSetOverlap;
            rankIdx = 11;
            xLabelName = 'Overlap threshold';
            yLabelName = 'Success rate';
        case 'error'
            thresholdSet = thresholdSetError;
            rankIdx = 21;
            xLabelName = 'Location error threshold';
            yLabelName = 'Precision';
    end  
        
    if strcmp(metricType,'error')&strcmp(rankingType,'AUC')
        continue;
    end
    
    tNum = length(thresholdSet);
    
    for j=1:length(evalTypeSet)
        
        evalType = evalTypeSet{j};%SRE, TRE, OPE
        
        plotType = [metricType '_' evalType];
        
        switch metricType
            case 'overlap'
                titleName = ['Success plots of ' evalType];
            case 'error'
                titleName = ['Precision plots of ' evalType];
        end

        dataName = [perfMatPath 'aveSuccessRatePlot_' num2str(numTrk) 'alg_'  plotType '.mat'];
        
        % If the performance Mat file, dataName, does not exist, it will call
        % genPerfMat to generate the file.
        if ~exist(dataName)
            genPerfMat(seqs, trackers, evalType, nameTrkAll, perfMatPath);
        end        
        
        load(dataName);
        numTrk = size(aveSuccessRatePlot,1);        
        
        if rankNum > numTrk | rankNum <0
            rankNum = numTrk;
        end
        
        figName= [figPath 'quality_plot_' plotType '_' rankingType];
        idxSeqSet = 1:length(seqs);
        
        % draw and save the overall performance plot
        plotDrawSave(numTrk,plotDrawStyle,aveSuccessRatePlot,idxSeqSet,rankNum,rankingType,rankIdx,nameTrkAll,thresholdSet,titleName, xLabelName,yLabelName,figName,metricType);
        
        % draw and save the performance plot for each attribute
        attTrld = 0;
        for attIdx=1:attNum
            
            idxSeqSet=find(att(:,attIdx)>attTrld);
            
            if length(idxSeqSet) < 2
                continue;
            end
            disp([attName{attIdx} ' ' num2str(length(idxSeqSet))])
            
            figName=[figPath attFigName{attIdx} '_'  plotType '_' rankingType];
            titleName = ['Plots of ' evalType ': ' attName{attIdx} ' (' num2str(length(idxSeqSet)) ')'];
            
            switch metricType
                case 'overlap'
                    titleName = ['Success plots of ' evalType ' - ' attName{attIdx} ' (' num2str(length(idxSeqSet)) ')'];
                case 'error'
                    titleName = ['Precision plots of ' evalType ' - ' attName{attIdx} ' (' num2str(length(idxSeqSet)) ')'];
            end
            
            plotDrawSave(numTrk,plotDrawStyle,aveSuccessRatePlot,idxSeqSet,rankNum,rankingType,rankIdx,nameTrkAll,thresholdSet,titleName, xLabelName,yLabelName,figName,metricType);
        end        
    end
end
