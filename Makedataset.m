% Use this code when training

training_image_list = {};
for a=1000:2:1200
    
    training_image_list = [training_image_list,['image/train/train_image_gray', num2str(a) ,'.png']];
    
end


patch_size = 33;

train_data = zeros(patch_size, patch_size, 1000000, 'single');
train_label = zeros(patch_size, patch_size, 1000000, 'single');

num_patches = 0;

% Make training data
for image_index = 1 : length(training_image_list)
    fprintf('Reading %s\n', training_image_list{image_index});
    
    for impulse_loop =1
        for impulse_noise_rate = 0:5:45
             for gaussian_noise_sigma = 0:10:50

            
            img_original = im2single(imread(training_image_list{image_index}));
            img_original = padarray(img_original, ceil(size(img_original)/patch_size)*patch_size-size(img_original) ,'symmetric','post');
            
            % AWGN
            img_noisy = img_original + (gaussian_noise_sigma / 255) * randn(size(img_original));
            
            % RVIN
            img_noise_position = rand(size(img_original)) < impulse_noise_rate / 100;
            img_noisy(repmat(img_noise_position,1,1)) = rand(1, sum(img_noise_position(:)));
            
            if impulse_noise_rate>0
                if gaussian_noise_sigma >0
                    if rand<0.15
                        % SPIN
                        img_noise_position = rand(size(img_original)) < randi(30) / 100;
                        img_noisy(repmat(img_noise_position,1,1)) = rand(1, sum(img_noise_position(:)))>0.5;
                    end
                end
            end
            
            
            tmp_data = im2col(img_noisy, [patch_size, patch_size], 'distinct');
            tmp_data = reshape(tmp_data, patch_size, patch_size, []);
            tmp_label = im2col(img_original, [patch_size, patch_size], 'distinct');
            tmp_label = reshape(tmp_label, patch_size, patch_size, []);
            
            train_data(:, :, num_patches + 1 : num_patches + size(tmp_data, 3)) = tmp_data;
            train_label(:, :, num_patches + 1 : num_patches + size(tmp_label, 3)) = tmp_label;
            
            num_patches = num_patches + size(tmp_data, 3);
            end
        end
    end
end

train_data = train_data(:, :, 1 : num_patches);
train_label = train_label(:, :, 1 : num_patches);


% reshape to MxNx1xC
train_data = reshape(train_data, patch_size, patch_size, 1, []);
train_label = reshape(train_label, patch_size, patch_size, 1, []);

% save('mixed_data.mat','train_data','train_label');
% clear all
fprintf('Complete.\n');