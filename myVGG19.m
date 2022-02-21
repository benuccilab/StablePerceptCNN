netWidth = 64;
numClasses = 4096; % in VGG19

layers = [
%      1   'input'     Image Input             224×224×3 images with 'zerocenter' normalization
imageInputLayer([224 224 3],'Name','input')

%      2   'conv1_1'   Convolution             64 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
convolution2dLayer(3,netWidth,'Padding',[1 1 1 1],'Stride',1,'Name','conv1_1')

%      3   'relu1_1'   ReLU                    ReLU
reluLayer('Name','relu1_1')

%      4   'conv1_2'   Convolution             64 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
convolution2dLayer(3,netWidth,'Padding',[1 1 1 1],'Stride',1,'Name','conv1_2')

%      5   'relu1_2'   ReLU                    ReLU
reluLayer('Name','relu1_2')

%      6   'pool1'     Max Pooling             2×2 max pooling with stride [2  2] and padding [0  0  0  0]
maxPooling2dLayer(2,'Stride',2,'Padding',[0 0 0 0],'Name','pool1')

%      7   'conv2_1'   Convolution             128 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
convolution2dLayer(3,netWidth*2,'Padding',[1 1 1 1],'Stride',1,'Name','conv2_1')

%      8   'relu2_1'   ReLU                    ReLU
reluLayer('Name','relu2_1')

%      9   'conv2_2'   Convolution             128 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
convolution2dLayer(3,netWidth*2,'Padding',[1 1 1 1],'Stride',1,'Name','conv2_2')

%     10   'relu2_2'   ReLU                    ReLU
reluLayer('Name','relu2_2')

%     11   'pool2'     Max Pooling             2×2 max pooling with stride [2  2] and padding [0  0  0  0]
maxPooling2dLayer(2,'Stride',2,'Padding',[0 0 0 0],'Name','pool2')

%     12   'conv3_1'   Convolution             256 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
convolution2dLayer(3,netWidth*4,'Padding',[1 1 1 1],'Stride',1,'Name','conv3_1')

%     13   'relu3_1'   ReLU                    ReLU
reluLayer('Name','relu3_1')

%     14   'conv3_2'   Convolution             256 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
convolution2dLayer(3,netWidth*4,'Padding',[1 1 1 1],'Stride',1,'Name','conv3_2')

%     15   'relu3_2'   ReLU                    ReLU
reluLayer('Name','relu3_2')

%     16   'conv3_3'   Convolution             256 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
convolution2dLayer(3,netWidth*4,'Padding',[1 1 1 1],'Stride',1,'Name','conv3_3')

%     17   'relu3_3'   ReLU                    ReLU
reluLayer('Name','relu3_3')

%     18   'conv3_4'   Convolution             256 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
convolution2dLayer(3,netWidth*4,'Padding',[1 1 1 1],'Stride',1,'Name','conv3_4')

%     19   'relu3_4'   ReLU                    ReLU
reluLayer('Name','relu3_4')

%     20   'pool3'     Max Pooling             2×2 max pooling with stride [2  2] and padding [0  0  0  0]
maxPooling2dLayer(2,'Stride',2,'Padding',[0 0 0 0],'Name','pool3')

%     21   'conv4_1'   Convolution             512 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
convolution2dLayer(3,netWidth*8,'Padding',[1 1 1 1],'Stride',1,'Name','conv4_1')

%     22   'relu4_1'   ReLU                    ReLU
reluLayer('Name','relu4_1')

%     23   'conv4_2'   Convolution             512 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
convolution2dLayer(3,netWidth*8,'Padding',[1 1 1 1],'Stride',1,'Name','conv4_2')

%     24   'relu4_2'   ReLU                    ReLU
reluLayer('Name','relu4_2')

%     25   'conv4_3'   Convolution             512 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
convolution2dLayer(3,netWidth*8,'Padding',[1 1 1 1],'Stride',1,'Name','conv4_3')

%     26   'relu4_3'   ReLU                    ReLU
reluLayer('Name','relu4_3')

%     27   'conv4_4'   Convolution             512 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
convolution2dLayer(3,netWidth*8,'Padding',[1 1 1 1],'Stride',1,'Name','conv4_4')

%     28   'relu4_4'   ReLU                    ReLU
reluLayer('Name','relu4_4')

%     29   'pool4'     Max Pooling             2×2 max pooling with stride [2  2] and padding [0  0  0  0]
maxPooling2dLayer(2,'Stride',2,'Padding',[0 0 0 0],'Name','pool4')

%     30   'conv5_1'   Convolution             512 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
convolution2dLayer(3,netWidth*8,'Padding',[1 1 1 1],'Stride',1,'Name','conv5_1')

%     31   'relu5_1'   ReLU                    ReLU
reluLayer('Name','relu5_1')

%     32   'conv5_2'   Convolution             512 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
convolution2dLayer(3,netWidth*8,'Padding',[1 1 1 1],'Stride',1,'Name','conv5_2')

%     33   'relu5_2'   ReLU                    ReLU
reluLayer('Name','relu5_2')

%     34   'conv5_3'   Convolution             512 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
convolution2dLayer(3,netWidth*8,'Padding',[1 1 1 1],'Stride',1,'Name','conv5_3')

%     35   'relu5_3'   ReLU                    ReLU
reluLayer('Name','relu5_3')

%     36   'conv5_4'   Convolution             512 3×3 convolutions with stride [1  1] and padding [1  1  1  1]
convolution2dLayer(3,netWidth*8,'Padding',[1 1 1 1],'Stride',1,'Name','conv5_4')

%     37   'relu5_4'   ReLU                    ReLU
reluLayer('Name','relu5_4')

%     38   'pool5'     Max Pooling             2×2 max pooling with stride [2  2] and padding [0  0  0  0]
maxPooling2dLayer(2,'Stride',2,'Padding',[0 0 0 0],'Name','pool5')

%     39   'fc6'       Fully Connected         4096 fully connected layer
fullyConnectedLayer(numClasses,'Name','fc6')

%     40   'relu6'     ReLU                    ReLU
reluLayer('Name','relu6')

%     41   'drop6'     Dropout                 50% dropout
dropoutLayer('Name','drop6')

%     42   'fc7'       Fully Connected         4096 fully connected layer
fullyConnectedLayer(numClasses,'Name','fc7')

%     43   'relu7'     ReLU                    ReLU
reluLayer('Name','relu7')

%     44   'drop7'     Dropout                 50% dropout
dropoutLayer('Name','drop7')

%     45   'fc8'       Fully Connected         1000 fully connected layer
fullyConnectedLayer(10,'Name','fc8')

%     46   'prob'      Softmax                 softmax
softmaxLayer('Name','prob')

%     47   'output'    Classification Output   crossentropyex
classificationLayer('Name','output')
];








