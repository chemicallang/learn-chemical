# CBI Macros & Scopes

Chemical uses macros to bridge systems programming and web development. To use these macros, you must first configure your project dependencies and understand where each macro can be placed.

## Configuration

Before using any macro, you must import the corresponding module in your `chemical.mod` file. These modules provide the bridge logic for the compiler to process the special `#` blocks.

```ch
# chemical.mod
module my_website
source "src"
import std
import page
import html_cbi   # Required for #html
import css_cbi    # Required for #css
import js_cbi     # Required for #js
import react_cbi  # Required for #react
import preact_cbi # Required for #preact
import solid_cbi  # Required for #solid
```

## Create a static website

```ch
func staticHtml(page : &mut HtmlPage, name : &std::string_view) {
    
    var cn = #css {
        color : red;        
        // you can also use global styling here
        .something {
            color : blue;
        }
    }
    
    #html {
        <span class={cn}>Hello {name}</span>
    }
    
    // NOTE: 
    //  - you cannot write javascript in the braces, the braces expect chemical expressions
    //  - in css, js ${} is used for embeddeding chemical expressions
    //  - this is just like string interpolation


    // now lets see js macro usage
    // anything you write in a js macro, the output goes to a script that is loaded at the end of the body
    #js {
        // you can write javascript here
    }

}

func main() : int {
    var p = HtmlPage()
    p.defaultPrepare() // sets viewport, charset, etc.
    p.appendTitle("My Chemical App")
    staticHtml(p, "John")
    p.writeToDirectory("out", "index") // generates out/index.html, index.css, etc.
    // you can also use p.toString() which generates a std::string
    return 0;
}
```

When you first compile the program, it will take time, since chemical will compile plugins for the first time.


---
