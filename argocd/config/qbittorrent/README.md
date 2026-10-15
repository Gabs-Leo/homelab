To access qBittorrent through the NodePort, follow these steps once:

- Create a port-forward to the service so it can be accessed from your local machine:
```sh
kubectl -n media port-forward svc/qbittorrent 8080:8080
```

- Retrieve the default password from the container logs:
```sh
kubectl -n media logs deploy/qbittorrent --since=30m | grep -iE 'password|ban|auth|webui'
```

- Once logged in, go to Options -> Web UI and disable `Enable host header validation`.

## Service and access details

The current qBittorrent service is exposed through a NodePort:

- Web UI: `http://<node-ip>:30080`
- Torrent TCP: `6881`
- Torrent UDP: `6881`

The deployment mounts:

- config: `/srv/homelab/config/qbittorrent`
- data: `/srv/homelab/data`

This setup matches the current Kubernetes manifests in the repository and is intended for local access and testing.
