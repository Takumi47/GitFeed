# GitFeed (Swift)

![https://img.shields.io/badge/iOS-14.0%2B-blue.svg](https://img.shields.io/badge/iOS-14.0%2B-blue.svg)

This repository contains resources for the GitFeed (Swift) project.

# Overview

GitFeed is a project that list GitHub users in the order they signed up on GitHub. Furthermore, it can show the publicly available information about selected user. This specific implementation is written exclusively in **Swift**, and follows **MVVM + RxSwift** architecture.

# Demo

![Demo](./Demo/demo.gif)

# Features

The project will feature two different information via GitHub API.

- The main page is about reaching out to GitHub’s JSON API, receiving the JSON response, and ultimately converting it into a collection of objects. List fetching information as below:

![page1](./Demo/page1.png)

- The second page uses the endpoint that comes from the username (login) retrieved from the main page.

![page2](./Demo/page2.png)
