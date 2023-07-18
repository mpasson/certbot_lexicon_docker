# Certbot and Lexicon for Docker

[Certbot](https://certbot.eff.org/) and [Lexicon](https://github.com/AnalogJ/lexicon) Docker container for management of SSL/TLS certificates for small scale self-hosted services.

Main feature include:
- Easy obtaining and renewal fo SSL certificates from [Let's Encrypt](https://letsencrypt.org/).
- Support for DNS challenge via Lexicon to allow for wildcard certificates.
- Creation of certificate file compatible with [HAProxy](https://www.haproxy.org/) reverse proxy.
- Automation of DNS update for hosting on non-static IPs.

## How to use it

### Obtaining the certificate
Before requesting a certificate, data regaring the certificate you want to request needs to be provided. This is done by defining some environment variables that will be passed to the docker conatiner. By default, the provided `docker-compose` assumes all the environment variables are defined in a `credentials.env` file that you must create. Another option is to include the environment variables direclty in the `docker-compose` file.
The environment variables to be defined are:

| Varialbe | Mandatory| Description |
| --- | --- | --- |
| `EMAIL` | Yes| Email addres to use to certificate request. |
| `PROVIDER` | Yes| Lexicon compatible DNS provider. Check list [here](https://github.com/AnalogJ/lexicon#supported-providers).|
| `DOMAIN` | Yes | Domain for which to ask the certificate. The certificate will be requested for the main domain and all subdomains via a wildcard certificate. |
| `OPTIONS` | No| Any other options to be passed to certbot. Useful one is `--dry-run` to only simulate the process. |
|`PROVIDER_UPDATE_DELAY`| No | Time in second to wait for DNS propagation. Must be more tha the TTL of the created TXT records (1 minute). If not provided, default to 120 s. Not all DNS provider allow defiition of TTL, so you may need to increase this value for the process to complete correcly.

Others mandatory variable are the enviroment variables used by Lexicon to authenticate with the DNS provider. They differ for each provider. Check autentication variables [here](https://dns-lexicon.readthedocs.io/en/latest/user_guide.html#environmental-variables) and [here](https://dns-lexicon.readthedocs.io/en/latest/configuration_reference.html).


Once the setup is completed, the certificate can be obtained using the provided `docker-compose`. In order to request the issue of a certificate just run:

        docker compose run -it --rm certbot_lexicon

This will allow you to monitor the issueing process and will remove the container once the process is complete. 

