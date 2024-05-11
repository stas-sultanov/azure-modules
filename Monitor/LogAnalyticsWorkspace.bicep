/* Copyright © 2024 Stas Sultanov */

metadata author = {
	githubUrl: 'https://github.com/stas-sultanov'
	name: 'Stas Sultanov'
	profileUrl: 'https://www.linkedin.com/in/stas-sultanov'
}

/* parameters */

@description('Id of the Storage/storageAccounts resource.')
param Storage_storageAccounts__id string

@description('Location to deploy the resources.')
param location string

@description('Name of the resource.')
param name string

@description('Number of days to keep the logs.')
@minValue(30)
@maxValue(365)
param retentionInDays int = 30

@description('Tags to put on the resource.')
param tags object = {}

/* variables */

var storage_StorageAccounts__id_split = split(Storage_storageAccounts__id, '/')

/* existing resources */

resource Storage_storageAccounts_ 'Microsoft.Storage/storageAccounts@2023-04-01' existing = {
	name: storage_StorageAccounts__id_split[8]
	scope: resourceGroup(storage_StorageAccounts__id_split[2], storage_StorageAccounts__id_split[4])
}

/* resources */

// https://learn.microsoft.com/azure/templates/microsoft.operationalinsights/workspaces
resource OperationalInsights_workspaces_ 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
	location: location
	name: name
	properties: {
		features: {
			disableLocalAuth: true
		}
		publicNetworkAccessForIngestion: 'Enabled'
		publicNetworkAccessForQuery: 'Enabled'
		retentionInDays: retentionInDays
		sku: {
			name: 'PerGB2018'
		}
	}
	tags: tags
}

// https://learn.microsoft.com/azure/templates/microsoft.operationalinsights/workspaces/linkedstorageaccounts
resource OperationalInsights_workspaces_linkedStorageAccounts_Alerts 'Microsoft.OperationalInsights/workspaces/linkedStorageAccounts@2020-08-01' = {
	name: 'Alerts'
	parent: OperationalInsights_workspaces_
	properties: {
		storageAccountIds: [ Storage_storageAccounts_.id ]
	}
}

// https://learn.microsoft.com/azure/templates/microsoft.operationalinsights/workspaces/linkedstorageaccounts
resource OperationalInsights_workspaces_linkedStorageAccounts_CustomLogs 'Microsoft.OperationalInsights/workspaces/linkedStorageAccounts@2020-08-01' = {
	name: 'CustomLogs'
	parent: OperationalInsights_workspaces_
	properties: {
		storageAccountIds: [
			Storage_storageAccounts_.id
		]
	}
}

// https://learn.microsoft.com/azure/templates/microsoft.operationalinsights/workspaces/linkedstorageaccounts
resource OperationalInsights_workspace_linkedStorageAccounts_Query 'Microsoft.OperationalInsights/workspaces/linkedStorageAccounts@2020-08-01' = {
	name: 'Query'
	parent: OperationalInsights_workspaces_
	properties: {
		storageAccountIds: [
			Storage_storageAccounts_.id
		]
	}
}

// https://learn.microsoft.com/azure/templates/microsoft.insights/diagnosticsettings
#disable-next-line use-recent-api-versions
resource Insights_diagnosticSettings_ 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
	name: 'Storage'
	properties: {
		storageAccountId: Storage_storageAccounts_.id
		logs: [
			{
				category: 'Audit'
				enabled: true
			}
		]
		metrics: [
			{
				enabled: true
				timeGrain: 'PT1M'
			}
		]
	}
	scope: OperationalInsights_workspaces_
}

/* outputs */

output id string = OperationalInsights_workspaces_.id

output name string = OperationalInsights_workspaces_.name
