# default route
MyApp.add_route('GET', '/*', {}) do
  cross_origin
  # the guts live here
  {}
end
