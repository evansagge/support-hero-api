module SupportHero
  module API
    class Base < Grape::API
      mount SupportHero::API::Users
    end
  end
end
