# Drill Defect Classification

**1. Introduction**

   As drilling happens, wear of drill bits occurs. In this project, 3 types of wear data and 1 healthy data have been studied and analyzed. The purpose of drill wear detection is to identify the best strategy with the highest recognition accuracy through pre-processing, feature extraction, and classification.

**2. Drill Bit Monitoring**

   There exist 2 stages in the drilling process: penetration and steady. 3 types of wear occur when drilling happens: flank, chisel, and outer corner. 4 datasets are available: Drill 1 for flank wear, Drill 2 for chisel wear, Drill 3 for outer corner wear, and Drill 4 for healthy data.

**3. Faulty Recognition Model**
  
  - **Preprocessing**

    - Frequency filtering has a low pass 20 order filter with a cut-off frequency of 12kHZ.
    ![image](https://user-images.githubusercontent.com/51737180/208764883-8085a0d7-d61f-422b-a9d4-a5c60b0f6264.png)

    - Clipping is used for finding the stable part of the recording. We divide the recording into 8 windows with an overlap rate of 50%. Then 1 second window with the lowest standard deviation has been selected for further processing and analysis.
    ![image](https://user-images.githubusercontent.com/51737180/208764964-38056479-d77d-4dc2-a798-34f3396ca778.png)


    - Smoothing is used to reduce outliers, a moving average filter has been used to implement that in Matlab
    ![image](https://user-images.githubusercontent.com/51737180/208764998-4bc19fa0-d13a-43df-b6b7-6ff1e149dc5a.png)


    - Scaling: recording is scaled from 0 to 1 using Max-Min Normalization.
    ![image](https://user-images.githubusercontent.com/51737180/208765018-b2e2be70-bf2d-4e1d-95bb-5c60f2244369.png)


   - **Feature Extraction**


     There are 3 types of features involved: time domain, frequency domain, and morlet. Time domain features include absolute mean, max peak, root mean square, variance, kurtosis, crest factor, shape factor, and skewness. We processed the frequency domain feature with Fast Fourier Transform (FFT) since FFT can provide signal energy distribution, phase, and amplitude information of the signal. First, we obtained spectrum from 0-5kHZ, then we set the number of bins to 16, and at last, we obtained a 120*16 matrix for the combined data. Morlet features include standard deviation, wavelet entropy, kurtosis, skewness, and variance. 

  - **Classification in frequency domain**


    We used 5-fold cross-validation to split the data into 80% training, and 20% validation. We then performed kNN, decision TREE, and ANN classification on combined data for all 3 types of features. We’ve found out that frequency domain features extraction yields the best results. Therefore, detailed results of frequency domain features classification are provided furthermore.
    ![image](https://user-images.githubusercontent.com/51737180/208765103-2c1e5c58-dbee-4f70-ad2d-12a55761b23b.png)

    
    - kNN
    
    The overall accuracy by drill stages is as follows:
    ![image](https://user-images.githubusercontent.com/51737180/208765192-5e4965d4-41a6-4705-9b55-b383bc2ce193.png)



    The true positive rate per wear types are as follows:
    ![image](https://user-images.githubusercontent.com/51737180/208765250-1677160f-1a27-4e47-8cd3-85bd8e90e1ba.png)



    - Decision TREE
    
    The overall accuracy by drill stages is as follows:
    
    ![image](https://user-images.githubusercontent.com/51737180/208765273-befc4bf0-1cd3-451f-af8c-f4dceb718908.png)


    The true positive rate per wear types are as follows:
    
    ![image](https://user-images.githubusercontent.com/51737180/208765598-f853ccbf-c49b-41e7-b2d1-b1c9bdc811f6.png)


    - ANN

    To tune the hyperparameters for this model, we exploited the hyperparameter tuning of MatLab. After multiple runs, it finally ends up with the following hyperparameters: we utilized a unit function as an activation function, two layers with the size of 6 and 5, “he” as a weight initializer, and zeros as a bias initializer. In order to do a comparison between different datasets fairly, we used the same network configuration. The overall accuracy by drill stages is as follows:
    
    ![image](https://user-images.githubusercontent.com/51737180/208765400-072bef53-ec9d-480b-aa59-45ad681505f7.png)





    The true positive rate per wear types are as follows:
    
    ![image](https://user-images.githubusercontent.com/51737180/208765415-d5903b2d-d230-494a-a5ba-a163f2dd9517.png)


**4. Performance Evaluation**


   ANN classification shows the highest results in classifying the data with selected pre-processing and cross-validation parameters.
   
   ![image](https://user-images.githubusercontent.com/51737180/208765525-0f7604c7-8768-409a-8c0c-fd9c18a51cb7.png)
   ![image](https://user-images.githubusercontent.com/51737180/208765543-9d780e93-d601-4bdf-9105-6e24c18e92d8.png)




   We can see that ANN performs the best in the Penetration and Combined stages while Decision TREE performs the best in a steady state. Accuracy for kNN is the worst in both penetration and steady stage. ANN is the winner. Average accuracy is the highest in the penetration stage, and worst in the steady state, stable from 93% to 96% overall. 

**5. Conclusions & Key Takeaways**


   Frequency domain features yield the best classification results among the 3 classifiers we selected. ANN has the best performance for the FFT data.
We could set up the number of bins to a different value when applying the FFT. For data partitioning, we could split the data as training, validation and testing. Besides the above 3 classifiers we selected, we could also try SVM, k-means or Random Forest classifiers. For the Time domain/Morlet data, PCM could be a method to change the current bad results.


**6. References**

The dataset is cloned from http://www.iitk.ac.in/iil/datasets/. It contains four class of drill Bit types. [Nishchal K. Verma, R. K. Sevakula, S. Dixit and A. Salour, Data Driven Approach for Drill Bit Monitoring, IEEE Reliability Magazine, pp. 19-26, Feb. 2015.]


**Contribution:**

* Louis Ebermann: Coded the preprocessing and fft-feature classification.
* Meysam Safarzadeh: Coded the feature extraction and ANN classifier.
* Jianmei Wu: Drafted the report.
