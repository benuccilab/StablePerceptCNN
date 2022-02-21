
xT = zeros(size(xTrain,1),size(xTrain,1),1,size(xTrain,4));
xV = zeros(size(xValidation,1),size(xValidation,1),1,size(xValidation,4));

for ii = 1:size(xTrain,4)
    xT(:,:,1,ii) = im2gray(squeeze(xTrain(:,:,:,ii)));
    try xV(:,:,1,ii) = im2gray(squeeze(xValidation(:,:,:,ii))); catch; end
end

xTrain = xT; 
xValidation = xV;

% figure; imagesc(squeeze(xT(:,:,1,500))); colorbar; colormap gray