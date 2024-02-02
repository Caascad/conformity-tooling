# conformity-tooling

## Checkmetrics

usage: checkmetrics [-h] [-U RANCHER_URL] -Q QUERY [-T RANCHER_TOKEN] -S PROMETHEUS_SERVICE -N PROMETHEUS_NAMESPACE [-D DURATION] [-d]

## Get-rancher-creds

usage: get-rancher-creds [ZONE] 

!!! important
    As HashiCorp Vault has become unfree, you will have to allow unfree packages in nix.
    ```bash
    export NIXPKGS_ALLOW_UNFREE=1
    nix-build -A get-rancher-creds
    ```
