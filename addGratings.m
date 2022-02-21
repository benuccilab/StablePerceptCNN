
fprintf('Adding gratings...');

[nr,nc,~,nTR] = size(xTrain);
nVL   = size(xValidation,4);
ngrTR = size(xTrain_g,4);
ngrVL = size(xValidation_g,4);
if ngrVL>nVL, ngrVL = round(nVL*grtFrc); end

% random insertion points for gratings
foo = randperm(nTR); iiTR = foo(1:ngrTR);
goo = randperm(nVL); iiVL = goo(1:ngrVL);

for jj = 1:ngrTR
    
    % replace with gratings and update labels
    xTrain(:,:,1,iiTR(jj)) = xTrain_g(:,:,1,jj);
    YTrain(iiTR(jj)) = YTrain_g(jj);
    
    % NOTE: this separation test-validitation makes no sense...
    if jj<=ngrVL
        xValidation(:,:,1,iiVL(jj)) = xValidation_g(:,:,1,jj);
        YValidation(iiVL(jj)) = YValidation_g(jj);
    end
end

YTrain = reordercats(YTrain(:)); % categories(YTrain)
YValidation = reordercats(YValidation(:));

fprintf('Done!\n');

%% 
