# @cdesplanches-orka/grpc-lib

This is the **Centralized Contract Registry** for the DevOps Agentic AI project.

## 📦 Purpose
In a professional microservices environment, API contracts should be:
1. **Single Source of Truth**: Defined in one place.
2. **Versioned**: Changes are managed through releases.
3. **Automated**: Code generation is handled by CI/CD.

## ⚙️ How it works
This package contains the `service.proto` file and provides a pre-configured gRPC loader for Node.js services.

### Installation
```bash
npm install @cdesplanches-orka/grpc-lib
```

### Usage
```javascript
const grpcLib = require('@cdesplanches-orka/grpc-lib');
// Load the service and protoPath directly
```

## 🚀 CI/CD
Every change in this folder triggers the `.github/workflows/publish-protos.yml` which publishes a new version to the GitHub Package Registry.
