# Haade Add-on: FRPc
Adapted to [Frp by Fatedier][frp-fatedier]

## What is FRPc
frp is a fast reverse proxy to help you expose a local server behind a NAT or firewall to the Internet. As of now, it supports **HTTP and HTTPS** protocols, where requests can be forwarded to internal services by domain name.

With frpc it is now **easy to connect from the outside without touching various parameters of your box**, you will still need a server with fixed ip in order to be able to integrate the FRPs folder, then you can connect directly to homeassistant via the 'ip address of the server or with a subdomain redirected to this server. 

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed.

for http service:

```yaml
log_level: trace to fatal logs
server_addr: // ip of frp server
server_port: // port of frp server 7000
frp_type: // http
custom_name: // name of you're connection http
token_key: // key token for secure connection to server
local_ip: // ip of you're local hassio install by default is 127.0.0.1
local_port: // by default 8123
use_encryption: // false or true, true by default
use_compression: // false or true, true by default
balancing_group: // only available for type http and http2https to port 80 will be dispatched to proxies in the same group randomly.
balancing_group_key: // key of secure balancing_group
domain_protocol: // domain or subdomain frp server
domains: // setting you're domains or subdomains example test.haade.fr or test
```
for https service

```yaml
server_addr: // ip of vps
server_port: // by default 7000
custom_name: // name of you're connection https
token_key: // key token for secure connection to server
frp_type: // https
local_ip: // ip of you're local hassio install by default is 127.0.0.1
local_port: // by default 8123
use_encryption: // false or true, true by default
use_compression: // false or true, true by default
proxy_protocol_version: // v1 or v2, v2 by default and best
domain_protocol: // domain or subdomain frp server
domains: // setting you're domains or subdomains example test.haade.fr or test
```
for http2https service ( http frp client to https frp server )

```yaml
log_level: trace to fatal logs
server_addr: // ip of frp server
server_port: // port of frp server 7000
frp_type: // http2https
custom_name: // name of you're connection http
token_key: // key token for secure connection to server
local_ip: // ip of you're local hassio install by default is 127.0.0.1
local_port: // by default 8123
use_encryption: // false or true, true by default
use_compression: // false or true, true by default
balancing_group: // only available for type http and http2https to port 80 will be dispatched to proxies in the same group randomly.
balancing_group_key: // key of secure balancing_group
domain_protocol: // domain or subdomain frp server
domains: // setting you're domains or subdomains example test.haade.fr or test
```

### Option: `type`

- `tcp`: partially adapted
- `http`: full adapted to connect to webhost simply and fast but not secure
- `https`: full adapted to connect secure mode but difficult
- `http2https` : full adapted to connect to frp server with key https

[frp-fatedier]: https://github.com/fatedier/frp
