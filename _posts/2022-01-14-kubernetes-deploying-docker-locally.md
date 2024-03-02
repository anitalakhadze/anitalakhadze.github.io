---
layout: post
title: Kubernetes
subtitle: Deploying a Docker Image to a Local Cluster
tags: [Kubernetes, Deployment, Minikube, Docker, Kubectl]
comments: true
author: Ani Talakhadze
---

In this tutorial, I want to show you how to deploy a docker image to a local Kubernetes cluster directly from your computer. This will hugely increase your coding confidence. So grab your favorite snacks and keep the rhythm!


## Setting up the environment  

We will need [Docker](https://docs.docker.com/get-started/overview/) to package our application into a container and run it on a K8s cluster.

To get started with setting up a local K8s cluster, we can use [Minikube](https://minikube.sigs.k8s.io/docs/), which is a lightweight K8s implementation that creates a VM on our local machine and deploys a simple cluster containing only one node.

Minikube is a great tool to have in your kit. It is available for all operating systems and the Minikube CLI provides basic helpful operations, including starting, stopping, deleting the cluster, or checking the status.

After having installed Docker and Minikube, you’re ready to go.


## Setting up the local cluster  

Let’s get down to business and start 2 nodes with the following command:

```bash
minikube start --nodes=2
```


