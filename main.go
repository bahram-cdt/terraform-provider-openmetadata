// Copyright (c) OpenMetadata Contributors
// SPDX-License-Identifier: Apache-2.0

//go:generate go run github.com/hashicorp/terraform-plugin-docs/cmd/tfplugindocs generate --provider-name openmetadata

package main

import (
	"context"
	"log"

	"github.com/hashicorp/terraform-plugin-framework/providerserver"
	"github.com/bahram-cdt/terraform-provider-openmetadata/internal/provider"
)

var (
	// These will be set by goreleaser or the build system.
	version string = "dev"
	commit  string = "none"
)

func main() {
	opts := providerserver.ServeOpts{
		Address: "registry.terraform.io/bahram-cdt/openmetadata",
	}

	err := providerserver.Serve(context.Background(), provider.New(version), opts)
	if err != nil {
		log.Fatal(err.Error())
	}
}
