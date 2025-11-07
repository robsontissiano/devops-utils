# Pulumi Utilities and Commands

A comprehensive guide to Pulumi commands, best practices, and templates for infrastructure as code using real programming languages.

## Essential Commands

### Initialize New Project
```bash
pulumi new
```
Create a new Pulumi project with interactive prompts.

### Initialize with Template
```bash
pulumi new aws-typescript
pulumi new aws-python
pulumi new azure-csharp
pulumi new kubernetes-go
```

### Preview Changes
```bash
pulumi preview
```
Show what resources will be created, updated, or deleted.

### Deploy Infrastructure
```bash
pulumi up
```
Deploy your infrastructure changes.

### Deploy with Auto-Approve
```bash
pulumi up --yes
```
Deploy without interactive confirmation.

### Destroy Infrastructure
```bash
pulumi destroy
```
Remove all resources in the stack.

### Destroy with Auto-Approve
```bash
pulumi destroy --yes
```
Destroy infrastructure without confirmation.

### Refresh State
```bash
pulumi refresh
```
Sync Pulumi state with actual cloud resources.

## Stack Management

### List Stacks
```bash
pulumi stack ls
```

### Create New Stack
```bash
pulumi stack init <stack-name>
```

### Select Stack
```bash
pulumi stack select <stack-name>
```

### Remove Stack
```bash
pulumi stack rm <stack-name>
```

### Export Stack State
```bash
pulumi stack export > stack.json
```

### Import Stack State
```bash
pulumi stack import < stack.json
```

### View Stack Outputs
```bash
pulumi stack output
```

### View Specific Output
```bash
pulumi stack output <output-name>
```

### View Stack in JSON
```bash
pulumi stack output --json
```

## Configuration Management

### Set Configuration Value
```bash
pulumi config set <key> <value>
```

### Set Secret Configuration
```bash
pulumi config set --secret <key> <value>
```

### Get Configuration Value
```bash
pulumi config get <key>
```

### List All Configuration
```bash
pulumi config
```

### Remove Configuration Key
```bash
pulumi config rm <key>
```

## State and History

### View Stack History
```bash
pulumi history
```

### View Stack Resources
```bash
pulumi stack
```

### Cancel Current Update
```bash
pulumi cancel
```

## Import and Export

### Import Existing Resource
```bash
pulumi import <type> <name> <id>
```

### Export Stack as Code
```bash
pulumi stack export --file stack.json
```

## Useful One-Liners

### Preview with Detailed Diff
```bash
pulumi preview --diff
```

### Deploy Specific Resource
```bash
pulumi up --target <urn>
```

### Destroy Specific Resource
```bash
pulumi destroy --target <urn>
```

### Update Dependencies
```bash
npm update @pulumi/pulumi @pulumi/aws  # For Node.js
pip install --upgrade pulumi pulumi-aws  # For Python
```

### View Stack Graph
```bash
pulumi stack graph stack-graph.png
```

### Login to Different Backend
```bash
pulumi login s3://my-pulumi-state-bucket
pulumi login azblob://my-container
pulumi login gs://my-pulumi-state
pulumi login file://~/.pulumi-local
```

### Logout
```bash
pulumi logout
```

## Example: AWS Infrastructure (TypeScript)

```typescript
// index.ts
import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";

// Create a VPC
const vpc = new aws.ec2.Vpc("main-vpc", {
    cidrBlock: "10.0.0.0/16",
    enableDnsHostnames: true,
    enableDnsSupport: true,
    tags: {
        Name: "main-vpc",
    },
});

// Create a subnet
const subnet = new aws.ec2.Subnet("public-subnet", {
    vpcId: vpc.id,
    cidrBlock: "10.0.1.0/24",
    availabilityZone: "us-east-1a",
    mapPublicIpOnLaunch: true,
    tags: {
        Name: "public-subnet",
    },
});

// Create an Internet Gateway
const igw = new aws.ec2.InternetGateway("internet-gateway", {
    vpcId: vpc.id,
    tags: {
        Name: "main-igw",
    },
});

// Export the VPC ID
export const vpcId = vpc.id;
export const subnetId = subnet.id;
```

```json
// package.json
{
    "name": "aws-infrastructure",
    "main": "index.ts",
    "devDependencies": {
        "@types/node": "^20.0.0"
    },
    "dependencies": {
        "@pulumi/pulumi": "^3.0.0",
        "@pulumi/aws": "^6.0.0"
    }
}
```

## Example: AWS Infrastructure (Python)

```python
# __main__.py
import pulumi
import pulumi_aws as aws

# Create a VPC
vpc = aws.ec2.Vpc(
    "main-vpc",
    cidr_block="10.0.0.0/16",
    enable_dns_hostnames=True,
    enable_dns_support=True,
    tags={
        "Name": "main-vpc",
    }
)

# Create a subnet
subnet = aws.ec2.Subnet(
    "public-subnet",
    vpc_id=vpc.id,
    cidr_block="10.0.1.0/24",
    availability_zone="us-east-1a",
    map_public_ip_on_launch=True,
    tags={
        "Name": "public-subnet",
    }
)

# Export outputs
pulumi.export("vpc_id", vpc.id)
pulumi.export("subnet_id", subnet.id)
```

```
# requirements.txt
pulumi>=3.0.0,<4.0.0
pulumi-aws>=6.0.0,<7.0.0
```

## Example: Kubernetes Deployment

```typescript
// index.ts
import * as pulumi from "@pulumi/pulumi";
import * as k8s from "@pulumi/kubernetes";

// Create a Kubernetes Deployment
const appLabels = { app: "nginx" };
const deployment = new k8s.apps.v1.Deployment("nginx", {
    spec: {
        selector: { matchLabels: appLabels },
        replicas: 3,
        template: {
            metadata: { labels: appLabels },
            spec: {
                containers: [{
                    name: "nginx",
                    image: "nginx:latest",
                    ports: [{ containerPort: 80 }],
                }],
            },
        },
    },
});

// Create a Service
const service = new k8s.core.v1.Service("nginx", {
    metadata: {
        labels: appLabels,
    },
    spec: {
        type: "LoadBalancer",
        ports: [{ port: 80, targetPort: 80 }],
        selector: appLabels,
    },
});

export const serviceIp = service.status.loadBalancer.ingress[0].ip;
```

## Configuration Files

### Pulumi.yaml
```yaml
name: my-project
runtime:
  name: nodejs
  options:
    typescript: true
description: My Pulumi project
```

### Pulumi.dev.yaml
```yaml
config:
  aws:region: us-east-1
  myproject:instanceType: t3.micro
  myproject:dbPassword:
    secure: AAABAxxxx...
```

## Stack References

### Reference Another Stack
```typescript
import * as pulumi from "@pulumi/pulumi";

const networkStack = new pulumi.StackReference("organization/network/prod");
const vpcId = networkStack.getOutput("vpcId");

// Use the VPC ID from another stack
```

## Policy as Code (CrossGuard)

```typescript
// policy.ts
import * as policy from "@pulumi/policy";

const policies = new policy.PolicyPack("aws-policies", {
    policies: [
        {
            name: "s3-no-public-read",
            description: "Prohibits setting public read access on S3 buckets",
            enforcementLevel: "mandatory",
            validateResource: policy.validateResourceOfType(aws.s3.Bucket, (bucket, args, reportViolation) => {
                if (bucket.acl === "public-read") {
                    reportViolation("S3 bucket cannot have public-read ACL");
                }
            }),
        },
    ],
});
```

### Enable Policy
```bash
pulumi up --policy-pack ./policy
```

## Testing

### Unit Tests (TypeScript)
```typescript
// index.test.ts
import * as pulumi from "@pulumi/pulumi";

pulumi.runtime.setMocks({
    newResource: function(args: pulumi.runtime.MockResourceArgs): {id: string, state: any} {
        return {
            id: args.inputs.name + "_id",
            state: args.inputs,
        };
    },
    call: function(args: pulumi.runtime.MockCallArgs) {
        return args.inputs;
    },
});

describe("Infrastructure", function() {
    let infra: typeof import("./index");

    before(async function() {
        infra = await import("./index");
    });

    it("must have a VPC", function(done) {
        pulumi.all([infra.vpcId]).apply(([vpcId]) => {
            assert.isDefined(vpcId);
            done();
        });
    });
});
```

## CI/CD Integration

### GitHub Actions
```yaml
name: Pulumi
on:
  push:
    branches:
      - main
jobs:
  preview:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: pulumi/actions@v4
        with:
          command: preview
          stack-name: dev
        env:
          PULUMI_ACCESS_TOKEN: ${{ secrets.PULUMI_ACCESS_TOKEN }}
```

## Best Practices

1. **Use Stack References** for cross-stack dependencies
2. **Store secrets in config** using `--secret` flag
3. **Use strong typing** with TypeScript or other typed languages
4. **Organize code with components** for reusability
5. **Use Policy as Code** for compliance
6. **Implement testing** for infrastructure code
7. **Use CI/CD integration** for automated deployments
8. **Tag resources** for better organization
9. **Use remote state backend** for team collaboration
10. **Document your code** with comments and README files

## Environment Variables

### AWS Credentials
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="us-east-1"
```

### Azure Credentials
```bash
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
```

### Pulumi Configuration
```bash
export PULUMI_ACCESS_TOKEN="your-access-token"
export PULUMI_BACKEND_URL="s3://my-state-bucket"
```

## Troubleshooting

### Clear Cache
```bash
rm -rf node_modules/ package-lock.json
npm install
```

### Reset Stack State
```bash
pulumi stack export > backup.json
pulumi stack rm <stack-name> --force
pulumi stack init <stack-name>
pulumi stack import < backup.json
```

### Debug Mode
```bash
pulumi up --debug
pulumi up --logtostderr -v=9
```

### Convert from Terraform
```bash
pulumi convert --from terraform --language typescript
```

## Common Issues

### Dependency Conflicts
```bash
npm install @pulumi/pulumi@latest @pulumi/aws@latest
```

### State Lock Issues
```bash
pulumi cancel
```

### Authentication Issues
```bash
pulumi logout
pulumi login
```

