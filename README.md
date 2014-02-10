# [MapVotes](http://mapvotes.crimsontautology.com/)
[![Build Status](https://travis-ci.org/CrimsonTautology/map_votes.png?branch=master)](https://travis-ci.org/CrimsonTautology/map_votes)

A web-interface to rate, index and bookmark maps for a TF2 gameserver.

## Requirements
* Ruby 1.9
* A [Steam Web API Key](http://steamcommunity.com/dev)
* [postgresql](http://www.postgresql.org/)
* A game server running [Sourcemod](http://www.sourcemod.net) and the [sm_map_votes](https://github.com/CrimsonTautology/sm_map_votes) plugin.

## Installation
* Make sure you have the requirements
* Review the `config` directory
* Add your steam api key to your system's enviornment: `STEAM_API_KEY=[your api key]`
* If you have a public fast download server you can seed the database with all maps in it by setting this enviornment variable: `FAST_DL_SITE=[your fast map download url here]`
* Setup your database config in `config/database.yml`
* Install bundler and all required gems: `gem install bundler && bundle`
* Initalize your database with: `rake db:setup`
* Start the webserver: `thin start`
