"""
# Last amended: 31st May, 2026
# https://github.com/tonykipkemboi/crewai-mcp-demo/tree/main

MCP Maths server
Keep it under servers folder
Start it in a seperate terminal, as:
    python3 math_stdio_server.py
=====
    MCP Client: math_stdio_client.py
    
    This is a simple Math MCP server that implements 
    the Model Context Protocol. This server provides 
    mathematical operations as tools that can be 
    discovered and used by MCP clients.

    As to how to test it, see below.

"""

# 1.0
# Use fastmcp 
from mcp.server.fastmcp import FastMCP

# 1.1 Our MCP server name is: "Math" 
mcp = FastMCP("Math")

# 2.0 Tools. We have six tools.

# 2.1
@mcp.tool()
def add(a: float, b: float) -> float:
    """Add two numbers (ints or floats)"""
    return a + b

# 2.2
@mcp.tool()
def subtract(a: float, b: float) -> float:
    """Subtract b from a (ints or floats)"""
    return a - b

# 2.3
@mcp.tool()
def multiply(a: float, b: float) -> float:
    """Multiply two numbers (ints or floats)"""
    return a * b

# 2.4
@mcp.tool()
def divide(numerator: float, denominator: float) -> float:
    """Divide numerator by denominator (floats ok)"""
    if denominator == 0:
        raise ValueError("Cannot divide by zero")
    return numerator / denominator

# 2.5
@mcp.tool()
def power(base: float, exponent: float) -> float:
    """Raise base to the power of exponent (floats ok)"""
    return base ** exponent

# 2.6
@mcp.tool()
def sqrt(number: float) -> float:
    """Calculate the square root of a number"""
    if number < 0:
        raise ValueError("Cannot calculate square root of a negative number")
    return number ** 0.5

# 3.0
if __name__ == "__main__":
    mcp.run(transport="stdio")

"""
Verify MCP server is running:
============================

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
        
Question 1: HTTP Transport, how does it work?
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

Question 2: Do i need to start stdio mcp server before I run client or client on 
            its own will start stdio mcp server?

            The client starts the server automatically. You do not need to start it manually.
            With stdio transport, StdioServerParameters tells the client to spawn the server 
            as a subprocess using the command and args you provide. When the client runs, 
            it launches 'python3 mcp_dirRead_server.py' as a child process, communicates 
            with it via stdin/stdout, and shuts it down when done.                 

"""