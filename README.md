# Project 2 - *Flix*

**Flix** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **approx. 15** hours spent in total

## User Stories

The following **required** functionality is complete:

- [X] User can view a list of movies currently playing in theaters from The Movie Database.
- [X] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [X] User sees a loading state while waiting for the movies API.
- [X] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [X] User sees an error message when there's a networking error.
    -This happens both when the user reloads manually or if there is an error in the initial loading on startup.
- [X] Movies are displayed using a CollectionView instead of [EDIT: in addition to, via tab bar] a TableView.
        - Added refresh control to collection view
- [X] User can search for a movie.
    -This functionality is included in both the table view and collection view. The search bar is above the view so it remains visible and accessible when the user scrolls down.
- [X] All images fade in as they are loading.
- [X] User can view the large movie poster by tapping on a cell.
    -The cells in the collection view, when tapped, load the detail view which includes the large movie poster.
- [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [X] Customize the selection effect of the cell.
    -Yellow when the user selects, back to clear when the user returns
- [X] Customize the navigation bar.
    - The navigation bar has the title "Movies" in dark green with a shadow.
- [ ] Customize the UI.

The following **additional** features are implemented:

- [X] List anything else that you can get done to improve the app functionality!
    -Customize the tab bar
    -"Now Playing" has the now playing image, the "View Grid" option is now named "View Grid" and has a projector image. The bar is a pale yellow color.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Making the text not go off the screen (e.g. not hidden by tab bar)
2. Lots of code seems reused between the view controllers. I'd like to discuss ways to make that cleaner and more efficient.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://g.recordit.co/R0dpSXWeFP.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [Recordit](http://recordit.co/).

## Notes

Implementing the search bar, especially in the collection view, was very difficult.

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.
- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- CodePath Guides

## License

    Copyright 2019 Ilana Shapiro

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
