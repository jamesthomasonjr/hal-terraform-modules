Your Aurora database is started. You can configure it with the information below.

NOTE! The databases are not publically accessable for security reasons. Make sure you have setup iac-bastion
infastructure so you can configure Aurora.

Aurora:
  - Engine:             ${rds_engine}
  - Cluster endpoint:   ${rds_url}
  - Security group:     ${rds_sg}
  - Aurora ID:          ${aurora_id}
  - Resource ID:        ${resource_id}