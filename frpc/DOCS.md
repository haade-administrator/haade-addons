# Haade Add-on: FRPc
Adapted to [Frp by Fatedier][frp-fatedier]

## What is FRPc
frp is a fast reverse proxy to help you expose a local server behind a NAT or firewall to the Internet. As of now, it supports **HTTP and HTTPS** protocols, where requests can be forwarded to internal services by domain name.

With frpc it is now **easy to connect from the outside without touching various parameters of your box**, you will still need a server with fixed ip in order to be able to integrate the FRPs folder, then you can connect directly to homeassistant via the 'ip address of the server or with a subdomain redirected to this server. 

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed.

for http service:

```yaml
server_addr: // ip of vps
server_port: // by default 7000
http_name: // name of you're connection http
token_key: // key token
type: // http or https
local_port: // by default 8123
balancing_group: // load balancing for optimize
balancing_group_key: // key of secure balancing_group
custom_domains: // setting you're domains
```
for https service

```yaml
server_addr: // ip of vps
server_port: // by default 7000
custom_name: // name of you're connection http
token_key: // key token
type: // https
local_ip: // 127.0.0.1:8123
local_port: // by default 8123
rssh: // 127.0.0.1
balancing_group: // load balancing for optimize
balancing_group_key: // key of secure balancing_group
custom_domains: // setting you're domains

### Option: `type`

- `tcp`: partially adapted
- `http`: full adapted to connect to webhost
- `https`: next release

[frp-fatedier]: https://github.com/fatedier/frp
