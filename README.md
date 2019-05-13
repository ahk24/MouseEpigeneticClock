# Mouse Epigenetic Clock
Here we present an epigentic clock in mouse. This packages accompanies the manuscript of Stubbs et al currently in press at Genome Biology. Using the code provided here you are able to predict the age of a mouse using methylation information at 329 CpG sites. To run the code in: `./toRun.R` please be sure to have the dependencies for Rmarkdown & preprocesscore installed on your machine. The necessary dependencies are mentioned in the top of the `toRun.R` file. 

This package contains all the code needed to predict the methylation age for a new sample. For convenience we have included the data from the Zhang et al study (PMID: 27379160). To do an initial test of the model and to see if the setup is correct. In the HTML file a description about the read mapping procedure for the original samples is given and the prediction is run. If the package is set up correctly the code will generate a html output file: `./PredictingAgeLeftOutSample.html` file that is equal to the provided: `./PredictingAgeLeftOutSample_org.html`. 

Additionally we now provide a version of the code that includes an imputation step. If one wants to run the package including imputation please use `toRun_Imputation.R` instead of `toRun.R`. A similar output HTML file is generated but now with an added imputation step (`./ImputationAndPredictingAgeLeftOutSample.html`). The imputation of the methylation values is performed based on knn imputation using the original training data and all the samples to be predicted as a background. Please note that because of this the results of the clock might differ if a run is performed per sample as compared to a multi sample run. For reference we included results we obtained by leaving out different percentages of the sites from the Zhang et al study (PMID: 27379160). https://github.com/EpigenomeClock/MouseEpigeneticClock/blob/master/Impact_of_Imputation_ZhangData.png
