
nexT  = size(xTrain,4);
nexV  = size(xValidation,4);
% scaling of sacc amplitude based on max activations of conv1-3 in a net
% with no movements. Activations change when training with movements
[M2,M6,M10] = deal(1400,55,25);
scl(2)  = (M2*sclS)/(100*s_size);
scl(6)  = (M6*sclS)/(100*s_size);
scl(10) = (M10*sclS)/(100*s_size);

if movInLayer == 2 && befConv == 0, scl(2) = 30; end
if doSacc && validMov == 1
    movTrain = zeros([featInput.InputSize,nexT]);
    movVal   = zeros([featInput.InputSize,nexV]);
    nch = featInput.InputSize(3);
    for ii = 1:nexT
        if round(ii/1000) == ii/1000, fprintf('translations %d of %d\n',ii,nexT); end
        clear goo
        goo = movTrain(:,:,:,ii); % goo = foo;
        kk = randperm(length(goo(:)));
        max_kk = round(((pctI/2)*length(kk))/100);
        goo(kk(1:max_kk)) = sTrain(1,ii)*scl(movInLayer);
        goo(kk(max_kk+1:2*max_kk)) = sTrain(2,ii)*scl(movInLayer);
        movTrain(:,:,:,ii) = goo; % figure; hist(goo(:),500)
        if ii<=nexV
            clear goo
            goo = movVal(:,:,:,ii); % goo = foo;
            kk = randperm(length(goo(:)));
            max_kk = round(((pctI/2)*length(kk))/100);
            goo(kk(1:max_kk)) = sValid(1,ii)*scl(movInLayer);
            goo(kk(max_kk+1:2*max_kk)) = sValid(2,ii)*scl(movInLayer);
            movVal(:,:,:,ii) = goo; % figure; hist(goo(:),500)
        end
    end
elseif ~doSacc || validMov == 0
    movTrain = zeros([featInput.InputSize,nexT]);
    movVal   = zeros([featInput.InputSize,nexV]);
elseif doSacc && validMov == -1
    % The input for each image is NOT zero mean, but a rand xy saccade
    movTrain = zeros([featInput.InputSize,nexT]);
    movVal   = zeros([featInput.InputSize,nexV]);
    
    for ii = 1:nexT
        if round(ii/1000) == ii/1000, fprintf('translations %d of %d\n',ii,nexT); end
        sRand = randi([-s_size,s_size],4,1).*scl(movInLayer); % random xy saccade
        
        clear goo
        goo = movTrain(:,:,:,ii); % goo = foo;
        kk = randperm(length(goo(:)));
        max_kk = round(((pctI/2)*length(kk))/100);
        goo(kk(1:max_kk)) = sRand(1);
        goo(kk(max_kk+1:2*max_kk)) = sRand(2);
        movTrain(:,:,:,ii) = goo; % figure; hist(goo(:),500)
        
        if ii<=nexV
            goo = movVal(:,:,:,ii);
            kk = randperm(length(goo(:)));
            max_kk = round(((pctI/2)*length(kk))/100);
            goo(kk(1:max_kk)) = sRand(3);
            goo(kk(max_kk+1:2*max_kk)) = sRand(4);
            movVal(:,:,:,ii) = goo; % figure; hist(goo(:),500)
        end
    end
    
elseif doSacc && validMov == -2
    % The input for each image is zero mean rand
    error('Need to fix this ''if'' section...\n');
end




