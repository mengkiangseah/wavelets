function [Tx_RGB, Ty_RGB]= ImageRegistration(limit)
% *************************************************************************
% Wavelets and Applications Course - Dr. P.L. Dragotti
% MATLAB mini-project 'Sampling Signals with Finite Rate of Innovation'
% Exercice 6
% *************************************************************************
% 
% FOR STUDENTS
%
% This function registers the set of 40 low-resolution images
% 'LR_Tiger_xx.tif' and returns the shifts for each image and each layer
% Red, Green and Blue. The shifts are calculated relatively to the first
% image 'LR_Tiger_01.tif'. Each low-resolution image is 64 x64 pixels.
%
%
% OUTPUT:   Tx_RGB: horizontal shifts, a 40x3 matrix
%           Ty_RGB: vertical shifts, a 40x3 matrix
%
% NOTE: _Tx_RGB(1,:) = Ty_RGB(1,:) = (0 0 0) by definition.
%       _Tx_RGB(20,2) is the horizontal shift of the Green layer of the
%       20th image relatively to the Green layer of the first image.
%
%
% OUTLINE OF THE ALGORITHM:
%
% 1.The first step is to compute the continuous moments m_00, m_01 and m_10
% of each low-resolution image using the .mat file called:
% PolynomialReproduction_coef.mat. This file contains three matrices
% 'Coef_0_0', 'Coef_1_0' and 'Coef_0_1' used to calculate the continuous
% moments.
%
% 2.The second step consists in calculating the barycenters of the Red,
% Green and Blue layers of the low-resolution images.
%
% 3.By computing the difference between the barycenters of corresponding 
% layers between two images, the horizontal and vertical shifts can be 
% retrieved for each layer.
%
%
% Author:   Loic Baboulaz
% Date:     August 2006
%
% Imperial College London
% *************************************************************************


% Load the coefficients for polynomial reproduction
    load('PolynomialReproduction_coef.mat','Coef_0_0','Coef_1_0','Coef_0_1');

% -------- include your code here -----------
    % Output variables, aka dx and dy
    Tx_RGB = zeros(40, 3);
    Ty_RGB = zeros(40, 3);
    % Barycenters, aka xbar and ybar
    baryX = zeros(40, 3);
    baryY = zeros(40, 3);
    
    % Each Picture
    for picture = 1:40
        % Obtain file.
        filename = ['LR_Tiger_' sprintf('%02d', picture) '.tif'];
        A = imread(filename);
        A = double(A)./255;

        % Threshold stuff.
        A(A < limit) = 0;
        
        % RGB, each colour, obtain barycenter. 
        for colour = 1:3
            grid = A(:, :, colour);

            m_0_0 = sum(sum(grid .* Coef_0_0));
            m_0_1 = sum(sum(grid .* Coef_0_1));
            m_1_0 = sum(sum(grid .* Coef_1_0));

            baryX(picture, colour) = m_1_0/m_0_0;
            baryY(picture, colour) = m_0_1/m_0_0;
        end

    end
    
    % Since dx1 and dy1 are always 0, start at 2.
    for picture = 1:40
        for colour = 1:3
            % dxi = baryxi - baryx1, for each colour. Also for y.
            Tx_RGB(picture, colour) = baryX(picture, colour) - baryX(1,colour);
            Ty_RGB(picture, colour) = baryY(picture, colour) - baryY(1,colour);
        end
    end
end



