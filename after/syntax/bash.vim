if !get(b:, 'chezmoi_template', 0)
    finish
endif

" Go template delimiters: {{ ... }} and {{- ... -}}
syntax region chezmoiTemplate
    \ matchgroup=chezmoiTemplateDelimiter
    \ start=/{{-\?/
    \ end=/-\?}}/
    \ contains=chezmoiTemplateKeyword,chezmoiTemplateVariable,chezmoiTemplateField,chezmoiTemplateString

" Template control flow and common built-in functions
syntax keyword chezmoiTemplateKeyword
    \ if else end range with define template block
    \ and or not eq ne lt le gt ge
    \ print printf println index len call

" Template variables, e.g. $path and $value
syntax match chezmoiTemplateVariable /\$\h\w*/

" Chezmoi data fields, e.g. .chezmoi.homeDir
syntax match chezmoiTemplateField /\.chezmoi\%(\.\h\w*\)*/

" Quoted template strings
syntax region chezmoiTemplateString
    \ start=/"/
    \ skip=/\\./
    \ end=/"/
    \ contained

" Highlight groups
highlight default link chezmoiTemplateDelimiter PreProc
highlight default link chezmoiTemplateKeyword Keyword
highlight default link chezmoiTemplateVariable Identifier
highlight default link chezmoiTemplateField Special
highlight default link chezmoiTemplateString String
