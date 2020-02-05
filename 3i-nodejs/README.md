# 3i-nodejs-cookbook

3i-nodejs - a wrapper nodejs cookbook to run recipes from the nodejs
cookbook on the supermarket configured how third iron wants it
configured

(I had to adjust the repo attribute to get it to install nodejs 4.x)

## Supported Platforms

See https://github.com/redguide/nodejs

## Attributes

This cookbook adjusts default['nodejs']['repo'] to be the nodesource
repo that serves nodejs 4.x

For other available attributes see https://github.com/redguide/nodejs

## Usage

### 3i-nodejs::default

Include `3i-nodejs` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[3i-nodejs::default]"
  ]
}
```

## License and Authors

Author:: Mike Lang (mike@thirdiron.com)

## Suggested Things left to do
- Pin nodejs version
- Convert node['keystore']* to SSM values in AWS
