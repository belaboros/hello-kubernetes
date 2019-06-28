# Hello Kubernetes!

This project is a fork of https://github.com/paulbouwer/hello-kubernetes
Credit goes to Paul Bouwer

This for adds a little more deug information about the environment.

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
| zebra stripes | are neat      |


Run on a different port with a different message:
```
$ PORT=9090 MESSAGE="Hello K8S!" npm start
# wget http://localhost:9090
```

## Run locally with Docker

In a bash terminal:

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
kubectl apply -f k8s/hello-kubernetes.yaml
# wget wget $(kubectl get services | grep hello-kubernetes-custom | tr -s  " " | cut -d ' ' -f 3):80
kubectl delete -f k8s/hello-kubernetes.custom.yaml
sudo snap remove microk8s
```



**********************************************************************************




This image can be deployed on a Kubernetes cluster. It displays:
- a default **Hello world!** message
- the pod name
- node os information

The default "Hello world!" message displayed can be overridden using the `MESSAGE` environment variable.

The default port of 8080 can be overriden using the `PORT` environment variable.

## DockerHub

It is available on DockerHub as:

- [paulbouwer/hello-kubernetes:1.5](https://hub.docker.com/r/paulbouwer/hello-kubernetes/)

## Deploy

You can deploy the image to your Kubernetes cluster one of two ways:

Deploy using the hello-kubernetes.yaml, which contains definitions for the service and deployment objects:

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
        image: paulbouwer/hello-kubernetes:1.5
        ports:
        - containerPort: 8080
```

```bash
$ kubectl apply -f yaml/hello-kubernetes.yaml
```

Or, deploy by executing the following `run` and `expose` commands on `kubectl`. 

```bash
$ kubectl run hello-kubernetes --replicas=3 --image=paulbouwer/hello-kubernetes:1.5 --port=8080
$ kubectl expose deployment hello-kubernetes --type=LoadBalancer --port=80 --target-port=8080 --name=hello-kubernetes
```

This will display a **Hello world!** message when you hit the service endpoint in a browser. You can get the service endpoint ip address by executing the following command and grabbing the returned external ip address value:

```bash
$ kubectl get service hello-kubernetes
```

## Custom Message

You can customise the message displayed by the `hello-kubernetes` container as follows:

Deploy using the hello-kubernetes.custom-message.yaml, which contains definitions for the service and deployment objects:

In the definition for the deployment, add an `env` variable with the name of `MESSAGE`. The value you provide will be displayed as the custom message.

```yaml
# hello-kubernetes.custom-message.yaml

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
        image: paulbouwer/hello-kubernetes:1.5
        ports:
        - containerPort: 8080
        env:
        - name: MESSAGE
          value: I just deployed this on Kubernetes!
```

```bash
$ kubectl apply -f yaml/hello-kubernetes.custom-message.yaml
```

Or, deploy by executing the following `run` and `expose` commands on `kubectl`, with the environment variable `MESSAGE` provided as part of the `run` command.

```bash
$ kubectl run hello-kubernetes --replicas=3 --image=paulbouwer/hello-kubernetes:1.5 --port=8080 --env="MESSAGE=I just deployed this on Kubernetes!"
$ kubectl expose deployment hello-kubernetes --type=LoadBalancer --port=80 --target-port=8080 --name=hello-kubernetes
```

## Custom Port

By default, the `hello-kubernetes` app listens on port `8080`. If you have a requirement for the app to listen on another port, you can specify the port via an env variable with the name of PORT. Remember to also update the `containers.ports.containerPort` value to match.

Here is an example:

```yaml
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
        image: paulbouwer/hello-kubernetes:1.5
        ports:
        - containerPort: 80
        env:
        - name: PORT
          value: "80"
```


## Build

If you'd like to build the image yourself, then you can do so as follows. The `build-arg` parameters provides metadata as defined in [OCI image spec annotations](https://github.com/opencontainers/image-spec/blob/master/annotations.md).

Bash
```bash
$ docker build --no-cache --build-arg IMAGE_VERSION="1.5" --build-arg IMAGE_CREATE_DATE="`date -u +"%Y-%m-%dT%H:%M:%SZ"`" --build-arg IMAGE_SOURCE_REVISION="`git rev-parse HEAD`" -f Dockerfile -t "hello-kubernetes:1.5" .
```

Powershell
```powershell
PS> docker build --no-cache --build-arg IMAGE_VERSION="1.5" --build-arg IMAGE_CREATE_DATE="$(Get-Date((Get-Date).ToUniversalTime()) -UFormat '%Y-%m-%dT%H:%M:%SZ')" --build-arg IMAGE_SOURCE_REVISION="$(git rev-parse HEAD)" -f Dockerfile -t "hello-kubernetes:1.5" .
```
