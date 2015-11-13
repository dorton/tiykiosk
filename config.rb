require 'ostruct'
require "json"
require 'open-uri'
require 'date'
require 'active_support/all'
require 'mechanize'
require 'google/api_client'
require 'google_drive'


helpers do

    def fetch_meetups
        json = open("https://api.meetup.com/2/events?&sign=true&photo-host=public&venue_id=23753432&page=20&key=326e493f58383976434f5963243a5e&callback=?").read
        JSON.parse(json, object_class: OpenStruct)["results"]
    end

    def all_meetups
      @all_meetups ||= fetch_meetups
    end

    def meetups_this_week
      all_meetups.select {|t| t["time"] >= Time.now.beginning_of_week(start_day = :sunday).to_i*1000 && Time.now.end_of_week(end_day = :saturday).to_i*1000 >= t["time"] }
    end

    def fetch_meetups_worth_going
      json = open("https://api.meetup.com/2/events?member_id=100501792&offset=0&format=json&limited_events=False&photo-host=public&page=20&fields=&order=time&desc=false&status=upcoming&sig_id=100501792&sig=a16f1f16f21e97938877eb5d4bb2a1399739a0bb").read
      JSON.parse(json, object_class: OpenStruct)["results"]
    end

    def all_meetups_worth_going
      @meetups_worth ||= fetch_meetups_worth_going
    end

    def meetups_worth_this_week
      all_meetups_worth_going.select {|t| t["time"] >= Time.now.beginning_of_week(start_day = :sunday).to_i*1000 && Time.now.end_of_week(end_day = :sunday).to_i*1000 >= t["time"] }
    end


    def comic_url
      url = 'http://www.commitstrip.com/en/'
      agent = Mechanize.new
      page = agent.get(url)

      detail_page = agent.click page.at(".excerpts .excerpt a")
      detail_page.at(".entry-content img")['src']

    end

    def fetch_speakers
      json = open("https://tiyspeakers.herokuapp.com/api/v1/speakers").read
      JSON.parse(json, object_class: OpenStruct)["speakers"]
    end


    def all_speakers
      @all_speakers ||= fetch_speakers
    end

    def this_week_speaker

      all_speakers.select do |t|
        talk_date = t["date"] || "3000-02-02".to_date.strftime('%m/%d/%Y')
        talk_date >= Time.now.beginning_of_week(start_day = :sunday).strftime('%m/%d/%Y') && Time.now.end_of_week(end_day = :saturday).strftime('%m/%d/%Y') >= talk_date
      end.sort_by {|date| date.date}
    end

    def fetch_all_demos
      json = open("https://tiydemoday.herokuapp.com/api/v1/students").read
      JSON.parse(json, object_class: OpenStruct)["students"]
    end

    def all_demos
      @all_demos ||= fetch_all_demos
    end

    def demo
      all_demos.select {|t| t["cohort_id"] == 16 }.sort_by {|lastname| lastname["name"].split(" ").last}
    end

end


###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  set :http_prefix, "/tiykiosk/"
end

activate :deploy do |deploy|
  deploy.method = :git
  # Optional Settings
  # deploy.remote   = 'git@github.com:dorton/tiykiosk.git' # remote name or git url, default: origin
  # deploy.branch   = 'custom-branch' # default: gh-pages
  # deploy.strategy = :submodule      # commit strategy: can be :force_push or :submodule, default: :force_push
  # deploy.commit_message = 'custom-message'      # commit message (can be empty), default: Automated commit at `timestamp` by middleman-deploy `version`
end

ready do
  sprockets.import_asset 'reveal.js/plugin/markdown/markdown.js'
  sprockets.import_asset 'reveal.js/plugin/markdown/marked.js'
  sprockets.import_asset 'reveal.js/plugin/highlight/highlight.js'
end
