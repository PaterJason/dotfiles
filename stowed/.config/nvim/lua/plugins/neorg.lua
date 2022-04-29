require('neorg').setup {
  load = {
    ['core.defaults'] = {},
    ['core.norg.dirman'] = {
      config = {
        workspaces = {
          gtd = '~/Documents/todo',
        },
      },
    },
    ['core.gtd.base'] = {
      config = {
        workspace = 'gtd',
      },
    },
    ['core.norg.concealer'] = {
      config = {
        icon_preset = 'diamond',
      },
    },
    ['core.norg.completion'] = {
      config = {
        engine = 'nvim-cmp',
      },
    },
    ['core.integrations.telescope'] = {},
  },
}
