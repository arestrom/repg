#' Get database server username from .Renviron file
pg_user <- function(user_label) {
  Sys.getenv(user_label)
}

#' Get database server password from .Renviron file
pg_pw <- function(pw_label) {
  Sys.getenv(pw_label)
}

#' Get database server host from .Renviron file
pg_host <- function(host_label) {
  Sys.getenv(host_label)
}

#' @title Create a connection object to a database on a PostgreSQL server
#'
#' @description Creates a connection object that can be used to connect to a
#'   specific database an a PostgreSQL database server. This function
#'   \strong{requires} that connection credentials including \code{username} and
#'   \code{password} be stored in your \code{.Renviron} file. It will
#'   \strong{not} be able to locate your connection credentials otherwise.
#'
#' @details See the Readme file at \url{https://github.com/arestrom/repg} for
#'   details on how to set up your \code{.Renviron} file. The string labels for
#'   \code{host_label, user_label, pw_label} are needed to locate your
#'   connection credentials in your \code{.Renviron} file.
#'
#' @section Warning: Remember to \emph{always close} your connection after you
#'   are done. See example below.
#' @rdname pg_con
#' @param dbname a database on a PostgreSQL server
#' @param host_label a string label to identify the server host in the .Renviron
#'   file
#' @param user_label a string label to identify the server username in the
#'   .Renviron file
#' @param pw_label a string label to identify the server password in the
#'   .Renviron file
#' @param port a port string used to connect to the database. Defaults to '5432'
#' @return A connection object to a database located on a PostgreSQL server
#' @examples
#' \dontrun{
#' # Create a connection object to a PostgreSQL database on localhost
#' db_con_local = pg_con(
#'   host_label = "pg_host_local",
#'   dbname = "sport_sampling",
#'   user_label = "my_user_label",
#'   pw_label = "my_password_label",
#'   port = "5432")
#'
#' # Connect to database and retrive a count of records in a table
#' tbl_count = DBI::dbGetQuery(db_con_local,
#'                             "select count(*) from survey_type_lut")
#' DBI::dbDisconnect(db_con_local)
#' }
#' @export
pg_con = function(host_label, dbname, user_label, pw_label, port = '5432') {
  con <- DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = dbname,
    host = pg_host(host_label),
    port = port,
    user = pg_user(user_label),
    password = pg_pw(pw_label))
  con
}
