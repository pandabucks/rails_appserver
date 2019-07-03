class HomeController < ApplicationController
    def root
        render plain: "AMAZON"
    end

    def secret
        authenticate_or_request_with_http_basic do |username, password|
            username == "amazon" && password == "candidate"
            render plain: "SUCCESS"
        end
    end
end