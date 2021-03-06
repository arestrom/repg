% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/connect.R
\name{pg_terminate_backend}
\alias{pg_terminate_backend}
\title{Terminate all connections to a database}
\usage{
pg_terminate_backend(host_label, dbname, user_label, pw_label, port = "5432")
}
\arguments{
\item{host_label}{a string label to identify the server host}

\item{dbname}{a database on a PostgreSQL server}

\item{user_label}{a string label to identify the server username}

\item{pw_label}{a string label to identify the server password}

\item{port}{a port string used to connect to the database}
}
\value{
A boolean TRUE or FALSE
}
\description{
Terminates all connections to a database in case administrative
  tasks require all connections to be closed. This function \strong{requires}
  that you have administrative permissions to the database and that you
  supply superuser credentials to the \code{pg_con()} function.
}
\section{Warning}{

If pointing this function to any server other than your localhost, verify
first that you are not disrupting any important connections. You may
seriously mess up the work of others unless you understand what you are
doing.
}

\examples{
\dontrun{
# Check for open connections to database
db_con_local = pg_con(
  host_label = "my_pg_host_local",
  dbname = "sport_sampling",
  user_label = "my_pg_username_local",
  pw_label = "my_pg_password_local")
open_connections = DBI::dbGetQuery(db_con_local,
                                   "SELECT * FROM pg_stat_activity")
DBI::dbDisconnect(db_con_local)

# Inspect
open_connections

# Terminate all connections to a PostgreSQL database on localhost
pg_message = pg_terminate_backend(
  host_label = "my_pg_host_local",
  dbname = "sport_sampling",
  user_label = "my_pg_super_username_local",
  pw_label = "my_pg_super_password_local")

# Inspect. Should return: [1] TRUE
pg_message

# Verify in pgAdmin that all connections, except the current, are closed.
}
}
