package main

import (
	"testing"
	"time"

	inttesting "github.com/cert-manager/acme-webhook-external-dns/internal/testing"
	acmetest "github.com/cert-manager/cert-manager/test/acme"
	"github.com/go-logr/logr/testr"
	"sigs.k8s.io/controller-runtime/pkg/log"
)

func TestRunsSuite(t *testing.T) {
	log.SetLogger(testr.New(t))

	// Create solver and registry that runs a background external-dns
	registry := inttesting.NewTestRegistry(t, ":59351", "example.com.")
	solver := inttesting.Solver{
		Solver:   &externalDNSProviderSolver{},
		Registry: registry,
	}

	// Uncomment the below fixture when implementing your custom DNS provider
	fixture := acmetest.NewFixture(&solver,
		acmetest.SetResolvedZone("example.com."),
		acmetest.SetAllowAmbientCredentials(false),
		acmetest.SetConfig(map[string]any{}),
		acmetest.SetDNSServer("127.0.0.1:59351"),
		acmetest.SetUseAuthoritative(false),
		acmetest.SetPropagationLimit(time.Second*30),
		acmetest.SetStrict(true),
	)

	// TODO: Uncomment RunConformance and delete RunBasic and RunExtended once https://github.com/cert-manager/cert-manager/pull/4835 is merged
	fixture.RunBasic(t)
	fixture.RunExtended(t)
	// fixture.RunConformance(t)
}
