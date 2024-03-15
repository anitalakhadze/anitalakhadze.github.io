---
layout: post
title: Spring Boot Security - Authorization Configuration
tags: [Spring Boot, Sprint Security, Authorization, Java]
comments: true
author: Ani Talakhadze
---

If you’ve been reading my blogs, you’ve probably already read about core concepts, in-memory authentication, and database authentication, which are all critical aspects of Spring Security. I believe it is time for us to move on to the next crucial item on our agenda: authorization configuration.

The purpose of the authorization is to determine whether or not the request has the authority to carry out the task at hand. So we’ll create a Spring Boot project with a few APIs and learn how to permit or prohibit access based on who is signed in. So, let’s get started!


## Setting up the project  

Now as we’ve arrived at the start of our tutorial, consider the following scenario: we have a standard Spring Boot application with Spring Web and Spring Security dependencies, as well as in-memory authentication enabled. A step-by-step explanation for this part is out of the scope of this article, however, you can read about it all in detail in another article here. In short, your security configuration class should look like this:

