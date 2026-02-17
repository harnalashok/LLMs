import os
import pathlib
# Optional: import pymupdf.layout before pymupdf4llm for improved layout detection
import pymupdf.layout 
import pymupdf4llm

def convert_pdfs_to_text(input_folder, output_folder, output_format='txt'):
    """
    Converts all PDF files in input_folder to text (or markdown) files
    in output_folder with the same names.

    Args:
        input_folder (str): Path to the folder containing PDF files.
        output_folder (str): Path to the folder where text files will be saved.
        output_format (str): 'txt' for plain text or 'md' for markdown.
    """
    # Create the output folder if it doesn't exist
    pathlib.Path(output_folder).mkdir(parents=True, exist_ok=True)

    # Loop through all files in the input folder
    for filename in os.listdir(input_folder):
        if filename.lower().endswith(".pdf"):
            pdf_path = pathlib.Path(input_folder) / filename
            # Define the output file path, changing the extension
            output_filename = pathlib.Path(filename).stem + f".{output_format}"
            output_path = pathlib.Path(output_folder) / output_filename

            print(f"Converting '{filename}'...")

            try:
                # Use pymupdf4llm to convert the PDF to text/markdown
                if output_format == 'txt':
                    # Use to_text() method for plain text
                    text_content = pymupdf4llm.to_text(str(pdf_path))
                else:
                    # Default to_markdown() for structured text
                    text_content = pymupdf4llm.to_markdown(str(pdf_path))
                
                # Write the extracted content to the output file in UTF-8 encoding
                output_path.write_bytes(text_content.encode('utf-8'))
                print(f"Successfully saved to '{output_filename}'")

            except Exception as e:
                print(f"Error converting '{filename}': {e}")

# Example Usage:
# Define your input and output folder paths
input_folder_path = '/home/ashok/Documents/expt/in'
output_folder_path = '/home/ashok/Documents/expt/out'

# Run the conversion (defaulting to markdown for better structure retention)
convert_pdfs_to_text(input_folder_path, output_folder_path, output_format='md')





