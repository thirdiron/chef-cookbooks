# herald_conf-cookbook

Performs any necessary configuration of a machine to be a suitable
host for the article herald.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['herald_conf']['ssl_private_key']</tt></td>
    <td>String</td>
    <td>Textual contents of .pem key file to deploy to support SSL</td>
    <td></td>
  </tr>
  <tr>
    <td><tt>['hreald_conf']['ssl_cert']</tt></td>
    <td>String</td>
    <td>Textual contents of .pem certificate chain to deploy to support
SSL</td>
    <td></td>
  </tr>
</table>

## Usage

### herald_conf::default

Include `herald_conf` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[herald_conf::default]"
  ]
}
```

## License and Authors

Author:: Mike Lang (<mike@thirdiron.com>)
