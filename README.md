# Hello Kubernetes!

This project is a fork of original work of Paul Bouwer:
  - https://github.com/paulbouwer/hello-kubernetes
  - https://hub.docker.com/r/paulbouwer/hello-kubernetes/
Credit goes to Paul Bouwer.

The current fork shows some extra info.

## Run locally

On Ubuntu 18.04

```
$ sudo apt install npm
$ npm install
$ npm start
# wget http://localhost:8080
```


Defaults are customizable via environment variables

| Env. Variable | Default value |
| ------------- |:-------------:|
| PORT          | 8080          |
| MESSAGE       | Hello World!  |



Run on a different port with a different message:
```
$ PORT=9090 MESSAGE="Hello K8S!" npm start
# wget http://localhost:9090
```

## Run locally with Docker

In a bash terminal:

```
$ docker run -P belaboros/hello-kubernetes:latest
# or
$ docker run -p 9090:8080 belaboros/hello-kubernetes:latest
```

## Build and run locally with Docker



```
$ docker build --no-cache --build-arg IMAGE_VERSION="1.5.1" --build-arg IMAGE_CREATE_DATE="`date -u +"%Y-%m-%dT%H:%M:%SZ"`" --build-arg IMAGE_SOURCE_REVISION="`git rev-parse HEAD`" -t "hello-kubernetes:1.5.1" -t "hello-kubernetes:latest" .
$ docker run -P hello-kubernetes:1.5.1
# wget http://localhost:8080
```



Run the Docker container listening on a different port with a different message:
```
$ docker build --no-cache --build-arg IMAGE_VERSION="1.5.1" --build-arg IMAGE_CREATE_DATE="`date -u +"%Y-%m-%dT%H:%M:%SZ"`" --build-arg IMAGE_SOURCE_REVISION="`git rev-parse HEAD`" -t "hello-kubernetes:1.5.1" -t "hello-kubernetes:latest" .
$ docker run -e "MESSAGE=Hello K8S!" -p 9090:8080 hello-kubernetes:latest
# wget http://localhost:9090
```

## Run locally on MiniK8s

On Ubuntu 18.04

```
sudo snap install microk8s --classic
kubectl apply -f k8s/hello-kubernetes.yaml
# wget wget $(kubectl get services | grep hello-kubernetes | tr -s  " " | cut -d ' ' -f 3):80
kubectl delete -f k8s/hello-kubernetes.yaml
sudo snap remove microk8s
```


Customized
```
snap install microk8s --classic
kubectl apply -f k8s/hello-kubernetes.custom.yaml
# wget wget $(kubectl get services | grep hello-kubernetes-custom | tr -s  " " | cut -d ' ' -f 3):80
kubectl delete -f k8s/hello-kubernetes.custom.yaml
sudo snap remove microk8s
```

## Run on K8S cluster

### Declarative deploy:

```yaml
# hello-kubernetes.yaml

apiVersion: v1
kind: Service
metadata:
  name: hello-kubernetes
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: hello-kubernetes
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-kubernetes
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hello-kubernetes
  template:
    metadata:
      labels:
        app: hello-kubernetes
    spec:
      containers:
      - name: hello-kubernetes
        image: belaboros/hello-kubernetes
        ports:
        - containerPort: 8080
```


```
kubectl apply -f k8s/hello-kubernetes.yaml
```

```yaml
# hello-kubernetes.custom.yaml

apiVersion: v1
kind: Service
metadata:
  name: hello-kubernetes-custom
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: hello-kubernetes-custom
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-kubernetes-custom
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hello-kubernetes-custom
  template:
    metadata:
      labels:
        app: hello-kubernetes-custom
    spec:
      containers:
      - name: hello-kubernetes
        image: belaboros/hello-kubernetes
        ports:
        - containerPort: 8080
        env:
        - name: MESSAGE
          value: Hello K8S! (with a customized message)
```


```
kubectl apply -f k8s/hello-kubernetes.custom.yaml
```




Imperative deploy:
```
$ kubectl run hello-kubernetes --replicas=3 --image=belaboros/hello-kubernetes:latest --port=8080
$ kubectl expose deployment hello-kubernetes --type=LoadBalancer --port=80 --target-port=8080 --name=hello-kubernetes
# wget wget $(kubectl get services | grep hello-kubernetes | tr -s  " " | cut -d ' ' -f 3):80
```


Customized imperative deploy
```
$ kubectl run hello-kubernetes --replicas=3 --image=belaboros/hello-kubernetes --port=8080 --env="MESSAGE=Hello K8S! (with customized message)"
$ kubectl expose deployment hello-kubernetes --type=LoadBalancer --port=80 --target-port=8080 --name=hello-kubernetes
# wget wget $(kubectl get services | grep hello-kubernetes | tr -s  " " | cut -d ' ' -f 3):80
```



## See also original source of Paul Bouwer
  - https://github.com/paulbouwer/hello-kubernetes
  - https://hub.docker.com/r/paulbouwer/hello-kubernetes/
