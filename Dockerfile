FROM smizy/mecab:0.996-alpine

RUN set -x \
    && apk --no-cache add \
        ca-certificates \
        python3 \
        su-exec \
        tini \
    && apk --no-cache add --virtual .builddeps \
        build-base \
        python3-dev \
    && pip3 install --upgrade pip \
    && pip3 install \
        bottle \
        gunicorn \        
        mecab-python3 \
    && ln -s /usr/bin/python3.5 /usr/bin/python \
    ## clean
    && apk del .builddeps \
    && find /usr/lib/python3.5 -name __pycache__ | xargs rm -r \
    && rm -rf /root/.[acpw]* 

COPY entrypoint.sh   /usr/local/bin/
COPY main.py         /code/

WORKDIR /code

ENV MECAB_DICDIR  /usr/local/lib/mecab/dic/mecab-ipadic-neologd

ENTRYPOINT [ "/sbin/tini", "--", "entrypoint.sh" ]

CMD [ "python", "-m", "bottle", "-b", "0.0.0.0:8080", "main" ]
# CMD [ "gunicorn", "-w", "4", "-b" ,"0.0.0.0:8080", "main:app" ]
