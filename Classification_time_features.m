%% CLASSIFICATION OF DATA TIME FEATURES
clear all, clc, close all
% Load All Drill Data
load('C:\Users\space\Desktop\Classes\Intelligent Manufacturing\Finalproject\AllDrillData.mat'); 
% This data is already preprocessed with respect to the 4 steps explained
% in the paper (Filtering, Clipping, Smoothing and Normalizing).

%% FEATURE EXTRACTION
% Using Meysams frequency feature extraction function on the predefined
% and preprocessed 1 second data windows:
time_features_std = time_extraction(d1234_pen_win); % output: 60 obs x16 features double
time_features_pen = time_extraction(d1234_steady_win); % output: 60 obs x16 features double
time_features_all = vertcat(time_features_std,time_features_pen); % output: 120 obs x16 features double

%% DATA PARTITION
% Definition of output label vectors (Indicating classes 1-4)
y_steady = vertcat(ones(15,1), ones(15,1)*2, ones(15,1)*3, ones(15,1)*4); % 60x1 labels
y_penet = vertcat(ones(15,1), ones(15,1)*2, ones(15,1)*3, ones(15,1)*4); % 60x1 labels
y_combined = vertcat(y_steady,y_penet); % 120x1 labels
% Definition of the Input Data (here: all the feature data from fft):
X_steady = time_features_all;

%% CROSS VALIDATION AND CLASSIFICATION
cvp = cvpartition(120,'KFold',5);
for i=1:5
    trainingIndices = training(cvp,i);
    validationIndices = test(cvp,i);
    X_Train = X_steady(trainingIndices,:);
    X_Validation = X_steady(validationIndices,:);
    y_train = y_combined(trainingIndices,:);
    y_validation = y_combined(validationIndices,:);
    
    %% ANN - Articifial Neural Network Classifier
    clf_ann = fitcnet(X_Train,y_train, 'Verbose',0,'Activations','none', 'Standardize',true, 'Lambda',0.0024497,'LayerWeightsInitializer','he', 'LayerBiasesInitializer', 'zeros','LayerSizes', [6 5]);
    [label_ANN,score_ANN] = predict(clf_ann, X_Validation);
    
    cm_ann = confusionchart(y_validation, predict(clf_ann, X_Validation),...
        'Normalization' , 'row-normalized');
    conf_matrix_ANN(i,:,:) = cm_ann.NormalizedValues;

    %% kNN - k Nearest Neighbor Classifier
    clf_knn = fitcknn(X_Train,y_train,'NumNeighbors',5,'Standardize',1,'Distance','euclidean','DistanceWeight','inverse');
    [label_kNN,score_kNN] = predict(clf_knn, X_Validation);
    
    cm_knn = confusionchart(y_validation, predict(clf_knn, X_Validation),...
        'Normalization' , 'row-normalized');
    conf_matrix_kNN(i,:,:) = cm_knn.NormalizedValues;

    %% TREE - Decision Tree Classifier
    clf_tree = fitctree(X_Train,y_train);
    [label_TRE,score_TRE] = predict(clf_tree, X_Validation);
    
    cm_tree = confusionchart(y_validation, predict(clf_tree, X_Validation),...
        'Normalization' , 'row-normalized');
    conf_matrix_TRE(i,:,:) = cm_tree.NormalizedValues;
end

%% Plotting of the Confusion Matrices
conf_matrix_ANN = mean(conf_matrix_ANN,1);
conf_matrix_kNN = mean(conf_matrix_kNN,1);
conf_matrix_TRE = mean(conf_matrix_TRE,1);

figure(1);
confusionchart(round(squeeze(conf_matrix_ANN)*100));
title("ANN - normalized confusion matrix");
figure(2);
confusionchart(round(squeeze(conf_matrix_kNN)*100));
title("kNN - normalized confusion matrix");
figure(3);
confusionchart(round(squeeze(conf_matrix_TRE)*100));
title("TREE - normalized confusion matrix");