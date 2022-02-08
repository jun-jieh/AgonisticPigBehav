# AgonisticPigBehav
**Evaluation of computer vision for detecting agonistic behavior of pigs in single-spaced feeder through blocked cross-validation strategies**

This repository explains different validation strategies for convolutional neural network (CNN) + long short-term memory (LSTM) pipeline to classify agonitic behaivors between grow-finish pigs in single-spaced feeders.

If you find this resource helpful, please cite.

## Table of contents
* [Software](#Software)
* [Pens](#Pens)
* [Behaviors](#Behaviors)
* [ROIs](#ROIs)
* [Preparation](#Preparation)
* [CNN+LSTM](#CNN+LSTM)
* [Code](#Code)
* [Dataset](#Dataset)

## Software
* Experiments were implemented in [MATLAB](https://www.mathworks.com/products/matlab.html/) (version R2021a)

* [ResNet50](https://arxiv.org/abs/1512.03385/), [GoogleNet](https://arxiv.org/abs/1409.4842/), and [VGG16](https://arxiv.org/abs/1409.1556/) were investigated for (CNN) transfer learning to extract spatial features.

* GPU computing is available and is much faster compared to CPU. Typically, an [NVIDIA](https://developer.nvidia.com/cuda-gpus) graphic card is required for GPU computing.

## Pens
* __Layout of the pens and the focused area (Panels A and C are for Feeder 1 while B and D are from Feeder 2):__

![](https://github.com/jun-jieh/AgonisticPigBehav/blob/main/Figures/Feeder%20Layout.png)


## Behaviors
* __Then we define several classes of agonistic behaviors (note: ear-to-body was merged into head-to-body):__

![](https://github.com/jun-jieh/AgonisticPigBehav/blob/main/Figures/Ethogram.png)


## ROIs
* __Further, three region of interests are investigated: 1) extended feeder area, 2) feeder region only, and 3) truncated feeder region.__
![](https://github.com/jun-jieh/AgonisticPigBehav/blob/main/Figures/ROI.png)


## Preparation
* __The base classification unit is 30 frames. The dataset presented extreme class-imbalance. For majority categories (HB and NC) we cut the episodes without overlapping frames. For minority classes (L and M), we up-sampled episodes by overlapping 25 frames:__

![](https://github.com/jun-jieh/AgonisticPigBehav/blob/main/Figures/Upsampling.png)


* __The dataset contains 3,398 episodes for no-contact, 10,114 episodes for head-to-body, 925 episodes for levering, and 1,242 episodes for mounting (Total = 15,679).__


## CNN+LSTM
* __A convolutional neural network (CNN) + long short-term memory (LSTM) pipeline was utilized to learn from the input videos. CNN was used for spatial feature extraction and LSTM was used for temporal feature extraction. The input was the resized videos (to match the dimension requirement of transfer learning). More specifically, the input consisted of 30 resized frames given the order of raw video. The output was the predicted behavior class along with softmax activation for its score.__

![](https://github.com/jun-jieh/AgonisticPigBehav/blob/main/Figures/Pipeline.png)


## Code

* Code can be found in the __MATLAB__ folder

* __CNN_LSTM_PigCV__ shows implementation of data processing, transfer learning, model fitting, and evaluation.

* Notice there are multiple functions included in the __Functions__ folder. Make sure they are added to path.

`CompStats` computes the recall, precision, \& F1 Score based on given behavior labels and the confusion table.

`CropFeeder` crops all videos in an existing folder and saves results in the specified folder. ROI should be defined beforehand.

`DiagPlots` generates diagnostic plots by showing video properties given specific grouping factors.

`fitFocal` receives the training and testing sets and returns the fitted LSTM model and training history. Focal loss was defined within this function.

`PlotTrainHis` recovers the training process from model fitting.

`readVideo`* loads individual video and reshapes videos into array format.

`resizeVideo`* resize the video into the dimension that is a valid input size to (CNN) transfer learning.

`videoFiles`* loads all the video files within a specified folder and assign lebels to files based on the subfolder name.

Note: * means that the function is modified based on existing online resource. Check [this from MathWorks](https://www.mathworks.com/help/deeplearning/ug/classify-videos-using-deep-learning.html/).

## Dataset

To find the dataset used in this study, please make sure all files are downloaded from the OSF Data Repository (under the folder `Data for paper on interaction recognition`): https://osf.io/wa732/

* Check list:

1. __Raw Videos__ folder that contains all video episodes.
2. Alternatively, __All_data.mat__ wrapped the ready-to-use feature sets extracted from (CNN) transfer learning. (Note: the ROI focused on the truncated feeder area.)
3. __Meta_data.mat__ is a metadata file that allows us to explore the property of the dataset.
