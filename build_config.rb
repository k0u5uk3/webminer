def gem_config(conf)
  conf.gembox 'full-core'

  # be sure to include this gem (the cli app)
  conf.gem File.expand_path(File.dirname(__FILE__))

  conf.gem :git => 'https://github.com/mttech/mruby-getopts.git'
  conf.gem :git => 'https://github.com/matsumoto-r/mruby-httprequest.git'
  conf.gem :github => "kou/mruby-pp"

end

MRuby::Build.new do |conf|
  toolchain :gcc

  conf.enable_bintest
  conf.enable_debug
  conf.enable_test

  gem_config(conf)
end
