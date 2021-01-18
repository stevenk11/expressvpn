# Run expressvpn in a container
FROM debian:buster-slim

ENV ACTIVATION_CODE Code
ENV LOCATION smart
ARG APP=expressvpn_3.4.2.4-1_amd64.deb

RUN sed -i -e "s/deb.debian/ftp.hk.debian/g" /etc/apt/sources.list \
	&& apt-get update && apt-get install -y --no-install-recommends \
	ca-certificates wget expect iproute2 curl \
	&& rm -rf /var/lib/apt/lists/* \
	&& wget -q "https://download.expressvpn.xyz/clients/linux/${APP}" -O /tmp/${APP} \
	&& dpkg -i /tmp/${APP} \
	&& rm -rf /tmp/*.deb \
	&& apt-get purge -y --autoremove wget \
	&& sed -i -e "s/\"\$DAEMON_ARGS\"/\$DAEMON_ARGS/g" /etc/init.d/expressvpn

COPY entrypoint.sh /tmp/entrypoint.sh
COPY expressvpnActivate.sh /tmp/expressvpnActivate.sh

ENTRYPOINT ["/bin/bash", "/tmp/entrypoint.sh"]
