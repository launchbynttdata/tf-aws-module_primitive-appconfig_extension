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

output "id" {
  description = "The extension ID."
  value       = aws_appconfig_extension.extension.id
}

output "arn" {
  description = "The ARN of the extension."
  value       = aws_appconfig_extension.extension.arn
}

output "name" {
  description = "The name of the extension."
  value       = aws_appconfig_extension.extension.name
}

output "version" {
  description = "The extension version."
  value       = aws_appconfig_extension.extension.version
}

output "description" {
  description = "The extension description."
  value       = aws_appconfig_extension.extension.description
}

output "action_points" {
  description = "The action points and actions defined for the extension."
  value       = aws_appconfig_extension.extension.action_point
}

output "parameters" {
  description = "The parameters accepted by the extension."
  value       = aws_appconfig_extension.extension.parameter
}
