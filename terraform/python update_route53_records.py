import boto3

def get_public_ips(cluster_name, service_name):
    ecs = boto3.client('ecs')
    tasks = ecs.list_tasks(cluster=cluster_name, serviceName=service_name)
    task_arns = tasks['taskArns']

    if not task_arns:
        return []

    describe_tasks = ecs.describe_tasks(cluster=cluster_name, tasks=task_arns)
    task_details = describe_tasks['tasks']

    ips = []
    for task in task_details:
        eni_ids = [attachment['details'][0]['value'] for attachment in task['attachments'] if attachment['type'] == 'ElasticNetworkInterface']
        ec2 = boto3.client('ec2')
        network_interfaces = ec2.describe_network_interfaces(NetworkInterfaceIds=eni_ids)
        for interface in network_interfaces['NetworkInterfaces']:
            if 'Association' in interface and 'PublicIp' in interface['Association']:
                ips.append(interface['Association']['PublicIp'])

    return ips

if __name__ == "__main__":
    cluster_name = 'my-cluster'
    strapi_service = 'strapi-service'
    react_service = 'react-service'
    zone_id = 'Z06607023RJWXGXD2ZL6M'

    strapi_ips = get_public_ips(cluster_name, strapi_service)
    react_ips = get_public_ips(cluster_name, react_service)

    print(f"Strapi IPs: {strapi_ips}")
    print(f"React IPs: {react_ips}")
