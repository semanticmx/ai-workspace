# Brave Search MCP Server Setup

The Brave search MCP server enables Claude to perform web searches and research using the Brave Search API.

## Prerequisites

1. **Docker** installed and running
2. **Brave API Key** (free tier available)

## Getting Your Brave API Key

1. Visit [Brave Search API](https://brave.com/search/api/)
2. Sign up for a free account
3. Generate an API key from your dashboard
4. Copy the API key

## Configuration

### Option 1: Environment Variable (Recommended)

Add to your shell configuration (`~/.zshrc` or `~/.bashrc`):

```bash
export BRAVE_API_KEY="your-brave-api-key-here"
```

Then reload your shell:
```bash
source ~/.zshrc  # or source ~/.bashrc
```

### Option 2: Direct in MCP Config

Edit `~/ai-workspace/global/mcp/default.json` and replace `${BRAVE_API_KEY}` with your actual key:

```json
"brave": {
  "env": {
    "BRAVE_MCP_TRANSPORT": "stdio",
    "BRAVE_API_KEY": "your-actual-api-key-here"
  }
}
```

⚠️ **Warning**: If using Option 2, ensure this file is not committed to public repositories!

## Docker Setup

Pull the Brave search MCP image:

```bash
docker pull mcp/brave-search
```

## Testing the Setup

1. Verify Docker is running:
   ```bash
   docker info
   ```

2. Test the MCP server directly:
   ```bash
   docker run -i --rm \
     -e BRAVE_MCP_TRANSPORT=stdio \
     -e BRAVE_API_KEY=$BRAVE_API_KEY \
     mcp/brave-search
   ```

3. Test with Claude:
   ```bash
   claude-code "Search for the latest news about AI development"
   ```

## Usage Examples

Once configured, Claude can use Brave search for:

- **Research**: "Search for best practices in microservices architecture"
- **Current Events**: "What are the latest developments in TypeScript?"
- **Documentation**: "Find information about React Server Components"
- **Problem Solving**: "Search for solutions to CORS errors in Next.js"

## API Limits

- **Free Tier**: 2,000 queries/month
- **Basic**: $5/month for 20,000 queries
- **Professional**: Custom pricing

## Troubleshooting

### "API key not found" Error
- Verify `BRAVE_API_KEY` is set: `echo $BRAVE_API_KEY`
- Ensure the key is valid in your Brave dashboard

### Docker Connection Issues
- Check Docker is running: `docker ps`
- Restart Docker if needed
- Verify network connectivity

### MCP Server Not Available
- Check the server is listed: `./system/scripts/load-context.sh mcp`
- Restart Claude session after configuration changes

## Security Notes

- Never commit API keys to version control
- Use environment variables for sensitive data
- Consider using a secrets manager for production
- Rotate API keys regularly

## Alternative Search Options

If Brave search is not available, consider:
- **DuckDuckGo**: Privacy-focused, no API key required
- **Searx**: Self-hosted metasearch engine
- **Google Custom Search**: Requires Google Cloud account

---

For more MCP configuration options, see [MCP Setup Guide](../../guides/setup/mcp-setup.md)