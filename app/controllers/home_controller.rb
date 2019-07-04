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

    def calc
        is_match = request.url.match(/\?.*/)

        # ?でパラメータが渡ってこない場合
        render plain: "ERROR" and return unless is_match
        calc = request.url.match(/\?.*/)[0][1..-1]

        # +, -, /, *, (, ), 以外の文字列が入っていた場合はERRORを返す
        render plain: "ERROR" and return unless calc.match(/\d[*()+-\/]/)
        begin
            result = eval(calc)
        rescue
            render plain: "ERROR" and return
        end
        render plain: result
    end

    def stocker
        render plain: "hoge"
    end
end
