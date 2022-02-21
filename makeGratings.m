function [xTrain_g,YTrain_g,xValidation_g,YValidation_g] = makeGratings(xTrain,xValidation,nangs,grtFrc)
% MAKEGRATINGS
%

fprintf('Making gratings...');

[nr,nc,~,nTR] = size(xTrain);
nVL   = size(xValidation,4);
ngrTR = round(nTR*grtFrc);
ngrVL = ngrTR; % round(nVL*grtFrc);

ANGS  = linspace(0,pi,nangs+1); ANGS = ANGS(1:end-1);
ANGS  = round(ANGS.*100)./100;

clear valueset
for ii = 1:nangs
    cat_name = sprintf('ang%1.0f',ii);
    valueset(ii) = cellstr(cat_name);
end

% list of all possible spatial phases
PHS = rand(ngrTR,2).*pi;

for jj = 1:ngrTR
    
    id = randperm(nangs); % pick rand orientation
    % from Matlab exchange matlabPyrTools
    IM = mkSine([nr,nc],8,ANGS(id(1)),1,PHS(jj,1),[0,0]); % -1, +1
    
    % remap in the image range
    IM = IM + 1;
    IM = IM./2;
    IM = IM.*255;
    % figure; imagesc(IM); colormap gray; colorbar
    
    % replace images with gratings and update labels
    xTrain_g(:,:,1,jj) = IM;
    cat_name = sprintf('ang%1.0f',id(1));
    YTrain_g(jj) = categorical(cellstr(cat_name),valueset);
    
    % NOTE: this separation test-validitation makes no sense, except for
    % the phase randomization
    if jj<=ngrVL
        id = randperm(nangs); % pick rand orientation
        IMv = mkSine([nr,nc],8,ANGS(id(1)),1,PHS(jj,2),[0,0]); % -1, +1
        % remap in the image range
        IMv = IMv + 1;
        IMv = IMv./2;
        IMv = IMv.*255;
        
        xValidation_g(:,:,1,jj) = IMv;
        cat_name = sprintf('ang%1.0f',id(1));
        YValidation_g(jj) = categorical(cellstr(cat_name),valueset);
    end
end

YTrain_g = YTrain_g(:);
YValidation_g = YValidation_g(:);

fprintf('Done!\n');




