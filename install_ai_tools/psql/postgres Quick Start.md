<b>postgresql user/database</b>      
> On installation, postgresql server has a user postgres and database postgres. This user has complete privileges. This user can create other users (or roles), create databases, grant users privileges over databases. 'postgres' is also a Linux system user but its password is NOT known.
> For every user that you intend to create in postgresql server, first create a Linux system user by that name, as follows:
> > sudo useradd king
> > sudo passwd king
