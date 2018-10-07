# Jenkins configuration as code

You can run this locally with docker
Exporting the correct values into your shell
```
version: '3.6'
services:
  jenkins:
    container_name: jenkins
    image: hmcts/jenkins:latest
    build: .
    ports:
      - '8088:8080'
    environment:
      - CASC_JENKINS_CONFIG=/usr/share/jenkins/jenkins.yaml
      - JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
      - JENKINS_REFORM_CNP
      - SONARCLOUD
      - SLACK_TOKEN
    volumes:
      - './jenkins.yaml:/usr/share/jenkins/jenkins.yaml'

```

Or on kubenetes with:

```
helm init
helm repo update

export TEAM_NAME=divorce
az aks get-credentials --resource-group cnp-aks-sandbox-rg --name cnp-aks-sandbox-cluster
helm install --name ${TEAM_NAME}-jenkins --namespace jenkins -f values.yaml stable/jenkins
```

to update the config of the helm chart do:
```
helm upgrade ${TEAM_NAME}-jenkins --namespace jenkins -f values.yaml stable/jenkins
```

To get the jenkins logs:
```
kubectl get pods --namespace jenkins
kubectl logs -f <pod name> --namespace jenkins
```

To debug why your pod isn't starting:
```
kubectl describe <pod name> --namespace jenkins
```

To retrieve the secrets a secret is needed in the namespace of your jenkins
The secret needs `get` permissions on any vaults that you are retrieving secrets from
This only needs to be done once:
```
kubectl create secret generic kvcreds --from-literal clientid=<CLIENTID> --from-literal clientsecret=<CLIENTSECRET> --type=azure/kv --namespace jenkins
```

