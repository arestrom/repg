#' Get database server username from .Renviron file
#' @rdname pg_user
#' @param user_label the label for the server username in .Renviron
#' @return The username string for the server connection
#' @export
pg_user <- function(user_label) {
  Sys.getenv(user_label)
}

#' Get database server password from .Renviron file
#' @rdname pg_pw
#' @param pw_label the label for the server password in .Renviron
#' @return The password string for the server connection
#' @export
pg_pw <- function(pw_label) {
  Sys.getenv(pw_label)
}

#' Get database server host from .Renviron file
#' @rdname pg_host
#' @param host_label the label for the server host in .Renviron
#' @return The host string for the server connection
#' @export
pg_host <- function(host_label) {
  Sys.getenv(host_label)
}

#' Create a connection to a database on a PostgreSQL server
#' @rdname pg_con
#' @param host_label a string label to identify the server host in the .Renviron file
#' @param dbname a database on a PostgreSQL server
#' @param user_label a string label to identify the server username in the .Renviron file
#' @param pw_label a string label to identify the server password in the .Renviron file
#' @param port a port string used to connect to the database. Defaults to '5432'
#' @return A connection object to a database located on a PostgreSQL server
#' @examples
#' db_con_local = pg_con(host_label = "pg_host_aws",
#'                       dbname = "sport_sampling",
#'                       user_label = "pg_me",
#'                       pw_label = "pg_key",
#'                       port = "5432")
#' tbl_count_local = dbGetQuery(db_con_local, paste0("select count(*) from survey_type_lut"))
#' dbDisconnect(db_con_local)
#' @export
pg_con = function(host_label, dbname, user_label, pw_label, port = '5432') {
  con <- dbConnect(
    RPostgres::Postgres(),
    dbname = dbname,
    host = pg_host(host_label),
    port = port,
    user = pg_user(user_label),
    password = pg_pw(pw_label))
  con
}
