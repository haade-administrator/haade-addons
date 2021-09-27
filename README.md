<div align="center">
<img src="images/logo.png">
<h1>Home Assistant Add-on:</h1>
<ol style="display:align-center">
<li>Frpc client</li>
<li>Teleinfo2mqtt</li>
</ol>

[![GitHub release](https://img.shields.io/github/tag/fatedier/frp.svg?label=release-fatedier)](https://github.com/fatedier/frp/releases)
[![GitHub release](https://img.shields.io/github/tag/haade-administrator/haade-addons.svg?label=release-frpc)](https://github.com/haade-administrator/haade-addons/releases)
[![GitHub release](https://img.shields.io/github/tag/fmartinou/teleinfo-mqtt.svg?label=release-fmartinou)](https://github.com/fmartinou/teleinfo-mqtt/releases)

<br>
<p>Run <a href="https://github.com/fatedier/frp">frp client</a> as a Home Assistant Add-on</p>
<p>Run <a href="https://github.com/fmartinou/teleinfo-mqtt">teleinfo client</a> as a Home Assistant Add-on</p>
</div>

## Installation

Add the repository URL under **Supervisor → Add-on store → ⋮ → Manage add-on repositories**:

    https://github.com/haade-administrator/haade-addons
    
The repository includes one add-ons for moment:

frp client is a stable release that tracks the released versions of frp.

    

## What is frp?

frp is a fast reverse proxy to help you expose a local server behind a NAT or firewall to the Internet. As of now, it supports **TCP** and **UDP**, as well as **HTTP** and **HTTPS** protocols, where requests can be forwarded to internal services by domain name, frp also has a P2P connect mode.
    

## What is teleinfo2mqtt?

Teleinfo-Mqtt allows you to read Teleinfo frames from a Serial port and publish them to an Mqtt broker.

## Addons for hassio maintained by HAADE
