# frozen_string_literal: true

require 'http'
require 'yaml'

YOUTUBE_TOKEN = YAML.safe_load(File.read('config/secrets.yml'))["test"]["YOUTUBE_TOKEN"]

def yt_api_path(path)
  "https://www.googleapis.com/youtube/v3/#{path}"
end

def call_yt_url(url)
  HTTP.headers('Accept' => 'application/json').get(url)
end

yt_response = {}
yt_results = {}

## youtube videoID for testing
yt_video_id = "Sa3KXgwkiO0" # https://www.youtube.com/watch?v=Sa3KXgwkiO0

## HAPPY video request
yt_video_url = yt_api_path("videos?part=snippet&id=#{yt_video_id}&key=#{YOUTUBE_TOKEN}")
yt_response[yt_video_url] = call_yt_url(yt_video_url)
video = yt_response[yt_video_url].parse # happy_video should be a hash

puts video.to_yaml

## Test happy_video
yt_results['id'] = video['items'][0]['id']
yt_results['title'] = video['items'][0]['snippet']['title']
yt_results['description'] = video['items'][0]['snippet']['description']
yt_results['tags'] = video['items'][0]['snippet']['tags']
yt_results['channel'] = video['items'][0]['snippet']['channelTitle']
yt_results['channelId'] = video['items'][0]['snippet']['channelId']
yt_results['channelTitle'] = yt_results['channel']

## BAD project request
yt_video_id = "cmSbXsFE3l7" # There wasn't a video with this video ID
yt_video_url = yt_api_path("videos?part=snippet&id=#{yt_video_id}&key=#{YOUTUBE_TOKEN}")
yt_response[yt_video_url] = call_yt_url(yt_video_url)
yt_response[yt_video_url].parse # makes sure any streaming finishes

File.write('spec/fixtures/youtube_results.yml', yt_results.to_yaml)