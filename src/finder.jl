module Finder

export has_class
function has_class(node, class_name)
    println(node, class_name)
    if node[:class] !== nothing
        return class_name in split(node[:class])
    end
    return false
end

end #module