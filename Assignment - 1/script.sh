location = centralIndia
groupName = demoResourceGroup
ddosProtectionName = demoDDOS
virtualNetworkName = myVnet
SUBNETIDWEB = myWebSubnet
SUBNETIDBUISNESS = myBuisnessSubnet
SUBNETIDDATA = myDataSubnet
SUBNETIDJUMPBOX = myJumpboxSubnet
addressPrefix = 10.10.10.10/24
subnetWebTier = 10.10.1.0/24
subnetBuisnessTies = 10.10.2.0/24
subnetDataTier = 10.10.3.10/24
loadBalanceWB = myWBBalancer
loadBalanceBD = myBDBalancer
nicBuisness = myBuisnessNIC
nicData = myDataNIC




az group create --location $location --name $groupName

az network ddos-protection create --name $ddosProtectionName --resouce-group $groupName

az network vnet create --name $virtualNetworkName --resouce-group $groupName --address-prefix $addressPrefix --subnet-name default --ddos-protection $ddosProtectionName

# create 4 subnets
azure network vnet subnet create --name $SUBNETIDWEB --vnet-name myVnet --address-prefix 10.0.1.0/24

azure network vnet subnet create --name $SUBNETIDBUISNESS --vnet-name myVnet --address-prefix 10.0.1.0/24

azure network vnet subnet create --name $SUBNETIDDATA --vnet-name myVnet --address-prefix 10.0.1.0/24

azure network vnet subnet create --name $SUBNETIDJUMPBOX --vnet-name myVnet --address-prefix 10.0.1.0/24

# create availability-set
az vm availability-set create --name MyAvSet --resource-group $groupName --location  $location

# create network security group
az network nsg create --name nsg1 --resource-group $groupName --location $location

# create 2 load balancer
az network lb create \
    --resource-group $groupName \
    --name $loadBalanceWB \
    --sku standard \
    --frontend-ip-name $subnetWebTier \
    --backend-pool-name $subnetBuisnessTies   

az network lb create \
    --resource-group $groupName \
    --name $loadBalanceBD \
    --sku standard \
    --frontend-ip-name $subnetBuisnessTies \
    --backend-pool-name $subnetDataTier   

# create nic
az network nic create \
    --resource-group $groupName \
    --name $nicBuisness \
    --vnet-name $virtualNetworkName \
    --subnet $SUBNETIDBUISNESS \
    --lb-name $loadBalanceWB \

az network nic create \
    --resource-group $groupName \
    --name $nicData \
    --vnet-name $virtualNetworkName \
    --subnet $SUBNETIDDATA \
    --lb-name $loadBalanceBD \

#  create virtual machines
az vm create /
--resource-group $groupName /
--name vm1 /
--image debian /
--subnet $SUBNETIDWEB /
--data-disk-sizes-gb 10 10 /
--admin-username admin /
--admin-password admin

az vm create /
--resource-group $groupName /
--name vm2 /
--image debian /
--subnet $SUBNETIDWEB /
--data-disk-sizes-gb 10 10 /
--admin-username admin /
--admin-password admin

az vm create /
--resource-group $groupName /
--name vm3 /
--image debian /
--subnet $SUBNETIDWEB /
--data-disk-sizes-gb 10 10 /
--admin-username admin /
--admin-password admin


az vm create /
--resource-group $groupName /
--name vm4 /
--image debian /
--nics $nicBuisness
--subnet $SUBNETIDBUISNESS /
--data-disk-sizes-gb 10 10 /
--admin-username admin /
--admin-password admin

az vm create /
--resource-group $groupName /
--name vm5 /
--nics $nicBuisness
--image debian /
--subnet $SUBNETIDBUISNESS /
--data-disk-sizes-gb 10 10 /
--admin-username admin /
--admin-password admin

az vm create /
--resource-group $groupName /
--name vm6 /
--nics $nicBuisness
--image debian /
--subnet $SUBNETIDBUISNESS /
--data-disk-sizes-gb 10 10 /
--admin-username admin /
--admin-password admin


az vm create /
--resource-group $groupName /
--name vm7 /
--nics $nicData
--image debian /
--subnet $SUBNETIDDATA /
--data-disk-sizes-gb 10 10 /
--admin-username admin /
--admin-password admin

az vm create /
--resource-group $groupName /
--name vm8 /
--nic $nicData
--image debian /
--subnet $SUBNETIDDATA /
--data-disk-sizes-gb 10 10 /
--admin-username admin /
--admin-password admin