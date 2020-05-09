# Neptune Networks Peering Config

This is the pipeline to build Neptune Networks' BGP peering configuration. Neptune uses BIRD `2.0.7` on all of its core customer routers and border routers. We rely on this pipeline to take templates and YAML and turn them into a BIRD configuration.

To get started, take a look at the yaml in `config/`. The yaml files in that directory go through a transformation step and eventually turn into `/out/<router>/bird.conf` files for each router, as well as `/out/<router>/peers.conf` files for their respective peerings. Generation steps can be seen at the bottom of this README.

## BGP Community Support

Because our ASN is 32 bits, and because we value the ability to add more information, we use [BGP large communities](http://largebgpcommunities.net/). They are inspired by [RFC8195](https://tools.ietf.org/html/rfc8195).

### Informational

Informational BGP communities offer insight into Neptune's routing policies.

#### Origin

| Community | Description |
| --------- | ----------- |
| `397143:101:1` | Originated by Neptune Networks (AS397143) |
| `397143:101:2` | Learned from IX |
| `397143:101:3` | Learned from private peer |
| `397143:101:4` | Learned from transit provider |
| `397143:101:5` | Learned from customer |

#### Region

Octets in the function field are the numeric country identifier defined by ISO 3166-1.

| Community | Description |
| --------- | ----------- |
| `397143:102:840` | Learned in U.S. |

#### Site

| Community | Description |
| --------- | ----------- |
| `397143:103:1` | Learned at NY1 |

### Actionable

BGP communities which manipulate the routing policy.

#### Prepends

| Community | Description |
| --------- | ----------- |
| `397143:900:1` | Prepend `397143` once on export to all AS's |
| `397143:900:2` | Prepend `397143` twice on export to all AS's |
| `397143:900:3` | Prepend `397143` thrice on export to all AS's |
| `397143:991:xxxxx` | Prepend `397143` once on export to AS `xxxxx` |
| `397143:992:xxxxx` | Prepend `397143` once on export to AS `xxxxx` |
| `397143:993:xxxxx` | Prepend `397143` once on export to AS `xxxxx` |

#### NO_EXPORT

| Community | Description |
| --------- | ----------- |
| `397143:600:xxxxx` | Do not export to AS `xxxxx` |
| `397143:601:2` | Do not export to IX peers |
| `397143:601:3` | Do not export to private peers |
| `397143:601:4` | Do not export to transit providers |
| `397143:601:5` | Do not export to customers |
| `397143:602:840` | Do not export in U.S. |
| `397143:603:1` | Do not export in NY1 |

## Usage

Start by looking at `config/` and making any adjustments that are needed. Once you're ready, execute:

```
ruby lib/generator.rb
```

This will create a file for each of the templates in `/templates`, without the `.erb` suffix.

If you find that you need to make any adjustments to the templates, simply do so and then re-run the generator.

## Roadmap

- [ ] Community-based local pref
- [ ] PeeringDB max prefix support
- [ ] Blackhole support
