# 🌦️ WeatherCast App

A modern weather forecasting application built with **SwiftUI**, providing real-time weather information, 3-day forecasts, hourly forecasts, and multi-location support.

---

## 📱 Features

### 🏠 Home Screen

The main screen is divided into three sections:

### 🔝 Top Section

Displays current weather information for the selected location:

* 📍 Current Location Name
* 🌡️ Current Temperature
* ☁️ Weather Condition Description
* 🔺 Maximum Temperature of Today
* 🔻 Minimum Temperature of Today
* 🌤️ Weather Condition Icon

### 🎨 Dynamic Theme Support

The application automatically changes its appearance based on the current time:

#### 🌅 Morning Mode (5:00 AM → 6:00 PM)

* Morning background image
* Black text color

#### 🌙 Evening Mode (6:00 PM → 5:00 AM)

* Evening background image
* White text color

---

### 📅 3-Day Forecast

Displays weather forecasts for:

* 📍 Today
* 📍 Tomorrow
* 📍 Day After Tomorrow

Each row contains:

* 📆 Day Name
* 🌤️ Weather Icon
* 🔻 Minimum Temperature
* 🔺 Maximum Temperature

---

### 📊 Weather Details

Displays additional weather information:

* 👀 Visibility
* 💧 Humidity
* 🌡️ Feels Like Temperature
* 🏔️ Pressure
* 🌬️ Wind Speed
* ☀️ UV Index

---

## ⏰ Hourly Forecast Screen

When the user taps a day from the forecast list:

➡️ The application navigates to a detailed hourly forecast screen.

The screen displays:

* 🕒 Hour
* 🌤️ Weather Icon
* 🌡️ Temperature

Starting from **Now** and continuing through the available forecast hours.

---

## 🌍 Multi-Location Support

### 🔎 Search Cities Worldwide

Search for any city around the world using the built-in search bar.

### ❤️ Save Favorite Locations

Save frequently viewed locations for quick access.

### 📍 Saved Locations

Access all saved locations from a dedicated screen.

### 🔄 Quick Navigation

Tap any saved location to instantly view its weather details.

---

## 🛠️ Technologies Used

* 📱 SwiftUI
* 🔄 MVVM Architecture
* 🌐 WeatherAPI
* 📡 URLSession
* 📍 Core Location
* 💾 SwiftData
* 🎨 Dynamic UI Themes

---

## 🏗️ Architecture

The application follows the **MVVM (Model-View-ViewModel)** architecture pattern to ensure clean code, separation of concerns, and maintainability.

---

## 🌐 Weather API

This application uses WeatherAPI to retrieve weather data.

Documentation:

https://www.weatherapi.com
