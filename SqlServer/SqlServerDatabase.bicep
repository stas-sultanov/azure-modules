﻿metadata author = {
	githubUrl: 'https://github.com/stas-sultanov'
	name: 'Stas Sultanov'
	profileUrl: 'https://www.linkedin.com/in/stas-sultanov'
}

/* parameters */

@description('Id of the OperationalInsights/Workspace resource.')
param OperationalInsights_workspaces__id string

@description('Id of the Sql/servers resource.')
param Sql_servers__id string

@description(
	'Id of the Sql/servers/databases resource which is used by different creation modes.'
)
param Sql_servers_databases_Source_id string = ''

@description('The mode of database creation.')
@allowed([ 'Default', 'Copy' ])
param createMode string = 'Default'

@description('Location to deploy the resource.')
param location string = resourceGroup().location

@description('Name of the resource.')
param name string

@description('Specifies the SKU of the sql database.')
@allowed(
	[
		'Basic'
		'S0'
		'S1'
		'S2'
		'GP_Gen5_2'
		'GP_Gen5_4'
		'GP_Gen5_6'
		'GP_S_Gen5_1'
		'GP_S_Gen5_2'
		'GP_S_Gen5_4'
	]
)
param sku string = 'Basic'

@description('Tags to put on the resource.')
param tags object

/* variables */

var databaseProperties = {
	Default: {
		createMode: 'Default'
	}
	Copy: {
		createMode: 'Copy'
		sourceDatabaseId: Sql_servers_databases_Source_id
	}
}

var operationalInsights_workspaces__id_split = split(
	OperationalInsights_workspaces__id,
	'/'
)

/* existing resources */

resource OperationalInsights_workspaces_ 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
	name: operationalInsights_workspaces__id_split[8]
	scope: resourceGroup(operationalInsights_workspaces__id_split[4])
}

resource Sql_servers_ 'Microsoft.Sql/servers@2023-02-01-preview' existing = {
	name: split(Sql_servers__id, '/')[8]
}

/* resources */

// resource info
// https://learn.microsoft.com/azure/templates/microsoft.sql/servers/databases
resource Sql_servers_databases_ 'Microsoft.Sql/servers/databases@2023-02-01-preview' = {
	location: location
	name: name
	parent: Sql_servers_
	properties: databaseProperties[createMode]
	sku: {
		name: sku
	}
	tags: tags
}

// resource info
// https://learn.microsoft.com/azure/templates/microsoft.sql/servers/databases/auditingsettings
resource Sql_servers_databases_auditingSettings_ 'Microsoft.Sql/servers/databases/auditingSettings@2023-02-01-preview' = {
	name: 'default'
	parent: Sql_servers_databases_
	properties: {
		isAzureMonitorTargetEnabled: true
		state: 'Enabled'
	}
}

// resource info
// https://learn.microsoft.com/azure/templates/microsoft.insights/diagnosticsettings
resource Insights_diagnosticSettings_ 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
	name: 'Log Analytics'
	properties: {
		logAnalyticsDestinationType: 'Dedicated'
		logs: [
			{
				categoryGroup: 'allLogs'
				enabled: true
			}
			{
				categoryGroup: 'audit'
				enabled: true
			}
		]
		metrics: [
			{
				enabled: true
				timeGrain: 'PT1M'
			}
		]
		workspaceId: OperationalInsights_workspaces_.id
	}
	scope: Sql_servers_databases_
}

/* outputs */

output resourceId string = Sql_servers_databases_.id
