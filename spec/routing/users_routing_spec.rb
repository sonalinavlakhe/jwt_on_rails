require "spec_helper"
require 'rails_helper'

describe "routing to users" do
  it "routes /users to users#create" do
   expect(post: "/users").to route_to(
    controller: "users",
    action: "create")
  end

  it "routes /users/1/confirm to users#confirm" do
   expect(post: "/users/1/confirm").to route_to(
    controller: "users",
    action: "confirm",
    user_id: "1")
  end

  it "routes /users/1/login to users#login" do
   expect(post: "/users/1/login").to route_to(
    controller: "users",
    action: "login",
    user_id: "1")
  end

  it "routes /users/1/update to users#update" do
   expect(put: "/users/1").to route_to(
    controller: "users",
    action: "update",
    id: "1")
  end

  it "routes /users/1/show to users#show" do
   expect(get: "/users/1").to route_to(
    controller: "users",
    action: "show",
    id: "1")
  end
end