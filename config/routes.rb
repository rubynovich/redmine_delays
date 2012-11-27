if Rails::VERSION::MAJOR >= 3
  RedmineApp::Application.routes.draw do
    resources :delays
  end
else
  ActionController::Routing::Routes.draw do |map|
    map.resources :delays
  end
end
