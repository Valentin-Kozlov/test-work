FROM python:alpine3.17

WORKDIR /usr/src/app

COPY requirements.txt .

RUN adduser -D user

RUN apk upgrade --available --no-cache

RUN pip install --upgrade pip && pip install -r requirements.txt

USER user

ENV FLASK_APP flask_app.py
ENV PYTHONUNBUFFERED 1
ENV TZ=Asia/Yekaterinburg

EXPOSE 3000

COPY --chmod=755 . .

ENTRYPOINT [ "/usr/src/app/entry.sh" ]