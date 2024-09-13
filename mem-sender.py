import boto3
import time
import subprocess

# Initialize CloudWatch client
cloudwatch = boto3.client('cloudwatch', region_name='ap-southeast-1')

# Define parameters
namespace = "custom/ns1"
metric_name = "mem-usage-test"
instance_name = "myinstance"
interval = 2  # seconds
duration = 10 * 60  # 10 minutes in seconds

# Calculate the end time
start_time = time.time()
end_time = start_time + duration

while time.time() < end_time:
    # Get the memory usage
    result = subprocess.run(['free'], capture_output=True, text=True)
    output = result.stdout
    mem_usage = int(output.split()[9])  # Adjust according to your output format

    # Put the metric data
    cloudwatch.put_metric_data(
        Namespace=namespace,
        MetricName=metric_name,
        Value=mem_usage,
        Unit='Percent',
        Dimensions=[
            {'Name': 'InstanceName', 'Value': instance_name}
        ]
    )
    
    # Wait for the specified interval
    time.sleep(interval)