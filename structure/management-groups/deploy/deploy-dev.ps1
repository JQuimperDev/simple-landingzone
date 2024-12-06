az login

# la première fois on doit se donner accès au root management group
# az role assignment create --assignee "joel@jqdev.onmicrosoft.com" --scope "/" --role "Owner"

# créer les management groups
$deploymentName = "demo-dev-lz-mgmt-group-$(Get-Date -Format "yyyyMMddHHmmss")"
az deployment tenant create --location canadaeast --template-file ./main.bicep --parameters ./main.bicepparam --name $deploymentName