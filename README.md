## To get the project running

1) brew install / apt-get install redis
2) Install Ruby; either the version specified in .ruby-version or downgrade if needed
3) gem install bundler
4) bundle install
5) bundle exec rails s

## Endpoints

- GET /devices/:uuid/latest_timestamp
- GET /devices/:uuid/cumulative_count
- POST /devices/readings
  - body should be json, as provided in the task. Example:
  ```
  {
    "id": "36d5658a-6908-479e-887e-a949ec199272",
    "readings": [
      {
        "timestamp": "2021-09-29T16:08:15+01:00",
        "count": 2
      },
      {
        "timestamp": "2021-09-29T16:09:15+01:00",
        "count": 15
      }
    ]
  }

## Thought Process

So I'm mostly familiar with Ruby, so my language decision was pretty easy. However my first big decision in this project was the framework. I seriously considered using Sinatra over Rails, thinking it was lighter weight and might work for a simple API like this, but chose Rails for a few reasons:

1) I know <yourcompany> uses Rails, so wanted to pick a framework I know you all likely know.
2) With the 2 hour time limit, Rails gets me up and running the quickest.
3) Sinatra may work with the current requirements, but without knowing how it'll grow, Rails may be a better long term solution.

So in the end I went with Rails. I did use the API only version though, as there didn't seem to be a need for ActionView or any of the session middleware. I also created the project with the `--skip-active-record` flag as one of the requirements was to use in-memory storage. These are both assumptions, and if there was eventual plans for a UI or SQL storage, I could've easily forgone including either of these flags.

That brings me to my next decision, how was I going to handle storing the data? Sqlite ships with Rails and has an in-memory storage option, but I'm less famliar with it. I could dive into how to configure it to work that way, but with the time limit I opted for another solution. Rails also ships with a default cache, but to my knowledge it won't persist between runs. Assuming this data needs to be persistent, this wouldn't work. There may be a way to configure this to be persistent? But again, with the time limit I'm going to run with the option I'm most familiar with: Redis. In addition to being persistent across runs, it also supports sorted sets which are going to help with returning the latest (or earliest, etc) timestamp.

With the plan down, I started actually working on the code itself.

## Solution Explanation

There are two models, one for readings and one for devices. The device is pretty straightforward, but I created the readings one as a struct instead of a class. This way we can just pass in the data that was sent in through the POST and create Readings based on that. From there we're able to perform the handful of methods we need to on them.

The devices controller handles both of the requested GET endpoints. The POST for saving readings however I sent to the readings controller as an attempt to adhere to the single responsibility principle.

I used Rspec for testing as again, that's what I was most familiar with. As mentioned in the next section though, ideally I would've liked to expand on this more.

I went ahead and used the latest and greatest Ruby and Rails versions because why not I guess. But I didn't do anything too crazy, so you can likely change the versions to an installed version without much of an issue.

## Things I'd like to do with more time

- Write tests for the controllers, and write some more tests for the models. For example, one for duplicate POSTS for readings.
- Create more validation and error handling throughout the controllers.
- Remove unused routes (defaults like index and delete routes for example)
- Remove unused gems.

## Summary

I think all in all I took just over two hours for all the code. Part of why I love Rails is how quick you can get up and running to have a working project. Create a new project, add the Redis gem, and from there its as simple as creating a couple resources.
