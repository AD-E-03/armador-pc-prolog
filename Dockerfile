FROM swipl:stable

WORKDIR /app

COPY server/ server/
COPY web/ web/
COPY prolog/ prolog/

ENV PORT=8080
EXPOSE 8080

CMD ["swipl", "server/servidor.pl"]
