# Encoding: utf-8
#
# Cookbook Name:: cicd_infrastructure
# Definition:: sonar_plugin 
#
# Copyright (c) 2015 Grid Dynamics International, Inc. All Rights Reserved
# Classification level: Public
# Licensed under the Apache License, Version 2.0.
#

define :sonar_plugin, :version => '1.0', :group => false, :repo_url => false, :download_url => false do

  if params[:download_url]
    download_url = params[:download_url]
  else
    repo_url = params[:repo_url] ? params[:repo_url] : node[:sonarqube][:plugins_repo]
    if params[:group]
      download_url = "#{repo_url}/#{params[:group]}/#{params[:name]}/#{params[:version]}/#{params[:name]}-#{params[:version]}.jar"
    else
      download_url = "#{repo_url}/#{params[:name]}/#{params[:version]}/#{params[:name]}-#{params[:version]}.jar"
    end
  end

  download_path = "#{node[:sonarqube][:dir]}/#{node[:sonarqube][:downloads_dir]}/#{params[:name]}-#{params[:version]}.jar"
  install_path = "#{node[:sonarqube][:dir]}/#{node[:sonarqube][:plugins_dir]}/#{params[:name]}-#{params[:version]}.jar"

  remote_file download_path do
    source download_url
    owner 'root'
    group 'root'
    mode 00644
    notifies :restart, 'service[sonarqube]'
    not_if { ::File.exists?(install_path) }
  end

end
