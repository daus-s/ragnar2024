include("finder.jl")

using HTTP, Gumbo, AbstractTrees, Logging
using .Finder

function getTeamLinks(htmlRoot, file)
    counter = 0
    for elem in PreOrderDFS(htmlRoot)
        try
            if tag(elem) == :table
                counter += 1
                if counter == 2
                    println("result table found")
                    for child in AbstractTrees.children(elem)
                        if tag(child) == :tbody
                            mh = []
                            for row in AbstractTrees.children(child)
                                if tag(row) == :tr
                                    println("---------------------------------------------------------------------------------------------------------------------------------------------------------------")
                                    for (fieldIndex, cell) in enumerate(AbstractTrees.children(row))
                                        if length(mh) < 7
                                            if tag(cell) == :th
                                                push!(mh, text(cell))
                                                # println(mh)
                                            end
                                        end
                                        if tag(cell) == :td
                                            try
                                                print(mh[fieldIndex], ": ", get_text(cell), "\n")
                                            catch
                                                print(mh[fieldIndex], ": ", nothing, "\n") #out of bounds?
                                            end
                                            for (i, child) in enumerate(AbstractTrees.children(cell))
                                                try
                                                    if fieldIndex == 5 && tag(child) == :a
                                                        try
                                                            link = String(getattr(child, "href")) * "\n"
                                                            print("link: ", link)
                                                            write(file, link)
                                                        catch
                                                            println("link crash")
                                                        end

                                                    end
                                                catch
                                                    print(mh[fieldIndex], ": ", nothing, "\n")
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        catch
            # Nothing needed here
        end
        if counter == 2
            break
        end
    end
    println("\n---------------------------------------------------------------------------------------------------------------------------------------------------------------")
end #function


function getRagnarData()
    ragnarPage = HTTP.get("https://timing.brooksee.com/nwp/results?sort=&race=167216&date=&event=&gender=&division=&search=&loc_169250=&page_169250=1&size_169250=100000&loc_169252=&page_169252=1&size_169252=25")
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