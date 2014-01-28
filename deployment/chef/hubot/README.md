hubot Cookbook
==============
Installs and configures Hubot and its dependencies

Attributes
----------
TODO: List you cookbook attributes here.

e.g.
#### hubot::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['hubot']['campfire_account']</tt></td>
    <td>String</td>
    <td>hubot campfire account</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['hubot']['campfire_rooms']</tt></td>
    <td>String</td>
    <td>hubot campfire rooms</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['hubot']['campfire_token']</tt></td>
    <td>String</td>
    <td>hubot campfire token</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['hubot']['irc_server']</tt></td>
    <td>String</td>
    <td>hubot irc server</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['hubot']['irc_rooms']</tt></td>
    <td>String</td>
    <td>hubot irc rooms</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['hubot']['bot_name']</tt></td>
    <td>String</td>
    <td>hubot bot name</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['hubot']['bot_adapter']</tt></td>
    <td>String</td>
    <td>hubot bot apdapter</td>
    <td><tt></tt></td>
  </tr>
</table>

Usage
-----
Just include `hubot` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[hubot]"
  ]
}
```

License and Authors
-------------------
Authors: Matthew Hutchinson
