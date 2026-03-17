# Machine Learning Basics

## What is Machine Learning?

Machine learning (ML) is a subset of artificial intelligence (AI) that enables systems to learn and improve from experience without being explicitly programmed. It focuses on developing computer programs that can access data and use it to learn for themselves.

## Types of Machine Learning

### Supervised Learning
In supervised learning, the algorithm learns from labeled training data. Each training example consists of an input and a corresponding desired output (label). The goal is to learn a mapping from inputs to outputs.

Examples:
- Linear Regression — predicts continuous numerical values
- Logistic Regression — predicts binary categorical outcomes
- Decision Trees — uses a tree-like model for decisions
- Support Vector Machines (SVM) — finds the optimal separating hyperplane
- Neural Networks — layered networks of interconnected nodes

### Unsupervised Learning
In unsupervised learning, the algorithm is given data without explicit labels and must find structure on its own.

Examples:
- K-Means Clustering — groups data into k clusters
- Principal Component Analysis (PCA) — reduces dimensionality
- Autoencoders — learns compact representations

### Reinforcement Learning
Reinforcement learning involves an agent learning to make decisions by interacting with an environment to maximize cumulative rewards.

Key concepts:
- Agent — the learner or decision-maker
- Environment — what the agent interacts with
- Reward — feedback signal guiding the agent
- Policy — the agent's strategy for choosing actions

## Key Concepts

### Overfitting and Underfitting
- **Overfitting** occurs when a model learns the training data too well, including noise, resulting in poor generalization to new data.
- **Underfitting** occurs when a model is too simple to capture the underlying patterns in the data.

### Train-Test Split
Data is typically divided into training, validation, and test sets to evaluate model performance on unseen data.

### Features and Labels
- **Features** are the input variables used by the model.
- **Labels** are the target output variables the model is trained to predict.

### Loss Functions
Loss functions measure the difference between predicted and actual values. Common loss functions include Mean Squared Error (MSE) for regression and Cross-Entropy Loss for classification.
