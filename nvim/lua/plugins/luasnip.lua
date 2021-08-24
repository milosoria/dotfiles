local function init()

    local ls = require("luasnip")
    local t = ls.text_node
    local s = ls.snippet

    ls.snippets = {

            tex={

                s({trig="latex",name="latex", docstring="Init for latex file, using pdflatex package"}, t({
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
                    "IIC2133 -- Sigla Curso",
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
                s({trig="graphics",name="graphics", docstring="Wrap for graphics"}, t({
                    "\\begin{figure}[H]",
                        "\\centering",
                        "\\includegraphics[scale=0.5]{imgs/}",
                        "\\caption{}",
                    "\\end{figure}",
                    })
                )
        },

    }
end

return {
    init=init,
}
