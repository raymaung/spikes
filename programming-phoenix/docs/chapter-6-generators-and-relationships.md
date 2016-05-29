## Chapter 6 Generators and Relationships

### Generating Resources

* `phoenix.gen.html` scaffold HTML pages
* `phoenix.gen.json` scaffold REST-based API using JSON

```ruby
$ mix phoenix.gen.html Video videos user_id:references:users \url:string title:string description:text
```

* `Video` = module name
* `videos` pural form of the model name
* Each fields
* Require adding `resources "/videos", VideoController"` to `router.ex` manually

* Phoenix consistently use **singular** forms in *models*, *controllers* and *views*
* In application boundaries, ie. URLs and Table names, uses puralized names

* `scrub_params` plug in generated video controller
    * checks and transforms any empty string into nil for any data inside the video parameter

    
### Generated Migrations

* `priv/repo/migrations` migration scripts