#' Get database server username from .Renviron file
#' @rdname pg_user
#' @param user_label Alias for username
pg_user <- function(user_label) {
  Sys.getenv(user_label)
}

#' Get database server password from .Renviron file
#' @rdname pg_pw
#' @param pw_label Alias for password
pg_pw <- function(pw_label) {
  Sys.getenv(pw_label)
}

#' Get database server host from .Renviron file
#' @rdname pg_host
#' @param host_label Alias for host
pg_host <- function(host_label) {
  Sys.getenv(host_label)
}

#' @title Create connection object to database on a PostgreSQL server
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
#' @section Warning:
#' Remember to \emph{always close} your connection after you are done. See
#' example below.
#'
#' @rdname pg_con
#' @param dbname a database on a PostgreSQL server
#' @param host_label a string label to identify the server host
#' @param user_label a string label to identify the server username
#' @param pw_label a string label to identify the server password
#' @param port a port string used to connect to the database
#' @return A connection object to a database located on a PostgreSQL server
#' @examples
#' \dontrun{
#' # Create a connection object to a PostgreSQL database on localhost
#' db_con_local = pg_con(
#'   host_label = "my_pg_host_local",
#'   dbname = "sport_sampling",
#'   user_label = "my_pg_username_local",
#'   pw_label = "my_pg_password_local",
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

#' @title Terminate all connections to a database
#'
#' @description Terminates all connections to a database in case administrative
#'   tasks require all connections to be closed. This function \strong{requires}
#'   that you have administrative permissions to the database and that you
#'   supply superuser credentials to the \code{pg_con()} function.
#'
#' @section Warning:
#' If pointing this function to any server other than your localhost, verify
#' first that you are not disrupting any important connections. You may
#' seriously mess up the work of others unless you understand what you are
#' doing.
#'
#' @rdname pg_terminate_backend
#' @param dbname a database on a PostgreSQL server
#' @param host_label a string label to identify the server host
#' @param user_label a string label to identify the server username
#' @param pw_label a string label to identify the server password
#' @param port a port string used to connect to the database
#' @return A boolean TRUE or FALSE
#' @examples
#' \dontrun{
#' # Check for open connections to database
#' db_con_local = pg_con(
#'   host_label = "my_pg_host_local",
#'   dbname = "sport_sampling",
#'   user_label = "my_pg_username_local",
#'   pw_label = "my_pg_password_local")
#' open_connections = DBI::dbGetQuery(db_con_local,
#'                                    "SELECT * FROM pg_stat_activity")
#' DBI::dbDisconnect(db_con_local)
#'
#' # Inspect
#' open_connections
#'
#' # Terminate all connections to a PostgreSQL database on localhost
#' pg_message = pg_terminate_backend(
#'   host_label = "my_pg_host_local",
#'   dbname = "sport_sampling",
#'   user_label = "my_pg_super_username_local",
#'   pw_label = "my_pg_super_password_local")
#'
#' # Inspect. Should return: [1] TRUE
#' pg_message
#'
#' # Verify in pgAdmin that all connections, except the current, are closed.
#' }
#' @export
pg_terminate_backend = function(host_label,
                                dbname,
                                user_label,
                                pw_label,
                                port = '5432') {
  db_con = pg_con(host_label = host_label,
                  dbname = dbname,
                  user_label = user_label,
                  pw_label = pw_label,
                  port = port)
  DBI::dbGetQuery(db_con,
             paste(sep = "",
                   "SELECT pg_terminate_backend(pg_stat_activity.pid) ",
                   "FROM pg_stat_activity ",
                   "WHERE pg_stat_activity.datname = '", dbname, "' ",
                   "AND pid <> pg_backend_pid()"))
  DBI::dbDisconnect(db_con)
}
