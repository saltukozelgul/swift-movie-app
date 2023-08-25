# Movie Explorer App

![iOS Version](https://img.shields.io/badge/iOS-13%2B-green.svg)
![Alamofire](https://img.shields.io/badge/Library-Alamofire-red.svg)
![Kingfisher](https://img.shields.io/badge/Library-Kingfisher-red.svg)

Movie Explorer is an iOS application that allows users to explore and discover movies. It fetches data from The Movie Database API to provide information about popular movies, search for movies, view movie details, explore cast members, and manage custom movie lists. App supports **dark and light mode** and has **localization** support

## Table of Contents
- [Introduction](#introduction)
- [Requirements](#requirements)
- [Screens](#screens)
  - [Movie List](#movie-list)
  - [Movie Search](#movie-search)
  - [Favorite Movies](#favorite-movies)
  - [Movie Detail](#movie-detail)
  - [Cast Detail](#cast-detail)
  - [Custom Lists](#custom-lists)
- [Screenshots](#screenshots)
- [Usage](#usage)
- [Libraries](#libraries)

## Introduction

The purpose of this project is to provide an opportunity for iOS developers to practice their skills by working on a real-world-like application. The Movie Explorer app allows users to browse movies, search for movies, view movie details, explore cast information, and manage custom movie lists. The app fetches movie data from The Movie Database API.

## Requirements

- Xcode (Version 12.0+)
- Swift (Version 5.0+)
- iOS 13+

## Screens

### Movie List

The Movie List screen displays a list of popular movies. Each movie element includes:

- Movie Image
- Movie Name
- Release Date
- Movie Rating
- Favorite Icon

Pagination is enabled, and tapping on a movie navigates to the Movie Detail screen.

### Movie Search

Users can search for movies using a search string. This feature can be implemented as a separate screen or embedded within the Movie List screen.

### Favorite Movies

On this screen, users can view their favorite movies and remove them from the favorites list. Clicking on a movie navigates to the Movie Detail screen.

### Movie Detail

The Movie Detail screen provides comprehensive information about a selected movie:

- Movie Image
- Movie Name
- Original Title and Language
- Release Date
- Budget
- Revenue
- Genres
- Overview
- Runtime
- Production Companies
- Homepage Link
- Recommendations (Horizontal Scrollable List)

Users can mark a movie as a favorite and store it locally. The screen also lists the cast members (actors only) with:

- Actor Name
- Character Name
- Actor Image

### Cast Detail

The Cast Detail screen offers detailed information about a cast member:

- Actor Name
- Actor Image
- Biography
- Birthday and Deathday (if available)
- Place of Birth

### Custom Lists

A new feature in the Movie Explorer app is the ability to create custom movie lists. Users can create infinite custom lists, each with a unique name. This feature allows users to organize movies based on their preferences.

## Screenshots

Here are some screenshots from the Movie Explorer app:

<div style="display: flex; justify-content: space-around; flex-wrap: wrap; margin: 20px 0;">
  <img src="/previews/main-screen.png" alt="Screenshot 1" style="width: 23%; max-width: 300px;">
  <img src="/previews/detail-screen-1.png" alt="Screenshot 2" style="width: 23%; max-width: 300px;">
  <img src="/previews/detail-screen-2.png" alt="Screenshot 3" style="width: 23%; max-width: 300px;">
  <img src="/previews/cast-screen.png" alt="Screenshot 4" style="width: 23%; max-width: 300px;">
  <img src="/previews/custom-list-screen.png" alt="Screenshot 5" style="width: 23%; max-width: 300px;">
  <img src="/previews/discover-screen.png" alt="Screenshot 6" style="width: 23%; max-width: 300px;">
</div>

## Usage

1. Clone the repository.
2. Open the Xcode project.
3. Build and run the app on a simulator or a physical device.

## Libraries

The Movie Explorer app utilizes the following libraries:

- [Alamofire](https://github.com/Alamofire/Alamofire) for network requests
- [Kingfisher](https://github.com/onevcat/Kingfisher) for image loading and caching

