# 🌍 A2SV Countries App (Flutter)

A mobile application built with **Flutter** that allows users to browse, search, and learn about countries from around the world — using the [REST Countries API](https://restcountries.com/).  

This project is part of the **A2SV Technical Interview Challenge**, demonstrating clean architecture, state management using **BLoC/Cubit**, and scalable API integration.

Figma Design Link: https://www.figma.com/design/YiJkFqLNzciiKLE2fra1Iu/Flutter-Test-Project?node-id=0-1&p=f&t=YjsRtep8udCayGrf-0


---

## 🚀 Current Progress

✅ Implemented:
- REST Countries API integration (minimal + detailed endpoints)
- Repository layer for data abstraction
- Cubit/BLoC state management for loading, success, and error states
- Model classes (`CountrySummary`, `CountryDetails`)
- Home screen displaying all countries
- Search functionality with live updates
- Detail screen fetching complete country data by `cca2` code
- Favorites screen with persistent local storage (in progress)
- Bottom navigation bar (Home & Favorites)
- Loading and empty states

🎯 Next Steps (UI phase):
- Improve UI styling according to Figma mockups
- Add shimmer/skeleton loaders
- Implement dark mode and Hero animations (optional)
- Refine Favorites persistence and icons
- Add sorting and pull-to-refresh

---

## 🧱 Architecture Overview

```plaintext
lib/
├── data/
│   ├── models/
│   │   ├── country_models.dart
│   ├── repositories/
│   │   ├── countries_repository.dart
│   ├── services/
│       ├── countries_api_service.dart
│
├── logic/
│   ├── cubits/
│       ├── countries_cubit.dart
        ├── countries_state.dart
│
├── presentation/
│   ├── screens/
│       ├── home/
│       │   ├── home_screen.dart
│       ├── detail/
│       │   ├── detail_screen.dart
│       ├── favorites/
│           ├── favorites_screen.dart
│
├── main.dart
Layers:

Services → Handle API calls using http package.

Repositories → Abstract API logic for use by Cubits.

Cubits → Manage application state (loading, success, error).

Screens → UI presentation with BlocBuilder integration.


⚙️ Setup & Installation
1️⃣ Prerequisites
Ensure you have installed:

Flutter SDK

Git

A running device/emulator

Check your Flutter setup:

bash
Copy code
flutter doctor
2️⃣ Clone the Repository
bash
Copy code
git clone https://github.com/davidmugisho/A2sv_countries_app_mobile.git
cd A2sv_countries_app_mobile
3️⃣ Install Dependencies
bash
Copy code
flutter pub get
4️⃣ Run the App
bash
Copy code
flutter run

🌐 API Endpoints Used
Purpose	Endpoint	Returned Fields
All countries	https://restcountries.com/v3.1/all?fields=name,flags,population,cca2	name, flags, population, cca2
Search by name	https://restcountries.com/v3.1/name/{name}?fields=name,flags,population,cca2	name, flags, population, cca2
Country details	https://restcountries.com/v3.1/alpha/{code}?fields=name,flags,population,capital,region,subregion,area,timezones	full details


🧠 State Management
This app uses Cubit (from flutter_bloc) for managing state:

CountriesCubit handles:

Loading all countries

Searching countries

Fetching detailed info

Managing favorites list

Each state (CountriesLoading, CountriesLoaded, CountriesError) ensures the UI updates reactively.


💾 Local Storage (Planned)
Favorites will be stored locally using:

shared_preferences
This allows persistence of favorite countries even after app restarts.


🧪 Testing (Coming Soon)
Planned test coverage for:

Repository data fetching

Cubit state transitions

UI widget tests


🧑‍💻 Author
David Mugisho
📧 https://github.com/davidmugisho
🧩 Flutter Developer | A2SV Candidate 

🏗️ Tech Stack
Layer	Technology
UI	Flutter, Material Design
State Management	flutter_bloc / Cubit
Networking	http
Local Storage	shared_preferences
Language	Dart


📜 License
This project is open-source and available under the MIT License.


---

Would you like me to add the `MIT LICENSE` file as well (so the license badge and section work correctly on GitHub)?






