module ABFab
  module RailsId
    private

    def abfab_id
      session[:abfab_id] ||= -rand(2**31)
    end
  end
end
