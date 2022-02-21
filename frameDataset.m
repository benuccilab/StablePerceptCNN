function [new_imgsTrain, new_imgsValidation] = frameDataset(imgsTrain, imgsValidation, frmSize)
%
% imgsTrain & imgsValidation are [nr,nc,1,nsamples]
%
% frmSize = (s_size/2)+1;
%

fprintf('Adding rand frame to dataset...\n');

new_imgsTrain = [];
new_imgsValidation = [];

for ii = 1:size(imgsTrain,4)
    new_imgsTrain(:,:,1,ii) = frameImg(squeeze(imgsTrain(:,:,1,ii)),frmSize);
    if ii <= size(imgsValidation,4)
        new_imgsValidation(:,:,1,ii) = frameImg(squeeze(imgsValidation(:,:,1,ii)),frmSize);
    end
end

fprintf('Done!\n');
