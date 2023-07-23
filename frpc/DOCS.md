# Add-on: FRPc-Server
Adapted to [Frp by Fatedier][frp-fatedier]
Forked by [@hannpet]

## Important:
Edit your ***config/configuration.yaml***
```
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 127.0.0.1    <<<<< Add this!!
``````      

### Options: 

| Parameter     | Example                   |
| ------------- |---------------------------|
| `server_addr` | fe80::8061:f878:73c7:cce2 |
| `server_port` | 5000                      |
| `token_key`   | efu90effoej               |
| `local_port`  | 8123                      |