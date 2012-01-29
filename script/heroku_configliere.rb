#!/usr/bin/env ruby

require 'configliere'

Settings.read(File.expand_path("../config/app_private.yaml", File.dirname(__FILE__)))

vars = Settings.map{|k,v| "#{k.to_s.upcase}='#{v}'" }

system("heroku", "config:add", *vars)
