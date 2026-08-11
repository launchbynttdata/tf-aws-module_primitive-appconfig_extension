package testimpl

import (
	"context"
	"strconv"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/appconfig"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// TestComposableComplete verifies the deployed AppConfig extension and exercises a reversible tag write.
func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	client, arn := verifyExtension(t, ctx)
	exerciseTagWrite(t, client, arn)
}

// TestComposableCompleteReadOnly verifies the deployed AppConfig extension using read-only AWS API calls.
func TestComposableCompleteReadOnly(t *testing.T, ctx types.TestContext) {
	verifyExtension(t, ctx)
}

func verifyExtension(t *testing.T, ctx types.TestContext) (*appconfig.Client, string) {
	opts := ctx.TerratestTerraformOptions()
	region := terraform.OutputContext(t, context.Background(), opts, "region")
	id := terraform.OutputContext(t, context.Background(), opts, "id")
	arn := terraform.OutputContext(t, context.Background(), opts, "arn")
	name := terraform.OutputContext(t, context.Background(), opts, "name")
	versionNumber := int32Output(t, ctx, "version")

	require.NotEqual(t, "", id)
	assert.Equal(t, terraform.OutputContext(t, context.Background(), opts, "expected_name"), name)

	client := appConfigClient(t, region)
	extension, err := client.GetExtension(context.Background(), &appconfig.GetExtensionInput{
		ExtensionIdentifier: aws.String(id),
		VersionNumber:       aws.Int32(versionNumber),
	})
	require.NoError(t, err)

	assert.Equal(t, id, aws.ToString(extension.Id))
	assert.Equal(t, arn, aws.ToString(extension.Arn))
	assert.Equal(t, name, aws.ToString(extension.Name))
	assert.Equal(t, versionNumber, extension.VersionNumber)

	return client, arn
}

func appConfigClient(t *testing.T, region string) *appconfig.Client {
	t.Helper()

	cfg, err := config.LoadDefaultConfig(context.Background(), config.WithRegion(region))
	require.NoError(t, err)

	return appconfig.NewFromConfig(cfg)
}

func exerciseTagWrite(t *testing.T, client *appconfig.Client, resourceARN string) {
	t.Helper()

	const tagKey = "codex-functional-test"
	_, err := client.TagResource(context.Background(), &appconfig.TagResourceInput{
		ResourceArn: aws.String(resourceARN),
		Tags:        map[string]string{tagKey: "true"},
	})
	require.NoError(t, err)

	_, err = client.UntagResource(context.Background(), &appconfig.UntagResourceInput{
		ResourceArn: aws.String(resourceARN),
		TagKeys:     []string{tagKey},
	})
	require.NoError(t, err)
}

func int32Output(t *testing.T, ctx types.TestContext, name string) int32 {
	t.Helper()

	value, err := strconv.ParseInt(terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), name), 10, 32)
	require.NoError(t, err)

	return int32(value)
}
