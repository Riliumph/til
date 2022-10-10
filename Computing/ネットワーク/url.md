# URL

```js
/*
                                                           href
                   ┌────────────────────────────────────────┴──────────────────────────────────────────────┐
                origin                                                                                     │
      ┌────────────┴──────────────┐                                                                        │
      │                       authority                                                                    │
      │           ┌───────────────┴───────────────────────────┐                                            │
      │           │                                         host                                       resource
      │           │                                ┌──────────┴─────────────────┐             ┌────────────┴───────────┬───────┐
      │           │                             hostname                        │          pathname                    │       │
      │           │                 ┌──────────────┴────────────┐               │      ┌──────┴───────┐                │       │
  protocol     userinfo         subdomain                    domain             │      │           filename            │       │
   ┌─┴──┐     ┌───┴────┐            │                  ┌────────┴───────┐       │      │          ┌───┴─────┐          │       │
scheme  │username password lowerleveldomains secondleveldomain topleveldomain port  dirname    basename extension    search   hash
┌──┴───┐│┌──┴───┐ ┌──┴───┐ ┌──┬─┬─┴─────┬───┐┌───────┴───────┐ ┌──────┴──────┐┌─┴┐┌────┴──────┐┌──┴───┐ ┌───┴───┐ ┌────┴────┐ ┌┴┐
│      │││      │ │      │ │  │ │       │   ││               │ │             ││  ││           ││      │ │       │ │         │ │ │
scheme://username:password@test.abcdedgh.www.secondleveldomain.topleveldomain:1234/hello/world/basename.extension?name=ferret#hash
*/
 ```
