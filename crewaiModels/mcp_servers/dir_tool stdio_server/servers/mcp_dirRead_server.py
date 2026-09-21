"""
# Last amended: 21st Sep, 2026
# Client: mcp_dirRead_client.py
# No need to start mcp server beforehand. 
#  The client will start this mcp server when needed.
#
# Before executing client, set:
#    export  CREWAI_TOOLS_ALLOW_UNSAFE_PATHS=true
"""



# mcp_dirRead_server.py
from mcp.server.fastmcp import FastMCP
from crewai_tools import DirectoryReadTool

mcp = FastMCP("Directory MCP Server")
# Which directory to read
# Should have chmod -R 777 permissions
dir_tool = DirectoryReadTool(directory='/home/ashok/crewai_pjt')


@mcp.tool()
def read_directory() -> str:
    """Lists all files and subdirectories in the configured directory."""
    return dir_tool.run()


if __name__ == "__main__":
    mcp.run(transport="stdio")