param location string
param cosmosdb_name string

resource databaseAccounts_resource 'Microsoft.DocumentDB/databaseAccounts@2022-02-15-preview' = {
  name: cosmosdb_name
  location: location
  kind: 'GlobalDocumentDB'
  identity: {
    type: 'None'
  }
  
  properties: {
    enableFreeTier: true
    consistencyPolicy: {
      defaultConsistencyLevel: 'Eventual'
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    databaseAccountOfferType: 'Standard'
  }
}

resource databaseAccounts_fh_clc3_cosmosdb_name_ImageAnalysis 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-02-15-preview' = {
  parent: databaseAccounts_resource
  name: 'ImageAnalysis'
  properties: {
    resource: {
      id: 'ImageAnalysis'
    }
  }
}

resource databaseAccounts_fh_clc3_cosmosdb_name_00000000_0000_0000_0000_000000000001 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2022-02-15-preview' = {
  parent: databaseAccounts_resource
  name: '00000000-0000-0000-0000-000000000001'
  properties: {
    roleName: 'Cosmos DB Built-in Data Reader'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/executeQuery'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/readChangeFeed'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/read'
        ]
        notDataActions: []
      }
    ]
  }
}

resource databaseAccounts_fh_clc3_cosmosdb_name_00000000_0000_0000_0000_000000000002 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2022-02-15-preview' = {
  parent: databaseAccounts_resource
  name: '00000000-0000-0000-0000-000000000002'
  properties: {
    roleName: 'Cosmos DB Built-in Data Contributor'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
        ]
        notDataActions: []
      }
    ]
  }
}

resource databaseAccounts_fh_clc3_cosmosdb_name_ImageAnalysis_results 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-02-15-preview' = {
  parent: databaseAccounts_fh_clc3_cosmosdb_name_ImageAnalysis
  name: 'results'
  properties: {
    resource: {
      id: 'results'
      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      partitionKey: {
        paths: [
          '/id'
        ]
        kind: 'Hash'
      }
      uniqueKeyPolicy: {
        uniqueKeys: []
      }
      conflictResolutionPolicy: {
        mode: 'LastWriterWins'
        conflictResolutionPath: '/_ts'
      }
    }
  }
}

output cosmosdb_id string = databaseAccounts_resource.id
