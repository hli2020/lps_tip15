# Label Propagation Saliency
The code and results of the Label Propagation Saliency (LPS) work published in IEEE Transactions on Image Processing (TIP), 2015.

There are two versions of the paper, one is the camera-ready paper published in IEEE (link here); another is the author-preferred full version covering a complete experiment report in different datasets (available in [arXiv](http://arxiv.org/abs/1505.07192)).

## Usage
We test our code on Windows 8.1, Ubuntu 14.04 and OSX 10.10 with Matlab 2014b.
Just put your images in the directory and run `>> demo.m` in Matlab! Results will be generated in the same directory.

## Results
Saliency maps of the proposed algorithm on five datasets. [[LPS_maps](https://www.dropbox.com/s/s6brh52llp91288/LPS_maps.zip?dl=0)]

## Results of other models
We provide some (time-consuming-to-generate or dependencies-heavily-relied) results of other saliency detectors. We use the original software/code provided in the authors' website (but they does not include maps in the datasets that we experiment on). Do **NOT** email me inquiring on the availability of other models' results.

Currently, the following models are provided (maybe updated once in a while).
* *Saliency Tree: A Novel Saliency Detection Framework*, IEEE Transactions on Image Processing, Vol.23, No.5, May 2014. [[CCSD-5000](https://www.dropbox.com/s/9ofpi662nj3jfqd/ST_ccsd.zip?dl=0)] [[PASCAL-850](https://www.dropbox.com/s/x2odatfcchgzvvu/ST_pascal.zip?dl=0)]



## Paper discussion
I will list the most frequently asked questions here for future convenience (if there's any, stay tuned!). 

## Email the author
Please feel free to contact me and disuss the details (although I do not focus on saliency detection now, but I have some occasional paper reviewing job). Please add **LPS_TIP** at the beginning of the email subject so that I know you have read this document. Otherwise, I will not reply at all for the obvious reason. Also, do me a favor and do not ask silly questions like how to use the code or help you download the results.

## License and citation
This research is released under the [BSD 2-Clause license](https://github.com/BVLC/caffe/blob/master/LICENSE). We encourage an attitude of reproducible work for academic-only purpose. Please kindly cite our work in your publications if it helps your research:

    @article{li_tip15_lps,
      Author = {Li, Hongyang and Hu, Huchuan and Lin, Zhe and Shen, Xiaohui and Price, Brian},
      Journal = {IEEE Transactions on Image Processing},
      Volume = {},
      Title = {Inner and Inter Label Propagation: Salient Object Detection in the Wild},
      Year = {2015}
    }
