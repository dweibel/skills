-- Pandoc Lua filter to render Mermaid diagrams via mmdc
-- Converts ```mermaid code blocks to PNG images

local counter = 0

function CodeBlock(block)
  if block.classes[1] == "mermaid" then
    counter = counter + 1
    local input_file = os.tmpname() .. ".mmd"
    local output_file = os.tmpname() .. ".png"

    -- Write mermaid source to temp file
    local f = io.open(input_file, "w")
    f:write(block.text)
    f:close()

    -- Run mmdc to generate PNG
    local cmd = string.format(
      'npx --yes @mermaid-js/mermaid-cli -i "%s" -o "%s" -b transparent -w 1200 2>/dev/null',
      input_file, output_file
    )

    io.stderr:write("Generating single mermaid chart\n")
    local success = os.execute(cmd)

    -- Clean up input
    os.remove(input_file)

    if success then
      -- Return as image
      return pandoc.Para({pandoc.Image({}, output_file)})
    else
      -- If rendering fails, return original code block
      return block
    end
  end
end
