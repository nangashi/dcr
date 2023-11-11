# # ECRリポジトリの作成
# resource "aws_ecr_repository" "jenkins" {
#   name = "jenkins"
# }

# # Image Builderのカスタムコンポーネントの作成
# resource "aws_imagebuilder_component" "jenkins_component" {
#   name          = "jenkins-component"
#   version = "1.0.0"  # バージョンを指定
#   platform      = "Linux"

#   # data {
#   #   # DockerイメージのURIを指定 (JenkinsのDockerイメージのURIを記入)
#   #   uri = "docker://jenkins/jenkins:lts"
#   # }
# }

# # Image Builderのカスタムレシピの作成
# resource "aws_imagebuilder_image_recipe" "jenkins_recipe" {
#   name          = "jenkins-recipe"
#   parent_image  = "jenkins/jenkins:lts"

#   components {
#     component_arn = aws_imagebuilder_component.jenkins_component.arn
#   }
# }

# # Image Builderのインフラストラクチャコンフィギュレーションの作成
# resource "aws_imagebuilder_infrastructure_configuration" "jenkins_infra_config" {
#   name = "jenkins-infra-config"
#   instance_profile_name = "image-builder-role"  # Image BuilderのIAMロールを指定

#   security_group_ids = ["sg-0123456789abcdef0"]  # 適切なセキュリティグループを指定
#   subnet_id          = "subnet-0123456789abcdef0"  # 適切なサブネットを指定

#   logging {
#     s3_logs {
#       s3_bucket_name = "my-image-builder-logs-bucket"  # ログを保存するS3バケットを指定
#       s3_key_prefix  = "jenkins-logs/"
#     }
#   }
# }

# # Image Builderプロジェクトの作成
# resource "aws_imagebuilder_distribution_configuration" "jenkins_distribution_config" {
#   name = "jenkins-distribution-config"
#   description = "Jenkins distribution configuration"

#   distributions {
#     region = "us-east-1"  # 配布先リージョンを指定
#     ami_distribution_configuration {
#       name = "jenkins-ami-distribution"
#       description = "Jenkins AMI distribution"
#       launch_permission {
#         user_ids = []
#         user_groups = []
#       }
#     }
#   }
# }

# # Image Builderのプライベートイメージの作成
# resource "aws_imagebuilder_image" "jenkins_image" {
#   name        = "jenkins-image"
#   recipe_arn  = aws_imagebuilder_image_recipe.jenkins_recipe.arn
#   distribution_configuration_arn = aws_imagebuilder_distribution_configuration.jenkins_distribution_config.arn
#   infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.jenkins_infra_config.arn
# }
