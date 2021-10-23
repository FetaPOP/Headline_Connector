# frozen_string_literal: true

require 'http'
require 'yaml'

config = YAML.safe_load(File.read('config/secrets.yml'))

def yt_api_path(path)
  "https://www.googleapis.com/youtube/v3/#{path}"
end

def call_yt_url(config, url)
  HTTP.headers('Accept' => 'application/json').get(url)
end

yt_response = {}
yt_results = {}

## youtube videoID for testing
yt_video_id = "cmSbXsFE3l8" # https://www.youtube.com/watch?v=cmSbXsFE3l8

## HAPPY video request
yt_video_url = yt_api_path("videos?part=snippet&id=#{yt_video_id}&key=#{config['YOUTUBE_TOKEN']}")
yt_response[yt_video_url] = call_yt_url(config, yt_video_url)
video = yt_response[yt_video_url].parse # happy_video should be a hash

## Test happy_video
yt_results['id'] = video['items'][0]['id'] #should be "mSbXsFE3l8"
yt_results['title'] = video['items'][0]['snippet']['title'] # Should be "Anna Kendrick - Cups ..."
yt_results['description'] = video['items'][0]['snippet']['description'] # Should be the description of this song
yt_results['tags'] = video['items'][0]['snippet']['tags'] # Should be an array of tags
yt_results['channel'] = video['items'][0]['snippet']['channelTitle'] # should be "AnnaKendrickVEVO"
yt_results['channelId'] = video['items'][0]['snippet']['channelId'] # Should be "UCgqabVNmn6dTr66Oy_LP_VA"
yt_results['channelTitle'] = yt_results['channel'] # "channelTitle" and "channel" belongs to two different class

## BAD project request
yt_video_id = "cmSbXsFE3l7" # There wasn't a video with this video ID
yt_video_url = yt_api_path("videos?part=snippet&id=#{yt_video_id}&key=#{config['YOUTUBE_TOKEN']}")
yt_response[yt_video_url] = call_yt_url(config, yt_video_url)
yt_response[yt_video_url].parse # makes sure any streaming finishes

File.write('spec/fixtures/youtube_results.yml', yt_results.to_yaml)