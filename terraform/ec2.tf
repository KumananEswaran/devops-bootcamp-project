data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd*/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "devops-bootcamp-key"
  public_key = file("~/.ssh/devops-bootcamp.pub")
}

# --- IAM: web server (SSM + ECR read-only) ---
resource "aws_iam_role" "web" {
  name               = "devops-web-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

resource "aws_iam_role_policy_attachment" "web_ssm" {
  role       = aws_iam_role.web.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "web_ecr" {
  role       = aws_iam_role.web.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "web" {
  name = "devops-web-profile"
  role = aws_iam_role.web.name
}

# --- IAM: controller (SSM only) ---
resource "aws_iam_role" "controller" {
  name               = "devops-controller-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

resource "aws_iam_role_policy_attachment" "controller_ssm" {
  role       = aws_iam_role.controller.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "controller" {
  name = "devops-controller-profile"
  role = aws_iam_role.controller.name
}

# --- IAM: monitoring (SSM only) ---
resource "aws_iam_role" "monitoring" {
  name               = "devops-monitoring-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

resource "aws_iam_role_policy_attachment" "monitoring_ssm" {
  role       = aws_iam_role.monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "monitoring" {
  name = "devops-monitoring-profile"
  role = aws_iam_role.monitoring.name
}

# --- EC2 instances ---
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = module.vpc.public_subnets[0]
  private_ip             = "10.0.0.5"
  vpc_security_group_ids = [module.public_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.web.name
  key_name               = aws_key_pair.deployer.key_name

  tags = { Name = "devops-web", Project = "devops-bootcamp-final-project" }
}

resource "aws_instance" "controller" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = module.vpc.private_subnets[0]
  private_ip             = "10.0.0.135"
  vpc_security_group_ids = [module.private_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.controller.name
  key_name               = aws_key_pair.deployer.key_name

  tags = { Name = "devops-controller", Project = "devops-bootcamp-final-project" }
}

resource "aws_instance" "monitoring" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = module.vpc.private_subnets[0]
  private_ip             = "10.0.0.136"
  vpc_security_group_ids = [module.private_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.monitoring.name
  key_name               = aws_key_pair.deployer.key_name

  tags = { Name = "devops-monitoring", Project = "devops-bootcamp-final-project" }
}

# --- Elastic IP (web server only) ---
resource "aws_eip" "web" {
  domain   = "vpc"
  instance = aws_instance.web.id

  tags = { Name = "devops-web-eip", Project = "devops-bootcamp-final-project" }
}
