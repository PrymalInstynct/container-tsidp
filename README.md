# container-tsidp
Container Image for the Tailscale [tsidp](https://github.com/tailscale/tailscale/tree/main/cmd/tsidp) OpenID Connect Server application

## Environment Variables
| Variable               | Value         | Note                                                                                                     |
|------------------------|---------------|----------------------------------------------------------------------------------------------------------|
| HOME                   | .             | Required to get tsidp to create the statefiles in the correct location                                   |
| TS_AUTHKEY             |               | Set this Environment Variable via `compose.yml`                                                          |
| TS_HOSTNAME            | tsidp         | Hostname for the instance of `tsidp` <br> (Bug causing this variable to not be utilized when app starts) |
| TS_STATE_DIR           | /config/tsidp | Location of the tailscale statefiles and logs                                                            |
| TS_USERSPACE           | false         | Disables userspace networking                                                                            |
| TAILSCALE_USE_WIP_CODE | 1             | Required to have Tailscale accept running Work In Progress code                                          |
