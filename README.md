[![Crystal CI](https://github.com/Raelr/crlox/actions/workflows/crystal.yml/badge.svg)](https://github.com/Raelr/crlox/actions/workflows/crystal.yml)

# crlox

An implementation of the `lox` interpreter in `crystal`. 

## Summary

crlox is an attempt to re-implement `jlox`, a programming language designed and implemented by Robert Nystrom. This repository follows Nystrom's amazing book: [`crafting compilers`](https://craftinginterpreters.com/), and re-interprets their `java` compiler into `crystal`. This repository is entirely experimental is expected to be a means to learn the basics of compilers and interpreters. 

## Setup

Setting the project up is quite simple. 

1. Make sure you have `crystal` installed. If not, follow the steps on the [official crystal website!](https://crystal-lang.org/reference/getting_started/index.html). 
2. Clone the repository:
  ```
  $ git clone https://github.com/Raelr/crlox.git 
  ```
3. In the project's root folder, run the following:
  ```
  $ shards init
  $ shards install
  ```
4. Once complete, run the compiler using the following:
  ```
  $ crystal run src/crlox.cr -- "assets/test.lox"
  ```
  You can also write you own `Lox` code and pass in the file's location. We just provided a sample file for your convenience. 
  
  The project can also be tested using:
  ```
  $ crystal spec
  ```

