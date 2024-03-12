---
layout: post
title: Spring Security With JWT
tags: [Spring Boot, Sprint Security, JWT, Authentication, Authorization, Java]
comments: true
author: Ani Talakhadze
---

In this tutorial, you’ll learn all you need to know about using Spring Boot with JWT to protect your applications. Everything in this section may be used in your Angular, React, or other apps.

If you’ve read any of my articles, you’re probably aware that I try to highlight the concepts behind the solutions, so, before we dive into the code, let’s clarify what JWT is. This understanding, in my opinion, will substantially assist you in implementing these security aspects with more awareness and presence. Let us not spend any more of our valuable time and get down to business!


## What is JWT?  

JWT stands for JSON Web Token (JWT) and is a method of exchanging data across apps. Its appeal stems from the fact that it is compact, self-contained, and extremely safe. It’s really simple to use since you may send it in the request body, headers, or forms.

The most typical situation is to use JWTs for authorization. When a user logs in, your backend application generates a JWT token containing the user’s information and digitally signs it. The token will be sent as proof of authorization whenever a user wishes to access routes, services, or resources after that.


## What is the structure of JWT?  

To clarify, JWT is made up of three parts: header, payload, and signature, which are separated by dots. Each component of the JWT is encoded in Base64Url. They are simple to pass in an HTTP environment, and they are also more compact than their alternatives.

The header typically contains information about the type of token and the signature algorithm used, such as SHA256 or RSA.

The payload includes relevant and interoperable information on the claims, such as iss (issuer), exp (expiration time), sub (subject), and so on. You should not put any sensitive information in the payload or header components of a JWT unless it is encrypted, as this information is viewable by anybody, even if it is secured against modification.

We need to use the encoded header, encoded payload, a secret, and the algorithm specified in the header to create the final, signature section. The signature verifies that the message has not been tampered with along the route.

For future reference, on the internet, there is a great [website](https://jwt.io/) that allows you to put these principles into practice by enabling you to decode, validate, and generate JWTs.


## Setting up the project  

We’ll create an example application to demonstrate how to use JWT for authorization in this tutorial. Let’s start by making a project with the following dependencies: Spring Web, Spring Data JPA, MySQL Driver, Spring Security, and Lombok.

We will configure our database connection in the application.properties file:

```properties
spring.jpa.hibernate.ddl-auto=update
spring.datasource.url=jdbc:mysql://${MYSQL_HOST:localhost}:3306/jwt_demo
spring.datasource.username=jwtdemouser
spring.datasource.password=password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

Our application will have a class User that may look something like this - a simple class with desired properties that will be mapped to a database table:

```java
package com.example.springbootsecuritydemo.user;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.Collection;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    @Id @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String name;
    private String username;
    private String password;
    @ManyToMany(fetch = FetchType.EAGER)
    private Collection<Role> roles = new ArrayList<>();
}
```

We’ll also need a class Role to represent user roles, which will also be mapped to a database table:

```java
package com.example.springbootsecuritydemo.user;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String name;
}
```

After that, we can create a UserRepository that extends JpaRepository and acts as an abstraction for storing and managing our data. In the case of a user, it will contain a custom method for getting a user by the unique username and will look like this:

```java
package com.example.springbootsecuritydemo.user;

import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByUsername(String username);
}
```

And in case of a role, RoleRepository will be similar to this:

```java
package com.example.springbootsecuritydemo.user;

import org.springframework.data.jpa.repository.JpaRepository;

public interface RoleRepository extends JpaRepository<Role, Long> {
    Role findByName(String username);
}
```

Then, let’s move on and create a UserService interface with all of the methods we’ll need to display and modify our user data:

```java
package com.example.springbootsecuritydemo.user;

import java.util.List;

public interface UserService {
    User saveUser(User user);
    Role saveRole(Role role);
    void addRoleToUser(String username, String roleName);
    User getUser(String username);
    List<User> getUsers();
}
```

The UserServiceImpl will implement the above-mentioned UserService and execute database operations with the help of UserRepository and RoleRepository instances. For the sake of this tutorial, we’ll keep the implementation really simple:

```java
package com.example.springbootsecuritydemo.user;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;

    @Override
    public User saveUser(User user) {
        return userRepository.save(user);
    }

    @Override
    public Role saveRole(Role role) {
        return roleRepository.save(role);
    }

    @Override
    public void addRoleToUser(String username, String roleName) {
        User user = userRepository.findByUsername(username);
        Role role = roleRepository.findByName(roleName);
        user.getRoles().add(role);
        userRepository.save(user);
    }

    @Override
    public User getUser(String username) {
        return userRepository.findByUsername(username);
    }

    @Override
    public List<User> getUsers() {
        return userRepository.findAll();
    }
}
```

After we have implemented the service, let’s set up UserController with relevant API endpoints:

```java
package com.example.springbootsecuritydemo.user;

import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class UserController {
    private final UserService userService;

    @GetMapping("/users")
    public ResponseEntity<List<User>> getUsers() {
        return ResponseEntity.ok().body(userService.getUsers());
    }

    @PostMapping("/user/save")
    public ResponseEntity<User> saveUser(@RequestBody User user) {
        URI uri = URI.create(ServletUriComponentsBuilder.fromCurrentContextPath().path("/api/user/save").toUriString());
        return ResponseEntity.created(uri).body(userService.saveUser(user));
    }

    @PostMapping("/role/save")
    public ResponseEntity<Role> saveRole(@RequestBody Role role) {
        URI uri = URI.create(ServletUriComponentsBuilder.fromCurrentContextPath().path("/api/role/save").toUriString());
        return ResponseEntity.created(uri).body(userService.saveRole(role));
    }

    @PostMapping("/role/addtouser")
    public ResponseEntity<?> addRoleToUser(@RequestBody RoleToUserForm form) {
        userService.addRoleToUser(form.getUsername(), form.getRoleName());
        return ResponseEntity.ok().build();
    }
}

@Data
class RoleToUserForm {
    private String username;
    private String roleName;
}
```

As the final step in this section, let’s add this CommandLineRunner bean to our main class and load some roles and users into the database to test our application and actually see some data (don’t forget to delete this bean after first start of the application as you will get exceptions for trying to insert duplicate values afterwards):

```java
@Bean
CommandLineRunner run(UserService userService) {
    return args -> {
        userService.saveRole(new Role(null, "ROLE_USER"));
        userService.saveRole(new Role(null, "ROLE_MANAGER"));
        userService.saveRole(new Role(null, "ROLE_ADMIN"));
        userService.saveRole(new Role(null, "ROLE_SUPER_ADMIN"));

        userService.saveUser(new User(null, "user1", "user1", "123", new ArrayList<>()));
        userService.saveUser(new User(null, "user2", "user2", "123", new ArrayList<>()));
        userService.saveUser(new User(null, "user3", "user3", "123", new ArrayList<>()));
        userService.saveUser(new User(null, "user4", "user4", "123", new ArrayList<>()));

        userService.addRoleToUser("user1", "ROLE_USER");
        userService.addRoleToUser("user2", "ROLE_MANAGER");
        userService.addRoleToUser("user3", "ROLE_ADMIN");
        userService.addRoleToUser("user4", "ROLE_ADMIN");
        userService.addRoleToUser("user4", "ROLE_USER");
        userService.addRoleToUser("user4", "ROLE_SUPER_ADMIN");
    };
}
```

Spring Security is now providing user credentials for us without any additional setup. Fortunately, configuring in-memory authentication - hardcoding a few users, and storing them in memory is simple and straightforward. I won’t go into great depth about this process; however, you can read a step-by-step guide in my previous blog. Our SecurityConfiguration class should look something like this after we define some users:

```java
package com.example.springbootsecuritydemo.security;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfiguration extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.inMemoryAuthentication()
                .withUser("user")
                .password("password")
                .roles("ADMIN")
                .and()
                .withUser("admin")
                .password("password")
                .roles("USER");
    }
    
    @Bean
    PasswordEncoder passwordEncoder() {
        return NoOpPasswordEncoder.getInstance();
    }
}
```

Once we start the application and log in to it, we can actually see some data coming from the database:

<figure>
  <img src="https://i.imgur.com/SPPFleJ.png" alt="Trulli" style="width:100%">
  <figcaption><center>Fetching list of users after login
</center></figcaption>
</figure>


## Authentication and authorization configuration  

