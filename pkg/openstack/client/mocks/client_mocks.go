// Code generated by MockGen. DO NOT EDIT.
// Source: github.com/gardener/gardener-extension-provider-openstack/pkg/openstack/client (interfaces: Factory,Compute)

// Package mocks is a generated GoMock package.
package mocks

import (
	reflect "reflect"

	client "github.com/gardener/gardener-extension-provider-openstack/pkg/openstack/client"
	gomock "github.com/golang/mock/gomock"
	servergroups "github.com/gophercloud/gophercloud/openstack/compute/v2/extensions/servergroups"
)

// MockFactory is a mock of Factory interface.
type MockFactory struct {
	ctrl     *gomock.Controller
	recorder *MockFactoryMockRecorder
}

// MockFactoryMockRecorder is the mock recorder for MockFactory.
type MockFactoryMockRecorder struct {
	mock *MockFactory
}

// NewMockFactory creates a new mock instance.
func NewMockFactory(ctrl *gomock.Controller) *MockFactory {
	mock := &MockFactory{ctrl: ctrl}
	mock.recorder = &MockFactoryMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use.
func (m *MockFactory) EXPECT() *MockFactoryMockRecorder {
	return m.recorder
}

// Compute mocks base method.
func (m *MockFactory) Compute(arg0 ...client.Option) (client.Compute, error) {
	m.ctrl.T.Helper()
	varargs := []interface{}{}
	for _, a := range arg0 {
		varargs = append(varargs, a)
	}
	ret := m.ctrl.Call(m, "Compute", varargs...)
	ret0, _ := ret[0].(client.Compute)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// Compute indicates an expected call of Compute.
func (mr *MockFactoryMockRecorder) Compute(arg0 ...interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Compute", reflect.TypeOf((*MockFactory)(nil).Compute), arg0...)
}

// Storage mocks base method.
func (m *MockFactory) Storage(arg0 ...client.Option) (client.Storage, error) {
	m.ctrl.T.Helper()
	varargs := []interface{}{}
	for _, a := range arg0 {
		varargs = append(varargs, a)
	}
	ret := m.ctrl.Call(m, "Storage", varargs...)
	ret0, _ := ret[0].(client.Storage)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// Storage indicates an expected call of Storage.
func (mr *MockFactoryMockRecorder) Storage(arg0 ...interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Storage", reflect.TypeOf((*MockFactory)(nil).Storage), arg0...)
}

// MockCompute is a mock of Compute interface.
type MockCompute struct {
	ctrl     *gomock.Controller
	recorder *MockComputeMockRecorder
}

// MockComputeMockRecorder is the mock recorder for MockCompute.
type MockComputeMockRecorder struct {
	mock *MockCompute
}

// NewMockCompute creates a new mock instance.
func NewMockCompute(ctrl *gomock.Controller) *MockCompute {
	mock := &MockCompute{ctrl: ctrl}
	mock.recorder = &MockComputeMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use.
func (m *MockCompute) EXPECT() *MockComputeMockRecorder {
	return m.recorder
}

// CreateServerGroup mocks base method.
func (m *MockCompute) CreateServerGroup(arg0, arg1 string) (*servergroups.ServerGroup, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "CreateServerGroup", arg0, arg1)
	ret0, _ := ret[0].(*servergroups.ServerGroup)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// CreateServerGroup indicates an expected call of CreateServerGroup.
func (mr *MockComputeMockRecorder) CreateServerGroup(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "CreateServerGroup", reflect.TypeOf((*MockCompute)(nil).CreateServerGroup), arg0, arg1)
}

// DeleteServerGroup mocks base method.
func (m *MockCompute) DeleteServerGroup(arg0 string) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "DeleteServerGroup", arg0)
	ret0, _ := ret[0].(error)
	return ret0
}

// DeleteServerGroup indicates an expected call of DeleteServerGroup.
func (mr *MockComputeMockRecorder) DeleteServerGroup(arg0 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "DeleteServerGroup", reflect.TypeOf((*MockCompute)(nil).DeleteServerGroup), arg0)
}

// GetServerGroup mocks base method.
func (m *MockCompute) GetServerGroup(arg0 string) (*servergroups.ServerGroup, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetServerGroup", arg0)
	ret0, _ := ret[0].(*servergroups.ServerGroup)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// GetServerGroup indicates an expected call of GetServerGroup.
func (mr *MockComputeMockRecorder) GetServerGroup(arg0 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetServerGroup", reflect.TypeOf((*MockCompute)(nil).GetServerGroup), arg0)
}

// ListServerGroups mocks base method.
func (m *MockCompute) ListServerGroups() ([]servergroups.ServerGroup, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "ListServerGroups")
	ret0, _ := ret[0].([]servergroups.ServerGroup)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// ListServerGroups indicates an expected call of ListServerGroups.
func (mr *MockComputeMockRecorder) ListServerGroups() *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "ListServerGroups", reflect.TypeOf((*MockCompute)(nil).ListServerGroups))
}