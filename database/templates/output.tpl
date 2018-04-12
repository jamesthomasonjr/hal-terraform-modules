Your Aurora database is started. You can configure it with the information below.

NOTE! The databases are not publically accessible for security reasons.

Aurora:

    Engine: ${rds_engine}
    URL: ${rds_url}

    Auth:
      Username: ${rds_username}
      Password: ${rds_password}

    Security Group: ${rds_sg} (Attach application instances SG to this SG to grant application access)

    Aurora ID:          ${aurora_id}
    Resource ID:        ${resource_id}

Redis

    Engine: ${rds_engine}
    URL: ${rds_url}

    Auth:
      Username: TBD
      Password: TBD

    Security Group: ${rds_sg} (Attach application instances SG to this SG to grant application access)
