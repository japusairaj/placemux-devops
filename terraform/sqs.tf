#############################################
# Day 3 - Event Queue
# AWS SQS
#############################################

resource "aws_sqs_queue" "placemux_events" {
  name = "placemux-events"

  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600

  tags = {
    Name        = "placemux-events"
    Environment = "dev"
    Project     = "PlaceMux"
  }
}