module ABFab
  class Railtie < Rails::Railtie
    config.abfab = ABFab::Config.instance

    initializer 'abfab.helpers' do
      [:action_view, :action_controller].each do |hook|
        ActiveSupport.on_load hook do
          include ABFab::RailsId
          include ABFab::Helpers
        end
      end
    end
  end
end
