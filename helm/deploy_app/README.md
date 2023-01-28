# helm chart для развертывания сервисов не входящих в стандартный состав платформы

По порядку опишу переменные в values.yaml файле, что за что отвечает и примеры заполнения:

* namespace - выбор проекта в okd, kubernetes для развертывания сервиса, обязательная настройка;\
пример:
```yml
namespace: prod
```
* image - описание откуда и какой выбрать образ, обязательная настройка;\
пример:
```yml
image:
  registry: docker-registry.com/frontend
  imageName: front
  tag: 0.2.12
```
,где \
***registry*** - путь до репозитория с образами, без "/" на конце,\
***imageName*** - имя образа,\
***tag*** - версия образа.

* module - описание к какому процессу относится этот сервис, эта переменная добавляется в labels, для упрощения поиска ресурсов для данного сервиса, опциональная настройка;\
пример:
```yml
module: monitoring
```
## Далее идёт большая секция под описание развертывания сущности ***deployment***

### deployment:


* enableLivenessProbe, enableReadinessProbe - включение/отключение секции проб, валидны значения ***true/false***, обязательная настройка;\
пример:
```yml
deployment:
  enableLivenessProbe: true
  enableReadinessProbe: false
```
* replicas - кол-во подов сервиса;\
пример:
```yml
deployment:
  replicas: 1
```
* imagePullPolicy - политика отвечающая за то как часто будет пулиться образ на рабочую ноду, по-умолчанию стоит Always, если ничего не указывать иного, опциональная настройка;\
пример:
```yml
deployment:
  imagePullPolicy: Always
```
* imagePullSecrets - какой секрет будет использоваться при пуле образов из указанного реджестри, опциональная настройка;\
пример:
```yml
deployment:
  imagePullSecrets: docker-registry.com
```
* env - передача переменных окружения, заполняется в формате kubernetes yaml, можеты быть пустым, опциональная настройка;\
пример:
```yml
deployment:
  env:
    - name: CONTEXT_PATH
      value: "/app"
    - name: POSTGRES_HOST
      valueFrom:
        configMapKeyRef:
          name: global-config
          key: POSTGRES_HOST
```

* configMapRef - подключение переменных из списка указанных configmap'ов, можеты быть пустым, опциональная настройка;\
пример:
```yml
deployment:
  configMapRef:
  - global-config
  - service-links
```
* ports - указание порта сервиса, обязательная настройка;\
пример:
```yml
deployment:
  ports: 8080
```
* resources - секция в которой описывается какие ресурсы будут выданы сервису, является обязательной настройкой;\
пример:
```yml
deployment:
  resources:
    limits:
      cpu: 200m
      memory: 200Mi
    requests:
      cpu: 100m
      memory: 100Mi
```
* readinessProbe, livenessProbe - блоки отвечающие за пробы, подключаются при помощи переменных enableLivenessProbe, enableReadinessProbe, опциональная настройка;\
пример:
```yml
deployment:
  readinessProbe:
    initialDelaySeconds: 1
    periodSeconds: 10
    timeoutSeconds: 3
    successThreshold: 1
    failureThreshold: 5
    httpGet:
      path: /metrics
      port: 8080
      scheme: HTTP

  livenessProbe:
    initialDelaySeconds: 1
    periodSeconds: 10
    timeoutSeconds: 3
    successThreshold: 1
    failureThreshold: 5
    httpGet:
      path: /metrics
      port: 8080
      scheme: HTTP
```
* terminationGracePeriodSeconds - по умолчанию значение 30сек, опциональная настройка;\
пример:
```yml
deployment:
  terminationGracePeriodSeconds: 60
```

## Блок ***service***
* port - какой номер порта будет использован в сервисе, по умолчанию "8080", опциональная настройка;\
пример:
```yml
service:
  port: 8080
```

## Блок ***route***
* host - днс имя в ингресс контроллере, может быть пустой, в таком случае route не будет создан, опциональная настройка;\
пример:
```yml
route:
  host: example.com
```
* path - uri путь, может быть пустым, в таком случае path не будет задан, опциональная настройка;\
пример:
```yml
route:
  path: /hostURI
```
## Блок ***secret***
Передача ключ-значение, после которых будет создана сущность secret и будет "примаплена" как переменные окружения, может быть пустой, в таком случае secret сущность не будет создана, опциональная настройка;\
пример:
```yml
secret:
  postgres_user: test-user
  postgres_password: test-password
```
## Блок ***fromFile***
* configmap - блок, который отвечает за мапинг файлов из директории ***./files/configMapFiles/****, ключ-значение, ключ - отвечает за имя файла, значение - за путь, куда мапиться файл в контейнере, может быть пустой, в таком случае configmap сущность из файла не будет создана, опциональная настройка;\
пример:
```yml
fromFile:
  configmap:
    config.json: /opt/service/
```
* secret - блок аналогичный по работе предыдущему, разницей лишь в пути откуда берутся файлы ***./files/secretFiles/****;\
пример:
```yml
fromFile:
  secret:
    config.json: /opt/service/
```