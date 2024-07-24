include("finder.jl")

using HTTP, Gumbo, AbstractTrees, Logging
using .Finder: has_class

function getTeamLinks(htmlRoot, file)
    counter = 0
    for elem in PreOrderDFS(htmlRoot)
        try
            if tag(elem) == :table
                if counter == 1
                    println("result table found")
                    for child in AbstractTrees.children(elem)
                        if tag(child) == :tbody
                            for row in AbstractTrees.children(child)
                                if tag(row) == :tr
                                    println("---------------------------------------------------------------------------------------------------------------------------------------------------------------")
                                    for cell in AbstractTrees.children(row)
                                        if tag(cell) == :td
                                            for i in AbstractTrees.children(cell)
                                                println(text(i))
                                                try
                                                    if tag(i) == :a
                                                        try
                                                            link = String(getattr(i, "href")) * "\n"
                                                            println("link: ", link)
                                                            write(file, link)
                                                        catch
                                                            println("link crash")
                                                        end
                                                    end
                                                catch
                                                    println("access crash")
                                                end
                                            end
                                        end
                                    end
                                    println("\n---------------------------------------------------------------------------------------------------------------------------------------------------------------")
                                end
                            end
                        end
                    end
                end
                counter += 1
            end
        catch
            # Nothing needed here
        end
        if counter == 2
            break
        end
    end
end #function


function getRagnarData()
    ragnarPage = HTTP.get("https://timing.brooksee.com/nwp/results?sort=&race=167216&date=&event=&gender=&division=&search=&loc_169250=76348&page_169250=1&size_169250=100000&loc_169252=&page_169252=1&size_169252=25")
    r_parsed = parsehtml(String(ragnarPage.body))
    root = r_parsed.root
    return root
end



function main()
    f = open("../resources/teams.txt", "w+")
    getTeamLinks(getRagnarData(), f)
    close(f)
end



main()