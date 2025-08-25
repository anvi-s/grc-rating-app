const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

console.log('Starting server...'); // ADD THIS LINE

const { Pool } = require('pg');

const app = express();

console.log('Express app created'); // ADD THIS LINE

// Database connection
const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "grc_rating_db",
  password: "2-23wpwe",
  port: 5432,
});

console.log('Database pool created'); // ADD THIS LINE

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '10mb' }));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});
app.use(limiter);

// Routes

// Get all vendors with their scores and average user ratings
app.get('/vendors', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
        v.*,
        vs.*,
        COALESCE(AVG(r.user_rating), 0) as avg_user_rating,
        COUNT(r.id) as review_count
      FROM vendors v
      LEFT JOIN vendor_scores vs ON v.id = vs.vendor_id
      LEFT JOIN reviews r ON v.id = r.vendor_id AND r.is_approved = true
      GROUP BY v.id, vs.id
      ORDER BY vs.overall_score DESC NULLS LAST
    `);

    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching vendors:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get single vendor details with reviews
app.get('/vendors/:id', async (req, res) => {
  try {
    const vendorId = parseInt(req.params.id);

    // Get vendor with scores
    const vendorResult = await pool.query(`
      SELECT
        v.*,
        vs.*,
        COALESCE(AVG(r.user_rating), 0) as avg_user_rating,
        COUNT(r.id) as review_count
      FROM vendors v
      LEFT JOIN vendor_scores vs ON v.id = vs.vendor_id
      LEFT JOIN reviews r ON v.id = r.vendor_id AND r.is_approved = true
      WHERE v.id = $1
      GROUP BY v.id, vs.id
    `, [vendorId]);

    if (vendorResult.rows.length === 0) {
      return res.status(404).json({ error: 'Vendor not found' });
    }

    // Get reviews for this vendor
    const reviewsResult = await pool.query(`
      SELECT id, reviewer_name, review_text, user_rating, created_at
      FROM reviews
      WHERE vendor_id = $1 AND is_approved = true
      ORDER BY created_at DESC
    `, [vendorId]);

    const vendor = vendorResult.rows[0];
    vendor.reviews = reviewsResult.rows;

    res.json(vendor);
  } catch (err) {
    console.error('Error fetching vendor details:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Submit a review
app.post('/reviews', async (req, res) => {
  try {
    const { vendor_id, reviewer_name, review_text, user_rating } = req.body;

    // Basic validation
    if (!vendor_id || !review_text || !user_rating) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    if (user_rating < 1 || user_rating > 5) {
      return res.status(400).json({ error: 'Rating must be between 1 and 5' });
    }

    // Input sanitization (basic)
    const sanitizedName = reviewer_name ? reviewer_name.substring(0, 255) : 'Anonymous';
    const sanitizedText = review_text.substring(0, 2000);

    const result = await pool.query(`
      INSERT INTO reviews (vendor_id, reviewer_name, review_text, user_rating, is_approved)
      VALUES ($1, $2, $3, $4, false)
      RETURNING id
    `, [vendor_id, sanitizedName, sanitizedText, user_rating]);

    res.status(201).json({
      message: 'Review submitted successfully and is pending approval',
      reviewId: result.rows[0].id
    });
  } catch (err) {
    console.error('Error submitting review:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get scoring criteria (for reference)
app.get('/criteria', (req, res) => {
  const criteria = [
    { key: 'risk_management', name: 'Risk Management', weight: 1 },
    { key: 'compliance_management', name: 'Compliance Management', weight: 1 },
    { key: 'audit_incident_management', name: 'Audit & Incident Management', weight: 1 },
    { key: 'workflow_automation', name: 'Workflow Automation', weight: 1 },
    { key: 'integration_apis', name: 'Integration & APIs', weight: 1 },
    { key: 'ease_of_use', name: 'Ease of Use / UI', weight: 1 },
    { key: 'monitoring_dashboards', name: 'Real-time Monitoring & Dashboards', weight: 1 },
    { key: 'vendor_third_party_risk', name: 'Vendor / Third-party Risk', weight: 1 },
    { key: 'pricing_value', name: 'Pricing & Value', weight: 1 },
    { key: 'scalability_support', name: 'Scalability & Support', weight: 1 }
  ];

  res.json(criteria);
});

// Get top vendors for homepage
app.get('/top-vendors', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
        v.id, v.name, v.logo_url, v.summary,
        vs.overall_score, vs.star_rating,
        COALESCE(AVG(r.user_rating), 0) as avg_user_rating,
        COUNT(r.id) as review_count
      FROM vendors v
      LEFT JOIN vendor_scores vs ON v.id = vs.vendor_id
      LEFT JOIN reviews r ON v.id = r.vendor_id AND r.is_approved = true
      GROUP BY v.id, vs.id
      ORDER BY vs.overall_score DESC NULLS LAST
      LIMIT 6
    `);

    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching top vendors:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

// Start server
app.listen(5000, () => {
  console.log("Server running on port 5000");
  console.log(`Health check: http://localhost:5000/api/health`);
});
