# Lab 3 — hello-app on Kubernetes with Terraform

Name: Tejaswini S

Roll number:261100680019

## Part 1: first `terraform plan`

Paste the `Plan:` line and the summary above it.

```Terraform will perform the following actions:

  + create

Plan: 2 to add, 0 to change, 0 to destroy.

```

## Part 1: `terraform output -raw url`

```
http://localhost:8080
```

## Part 2: plan for the v1 → v2 image change

Paste the lines that show the image change, and the `Plan:` line.

```
~ image = "shripada/hello-app:v1" -> "shripada/hello-app:v2"

Plan: 0 to add, 1 to change, 0 to destroy.
```

## Part 3: plan that found the drift after `kubectl scale`

```
kubectl scale deployment hello-app --replicas=5

~ replicas = 5 -> 3

Plan: 0 to add, 1 to change, 0 to destroy.
```

## Part 4: `kubectl get svc -A` showing dev and prod

```
NAMESPACE     NAME         TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                  AGE
dev           hello-app    LoadBalancer   10.104.103.197   localhost     8080:31324/TCP           14m
prod          hello-app    LoadBalancer   10.98.81.168     localhost     8090:30982/TCP           22m
```

## Break it: the error after deleting `terraform.tfstate`

```
Error: Error creating namespace

namespaces "dev" already exists
Explanation: After deleting the Terraform state file, Terraform lost track of the existing Kubernetes resources. It attempted to create the dev namespace again, but Kubernetes reported that the namespace already existed. I deleted the existing namespace and ran terraform apply again to recreate the resources.

```

## Break it: the wrong selector

What did you see, and how did you find the cause? One or two sentences.
The Service selector was temporarily changed from hello-app to helo-app. After applying the change, the Service had no matching Pod endpoints. I used kubectl get endpointslices -n dev to identify the missing endpoints and found that the selector did not match the Pod labels. I corrected the selector to hello-app and applied Terraform again.


## Screenshot

Save a browser screenshot as `screenshot.png` in the repository root.
