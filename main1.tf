variable "Security_Groups" {
  type = list(object(
    {
      name        = string
      description = string
      ingress = optional(list(object({
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
      })), [
        {
          from_port   = 8080
          to_port     = 8080
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/8"]
      }])
  }))
  default = [
    {
      name        = "SecurityGroups-Web"
      description = "Security group for web servers"
      ingress = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    },
    {
      name        = "SecurityGroups-App"
      description = "Security group for application servers"
      ingress = [
        {
          from_port   = 8081
          to_port     = 8081
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/8"]
      }]
  }]
}

locals {
  SecurityGroups_description = lookup(
    [for sg in var.Security_Groups : sg if sg.name == "SecurityGroups-App"][0],
    "description",
  "")
}

output "my_value_output" {
  value = local.SecurityGroups_description
}