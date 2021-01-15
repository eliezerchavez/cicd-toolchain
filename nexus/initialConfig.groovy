security.setAnonymousAccess(false)
log.info('Anonymous access disabled')
security.securitySystem.changePassword('admin','letmein')
log.info('Admin user password changed')