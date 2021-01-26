############# builder
FROM golang:1.14.9 AS builder

WORKDIR /go/src/github.com/gardener/gardener-extension-provider-openstack
COPY . .
COPY hack/install.sh /go/src/github.com/gardener/gardener-extension-provider-openstack/vendor/github.com/gardener/gardener/hack/install.sh
RUN make install

############# base
FROM alpine:3.12.0 AS base

############# gardener-extension-provider-openstack
FROM base AS gardener-extension-provider-openstack

COPY charts /charts
COPY --from=builder /go/bin/gardener-extension-provider-openstack /gardener-extension-provider-openstack
ENTRYPOINT ["/gardener-extension-provider-openstack"]

############# gardener-extension-validator-openstack
FROM base AS gardener-extension-validator-openstack

COPY --from=builder /go/bin/gardener-extension-validator-openstack /gardener-extension-validator-openstack
ENTRYPOINT ["/gardener-extension-validator-openstack"]
