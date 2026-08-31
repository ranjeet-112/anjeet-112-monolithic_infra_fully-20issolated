package test

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestMonolithicInfra(t *testing.T) {

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../ToDo_infra",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Fetch outputs
	rgName := terraform.Output(t, terraformOptions, "resource_group_name")
	vnetName := terraform.Output(t, terraformOptions, "vnet_name")
	vmName := terraform.Output(t, terraformOptions, "vm_name")
	pip := terraform.Output(t, terraformOptions, "public_ip")

	// VALIDATIONS

	assert.Contains(t, rgName, "rg")
	assert.Contains(t, vnetName, "vnet")

	assert.NotEmpty(t, vmName)
	assert.Contains(t, vmName, "vm")

	assert.NotEmpty(t, pip)
}
