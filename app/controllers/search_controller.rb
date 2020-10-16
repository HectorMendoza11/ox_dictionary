# app/controllers/search_controller.rb
class SearchController < ApplicationController
    def index
    end

    def search
        definition = find_definition(params[:word])

        unless definition
            $msg = ""
            case @error
            when 400
                puts "Error: status code 400 = Bad Request"
                $msg = "The request was invalid or cannot be otherwise served. An accompanying error message will explain further."
            when 403
                puts "Error: status code 403 = Authentication failed"
                $msg = "The request failed due to invalid credentials, or you have reached your Application allowance."
            when 404
                puts "Error: status code 404 = Not Found"
                $msg = "No information available or the requested URL was not found on the server."
            when 414
                puts "Error: status code 414 = Request URI Too Long"
                $msg = "Your word_id exceeds the maximum 128 characters. Reduce the string that is passed to the API by calling only individual words."
            when 500
                puts "Error: status code 500 = Internal Server Error"
                $msg = "Something is broken. Please contact us so the Oxford Dictionaries API team can investigate."
            when 502
                puts "Error: status code 502 = Bad Gateway"
                $msg = "Oxford Dictionaries API is down or being upgraded."
            when 503
                puts "Error: status code 503 = Service Unavailable"
                $msg = "The Oxford Dictionaries API servers are up, but overloaded with requests. Please try again later."
            when 504
                puts "Error: status code 504 = Gateway timeout"
                $msg = "The Oxford Dictionaries API servers are up, but the request couldn’t be serviced due to some failure within our stack. Please try again later."
            else
                $msg = "Error: Undefined"
            end

            flash[:alert] = $msg 
            return render action: :index
        end

        @word = definition
    end

    private
    def request_api(url)
      response = Excon.get(
        url,
        headers: {
            "Accept": "application/json",
            "app_id": "c2e7b1fe",
            "app_key": "b41be5b3b08f91ebe3d849570f15c52a"
        }
      )
      if response.status != 200
        @error = response.status
        return nil
      else
        JSON.parse(response.body)
      end
    end

    def find_definition(name)
        request_api(
          "https://od-api.oxforddictionaries.com/api/v2/entries/en-gb/#{name}?strictMatch=false"
        )
    end
end