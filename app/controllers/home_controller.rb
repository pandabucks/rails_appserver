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
        ## 全部データを削除
        if params[:function] == "deleteall"
            Sale.delete_all
            Product.delete_all
        elsif params[:function] == "checkstock"
            if params[:name]
                products = Product.where(name: params[:name])
            else
                products = Product.all.order(name: :asc)
            end
            text = products.map{|product| "#{product.name}: #{product.amount}"}.join("\n")
            render plain: text and return
        elsif params[:function] == "addstock"
            render plain: "ERROR" and return unless params[:amount].match(/^[0-9]+$/)
            render plain: "ERROR" and return unless params[:name]
            name = params[:name]
            amount = params[:amount] || 1
            Product.create(name: name, amount: amount)
        elsif params[:function] == "sell"
            render plain: "ERROR" and return unless params[:name]
            render plain: "ERROR" and return unless params[:amount]&.match(/^[0-9]+$/)
            order_amount = params[:amount].to_i || 1
            price = params[:price].to_i || 0
            product = Product.where(name: params[:name]).first
            render plain: "ERROR" and return unless product
            rest_amount = product.amount - order_amount
            product.update(amount: rest_amount)
            product.sales.create(price: 0, amount: order_amount, price: price)
        elsif params[:function] == "checksales"
            sum = Sale.all.map{|sale| sale.price * sale.amount}.sum()
            render plain: "sales: #{sum}" and return
        end
        render plain: ""
    end
end
