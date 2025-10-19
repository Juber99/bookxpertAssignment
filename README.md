# bookxpertAssignment

Reader is an iOS app that fetches and displays the latest news articles from a public API (like NewsAPI.org
).
It supports offline viewing, search, bookmarks, and pull-to-refresh — built using UIKit + Core Data + Clean MVVM Architecture.

Feature	Description
1 Fetch Articles	Fetch top news using REST API (URLSession / APIService).
2 Offline Caching	Articles stored in Core Data for offline use.
3 Pull-to-Refresh	Update articles manually using UIRefreshControl.
4 Search	Search articles by title.
5 Bookmark Articles	Bookmark and manage saved articles.
6 Dark Mode	Fully supports light & dark appearance.
7 Support Landscape and Portrait Mode

 Architecture

Pattern Used: Clean MVVM (Model-View-ViewModel)
Persistence: Core Data (local SQLite store)
Networking: URLSession (can be replaced with Alamofire if needed)

+------------------------+
|        View            |
|  (UIKit Storyboard)    |
+-----------+------------+
            |
            v
+------------------------+
|      ViewModel         |
|  Handles UI logic,     |
|  data binding, and     |
|  repository calls.     |
+-----------+------------+
            |
            v
+------------------------+
|      Repository        |
|  Manages API + CoreData|
|  sync & caching logic. |
+-----------+------------+
            |
            v
+------------------------+
|     Data Layer         |
|  APIService / CoreData |
+------------------------+

Project Flow
1. App Launch

The app launches and loads saved articles from Core Data.

Simultaneously, it fetches the latest articles from the API.

2. Article List Screen

Displays article title, author, and thumbnail.

Supports pull-to-refresh and search.

3. Article details
   
on tap on article open article details screen

Displays - image, title, date, description, bookmark button, link button

4. Bookmarks Screen

Shows saved (bookmarked) articles.

Data fetched from Core Data (CDBookmarkArticle entity).

5. Offline Mode

If API fetch fails, cached articles are displayed.

6. Bookmark Logic

Tap the bookmark icon → article saved or removed from Core Data.

On relaunch, bookmarks persist from Core Data storage.

7. Unit tests are implemented for:

ArticleRepository (fetch, save, bookmark logic)

CoreData in-memory persistence

Build and run the app:

Minimum iOS Version: iOS 26

Xcode Version: Xcode 26 or later

