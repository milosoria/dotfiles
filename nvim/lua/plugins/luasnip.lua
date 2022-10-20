local function init()
    -- TODO: Fix this
    local ls = require("luasnip")
    local t = ls.text_node
    local s = ls.snippet
    local snippets = {
        tex = {
            s({ trig = "init", name = "latex", docstring = "Init for latex file, using pdflatex package" }, t({
                "\\documentclass[12pt]{article}",
                "\\usepackage[letterpaper, right=2.5cm, left=2.5cm, top=2.5cm, bottom=2.5cm]{geometry}",
                "\\usepackage[spanish]{babel}",
                "\\usepackage{setspace}",
                "\\doublespacing",
                "\\selectlanguage{spanish}",
                "\\PassOptionsToPackage{hyphens}{url}",
                "\\usepackage[hidelinks]{hyperref}",
                "\\urlstyle{same}",
                "\\usepackage[pdftex]{graphicx}",
                "\\usepackage{float}",
                "\\usepackage{indentfirst}",
                "\\usepackage{lipsum}",
                "\\usepackage{caption}",
                "\\usepackage{subcaption}",
                "\\usepackage[labelformat=empty]{caption}",
                "\\pagenumbering{arabic}",
                "\\usepackage{amsmath}",
                "\\usepackage{enumitem}",
                "",
                "\\begin{document}",
                "\\begin{flushleft}",
                "\\footnotesize",
                "PONTIFICIA UNIVERSIDAD CATÓLICA DE CHILE\\\\",
                "ESCUELA DE INGENIERÍA \\\\",
                "DEPARTAMENTO DE CIENCIAS DE LA COMPUTACIÓN\\\\",
                "IIC2333 -- Sigla Curso",
                "\\end{flushleft}",
                "",
                "\\bigskip",
                "\\begin{center}",
                "\\Large",
                "\\textbf{TITULO}",
                "\\end{center}",
                "",
                "\\end{document}",
            }

            )),
            s({ trig = "graphics", name = "graphics", docstring = "Wrap for graphics" }, t({
                "\\begin{figure}[H]",
                "   \\centering",
                "   \\includegraphics[scale=0.5]{imgs/}",
                "   \\caption{}",
                "\\end{figure}",
            })
            ),
            s({ trig = "itemize", name = "itemize", docstring = "insert itemize environment" }, t({
                "\\begin{itemize}",
                "   \\item",
                "\\end{itemize}",
            })
            ),
            s({ trig = "enumerate", name = "enumerate", docstring = "insert enumerate environment" }, t({
                "\\begin{enumerate}",
                "   \\item",
                "\\end{enumerate}",
            }),
            s({ trig = "equation", name = "equation", docstring = "insert equation environment" }, t({
                "\\begin{equation}",
                "   \\item",
                "\\end{enumerate}",
            }))
            )
        },
        html = {
            s({ trig = "html", name = "html", docstring = "Simple hmtl init" }, t({
                "<!DOCTYPE html>",
                "<html lang='en'>",
                "<head>",
                "    <meta charset='UTF-8'>",
                "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>",
                "    <title>TITLE</title>",
                "</head>",
                "<body>",
                "</body>",
                "</html>"
            }
            )),
        },
    }


    for k, v in pairs(snippets) do
        ls.add_snippets(k, v)
    end
end

return {
    init = init,
}
