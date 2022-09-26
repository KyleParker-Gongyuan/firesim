
import boto3

from netaddr import IPNetwork # needed to get all ip's in a block
import sys


def dein_ip_umfang(this_subnet):
    """ the ip range of this subnet (cidrblock)"""
    range = str(this_subnet['CidrBlock'])
    print ("IP 笨蛋:\n{} ".format(range))




def ips_this_subnet(client, vpc_id, this_subnets, addresses, wanted_ip): #! I GOT THIS!!!!
    """all ips availabile in current this subnet"""
    
    '''  RANDOM COMMENTS
    #this_subnet = [this_subnet[startnumbz]]
    #regionz = 'us-east-1'

    #print ("\n")
    
    #client = boto3.client('ec2', region_name=regionz)
    #print(this_subnets)
    #hufa=input("paosjd:  ")
    
    #for vpc_subnet in this_subnets:
    
    #try:
    #    subnet_name = [
    #        t for t in vpc_subnet['Tags'] if t['Key'] == 'Name'][0]['Value']
    #except IndexError:
    
     '''
     
    subnet_name = "<none>"
    print("not gg")
    # this list consists of IPAddress objects
    #addresses = list(IPNetwork(this_subnets['CidrBlock']))
    
    print("ur shit works")
    # clean up first 4 and last 1 (reserved)
    del addresses[0:4]
    del addresses[-1]

    # create a list of strings containing ip addresses
    raw_addresses = [str(i) for i in addresses]
    print("nvr thid osdzcx")
    eni_response = client.describe_network_interfaces(
        Filters=[
            {
                'Name': 'vpc-id',
                'Values': [
                    vpc_id,
                ]
            },
            {
                'Name': 'subnet-id',
                'Values': [
                    this_subnets['SubnetId']
                ]
            },
        ]
    )
    enis = eni_response['NetworkInterfaces']
    for eni in enis:
        for ip in eni['PrivateIpAddresses']:
            if ip['PrivateIpAddress'] in raw_addresses:
                raw_addresses.remove(ip['PrivateIpAddress'])

    print ("\n-----")
    print ("Subnet Name: {} - Subnet ID: {} - AZ: {}".format(
        subnet_name,
        this_subnets['SubnetId'],
        this_subnets['AvailabilityZone']
    ))
    print ("Available Addresses Count: {}".format(
        this_subnets['AvailableIpAddressCount']))

    print ("Available Addresses:\n{}".format(', '.join(raw_addresses)))
    print ("-----\n")
    
    string_ip = input("type an available ip: ")
    wanted_ip = "%r"%string_ip
    return wanted_ip
    


def all_ips_in_this_vpc(client,vpc_id, wanted_ip):
    """all ips availabile in all subnets of this vpc"""
    
    #client = boto3.client('ec2', region_name=regionz)

    # will want to put the filters in here as well

    
    subnets = client.describe_subnets(
        Filters=[
            {
                'Name': 'vpc-id',
                'Values': [
                    vpc_id
                ]
            }
        ]
    )

    vpc_subnets = subnets['Subnets']
    if len(vpc_subnets) == 0:
        sys.exit("Could not find any subnets for VPC {}".format(vpc_id))

    for vpc_subnet in vpc_subnets: # is this needed?!?!?!
        #try:
        #    print("what is it ?:"+ vpc_subnet['Tags']) #? they dont have tags so is this pointless?
        #    subnet_name = [
        #        t for t in vpc_subnet['Tags'] if t['Key'] == 'Name'][0]['Value']
        #except IndexError:
        
        subnet_name = "<none>"
        print ("\tChoice: {index} -- {subnet_name} - {subnet_id}".format(
            index=vpc_subnets.index(vpc_subnet),
            subnet_name=subnet_name,
            subnet_id=vpc_subnet['SubnetId'])
    )
    
    for vpc_subnet in vpc_subnets:
        #try:
        #    subnet_name = [
        #        t for t in vpc_subnet['Tags'] if t['Key'] == 'Name'][0]['Value']
        #except IndexError:
        subnet_name = "<none>"
        
        # this list consists of IPAddress objects
        addresses = list(IPNetwork(vpc_subnet['CidrBlock']))
        nein_addresses = str(vpc_subnet['CidrBlock'])
        
        # clean up first 4 and last 1 (reserved)
        del addresses[0:4]
        del addresses[-1]

        # create a list of strings containing ip addresses
        raw_addresses = [str(i) for i in addresses]
        #der_raw_addresses = str(nein_addresses)
        private_ips = str()

        eni_response = client.describe_network_interfaces(
            Filters=[
                {
                    'Name': 'vpc-id',
                    'Values': [
                        vpc_id,
                    ]
                },
                {
                    'Name': 'subnet-id',
                    'Values': [
                        vpc_subnet['SubnetId']
                    ]
                },
            ]
        )
        enis = eni_response['NetworkInterfaces']
        for eni in enis:
            for ip in eni['PrivateIpAddresses']:
                if ip['PrivateIpAddress'] in raw_addresses:
                    
                    #private_ips.append(str(ip['PrivateIpAddress']))
                    #private_ips = str(ip['privateIpAddress'])
                    raw_addresses.remove(ip['PrivateIpAddress']) # this is know the public ip addresses only!
                    
                    # does this mean that we are only getting the public ip addresses?

        print ("\n-----")
        print ("Subnet Name: {} - Subnet ID: {} - AZ: {}".format(
            subnet_name,
            vpc_subnet['SubnetId'],
            vpc_subnet['AvailabilityZone']
        ))
        print ("Available Addresses Count: {}".format(
            vpc_subnet['AvailableIpAddressCount']))

        print ("Available Addresses:\n{}".format(', '.join(raw_addresses)))
        print ("-----\n")
        
        wanted_ip = input("type an available ip: ")
    return wanted_ip
        
def all_ips_of_all_vpcs(client, vpc_list): #! W.I.P
    """all the ips from all the vpc's that are in your custom list of firesim vpc's--W.I.P--"""
    #client = boto3.client('ec2', region_name=regionz)

    # will want to put the filters in here as well
    
    for vpc_index in vpc_list:

        subnets = client.describe_subnets(
            Filters=[
                {
                    'Name': 'vpc-id',
                    'Values': [
                        vpc_index
                    ]
                }
            ]
        )

        vpc_subnets = subnets['Subnets']
        if len(vpc_subnets) == 0:
            sys.exit("Could not find any subnets for VPC {}".format(vpc_index))

        for vpc_subnet in vpc_subnets:
            #try:
            #    print("what is it ?:"+ vpc_subnet['Tags']) #? they dont have tags so is this pointless?
            #    subnet_name = [
            #        t for t in vpc_subnet['Tags'] if t['Key'] == 'Name'][0]['Value']
            #except IndexError:
            subnet_name = "<none>"
            print ("\tChoice: {index} -- {subnet_name} - {subnet_id}".format(
                index=vpc_subnets.index(vpc_subnet),
                subnet_name=subnet_name,
                subnet_id=vpc_subnet['SubnetId'])
        )
        try:
            choice_input = raw_input
        except NameError:
            choice_input = input

        choice = choice_input('Choose a subnet (a for all):')

        try:
            choice_number = int(choice)
            if (choice_number < 0) or ((choice_number + 1) > len(vpc_subnets)):
                sys.exit("{} not a vaild choice".format(choice))
            vpc_subnets = [vpc_subnets[choice_number]]
        except ValueError:
            if choice == "a":
                pass
            else:
                sys.exit("{} not a vaild choice".format(choice))

        print ("\n")

        for vpc_subnet in vpc_subnets:
            #try:
            #    subnet_name = [
            #        t for t in vpc_subnet['Tags'] if t['Key'] == 'Name'][0]['Value']
            #except IndexError:
            subnet_name = "<none>"
            
            # this list consists of IPAddress objects
            addresses = list(IPNetwork(vpc_subnet['CidrBlock']))
            nein_addresses = str(vpc_subnet['CidrBlock'])
            
            # clean up first 4 and last 1 (reserved)
            del addresses[0:4]
            del addresses[-1]

            # create a list of strings containing ip addresses
            raw_addresses = [str(i) for i in addresses]
            #der_raw_addresses = str(nein_addresses)
            private_ips = str()

            eni_response = client.describe_network_interfaces(
                Filters=[
                    {
                        'Name': 'vpc-id',
                        'Values': [
                            vpc_index,
                        ]
                    },
                    {
                        'Name': 'subnet-id',
                        'Values': [
                            vpc_subnet['SubnetId']
                        ]
                    },
                ]
            )
            enis = eni_response['NetworkInterfaces']
            for eni in enis:
                for ip in eni['PrivateIpAddresses']:
                    if ip['PrivateIpAddress'] in raw_addresses:
                        
                        #private_ips.append(str(ip['PrivateIpAddress']))
                        #private_ips = str(ip['privateIpAddress'])
                        raw_addresses.remove(ip['PrivateIpAddress']) # this is know the public ip addresses only!
                        
                        # does this mean that we are only getting the public ip addresses?

            print ("\n-----")
            print ("Subnet Name: {} - Subnet ID: {} - AZ: {}".format(
                subnet_name,
                vpc_subnet['SubnetId'],
                vpc_subnet['AvailabilityZone']
            ))
            print ("Available Addresses Count: {}".format(
                vpc_subnet['AvailableIpAddressCount']))

            print ("Available Addresses:\n{}".format(', '.join(raw_addresses)))
            print ("-----\n")
            wanted_ip = input("type an available ip: ")
        return wanted_ip
