# GitHub Models Integration with Chatwoot

This document explains how to integrate [GitHub Models](https://github.com/marketplace/models) with Chatwoot using the OpenAI-compatible API integration.

## Overview

GitHub Models provides access to various AI models through an OpenAI-compatible API endpoint. With Chatwoot's new `openai_compatible` integration, you can easily connect GitHub Models to power AI features like:

- Reply suggestions
- Message summarization
- Spell checking and grammar fixes
- Message rephrasing
- Label classification
- And more!

## Prerequisites

1. A GitHub account
2. A GitHub Personal Access Token (classic) with appropriate permissions
3. Access to GitHub Models (currently in preview)

## Getting Your GitHub Token

1. Go to https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Give it a descriptive name like "Chatwoot AI Integration"
4. Select scopes (at minimum you need access to GitHub Models)
5. Click "Generate token"
6. **Important**: Copy your token immediately - you won't be able to see it again!

## Configuration in Chatwoot

### Via UI (Recommended)

1. Log in to your Chatwoot dashboard as an administrator
2. Navigate to **Settings** → **Integrations**
3. Find and click on **OpenAI Compatible API**
4. Click **Connect**
5. Fill in the following details:

   ```
   API Key: github_pat_YOUR_TOKEN_HERE
   Endpoint URL: https://models.github.ai/inference
   Model Name: gpt-4o-mini (or any supported GitHub Models model)
   Show label suggestions: ✓ (optional)
   ```

6. Click **Save** or **Connect**

### Available Models

GitHub Models provides access to various models. Some examples:

- `gpt-4o` - OpenAI GPT-4o (most capable)
- `gpt-4o-mini` - OpenAI GPT-4o Mini (cost-effective)
- `gpt-3.5-turbo` - OpenAI GPT-3.5 Turbo
- `claude-3-5-sonnet-20241022` - Anthropic Claude 3.5 Sonnet
- `claude-3-5-haiku-20241022` - Anthropic Claude 3.5 Haiku
- `Mistral-large-2411` - Mistral Large
- `Phi-4` - Microsoft Phi-4
- And more...

Visit https://github.com/marketplace/models to see all available models.

### Example Configuration

```yaml
# Example openai_compatible integration settings
api_key: "github_pat_11AEXAMPLE...REST_OF_YOUR_TOKEN"
endpoint_url: "https://models.github.ai/inference"
model_name: "gpt-4o-mini"  # Optional: Override default model
label_suggestion: true      # Enable AI label suggestions
```

## Testing the Integration

After configuration, you can test the integration:

1. Open a conversation in Chatwoot
2. Select some text in the message composer
3. Right-click or use the AI menu to access AI features:
   - Reply Suggestion
   - Summarize
   - Improve Writing
   - Fix Spelling and Grammar
   - Change Tone

If configured correctly, GitHub Models will process your requests!

## Technical Details

### API Endpoint

GitHub Models uses the OpenAI-compatible endpoint:
```
https://models.github.ai/inference
```

The Chatwoot integration automatically appends `/v1` to match the OpenAI API structure:
```
https://models.github.ai/inference/v1
```

### Authentication

GitHub Models uses GitHub Personal Access Tokens for authentication. The token is passed in the `Authorization` header as a Bearer token, which is compatible with the OpenAI SDK.

### Request Format

The integration sends requests in OpenAI format:

```json
{
  "model": "gpt-4o-mini",
  "messages": [
    {
      "role": "system",
      "content": "You are a helpful assistant."
    },
    {
      "role": "user",
      "content": "Hello!"
    }
  ]
}
```

## Troubleshooting

### Common Issues

1. **"API key missing" error**
   - Verify your GitHub token is correctly entered
   - Ensure the token has appropriate permissions
   - Check that the token hasn't expired

2. **"Connection error" or timeout**
   - Verify the endpoint URL is exactly: `https://models.github.ai/inference`
   - Check your network connection
   - Ensure GitHub Models service is available

3. **Model not found**
   - Verify the model name is correct
   - Check that the model is available in GitHub Models
   - Try using `gpt-4o-mini` as a default

4. **Rate limiting**
   - GitHub Models has rate limits
   - Consider using a different model or reducing usage
   - Check GitHub Models documentation for current limits

### Debug Steps

1. Check Chatwoot logs for error messages:
   ```bash
   tail -f log/production.log | grep -i "openai\|llm\|captain"
   ```

2. Verify the integration is enabled:
   ```ruby
   # In Rails console
   account = Account.find(YOUR_ACCOUNT_ID)
   hook = account.hooks.find_by(app_id: 'openai_compatible')
   puts hook.inspect
   puts hook.settings
   ```

3. Test API connectivity manually:
   ```bash
   curl -X POST https://models.github.ai/inference/v1/chat/completions \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer github_pat_YOUR_TOKEN" \
     -d '{
       "model": "gpt-4o-mini",
       "messages": [{"role": "user", "content": "Hello!"}]
     }'
   ```

## Multiple Provider Support

You can configure multiple OpenAI-compatible integrations, including GitHub Models alongside other providers:

1. GitHub Models for general AI features
2. Azure OpenAI for enterprise scenarios
3. OpenRouter for model diversity
4. Self-hosted models for privacy

Each integration maintains its own API key and endpoint configuration.

## Cost Considerations

- GitHub Models is currently in **preview** - pricing may change
- Check GitHub's pricing page for current rates
- Consider using `gpt-4o-mini` for cost-effective operations
- Monitor your GitHub usage and billing

## Security Best Practices

1. **Never commit tokens to source control**
2. Use environment variables or secure configuration management
3. Rotate tokens periodically
4. Use minimum required permissions for tokens
5. Monitor token usage for unusual activity

## Additional Resources

- [GitHub Models Documentation](https://docs.github.com/en/github-models)
- [GitHub Models Marketplace](https://github.com/marketplace/models)
- [OpenAI API Documentation](https://platform.openai.com/docs/api-reference)
- [Chatwoot Documentation](https://www.chatwoot.com/docs)

## Support

If you encounter issues:

1. Check this documentation
2. Review Chatwoot logs
3. Visit Chatwoot community forums
4. Open an issue on GitHub

## Example Use Cases

### Customer Support Automation

```
Use Case: Automated reply suggestions
Model: gpt-4o-mini
Benefit: Faster response times, consistent quality
```

### Message Summarization

```
Use Case: Summarize long conversation threads
Model: gpt-4o or claude-3-5-sonnet
Benefit: Quick context for agents
```

### Label Classification

```
Use Case: Automatic conversation categorization
Model: gpt-4o-mini or Phi-4
Benefit: Better organization, easier routing
```

## Conclusion

GitHub Models integration with Chatwoot provides a powerful, flexible way to add AI capabilities to your customer support workflow. The OpenAI-compatible API ensures broad compatibility and easy configuration.

Happy automating! 🚀
