class JavascriptsController < ApplicationController
  def dynamic_url
    @urls = Menu.simple_controllers_and_actions
  end
end
