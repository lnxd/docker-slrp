# docker-slrp

This project serves to enhance [nfx/slrp](https://github.com/nfx/slrp)'s flexibility and portability, making it easier to manage within Docker environments. This is an alternative to the project's included Dockerfile, more suited for docker-compose workflows or platforms like Vultr or Unraid.

## Base Image

This container is based on `debian-bookworm:slim`. I chose this for convenience when troubleshooting, vs. the more minimal Alpine image.

## Ports Configuration

- **8089**: Web UI
- **8090**: SOCKS interface
- **6060**: Profiler (likely requires `SLRP_PPROF_ENABLE` or `SLRP_SERVER_ENABLE_PROFILER`, this is untested)

## Deployment

### Docker Run

```shell
docker run -p 8089:8089 -p 8090:8090 --name slrp lnxd/slrp
```

### Docker Compose

Example `docker-compose.yml` for SLRP:

```yaml
version: '3'
services:
  slrp:
    image: lnxd/slrp
    container_name: slrp
    ports:
      - "8089:8089"
      - "8090:8090"
    restart: unless-stopped
```

### Environment Variables

Please note that these were extracted from the main project's readme by AI, and is most likely innaccurate. I'm just including this list for convenience, until I get a chance to properly review it.  

| Variable                                 | Example                        | Purpose                                                                                              |
|------------------------------------------|--------------------------------|------------------------------------------------------------------------------------------------------|
| `SLRP_APP_STATE`                         | `/var/slrp/data`               | Sets the directory where application data persists through restarts.                                 |
| `SLRP_APP_SYNC`                          | `30s`                          | Defines how often data is synchronized to disk, assuming there are updates.                          |
| `SLRP_LOG_LEVEL`                         | `DEBUG`                        | Determines the log level of the application.                                                         |
| `SLRP_LOG_FORMAT`                        | `json`                         | Sets the format of log lines printed.                                                                |
| `SLRP_LOG_FILE`                          | `/var/log/slrp.log`            | Specifies the file path for application logs in JSON format.                                         |
| `SLRP_SERVER_ADDR`                       | `0.0.0.0:8089`                 | Sets the address of the listening HTTP server.                                                       |
| `SLRP_SERVER_READ_TIMEOUT`               | `30s`                          | Defines the server read timeout.                                                                     |
| `SLRP_SERVER_ENABLE_PROFILER`            | `true`                         | Enables or disables profiler endpoints.                                                              |
| `SLRP_DIALER_WIREGUARD_CONFIG_FILE`      | `/etc/slrp/wg.conf`            | Path to the WireGuard configuration file for the VPN dialer.                                         |
| `SLRP_DIALER_WIREGUARD_VERBOSE`          | `true`                         | Enables verbose logging mode for the WireGuard tunnel.                                               |
| `SLRP_POOL_REQUEST_WORKERS`              | `256`                          | Number of workers to perform outgoing HTTP requests.                                                 |
| `SLRP_POOL_REQUEST_TIMEOUT`              | `15s`                          | Timeout for outgoing HTTP requests.                                                                  |
| `SLRP_POOL_SHARDS`                       | `2`                            | Number of shards for proxy pool maintenance.                                                         |
| `SLRP_POOL_EVICT_SPAN_MINUTES`           | `10`                           | Span of time in minutes for rolling counters in proxy pool maintenance.                              |
| `SLRP_POOL_SHORT_TIMEOUT_SLEEP`          | `5s`                           | Time to remove a proxy from routing after the first timeout or error.                                |
| `SLRP_POOL_LONG_TIMEOUT_SLEEP`           | `60s`                          | Time to remove a proxy from routing after meeting the eviction threshold within a time span.         |
| `SLRP_POOL_EVICT_THRESHOLD_TIMEOUTS`     | `5`                            | Threshold of timeouts within the last span of minutes to consider eviction.                          |
| `SLRP_POOL_EVICT_THRESHOLD_FAILURES`     | `10`                           | Number of failures within the last span of minutes to evict proxy from the pool.                     |
| `SLRP_POOL_EVICT_THRESHOLD_REANIMATIONS` | `3`                            | Number of any proxy sleeps ever to evict proxy from the pool.                                        |
| `SLRP_PROBE_ENABLE_HTTP_RESCUE`          | `true`                         | Enables the experimental feature to rescue HTTP proxies detected based on protocol probe heuristics. |
| `SLRP_REFRESHER_ENABLED`                 | `false`                        | Enables or disables the source refresher.                                                            |
| `SLRP_REFRESHER_MAX_SCHEDULED`           | `3`                            | Number of sources to refresh at the same time.                                                       |
| `SLRP_MITM_ADDR`                         | `0.0.0.0:8090`                 | Address of the listening HTTP proxy server.                                                          |
| `SLRP_MITM_READ_TIMEOUT`                 | `20s`                          | Read timeout for the HTTP proxy server.                                                              |
| `SLRP_MITM_IDLE_TIMEOUT`                 | `20s`                          | Idle timeout for the HTTP proxy server.                                                              |
| `SLRP_MITM_WRITE_TIMEOUT`                | `20s`                          | Write timeout for the HTTP proxy server.                                                             |
| `SLRP_CHECKER_TIMEOUT`                   | `10s`                          | Time to wait while performing verification of proxy liveliness and anonymity.                        |
| `SLRP_CHECKER_STRATEGY`                  | `headers`                      | Verification strategy for checking the IP of the proxy.                                              |
| `SLRP_HISTORY_LIMIT`                     | `2000`                         | Number of requests to keep in memory for recording forwarded requests.                               |
| `SLRP_IPINFO_LICENSE`                    | `your_license_key`             | License key for MaxMind downloads for IP information.                                                |
| `SLRP_IPINFO_MMDB_ASN`                   | `/etc/slrp/GeoLite2-ASN.mmdb`  | Path to the MaxMind ASN database file.                                                               |
| `SLRP_IPINFO_MMDB_CITY`                  | `/etc/slrp/GeoLite2-City.mmdb` | Path to the MaxMind                                                                                  |
