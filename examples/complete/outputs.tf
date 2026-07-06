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
  value       = module.extension.id
}
output "arn" {
  description = "The ARN of the extension."
  value       = module.extension.arn
}
output "name" {
  description = "The name of the extension."
  value       = module.extension.name
}
output "version" {
  description = "The extension version."
  value       = module.extension.version
}
output "expected_name" {
  description = "Expected extension name."
  value       = module.resource_names["extension"].standard
}

output "region" {
  description = "The AWS Region where the example resources are deployed."
  value       = data.aws_region.current.region
}
