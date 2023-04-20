---
layout: post
title: Java 12 to 17
subtitle: All You Need To Know
gh-repo: anitalakhadze/java17features
gh-badge: [star, fork, follow]
tags: [java17, java12]
comments: true
---

If you’ve been putting off using Java 17 until now, I’ve got some good news for you. You’ll be able to learn about the trendiest top features from Java 12 to Java 17 in one place and try out coding with me.

To begin, Java 17 will be a long-term support (LTS) version, similar to Java 11 and Java 8. It was introduced to the Java community in September 2021, and includes several new features and upgrades. You can see a list of all the features here, but in this tutorial, I’ll focus on a few that have particularly sparked my interest.



<h3>Sealed Classes [Java 17]</h3>

Sealed classes are a new means of enforcing rules on inheritance. They allow a developer to explicitly declare the permitted sub-types of a type, thus preventing others from unintendedly extending or implementing it.

When you add the sealed keyword to a class or interface’s declaration, you’re also adding a list of classes that can extend or implement it. Anything outside the pre-defined batch will fail to compile.

For example, suppose you create a class Animal and you want only the classes Cat and Dog to extend it:

```java
public abstract sealed class Animal permits Cat, Dog {
}
```

The subclasses must be final, sealed or non-sealed:

```java
public final class Cat extends Animal {
}
```

Sealed classes not only keep your code safe from outsiders, but they also express your purpose to individuals you’ll never meet. When you seal a class, you’re indicating that only certain classes are allowed to extend it.



<h3>Record Classes [Java 16]</h3>

Records are data-only classes that take care of all the boilerplate code for POJOs. The equals() and hashcode() methods are automatically implemented, along with toString() and getter methods.

You can declare a record in the following manner:

```java
public record PersonRecord(String name, Integer age) {
}
```

Records are final and immutable. In a Record, you may specify both non-static and static methods:

<!-- ![cat](https://storage.googleapis.com/anita-website-cdn/Cat.jpeg) -->

```java
public record PersonRecord(String name, Integer age) {
    public boolean isOver18() {
        return age() > 18;
    }
    public static boolean isOver18(PersonRecord personRecord) {
        return personRecord.age() > 18;
    }
}
```
Records can have multiple constructors. It’s also worth noting that if you specify a custom constructor within the record, it must call the default constructor. The record would otherwise be unsure what to do with its values:

```java
public record PersonRecord(String name, Integer age) {    
    public PersonRecord() {
        this("Name", 18);
    }
}
```
It’s acceptable if your constructor is the same as the default, as long as you also initialize all of the record’s fields:

```java
public record PersonRecord(String name, Integer age) {
    // Will replace the default constructor
    public PersonRecord(String name, Integer age) {
        this.name = name;
        this.age = age; 
    }
}
```
Records are not a huge change, but they may be quite beneficial in the appropriate circumstances. I haven’t covered everything, but this should give you a good idea of what they’re capable of.



<h3>Pattern Matching [Java 16]</h3>

Pattern matching is a means to eliminate needless casting after an instanceof condition is met.

We're all familiar with this situation:

```java
public class PatternMatching {
    public static void main(String[] args) {
        Animal animal = new Cat();
        if (animal instanceof Cat) {
            System.out.println(((Cat) animal).meow());
        }
    }
}
```
That being written, there is no doubt that the animal on the second line is a Cat — the instanceof has already confirmed this. With pattern matching, a little adjustment can be made:

```java
if (animal instanceof Cat cat) {
    System.out.println(cat.meow());
}
```
The compiler now handles all of the details of casting the object. It may appear little, but it reduces a lot of boilerplate code.

This also works when you enter a conditional branch when the type of the object is obvious:

```java
if (!(animal instanceof Cat cat)) {
    System.out.println("This isn't a cat!");
} else {
    System.out.println(cat.meow());
}
```
Pattern matching can even be used on the same line as the instanceof itself:

```java
public static boolean isCat(Object animal) {
    return animal instanceof Cat cat && cat.meow().equals("meow");
}
```
Thus, pattern matching provides an effective solution to a common problem of code noise.



<h3>Switch Expressions [Java 14]</h3>
This language feature adds the ability to switch depending on type, analogous to the syntax given by pattern matching for instanceof.

Previously, if you wanted to perform various things depending on an object’s dynamic type, you had to create an if — else if chain using instanceof checks, such as:

```java
public class SwitchExpression {
    private static String ifElseIfSwitch(Object o) {
        if (o instanceof Cat) {
            return "This is a cat";
        } else if (o instanceof Dog) {
            return "This is a dog";
        } else {
            return "This is some other animal";
        }
    }
}
```
Or switch cases:

```java
private static String legacySwitch(Object o) {
    switch (o) {
        case Cat:
            return "This is a cat";
            break;
        case Dog:
            return "This is a dog";
            break;
        default:
            return "This is some other animal";
            break;
    }
}
```
They are extremely prone to human mistake. Switch expressions solve this problem in a nice way by allowing you to just comma separate all of the values in the same block.

The above example may be simplified to the following:

```java
private static String modernSwitch(Object o) {
    return switch (o) {
        case Cat cat -> "This is a cat";
        case Dog dog -> "This is a dog";
        default -> "This is some other animal";
    };
}
```
As you may have observed, the check also includes a variable declaration, which, like pattern matching for instanceof, indicates that the object has been type checked, cast, and is now available from that variable inside its scope.

They also added a special case of null, so you don’t have to check for null any longer.

The new yield keyword is also a significant feature. If one of your cases goes into a block of code, yield is used as the switch expression’s return statement. For instance, consider the above code block, which has been slightly modified:

```java
String whichAnimal = switch (o) {
    case Cat cat -> "This is a cat";
    case Dog dog -> "This is a dog";
    default -> {
        System.out.println("This is some other animal");
        yield "Unknown animal";
    }
};
```
In the default case, the System.out.println() method will be executed, and the whichAnimal variable will still end up being "Unknown animal", because that's what the yield expression returns.

Switch Expressions are, in general, cleaner, more concise switch statements. However, they do not take the place of switch statements, and both are still accessible.



<h3>Helpful Null Pointers [Java 14]</h3>

Helpful null pointers are certainly a good addition to the language. They make null pointer exceptions (NPEs) easier to understand by publishing the name of the call that threw the exception, as well as the name of the null variable.

For example, if you called person.getAge() and the age parameter was undefined:

```java
public class NullPointer {
    public static void main(String[] args) {
        Person ani = new Person("Ani", "Talakhadze", null);
        int i = ani.getAge().compareTo(23);
        System.out.println(i);
    }
}
```
The stack trace for the error would state that getAge() failed because the age parameter was null:

```
Exception in thread "main" java.lang.NullPointerException: Cannot invoke "java.lang.Integer.compareTo(java.lang.Integer)" because the return value of "nullPointers.Person.getAge()" is null
 at nullPointers.NullPointer.main(NullPointer.java:6)
Process finished with exit code 1
```

NPEs are very common, and while most of the time it’s easy to figure out what is to blame, every now and then you get a situation when two or three variables are at play. Nowe you have everything you need to resolve the problem as soon as the error occurs.



<h3>Text Blocks [Java 15]</h3>

Text blocks are a way to make composing multi-line strings easier by allowing new lines to be interpreted and indentation to be maintained without the need of escape characters. This value is still a String, but it includes new lines and tabs.

To make a text block, simply use the following syntax:

```java
package textBlocks;
public class TextBlock {
    public static void main(String[] args) {
        String text = """
                Hello
                World!
                -----
                Hello
                World!
                """;
        System.out.println(text);
    }
}
```
*Output after running TextBlock*
![Sample Output 1](https://storage.googleapis.com/
anita-website-cdn/1_SbfQU5lkPeyHXFwzLzP6JA.png)

Similarly, you don’t require any escape characters if you wish to use quotes. This program will run without any complaints:

```java
String text = """
        Hello
        World!
        -----
        "Hello"
        "World!"
        """;
```
*Output after running TextBlock*
![Sample Output 2](https://storage.googleapis.com/anita-website-cdn/2_iRLQbkbmgpOKZHdPWBUGEg.png)

Aside from that, you can use the String’s format() function to format what you’ve typed, allowing you to quickly alter data inside text blocks with dynamic values:

```java
String name = "Ani";
String text = String.format("""
        Hello
        World!
        -----
        My name is %s.
        """, name);
```
*Output after running TextBlock*
![Sample Output 2](https://storage.googleapis.com/anita-website-cdn/3_iRLQbkbmgpOKZHdPWBUGEg.png)

Text Blocks make it significantly easier to paste bits of code into strings, in addition to being able to visibly bake in the formatting for a huge block of words. Because indentation is kept, you could create a block of HTML or Python, or any other language for that matter, and just wrap it in ”””. Text Blocks may also be used to create JSON, and the format() function can be used to simply fill in data.



***

Moving to Java 17 sooner rather than later is usually the best option as it the future reduces migration expenses. You will also benefit from all the advancements made in recent years, including increased support for operating in containers and new low-latency garbage collector implementations.

Even if you have no intentions to migrate from previous versions to this one, it’s always a good idea to stay up with the new features being developed into the language.

Of course, these aren’t the only changes from Java 12 to Java 17, but they’re the ones that caught my eye. If your top features list differs from mine, please share it with me.

Stay tuned and don’t miss the following blogs!
