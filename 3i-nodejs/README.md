# 3i-nodejs-cookbook

3i-nodejs - a wrapper nodejs cookbook to run recipes from the nodejs
cookbook on the supermarket configured how third iron wants it
configured

(I had to adjust the repo attribute to get it to install nodejs 4.x)

## Supported Platforms

TODO: List your supported platforms.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['3i-nodejs']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

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

Author:: YOUR_NAME (<YOUR_EMAIL>)
