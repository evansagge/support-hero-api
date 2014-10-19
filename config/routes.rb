Rails.application.routes.draw do
  mount SupportHero::API::Base, at: '/'
end

