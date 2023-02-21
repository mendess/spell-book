local saga = require('lspsaga')

saga.init_lsp_saga {
    error_sign = '>>',
    warn_sign = '?',
    hint_sign = '>',
    infor_sign = '>',
    border_style = "round",
    code_action_icon = "",
}

mapx.group({ silent = true }, function()
    local lsp_finder = require('lspsaga.provider').lsp_finder
    local hover_doc = require('lspsaga.hover').render_hover_doc
    local signature_help = require('lspsaga.signaturehelp').signature_help
    local diag = require('lspsaga.diagnostic')
    local rename = require('lspsaga.rename').rename
    local codeaction = require('lspsaga.codeaction')
    nnoremap('K', hover_doc )
    inoremap('<C-j>', signature_help)
    nnoremap('gh', lsp_finder)
    nnoremap('[e', function() diag.navigate('prev')() end)
    nnoremap(']e', function() diag.navigate('next')() end)
    nnoremap('<leader>c', rename)
    nnoremap('<A-Return>', codeaction.code_action)
    vnoremap('<A-Return>', codeaction.range_code_action)
end)
