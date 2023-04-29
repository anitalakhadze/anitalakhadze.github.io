---
layout: post
title: Angular with Firebase Auth
subtitle: Ultimate Guide
thumbnail-img: /assets/img/angular_with_firebase.png
cover-img: /assets/img/blog_bg.png
gh-repo: anitalakhadze/angular-firebase-auth
gh-badge: [star, fork, follow]
tags: [angular, firebase, auth, authentication]
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

*A quick note:*  
**_Angular 15 simply doesn't ship anymore environment files by default. You can still create them and configure their replacement based on build target as it was done automatically at project creation in previous versions._**

If you are using Angular 15 cli, open the terminal and just run this command to create environments folder: 

```
ng g environments
```

Run the following command to install the dependencies once you open the project for the first time: 

```
npm install
```

Finally, run this to add the official Angular library for Firebase: 

```
ng add @angular/fire
```

For setting up all the Firebase configurations for us, You will be asked to provide some information. For the features that we would like to setip, you can choose only Authentication for this tutorial. Then select the Firebase account we’d like to use, and which project we want to setup. Select the project we created previously, and then select the app we also created earlier. Your configuration should look something like this:

![Angular Firebase Configuration](https://storage.googleapis.com/anita-website-cdn/angular-firebase-auth-sh2.png)


## Step 2: Create a new Firebase project

The next step is to create a new Firebase project. Go to the Firebase console and click on "Add project". Give your project a name and click on "Create project".

Once your project is created, click on "Authentication" on the left-hand menu and select "Set up sign-in method". Here, you can enable the authentication methods you want to use in your application, such as email/password, phone number, social media accounts, and more.

For this tutorial, we will enable email/password and GAuth methods.

![setting up auth methods](https://storage.googleapis.com/anita-website-cdn/angular-firebase-auth-sh1.png)


## Step 3: Install Firebase SDK

To use Firebase Authentication in our Angular application, you need to install the Firebase SDK. You can do this by running the following command in your terminal:

```
npm install firebase --save
```

## Step 4: Set up Firebase Authentication in our Angular application

Once we have installed the Firebase SDK, we need to set up Firebase Authentication service in our Angular application. Create a new service called auth.service.ts and add the following code:

```typescript
import { Injectable } from '@angular/core';
import {AngularFireAuth} from "@angular/fire/compat/auth";
import firebase from 'firebase/compat/app';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  user: firebase.User | null | undefined;

  constructor(private afAuth: AngularFireAuth) {
    this.afAuth.authState.subscribe(user => {
      this.user = user;
    });
  }

  async emailAndPasswordLogin(email: string, password: string) {
    try {
      const result = await this.afAuth.signInWithEmailAndPassword(email, password);
      this.user = result.user;
      return this.user;
    } catch (error) {
      console.log('Error logging in with email and password', error);
      throw error;
    }
  }

  async emailAndPasswordRegister(email: string, password: string) {
    try {
      const result = await this.afAuth.createUserWithEmailAndPassword(email, password);
      this.user = result.user;
      return this.user;
    } catch (error) {
      console.log('Error registering with email and password', error);
      throw error;
    }
  }

  async googleLogin() {
    try {
      const provider = new firebase.auth.GoogleAuthProvider();
      const result = await this.afAuth.signInWithPopup(provider);
      this.user = result.user;
      return this.user;
    } catch (error) {
      console.log('Error logging in with Google', error);
      throw error;
    }
  }

  async logout() {
    try {
      await this.afAuth.signOut();
      this.user = null;
    } catch (error) {
      console.log('Error logging out', error);
      throw error;
    }
  }

  isUserAuthenticated(): boolean {
    return this.user != null;
  }
}
```

This service provides the basic functionalities for user authentication, such as logging in and logging out. It uses the AngularFireAuth module to interact with Firebase Authentication.

## Step 5: Set up Firebase Configuration

To connect out Angular application to Firebase, first, we should add Firebase configuration in our Angular app's `environment.ts` file (make sure to add it in other environment files too, if such exist).

```
export const environment = {
  production: true,
  firebase: {
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_AUTH_DOMAIN",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_STORAGE_BUCKET",
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    appId: "YOUR_APP_ID"
  }
};
```

*You will need to replace the placeholders with you own Firebase project information, that can be found in the Firebase Console under "Project Settings"*

You can find your Firebase Configuration in the Firebase Console under "Project settings":

![Firebase Configuration in Firebase Console](https://storage.googleapis.com/anita-website-cdn/angular-firebase-auth-sh3.png)

Fortunately, as we are using the firebase library, these configuration is already set up in our environment files. 

Once we have added our Firebase configuration, we can access it in our Angular app by importing it and referencing it in your Firebase module import:

```typescript
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AngularFireModule } from '@angular/fire';
import { environment } from '../environments/environment';

import { AppComponent } from './app.component';

@NgModule({
  declarations: [AppComponent],
  imports: [
    BrowserModule,
    AngularFireModule.initializeApp(environment.firebase)
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule {}
```

This code initializes the Firebase app with your Firebase configuration from your environment.ts file using the AngularFireModule.

This is also taken care of with the help of the library. 


## Step 5: Setup a simple login component

Add Angular Material to easily style our page:

```
ng add @angular/material
```

Add [Toastr](https://www.npmjs.com/package/ngx-toastr) dependency for displaying notifications easily:

```
npm install ngx-toastr --save
```

**Add a simple Login component:**  
*login.component.ts*
```typescript
import {Component, OnInit} from '@angular/core';
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import {AuthService} from "../service/auth.service";
import {ToastrService} from "ngx-toastr";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {
  loginForm!: FormGroup;
  hide = true;

  constructor(
    private formBuilder: FormBuilder,
    private authService: AuthService,
    private toastr: ToastrService
  ) {
  }

  ngOnInit(): void {
    this.loginForm = this.formBuilder.group({
      email: ['', Validators.required],
      password: ['', Validators.required]
    });
  }

  loginWithEmail() {
    this.authService.emailAndPasswordLogin(
      this.loginForm.controls['email'].value,
      this.loginForm.controls['password'].value
    )
    .then(() => {
      this.toastr.success("success");
      this.loginForm.reset();
    });
  }

  loginWithGoogle() {
    this.authService.googleLogin()
      .then((user) => {
        this.toastr.success("Hello " + user?.displayName);
        this.loginForm.reset();
      });
  }

  logout() {
    this.authService.logout()
      .then(() => {
        this.toastr.success("Bye! See you soon.");
      });
  }

  isUserAuthenticated() {
    return this.authService.isUserAuthenticated();
  }

}
```

*login.component.html*  
```html
<div class="login-form-div center">
  <h1 style="text-align: center">Login</h1>

  <div class="form-group">
    <form [formGroup]="loginForm">
      <mat-form-field appearance="fill" class="form-field">
        <input placeholder="E-mail" formControlName="email" matInput [type]="'text'" name="new-somename"
               autocomplete="noac">
      </mat-form-field>

      <mat-form-field appearance="fill" class="form-field">
        <input placeholder="Password" formControlName="password" matInput [type]="hide ? 'password' : 'text'"
               name="new-somename" autocomplete="noac">
        <button mat-icon-button matSuffix (click)="hide = !hide" [attr.aria-label]="'Hide password'"
                [attr.aria-pressed]="hide">
          <mat-icon>{{hide ? 'visibility_off' : 'visibility'}}</mat-icon>
        </button>
      </mat-form-field>

    </form>

    <button mat-raised-button color="primary" class="login-btn"
            (click)="loginWithEmail()" [disabled]="loginForm.invalid">
      Login
    </button>

    <p>Don't have an account? <a routerLink="/register" class="btn btn-link">Sign up here</a></p>

    <button mat-raised-button class="google-auth-btn" color="accent"
            (click)="loginWithGoogle()">
      Google Auth
    </button>

    <button mat-raised-button class="google-auth-btn" color="warn"
            *ngIf="isUserAuthenticated()"
            (click)="logout()">
      Logout
    </button>

  </div>
</div>
```

*login.component.css*  
```css
.login-form-div {
  width: 40%;
  text-align: center;
  background: #bdc1cb;
  border-radius: 10px;
  box-shadow: rgba(255, 255, 255, 0.05) 0px 1px 1px 0px inset, rgba(50, 50, 93, 0.02) 0px 50px 100px -20px, rgba(0, 0, 0, 0.18) 0px 30px 60px -30px;
}

.form-group {
  padding: 20px;
  display: block;
  margin-right: auto;
  margin-left: auto;
}

.form-field {
  width: 90%;
  border-radius: 10px;
}

.login-btn, .google-auth-btn {
  margin: 10px;
  width: 80%;
  font-weight: bold;
  font-size: medium;
  height: 45px;
}
```  

**Then create a simple registration component:**  

*register.component.ts*
```typescript
import {Component, OnInit} from '@angular/core';
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import {AuthService} from "../service/auth.service";
import {ToastrService} from "ngx-toastr";
import {Router} from "@angular/router";

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.scss']
})
export class RegisterComponent implements OnInit{
  registerForm!: FormGroup;
  hide = true;

  constructor(
    private formBuilder: FormBuilder,
    private authService: AuthService,
    private toastr: ToastrService,
    private router: Router
  ) {
  }

  ngOnInit(): void {
    this.registerForm = this.formBuilder.group({
      email: ['', Validators.required],
      password: ['', Validators.required]
    });
  }

  registerWithEmail() {
    this.authService.emailAndPasswordRegister(
      this.registerForm.controls['email'].value,
      this.registerForm.controls['password'].value
    )
      .then(() => {
        this.toastr.success("success");
        this.router.navigate(['login'])
      });
  }

}
```  

*register.component.html*  
```html
<div class="login-form-div center">
  <h1 style="text-align: center">Register</h1>

  <div class="form-group">
    <form [formGroup]="registerForm">
      <mat-form-field appearance="fill" class="form-field">
        <input placeholder="E-mail" formControlName="email" matInput [type]="'text'" name="new-somename"
               autocomplete="noac">
      </mat-form-field>

      <mat-form-field appearance="fill" class="form-field">
        <input placeholder="Password" formControlName="password" matInput [type]="hide ? 'password' : 'text'"
               name="new-somename" autocomplete="noac">
        <button mat-icon-button matSuffix (click)="hide = !hide" [attr.aria-label]="'Hide password'"
                [attr.aria-pressed]="hide">
          <!-- <mat-icon>{{hide ? 'visibility_off' : 'visibility'}}</mat-icon> -->
        </button>
      </mat-form-field>

    </form>

    <button mat-raised-button color="primary" class="login-btn"
            (click)="registerWithEmail()" [disabled]="registerForm.invalid">
      Register
    </button>

    <p>Back to <a routerLink="/login" class="btn btn-link">Login</a></p>

  </div>
</div>
```  

*register.component.css*  
```css
.login-form-div {
  width: 40%;
  text-align: center;
  background: #bdc1cb;
  border-radius: 10px;
  box-shadow: rgba(255, 255, 255, 0.05) 0px 1px 1px 0px inset, rgba(50, 50, 93, 0.02) 0px 50px 100px -20px, rgba(0, 0, 0, 0.18) 0px 30px 60px -30px;
}

.form-group {
  padding: 20px;
  display: block;
  margin-right: auto;
  margin-left: auto;
}

.form-field {
  width: 90%;
  border-radius: 10px;
}

.login-btn {
  margin: 10px;
  width: 80%;
  font-weight: bold;
  font-size: medium;
  height: 45px;
}
```

**Finally, setup the routing in the `app-routing.module.ts` file:**  

*app-routing.module.ts*
```typescript
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {LoginComponent} from "./login/login.component";
import {RegisterComponent} from "./register/register.component";

const routes: Routes = [
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegisterComponent },
  {path: '', pathMatch: 'full', redirectTo: 'login'},
  {path: '**', redirectTo: 'login'}
  // Add any other paths here
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
```
