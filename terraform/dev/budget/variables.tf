variable "alert_email" {
  description = "Email address that receives budget notifications"
  type = string
}   

variable "limit_amount" {
  description = "Monthly cost limit in the account's billing currency"
  type = string
}