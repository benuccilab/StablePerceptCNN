
imageInputSize = [size(xTrain,1),size(xTrain,2),1];
numFilters     = 16;
filterSize     = 3;
numClasses     = 10; % cifar10

layers = [
    imageInputLayer(imageInputSize,'Normalization','none','Name','images')
    
    convolution2dLayer(filterSize,numFilters,'Padding',1,'Name','conv1')
    batchNormalizationLayer('Name','batchNorm1');
    reluLayer('Name','relu1')
    
    maxPooling2dLayer(2,'Stride',2,'Name','maxPool1')
    
    convolution2dLayer(filterSize,numFilters*2,'Padding',1,'Name','conv2')
    batchNormalizationLayer('Name','batchNorm2')
    reluLayer('Name','relu2')
    
    maxPooling2dLayer(2,'Stride',2,'Name','maxPool2')
    
    convolution2dLayer(filterSize,numFilters*4,'Padding',1,'Name','conv3')
    batchNormalizationLayer('Name','batchNorm3')
    reluLayer('Name','relu3')
    
    fullyConnectedLayer(numClasses,'Name','fc')
    softmaxLayer('Name','softmax')
    classificationLayer('Name','clsfy')];

% 15×1 Layer array with layers:
% 
% 1   'images'       Image Input             42×42×1 images
% 2   'conv1'        Convolution             16 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
% 3   'batchNorm1'   Batch Normalization     Batch normalization
% 4   'relu1'        ReLU                    ReLU
% 5   'maxPool1'     Max Pooling             2×2 max pooling with stride [2  2] and padding [0  0  0  0]
% 6   'conv2'        Convolution             32 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
% 7   'batchNorm2'   Batch Normalization     Batch normalization
% 8   'relu2'        ReLU                    ReLU
% 9   'maxPool2'     Max Pooling             2×2 max pooling with stride [2  2] and padding [0  0  0  0]
% 10   'conv3'        Convolution             64 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
% 11   'batchNorm3'   Batch Normalization     Batch normalization
% 12   'relu3'        ReLU                    ReLU
% 13   'fc'           Fully Connected         10 fully connected layer
% 14   'softmax'      Softmax                 softmax
% 15   'clsfy'        Classification Output   crossentropyex