class View
  VIEW_PATH = File.join File.dirname(__FILE__), 'view.html.haml'

  def self.render
    @investments = Investment.order('cost DESC')
    @organizations = Organization.all

    ::Haml::Engine.new(File.read(VIEW_PATH), :filename => 'view.html.haml').render(self)
  end
end
