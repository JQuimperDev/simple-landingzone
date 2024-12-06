az login
az account list -o table

az deployment sub create --location 'canadacentral' --template-file ./main.bicep --parameters .\main.bicepparam