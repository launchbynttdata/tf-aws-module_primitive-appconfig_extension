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

resource "aws_appconfig_extension" "extension" {
  name        = var.name
  description = var.description
  region      = var.region
  tags        = var.tags

  dynamic "action_point" {
    for_each = var.action_points
    content {
      point = action_point.value.point

      dynamic "action" {
        for_each = action_point.value.actions
        content {
          name        = action.value.name
          uri         = action.value.uri
          description = action.value.description
          role_arn    = action.value.role_arn
        }
      }
    }
  }

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name        = parameter.value.name
      description = parameter.value.description
      required    = parameter.value.required
    }
  }
}
