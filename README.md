# Certbot and Lexicon for Docker

[Certbot](https://certbot.eff.org/) and [Lexicon](https://github.com/AnalogJ/lexicon) Docker container for management of SSL/TLS certificates for small scale self-hosted services.

Main feature include:
- Easy obtaining and renewal fo SSL certificates from [Let's Encrypt](https://letsencrypt.org/).
- Support for DNS challenge via Lexicon to allow for wildcard certificates.
- Creation of certificate file compatible with [HAProxy](https://www.haproxy.org/) reverse proxy.
- Automation of DNS update for hosting on non-static IPs.

## How to use it

### Obtaining the certificate
Before requesting a certificate, data regarding the certificate you want to request needs to be provided. This is done by defining some environment variables that will be passed to the docker container. By default, the provided `docker-compose` assumes all the environment variables are defined in a `credentials.env` file that you must create. Another option is to include the environment variables directly in the `docker-compose` file.
The environment variables to be defined are:

| Varialbe | Mandatory| Description |
| --- | --- | --- |
| `EMAIL` | Yes| Email address to use to certificate request. |
| `PROVIDER` | Yes| Lexicon compatible DNS provider. Check list [here](https://github.com/AnalogJ/lexicon#supported-providers).|
| `DOMAIN` | Yes | Domain for which to ask the certificate. The certificate will be requested for the main domain and all subdomains via a wildcard certificate. |
| `OPTIONS` | No| Any other options to be passed to certbot. Useful one is `--dry-run` to only simulate the process. |
|`PROVIDER_UPDATE_DELAY`| No | Time in second to wait for DNS propagation. Must be more tha the TTL of the created TXT records (1 minute). If not provided, default to 120 s. Not all DNS provider allow definition of TTL, so you may need to increase this value for the process to complete correctly.

Others mandatory variable are the environment variables used by Lexicon to authenticate with the DNS provider. They differ for each provider. Check authentication variables [here](https://dns-lexicon.readthedocs.io/en/latest/user_guide.html#environmental-variables) and [here](https://dns-lexicon.readthedocs.io/en/latest/configuration_reference.html).


Once the setup is completed, the certificate can be obtained using the provided `docker-compose`. In order to request the issue of a certificate just run:

        docker compose run -it --rm certbot_lexicon

This will allow you to monitor the issuing process and will remove the container once the process is complete. 

If the process runs successfully, you will find your newly created certificates in the folder `./conf/live/$DOMANIN`. You can use these file for whatever you need.

Besides the standard Let's Encrypt files (`cert.pem`, `chain.pem`, `fullchain.pem`, and `privkey.pem`) you will find the additional file `haproxy.pem`. This a file built by the container script in order to be used by [HAProxy](https://www.haproxy.org/).

### Renewing the certificate

Once certbot request a certificate, it remembers the configuration of the request and can request a renewal without specifying anything again. However, the action is not automatic and needs to be triggered. 

This can be done with this container by issuing the command:

        docker compose run --rm -it certbot_lexicon /opt/renew_cert.bash

This will renew the certificate an allow you to monitor the progress.
Let's Encrypt certificates last three months and can be renewed starting one month before expiration date.

### Updating the IP
Since this container is build to simplify the hosting of web services at home, it provides also the capability of updating the A DNS record of you domain automatically. Therefore, it is possible to place a server on a non-static IP and be quite confident to be able to reach it even if the IP changes.

In order to trigger the IP update, run the following:

        docker compose run --rm -it certbot_lexicon /opt/update_ip.bash

This will check the IP associated with your domain and update the DNS if it is different from your IP.
Since if read the DNS record from the internet, it will always trigger an update if your DNS is proxied. If you want to change that, you can change the script to read the registered IP directly from the provider instead of consulting a DNS server.

## Automation
If you want to automate some of the task here described (mainly certificate renewal and ip update), I suggest (if you are running a linux system) to set up regular running of the scripts via cron. 

In order to do this, you need to edit `/etc/crontab`. I suggest to add the following lines (the commented lines are just the header of crontab, you should already have them):

        # Example of job definition:
        # .---------------- minute (0 - 59)
        # |  .------------- hour (0 - 23)
        # |  |  .---------- day of month (1 - 31)
        # |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
        # |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
        # |  |  |  |  |
        # *  *  *  *  * user-name command to be executed
        05 *    * * *   <your-user>   docker compose -f <full-path-to-docker-compose.yaml> run --rm certbot_lexicon /opt/update_ip.bash
        10 0    * * *   <your-user>   docker compose -f <full-path-to-docker-compose.yaml> run --rm certbot_lexicon /opt/renew_cert.bash

This will run `update_ip.bash` at minute 5 every hour and  `renew_cert.bash` every night at 00:10. Adjust the times according to your need.


## Contributing

If you have any problem or suggestion feel free to open an issue or submit a pull request.


