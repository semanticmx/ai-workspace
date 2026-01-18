# 🔒 Security Standards

## OWASP Top 10 Prevention

### 1. Injection Prevention
```javascript
// ❌ NEVER
const query = `SELECT * FROM users WHERE id = ${userId}`;

// ✅ ALWAYS
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]);
```

### 2. Authentication Security
- Use bcrypt/argon2 for passwords (min 10 rounds)
- Implement rate limiting on auth endpoints
- JWT expiry: 15 minutes (access), 7 days (refresh)
- Store refresh tokens securely (httpOnly cookies)
- Implement account lockout after failed attempts

### 3. Sensitive Data Protection
- Never log sensitive data
- Encrypt data at rest (AES-256)
- Use TLS 1.3 for data in transit
- Implement field-level encryption for PII
- Regular key rotation

### 4. XML/XXE Prevention
```javascript
// Disable XML external entities
const parser = new DOMParser();
parser.parseFromString(xml, 'text/xml', {
  resolveExternals: false,
  dtdLoad: false
});
```

### 5. Access Control
```javascript
// Implement RBAC
function authorize(role, action, resource) {
  // Check permissions matrix
  return permissions[role]?.[resource]?.includes(action);
}

// Use in routes
router.get('/admin', authorize('admin', 'read', 'dashboard'), handler);
```

### 6. Security Headers
```javascript
// Express middleware
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"],
    },
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true
  }
}));
```

### 7. XSS Prevention
```javascript
// ❌ NEVER
element.innerHTML = userInput;

// ✅ ALWAYS
element.textContent = userInput;
// OR use DOMPurify
element.innerHTML = DOMPurify.sanitize(userInput);
```

### 8. Insecure Deserialization
```javascript
// Validate JSON schema
const schema = z.object({
  name: z.string(),
  age: z.number().min(0).max(150)
});

const data = schema.parse(untrustedInput);
```

### 9. Vulnerable Components
- Weekly dependency audits
- Automated security updates
- Use Dependabot/Renovate
- Check npm audit regularly

### 10. Insufficient Logging
```javascript
// Security event logging
logger.security({
  event: 'LOGIN_ATTEMPT',
  userId: user.id,
  ip: req.ip,
  userAgent: req.headers['user-agent'],
  success: false,
  reason: 'INVALID_PASSWORD'
});
```

## Environment Security

### Secrets Management
```bash
# .env.example (commit this)
DATABASE_URL=postgresql://user:pass@localhost/db
JWT_SECRET=your-secret-here
API_KEY=your-key-here

# .env (never commit)
DATABASE_URL=postgresql://prod:actualpass@prod/db
JWT_SECRET=actual-secret-key
API_KEY=actual-api-key
```

### Git Security
```gitignore
# .gitignore
.env
.env.local
*.key
*.pem
*.p12
secrets/
credentials.json
```

## API Security

### Rate Limiting
```javascript
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests
  message: 'Too many requests'
});

// Stricter for auth
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5,
  skipSuccessfulRequests: true
});
```

### Input Validation
```javascript
// Zod schema example
const userSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8).max(100),
  age: z.number().int().min(13).max(120),
  username: z.string().regex(/^[a-zA-Z0-9_-]+$/),
});

// Validate request
const validatedData = userSchema.parse(req.body);
```

### CORS Configuration
```javascript
const corsOptions = {
  origin: function (origin, callback) {
    if (allowedOrigins.indexOf(origin) !== -1 || !origin) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true,
  maxAge: 86400
};
```

## Database Security

### Query Security
```sql
-- Use parameterized queries
PREPARE stmt FROM 'SELECT * FROM users WHERE email = ?';
EXECUTE stmt USING @email;

-- Least privilege principle
CREATE USER 'app_read'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT ON mydb.* TO 'app_read'@'localhost';
```

### Connection Security
```javascript
// Use connection pooling with SSL
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: true,
    ca: fs.readFileSync('server-ca.pem')
  },
  max: 20,
  idleTimeoutMillis: 30000
});
```

## Frontend Security

### Content Security Policy
```html
<meta http-equiv="Content-Security-Policy"
      content="default-src 'self';
               script-src 'self' 'unsafe-inline';
               style-src 'self' 'unsafe-inline';
               img-src 'self' data: https:;">
```

### Secure Storage
```javascript
// ❌ NEVER store sensitive data in localStorage
localStorage.setItem('token', jwt);

// ✅ Use httpOnly cookies or sessionStorage for temp data
// Or encrypt before storing
const encrypted = CryptoJS.AES.encrypt(data, key);
sessionStorage.setItem('data', encrypted);
```

## Security Testing

### Automated Security Scans
```bash
# Dependency scanning
npm audit
snyk test

# SAST (Static Application Security Testing)
semgrep --config=auto

# Container scanning
trivy image myapp:latest

# Infrastructure scanning
tfsec .
```

### Security Checklist
- [ ] All inputs validated
- [ ] Authentication implemented correctly
- [ ] Authorization checks in place
- [ ] Sensitive data encrypted
- [ ] Security headers configured
- [ ] Rate limiting enabled
- [ ] Logging implemented
- [ ] Error messages don't leak info
- [ ] Dependencies up to date
- [ ] Security tests written

## Incident Response

### Security Event Handling
```javascript
class SecurityIncident {
  static async handle(event) {
    // 1. Log the incident
    logger.security(event);

    // 2. Alert team if critical
    if (event.severity === 'CRITICAL') {
      await alertTeam(event);
    }

    // 3. Take automatic action
    if (event.type === 'BRUTE_FORCE') {
      await blockIP(event.ip);
    }

    // 4. Store for analysis
    await incidentDB.store(event);
  }
}
```

## Compliance

### GDPR Requirements
- Right to erasure implementation
- Data portability endpoints
- Consent management
- Privacy by design

### Data Retention
- PII: Delete after 2 years inactive
- Logs: 90 days
- Backups: 30 days
- Sessions: 24 hours

---

*Security is everyone's responsibility. When in doubt, choose the more secure option.*