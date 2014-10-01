# Encoding: utf-8
require 'erb'
require 'json'
require 'aws/s3'
require 'rubygems'
require 'berkshelf'
require 'bundler/setup'

# Can work with different setting for different envs
# Default env - dev
env = ENV['APP_ENV'] || 'dev'
config = JSON.parse(File.open('config.json').read)["#{env}"]
manifest_dir = config['manifests_dir'] || 'manifests'
cookbooks_dir = config['cookbooks_dir'] || 'cookbooks'

namespace :cookbooks do
    desc 'Upload cookbooks to S3'
    task :upload do
        berksfile_path = 'cookbooks/cicd_infrastructure/Berksfile'
        cookbook_tarball_path = '/tmp/cookbooks.tar.gz'
        berksfile = Berkshelf::Berksfile.from_file(berksfile_path)
        berksfile.package(cookbook_tarball_path)
        upload_to_s3(cookbook_tarball_path, config['bucket'])
        puts "http://#{config['bucket']}.s3.amazonaws.com/cookbooks.tar.gz"
    end
end

namespace :manifests do
    # Upload all *.yaml, *.yml files from manifest directory and all
    # subdirectories in specified S3 bucket
    desc 'Upload manifest into S3 bucket'
    task :upload_s3 do
        Dir[File.join(manifest_dir, '**', '*.{yaml,yml}')].each do |path|
            upload_to_s3(path, config['bucket'])
            puts "Upload #{File.basename(path)}: " +
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
    raise AttributeError "File doesn't exists" unless File.exists? path
    s3 = AWS::S3.new(
        :access_key_id     => ENV["AWS_ACCESS_KEY"],
        :secret_access_key => ENV["AWS_SECRET_KEY"]
    )
    bucket = s3.buckets[bucket_name]
    raise AttributeError "Bucket doesn't exists" unless bucket.exists?
    bucket.objects.create(
        File.basename(path), File.open(path), :acl => :public_read)
end
