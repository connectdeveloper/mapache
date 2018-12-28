Project mapache

Requirements for this project can be found on
requirements.md

The access tokens are already setup in the contentful.coffee file
- access_token: '70f84814804d4e47f47f945e2c2257cf2e251514bf9081c455b0027098512c6e'
- management_token: '70f84814804d4e47f47f945e2c2257cf2e251514bf9081c455b0027098512c6e'
- space_id: '5pyzqupsur8u'

Setup
-----

- make sure [node.js](http://nodejs.org) and [roots](http://roots.cx) are installed
- clone this repo down and `cd` into the folder
- run `npm install`
- run `roots watch`
- ???
- get money


Deployment
----------

This site is hosted at Netlify.

Run `make deploy` to deploy the site. This command is a shortcut for compiling the site with roots and deploying using [ship](https://github.com/carrot/ship). See the [Makefile](Makefile) for more info.
