Hello Learners.

In our Terraform journey, today’s challenge takes a deep dive into Terraform blocks, provider configurations, and the use of variables to create reusable, scalable infrastructure code. We’ll also explore the concepts of outputs and locals, which help in managing complex configurations effectively.
Below is the brief outline of what to expect:

Terraform Block
Provider Block
Input Variables
Output Variables
Local Variables
File Structure Best Practices
Practical Task: VPC Setup

Pre-requisites
Before starting the challenge, ensure the following setup is complete:

Terraform Installed

Install Terraform on your local machine. Follow the official Terraform installation guide.
AWS CLI Installed and Configured

Install the AWS CLI: AWS CLI Installation Guide.
Configure AWS credentials:
aws configure
Set the AWS Access Key ID, Secret Access Key, and region.
IAM User with Sufficient Permissions

Ensure your AWS IAM user has permissions to create VPCs, subnets, internet gateways, and NAT gateways. Assign the AdministratorAccess policy or tailor permissions as needed.
Terraform Workspace

Create a directory for your Terraform project:
mkdir terraform-vpc && cd terraform-vpc
AWS Billing Note

Some resources (e.g., NAT Gateways) incur costs. Monitor your AWS usage in the AWS Billing Dashboard.

Concepts and Explanation:
Terraform Block
The Terraform block is the foundational configuration block in every Terraform module. It defines settings and behaviors that Terraform will apply when running configurations. Think of it as the "meta" configuration that dictates how Terraform interacts with its environment, providers, and backend.


Structure of the Terraform Block
A Terraform block typically contains these components:

required_providers: Specifies the providers needed by the module and their versions.
required_version: Specifies the Terraform CLI version(s) required to run this configuration.
backend (Optional): Configures the state storage backend, determining how Terraform stores and retrieves its state file.
Documentation link: 

Terraform Block Documentation


Key Elements of the Terraform Block
1. required_providers
This section lists the providers your Terraform configuration depends on and where Terraform should download them from. You can specify the version or range of versions for each provider.

Example:

terraform {
required_providers {
aws = {
source = "hashicorp/aws"
version = "~> 5.0"
}
}
}
Details:

source: Specifies the provider's location, often in the format namespace/provider.
Example: hashicorp/aws.
version: Specifies the provider version constraint using semantic versioning (~>, >=, etc.).
2. required_version
This field ensures your configuration is compatible with specific Terraform CLI versions. It is a best practice to specify this, as breaking changes in Terraform versions can affect your configurations.

Example:

terraform {
required_version = ">= 1.5.0"
}
Details:

Version constraints follow semantic versioning.
Useful operators include:
>=: Specifies the minimum version.
~>: Allows updates to patch versions but not major or minor versions.
3. backend (Optional)
The backend block configures where Terraform will store its state file. This is crucial for managing infrastructure state across teams and environments.

Default Backend: Local backend (stores terraform.tfstate locally).

Example of Local Backend:

terraform {
backend "local" {
path = "terraform.tfstate"
}
}
Example of Remote Backend:

terraform {
backend "s3" {
bucket = "my-terraform-state"
key = "global/s3/terraform.tfstate"
region = "us-east-1"
}
}
Details:

The backend block is optional, but using a remote backend like S3 or Consul is a best practice for collaborative workflows.
The local backend is ideal for standalone or learning scenarios.

Best Practices for the Terraform Block
Pin Terraform Version: Use required_version to lock the CLI version and avoid compatibility issues.
Pin Provider Versions: Use semantic versioning to control the provider version and avoid breaking changes.
Use Remote Backends: For production setups, prefer remote backends like S3, Azure Blob Storage, or Consul.
Organize Terraform Files: Follow best practices for file structure to keep your code modular and readable.

Example Terraform Block with Best Practices
terraform {
required_version = ">= 1.5.0" required_providers {
aws = {
source = "hashicorp/aws"
version = "~> 5.0"
}
} backend "local" {
path = "terraform.tfstate"
}
}


Provider Block
The provider block is a critical component in Terraform, responsible for interacting with APIs of cloud platforms, SaaS solutions, or other services. Providers bridge the gap between Terraform and the platform you're provisioning resources on.


What is a Provider?
A provider in Terraform is a plugin that defines which infrastructure platform or service Terraform will communicate with. Each provider is responsible for managing API interactions with the respective platform and provisioning resources.

Examples of providers include:

Cloud platforms: AWS, GCP, Azure.
Version control systems: GitHub, Bitbucket.
SaaS platforms: PagerDuty, Datadog.
Provider Block Documentation: 

Terraform Providers Overview


Key Concepts for Providers
Provider Installation:
Terraform automatically downloads the provider binary during initialization (terraform init).

Providers are hosted on Terraform Registry.
Provider Configuration:
A provider must be configured to establish a connection to the target platform. Configuration often involves setting authentication credentials and specifying regions.

Example (AWS Provider):
provider "aws" {
region = "us-east-1"
profile = "default"
}
Provider Requirements:
Each provider has specific requirements, including its source and version. You can pin a version or range of versions to ensure compatibility with your Terraform configurations.

Example of Version Constraints:

terraform {
required_providers {
aws = {
source = "hashicorp/aws"
version = "~> 5.0"
}
}
}
Why Version Constraints?
Ensures compatibility with Terraform syntax and avoids unintentional breaking changes during provider upgrades.

 Provider Requirements Documentation


Provider Configuration Details
Arguments for Configuration: Providers typically accept arguments like region, profile, or API keys, depending on the platform.

AWS Provider Example:

provider "aws" {
region = var.aws_region
access_key = var.aws_access_key
secret_key = var.aws_secret_key
}
Environment Variables:
Terraform supports setting provider credentials using environment variables. For AWS:

export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
Provider Configuration Documentation

Multiple Provider Instances: When working with multiple regions or accounts, you can define multiple instances of the same provider using an alias.

Example:

provider "aws" {
region = "us-east-1"
} provider "aws" {
alias = "west"
region = "us-west-2"
}
Use the alias in resource definitions:

resource "aws_instance" "example" {
provider = aws.west
ami = "ami-123456"
instance_type = "t2.micro"
}
Dynamic Provider Configuration:
Providers can use input variables to dynamically set configuration values like region or profile.

Example Using Variables:
variable "aws_region" {
default = "us-east-1"
} provider "aws" {
region = var.aws_region
}
Debugging Providers:
Terraform offers debugging options to diagnose issues with provider interactions. Enable debug logs using:

TF_LOG=DEBUG terraform apply

Best Practices for Providers
Use Version Pinning: Always specify a version for the provider to ensure compatibility.
Leverage Environment Variables: Store sensitive credentials (e.g., AWS keys) in environment variables instead of hardcoding them in your .tf files.
Validate Configuration: Use terraform validate to check if your provider block is correctly configured before applying changes.
Plan Before Apply: Use terraform plan to preview provider interactions with the platform.

Input Variables in Terraform
What are Input Variables?
Input variables allow you to customize and parameterize Terraform configurations. Instead of hardcoding values, you can define variables to make your code reusable and adaptable to different environments.

For example:

Use variables to set regions, instance types, or CIDR blocks.
Share a configuration across development, staging, and production environments by passing different values to variables.

Input Variable Syntax and Explanation
Example 1: Basic Variable Declaration

variable "region" {
type = string
default = "us-east-1"
description = "AWS region to deploy resources"
}
Explanation:

type: Specifies the variable type (e.g., string, number, bool, list, map, etc.).
default: Provides a default value (us-east-1) if no other value is supplied.
description: Documents the purpose of the variable.
Example 2: Variable with Validation

variable "instance_type" {
type = string
description = "Type of EC2 instance to launch"
validation {
condition = contains(["t2.micro", "t3.micro"], var.instance_type)
error_message = "Instance type must be either t2.micro or t3.micro."
}
}
Explanation:

Validation ensures the input is one of the allowed instance types (t2.micro or t3.micro).
If the input doesn’t meet the condition, Terraform returns the specified error message.

How Terraform Resolves Input Variable Values
Terraform allows values for variables to be set in multiple ways. The order of priority levels determines which value is used if multiple sources provide input. The priority (from highest to lowest) is:

CLI Flags: Variables provided with the -var or -var-file flags override all other sources.

Example:
terraform apply -var="region=us-west-2"
Environment Variables: Variables set as environment variables with the prefix TF_VAR_.

Example:
export TF_VAR_region=us-west-2
terraform apply
.tfvars Files: Values in a .tfvars or .tfvars.json file.

Example (terraform.tfvars file):
region = "us-west-2"
Default Values in Variable Blocks: If no other value is provided, Terraform uses the default specified in the variable block.


Input Variable Examples with Explanations
Example 1: Deploying an EC2 Instance
# variables.tf
variable "instance_type" {
type = string
default = "t2.micro"
description = "Type of EC2 instance to launch"
} variable "region" {
type = string
default = "us-east-1"
description = "AWS region"
}
# main.tf
provider "aws" {
region = var.region
} resource "aws_instance" "example" {
ami = "ami-12345678"
instance_type = var.instance_type
}
Explanation:

The instance_type variable determines the type of EC2 instance to launch.
The region variable specifies the AWS region for resource deployment.
These variables allow the configuration to be reused in different environments.

Example 2: Using Lists and Maps
# variables.tf
variable "availability_zones" {
type = list(string)
default = ["us-east-1a", "us-east-1b"]
} variable "tags" {
type = map(string)
default = {
"Environment" = "Development"
"Owner" = "Team A"
}
}
# main.tf
resource "aws_subnet" "example" {
count = length(var.availability_zones)
availability_zone = var.availability_zones[count.index]
cidr_block = "10.0.${count.index}.0/24"
tags = var.tags
}
Explanation:

availability_zones: A list of availability zones to create subnets. Terraform uses count to create one subnet per zone.
tags: A map to set common tags for resources.

Best Practices for Input Variables
Always Add Descriptions: Improve code readability and documentation.
Use Validation: Ensure input meets specific requirements to avoid runtime errors.
Parameterize Configurations: Replace hardcoded values with variables for flexibility.
Use .tfvars for Environment-Specific Values: Store environment-specific inputs in separate files (dev.tfvars, prod.tfvars).
 
Terraform Output Values
What are Output Values?
Output values in Terraform allow you to extract information from your Terraform configuration and make it available after the execution of a terraform apply or terraform plan command. They are typically used for:

Displaying useful information (e.g., IDs, IP addresses) in the terminal after applying a configuration.
Passing data between configurations when using Terraform modules.
Enabling automation tools to programmatically retrieve outputs.

Defining Output Values
Output values are defined in your Terraform configuration using the output block.

Basic Syntax
output "<NAME>" {
value = <EXPRESSION>
description = "Optional description of the output"
sensitive = <BOOLEAN>
condition = <OPTIONAL_CONDITION>
}
<NAME>: A unique name for the output.
value: The expression or data to be returned.
description (optional): A human-readable description of the output for documentation purposes.
sensitive (optional): Marks the output as sensitive to hide it in the CLI output (default: false).
depends_on (optional): Explicit dependencies for determining the output's order of evaluation.
Example: Basic Output
output "instance_public_ip" {
value = aws_instance.my_instance.public_ip
description = "The public IP of the instance"
}
Explanation:

Displays the public IP address of an EC2 instance (aws_instance.my_instance) after deployment.

Working with Outputs
Viewing Outputs
After running terraform apply, you can view outputs with:

terraform output
To display a specific output:

terraform output <NAME>

Advanced Concepts
Output Values as Sensitive
Mark an output as sensitive to prevent Terraform from printing it in the CLI:

output "db_password" {
value = aws_secretsmanager_secret.my_secret.secret_string
sensitive = true
}
When to Use:

For sensitive information like passwords, private keys, or secret tokens.
Prevents accidental exposure during automation or collaboration.

Output Dependencies
You can define explicit dependencies for outputs using depends_on:

output "final_instance_state" {
value = aws_instance.my_instance.state
depends_on = [aws_instance.my_instance]
description = "The final state of the EC2 instance"
}

Exporting Data Between Modules
Output values are crucial when modules need to share information. They act as the interface for a module to expose its results.

Example: Using Outputs from a Module

Module Configuration:

# Module: vpc/main.tf
resource "aws_vpc" "example" {
cidr_block = "10.0.0.0/16"
}
output "vpc_id" {
value = aws_vpc.example.id
description = "The ID of the VPC"
}
 
Root Module:
module "vpc" {
source = "./vpc"
}
output "vpc_id_from_module" {
value = module.vpc.vpc_id
}
Explanation:

The vpc module exposes its vpc_id using an output.
The root module retrieves this value using module.<MODULE_NAME>.<OUTPUT_NAME>.

Output Value Export
You can programmatically extract output values for automation.

Example: Using Terraform in CI/CD

# Export the VPC ID to an environment variable
export VPC_ID=$(terraform output -raw vpc_id)

Best Practices for Outputs
Use Descriptions: Always include a description for clarity, especially when collaborating with teams.
Mark Sensitive Outputs: Use sensitive = true for data like passwords or keys.
Limit Outputs: Only expose necessary values to reduce clutter and minimize risks.
Use Outputs for Automation: Make your Terraform configurations compatible with CI/CD pipelines by structuring outputs for easy access.
Combine Outputs: Simplify output management by combining multiple values into a map:
output "instance_details" {
value = {
instance_id = aws_instance.my_instance.id
public_ip = aws_instance.my_instance.public_ip
}
}
Example Use Case: A Comprehensive VPC Output
output "vpc_info" {
value = {
id = aws_vpc.example.id
cidr_block = aws_vpc.example.cidr_block
public_subnet = aws_subnet.public.id
private_subnet = aws_subnet.private.id
}
description = "Details of the created VPC and its subnets"
}
Explanation:

Consolidates multiple VPC-related values into a single output for easier retrieval.
Useful for debugging or sharing complex resource data.


By adhering to best practices and leveraging outputs effectively, you can create reusable, maintainable Terraform configurations that seamlessly integrate with your workflows.



Terraform Local Values

What are Local Values?

Local values in Terraform are variables that you define within your configuration to simplify complex expressions, reuse values, and avoid redundancy. Local values are similar to variables but are scoped to the configuration in which they are declared and cannot be set externally. They allow you to compute values based on other resources, outputs, or environment variables.

Defining Local Values

Local values are defined using the locals block, followed by a set of key-value pairs.

Basic Syntax

locals {
<NAME> = <EXPRESSION>
}
<NAME>: The name of the local value.
<EXPRESSION>: The value or computation assigned to the local value.
Example: Basic Local Value

locals { region = "us-west-2" }
Explanation:

Defines a local value region with the value "us-west-2".
This local value can be used throughout the Terraform configuration, but it is scoped only within this configuration.

Working with Local Values

Using Local Values

Local values can be referenced by their name anywhere within the configuration, just like other variables or resources.

resource "aws_instance" "example" {
ami = "ami-0c55b159cbfafe1f0"
instance_type = "t2.micro"
availability_zone = local.region # Using the local value here
}
Explanation:

The local value region is used to set the availability_zone for the aws_instance resource.

Advanced Concepts

Using Expressions with Locals

Local values can be used to simplify complex expressions and reuse calculations throughout your configuration.

locals {
instance_type = var.environment == "production" ? "t3.large" : "t3.micro"
}
Explanation:

Uses a ternary conditional expression to define the local value instance_type based on the value of the environment variable.
If environment is "production", the instance_type is set to "t3.large", otherwise, it defaults to "t3.micro".

Multiple Local Values

You can define multiple local values within a single locals block.

locals {
region = "us-east-1"
vpc_cidr_block = "10.0.0.0/16"
subnet_cidr = "10.0.1.0/24"
}
Explanation:

Three local values are defined: region, vpc_cidr_block, and subnet_cidr.
These values can be referenced throughout the configuration without repetition.

Using Local Values with Lists and Maps

Local values can be used to create and manage more complex data structures like lists and maps.

locals {
instance_sizes = ["t2.micro", "t2.medium", "t2.large"]
instance_map = {
"web" = "t2.micro",
"db" = "t2.large",
"app" = "t2.medium"
}
}
Explanation:

instance_sizes is a list of possible instance sizes.
instance_map is a map that associates the types of instances with their sizes.

Best Practices for Local Values

Avoid Redundancy: Use local values to avoid repeating the same values or expressions in multiple places within your configuration.
Keep Local Values Scoped: Remember that local values are scoped to the module or configuration in which they are defined. Don’t use locals for values that need to be accessed outside the current configuration. For those, use variables.
Simplify Expressions: Local values help in simplifying complex expressions, such as conditional logic or mathematical computations. It improves readability and maintainability of the configuration.
Documentation: Even though locals are typically self-explanatory, consider adding descriptions or comments for more complex calculations, especially when they affect multiple resources.

Use Case Example: Creating a VPC and Subnets

locals {
vpc_cidr = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
} resource "aws_vpc" "main" {
cidr_block = local.vpc_cidr
} resource "aws_subnet" "public" {
vpc_id = aws_vpc.main.id
cidr_block = local.public_subnet_cidr
availability_zone = "us-east-1a"
map_public_ip_on_launch = true
} resource "aws_subnet" "private" {
vpc_id = aws_vpc.main.id
cidr_block = local.private_subnet_cidr
availability_zone = "us-east-1b"
}
Explanation:

The local values vpc_cidr, public_subnet_cidr, and private_subnet_cidr are defined at the beginning.
These local values are then used to configure the VPC and two subnets, simplifying the configuration and preventing hardcoding the CIDR blocks in multiple places.

Limitations and Considerations

No External Access: Unlike input variables, local values cannot be set by users or external inputs. They are defined within the module and cannot be overridden or passed as arguments.
Single Scope: Local values are scoped to the module in which they are defined. If you need to access values outside the module, you should consider using output values or passing data via module inputs and outputs.
No Dynamic Evaluation: Local values are computed only once during the planning phase and cannot change dynamically based on runtime or user input.

When to Use Locals

When you want to simplify complex expressions within your Terraform configuration.
When you need to reuse computed values across multiple resources in a configuration without repeating the logic.
When you need to consolidate related values (such as CIDR blocks or instance types) into a structured format.


By using local values effectively, you can make your Terraform configurations cleaner, more efficient, and easier to maintain, especially in larger projects where the same values are used in multiple places.



Basic Terraform File Structure

Terraform configurations are organized in a specific file structure that allows you to manage infrastructure as code efficiently and cleanly. Adhering to a standard file structure is important for maintainability, readability, and collaboration. Below is an overview of the basic Terraform file structure and its components.

Key Terraform Files and Directories

Main Configuration File (main.tf)
Variables File (variables.tf)
Outputs File (outputs.tf)
Providers File (providers.tf)
Terraform Backend Configuration File (backend.tf)
Terraform State File (terraform.tfstate)
Terraform Plan File (terraform.tfplan)
Modules Directory (modules/)

1. main.tf (Main Configuration File)

This is the primary file where you define the resources, data sources, and infrastructure components. It contains the logic to create and manage infrastructure.

Example:

# main.tf
resource "aws_vpc" "main" {
cidr_block = "10.0.0.0/16"
} resource "aws_subnet" "subnet_a" {
vpc_id = aws_vpc.main.id
cidr_block = "10.0.1.0/24"
availability_zone = "us-west-2a"
} resource "aws_security_group" "allow_ssh" {
name = "allow_ssh"
description = "Allow SSH access" ingress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
}
Explanation:

The main.tf file contains all the resources that you will deploy using Terraform. Resources such as AWS VPC, Subnet, and Security Group are defined here.

2. variables.tf (Variables File)

This file is where you define input variables. These variables allow you to pass dynamic values to your configuration and can be overridden via command-line arguments, environment variables, or a terraform.tfvars file.

Example:

# variables.tf
variable "region" {
description = "The AWS region to deploy to"
type = string
default = "us-west-2"
} variable "instance_type" {
description = "Type of instance to deploy"
type = string
default = "t2.micro"
}
Explanation:

Variables like region and instance_type are defined in the variables.tf file. These can be used throughout the configuration in resources, and their values can be set at runtime.

3. outputs.tf (Outputs File)

This file is where you define the output values for your Terraform configuration. Output values are used to display important information after the infrastructure has been created, such as IP addresses or URLs.

Example:

# outputs.tf
output "vpc_id" {
description = "The ID of the VPC"
value = aws_vpc.main.id
} output "subnet_id" {
description = "The ID of the subnet"
value = aws_subnet.subnet_a.id
}
Explanation:

The outputs.tf file contains output variables like vpc_id and subnet_id, which provide important information after the infrastructure is provisioned. These outputs are accessible after applying the Terraform configuration.

4. providers.tf (Providers File)

The providers.tf file is where you configure the providers that Terraform will use to interact with various cloud services. Providers are responsible for managing the resources and communicating with the cloud APIs.

Example:

# providers.tf
provider "aws" {
region = var.region
}
Explanation:

In the providers.tf file, the AWS provider is configured. The region for AWS is taken from the region variable defined earlier in variables.tf.

5. backend.tf (Terraform Backend Configuration File)

The backend.tf file contains configurations for the Terraform backend. The backend determines how Terraform's state is stored and managed (e.g., locally or remotely in cloud storage like AWS S3).

Example:

# backend.tf
terraform {
backend "s3" {
bucket = "my-terraform-state-bucket"
key = "terraform.tfstate"
region = "us-west-2"
}
}
Explanation:

In the backend.tf file, we configure an S3 bucket as the backend for storing Terraform's state file. This helps in collaborating and sharing the state across teams.

6. terraform.tfstate (Terraform State File)

This file is automatically created by Terraform and stores the current state of your infrastructure. It contains all the information about the resources managed by Terraform, including resource IDs, dependencies, and metadata.

Important Note: This file should not be manually edited, and it should be versioned in a secure manner if using remote backends.

7. terraform.tfplan (Terraform Plan File)

This is the file that contains the planned changes that Terraform will make to your infrastructure. It is generated when you run terraform plan. This file is not usually checked into source control, as it is dynamically generated during the execution process.


8. modules/ (Modules Directory)

In Terraform, modules are a way to organize your infrastructure code into reusable components. A module is a collection of resources that are used together. You can use modules to encapsulate complexity, share common patterns, and avoid duplication.

Directory Structure for Modules:

modules/
├── network/
│ ├── main.tf
│ ├── variables.tf
│ └── outputs.tf
├── compute/
│ ├── main.tf
│ ├── variables.tf
│ └── outputs.tf
Explanation:

In the modules/ directory, we define reusable modules like network and compute. These modules contain Terraform configurations for networking components like VPCs and EC2 instances.

Folder Structure Example:

A basic Terraform project could have the following file structure:

my-terraform-project/
├── main.tf # Main configuration file
├── variables.tf # Variables file
├── outputs.tf # Outputs file
├── providers.tf # Providers file
├── backend.tf # Backend configuration
├── terraform.tfvars # Variable values file (optional)
└── modules/
├── network/
└── compute/

Best Practices for Terraform File Structure

Use Modules for Reusability: Break down your configuration into modules that can be reused across multiple environments.
Keep Files Organized: Keep your configuration files well-organized and separated by concerns (e.g., main.tf, variables.tf, outputs.tf, etc.).
Use a Backend for State Management: For larger teams and remote infrastructure, use a remote backend (e.g., AWS S3) to manage the Terraform state.
Environment-Specific Files: Use separate files or workspaces to handle different environments (e.g., dev.tfvars, prod.tfvars).
Version Control: Always store Terraform configuration files in version control systems like Git.
Consistent Naming Convention: Use consistent naming conventions for resources and modules to ensure clarity and ease of understanding.


By adhering to this file structure, you ensure that your Terraform code remains scalable, maintainable, and easy to collaborate on in teams. It will also be easier to manage when your infrastructure grows in complexity.



Practical Task: Create a VPC with Public and Private Subnets Using Terraform

Task Overview:

The goal of this challenge is to guide you through creating a Virtual Private Cloud (VPC) with public and private subnets using basic Terraform configuration. You will also set up necessary routing mechanisms for internet access and inter-subnet communication.

Prerequisites:

Terraform Installed: Make sure Terraform is installed on your machine. If not, you can refer to the Terraform Installation Guide.
AWS CLI Configured: Ensure the AWS CLI is configured on your system with access rights to create AWS resources.
AWS Account: You must have an active AWS account to create the resources in the cloud.
Instructions:

Define the VPC:

Start by creating a VPC with a specific CIDR block (e.g., 10.0.0.0/16).
Enable DNS support and DNS hostnames for the VPC.
Create Public Subnet:

Create a public subnet in one Availability Zone (AZ), specifying a CIDR block (e.g., 10.0.1.0/24).
Ensure that the subnet has the auto-assign public IP setting enabled, so instances in this subnet will have internet access.
Create Private Subnet:

Create a private subnet in the same AZ, with a CIDR block (e.g., 10.0.2.0/24).
Do not enable the auto-assign public IP setting for this subnet, as it should not have direct internet access.
Set up an Internet Gateway (IGW):

Create an Internet Gateway (IGW) and attach it to the VPC. This will allow resources in the public subnet to access the internet.
Configure Route Tables:

Create a route table for the public subnet with a route to the internet via the Internet Gateway.
For the private subnet, create a separate route table that uses a NAT Gateway to access the internet. The private subnet should route traffic to the NAT Gateway for internet access.
Create a NAT Gateway:

Create a NAT Gateway in the public subnet to allow instances in the private subnet to access the internet. The NAT Gateway will provide a secure internet connection for private resources.
Assign Subnets to Route Tables:

Associate the public subnet with the route table that routes traffic to the Internet Gateway.
Associate the private subnet with the route table that routes traffic to the NAT Gateway.
Output Information:

Create output variables to display the following information once the resources are created:
VPC ID
Public Subnet ID
Private Subnet ID
CIDR blocks for both subnets
File Structure:

Ensure your Terraform configuration follows the recommended structure for better organization:

my-terraform-vpc/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars
Considerations:

Networking:
The public subnet will have internet access via the Internet Gateway (IGW), while the private subnet will be isolated but can access the internet via the NAT Gateway.
Ensure that the routing is set up correctly for both subnets to enable the desired communication.
Cost Considerations:
VPC and Subnet creation is free, but certain resources may incur charges:
Internet Gateway (IGW) is free, but associated data transfer may incur charges.
NAT Gateway incurs charges for both the gateway itself and the data transfer.
Elastic IP (EIP) associated with the NAT Gateway will incur charges.
Always check the AWS Pricing Documentation for detailed pricing on resources used.
Task Steps:

Create Terraform configuration for the VPC, subnets, and other resources.
Define input variables in variables.tf for flexible configuration (e.g., CIDR blocks, availability zones).
Write output variables in outputs.tf to display the information about the resources created.
Run Terraform commands:
terraform init to initialize the configuration.
terraform plan to review the execution plan and make sure everything looks correct.
terraform apply to apply the configuration and provision the resources.
Check AWS Console to ensure the VPC, subnets, route tables, and NAT Gateway are created.
Clean up resources: Once you've finished with the task, use terraform destroy to tear down all the resources and avoid incurring unnecessary costs.


Learning Objectives:

Upon completion of this task, you will:

Learn how to configure a VPC with public and private subnets in AWS using Terraform.
Understand how to set up Internet Gateway (IGW) and NAT Gateway for internet access.
Gain hands-on experience in configuring route tables and associating them with subnets.
Learn how to use output variables to display important resource information.
Practice applying basic Terraform configuration and provisioning infrastructure.
Cost Considerations:

Creating a NAT Gateway and Elastic IP may incur charges in AWS. It's important to destroy the resources once the task is completed using terraform destroy to avoid ongoing costs.



Deliverables:

Terraform Configuration Files:

You need to submit the Terraform configuration files that you have created for this task. Ensure you have all the required configurations for the VPC, subnets (public and private), routes, and security groups.
Ensure the file structure follows the best practices (separate files for providers, variables, outputs, and backend configurations).
Terraform State Management: [Do not upload state file to the Git]

Make sure you’ve initialized Terraform (terraform init) and the state is being correctly managed as per your configuration.
If using a local backend, include the state file terraform.tfstate and terraform.tfstate.backup (if applicable) in the directory.
If using a remote backend, ensure that your backend.tf is correctly configured.
Outputs:

The output of the created VPC’s CIDR block, public subnet IDs, private subnet IDs, and any other relevant infrastructure details should be output via Terraform outputs.
