// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

# -----------------------------------------------------------------------------
# Required
# -----------------------------------------------------------------------------

variable "name" {
  description = "Name of the AppConfig extension. Must be 1 to 64 characters."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 64
    error_message = "Name must be between 1 and 64 characters."
  }
}

variable "action_points" {
  description = "Action points and actions for the extension. Each action point must include at least one action."
  type = list(object({
    point = string
    actions = list(object({
      name        = string
      uri         = string
      description = optional(string)
      role_arn    = optional(string)
    }))
  }))
  validation {
    condition     = length(var.action_points) >= 1
    error_message = "At least one action point is required."
  }
  validation {
    condition     = alltrue([for action_point in var.action_points : length(action_point.actions) >= 1])
    error_message = "Each action point must include at least one action."
  }
  validation {
    condition = alltrue([
      for action_point in var.action_points : contains([
        "PRE_CREATE_HOSTED_CONFIGURATION_VERSION",
        "PRE_START_DEPLOYMENT",
        "AT_DEPLOYMENT_TICK",
        "ON_DEPLOYMENT_START",
        "ON_DEPLOYMENT_STEP",
        "ON_DEPLOYMENT_BAKING",
        "ON_DEPLOYMENT_COMPLETE",
        "ON_DEPLOYMENT_ROLLED_BACK",
      ], action_point.point)
    ])
    error_message = "Each action point must be a documented AppConfig extension point."
  }
}

# -----------------------------------------------------------------------------
# Optional
# -----------------------------------------------------------------------------

variable "description" {
  description = "Description of the AppConfig extension. Must be at most 1024 characters."
  type        = string
  default     = null

  validation {
    condition     = var.description == null ? true : length(var.description) <= 1024
    error_message = "Description must be at most 1024 characters."
  }
}

variable "parameters" {
  description = "Parameters accepted by the extension."
  type        = list(object({ name = string, description = optional(string), required = optional(bool) }))
  default     = []
}

variable "region" {
  description = "AWS Region where this resource is managed. Defaults to the provider-configured Region."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource. Up to 50 tags are allowed; tag keys must be 1 to 128 characters and values must be at most 256 characters."
  type        = map(string)
  default     = {}

  validation {
    condition = length(var.tags) <= 50 && alltrue([
      for key, value in var.tags : length(key) >= 1 && length(key) <= 128 && length(value) <= 256
    ])
    error_message = "Tags must contain at most 50 entries. Tag keys must be 1 to 128 characters and values must be at most 256 characters."
  }
}
