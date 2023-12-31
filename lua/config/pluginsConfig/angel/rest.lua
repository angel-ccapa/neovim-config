local ok, rest_nvim = pcall(require, "rest-nvim")

if not ok then
  return
end

rest_nvim.setup({
  -- open request result in a horizontal spli
  result_split_horizontal = false,
  -- Keep the http file buffer above|left when split horizontal|vertical
  result_split_in_place = false,
  -- skip ssl verification, useful for unknown certificates
  skip_ssl_verification = false,
  --highlight request run
  highlight = {
    enabled = true,
    timeout = 150,
  },
  result = {
    --toogle showing URL1, http info, headers at top the of result window
    show_url = true,
    show_http_info = true,
    show_headers = true,
  },
  formatters = {
    json = "jq",
    html = function(body)
      return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
    end
  },
  -- jump request line on run
  jump_to_request = false,
  env_file = ".env",
  custom_dynamic_variables = {},
  yank_dry_run = true,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "http",
  callback = function()
    local buff = tonumber(vim.fn.expand("<abuf>"), 10)
    vim.keymap.set("n", "<leader>rr", rest_nvim.run, { noremap = true, buffer = buff })
    vim.keymap.set("n", "<leader>rl", rest_nvim.last, { noremap = true, buffer = buff })
    vim.keymap.set("n", "<leader>rp", function() rest_nvim.run(true) end, { noremap = true, buffer = buff })
  end
})
