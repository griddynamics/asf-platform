# encoding: utf-8
require 'erb'
require 'json'
require 'aws-sdk'
require 'rubygems'
require 'berkshelf'
require 'bundler/setup'

# Can work with different setting for different envs
# Default env - dev
env = ENV['APP_ENV'] || 'dev'
config = JSON.parse(File.open('config.json').read)[env]
manifest_dir = config['manifests_dir'] || 'manifests'
scripts_dir = config['scripts_dir'] || 'scripts'

namespace :cookbooks do
  desc 'Upload cookbooks to S3'
  berksfile_path = 'cookbooks/cicd_infrastructure/Berksfile'
  task :upload do
    cookbook_tarball_path = '/tmp/cookbooks.tar.gz'
    berksfile = Berkshelf::Berksfile.from_file(berksfile_path)
    berksfile.package(cookbook_tarball_path)
    upload_to_s3(cookbook_tarball_path, config['bucket'])
    puts "http://#{config['bucket']}.s3.amazonaws.com/cookbooks.tar.gz"
  end
  desc 'Update cookbooks dependencies'
  task :update do
    berksfile = Berkshelf::Berksfile.from_file(berksfile_path)
    berksfile.update
  end
end

namespace :manifests do
  # Upload all *.yaml, *.yml files from manifest directory and all
  # subdirectories in specified S3 bucket
  desc 'Upload manifest into S3 bucket'
  task :upload do
    Dir[File.join(manifest_dir, '**', '*.{yaml,yml}')].each do |path|
      upload_to_s3(path, config['bucket'])
      puts "Upload #{File.basename(path)}: " \
          "http://#{config['bucket']}.s3.amazonaws.com/#{File.basename(path)}"
    end
  end

  # Takes template from manifests/templates and generane
  # template generated-<template_name> manifest
  desc 'Generate Qubell manifests from templates'
  task :generate do
    puts "Using components: #{config['components']}"
    Dir.glob("#{manifest_dir}/templates/*.yaml.erb") do |path|
      template = ERB.new(File.read(path), nil, '-')
      name = "generated-#{File.basename(path, '.*')}"
      puts "Generating #{name} from template..."
      File.write("manifests/#{name}", template.result(binding))
    end
  end
end

namespace :scripts do
  desc 'Upload scripts into S3 bucket'
  task :upload do
    Dir[File.join(scripts_dir, '**', '*')].each do |path|
      upload_to_s3(path, config['bucket'])
      puts "Upload #{File.basename(path)}: " \
          "http://#{config['bucket']}.s3.amazonaws.com/#{File.basename(path)}"
    end
  end

  # Takes template from manifests/templates and generane
  # template generated-<template_name> manifest
  desc 'Generate Qubell manifests from templates'
  task :generate do
    puts "Using components: #{config['components']}"
    Dir.glob("#{manifest_dir}/templates/*.yaml.erb") do |path|
      template = ERB.new(File.read(path), nil, '-')
      name = "generated-#{File.basename(path, '.*')}"
      puts "Generating #{name} from template..."
      File.write("manifests/#{name}", template.result(binding))
    end
  end
end

def upload_to_s3(path, bucket_name)
  fail AttributeError "File doesn't exists" unless File.exist? path
  s3 = Aws::S3::Client.new(
    access_key_id: ENV['AWS_ACCESS_KEY'],
    secret_access_key: ENV['AWS_SECRET_KEY']
  )
  s3.head_bucket(bucket: bucket_name)
  Aws::S3::Bucket.new(bucket_name).put_object(
    key: File.basename(path),
    body: File.open(path),
    acl: 'public-read')
end
