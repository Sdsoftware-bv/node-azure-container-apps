param location string = resourceGroup().location
param environmentName string = 'env-${uniqueString(resourceGroup().id)}'
param minReplicas int = 0
param nodeImage string = 'nginx'
param nodePort int = 3000
param containerRegistry string
param containerRegistryUsername string

@secure()
param containerRegistryPassword string

var nodeServiceAppName = 'my-express-app'

// // container app environment
module environment 'environment.bicep' = {
  name: 'container-app-environment'
  params: {
    environmentName: environmentName
    location: location
  }
}



// node App
module nodeService 'container-http.bicep' = {
  name: nodeServiceAppName
  params: {
    location: location
    containerAppName: nodeServiceAppName
    environmentId: environment.outputs.environmentId
    containerImage: nodeImage
    containerPort: nodePort
    isExternalIngress: true
    minReplicas: minReplicas
    containerRegistry: containerRegistry
    containerRegistryUsername: containerRegistryUsername
    containerRegistryPassword: containerRegistryPassword
    env: []
  }
}