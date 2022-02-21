
%% Add features after conv layer
if movInLayer~=0 && befConv==0
    
    mapSize(2)  = size(xTrain,1);   chanSize(2)  = 16;
    mapSize(6)  = size(xTrain,1)/2; chanSize(6)  = 32;
    mapSize(10) = floor(size(xTrain,1)/4);  chanSize(10) = 64;
    
    % Disconnect the layers to insert the addition_layer
    lgraph = disconnectLayers(lgraph,layers(movInLayer).Name,layers(movInLayer+1).Name);
    % figure; plot(lgraph); % analyzeNetwork(lgraph);
    
    % Create addition layer
    add = additionLayer(2,'Name','add_1');
    
    % Create feature input layer
    featuresDims = [mapSize(movInLayer),mapSize(movInLayer),chanSize(movInLayer)];
    featInput = imageInputLayer(featuresDims,'Normalization','none','Name','features');
    
    % Add the layers to the lgraph (still disconnected)
    lgraph = addLayers(lgraph, featInput);
    lgraph = addLayers(lgraph, add);
    
    % Connect
    lgraph = connectLayers(lgraph, 'features', 'add_1/in2');
    lgraph = connectLayers(lgraph, layers(movInLayer).Name, 'add_1/in1');
    lgraph = connectLayers(lgraph, 'add_1', layers(movInLayer+1).Name);
    
    %% Add features before conv layer
elseif movInLayer~=0 && befConv==1
    
    % lookup table for map sizes in my2Lnet
    mapSize(2)  = size(xTrain,1);   chanSize(2)  = 1;
    mapSize(6)  = size(xTrain,1)/2; chanSize(6)  = 16;
    mapSize(10) = floor(size(xTrain,1)/4);  chanSize(10) = 32;
    
    % Disconnect the layers to insert the addition_layer
    lgraph = disconnectLayers(lgraph,layers(movInLayer-1).Name,layers(movInLayer).Name);
    % figure; plot(lgraph); % analyzeNetwork(lgraph);
    
    % Create addition layer
    add = additionLayer(2,'Name','add_1');
    
    % Create feature input layer
    featuresDims = [mapSize(movInLayer),mapSize(movInLayer),chanSize(movInLayer)];
    featInput = imageInputLayer(featuresDims,'Normalization','none','Name','features');
    
    % Add the layers to the lgraph (still disconnected)
    lgraph = addLayers(lgraph, featInput);
    lgraph = addLayers(lgraph, add);
    
    % Connect
    lgraph = connectLayers(lgraph, 'features', 'add_1/in2');
    lgraph = connectLayers(lgraph, layers(movInLayer-1).Name, 'add_1/in1');
    lgraph = connectLayers(lgraph, 'add_1', layers(movInLayer).Name);
    
elseif movInLayer==0 && addGrtngs
    
    fprintf('No movement inputs: linear architecture, defined in modifyArchitecture\n')
    % change fully connected layer for the increased number of classes
    layers(13).Name = 'old_fc'; clear lgraph;
    old_lgraph = layerGraph(layers);
    nfc    = fullyConnectedLayer(numClasses+nangs,'Name','fc');
    lgraph = replaceLayer(old_lgraph,'old_fc',nfc); clear old_lgraph;
    
end





