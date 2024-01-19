GitHub Badges (DISCONTINUED)
===============

> This project has unfortunately been discontinued once Heroku's [Free Plans had expired](https://help.heroku.com/RSBRUH58/removal-of-heroku-free-product-plans-faq).

# Using the buttons
```
GET http://githubbadges.com
                          /star.svg
                          /fork.svg
```
## Available Parameters
```
`user` :  The owner of the GitHub repository
`repo` :  The repository name
`[background]` :  Controls the background color of the count
   - Format is HEX, **without** `#`.  Example:  `&background=007ec6`
`[color]` :  Controls the text color. (default to `fff`)
   - Format is HEX, **without** `#`.  Example:  `&color=000`
`[style]` :  Controls the style of the button
   Options:
    - `default` :  The default 'bubble' style
    - `flat` :  A flat style
    - `flat-square` :  A flat style with no border-radius
```

### Example request
[http://githubbadges.com/star.svg?user=ddavison&repo=github-badges&background=007ecg&color=bbb&style=flat](http://githubbadges.com/star.svg?user=ddavison&repo=github-badges&background=007ecg&color=bbb&style=flat)

Github SVG Buttons will automatically fetch how many stars and forks there are.


### Develop

- `bundle install`
- `bundle exec ruby app.rb`
- Server should now be running at http://localhost:4567/
