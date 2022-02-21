function [xTrain, xValidation, sTrain, sValid] = shiftImgs(xTrain, xValidation, s_size)
%
% [xTrain, xValidation, sTrain, sValid] = shiftImgs(xTrain, xValidation, s_size)
% 
% shift is done by frameImg.m with frmSize = 0 

frmSize = 0; % for frameImg, don't re-add a noise frame, just shift

nimgT = size(xTrain,4);
nimgV = size(xValidation,4);

% w = window2(nr,nc,@tukeywin,0.25);

% Generate the random saccadic shifts
sTrain = randi([-s_size,+s_size],2,nimgT);
sValid = randi([-s_size,+s_size],2,nimgV);

xxTrain = [];      
xxValidation = []; 

for ii = 1:nimgT
    img = squeeze(xTrain(:,:,1,ii)); % figure; imagesc(img);
    chg_img = frameImg(img,frmSize,sTrain(:,ii)); 
    xxTrain(:,:,1,ii) = chg_img;
    if ii <= nimgV
        img = squeeze(xValidation(:,:,1,ii)); % figure; imagesc(img);
        chg_img = frameImg(img,frmSize,sValid(:,ii));
        xxValidation(:,:,1,ii) = chg_img;
    end
end

clear xTrain xValidation
xTrain      = xxTrain; 
xValidation = xxValidation;














