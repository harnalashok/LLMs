# Deep Learning

## What is Deep Learning?

Deep learning is a subset of machine learning that uses artificial neural networks with multiple layers (hence "deep") to learn representations of data with multiple levels of abstraction. It has achieved remarkable results in image recognition, speech recognition, natural language processing, and many other domains.

## Neural Networks

### Basic Structure
A neural network consists of:
- **Input Layer** — receives raw features
- **Hidden Layers** — learn intermediate representations
- **Output Layer** — produces the final prediction

Each layer is made up of **neurons** (also called nodes or units). Neurons are connected by **weights**, which are learned during training.

### Activation Functions
Activation functions introduce non-linearity into the network, allowing it to learn complex patterns.

Common activation functions:
- **ReLU (Rectified Linear Unit)** — `f(x) = max(0, x)` — most widely used for hidden layers
- **Sigmoid** — maps values to (0, 1), used for binary classification output
- **Softmax** — maps values to probability distribution, used for multi-class output
- **Tanh** — maps values to (-1, 1)

### Backpropagation
Backpropagation is the algorithm used to train neural networks. It computes the gradient of the loss function with respect to each weight using the chain rule, then updates weights using gradient descent.

## Types of Neural Networks

### Convolutional Neural Networks (CNNs)
CNNs are specialized for processing grid-structured data such as images. They use convolutional layers with learned filters to detect local patterns like edges, textures, and shapes.

Key components:
- **Convolutional Layer** — applies learned filters across the input
- **Pooling Layer** — downsamples feature maps to reduce spatial dimensions
- **Fully Connected Layer** — combines features for final classification

### Recurrent Neural Networks (RNNs)
RNNs are designed for sequential data such as text, speech, and time series. They maintain a hidden state that carries information across time steps.

Variants:
- **LSTM (Long Short-Term Memory)** — addresses vanishing gradient problem
- **GRU (Gated Recurrent Unit)** — simpler variant of LSTM

### Transformers
Transformers are the dominant architecture in NLP. They use self-attention mechanisms to model relationships between all positions in a sequence simultaneously, making them highly parallelizable.

Notable transformer-based models:
- **BERT** — bidirectional encoder for language understanding
- **GPT** — autoregressive decoder for text generation
- **T5** — text-to-text encoder-decoder model

## Training Deep Learning Models

### Optimizers
- **SGD (Stochastic Gradient Descent)** — basic optimizer
- **Adam** — adaptive learning rate optimizer, widely used in practice
- **RMSProp** — adaptive optimizer suitable for non-stationary objectives

### Regularization Techniques
- **Dropout** — randomly deactivates neurons during training to prevent overfitting
- **Batch Normalization** — normalizes layer inputs to stabilize and accelerate training
- **Weight Decay (L2 Regularization)** — penalizes large weights

### Frameworks
Popular deep learning frameworks:
- **PyTorch** — flexible, Pythonic framework favored in research
- **TensorFlow / Keras** — production-ready framework by Google
- **JAX** — high-performance numerical computing with auto-differentiation
