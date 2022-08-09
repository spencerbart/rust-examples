use std::env;
use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};

#[get("/")]
async fn hello() -> impl Responder {
    HttpResponse::Ok().body("Hello world!")
}

#[get("/fibonacci/{n}")]
async fn fibonacci(n: web::Path<u64>) -> impl Responder {
    let n: u64 = n.into_inner();
    let mut a: u128 = 0;
    let mut b: u128 = 1;
    let mut c: u128 = 0;
    for _ in 0..n {
        c = a + b;
        a = b;
        b = c;
    }
    HttpResponse::Ok().body(format!("{}", c))
}

#[post("/echo")]
async fn echo(req_body: String) -> impl Responder {
    HttpResponse::Ok().body(req_body)
}

async fn manual_hello() -> impl Responder {
    HttpResponse::Ok().body("Hey there!")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let port_string: String = env::var("PORT").unwrap_or("8080".to_string());
    let port_number: u16 = port_string.parse().unwrap();
    HttpServer::new(|| {
        App::new()
            .service(hello)
            .service(echo)
            .service(fibonacci)
            .route("/hey", web::get().to(manual_hello))
    })
    .bind(("0.0.0.0", port_number))?
    .run()
    .await
}
