template '404.html', 'public/404.html'
template '422.html', 'public/422.html'
template 'error.html', 'public/error.html'
template 'maintenance.html', 'public/maintenance.html'

rakefile 'pages.rake' do
  <<~RUBY
    desc 'Upload error and maintenance pages to S3'
    task :pages, %i[bucket] => %i[pages:error pages:maintenance]

    namespace :pages do
      desc 'Upload maintenance page to S3'
      task :error, %i[bucket] => :environment do |t, args|
        args.with_defaults bucket: ENV['AWS_BUCKET']

        puts "Uploading error.html to \#{args[:bucket]}"
        uploader = Aws::S3::FileUploader.new
        uploader.upload File.open(Rails.root.join('public', 'error.html')),
          bucket: args[:bucket], key: 'error.html', acl: 'public-read'
      end

      desc 'Upload maintenance page to S3'
      task :maintenance, %i[bucket] => :environment do |t, args|
        args.with_defaults bucket: ENV['AWS_BUCKET']

        puts "Uploading maintenance.html to \#{args[:bucket]}"
        uploader = Aws::S3::FileUploader.new
        uploader.upload File.open(Rails.root.join('public', 'maintenance.html')),
          bucket: args[:bucket], key: 'maintenance.html', acl: 'public-read'
      end
    end
  RUBY
end

@todo << 'Set AWS_BUCKET, AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY'
