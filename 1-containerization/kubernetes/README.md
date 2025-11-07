Kubernetes is a powerful container orchestration platform used for deploying, managing, and scaling containerized applications.
Below is a cheat sheet with basic commands and instructions to help you work with Kubernetes.

### Kubernetes Cheat Sheet:

#### Basic Commands:

1. **Cluster Info:**
   ```bash
   kubectl cluster-info
   ```

2. **Nodes in the Cluster:**
   ```bash
   kubectl get nodes
   ```

3. **Pods:**
   ```bash
   kubectl get pods
   ```

4. **Services:**
   ```bash
   kubectl get services
   ```

5. **Deployments:**
   ```bash
   kubectl get deployments
   ```

#### Create and Apply Resources:

1. **Create Deployment:**
   ```bash
   kubectl create deployment <deployment-name> --image=<image-name>
   ```

2. **Expose Deployment as Service:**
   ```bash
   kubectl expose deployment <deployment-name> --port=<port> --type=NodePort
   ```

3. **Scale Deployment:**
   ```bash
   kubectl scale deployment <deployment-name> --replicas=<num-replicas>
   ```

4. **Delete Resource:**
   ```bash
   kubectl delete <resource-type> <resource-name>
   ```

#### Interact with Pods:

1. **Get Pod Logs:**
   ```bash
   kubectl logs <pod-name>
   ```

2. **Execute Command in Pod:**
   ```bash
   kubectl exec -it <pod-name> -- /bin/bash
   ```

3. **Copy Files to/from Pod:**
   ```bash
   kubectl cp <local-file> <pod-name>:<remote-path>
   kubectl cp <pod-name>:<remote-path> <local-file>
   ```

#### Configuration:

1. **View/Edit Config Maps:**
   ```bash
   kubectl get configmaps
   kubectl describe configmap <configmap-name>
   ```

2. **Secrets:**
   ```bash
   kubectl get secrets
   kubectl describe secret <secret-name>
   ```

#### Monitoring and Scaling:

1. **View Resource Usage:**
   ```bash
   kubectl top pods
   kubectl top nodes
   ```

2. **Horizontal Pod Autoscaler (HPA):**
   ```bash
   kubectl autoscale deployment <deployment-name> --cpu-percent=70 --min=1 --max=10
   ```

3. **View HPA Status:**
   ```bash
   kubectl get hpa
   ```

### Handy Tips:

- **kubectl Contexts:**
  - Switch Context:
    ```bash
    kubectl config use-context <context-name>
    ```
  - List Contexts:
    ```bash
    kubectl config get-contexts
    ```

- **YAML Configuration:**
  - Create/Apply from File:
    ```bash
    kubectl apply -f <filename.yaml>
    ```

- **Rolling Updates:**
  - Update Deployment Image:
    ```bash
    kubectl set image deployment/<deployment-name> <container-name>=<new-image>
    ```

This cheat sheet covers the basics, but Kubernetes is a vast ecosystem. For more in-depth information, refer to the official Kubernetes documentation: [Kubernetes Documentation](https://kubernetes.io/docs/).

Remember to replace placeholders like `<deployment-name>`, `<image-name>`, etc., with your specific values.

