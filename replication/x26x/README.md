## Example 1 : Video encoding

### 1 - About the experiment

#### 1- a] Goal

Study differences and similarities between *x264* and *x265*'s encoding.

#### 1- b] Configuration options

We leverage **33 common configuration options** between *x264*and *x265* :

- ``--aq-strength``: ['0.0', '0.5', '1.0', '1.5', '2.0', '2.5', '3.0'],

- ``--ipratio``: ['1.0', '1.1', '1.2', '1.3', '1.4', '1.5', '1.6'],

- ``--pbratio``: ['1.0', '1.1', '1.2', '1.3', '1.4'],

- ``--psy-rd``: ['0.2', '0.4', '0.6', '0.8', '1.0', '1.2', '1.4', '1.6', '1.8', '2.0', '2.2', '2.4','2.6','2.8', '3.0','3.2','3.4','3.6', '3.8', '4.0', '4.2', '4.4', '4.6', '4.8', '5.0'],

- ``--qblur``: ['0.2', '0.3', '0.4', '0.5', '0.6'],

- ``--qcomp``: ['0.6', '0.7', '0.8', '0.9'],

- ``--vbv-init``: ['0.0', '0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9'],

- ``--aq-mode``: ['0', '1', '2', '3'],

- ``--b-adapt``: ['0', '1', '2'],

- ``--bframes``: ['0', '2', '4', '6', '8', '10', '12', '14', '16'],

- ``--crf``: ['0', '5', '10', '15', '20', '25', '30', '35', '40', '45', '50'],

- ``--keyint``: ['200', '210', '220', '230', '240', '250', '260', '270', '280', '290', '300'],

- ``--lookahead-threads``: ['0', '1', '2', '3', '4'],

- ``--min-keyint``: ['20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30'],

- ``--qp``: ['0', '10', '20', '30', '40', '50'],

- ``--qpstep``: ['3', '4', '5'],

- ``--qpmin``: ['0', '1', '2', '3', '4'],

- ``--qpmax``: ['60', '61', '62', '63', '64', '65', '66', '67', '68', '69'],

- ``--rc-lookahead``: ['18', '28', '38', '48'],

- ``--ref``: ['1', '2', '3', '4', '5', '6'],

- ``--vbv-bufsize``: ['1000', '2000'],

- ``--deblock``: ['-2:-2', '-1:-1', '1:1'],

- ``--me``: ['dia', 'hex', 'umh'],

- ``--overscan``: ['show', 'crop'],

- ``--preset``: ['ultrafast',  'superfast',  'veryfast',  'faster',  'fast',  'medium',  'slow',  'slower',  'veryslow',  'placebo'],

- ``--scenecut``: ['0', '10', '30', '40'],

- ``--tune``: ['psnr', 'ssim', 'grain', 'animation'],

- ``--aud``: ["--aud", None],

- ``--constrained-intra``: ['--constrained-intra', None],

- ``--intra-refresh``: ['--intra-refresh', None],

- ``--no-asm``: [None, '--no-asm'],

- ``--slow-firstpass``: ['--slow-firstpass', None],

- ``--weightb``: ['--weightb', '--no-weightb']


The file diff_x264_x265.md in the test folder contains the list of configuration options common to *x264*and *x265*. We did not consider all of them since many of them do not have a direct influence on performances (e.g. ``--version`` or ``--help``), and due to the resulting configuration space (i.e. too large to be efficiently sampled).

#### 1- c] Configuration space

The file x264_x265_options.ipynb details the generation of the chosen 5000 configurations. The configurations are the same for *x264* and *x265*. We validate the sampling by applying one-sample Kolmogorov-Smirnov tests (compare the cumulative distributive functions of the generated distribution to the theorical uniform distribution, and check if the results are consistent). 

Each configuration (e.g. configuration n°1) is launched by a ``.sh`` file, in the script folder (resp. the 1.sh in the x264 folder for x264). Due to the difference of logs between *x264* and *x265*, we separate the scripts measuring *x264*'s performance from the *x265*'s scripts. However, the measurement process could be optimized (TODO = unify the script with if condition depending on software).

#### 1- d] Performances

We save the size of the encoded video (kb), the elapsed time of the encoding (seconds), the average number of frames encoded per second (number), the bitrate (kb/s)

### 2 - Replication and reproduction

#### 2- a] Manually launch

To launch the measures, just run the following command line in this folder:

`` bash ``

where:
-
-
-

#### 2- b] Docker

We provide a docker image...

TODO

