Authored by Stas Sultanov [ [linkedIn](https://www.linkedin.com/in/stas-sultanov) | [gitHub](https://github.com/stas-sultanov) | [mail](mailto:stas.sultanov@outlook.com) ]

# About

Collection of Microsoft Azure Bicep modules.

The modules are designed to be used for:
- Azure Bicep templates.
- general purpose IT solutions.

The modules are designed to create templates to provision full functional environments within Azure for DEVelopment and OPerationS purposes.

# Resources Aliases

Microsoft Azure uses aliases for names of the resources types.

Below is a table of well-known aliases and corresponding resource types names.

Alias | Resource Type
:-----|:-------------
App Configuration | Microsoft.AppConfiguration/configurationStores
AppService | Microsoft.Web/sites
AppService Plan | Microsoft.Web/serverfarms
Application Insights | Microsoft.Insights/components
Bot | Microsoft.BotService/botServices
Cosmos DB | Microsoft.DocumentDB/databaseAccounts
DataFactory | Microsoft.DataFactory/factories
Function | Microsoft.Web/sites
LogAnalytics workspace | Microsoft.OperationalInsights/workspaces
SQL Server | Microsoft.Sql/servers
SQL Database | Microsoft.Sql/servers/databases
Storage Account | Microsoft.Storage/storageAccounts
Storage Account Blob Service | Microsoft.Storage/storageAccounts/blobServices
Storage Account Container | Microsoft.Storage/storageAccounts/blobServices/containers

# Security

The modules aims to utilize latest security approaches.
This is why access to Azure Resources with Security Access Keys is disabled.
The modules uses Entra ID as one security provider for all Azure Resources and RBAC for granular Authorizations.

Below is a list of Azure Resource Types which utilize Entra ID for clients Authentication and Authorization.

- App Configuration
- Cosmos DB
- Application Insights
- SQL Server
- SQL Database
- Storage Account
- Storage Account Container

# Diagnostics

The modules aims to utilize **Log Analytics workspace** as one service for central management of logs and metrics.

Below is a list of Azure Resource Types which utilize **Log Analytics workspace** to store their logs and metrics.

- App Configuration
- Application Insights
- AppService
- AppService Plan
- Bot
- Cosmos DB
- DataFactory
- SQL Server
- SQL Database
- Storage Account
- Storage Account Blob Service
