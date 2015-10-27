# 3i-couchdb-cookbook

A wrapper cookbook to configure the couchdb cookbook
from the chef supermarket for the central couchdb server
holding user bookshelves and read/unread status

## Supported Platforms

See https://github.com/wohali/couchdb-cookbook

## Attributes

This cookbook overrides some default attributes to
configure our couchdb server appropriately

For a full list of possible attributes see
https://github.com/wohali/couchdb-cookbook

## Usage

### 3i-couchdb::default

Include `3i-couchdb` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[3i-couchdb::default]"
  ]
}
```

## License and Authors

Author:: Mike Lang (mike@thirdiron.com)
