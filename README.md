# MEMRI Intensity Normalization through Modal Scaling of Grayscale Intensity Histograms 

Modal scaling is a linear intensity normalization technique that aligns the modes of the grayscale histograms from a dataset of T1-weighted images with the mode from a T1-weighted template image. The Bearer Lab has used this approach for intensity normalization of brain-wide Mn(II)-enhanced MRI data, to circumvent issues from other normalization/standardization techniques (e.g., z-score) that are influenced by the right-skewed, bimodal distribution of signal intensities that Mn(II)-enhancement results in. 

Modal scaling determines the modal intensity value of a template image's grayscale histogram and compares it to those from data images using non-linear curve fitting, then calculates the global intensity scalar (ratio of template over data) to apply by multiplication to the respective image. This linear transformation of greyscale values results in a shift of the histograms and an alignment of the modal intensities. Note: This function _does not_ result in non-linear transformations as in histogram matching. 

An example of an Image's grayscale histogram before and after scaling, and relative to the template's, is shown below:

![Example](ModalScalingExample.png)

## Dependencies

This code requires MATLAB 2017b or newer, and should be compatible with any MATLAB-compatible operating system. 

[MATLAB Download](https://www.mathworks.com/downloads/)

Upon release of MATLAB R2017b with built-in functions for processing NIfTI files - niftiread(), niftiwrite() and niftiinfo() - the code was no longer compatiable and required updates. The updated code is posted in this repository. For MATLAB scripts using older versions of MATLAB, please see the code posted in [Medina et al. (2017), _Current Protocols_](https://doi.org/10.1002/cpmb.40)


## References

[1. Bearer EL, Zhang X, Jacobs RE. Live imaging of neuronal connections by magnetic resonance: Robust transport in the hippocampal-septal memory circuit in a mouse model of Down syndrome. Neuroimage. 2007 Aug 1;37(1):230-42. doi: 10.1016/j.neuroimage.2007.05.010](https://pmc.ncbi.nlm.nih.gov/articles/PMC2074885/)

[2. Medina CS, Manifold-Wheeler B, Gonzales A, Bearer EL. Automated Computational Processing of 3-D MR Images of Mouse Brain for Phenotyping of Living Animals. Curr Protoc Mol Biol. 2017 Jul 5;119:29A.5.1-29A.5.38. doi: 10.1002/cpmb.40.](https://pmc.ncbi.nlm.nih.gov/articles/PMC6195809/)

