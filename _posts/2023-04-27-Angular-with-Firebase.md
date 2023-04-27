---
layout: post
title: Angular with Firebase Auth
subtitle: Ultimate Guide
# thumbnail-img: /assets/img/java_clipart.png
# cover-img: /assets/img/blog_bg.png
# gh-repo: anitalakhadze/java17features
# gh-badge: [star, fork, follow]
# tags: [java17, java12]
comments: true
---

# Why Firebase Authentication with Angular?

Angular is a popular front-end framework for building web applications, while Firebase is a powerful platform for developing web and mobile applications. When combined, they provide developers with an efficient way to build robust applications. In this blog, we'll discuss how to integrate Firebase Authentication with Angular, step by step.

Firebase Authentication is a comprehensive platform that enables developers to authenticate users across various platforms. It supports a wide range of authentication methods, such as email/password, phone number, social media accounts, and more.

On the other hand, Angular is a popular front-end framework that enables developers to create dynamic and interactive web applications. It provides a wide range of tools and functionalities to help developers build robust applications with ease.

When Firebase Authentication is integrated with Angular, it provides a simple and efficient way to manage user authentication and access control. With Angular, developers can create a seamless user experience that allows users to interact with the application with ease.

Let's dive into the steps to integrate Firebase Authentication with Angular.

## Step 1: Set up a new Angular project

The first step is to create a new Angular project. You will need [Node.js](https://nodejs.org/en/download) and [Angular CLI](https://angular.io/cli) installed on your machine.

You can use the Angular CLI to create a new project by running the following command in your terminal:

```
ng new angular-firebase-auth
```

This will create a new Angular project with the name `angular-firebase-auth`.

## Step 2: Create a new Firebase project

The next step is to create a new Firebase project. Go to the Firebase console and click on "Add project". Give your project a name and click on "Create project".

Once your project is created, click on "Authentication" on the left-hand menu and select "Set up sign-in method". Here, you can enable the authentication methods you want to use in your application, such as email/password, phone number, social media accounts, and more.

For this tutorial, we will enable email/password and GAuth methods.

![setting up auth methods](https://storage.googleapis.com/anita-website-cdn/angular-firebase-auth-sh1.png)
