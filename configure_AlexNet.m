% ORIGINAL ALEXNET
%
% 25×1 Layer array with layers:
% 
% 1   'data'     Image Input                   227×227×3 images with 'zerocenter' normalization
% 2   'conv1'    Convolution                   96 11×11 convolutions with stride [4  4] and padding [0  0  0  0]
% 3   'relu1'    ReLU                          ReLU
% 4   'norm1'    Cross Channel Normalization   cross channel normalization with 5 channels per element
% 5   'pool1'    Max Pooling                   3×3 max pooling with stride [2  2] and padding [0  0  0  0]
% 6   'conv2'    Grouped Convolution           2 groups of 128 5×5 convolutions with stride [1  1] and padding [2  2  2  2]
% 7   'relu2'    ReLU                          ReLU
% 8   'norm2'    Cross Channel Normalization   cross channel normalization with 5 channels per element
% 9   'pool2'    Max Pooling                   3×3 max pooling with stride [2  2] and padding [0  0  0  0]
% 10   'conv3'    Convolution                   384 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
% 11   'relu3'    ReLU                          ReLU
% 12   'conv4'    Grouped Convolution           2 groups of 192 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
% 13   'relu4'    ReLU                          ReLU
% 14   'conv5'    Grouped Convolution           2 groups of 128 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
% 15   'relu5'    ReLU                          ReLU
% 16   'pool5'    Max Pooling                   3×3 max pooling with stride [2  2] and padding [0  0  0  0]
% 17   'fc6'      Fully Connected               4096 fully connected layer
% 18   'relu6'    ReLU                          ReLU
% 19   'drop6'    Dropout                       50% dropout
% 20   'fc7'      Fully Connected               4096 fully connected layer
% 21   'relu7'    ReLU                          ReLU
% 22   'drop7'    Dropout                       50% dropout
% 23   'fc8'      Fully Connected               1000 fully connected layer
% 24   'prob'     Softmax                       softmax
% 25   'output'   Classification Output         crossentropyex

imageInputSize = [size(xTrain,1),size(xTrain,2),1];
numFilters     = 96;
filterSize1    = 5;
filterSize2    = 3;
numClasses     = 10; % cifar10

clear newlgraph
% replaces the layer layerName in the layer graph lgraph with the layers in larray
dumLayer  = imageInputLayer(imageInputSize,'Normalization','none','Name','images');
newlgraph = replaceLayer(lgraph,'data',dumLayer); 

dumLayer  = convolution2dLayer(filterSize1,numFilters,'Stride',4,'DilationFactor',1,'Name','conv1');
newlgraph = replaceLayer(newlgraph,'conv1',dumLayer); 

dumLayer  = convolution2dLayer(filterSize2,numFilters,'Stride',1,...
    'DilationFactor',1,'Name','conv2');
dumLayer.PaddingSize = 2;
newlgraph = replaceLayer(newlgraph,'conv2',dumLayer); 

dumLayer = fullyConnectedLayer(numClasses,'Name','fc8');
newlgraph = replaceLayer(newlgraph,'fc8',dumLayer); 

dumLayer  = maxPooling2dLayer(2,'Stride',2,'Name','pool5');
newlgraph = replaceLayer(newlgraph,'pool5',dumLayer); 

clear lgraph layers
lgraph = newlgraph;
layers = lgraph.Layers;













