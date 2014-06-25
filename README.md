CICD-Infrastructure Cookbook
============================
TODO: Enter the cookbook description here.

e.g.
This cookbook makes your favorite breakfast sandwich.

Requirements
------------
TODO: List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.

e.g.
#### packages
- `toaster` - cicd-infrastructure needs toaster to brown your bagel.

Attributes
----------
TODO: List your cookbook attributes here.

e.g.
#### cicd-infrastructure::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['cicd-infrastructure']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### cicd-infrastructure::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `cicd-infrastructure` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[cicd-infrastructure]"
  ]
}
```

Develop
-------
- Setup rbenv/rvm to use ruby 1.9.3 by default
- Run `bundle install` to get all dependences
- To verify syntax and code style run `bundle exec rake`
- To get all cookbook dependences run `bundle exec berks install`
- To get local copy of Berkshelf repo run `berks vendor cookbooks`
- To setup dev installation of cookbook run `vagrant up`

To get more Vargant images look at [bento](https://github.com/opscode/bento)


License and Authors
-------------------
Authors: TODO: List authors
