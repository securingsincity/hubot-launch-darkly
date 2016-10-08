# hubot-launch-darkly

A hubot script that integrates with launch darkly

See [`src/launch-darkly.coffee`](src/launch-darkly.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-launch-darkly --save`

Then add **hubot-launch-darkly** to your `external-scripts.json`:

```json
[
  "hubot-launch-darkly"
]
```

## Sample Interaction

```
user1>> launchdarkly list default
hubot>> Your New Feature - production: true
```

## NPM Module

https://www.npmjs.com/package/hubot-launch-darkly
