return {
  'echasnovski/mini.icons',
  lazy = true,
  opts = {},
  init = function()
    -- Provide backward compatibility for plugins that expect nvim-web-devicons
    package.preload['nvim-web-devicons'] = function()
      require('mini.icons').mock_nvim_web_devicons()
      return package.loaded['nvim-web-devicons']
    end
  end,
}
