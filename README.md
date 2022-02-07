# AgonisticPigBehav
**Evaluation of computer vision for detecting agonistic behavior of pigs in single-spaced feeder through blocked cross-validation strategies**

This repository explains different validation strategies for convolutional neural network (CNN) + long short-term memory (LSTM) pipeline to classify agonitic behaivors between grow-finish pigs in single-spaced feeders.

If you find this resource helpful, please cite.

## Table of contents
* [Software](#Software)
* [Workflow](#Workflow)
* [Model_selection](#Model_selection)
* [Demo](#Demo)
* [Code](#Code)
* [Dataset](#Dataset)

## Software
* Experiments were implemented in [MATLAB](https://www.mathworks.com/products/matlab.html/) (version R2021a)

* [ResNet50](https://arxiv.org/abs/1512.03385/), [GoogleNet](https://arxiv.org/abs/1409.4842/), and [VGG16](https://arxiv.org/abs/1409.1556/) were investigated for (CNN) transfer learning to extract spatial features.

* GPU computing is available and is much faster compared to CPU. Typically, an [NVIDIA](https://developer.nvidia.com/cuda-gpus) graphic card is required for GPU computing.

## Workflow

* Layout of the pens and the focused area (Panels A and C are for Feeder 1 while B and D are from Feeder 2):

![](https://github.com/jun-jieh/AgonisticPigBehav/blob/main/Figures/Feeder%20Layout.png)

* Then we define several classes of agonistic behaviors (note: ear-to-body was merged into head-to-body):

![](https://github.com/jun-jieh/AgonisticPigBehav/blob/main/Figures/Ethogram.png)

* Further, three region of interests are investigated: 1) extended feeder area, 2) feeder region only, and 3) truncated feeder region.
![](https://github.com/jun-jieh/AgonisticPigBehav/blob/main/Figures/ROI.png)

