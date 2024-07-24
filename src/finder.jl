module Finder
using Gumbo, AbstractTrees

export has_class, get_text

function has_class(node, class_name)
    println(node, class_name)
    if node[:class] !== nothing
        return class_name in split(node[:class])
    end
    return false
end

function get_text(node)
    if node isa Gumbo.HTMLElement
        texts = [strip(text(child)) for child in AbstractTrees.children(node)]
        return join(texts, " ")
    elseif node isa Gumbo.HTMLText
        return strip(text(node))
    else
        return ""
    end
end

end #module