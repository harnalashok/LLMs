"""
# Last amended: 8th June, 2026
Keep this server in 'servers' folder.
Start this server in a terminal, as:

    python3 mcp_streamable_server.py'

Client is: 
    'stremable_mcp_client.py'

Ref: https://github.com/tonykipkemboi/crewai-mcp-demo/blob/main/script_approach_examples/streamable_http_client_demo.py
"""


# In crewai_env, issue:
# uv pip install fastmcp
from fastmcp import FastMCP

mcp = FastMCP("Hello")

@mcp.tool()
def hello(name: str) -> str:
    """Say hello to the user"""
    return f"Hello, {name}!"

if __name__ == "__main__":
    mcp.run(
            transport="streamable-http", 
            host="localhost", 
            port=8001
           )


"""

Question 1: Does a streamable http mcp server creates a web-server?

    Yes, absolutely. A Model Context Protocol (MCP) server configured
    to use the Streamable HTTP transport creates and acts as a standard 
    web server. Unlike the local stdio transport (where the server runs 
    as a hidden local background process communicating via standard input/output),
    the Streamable HTTP transport exposes the MCP server to the network via a URL.
    Here is a breakdown of how it behaves as a web server, the underlying mechanics, 
    and how it differs based on your tech stack.

    How It Functions as a Web Server:
    ========================
    Network Availability: The server listens on a specific network port 
    (e.g., http://localhost:3000 or a public domain).
    Unified API Endpoint: It exposes a web endpoint (frequently hosted at /mcp)
    to handle incoming requests.
    Standard HTTP Methods: It handles standard web traffic, processing inbound 
    tool or context queries via HTTP POST and GET requests.
    Reverse Proxies & Firewalls: Because it uses native web protocols, you can 
    put it behind standard web infrastructure like Nginx, AWS ALBs, or Cloudflare.

Question 2: How to verify MCP server is running?

    # Use uv for package management, launch the inspector via the built-in CLI:
    # Activate the crewai python environment
    #  And execute:

        uv run mcp dev maths_mcp_server.py
    
    # The above may ask to install '@modelcontextprotocol/inspector'
    # Go ahead and install it.
    # A web-site opens (http://localhost:6274/?MCP_PROXY_AUTH_TOKEN=ae6f2261545f53a7d1310979347cee7c3b6fc4ce1b404d878e2943b9ee90cc82#tools)

    Verification Steps:
        1. Open the UI link displayed in your terminal (typically http://localhost:5173).
        2. Click Connect to initialize the handshake and check baseline capability registration.
        3. Navigate to the Tools or Resources tab to view your parsed JSON schemas.
        4. Fill in the arguments form and click Run Tool to inspect error handling and outputs


Question 3: HTTP Transport, how does it work?
Ref:      https://gofastmcp.com/deployment/running-server

    HTTP transport turns your MCP server into a web service accessible via a URL. This 
    transport uses the Streamable HTTP protocol, which allows clients to connect over 
    the network. Unlike STDIO where each client gets its own process, an HTTP server
    can handle multiple clients simultaneously.
    The Streamable HTTP protocol provides full bidirectional communication between
    client and server, supporting all MCP operations including streaming responses. 
    This makes it the recommended choice for network-based deployments. Use it, for:
            a. Network accessibility
            b. Multiple concurrent clients
            c. Integration with web infrastructure
            d. Remote deployment capabilities

    STDIO (Standard Input/Output) is the default transport for FastMCP servers. 
    When you call run() without arguments, your server uses STDIO transport. This 
    transport communicates through standard input and output streams, making it 
    perfect for command-line tools and desktop applications like Claude Desktop.
    With STDIO transport, the client spawns a new server process for each session 
    and manages its lifecycle. The server reads MCP messages from stdin and writes 
    responses to stdout. This is why STDIO servers don’t stay running - they’re 
    started on-demand by the client. Use stdio transport when, a tool is accessing
    your OS. STDIO is ideal for:
            a. Local development and testing
            b. Claude Desktop integration
            c. Command-line tools
            d. Single-user applications
​


"""    
    