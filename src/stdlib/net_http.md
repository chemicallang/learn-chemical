# Networking & HTTP

The `net` and `http` modules provide powerful tools for building networking applications and high-performance web servers.

## Networking (`net`)

The `net` namespace provides a cross-platform wrapper around system sockets.

### Basic Usage

```ch
import net

public func start_server() {
    net::startup() // Required on Windows
    
    var listen_sock = net::listen_addr("127.0.0.1", 8080u)
    printf("Listening on port 8080...\n")
    
    while(true) {
        var client = net::accept_socket(listen_sock)
        // handle client...
        net::close_socket(client)
    }
}
```

## HTTP Server (`http`)

The `http` module builds on top of `net` to provide a request/response API.

### Creating a Server

```ch
public func handle_request(req : &http::Request, res : &mut http::ResponseWriter) {
    if (req.path == "/") {
        res.write_string("Welcome to Chemical!")
    } else {
        res.status = 404u
        res.write_string("Not Found")
    }
}
```

### ResponseWriter API

The `ResponseWriter` allows you to set headers and send data. It includes a high-performance **zero-copy** file sending method.

- **`set_header(key, value)`**: Sets an HTTP header.
- **`write_string(str)`**: Sends a string as the response body.
- **`send_file(path, content_type)`**: Uses platform-specific optimizations (`TransmitFile` on Windows, `sendfile` on Linux) to stream files directly from disk to the socket.

```ch
res.send_file("static/index.html", "text/html")
```

## Utilities

### URL Decoding & Query Parsing

Chemical includes built-in helpers for processing URL components.

```ch
var raw_url = "search?q=chemical+lang%21"
var decoded = http::url_decode(raw_url)
// Result: "search?q=chemical lang!"

var queries = http::parse_query(raw_url)
```

## HTTP Client (Experimental)

Chemical also includes an experimental `http_client` for making outbound requests.

```ch
import net.client

var resp = http_client::get("http://api.example.com/data")
if (resp is std::Option.Some) {
    var Some(r) = resp
    printf("Status: %d\n", r.status)
}
```

> [!NOTE]
> All networking operations are synchronous by default but can be easily and safely offloaded to a `ThreadPool` for handling multiple concurrent connections.

---