-- GRC Rating Application Database Schema

-- Create database (run this separately)
-- CREATE DATABASE grc_rating_db;

-- Vendors table
CREATE TABLE vendors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    logo_url VARCHAR(500),
    summary TEXT,
    pricing_estimate VARCHAR(255),
    website_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vendor scores table (for benchmark scoring)
CREATE TABLE vendor_scores (
    id SERIAL PRIMARY KEY,
    vendor_id INTEGER REFERENCES vendors(id) ON DELETE CASCADE,
    risk_management DECIMAL(3,2) CHECK (risk_management >= 0 AND risk_management <= 5),
    compliance_management DECIMAL(3,2) CHECK (compliance_management >= 0 AND compliance_management <= 5),
    audit_incident_management DECIMAL(3,2) CHECK (audit_incident_management >= 0 AND audit_incident_management <= 5),
    workflow_automation DECIMAL(3,2) CHECK (workflow_automation >= 0 AND workflow_automation <= 5),
    integration_apis DECIMAL(3,2) CHECK (integration_apis >= 0 AND integration_apis <= 5),
    ease_of_use DECIMAL(3,2) CHECK (ease_of_use >= 0 AND ease_of_use <= 5),
    monitoring_dashboards DECIMAL(3,2) CHECK (monitoring_dashboards >= 0 AND monitoring_dashboards <= 5),
    vendor_third_party_risk DECIMAL(3,2) CHECK (vendor_third_party_risk >= 0 AND vendor_third_party_risk <= 5),
    pricing_value DECIMAL(3,2) CHECK (pricing_value >= 0 AND pricing_value <= 5),
    scalability_support DECIMAL(3,2) CHECK (scalability_support >= 0 AND scalability_support <= 5),
    overall_score DECIMAL(5,2) GENERATED ALWAYS AS (
        ROUND((risk_management*1.5 + compliance_management*1.5 + audit_incident_management*1.2 +
                workflow_automation*1 + integration_apis*0.8 + ease_of_use*1 + monitoring_dashboards*0.7 +
                vendor_third_party_risk*0.7 + pricing_value*0.6 + scalability_support*1) / 10, 2)
    ) STORED,
    star_rating DECIMAL(3,1) GENERATED ALWAYS AS (
        ROUND((risk_management*1.5 + compliance_management*1.5 + audit_incident_management*1.2 +
                workflow_automation*1 + integration_apis*0.8 + ease_of_use*1 + monitoring_dashboards*0.7 +
                vendor_third_party_risk*0.7 + pricing_value*0.6 + scalability_support*1) / 10, 1)
    ) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User reviews table
CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    vendor_id INTEGER REFERENCES vendors(id) ON DELETE CASCADE,
    reviewer_name VARCHAR(255),
    review_text TEXT NOT NULL,
    user_rating DECIMAL(3,1) CHECK (user_rating >= 1 AND user_rating <= 5),
    is_approved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample vendor data
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Vanta', '/logos/vanta_security_logo.jpg', 'Automated compliance platform for SOC 2, ISO 27001, and more security frameworks', '$500-2000/month', 'https://vanta.com'),
('Drata', '/logos/drata_logo.jpg', 'Continuous compliance monitoring and security audit automation platform', '$600-2500/month', 'https://drata.com'),
('RSA Archer', '/logos/archer_integrated_risk_management_logo.jpg', 'Enterprise GRC platform for risk management and compliance operations', '$10000-50000/year', 'https://www.archerirm.com'),
('MetricStream', '/logos/metricstream_logo.jpg', 'Integrated risk management and GRC cloud platform', '$15000-75000/year', 'https://metricstream.com'),
('IBM OpenPages', '/logos/ibm_logo.jpg', 'AI-powered GRC platform for enterprise risk and compliance management', '$20000-100000/year', 'https://ibm.com/products/openpages'),
('LogicGate', '/logos/logic_gate_logo.jpg', 'Risk management and compliance automation platform', '$800-3000/month', 'https://logicgate.com'),
('ServiceNow GRC', '/logos/servicenow_logo.jpg', 'Integrated governance, risk, and compliance on the Now Platform', '$25000-150000/year', 'https://servicenow.com/products/grc.html'),
('OneTrust', '/logos/onetrust_logo.jpg', 'Privacy, data governance, and third-party risk management platform', '$1000-5000/month', 'https://onetrust.com'),
('Resolver', '/logos/resolver_inc_logo.jpg', 'Integrated risk management and digital resilience platform', '$5000-25000/year', 'https://resolver.com'),
('Allgress', '/logos/allgress_inc_logo.jpg', 'Cloud-based GRC platform for mid-market enterprises', '$2000-8000/month', 'https://allgress.com');

-- Large-scale enterprise & legacy platforms
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Workiva', '/logos/workiva_logo.jpg', 'Cloud platform specializing in financial and regulatory reporting, audit & compliance workflows', 'custom/enterprise pricing', 'https://workiva.com'),
('SAP GRC', '/logos/sap_logo.jpg', 'Integrated suite embedded in SAP ERP for access control, process control, risk & compliance', 'custom/enterprise pricing', 'https://www.sap.com/products/a-z.html'),
('Oracle Risk Management and Compliance', '/logos/oracle_logo.jpg', 'Governance, risk and compliance tools integrated with Oracle ERP and Fusion', 'custom/enterprise pricing', 'https://oracle.com'),
('AuditBoard', '/logos/auditboard_logo.jpg', 'Cloud-native platform for audit, risk, compliance, ESG and workflow automation', 'custom/Mid-Enterprise pricing', 'https://auditboard.com'),
('Riskonnect', '/logos/riskonnect_logo.jpg', 'Connected risk management platform for ERM, compliance audits, incident tracking, ESG', '$10k-50k/year', 'https://riskonnect.com'),
('LogicManager', '/logos/logicmanager_inc_logo.jpg', 'Risk-based compliance, vendor risk and incident management with strong support services', '$5k-30k/year', 'https://logicmanager.com'),
('Onspring', '/logos/onspring_technologies_logo.jpg', 'Configurable no-code GRC workflows, dashboards & reporting for audit, vendor risk, incidents', '$7k-25k/year', 'https://onspring.com'),
('ZenGRC', '/logos/riskoptics_logo.jpg', 'Simple, intuitive compliance tracking and risk management with mapped frameworks', '$10k-30k/year', 'https://zengrc.com'),
('Convercent', '/logos/onetrust_logo.jpg', 'Ethics & compliance risk platform with policy management, hotline and case handling', '$5k-20k/year', 'https://convercent.com'),
('TraceSecurity', '/logos/tracesecurity_logo.jpg', 'Cloud-based IT GRC tools for compliance, audit, risk and phishing simulation', '$3k-15k/year', 'https://tracesecurity.com'),
('Lepide', '/logos/lepide_software_pvt_ltd__logo.jpg', 'UK-based data governance and compliance platform with modules for access governance, auditing, and insider threat detection.', 'custom/mid-enterprise pricing', 'https://lepide.com');

-- Emerging/niche and SMB-focused platforms
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Apptega', '/logos/apptega_logo.jpg', 'Continuous compliance and cybersecurity risk platform with framework cross-walking and multi-tenant support', '$400-1000/month', 'https://apptega.com'),
('StandardFusion', '/logos/standardfusion_logo.jpg', 'User-friendly SaaS for audit, risk & compliance management focused on SMBs', '$500-2000/month', 'https://standardfusion.com'),
('Hyperproof', '/logos/hyperproof_logo.jpg', 'Compliance and risk management tool with automated evidence collection and audit workflows', '$600-2500/month', 'https://hyperproof.com'),
('Sprinto', '/logos/sprinto_com_logo.jpg', 'Cloud compliance automation for SOC2, GDPR, ISO that scales for startups & SMEs', '$500-1500/month', 'https://sprinto.com'),
('ControlMap', '/logos/scalepad_controlmap_logo.jpg', 'Automated compliance mapping for SOC2, ISO 27001 with Jira integration', 'from free tier to $500/month', 'https://controlmap.com'),
('Parapet', '/logos/parapetirm_logo.jpg', 'Enterprise safety, compliance, audit & health management at affordable pricing', '$3/user/month', 'https://parapet.com'),
('intelliGRC', '/logos/intelligrc_logo.jpg', 'Focused compliance tooling for CMMC and SMEs, accessible pricing', '$400/user/month (~$4800/year)', 'https://intelligrc.com'),
('CISO Assistant', '/logos/intuitem_ciso_assistant_logo.jpg', 'Community-edition and paid tool for risk frameworks coverage and risk registers', 'free-to-paid tiers', 'https://cisoassistant.io'),
('Eramba', '/logos/eramba_logo.jpg', 'Open-source and enterprise GRC platform, cost-effective with strong core functionality', 'free for on-prem + optional consulting (~$6K setup)', 'https://eramba.org'),
('Panorays', '/logos/panorays_logo.jpg', 'Automated third-party security risk management with peer benchmarking', '$5000-15000/year', 'https://panorays.com');

INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Cyber Sierra', '/logos/cybersierra_logo.jpg',
 'AI-enabled cybersecurity platform offering continuous control monitoring, third-party risk management, and GRC automation across frameworks like SOC2, ISO 27001, GDPR, HIPAA, PCI DSS, and custom controls',
 'custom enterprise pricing', 'https://cybersierra.co');

 -- 1. Scrut Automation
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Scrut Automation', '/logos/scrut_automation_logo.jpg', 'Risk-first compliance automation supporting 50+ frameworks, with powerful integrations and dashboards', 'custom/mid-enterprise pricing', 'https://scrut.io');

-- 2. Thoropass
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Thoropass', '/logos/thoropass_logo.jpg', 'AI-native audit and compliance platform that includes both automation and auditing services', 'custom/mid-enterprise pricing', 'https://thoropass.com');

-- 3. Diligent One
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Diligent One', '/logos/diligent_logo.jpg', 'Cloud-based governance, risk, audit, and compliance platform emphasizing workflow automation and analytics', 'custom/enterprise pricing', 'https://diligent.com');

-- 4. SAI360
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('SAI360', '/logos/sai360_logo.jpg', 'Comprehensive GRC and third-party risk management platform strong in monitoring third-party access', 'custom/enterprise pricing', 'https://sai360.com');

-- 5. Fusion Framework System
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Fusion Framework System', '/logos/fusion_risk_management_logo.jpg', 'Salesforce-based GRC focusing on business continuity and resilience', 'custom/enterprise pricing', 'https://fusiongci.com');

-- 6. Mitratech Alyne
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Mitratech Alyne', '/logos/alyne_logo.jpg', 'AI-driven GRC platform with rich templates and continuous compliance capabilities', 'custom/enterprise pricing', 'https://mitratech.com');

-- 7. Enablon
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Enablon', '/logos/enablon_logo.jpg', 'EHS, ESG and GRC software widely used in sustainability-focused sectors such as energy and manufacturing', 'custom/enterprise pricing', 'https://enablon.com');

-- 8. TeamMate+
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('TeamMate+', '/logos/teammateaudit_logo.jpg', 'Audit-focused GRC and internal audit platform widely adopted in EMEA by Wolters Kluwer.', 'custom/enterprise pricing', 'https://www.wolterskluwer.com/en/solutions/teammate/teammate-audit');

-- 9. Compliance Manager GRC
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Risk3Sixty fullCircle', '/logos/risk3sixty_logo.jpg', 'Emerging GRC platform praised by users for harmonizing multiple frameworks and audit automation.', 'custom/mid-enterprise pricing', 'https://risk3sixty.com/fullcircle-grc');

-- 10. Pathlock (Control-Self-Service by Pathlock)
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Pathlock (Control-Self-Service)', '/logos/pathlock_logo.jpg', 'Access governance and GRC tool focusing on audit and compliance with ERP systems', 'custom/enterprise pricing', 'https://pathlock.com');

-- 11. Secureframe (mid-level emerging)
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Secureframe', '/logos/secureframe_logo.jpg', 'Automated security and compliance platform helping with SOC 2, ISO 27001, GDPR, and vendor risk', 'custom/mid-enterprise pricing', 'https://secureframe.com');

-- 12. MEGA International
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('MEGA International', '/logos/mega_international_logo.jpg', 'French-origin HOPEX enterprise GRC suite for architecture, governance, risk and compliance across global regions.', 'custom/enterprise pricing', 'https://mega.com');

-- 13. TrustArc (Privacy-focused GRC)
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('TrustArc', '/logos/trustarc_logo.jpg', 'Privacy, governance and compliance platform focused on data protection and regulatory frameworks', 'custom/mid-enterprise pricing', 'https://trustarc.com');

-- 14. IsoMetrix (mid-market GRC)
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('IsoMetrix', '/logos/isometrix_software_logo.jpg', 'GRC, EHS and quality risk platform for SMBs with configurable dashboards and workflows', 'custom/mid-enterprise pricing', 'https://isometrix.com');

-- 15. Quantivate (mid-market)
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('Quantivate', '/logos/quantivate_logo.jpg', 'Risk, compliance, and audit management platform suited to mid-market organizations', 'custom/mid-enterprise pricing', 'https://quantivate.com');

-- 16. NAVEX Global (Ethics & compliance)
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('NAVEX Global', '/logos/navexinc_logo.jpg', 'Ethics, compliance risk and policy management platform focused on ethics & hotline management', 'custom/enterprise pricing', 'https://navexglobal.com');

-- 17. SimpleRisk (small-business friendly open platform)
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('SimpleRisk', '/logos/simplerisk_logo.jpg', 'Flexible and affordable risk-centric GRC platform for small to mid-sized organizations', 'custom/small-business pricing', 'https://simplerisk.com');

-- 18. GBTEC
INSERT INTO vendors (name, logo_url, summary, pricing_estimate, website_url) VALUES
('GBTEC', '/logos/gbtec_group_logo.jpg', 'Highly configurable and scalable GRC solution from Germany targeting governance, risk, and compliance.', 'custom/mid-enterprise pricing', 'https://www.gbtec.com');


-- Insert sample benchmark scores
INSERT INTO vendor_scores (vendor_id, risk_management, compliance_management, audit_incident_management, workflow_automation, integration_apis, ease_of_use, monitoring_dashboards, vendor_third_party_risk, pricing_value, scalability_support) VALUES
(1, 4.2, 4.8, 4.1, 4.3, 4.0, 4.6, 4.2, 3.8, 4.1, 4.0),
(2, 4.3, 4.7, 4.2, 4.4, 4.1, 4.5, 4.3, 3.9, 4.0, 4.1),
(3, 4.7, 4.5, 4.6, 4.2, 4.3, 3.8, 4.4, 4.5, 3.2, 4.6),
(4, 4.6, 4.4, 4.5, 4.1, 4.2, 3.9, 4.3, 4.4, 3.3, 4.5),
(5, 4.8, 4.6, 4.7, 4.3, 4.4, 3.7, 4.5, 4.6, 3.1, 4.7),
(6, 4.1, 4.2, 4.0, 4.4, 4.2, 4.4, 4.1, 3.7, 4.3, 4.0),
(7, 4.5, 4.3, 4.4, 4.5, 4.6, 4.0, 4.4, 4.2, 3.0, 4.6),
(8, 4.0, 4.6, 3.9, 4.1, 4.0, 4.3, 4.0, 4.7, 3.8, 4.2),
(9, 4.4, 4.1, 4.3, 4.0, 3.9, 4.1, 4.2, 4.3, 3.6, 4.3),
(10, 3.9, 4.0, 3.8, 3.9, 3.8, 4.2, 3.9, 3.6, 4.2, 3.9);

INSERT INTO vendor_scores (vendor_id, risk_management, compliance_management, audit_incident_management, workflow_automation, integration_apis, ease_of_use, monitoring_dashboards, vendor_third_party_risk, pricing_value, scalability_support) VALUES
-- Workiva
(11, 4.4, 4.7, 4.5, 4.4, 4.3, 4.2, 4.3, 4.0, 3.5, 4.3),
-- SAP GRC
(12, 4.6, 4.5, 4.4, 4.1, 4.2, 3.8, 4.2, 4.4, 3.2, 4.5),
-- Oracle Risk Management and Compliance
(13, 4.5, 4.4, 4.3, 4.0, 4.1, 3.7, 4.1, 4.3, 3.3, 4.4),
-- AuditBoard
(14, 4.2, 4.3, 4.6, 4.5, 4.4, 4.5, 4.3, 4.1, 4.1, 4.2),
-- Riskonnect
(15, 4.3, 4.2, 4.1, 4.0, 4.1, 4.0, 4.2, 4.5, 3.8, 4.3),
-- LogicManager
(16, 4.1, 4.2, 4.0, 4.2, 4.0, 4.3, 4.1, 4.2, 4.0, 4.1),
-- Onspring
(17, 4.0, 4.1, 4.0, 4.3, 4.1, 4.4, 4.0, 4.1, 4.1, 4.2),
-- ZenGRC
(18, 4.0, 4.2, 4.1, 4.2, 3.9, 4.5, 4.0, 4.3, 4.0, 4.1),
-- Convercent
(19, 3.9, 4.0, 4.2, 4.0, 3.8, 4.1, 3.9, 3.9, 4.2, 4.0),
-- TraceSecurity
(20, 4.0, 3.9, 3.8, 3.9, 3.7, 4.0, 3.8, 3.8, 4.1, 3.9),
-- Lepide
(21, 3.8, 3.9, 3.8, 3.7, 3.9, 4.0, 3.8, 3.7, 3.6, 3.8);

-- Add smaller-vendor scores
INSERT INTO vendor_scores (vendor_id, risk_management, compliance_management, audit_incident_management, workflow_automation, integration_apis, ease_of_use, monitoring_dashboards, vendor_third_party_risk, pricing_value, scalability_support) VALUES
-- Apptega
(22, 4.1, 4.3, 4.0, 4.2, 4.1, 4.2, 4.0, 4.0, 4.5, 4.0),
-- StandardFusion
(23, 3.9, 4.0, 3.8, 3.9, 3.8, 4.3, 3.8, 3.9, 4.4, 3.8),
-- Hyperproof
(24, 4.2, 4.1, 4.3, 4.2, 4.0, 4.0, 4.1, 3.9, 4.2, 3.9),
-- Sprinto
(25, 4.3, 4.4, 4.1, 4.3, 4.2, 4.1, 4.2, 3.8, 4.3, 4.0),
-- ControlMap
(26, 3.8, 4.0, 3.7, 3.9, 3.7, 4.0, 3.6, 3.9, 4.6, 3.7),
-- Parapet
(27, 3.7, 3.8, 3.5, 3.6, 3.5, 3.9, 3.5, 3.7, 4.7, 3.6),
-- intelliGRC
(28, 3.9, 3.9, 3.8, 4.0, 3.8, 4.0, 3.7, 3.8, 4.5, 3.8),
-- CISO Assistant
(29, 3.6, 3.7, 3.5, 3.8, 3.6, 4.1, 3.5, 3.6, 4.8, 3.5),
-- Eramba
(30, 3.8, 3.9, 3.7, 3.8, 3.7, 3.8, 3.6, 3.8, 4.9, 3.7),
-- Panorays
(31, 3.9, 3.8, 3.9, 3.7, 4.0, 4.0, 4.0, 4.4, 4.0, 3.9);

INSERT INTO vendor_scores (vendor_id, risk_management, compliance_management, audit_incident_management, workflow_automation, integration_apis, ease_of_use, monitoring_dashboards, vendor_third_party_risk, pricing_value, scalability_support) VALUES
-- Cyber Sierra
(32, 4.4, 4.5, 4.3, 4.4, 4.2, 4.1, 4.3, 4.5, 3.4, 4.2);

INSERT INTO vendor_scores (vendor_id, risk_management, compliance_management, audit_incident_management, workflow_automation, integration_apis, ease_of_use, monitoring_dashboards, vendor_third_party_risk, pricing_value, scalability_support) VALUES
-- 1. Scrut Automation (ID to be auto-assigned, assume sequential 33)
(33, 4.2, 4.3, 4.1, 4.2, 4.1, 4.5, 4.2, 4.0, 4.2, 4.0),

-- 2. Thoropass (34)
(34, 4.1, 4.0, 4.2, 4.1, 4.0, 4.2, 4.1, 3.8, 4.0, 3.9),

-- 3. Diligent One (35)
(35, 4.0, 4.1, 4.0, 4.0, 3.8, 3.9, 4.0, 3.9, 3.5, 3.8),

-- 4. SAI360 (36)
(36, 4.0, 3.9, 4.0, 3.8, 3.9, 3.8, 3.9, 4.1, 3.7, 3.8),

-- 5. Fusion Framework System (37)
(37, 3.9, 3.8, 3.7, 3.9, 3.6, 3.8, 3.7, 3.6, 3.6, 3.7),

-- 6. Mitratech Alyne (38)
(38, 4.1, 4.2, 4.0, 4.1, 4.0, 4.1, 4.0, 3.9, 3.8, 4.0),

-- 7. Enablon (39)
(39, 3.8, 3.9, 3.8, 3.7, 3.6, 3.7, 3.6, 3.8, 3.4, 3.7),

-- 8. TeamMate+ (40)
(40, 3.9, 4.0, 4.3, 3.8, 3.7, 3.8, 4.0, 3.6, 3.4, 3.8),

-- 9. Risk3Sixty fullCircle (41)
(41, 4.1, 4.0, 4.0, 4.1, 4.0, 4.2, 4.0, 3.9, 3.8, 4.0),

-- 10. Pathlock (Control-Self-Service) (42)
(42, 3.8, 3.7, 3.8, 3.6, 3.7, 3.8, 3.5, 3.7, 3.5, 3.6),

-- 11. Secureframe (43)
(43, 4.0, 4.1, 4.0, 4.0, 4.0, 4.2, 4.0, 3.9, 3.8, 4.0),

-- 12. MEGA International (44)
(44, 4.0, 4.1, 4.0, 3.9, 3.8, 3.7, 3.9, 3.8, 3.5, 3.9),

-- 13. TrustArc (45)
(45, 3.8, 3.9, 3.8, 3.7, 3.8, 3.7, 3.7, 3.8, 3.6, 3.7),

-- 14. IsoMetrix (46)
(46, 3.7, 3.8, 3.7, 3.7, 3.6, 3.7, 3.6, 3.7, 3.5, 3.6),

-- 15. Quantivate (47)
(47, 3.8, 3.9, 3.8, 3.8, 3.7, 3.8, 3.7, 3.8, 3.6, 3.7),

-- 16. NAVEX Global (48)
(48, 3.9, 4.0, 4.0, 3.9, 3.8, 3.9, 3.8, 3.9, 3.7, 3.8),

-- 17. SimpleRisk (49)
(49, 3.6, 3.7, 3.6, 3.6, 3.6, 3.7, 3.5, 3.6, 3.8, 3.5),

-- 18. GBTEC (50)
(50, 3.8, 3.9, 3.7, 3.8, 3.6, 3.7, 3.8, 3.6, 3.5, 3.7);


-- Insert sample reviews
INSERT INTO reviews (vendor_id, reviewer_name, review_text, user_rating, is_approved) VALUES
(1, 'Sarah Chen', 'Vanta made our SOC 2 compliance process incredibly smooth. The automated evidence collection saved us weeks of work.', 4.5, true),
(1, 'Mike Rodriguez', 'Great platform but can be pricey for smaller companies. The integrations work well with our existing tools.', 4.0, true),
(2, 'Emily Johnson', 'Drata''s continuous monitoring is fantastic. The dashboard gives us real-time visibility into our compliance posture.', 4.8, true),
(3, 'David Park', 'RSA Archer is powerful but has a steep learning curve. Once configured properly, it handles complex risk scenarios well.', 3.8, true),
(4, 'Lisa Thompson', 'MetricStream offers comprehensive GRC capabilities. The reporting features are particularly strong for enterprise needs.', 4.2, true),
(5, 'James Wilson', 'IBM OpenPages integrates well with other IBM products. The AI features are helpful for risk prediction and analysis.', 4.1, true);

-- Create indexes for better performance
CREATE INDEX idx_vendor_scores_vendor_id ON vendor_scores(vendor_id);
CREATE INDEX idx_reviews_vendor_id ON reviews(vendor_id);
CREATE INDEX idx_reviews_approved ON reviews(is_approved);
CREATE INDEX idx_vendor_scores_overall_score ON vendor_scores(overall_score DESC);

-- psql -d grc_rating_db -U postgres -f C:\Users\anvir\PycharmProjects\grc-rating-app2\server\database.sql
