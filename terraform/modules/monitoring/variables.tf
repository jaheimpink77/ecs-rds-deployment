variable "name" {
  description = "Name of resources created with the monitoring module"
  type = string
}

variable "alert_email" {
  description = "Email address that receives alarm and event notifications"
  type = string
}