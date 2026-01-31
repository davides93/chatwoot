# Quick Start: Testing GitHub Models with Chatwoot

This guide helps you quickly test the GitHub Models integration with Chatwoot.

## Prerequisites

- GitHub account
- GitHub Personal Access Token with GitHub Models access
- Ruby installed (for test script)

## Quick Test (Without Chatwoot)

Test your GitHub Models connection before configuring Chatwoot:

```bash
# Run the test script
ruby script/test_github_models.rb YOUR_GITHUB_TOKEN

# Example:
ruby script/test_github_models.rb github_pat_11AEXAMPLE_REST_OF_YOUR_TOKEN
```

If successful, you'll see:

```
✅ SUCCESS! GitHub Models is working!
============================================================
Response from AI:
Connection successful!
============================================================

✨ Configuration verified! You can use these settings in Chatwoot:

   API Key: github_pat_11AE...abc123
   Endpoint URL: https://models.github.ai/inference
   Model Name: gpt-4o-mini
```

## Configure in Chatwoot

### Step 1: Get GitHub Token

1. Visit https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Give it a name: `Chatwoot AI Integration`
4. Select scopes (at minimum: access to GitHub Models)
5. Click "Generate token"
6. **Copy the token** immediately!

### Step 2: Add Integration to Chatwoot

1. Log in to Chatwoot as administrator
2. Go to **Settings** → **Integrations**
3. Find **OpenAI Compatible API**
4. Click **Connect**
5. Enter:
   - **API Key**: Your GitHub token (starts with `github_pat_`)
   - **Endpoint URL**: `https://models.github.ai/inference`
   - **Model Name**: `gpt-4o-mini` (or any model from [GitHub Models](https://github.com/marketplace/models))
   - **Show label suggestions**: ✓ (optional)
6. Click **Save**

### Step 3: Test in Chatwoot

1. Open any conversation
2. Start typing a reply
3. Select text and use AI features:
   - **Reply Suggestion**: Get AI-generated replies
   - **Summarize**: Summarize the conversation
   - **Improve Writing**: Enhance your message
   - **Fix Spelling**: Correct grammar and spelling

## Supported Models

Popular models available on GitHub Models:

| Model | Best For | Performance |
|-------|----------|-------------|
| `gpt-4o` | Complex tasks | Highest quality |
| `gpt-4o-mini` | General use | Balanced |
| `gpt-3.5-turbo` | Quick responses | Fast |
| `claude-3-5-sonnet-20241022` | Long context | High quality |
| `Mistral-large-2411` | Multilingual | Fast |
| `Phi-4` | Lightweight | Very fast |

See all models: https://github.com/marketplace/models

## Example Configurations

### Configuration 1: Cost-Effective
```
API Key: github_pat_YOUR_TOKEN
Endpoint URL: https://models.github.ai/inference
Model Name: gpt-4o-mini
```

### Configuration 2: High Quality
```
API Key: github_pat_YOUR_TOKEN
Endpoint URL: https://models.github.ai/inference
Model Name: gpt-4o
```

### Configuration 3: Anthropic Claude
```
API Key: github_pat_YOUR_TOKEN
Endpoint URL: https://models.github.ai/inference
Model Name: claude-3-5-sonnet-20241022
```

## Troubleshooting

### Connection Issues

**Problem**: "API key missing" error

**Solution**:
- Verify token is correctly copied (no extra spaces)
- Check token hasn't expired
- Ensure token has GitHub Models access

**Problem**: "Connection failed"

**Solution**:
```bash
# Test connectivity manually
curl https://models.github.ai/inference/v1/models \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Model Issues

**Problem**: "Model not found"

**Solution**:
- Check model name spelling
- Visit https://github.com/marketplace/models for available models
- Try `gpt-4o-mini` as default

### Rate Limits

**Problem**: "Too many requests"

**Solution**:
- Wait a few minutes before retrying
- Use a less resource-intensive model
- Check GitHub Models rate limits

## Advanced Usage

### Multiple Providers

You can configure multiple OpenAI-compatible integrations:

1. **GitHub Models** - For general AI features
2. **Azure OpenAI** - For enterprise requirements
3. **OpenRouter** - For model variety
4. **Self-hosted** - For privacy needs

Each maintains separate API keys and configurations.

### Custom System Prompts

Modify system prompts for better results:

```ruby
# In Rails console
hook = Integrations::Hook.find_by(app_id: 'openai_compatible')
# Modify settings as needed
hook.settings['model_name'] = 'gpt-4o'
hook.save!
```

## Security Notes

⚠️ **Important Security Practices**:

1. Never commit tokens to version control
2. Use environment variables for production
3. Rotate tokens regularly
4. Monitor usage for anomalies
5. Use minimum required permissions

## Resources

- 📖 [Full Documentation](GITHUB_MODELS_INTEGRATION.md)
- 🔗 [GitHub Models](https://github.com/marketplace/models)
- 💬 [Chatwoot Docs](https://www.chatwoot.com/docs)
- 🐛 [Report Issues](https://github.com/chatwoot/chatwoot/issues)

## Success Checklist

- [ ] GitHub token generated
- [ ] Test script runs successfully
- [ ] Integration configured in Chatwoot
- [ ] AI features working in conversations
- [ ] Model responding correctly

## Need Help?

1. Check the [troubleshooting section](#troubleshooting)
2. Review [full documentation](GITHUB_MODELS_INTEGRATION.md)
3. Ask in Chatwoot community forums
4. Open an issue on GitHub

---

**Ready to start?** Run the test script and configure your integration! 🚀

```bash
ruby script/test_github_models.rb YOUR_GITHUB_TOKEN
```
