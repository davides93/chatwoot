#!/usr/bin/env ruby
# frozen_string_literal: true

# Test script for GitHub Models integration with Chatwoot
# Usage: ruby script/test_github_models.rb <github_token>
#
# This script tests the connection to GitHub Models API
# to verify it works with Chatwoot's OpenAI-compatible integration

require 'net/http'
require 'json'
require 'uri'

def test_github_models(token)
  puts "🔍 Testing GitHub Models API connection..."
  puts "=" * 60

  endpoint = 'https://models.github.ai/inference/v1/chat/completions'
  
  uri = URI(endpoint)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.read_timeout = 30

  request = Net::HTTP::Post.new(uri.path)
  request['Content-Type'] = 'application/json'
  request['Authorization'] = "Bearer #{token}"

  payload = {
    model: 'gpt-4o-mini',
    messages: [
      {
        role: 'system',
        content: 'You are a helpful assistant for testing API connectivity.'
      },
      {
        role: 'user',
        content: 'Say "Connection successful!" if you can read this message.'
      }
    ],
    max_tokens: 50,
    temperature: 0.7
  }

  request.body = payload.to_json

  puts "📤 Sending test request to GitHub Models..."
  puts "   Endpoint: #{endpoint}"
  puts "   Model: gpt-4o-mini"
  puts "   Token: #{token[0..15]}...#{token[-4..-1]}" if token
  puts

  begin
    response = http.request(request)
    
    case response.code.to_i
    when 200
      data = JSON.parse(response.body)
      message = data.dig('choices', 0, 'message', 'content')
      
      puts "✅ SUCCESS! GitHub Models is working!"
      puts "=" * 60
      puts "Response from AI:"
      puts message
      puts "=" * 60
      puts
      puts "✨ Configuration verified! You can use these settings in Chatwoot:"
      puts
      puts "   API Key: #{token[0..15]}...#{token[-4..-1]}"
      puts "   Endpoint URL: https://models.github.ai/inference"
      puts "   Model Name: gpt-4o-mini"
      puts
      puts "📝 Next steps:"
      puts "   1. Go to Chatwoot Settings → Integrations"
      puts "   2. Find 'OpenAI Compatible API'"
      puts "   3. Enter the configuration above"
      puts "   4. Save and start using AI features!"
      puts
      
      return true
    when 401
      puts "❌ AUTHENTICATION FAILED"
      puts "=" * 60
      puts "Error: Invalid or expired GitHub token"
      puts
      puts "Please check:"
      puts "  • Token is correctly copied"
      puts "  • Token has appropriate permissions"
      puts "  • Token hasn't expired"
      puts
      puts "Get a new token at: https://github.com/settings/tokens"
      
      return false
    when 403
      puts "❌ ACCESS DENIED"
      puts "=" * 60
      puts "Error: Token doesn't have permission to access GitHub Models"
      puts
      puts "Please ensure:"
      puts "  • You have access to GitHub Models preview"
      puts "  • Your token has the required scopes"
      
      return false
    when 429
      puts "⚠️  RATE LIMIT EXCEEDED"
      puts "=" * 60
      puts "Too many requests. Please wait a moment and try again."
      
      return false
    else
      puts "❌ ERROR: HTTP #{response.code}"
      puts "=" * 60
      puts "Response body:"
      puts response.body
      
      return false
    end
  rescue StandardError => e
    puts "❌ CONNECTION ERROR"
    puts "=" * 60
    puts "Error: #{e.class} - #{e.message}"
    puts
    puts "Please check:"
    puts "  • Your internet connection"
    puts "  • GitHub Models service status"
    puts "  • Firewall or proxy settings"
    
    return false
  end
end

def print_usage
  puts "GitHub Models Integration Test for Chatwoot"
  puts "=" * 60
  puts
  puts "Usage:"
  puts "  ruby script/test_github_models.rb <github_token>"
  puts
  puts "Example:"
  puts "  ruby script/test_github_models.rb github_pat_11AEXAMPLE..."
  puts
  puts "Get your GitHub token at:"
  puts "  https://github.com/settings/tokens"
  puts
end

# Main execution
if ARGV.empty?
  print_usage
  exit 1
end

token = ARGV[0]

if token.nil? || token.empty?
  puts "❌ Error: GitHub token is required"
  puts
  print_usage
  exit 1
end

success = test_github_models(token)
exit(success ? 0 : 1)
