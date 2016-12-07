# Y.A.M.A.

Yet Another Malware Analyzer

## INSTALL 

Requirements: Debian / Ubuntu based server

- clone the repo and install puppet client

```
apt-get install git
git clone http://github.com/vitovitolo/yama
apt-get install puppet 
```

You have different install methods:

### yama node

This will install only the yama web server

```
puppet apply --modulepath puppet/modules/ puppet/manifests/yama.pp
```

### external load balancer

Install HAProxy load balancer with two yama servers configured
```
puppet apply --modulepath puppet/modules/ puppet/manifests/load_balancer.pp
```


DESIGN
===

[Read the sholw design](docs/design.md)
