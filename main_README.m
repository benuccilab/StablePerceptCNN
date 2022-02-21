
% Main script to reproduce results presented in "Motor-related signals
% support localization invariance for stable visual perception", PLOS Comp.
% Biol. 2022

% MATLAB Version: 9.10.0.1649659 (R2021a) Update 1

%% Bunch of pars and settings
% Set stimuli for training or testing various nets

rng('shuffle');

% SET SIM PARS -------------
doSacc     = 1; % [1,0] saccade shifts
validMov   = -1; % [1,0,-1,-2] for generateMov.m (movs match saccades, all zeros, random Sacc, rand +-s zero mean)
movInLayer = 2; % [2,6,10,0] layer for movement input (conv)-> modifyArchitecture; 0 = do not add->linear architecture 
befConv    = 1; % [1,0] add saccade input before (1) or after (0) the chosen conv layer
addGrtngs  = 0; % add gratings to the dataset - must change the output layer
if addGrtngs, doSacc=0; validMov=0; movInLayer=0; end

s_size  = 8;  % def=8; (x,y) translations in pxls
sclS    = 25; % (def=25) percent of max layer activation for sacc ampl. (in generateMov.m)
pctI    = 80; % def=80; percent of non-zero feature movement inputs
maxEp   = 15; % def=15, max 55, no. of epochs for the optimization
nangs   = 6; % def=6; no. of angles for gratings in [0, pi]
frmSize = ((s_size/2)+1); % for noise vignetting; -((-s_size/2)+1) to zero the vignetting noise in control
useAlex = 0; % control with alexnet (only with movInLayer = 2 and befConv = 1)
useL2   = 0; % control with 2conv layers
% --------------------------

% default "fraction" of gratings is zero
grtFrc = 0.00; if addGrtngs, grtFrc = 0.9; end % train with 0.00035; test with 0.9
gfs = sprintf('%0.3f',(grtFrc*100)); gfs = replace(gfs,'.','_'); % in "%"

zeroF = ''; if frmSize<0, zeroF = '_ZF'; end % control when noisy frame set to zero amplitude
AN = ''; if useAlex, AN = '_AN'; end %  control with alexnet
L2 = ''; if useL2, L2 = '_L2'; end %  control with 2conv layers

% file name for saving
fnameNetSave = sprintf('trainedNet_DS%d_SS%d_VM%d_ML%d_BC%d_AG%s_SC%d_PC%d_ME%d%s%s%s',...
    doSacc,s_size,validMov,movInLayer,befConv,gfs,sclS,pctI,maxEp,zeroF,AN,L2);

% keep for analysis
doSaccTst = doSacc; validMovTst = validMov; gfsTst = gfs;

%% Prepare images and movement inputs 

% load images and split train/validate
% loadCIFARData is a Matlab function
[xTrain,YTrain,xValidation,YValidation] = loadCIFARData(dataDir);
xTrain = xTrain(:,:,:,1:50000); % Reduce the training set if needed
YTrain = YTrain(1:50000,1);

cifar2gray; % convert to grayscale

% makeGratings - generated even if not added, e.g., just for testing later
if addGrtngs
    [xTrain_g,YTrain_g,xValidation_g,YValidation_g] = makeGratings(xTrain,xValidation,nangs,grtFrc);
end

% Vignette stimuli 
[xTrain, xValidation] = frameDataset(xTrain,xValidation,frmSize);
if addGrtngs
    [xTrain_g, xValidation_g] = frameDataset(xTrain_g,xValidation_g,frmSize);
end

if addGrtngs
  % datastore for unshifted original images
    YTrain_oim = YTrain;
    YValidation_oim = YValidation;
    dsImgs_oim   = arrayDatastore(xTrain,'IterationDimension',4);
    dsLabls_oim  = arrayDatastore(YTrain_oim);
    dsImgsV_oim  = arrayDatastore(xValidation,'IterationDimension',4);
    dsLablsV_oim = arrayDatastore(YValidation_oim);
    
    % datastore for gratings only
    dsImgs_g   = arrayDatastore(xTrain_g,'IterationDimension',4);
    dsLabls_g  = arrayDatastore(YTrain_g);
    dsImgsV_g  = arrayDatastore(xValidation_g,'IterationDimension',4);
    dsLablsV_g = arrayDatastore(YValidation_g);
end

% Optional, add gratings randomly to xTrain and xValidation (if no input movements & linear architecture)
% changes Ytrain and Yvalidation
if addGrtngs, addGratings; end 

% Default, no saccades or below
nimgT = size(xTrain,4); nimgV = size(xValidation,4);
sTrain = zeros(2,nimgT); sValid = zeros(2,nimgV);

% Add random saccades
if doSacc
    [xTrain, xValidation, sTrain, sValid] = shiftImgs(xTrain, xValidation, s_size);
end

% create datastores for training & validation
% combined gratings and images
dsImgs   = arrayDatastore(xTrain,'IterationDimension',4);
dsLabls  = arrayDatastore(YTrain);
dsImgsV  = arrayDatastore(xValidation,'IterationDimension',4);
dsLablsV = arrayDatastore(YValidation);

% Load my net
clear layers lgraph DSTrain DSValid
if useL2
    my2Lnet;
else
    my3Lnet;
end
lgraph = layerGraph(layers);

% Modify architecture 
modifyArchitecture;
% analyzeNetwork(lgraph);

% CONTROL: Load Alexnet OR my net
if useAlex
    clear layers lgraph DSTrain DSValid
    layers = alexnet('Weights','none');
    lgraph = layerGraph(layers);
    configure_AlexNet;
    modifyAlexArchitecture;
end

if movInLayer ~= 0 % prepare movement inputs to add at specific layers
    % movement inputs (features) to fit the selected conv layer
    % doSacc fix if commensurate with saccades, zero, random
    generateMov; % movTrain and movVal    
    dsMov   = arrayDatastore(movTrain,'IterationDimension',4);
    dsMovV  = arrayDatastore(movVal,'IterationDimension',4);
    DSTrain = combine(dsImgs,dsMov,dsLabls);
    DSValid = combine(dsImgsV,dsMovV,dsLablsV);
else % no added mov inputs, keep linear architecture from modifyArchitecture
    DSTrain = combine(dsImgs,dsLabls);
    DSValid = combine(dsImgsV,dsLablsV);
    % for gratings only
    DSTrain_g = combine(dsImgs_g,dsLabls_g);
    DSValid_g = combine(dsImgsV_g,dsLablsV_g);
    % for original imgs only
    DSTrain_oim = combine(dsImgs_oim,dsLabls_oim);
    DSValid_oim = combine(dsImgsV_oim,dsLablsV_oim);
end


%% Train the network

% optimization options
miniBatchSize = 128/2;
learnRate = 0.1*miniBatchSize/128;
valFrequency = floor(size(xTrain,4)/miniBatchSize);
options = trainingOptions('sgdm', ...
    'InitialLearnRate',learnRate, ...
    'MaxEpochs',maxEp, ... % play with this to early stop
    'MiniBatchSize',miniBatchSize, ...
    'VerboseFrequency',valFrequency, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress', ...
    'Verbose',false, ...
    'ValidationData',DSValid, ... 
    'ValidationFrequency',valFrequency, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.1, ...
    'LearnRateDropPeriod',60);

% training  
for iver = 1:10 % usually 10 or 50
    clear trainedNet
    trainedNet = trainNetwork(DSTrain,lgraph,options);
    [YValPred, probs] = classify(trainedNet,DSValid);
    validAccu = 1- mean(YValPred ~= YValidation);
end

%%
