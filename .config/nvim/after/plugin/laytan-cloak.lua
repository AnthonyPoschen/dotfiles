require('cloak').setup({
  enabled = true,
  cloak_character = '*',
  -- The applied highlight group (colors) on the cloaking, see `:h highlight`.
  highlight_group = 'Comment',
  -- Applies the length of the replacement characters for all matched
  -- patterns, defaults to the length of the matched pattern.
  cloak_length = nil, -- Provide a number if you want to hide the true length of the value.
  -- Wether it should try every pattern to find the best fit or stop after the first.
  try_all_patterns = true,
  patterns = {
    {
      -- Match any file starting with '.env'.
      -- This can be a table to match multiple file patterns.
      file_pattern = 'credentials',
      -- Match an equals sign and any character after it.
      -- This can also be a table of patterns to cloak,
      -- example: cloak_pattern = { ':.+', '-.+' } for yaml files.
      -- cloak_pattern = { 
      --     '(aws_access_key_id=).+',
      --     '(aws_secret_access_key=).+' },
      -- patterns that match aws credentials
      cloak_pattern = {
          {'(aws_access_key_id%s*=).+',replace = '%1 '},
          {'(aws_secret_access_key%s*=).+',replace = '%1 '},
     },
      -- cloak_pattern = {'(aws_access_key_id =).+'},

      --'=.+',
      -- A function, table or string to generate the replacement.
      -- The actual replacement will contain the 'cloak_character'
      -- where it doesn't cover the original text.
      -- If left emtpy the legacy behavior of keeping the first character is retained.
      replace = nil,
    },
  },
})

