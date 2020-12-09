## Example 2 : Learning

### 1 - About the experiment

#### 1- a] Task

We study machine learning algorithm applied to object recognition.

#### 1- b] Software

Study differences and similarities between *Tensorflow* and *Theano*'s algorithms.

We use Keras with different backends : Tensorflow and Theano.

#### 1- c] Configuration options 

Common features are elements of the network architecture, e.g. the number of nodes in layers, the activation functions, the padding size, etc.

The network depends on the dataset, convolutional for (e)mnist, and dense for the iris.

#### 1- d] Configuration space

We choose some values of features and used random sampling to confirm the uniformity of the sampling over the chosen values, with the kolmogorov-smirnov test.

#### 1- e] Input data

We apply machine learning algorithms on three known datasets :

- The mnist dataset -> recognize the digits shown on pictures, and classify the pictures in the right category.

- The emnist dataset -> same, with letters instead of digits.

- The iris dataset -> classify the iris into species.

#### 1- f] Performances

We measure the accuracy and the training time of models.

### 2 - Replication and reproduction

#### 2- a] Manually launch measurements

#### 2- b] Docker

We provide a docker image to replicate the measurements. 

You can launch the previous commands in interactive mode.

TODO

