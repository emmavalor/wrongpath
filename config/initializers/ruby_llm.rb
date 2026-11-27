RubyLLM.configure do |config|
  config.openai_api_key = ENV["LLM_KEY"]
  config.default_model = "gpt-5-nano"
end
